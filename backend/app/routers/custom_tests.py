import json
from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
import asyncpg

from app.dependencies import get_db, get_current_user_id, require_manager

router = APIRouter(prefix="/tests", tags=["custom_tests"])


# ── Modelos ────────────────────────────────────────────────────────────────────

class TestCreate(BaseModel):
    title: str
    description: Optional[str] = None
    instructions: Optional[str] = None
    scoring_mode: str = "auto"
    is_public: bool = True
    max_attempts: Optional[int] = None
    time_limit_min: Optional[int] = None
    pass_score: Optional[float] = None


class TestUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    instructions: Optional[str] = None
    scoring_mode: Optional[str] = None
    is_public: Optional[bool] = None
    max_attempts: Optional[int] = None
    time_limit_min: Optional[int] = None
    pass_score: Optional[float] = None


class QuestionCreate(BaseModel):
    question_type: str
    text: str
    explanation: Optional[str] = None
    is_required: bool = True
    points: float = 1.0
    scale_min: Optional[int] = None
    scale_max: Optional[int] = None
    scale_labels: Optional[dict] = None


class QuestionUpdate(BaseModel):
    text: Optional[str] = None
    explanation: Optional[str] = None
    is_required: Optional[bool] = None
    points: Optional[float] = None
    scale_min: Optional[int] = None
    scale_max: Optional[int] = None
    scale_labels: Optional[dict] = None


class OptionCreate(BaseModel):
    text: str
    is_correct: bool = False
    point_value: float = 0.0
    order_index: int = 0


class OptionUpdate(BaseModel):
    text: Optional[str] = None
    is_correct: Optional[bool] = None
    point_value: Optional[float] = None
    order_index: Optional[int] = None


class AssignmentCreate(BaseModel):
    user_id: Optional[str] = None
    department_id: Optional[str] = None


class ReorderRequest(BaseModel):
    question_ids: List[str]


class ResponseItem(BaseModel):
    question_id: str
    selected_option_ids: Optional[List[str]] = None
    text_response: Optional[str] = None
    scale_value: Optional[int] = None
    boolean_response: Optional[bool] = None


class AttemptRespond(BaseModel):
    responses: List[ResponseItem]


class QuestionScore(BaseModel):
    question_id: str
    manual_points: float
    hr_comment: Optional[str] = None


class EvaluateAttempt(BaseModel):
    manual_score: Optional[float] = None
    hr_feedback: Optional[str] = None
    question_scores: Optional[List[QuestionScore]] = None


# ── Helpers ────────────────────────────────────────────────────────────────────

def _score_response(question: dict, options: list, response: dict) -> float:
    qtype = question["question_type"]

    if qtype == "open_text":
        return 0.0

    if qtype in ("single_choice", "true_false"):
        selected = sorted(str(s) for s in (response.get("selected_option_ids") or []))
        correct = sorted(str(o["id"]) for o in options if o["is_correct"])
        return float(question["points"]) if selected == correct else 0.0

    if qtype == "multiple_choice":
        selected = {str(s) for s in (response.get("selected_option_ids") or [])}
        correct = {str(o["id"]) for o in options if o["is_correct"]}
        return float(question["points"]) if selected == correct else 0.0

    if qtype == "checklist":
        selected = {str(s) for s in (response.get("selected_option_ids") or [])}
        correct_opts = [o for o in options if o["is_correct"]]
        wrong_opts = [o for o in options if not o["is_correct"]]
        n_correct = max(len(correct_opts), 1)
        per_item = float(question["points"]) / n_correct
        earned = sum(per_item for o in correct_opts if str(o["id"]) in selected)
        penalty = sum(per_item for o in wrong_opts if str(o["id"]) in selected)
        return max(0.0, earned - penalty)

    if qtype == "scale":
        scale_val = response.get("scale_value")
        matched = next((o for o in options if o["order_index"] == scale_val), None)
        return float(matched["point_value"]) if matched else 0.0

    return 0.0


async def _notify(conn: asyncpg.Connection, user_id: str, ntype: str, title: str, message: str):
    try:
        await conn.execute(
            "INSERT INTO public.notifications (user_id, type, title, message) VALUES ($1, $2, $3, $4)",
            user_id, ntype, title, message,
        )
    except Exception:
        pass


