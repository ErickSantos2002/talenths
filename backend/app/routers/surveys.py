from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone
import asyncpg
import json

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/surveys", tags=["surveys"])


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _require_manager(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=403, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")
    return str(row["company_id"])


def _ser_question(q) -> dict:
    options = q["options"]
    if isinstance(options, str):
        try:
            options = json.loads(options)
        except Exception:
            options = None
    return {
        "id": str(q["id"]),
        "survey_id": str(q["survey_id"]),
        "text": q["text"],
        "type": q["type"],
        "options": options,
        "position": q["position"],
    }


def _ser_survey(s, questions: list, response_count: int = 0, user_responded: bool = False) -> dict:
    return {
        "id": str(s["id"]),
        "title": s["title"],
        "description": s["description"],
        "anonymous": s["anonymous"],
        "status": s["status"],
        "starts_at": s["starts_at"].isoformat() if s["starts_at"] else None,
        "ends_at": s["ends_at"].isoformat() if s["ends_at"] else None,
        "created_at": s["created_at"].isoformat() if s["created_at"] else None,
        "questions": [_ser_question(q) for q in questions],
        "response_count": response_count,
        "user_responded": user_responded,
    }


# ── Surveys CRUD ──────────────────────────────────────────────────────────────

@router.get("")
async def list_surveys(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    is_manager = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )

    if is_manager:
        surveys = await conn.fetch(
            "SELECT * FROM engagement_surveys WHERE company_id = $1 ORDER BY created_at DESC",
            company_id,
        )
    else:
        surveys = await conn.fetch(
            "SELECT * FROM engagement_surveys WHERE company_id = $1 AND status = 'active' ORDER BY starts_at DESC",
            company_id,
        )

    result = []
    for s in surveys:
        questions = await conn.fetch(
            "SELECT * FROM survey_questions WHERE survey_id = $1 ORDER BY position", s["id"]
        )
        response_count = await conn.fetchval(
            "SELECT COUNT(*) FROM survey_responses WHERE survey_id = $1", s["id"]
        )
        user_responded = bool(await conn.fetchrow(
            "SELECT id FROM survey_responses WHERE survey_id = $1 AND user_id = $2",
            s["id"], user_id,
        ))
        result.append(_ser_survey(s, list(questions), response_count, user_responded))
    return result


@router.post("", status_code=201)
async def create_survey(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    from datetime import date as date_type
    starts_at = date_type.fromisoformat(body["starts_at"]) if body.get("starts_at") else None
    ends_at = date_type.fromisoformat(body["ends_at"]) if body.get("ends_at") else None

    s = await conn.fetchrow(
        """INSERT INTO engagement_surveys
               (company_id, title, description, anonymous, status, starts_at, ends_at, created_by)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *""",
        company_id, body["title"], body.get("description"),
        body.get("anonymous", True), body.get("status", "draft"),
        starts_at, ends_at, user_id,
    )
    questions = []
    for i, q in enumerate(body.get("questions", [])):
        row = await conn.fetchrow(
            """INSERT INTO survey_questions (survey_id, text, type, options, position)
               VALUES ($1, $2, $3, $4, $5) RETURNING *""",
            str(s["id"]), q["text"], q.get("type", "scale"),
            json.dumps(q["options"]) if q.get("options") else None, i,
        )
        questions.append(row)
    return _ser_survey(s, questions)


@router.put("/{survey_id}")
async def update_survey(
    survey_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    from datetime import date as date_type
    starts_at = date_type.fromisoformat(body["starts_at"]) if body.get("starts_at") else None
    ends_at = date_type.fromisoformat(body["ends_at"]) if body.get("ends_at") else None

    s = await conn.fetchrow(
        """UPDATE engagement_surveys
           SET title = $1, description = $2, anonymous = $3, status = $4, starts_at = $5, ends_at = $6
           WHERE id = $7 AND company_id = $8 RETURNING *""",
        body["title"], body.get("description"), body.get("anonymous", True),
        body.get("status", "draft"), starts_at, ends_at, survey_id, company_id,
    )
    if not s:
        raise HTTPException(404, "Pesquisa não encontrada")
    questions = await conn.fetch(
        "SELECT * FROM survey_questions WHERE survey_id = $1 ORDER BY position", survey_id
    )
    count = await conn.fetchval("SELECT COUNT(*) FROM survey_responses WHERE survey_id = $1", survey_id)
    return _ser_survey(s, list(questions), count)


@router.delete("/{survey_id}", status_code=204)
async def delete_survey(
    survey_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM engagement_surveys WHERE id = $1 AND company_id = $2", survey_id, company_id
    )


# ── Questions ─────────────────────────────────────────────────────────────────

@router.post("/{survey_id}/questions", status_code=201)
async def add_question(
    survey_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    count = await conn.fetchval(
        "SELECT COUNT(*) FROM survey_questions WHERE survey_id = $1", survey_id
    )
    row = await conn.fetchrow(
        """INSERT INTO survey_questions (survey_id, text, type, options, position)
           VALUES ($1, $2, $3, $4, $5) RETURNING *""",
        survey_id, body["text"], body.get("type", "scale"),
        json.dumps(body["options"]) if body.get("options") else None, count,
    )
    return _ser_question(row)


@router.put("/questions/{question_id}")
async def update_question(
    question_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE survey_questions SET text = $1, type = $2, options = $3
           WHERE id = $4 RETURNING *""",
        body["text"], body.get("type", "scale"),
        json.dumps(body["options"]) if body.get("options") else None, question_id,
    )
    if not row:
        raise HTTPException(404, "Pergunta não encontrada")
    return _ser_question(row)


@router.delete("/questions/{question_id}", status_code=204)
async def delete_question(
    question_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    await conn.execute("DELETE FROM survey_questions WHERE id = $1", question_id)


# ── Respond ───────────────────────────────────────────────────────────────────

@router.post("/{survey_id}/respond")
async def respond(
    survey_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    survey = await conn.fetchrow(
        "SELECT * FROM engagement_surveys WHERE id = $1 AND company_id = $2",
        survey_id, company_id,
    )
    if not survey:
        raise HTTPException(404, "Pesquisa não encontrada")
    if survey["status"] != "active":
        raise HTTPException(400, "Pesquisa não está ativa")

    existing = await conn.fetchrow(
        "SELECT id FROM survey_responses WHERE survey_id = $1 AND user_id = $2",
        survey_id, user_id,
    )
    if existing:
        raise HTTPException(400, "Você já respondeu esta pesquisa")

    response = await conn.fetchrow(
        "INSERT INTO survey_responses (survey_id, user_id, company_id) VALUES ($1, $2, $3) RETURNING *",
        survey_id, user_id, company_id,
    )
    for answer in body.get("answers", []):
        await conn.execute(
            """INSERT INTO survey_answers (response_id, question_id, scale_value, text_value, choice_value)
               VALUES ($1, $2, $3, $4, $5)""",
            str(response["id"]), answer["question_id"],
            answer.get("scale_value"), answer.get("text_value"), answer.get("choice_value"),
        )
    return {"ok": True}


# ── Results ───────────────────────────────────────────────────────────────────

@router.get("/{survey_id}/results")
async def get_results(
    survey_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    survey = await conn.fetchrow(
        "SELECT * FROM engagement_surveys WHERE id = $1 AND company_id = $2",
        survey_id, company_id,
    )
    if not survey:
        raise HTTPException(404, "Pesquisa não encontrada")

    questions = await conn.fetch(
        "SELECT * FROM survey_questions WHERE survey_id = $1 ORDER BY position", survey_id
    )
    response_count = await conn.fetchval(
        "SELECT COUNT(*) FROM survey_responses WHERE survey_id = $1", survey_id
    )

    results = []
    for q in questions:
        q_result: dict = {"question_id": str(q["id"]), "text": q["text"], "type": q["type"]}

        if q["type"] == "scale":
            rows = await conn.fetch(
                """SELECT sa.scale_value FROM survey_answers sa
                   JOIN survey_responses sr ON sr.id = sa.response_id
                   WHERE sa.question_id = $1 AND sr.survey_id = $2 AND sa.scale_value IS NOT NULL""",
                q["id"], survey_id,
            )
            values = [r["scale_value"] for r in rows]
            avg = sum(values) / len(values) if values else 0
            distribution = {str(i): values.count(i) for i in range(1, 6)}
            q_result["average"] = round(avg, 2)
            q_result["distribution"] = distribution
            q_result["count"] = len(values)

        elif q["type"] == "text":
            rows = await conn.fetch(
                """SELECT sa.text_value FROM survey_answers sa
                   JOIN survey_responses sr ON sr.id = sa.response_id
                   WHERE sa.question_id = $1 AND sr.survey_id = $2 AND sa.text_value IS NOT NULL""",
                q["id"], survey_id,
            )
            q_result["answers"] = [r["text_value"] for r in rows if r["text_value"]]

        elif q["type"] == "choice":
            rows = await conn.fetch(
                """SELECT sa.choice_value FROM survey_answers sa
                   JOIN survey_responses sr ON sr.id = sa.response_id
                   WHERE sa.question_id = $1 AND sr.survey_id = $2 AND sa.choice_value IS NOT NULL""",
                q["id"], survey_id,
            )
            counts: dict = {}
            for r in rows:
                v = r["choice_value"]
                counts[v] = counts.get(v, 0) + 1
            q_result["counts"] = counts
            q_result["count"] = len(rows)

        results.append(q_result)

    return {
        "survey_id": str(survey["id"]),
        "title": survey["title"],
        "anonymous": survey["anonymous"],
        "response_count": response_count,
        "results": results,
    }
