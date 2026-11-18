import uuid
from datetime import date, datetime
from typing import List, Literal, Optional
from zoneinfo import ZoneInfo

import asyncpg
from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field

from app.dependencies import get_current_user_id, get_db
from app.evaluation_rules import (
    BEHAVIOR_KEYS, BEHAVIORS, NINE_BOX_QUADRANTS, PILLAR_WEIGHTS, SCORE_LABELS, STATUSES,
    compose_scores, effective_status, nine_box, validate_stage_dates,
)
from app.roster import active_unless, iso_or_none

router = APIRouter(prefix="/evaluations", tags=["evaluations"])

BRT = ZoneInfo("America/Sao_Paulo")
DATE_FIELDS = ("eval_start", "eval_end", "calibration_start", "calibration_end",
               "feedback_start", "feedback_end", "pdi_start", "pdi_end")


def _today() -> date:
    return datetime.now(BRT).date()


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _require_manager(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")
    return str(row["company_id"])


def _uuid_or_404(value: str, what: str) -> None:
    try:
        uuid.UUID(str(value))
    except ValueError:
        raise HTTPException(status_code=404, detail=f"{what} não encontrado")


async def _get_cycle(cycle_id: str, company_id: str, conn: asyncpg.Connection):
    _uuid_or_404(cycle_id, "Ciclo")
    row = await conn.fetchrow(
        "SELECT * FROM public.evaluation_cycles WHERE id = $1 AND company_id = $2", cycle_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")
    return row


def _check_cycle(cycle: dict) -> None:
    if cycle.get("status") not in STATUSES:
        raise HTTPException(status_code=422, detail="Etapa inválida")
    error = validate_stage_dates(cycle)
    if error:
        raise HTTPException(status_code=422, detail=error)
    if cycle.get("stage_by_dates") and not cycle.get("eval_start"):
        raise HTTPException(
            status_code=422,
            detail="Para a etapa seguir as datas, preencha o início e o fim de Avaliação.",
        )


def _serialize_cycle(row) -> dict:
    d = dict(row)
    d["id"] = str(d["id"])
    d["company_id"] = str(d["company_id"])
    if d.get("management_cycle_id"):
        d["management_cycle_id"] = str(d["management_cycle_id"])
    if d.get("created_by"):
        d["created_by"] = str(d["created_by"])
    d["manual_status"] = d["status"]
    d["status"] = effective_status(d, _today())
    if d.get("created_at"):
        d["created_at"] = d["created_at"].isoformat()
    for field in DATE_FIELDS:
        if d.get(field):
            d[field] = d[field].isoformat()
    return d


def _float(v) -> Optional[float]:
    return float(v) if v is not None else None


# ── Pydantic Models ───────────────────────────────────────────────────────────

class EvalCycleCreate(BaseModel):
    name: str = Field(min_length=1)
    management_cycle_id: Optional[str] = None
    eval_start: Optional[date] = None
    eval_end: Optional[date] = None
    calibration_start: Optional[date] = None
    calibration_end: Optional[date] = None
    feedback_start: Optional[date] = None
    feedback_end: Optional[date] = None
    pdi_start: Optional[date] = None
    pdi_end: Optional[date] = None
    stage_by_dates: bool = True
    status: str = "draft"


class EvalCycleUpdate(BaseModel):
    # Campo enviado como null limpa o valor; campo ausente fica como está.
    name: Optional[str] = Field(default=None, min_length=1)
    management_cycle_id: Optional[str] = None
    eval_start: Optional[date] = None
    eval_end: Optional[date] = None
    calibration_start: Optional[date] = None
    calibration_end: Optional[date] = None
    feedback_start: Optional[date] = None
    feedback_end: Optional[date] = None
    pdi_start: Optional[date] = None
    pdi_end: Optional[date] = None
    stage_by_dates: Optional[bool] = None
    status: Optional[str] = None


class ScoreItem(BaseModel):
    behavior_key: str
    score: int = Field(ge=1, le=5)
    comment: Optional[str] = Field(default=None, max_length=2000)


class EvalSubmit(BaseModel):
    eval_cycle_id: str
    evaluated_user_id: str
    eval_type: Literal["self", "manager"]
    scores: List[ScoreItem]


class CalibrateBody(BaseModel):
    user_id: str
    nine_box_x: int = Field(ge=1, le=3)
    nine_box_y: int = Field(ge=1, le=3)
    calibration_note: Optional[str] = None


# ── Behaviors metadata ────────────────────────────────────────────────────────

@router.get("/behaviors")
async def get_behaviors():
    return {"behaviors": BEHAVIORS, "score_labels": SCORE_LABELS, "pillar_weights": PILLAR_WEIGHTS}


# ── Evaluation Cycles ─────────────────────────────────────────────────────────

@router.get("/cycles")
async def list_cycles(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM public.evaluation_cycles WHERE company_id = $1 ORDER BY created_at DESC",
        company_id,
    )
    return [_serialize_cycle(r) for r in rows]


@router.post("/cycles", status_code=status.HTTP_201_CREATED)
async def create_cycle(
    body: EvalCycleCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    data = body.model_dump()
    _check_cycle(data)

    row = await conn.fetchrow(
        """INSERT INTO public.evaluation_cycles
           (company_id, management_cycle_id, name, eval_start, eval_end,
            calibration_start, calibration_end, feedback_start, feedback_end,
            pdi_start, pdi_end, status, stage_by_dates, created_by)
           VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14)
           RETURNING *""",
        company_id, body.management_cycle_id, body.name.strip(),
        body.eval_start, body.eval_end,
        body.calibration_start, body.calibration_end,
        body.feedback_start, body.feedback_end,
        body.pdi_start, body.pdi_end,
        body.status, body.stage_by_dates, user_id,
    )
    return _serialize_cycle(row)


@router.put("/cycles/{cycle_id}")
async def update_cycle(
    cycle_id: str,
    body: EvalCycleUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    current = dict(await _get_cycle(cycle_id, company_id, conn))

    fields = body.model_dump(exclude_unset=True)
    for required in ("name", "status", "stage_by_dates"):
        if required in fields and fields[required] is None:
            fields.pop(required)
    if not fields:
        raise HTTPException(status_code=400, detail="Nenhum campo para atualizar")
    if "name" in fields:
        fields["name"] = fields["name"].strip()
    _check_cycle({**current, **fields})

    set_clause = ", ".join(f"{k} = ${i + 3}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.evaluation_cycles SET {set_clause} WHERE id = $1 AND company_id = $2 RETURNING *",
        cycle_id, company_id, *list(fields.values()),
    )
    return _serialize_cycle(row)


# ── Submit Evaluation ─────────────────────────────────────────────────────────

@router.post("/submit")
async def submit_evaluation(
    body: EvalSubmit,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    cycle = await _get_cycle(body.eval_cycle_id, company_id, conn)
    stage = effective_status(dict(cycle), _today())

    _uuid_or_404(body.evaluated_user_id, "Colaborador")
    evaluated = await conn.fetchrow(
        """SELECT user_id::text, name, manager_user_id::text FROM public.profiles
           WHERE user_id = $1 AND company_id = $2 AND deactivated_at IS NULL""",
        body.evaluated_user_id, company_id,
    )
    if not evaluated:
        raise HTTPException(status_code=404, detail="Colaborador não encontrado")

    if body.eval_type == "self":
        if body.evaluated_user_id != user_id:
            raise HTTPException(status_code=403, detail="Autoavaliação deve ser do próprio usuário")
        if stage != "evaluation":
            raise HTTPException(status_code=409, detail="A autoavaliação deste ciclo não está aberta.")
    else:
        if body.evaluated_user_id == user_id:
            raise HTTPException(status_code=400, detail="Não é possível avaliar a si mesmo como gestor")
        if evaluated["manager_user_id"] != user_id:
            raise HTTPException(
                status_code=403,
                detail=f"Só o gestor responsável por {evaluated['name']} pode dar a nota de gestor.",
            )
        if stage not in ("evaluation", "calibration"):
            raise HTTPException(
                status_code=409,
                detail="A avaliação do gestor só pode ser enviada nas etapas de Avaliação e Calibragem.",
            )

    keys = [s.behavior_key for s in body.scores]
    if len(keys) != len(set(keys)) or set(keys) != BEHAVIOR_KEYS:
        raise HTTPException(status_code=422, detail="Dê uma nota de 1 a 5 para todos os comportamentos.")

    async with conn.transaction():
        eval_row = await conn.fetchrow(
            """INSERT INTO public.evaluations
               (eval_cycle_id, company_id, evaluated_user_id, evaluator_user_id, eval_type, submitted_at)
               VALUES ($1, $2, $3, $4, $5, now())
               ON CONFLICT (eval_cycle_id, evaluated_user_id, evaluator_user_id, eval_type)
               DO UPDATE SET submitted_at = now()
               RETURNING id""",
            body.eval_cycle_id, company_id, body.evaluated_user_id, user_id, body.eval_type,
        )
        eval_id = eval_row["id"]
        for item in body.scores:
            await conn.execute(
                """INSERT INTO public.evaluation_scores (evaluation_id, behavior_key, score, comment)
                   VALUES ($1, $2, $3, $4)
                   ON CONFLICT (evaluation_id, behavior_key)
                   DO UPDATE SET score = EXCLUDED.score, comment = EXCLUDED.comment""",
                eval_id, item.behavior_key, item.score, (item.comment or "").strip() or None,
            )

    return {"ok": True, "evaluation_id": str(eval_id)}


async def _scores_of(conn: asyncpg.Connection, evaluation_id) -> list:
    rows = await conn.fetch(
        "SELECT behavior_key, score, comment FROM public.evaluation_scores WHERE evaluation_id = $1",
        evaluation_id,
    )
    return [dict(s) for s in rows]


# ── My evaluation status ──────────────────────────────────────────────────────

@router.get("/my")
async def get_my_evaluation(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Get the current user's self-evaluation for a cycle (if submitted)."""
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)

    eval_row = await conn.fetchrow(
        """SELECT e.id, e.submitted_at FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.evaluated_user_id = $2
             AND e.evaluator_user_id = $2 AND e.eval_type = 'self'""",
        cycle_id, user_id,
    )

    if not eval_row:
        return {"submitted": False, "submitted_at": None, "scores": []}

    return {
        "submitted": eval_row["submitted_at"] is not None,
        "submitted_at": eval_row["submitted_at"].isoformat() if eval_row["submitted_at"] else None,
        "scores": await _scores_of(conn, eval_row["id"]),
    }


# ── Gestor responsável: quem eu avalio ───────────────────────────────────────

@router.get("/my-team")
async def get_my_team(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Pessoas de quem o usuário é gestor responsável, com a nota de gestor que ele já deu."""
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)

    people = await conn.fetch(
        """SELECT p.user_id, p.name, p.email, d.name AS department_name
           FROM public.profiles p
           LEFT JOIN public.departments d ON d.id = p.department_id
           WHERE p.manager_user_id = $1 AND p.company_id = $2 AND p.deactivated_at IS NULL
           ORDER BY p.name""",
        user_id, company_id,
    )
    if not people:
        return []

    evals = await conn.fetch(
        """SELECT id, evaluated_user_id, evaluator_user_id, eval_type, submitted_at
           FROM public.evaluations
           WHERE eval_cycle_id = $1 AND evaluated_user_id = ANY($2::uuid[])""",
        cycle_id, [p["user_id"] for p in people],
    )
    self_done = {e["evaluated_user_id"] for e in evals if e["eval_type"] == "self" and e["submitted_at"]}
    mine = {e["evaluated_user_id"]: e for e in evals
            if e["eval_type"] == "manager" and str(e["evaluator_user_id"]) == str(user_id)}

    result = []
    for p in people:
        given = mine.get(p["user_id"])
        result.append({
            "user_id": str(p["user_id"]),
            "name": p["name"],
            "email": p["email"],
            "department": p["department_name"],
            "self_submitted": p["user_id"] in self_done,
            "manager_submitted": bool(given and given["submitted_at"]),
            "submitted_at": iso_or_none(given["submitted_at"]) if given else None,
            "scores": await _scores_of(conn, given["id"]) if given else [],
        })
    return result


# ── Team evaluation overview (manager) ───────────────────────────────────────

@router.get("/team-status")
async def get_team_status(
    cycle_id: str = Query(...),
    include_inactive: bool = False,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Overview of who has submitted what for a cycle."""
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)

    profiles = await conn.fetch(
        f"""SELECT p.user_id, p.name, p.email, p.deactivated_at, d.name AS department_name,
                   p.manager_user_id::text, m.name AS manager_name, m.deactivated_at AS manager_deactivated_at
            FROM public.profiles p
            LEFT JOIN public.departments d ON d.id = p.department_id
            LEFT JOIN public.profiles m ON m.user_id = p.manager_user_id
            WHERE p.company_id = $1 AND {active_unless("p", 2)}
            ORDER BY d.name, p.name""",
        company_id, include_inactive,
    )

    eval_rows = await conn.fetch(
        """SELECT evaluated_user_id::text, eval_type, submitted_at
           FROM public.evaluations
           WHERE eval_cycle_id = $1 AND company_id = $2""",
        cycle_id, company_id,
    )
    submitted_map: dict = {}
    for e in eval_rows:
        if e["submitted_at"] is not None:
            submitted_map.setdefault(e["evaluated_user_id"], set()).add(e["eval_type"])

    consolidated = await conn.fetch(
        """SELECT user_id::text, score_final, score_manager, score_self, nine_box_quadrant
           FROM public.consolidated_scores WHERE eval_cycle_id = $1""",
        cycle_id,
    )
    scores_map = {r["user_id"]: r for r in consolidated}

    result = []
    for p in profiles:
        uid = str(p["user_id"])
        done = submitted_map.get(uid, set())
        cs = scores_map.get(uid)
        result.append({
            "user_id": uid,
            "name": p["name"],
            "email": p["email"],
            "department": p["department_name"],
            "deactivated_at": iso_or_none(p["deactivated_at"]),
            "manager_user_id": p["manager_user_id"],
            "manager_name": p["manager_name"],
            "manager_deactivated": p["manager_deactivated_at"] is not None,
            "self_submitted": "self" in done,
            "manager_submitted": "manager" in done,
            "score_final": _float(cs["score_final"]) if cs else None,
            "score_manager": _float(cs["score_manager"]) if cs else None,
            "score_self": _float(cs["score_self"]) if cs else None,
            "nine_box_quadrant": cs["nine_box_quadrant"] if cs else None,
        })
    return result


# ── Get evaluation scores for a collaborator (manager view) ──────────────────

@router.get("/scores")
async def get_scores(
    cycle_id: str = Query(...),
    evaluated_user_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    # Notas de cada avaliação, por tipo de avaliador: só o RH.
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)
    _uuid_or_404(evaluated_user_id, "Colaborador")

    evals = await conn.fetch(
        """SELECT e.id, e.eval_type, e.evaluator_user_id::text, e.submitted_at
           FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.evaluated_user_id = $2 AND e.company_id = $3""",
        cycle_id, evaluated_user_id, company_id,
    )
    return [{
        "eval_type": e["eval_type"],
        "submitted_at": iso_or_none(e["submitted_at"]),
        "scores": await _scores_of(conn, e["id"]),
    } for e in evals]


# ── Consolidate scores ────────────────────────────────────────────────────────

async def _department_goal_progress(conn: asyncpg.Connection, mgmt_cycle_id: str) -> dict:
    """% de atingimento das metas de cada departamento no ciclo de metas, acumulado até o
    último mês do ciclo (ou até o mês corrente, se o ciclo ainda está em andamento)."""
    mgmt = await conn.fetchrow(
        "SELECT start_date, end_date FROM public.management_cycles WHERE id = $1", mgmt_cycle_id,
    )
    if not mgmt:
        return {}
    today = _today()
    last_month = mgmt["end_date"].month if today > mgmt["end_date"] else today.month

    goal_rows = await conn.fetch(
        "SELECT id, department_id, calculation_type, target_value, weight FROM public.goals WHERE cycle_id = $1",
        mgmt_cycle_id,
    )
    if not goal_rows:
        return {}
    actual_rows = await conn.fetch(
        "SELECT goal_id::text, month, actual_value FROM public.goal_monthly_actuals WHERE goal_id = ANY($1::uuid[])",
        [r["id"] for r in goal_rows],
    )
    actuals_map: dict = {}
    for a in actual_rows:
        if a["actual_value"] is not None:
            actuals_map.setdefault(a["goal_id"], {})[a["month"]] = float(a["actual_value"])

    dept_goal_pcts: dict = {}
    for r in goal_rows:
        target = float(r["target_value"]) if r["target_value"] else 0
        actuals = {m: v for m, v in actuals_map.get(str(r["id"]), {}).items() if m <= last_month}
        if not actuals or not target or not r["department_id"]:
            continue
        calc = r["calculation_type"]
        if calc == "average":
            cum = sum(actuals.values()) / len(actuals)
        elif calc == "repeat":
            cum = actuals[max(actuals)]
        else:
            cum = sum(actuals.values())
        weight = float(r["weight"]) if r["weight"] else 0
        dept_goal_pcts.setdefault(str(r["department_id"]), []).append((cum / target * 100, weight))

    progress = {}
    for dept_id, pct_weights in dept_goal_pcts.items():
        total_weight = sum(w for _, w in pct_weights)
        if total_weight > 0:
            progress[dept_id] = sum(p * w for p, w in pct_weights) / total_weight
        else:
            progress[dept_id] = sum(p for p, _ in pct_weights) / len(pct_weights)
    return progress


@router.post("/cycles/{cycle_id}/consolidate")
async def consolidate_scores(
    cycle_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Nota de cada colaborador ativo: média ponderada gestor 90% + autoavaliação 10%. A
    posição calibrada à mão no 9Box é mantida."""
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    cycle = await _get_cycle(cycle_id, company_id, conn)

    profiles = await conn.fetch(
        """SELECT user_id::text, department_id::text FROM public.profiles
           WHERE company_id = $1 AND deactivated_at IS NULL""",
        company_id,
    )

    # Se a pessoa trocou de gestor no meio do ciclo, vale a nota de gestor mais recente.
    evals = await conn.fetch(
        """SELECT e.id, e.evaluated_user_id::text, e.eval_type
           FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.company_id = $2 AND e.submitted_at IS NOT NULL
           ORDER BY e.submitted_at""",
        cycle_id, company_id,
    )
    eval_scores: dict = {}
    for e in evals:
        rows = await conn.fetch(
            "SELECT behavior_key, score FROM public.evaluation_scores WHERE evaluation_id = $1", e["id"],
        )
        scores = {r["behavior_key"]: r["score"] for r in rows}
        if set(scores) >= BEHAVIOR_KEYS:
            eval_scores.setdefault(e["evaluated_user_id"], {})[e["eval_type"]] = scores

    dept_progress = (
        await _department_goal_progress(conn, cycle["management_cycle_id"])
        if cycle["management_cycle_id"] else {}
    )

    updated = 0
    without_score = []
    async with conn.transaction():
        for profile in profiles:
            uid = profile["user_id"]
            user_evals = eval_scores.get(uid, {})
            composed = compose_scores(user_evals.get("manager"), user_evals.get("self"))
            if composed is None:
                without_score.append(uid)
                continue

            goals_pct = dept_progress.get(profile["department_id"]) if profile["department_id"] else None
            nx, ny, quadrant = nine_box(composed["final"], goals_pct)

            await conn.execute(
                """INSERT INTO public.consolidated_scores
                   (eval_cycle_id, user_id, company_id, score_cultura, score_entregas, score_desenvolvimento,
                    score_final, score_manager, score_self, nine_box_x, nine_box_y, nine_box_quadrant, computed_at)
                   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, now())
                   ON CONFLICT (eval_cycle_id, user_id) DO UPDATE SET
                     score_cultura = EXCLUDED.score_cultura,
                     score_entregas = EXCLUDED.score_entregas,
                     score_desenvolvimento = EXCLUDED.score_desenvolvimento,
                     score_final = EXCLUDED.score_final,
                     score_manager = EXCLUDED.score_manager,
                     score_self = EXCLUDED.score_self,
                     nine_box_x = CASE WHEN consolidated_scores.calibrated
                                       THEN consolidated_scores.nine_box_x ELSE EXCLUDED.nine_box_x END,
                     nine_box_y = CASE WHEN consolidated_scores.calibrated
                                       THEN consolidated_scores.nine_box_y ELSE EXCLUDED.nine_box_y END,
                     nine_box_quadrant = CASE WHEN consolidated_scores.calibrated
                                       THEN consolidated_scores.nine_box_quadrant ELSE EXCLUDED.nine_box_quadrant END,
                     computed_at = now()""",
                cycle_id, uid, company_id,
                composed["cultura"], composed["entregas"], composed["desenvolvimento"],
                composed["final"], composed["manager"], composed["self"], nx, ny, quadrant,
            )
            updated += 1

        # Nota antiga de quem hoje não tem avaliação de gestor (o cálculo anterior aceitava
        # só a autoavaliação) não pode continuar no 9Box.
        if without_score:
            await conn.execute(
                """DELETE FROM public.consolidated_scores
                   WHERE eval_cycle_id = $1 AND user_id = ANY($2::uuid[]) AND NOT calibrated""",
                cycle_id, without_score,
            )

    return {"ok": True, "updated": updated, "pending_manager": len(without_score)}


# ── Calibrate (manual 9Box override) ─────────────────────────────────────────

@router.put("/cycles/{cycle_id}/calibrate")
async def calibrate(
    cycle_id: str,
    body: CalibrateBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)
    _uuid_or_404(body.user_id, "Colaborador")
    quadrant = NINE_BOX_QUADRANTS[(body.nine_box_y, body.nine_box_x)]

    result = await conn.execute(
        """UPDATE public.consolidated_scores
           SET nine_box_x = $3, nine_box_y = $4, nine_box_quadrant = $5,
               calibrated = true, calibration_note = $6
           WHERE eval_cycle_id = $1 AND user_id = $2 AND company_id = $7""",
        cycle_id, body.user_id, body.nine_box_x, body.nine_box_y, quadrant,
        body.calibration_note, company_id,
    )
    if result == "UPDATE 0":
        raise HTTPException(status_code=404, detail="Nota consolidada não encontrada")
    return {"ok": True, "quadrant": quadrant}


# ── 9Box data ─────────────────────────────────────────────────────────────────

@router.get("/9box")
async def get_9box(
    cycle_id: str = Query(...),
    include_inactive: bool = False,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _get_cycle(cycle_id, company_id, conn)

    consolidated = await conn.fetch(
        f"""SELECT cs.user_id::text, cs.score_final, cs.score_cultura, cs.score_entregas,
                   cs.score_desenvolvimento, cs.nine_box_x, cs.nine_box_y, cs.nine_box_quadrant,
                   cs.calibrated, cs.calibration_note, p.name, p.email, p.deactivated_at,
                   d.name AS department_name
            FROM public.consolidated_scores cs
            JOIN public.profiles p ON p.user_id = cs.user_id
            LEFT JOIN public.departments d ON d.id = p.department_id
            WHERE cs.eval_cycle_id = $1 AND cs.company_id = $2 AND {active_unless("p", 3)}
            ORDER BY cs.nine_box_y DESC, cs.nine_box_x DESC""",
        cycle_id, company_id, include_inactive,
    )

    grid: dict = {}
    for r in consolidated:
        if r["nine_box_x"] is None or r["nine_box_y"] is None:
            continue
        key = f"{r['nine_box_y']}-{r['nine_box_x']}"
        grid.setdefault(key, []).append({
            "user_id": str(r["user_id"]),
            "name": r["name"],
            "email": r["email"],
            "department": r["department_name"],
            "deactivated_at": iso_or_none(r["deactivated_at"]),
            "score_final": _float(r["score_final"]),
            "nine_box_x": r["nine_box_x"],
            "nine_box_y": r["nine_box_y"],
            "nine_box_quadrant": r["nine_box_quadrant"],
            "calibrated": r["calibrated"],
        })

    return {"grid": grid, "total": len(consolidated)}