async def _recalc_total_points(conn: asyncpg.Connection, test_id: str):
    await conn.execute(
        """UPDATE public.custom_tests
           SET total_points = (
             SELECT COALESCE(SUM(points), 0) FROM public.test_questions WHERE test_id = $1
           ), updated_at = now()
           WHERE id = $1""",
        test_id,
    )


async def _get_test_or_404(conn: asyncpg.Connection, test_id: str) -> dict:
    row = await conn.fetchrow("SELECT * FROM public.custom_tests WHERE id = $1", test_id)
    if not row:
        raise HTTPException(status_code=404, detail="Teste não encontrado")
    return dict(row)


async def _require_manager_company(conn: asyncpg.Connection, user_id: str) -> str:
    await require_manager(user_id, conn)
    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile or not profile["company_id"]:
        raise HTTPException(status_code=400, detail="Perfil sem empresa associada")
    return str(profile["company_id"])


async def _build_test_detail(conn: asyncpg.Connection, test_id: str) -> dict:
    test = await _get_test_or_404(conn, test_id)
    questions = await conn.fetch(
        "SELECT * FROM public.test_questions WHERE test_id = $1 ORDER BY order_index",
        test_id,
    )
    result = dict(test)
    result["questions"] = []
    for q in questions:
        qd = dict(q)
        options = await conn.fetch(
            "SELECT * FROM public.test_question_options WHERE question_id = $1 ORDER BY order_index",
            q["id"],
        )
        qd["options"] = [dict(o) for o in options]
        result["questions"].append(qd)
    return result


# ── Rotas estáticas (devem vir antes de /{test_id}) ───────────────────────────

@router.get("/available")
async def get_available_tests(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await conn.fetchrow(
        "SELECT company_id, department_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile:
        return []

    company_id = str(profile["company_id"]) if profile["company_id"] else None
    dept_id = str(profile["department_id"]) if profile["department_id"] else None

    rows = await conn.fetch(
        """
        SELECT DISTINCT t.*,
          COALESCE(att.cnt, 0) AS attempt_count
        FROM public.custom_tests t
        LEFT JOIN public.test_assignments ta ON ta.test_id = t.id
          AND (ta.user_id = $1 OR ta.department_id = $2)
        LEFT JOIN (
          SELECT test_id, COUNT(*) AS cnt
          FROM public.test_attempts
          WHERE user_id = $1
          GROUP BY test_id
        ) att ON att.test_id = t.id
        WHERE t.company_id = $3
          AND t.status = 'published'
          AND (t.is_public = true OR ta.id IS NOT NULL)
          AND (t.max_attempts IS NULL OR COALESCE(att.cnt, 0) < t.max_attempts)
        ORDER BY t.created_at DESC
        """,
        user_id, dept_id, company_id,
    )
    return [dict(r) for r in rows]


@router.get("/my-attempts")
async def get_my_attempts(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        """
        SELECT a.*, t.title AS test_title, t.scoring_mode, t.pass_score
        FROM public.test_attempts a
        JOIN public.custom_tests t ON t.id = a.test_id
        WHERE a.user_id = $1
        ORDER BY a.started_at DESC
        """,
        user_id,
    )
    return [dict(r) for r in rows]


@router.get("/my-attempts/{attempt_id}")
async def get_my_attempt_detail(
    attempt_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    attempt = await conn.fetchrow(
        """
        SELECT a.*, t.title AS test_title, t.scoring_mode, t.pass_score
        FROM public.test_attempts a
        JOIN public.custom_tests t ON t.id = a.test_id
        WHERE a.id = $1 AND a.user_id = $2
        """,
        attempt_id, user_id,
    )
    if not attempt:
        raise HTTPException(status_code=404, detail="Tentativa não encontrada")

    attempt_dict = dict(attempt)

    # Carrega respostas com perguntas (sem revelar gabarito se não avaliado)
    responses = await conn.fetch(
        """
        SELECT r.*, q.text AS question_text, q.question_type, q.points, q.explanation,
               q.scale_min, q.scale_max, q.scale_labels, q.order_index
        FROM public.test_responses r
        JOIN public.test_questions q ON q.id = r.question_id
        WHERE r.attempt_id = $1
        ORDER BY q.order_index
        """,
        attempt_id,
    )

    show_answers = attempt_dict["status"] == "evaluated"
    responses_list = []
    for resp in responses:
        rd = dict(resp)
        if show_answers:
            opts = await conn.fetch(
                "SELECT * FROM public.test_question_options WHERE question_id = $1 ORDER BY order_index",
                resp["question_id"],
            )
            rd["options"] = [dict(o) for o in opts]
        responses_list.append(rd)

    attempt_dict["responses"] = responses_list
    return attempt_dict


@router.get("/attempts/{attempt_id}")
async def get_attempt_detail(
    attempt_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    attempt = await conn.fetchrow(
        """
        SELECT a.*, t.title AS test_title, t.scoring_mode, t.pass_score, t.total_points,
               p.name AS collaborator_name
        FROM public.test_attempts a
        JOIN public.custom_tests t ON t.id = a.test_id
        LEFT JOIN public.profiles p ON p.user_id = a.user_id
        WHERE a.id = $1
        """,
        attempt_id,
    )
    if not attempt:
        raise HTTPException(status_code=404, detail="Tentativa não encontrada")

    attempt_dict = dict(attempt)
    responses = await conn.fetch(
        """
        SELECT r.*, q.text AS question_text, q.question_type, q.points, q.order_index
        FROM public.test_responses r
        JOIN public.test_questions q ON q.id = r.question_id
        WHERE r.attempt_id = $1
        ORDER BY q.order_index
        """,
        attempt_id,
    )

    responses_list = []
    for resp in responses:
        rd = dict(resp)
        opts = await conn.fetch(
            "SELECT * FROM public.test_question_options WHERE question_id = $1 ORDER BY order_index",
            resp["question_id"],
        )
        rd["options"] = [dict(o) for o in opts]
        responses_list.append(rd)

    attempt_dict["responses"] = responses_list
    return attempt_dict


@router.post("/attempts/{attempt_id}/evaluate")
async def evaluate_attempt(
    attempt_id: str,
    body: EvaluateAttempt,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    attempt = await conn.fetchrow(
        "SELECT * FROM public.test_attempts WHERE id = $1", attempt_id
    )
    if not attempt:
        raise HTTPException(status_code=404, detail="Tentativa não encontrada")
    if attempt["status"] not in ("submitted", "evaluated"):
        raise HTTPException(status_code=400, detail="Tentativa não está submetida")

    auto_score = float(attempt["auto_score"] or 0)

    if body.question_scores:
        for qs in body.question_scores:
            await conn.execute(
                """UPDATE public.test_responses
                   SET manual_points = $1, hr_comment = $2
                   WHERE attempt_id = $3 AND question_id = $4""",
                qs.manual_points, qs.hr_comment, attempt_id, qs.question_id,
            )
        extra = sum(float(qs.manual_points) for qs in body.question_scores)
        final_score = auto_score + extra
    elif body.manual_score is not None:
        final_score = float(body.manual_score)
    else:
        final_score = auto_score

    test = await conn.fetchrow(
        "SELECT pass_score FROM public.custom_tests WHERE id = $1", str(attempt["test_id"])
    )
    pass_score = test["pass_score"] if test else None
    passed = (final_score >= float(pass_score)) if pass_score is not None else None

    row = await conn.fetchrow(
        """UPDATE public.test_attempts
           SET manual_score = $1, final_score = $2, passed = $3,
               hr_feedback = $4, evaluated_at = now(), evaluated_by = $5, status = 'evaluated'
           WHERE id = $6 RETURNING *""",
        body.manual_score, final_score, passed, body.hr_feedback, user_id, attempt_id,
    )

    test_row = await conn.fetchrow(
        "SELECT title FROM public.custom_tests WHERE id = $1", str(attempt["test_id"])
    )
    title = test_row["title"] if test_row else "teste"
    await _notify(
        conn, str(attempt["user_id"]), "test_evaluated",
        "Resultado disponível",
        f"Seu resultado em \"{title}\" está disponível.",
    )

    return dict(row)


@router.post("/attempts/{attempt_id}/respond")
async def save_responses(
    attempt_id: str,
    body: AttemptRespond,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    attempt = await conn.fetchrow(
        "SELECT * FROM public.test_attempts WHERE id = $1 AND user_id = $2",
        attempt_id, user_id,
    )
    if not attempt:
        raise HTTPException(status_code=404, detail="Tentativa não encontrada")
    if attempt["status"] != "in_progress":
        raise HTTPException(status_code=400, detail="Tentativa já finalizada")

    for resp in body.responses:
        existing = await conn.fetchrow(
            "SELECT id FROM public.test_responses WHERE attempt_id = $1 AND question_id = $2",
            attempt_id, resp.question_id,
        )
        if existing:
            await conn.execute(
                """UPDATE public.test_responses
                   SET selected_option_ids = $1, text_response = $2,
                       scale_value = $3, boolean_response = $4
                   WHERE attempt_id = $5 AND question_id = $6""",
                resp.selected_option_ids, resp.text_response,
                resp.scale_value, resp.boolean_response,
                attempt_id, resp.question_id,
            )
        else:
            await conn.execute(
                """INSERT INTO public.test_responses
                   (attempt_id, question_id, selected_option_ids, text_response, scale_value, boolean_response)
                   VALUES ($1, $2, $3, $4, $5, $6)""",
                attempt_id, resp.question_id, resp.selected_option_ids,
                resp.text_response, resp.scale_value, resp.boolean_response,
            )

    return {"saved": len(body.responses)}


@router.post("/attempts/{attempt_id}/submit")
async def submit_attempt(
    attempt_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    attempt = await conn.fetchrow(
        "SELECT * FROM public.test_attempts WHERE id = $1 AND user_id = $2",
        attempt_id, user_id,
    )
    if not attempt:
        raise HTTPException(status_code=404, detail="Tentativa não encontrada")
    if attempt["status"] != "in_progress":
        raise HTTPException(status_code=400, detail="Tentativa já finalizada")

    test = await conn.fetchrow(
        "SELECT * FROM public.custom_tests WHERE id = $1", str(attempt["test_id"])
    )
    questions = await conn.fetch(
        "SELECT * FROM public.test_questions WHERE test_id = $1", str(attempt["test_id"])
    )
    responses = await conn.fetch(
        "SELECT * FROM public.test_responses WHERE attempt_id = $1", attempt_id
    )
    response_map = {str(r["question_id"]): dict(r) for r in responses}

    auto_score = 0.0
    has_open = False
    for q in questions:
        qd = dict(q)
        resp = response_map.get(str(q["id"]), {})
        options = await conn.fetch(
            "SELECT * FROM public.test_question_options WHERE question_id = $1", q["id"]
        )
        pts = _score_response(qd, [dict(o) for o in options], resp)
        auto_score += pts
        if q["question_type"] == "open_text":
            has_open = True
        if resp.get("id"):
            await conn.execute(
                "UPDATE public.test_responses SET auto_points = $1 WHERE id = $2",
                pts, resp["id"],
            )

    scoring_mode = test["scoring_mode"]
    pass_score = test["pass_score"]

    if scoring_mode == "auto" or (scoring_mode == "mixed" and not has_open):
        final_score = auto_score
        passed = (final_score >= float(pass_score)) if pass_score is not None else None
        new_status = "evaluated"
    else:
        final_score = None
        passed = None
        new_status = "submitted"

    row = await conn.fetchrow(
        """UPDATE public.test_attempts
           SET auto_score = $1, final_score = $2, passed = $3,
               submitted_at = now(), status = $4
           WHERE id = $5 RETURNING *""",
        auto_score, final_score, passed, new_status, attempt_id,
    )

    if new_status == "submitted":
        managers = await conn.fetch(
            """SELECT DISTINCT ur.user_id FROM public.user_roles ur
               JOIN public.profiles p ON p.user_id = ur.user_id
               WHERE ur.role IN ('manager', 'master_admin')
                 AND p.company_id = $1""",
            test["company_id"],
        )
        for mgr in managers:
            await _notify(
                conn, str(mgr["user_id"]), "test_pending_evaluation",
                "Nova tentativa aguarda avaliação",
                f'Nova tentativa aguarda avaliação: "{test["title"]}".',
            )

    return dict(row)


# ── Gestão de testes ───────────────────────────────────────────────────────────

@router.get("")
async def list_tests(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _require_manager_company(conn, user_id)
    rows = await conn.fetch(
        """
        SELECT t.*,
          (SELECT COUNT(*) FROM public.test_questions WHERE test_id = t.id) AS question_count,
          (SELECT COUNT(*) FROM public.test_attempts WHERE test_id = t.id) AS attempt_count
        FROM public.custom_tests t
        WHERE t.company_id = $1
        ORDER BY t.created_at DESC
        """,
        company_id,
    )
    return [dict(r) for r in rows]


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_test(
    body: TestCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _require_manager_company(conn, user_id)
    row = await conn.fetchrow(
        """INSERT INTO public.custom_tests
           (company_id, created_by, title, description, instructions,
            scoring_mode, is_public, max_attempts, time_limit_min, pass_score)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
           RETURNING *""",
        company_id, user_id, body.title, body.description, body.instructions,
        body.scoring_mode, body.is_public, body.max_attempts, body.time_limit_min, body.pass_score,
    )
    return dict(row)


@router.get("/{test_id}")
async def get_test(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    return await _build_test_detail(conn, test_id)


@router.put("/{test_id}")
async def update_test(
    test_id: str,
    body: TestUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")

    # exclude_unset=True: inclui campos explicitamente enviados, mesmo que null
    fields = body.model_dump(exclude_unset=True)
    if not fields:
        return test

    cols = list(fields.keys())
    set_parts = [f"{k} = ${i + 2}" for i, k in enumerate(cols)]
    set_parts.append("updated_at = now()")
    set_clause = ", ".join(set_parts)

    row = await conn.fetchrow(
        f"UPDATE public.custom_tests SET {set_clause} WHERE id = $1 RETURNING *",
        test_id, *[fields[k] for k in cols],
    )
    return dict(row)


@router.delete("/{test_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_test(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser excluídos")
    await conn.execute("DELETE FROM public.custom_tests WHERE id = $1", test_id)


@router.post("/{test_id}/publish")
async def publish_test(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Teste não está em rascunho")

    count = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_questions WHERE test_id = $1", test_id
    )
    if count == 0:
        raise HTTPException(status_code=400, detail="Adicione ao menos uma pergunta antes de publicar")

    row = await conn.fetchrow(
        "UPDATE public.custom_tests SET status = 'published', updated_at = now() WHERE id = $1 RETURNING *",
        test_id,
    )
    return dict(row)


@router.post("/{test_id}/archive")
async def archive_test(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "published":
        raise HTTPException(status_code=400, detail="Teste não está publicado")
    row = await conn.fetchrow(
        "UPDATE public.custom_tests SET status = 'archived', updated_at = now() WHERE id = $1 RETURNING *",
        test_id,
    )
    return dict(row)


@router.post("/{test_id}/duplicate", status_code=status.HTTP_201_CREATED)
async def duplicate_test(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _require_manager_company(conn, user_id)
    original = await _get_test_or_404(conn, test_id)

    new_test = await conn.fetchrow(
        """INSERT INTO public.custom_tests
           (company_id, created_by, title, description, instructions,
            scoring_mode, is_public, max_attempts, time_limit_min, pass_score)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
           RETURNING *""",
        company_id, user_id,
        f"[Cópia] {original['title']}", original["description"], original["instructions"],
        original["scoring_mode"], original["is_public"], original["max_attempts"],
        original["time_limit_min"], original["pass_score"],
    )
    new_test_id = str(new_test["id"])

    questions = await conn.fetch(
        "SELECT * FROM public.test_questions WHERE test_id = $1 ORDER BY order_index", test_id
    )
    for q in questions:
        new_q = await conn.fetchrow(
            """INSERT INTO public.test_questions
               (test_id, order_index, question_type, text, explanation,
                is_required, points, scale_min, scale_max, scale_labels)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
               RETURNING id""",
            new_test_id, q["order_index"], q["question_type"], q["text"], q["explanation"],
            q["is_required"], q["points"], q["scale_min"], q["scale_max"], q["scale_labels"],
        )
        options = await conn.fetch(
            "SELECT * FROM public.test_question_options WHERE question_id = $1 ORDER BY order_index",
            q["id"],
        )
        for opt in options:
            await conn.execute(
                """INSERT INTO public.test_question_options
                   (question_id, order_index, text, is_correct, point_value)
                   VALUES ($1, $2, $3, $4, $5)""",
                str(new_q["id"]), opt["order_index"], opt["text"], opt["is_correct"], opt["point_value"],
            )

    await _recalc_total_points(conn, new_test_id)
    return dict(new_test)


# ── Perguntas ──────────────────────────────────────────────────────────────────

@router.post("/{test_id}/questions", status_code=status.HTTP_201_CREATED)
async def add_question(
    test_id: str,
    body: QuestionCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")

    max_order = await conn.fetchval(
        "SELECT COALESCE(MAX(order_index), -1) FROM public.test_questions WHERE test_id = $1", test_id
    )
    scale_labels_json = json.dumps(body.scale_labels) if body.scale_labels else None
    row = await conn.fetchrow(
        """INSERT INTO public.test_questions
           (test_id, order_index, question_type, text, explanation,
            is_required, points, scale_min, scale_max, scale_labels)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
           RETURNING *""",
        test_id, max_order + 1, body.question_type, body.text, body.explanation,
        body.is_required, body.points, body.scale_min, body.scale_max, scale_labels_json,
    )
    await _recalc_total_points(conn, test_id)
    result = dict(row)
    result["options"] = []
    return result


@router.put("/{test_id}/questions/reorder")
async def reorder_questions(
    test_id: str,
    body: ReorderRequest,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")
    for idx, qid in enumerate(body.question_ids):
        await conn.execute(
            "UPDATE public.test_questions SET order_index = $1 WHERE id = $2 AND test_id = $3",
            idx, qid, test_id,
        )
    return {"reordered": len(body.question_ids)}


@router.put("/questions/{question_id}")
async def update_question(
    question_id: str,
    body: QuestionUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    q = await conn.fetchrow("SELECT * FROM public.test_questions WHERE id = $1", question_id)
    if not q:
        raise HTTPException(status_code=404, detail="Pergunta não encontrada")

    test = await _get_test_or_404(conn, str(q["test_id"]))
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")

    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        return dict(q)

    if "scale_labels" in fields and isinstance(fields["scale_labels"], dict):
        fields["scale_labels"] = json.dumps(fields["scale_labels"])

    cols = list(fields.keys())
    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(cols))
    row = await conn.fetchrow(
        f"UPDATE public.test_questions SET {set_clause} WHERE id = $1 RETURNING *",
        question_id, *[fields[k] for k in cols],
    )
    await _recalc_total_points(conn, str(q["test_id"]))
    return dict(row)


@router.delete("/questions/{question_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_question(
    question_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    q = await conn.fetchrow("SELECT * FROM public.test_questions WHERE id = $1", question_id)
    if not q:
        raise HTTPException(status_code=404, detail="Pergunta não encontrada")

    test = await _get_test_or_404(conn, str(q["test_id"]))
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")

    await conn.execute("DELETE FROM public.test_questions WHERE id = $1", question_id)
    await _recalc_total_points(conn, str(q["test_id"]))


# ── Opções ─────────────────────────────────────────────────────────────────────

@router.post("/questions/{question_id}/options", status_code=status.HTTP_201_CREATED)
async def add_option(
    question_id: str,
    body: OptionCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    q = await conn.fetchrow("SELECT test_id FROM public.test_questions WHERE id = $1", question_id)
    if not q:
        raise HTTPException(status_code=404, detail="Pergunta não encontrada")
    test = await _get_test_or_404(conn, str(q["test_id"]))
    if test["status"] != "draft":
        raise HTTPException(status_code=400, detail="Apenas testes em rascunho podem ser editados")
    row = await conn.fetchrow(
        """INSERT INTO public.test_question_options
           (question_id, order_index, text, is_correct, point_value)
           VALUES ($1, $2, $3, $4, $5) RETURNING *""",
        question_id, body.order_index, body.text, body.is_correct, body.point_value,
    )
    return dict(row)


@router.put("/options/{option_id}")
async def update_option(
    option_id: str,
    body: OptionUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        row = await conn.fetchrow("SELECT * FROM public.test_question_options WHERE id = $1", option_id)
        return dict(row) if row else {}
    cols = list(fields.keys())
    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(cols))
    row = await conn.fetchrow(
        f"UPDATE public.test_question_options SET {set_clause} WHERE id = $1 RETURNING *",
        option_id, *[fields[k] for k in cols],
    )
    if not row:
        raise HTTPException(status_code=404, detail="Opção não encontrada")
    return dict(row)


@router.delete("/options/{option_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_option(
    option_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    result = await conn.execute("DELETE FROM public.test_question_options WHERE id = $1", option_id)
    if result == "DELETE 0":
        raise HTTPException(status_code=404, detail="Opção não encontrada")


# ── Atribuições ────────────────────────────────────────────────────────────────

@router.get("/{test_id}/assignments")
async def list_assignments(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    rows = await conn.fetch(
        """
        SELECT ta.*, p.name AS user_name, d.name AS department_name
        FROM public.test_assignments ta
        LEFT JOIN public.profiles p ON p.user_id = ta.user_id
        LEFT JOIN public.departments d ON d.id = ta.department_id
        WHERE ta.test_id = $1
        """,
        test_id,
    )
    return [dict(r) for r in rows]


@router.post("/{test_id}/assignments", status_code=status.HTTP_201_CREATED)
async def create_assignment(
    test_id: str,
    body: AssignmentCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    if not body.user_id and not body.department_id:
        raise HTTPException(status_code=400, detail="Informe user_id ou department_id")
    row = await conn.fetchrow(
        "INSERT INTO public.test_assignments (test_id, user_id, department_id) VALUES ($1, $2, $3) RETURNING *",
        test_id, body.user_id, body.department_id,
    )
    return dict(row)


@router.delete("/{test_id}/assignments/{assignment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_assignment(
    test_id: str,
    assignment_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    result = await conn.execute(
        "DELETE FROM public.test_assignments WHERE id = $1 AND test_id = $2",
        assignment_id, test_id,
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=404, detail="Atribuição não encontrada")


# ── Tentativas (visão do RH) ───────────────────────────────────────────────────

@router.get("/{test_id}/attempts")
async def list_attempts(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    rows = await conn.fetch(
        """
        SELECT a.*, p.name AS collaborator_name
        FROM public.test_attempts a
        LEFT JOIN public.profiles p ON p.user_id = a.user_id
        WHERE a.test_id = $1
        ORDER BY a.started_at DESC
        """,
        test_id,
    )
    return [dict(r) for r in rows]


@router.get("/{test_id}/stats")
async def get_test_stats(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    await _get_test_or_404(conn, test_id)

    total = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1", test_id
    )
    submitted = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1 AND status = 'submitted'", test_id
    )
    evaluated = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1 AND status = 'evaluated'", test_id
    )
    in_progress = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1 AND status = 'in_progress'", test_id
    )
    approved = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1 AND passed = true", test_id
    )
    score_stats = await conn.fetchrow(
        """SELECT AVG(final_score) AS avg_score, MIN(final_score) AS min_score,
                  MAX(final_score) AS max_score
           FROM public.test_attempts WHERE test_id = $1 AND status = 'evaluated'""",
        test_id,
    )

    return {
        "total_attempts": total,
        "in_progress": in_progress,
        "submitted": submitted,
        "evaluated": evaluated,
        "approved": approved,
        "avg_score": float(score_stats["avg_score"]) if score_stats["avg_score"] else None,
        "min_score": float(score_stats["min_score"]) if score_stats["min_score"] else None,
        "max_score": float(score_stats["max_score"]) if score_stats["max_score"] else None,
    }


# ── Iniciar tentativa ──────────────────────────────────────────────────────────

@router.post("/{test_id}/start", status_code=status.HTTP_201_CREATED)
async def start_attempt(
    test_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    test = await _get_test_or_404(conn, test_id)
    if test["status"] != "published":
        raise HTTPException(status_code=400, detail="Teste não está disponível")

    in_progress = await conn.fetchrow(
        "SELECT id FROM public.test_attempts WHERE test_id = $1 AND user_id = $2 AND status = 'in_progress'",
        test_id, user_id,
    )
    if in_progress:
        return dict(await conn.fetchrow(
            "SELECT * FROM public.test_attempts WHERE id = $1", str(in_progress["id"])
        ))

    attempt_count = await conn.fetchval(
        "SELECT COUNT(*) FROM public.test_attempts WHERE test_id = $1 AND user_id = $2",
        test_id, user_id,
    )
    if test["max_attempts"] and attempt_count >= test["max_attempts"]:
        raise HTTPException(status_code=400, detail="Limite de tentativas atingido")

    row = await conn.fetchrow(
        """INSERT INTO public.test_attempts (test_id, user_id, attempt_number)
           VALUES ($1, $2, $3) RETURNING *""",
        test_id, user_id, attempt_count + 1,
    )
    return dict(row)
