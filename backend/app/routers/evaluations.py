from fastapi import APIRouter, Depends, HTTPException, status, Query
from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/evaluations", tags=["evaluations"])

# ── Domain constants ──────────────────────────────────────────────────────────

BEHAVIORS = [
    {"key": "cultura_visivel",  "label": "Alinhamento Cultural Visível",         "pillar": "cultura"},
    {"key": "cultura_genuino",  "label": "Alinhamento Cultural Genuíno",          "pillar": "cultura"},
    {"key": "entregas",         "label": "Entregas (qualidade, prazo e impacto)", "pillar": "entregas"},
    {"key": "organizacao",      "label": "Organização e priorização",             "pillar": "entregas"},
    {"key": "colaboracao",      "label": "Colaboração",                           "pillar": "entregas"},
    {"key": "feedback",         "label": "Abertura a feedback",                   "pillar": "desenvolvimento"},
    {"key": "autonomia",        "label": "Autonomia e aprendizado",               "pillar": "desenvolvimento"},
    {"key": "protagonismo",     "label": "Protagonismo",                          "pillar": "desenvolvimento"},
]
PILLAR_WEIGHTS = {"cultura": 0.40, "entregas": 0.30, "desenvolvimento": 0.30}
BEHAVIOR_KEYS = {b["key"] for b in BEHAVIORS}

SCORE_LABELS = {1: "Precisa Melhorar", 2: "Tá no Caminho", 3: "Atende às Expectativas", 4: "Tá Mandando Bem", 5: "É Referência"}


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


def _compute_pillar_scores(scores_map: dict) -> dict:
    """Given {behavior_key: score}, compute pillar scores and final score."""
    pillar_scores = {}
    for pillar in ["cultura", "entregas", "desenvolvimento"]:
        keys = [b["key"] for b in BEHAVIORS if b["pillar"] == pillar]
        vals = [scores_map[k] for k in keys if k in scores_map and scores_map[k] is not None]
        pillar_scores[pillar] = round(sum(vals) / len(vals), 4) if vals else None

    final = None
    if all(v is not None for v in pillar_scores.values()):
        final = round(sum(pillar_scores[p] * PILLAR_WEIGHTS[p] for p in pillar_scores), 4)

    return {
        "score_cultura": pillar_scores.get("cultura"),
        "score_entregas": pillar_scores.get("entregas"),
        "score_desenvolvimento": pillar_scores.get("desenvolvimento"),
        "score_final": final,
    }


def _compute_9box(score_final: Optional[float], goals_pct: Optional[float]) -> tuple:
    """Return (x, y, quadrant_name). x=metas_band, y=avaliacao_band (1-3)."""
    if score_final is None or goals_pct is None:
        return None, None, None

    y = 1 if score_final < 3.0 else (2 if score_final <= 4.5 else 3)
    x = 1 if goals_pct < 91 else (2 if goals_pct <= 105 else 3)

    quadrants = {
        (1, 1): "Insuficiente",
        (1, 2): "Contribuidor",
        (1, 3): "Alcança Resultados",
        (2, 1): "Competência Consistente",
        (2, 2): "Essenciais",
        (2, 3): "Futuro Talento",
        (3, 1): "Alta Competência",
        (3, 2): "Forte Talento",
        (3, 3): "Super Talento",
    }
    return x, y, quadrants.get((y, x))


def _serialize_cycle(row) -> dict:
    d = dict(row)
    d["id"] = str(d["id"])
    d["company_id"] = str(d["company_id"])
    if d.get("management_cycle_id"):
        d["management_cycle_id"] = str(d["management_cycle_id"])
    if d.get("created_at"):
        d["created_at"] = d["created_at"].isoformat()
    for field in ("eval_start", "eval_end", "calibration_start", "calibration_end",
                  "feedback_start", "feedback_end", "pdi_start", "pdi_end"):
        if d.get(field):
            d[field] = d[field].isoformat()
    return d


# ── Pydantic Models ───────────────────────────────────────────────────────────

class EvalCycleCreate(BaseModel):
    name: str
    management_cycle_id: Optional[str] = None
    eval_start: Optional[date] = None
    eval_end: Optional[date] = None
    calibration_start: Optional[date] = None
    calibration_end: Optional[date] = None
    feedback_start: Optional[date] = None
    feedback_end: Optional[date] = None
    pdi_start: Optional[date] = None
    pdi_end: Optional[date] = None
    status: str = "draft"


class EvalCycleUpdate(BaseModel):
    name: Optional[str] = None
    management_cycle_id: Optional[str] = None
    eval_start: Optional[date] = None
    eval_end: Optional[date] = None
    calibration_start: Optional[date] = None
    calibration_end: Optional[date] = None
    feedback_start: Optional[date] = None
    feedback_end: Optional[date] = None
    pdi_start: Optional[date] = None
    pdi_end: Optional[date] = None
    status: Optional[str] = None


class ScoreItem(BaseModel):
    behavior_key: str
    score: int
    comment: Optional[str] = None


class EvalSubmit(BaseModel):
    eval_cycle_id: str
    evaluated_user_id: str
    eval_type: str  # 'self' | 'manager' | 'chief' | 'team'
    scores: List[ScoreItem]


class CalibrateBody(BaseModel):
    user_id: str
    nine_box_x: int
    nine_box_y: int
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

    row = await conn.fetchrow(
        """INSERT INTO public.evaluation_cycles
           (company_id, management_cycle_id, name, eval_start, eval_end,
            calibration_start, calibration_end, feedback_start, feedback_end,
            pdi_start, pdi_end, status, created_by)
           VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
           RETURNING *""",
        company_id, body.management_cycle_id, body.name,
        body.eval_start, body.eval_end,
        body.calibration_start, body.calibration_end,
        body.feedback_start, body.feedback_end,
        body.pdi_start, body.pdi_end,
        body.status, user_id,
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

    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=400, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 3}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.evaluation_cycles SET {set_clause} WHERE id = $1 AND company_id = $2 RETURNING *",
        cycle_id, company_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")
    return _serialize_cycle(row)


# ── Submit Evaluation ─────────────────────────────────────────────────────────

@router.post("/submit")
async def submit_evaluation(
    body: EvalSubmit,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    # Validate cycle
    cycle = await conn.fetchrow(
        "SELECT id FROM public.evaluation_cycles WHERE id = $1 AND company_id = $2",
        body.eval_cycle_id, company_id,
    )
    if not cycle:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")

    # Self-eval: evaluated == evaluator
    if body.eval_type == "self" and body.evaluated_user_id != user_id:
        raise HTTPException(status_code=403, detail="Autoavaliação deve ser do próprio usuário")

    # Manager can evaluate others
    if body.eval_type in ("manager", "chief") and body.evaluated_user_id == user_id:
        raise HTTPException(status_code=400, detail="Não é possível avaliar a si mesmo como gestor")

    # Validate behavior keys
    invalid = [s.behavior_key for s in body.scores if s.behavior_key not in BEHAVIOR_KEYS]
    if invalid:
        raise HTTPException(status_code=400, detail=f"Comportamentos inválidos: {invalid}")

    # Upsert evaluation
    eval_row = await conn.fetchrow(
        """INSERT INTO public.evaluations
           (eval_cycle_id, company_id, evaluated_user_id, evaluator_user_id, eval_type, submitted_at)
           VALUES ($1, $2, $3, $4, $5, now())
           ON CONFLICT (eval_cycle_id, evaluated_user_id, evaluator_user_id, eval_type)
           DO UPDATE SET submitted_at = now()
           RETURNING id""",
        body.eval_cycle_id, company_id, body.evaluated_user_id, user_id, body.eval_type,
    )
    eval_id = str(eval_row["id"])

    # Upsert scores
    for item in body.scores:
        await conn.execute(
            """INSERT INTO public.evaluation_scores (evaluation_id, behavior_key, score, comment)
               VALUES ($1, $2, $3, $4)
               ON CONFLICT (evaluation_id, behavior_key) DO UPDATE SET score = EXCLUDED.score, comment = EXCLUDED.comment""",
            eval_id, item.behavior_key, item.score, item.comment,
        )

    return {"ok": True, "evaluation_id": eval_id}


# ── My evaluation status ──────────────────────────────────────────────────────

@router.get("/my")
async def get_my_evaluation(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Get the current user's self-evaluation for a cycle (if submitted)."""
    company_id = await _get_company_id(user_id, conn)

    eval_row = await conn.fetchrow(
        """SELECT e.id, e.submitted_at FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.evaluated_user_id = $2
             AND e.evaluator_user_id = $2 AND e.eval_type = 'self'""",
        cycle_id, user_id,
    )

    if not eval_row:
        return {"submitted": False, "scores": []}

    scores = await conn.fetch(
        "SELECT behavior_key, score, comment FROM public.evaluation_scores WHERE evaluation_id = $1",
        str(eval_row["id"]),
    )

    return {
        "submitted": eval_row["submitted_at"] is not None,
        "submitted_at": eval_row["submitted_at"].isoformat() if eval_row["submitted_at"] else None,
        "scores": [dict(s) for s in scores],
    }


# ── Team evaluation overview (manager) ───────────────────────────────────────

@router.get("/team-status")
async def get_team_status(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Overview of who has submitted what for a cycle."""
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    profiles = await conn.fetch(
        """SELECT p.user_id, p.name, p.email, d.name AS department_name
           FROM public.profiles p
           LEFT JOIN public.departments d ON d.id = p.department_id
           WHERE p.company_id = $1
           ORDER BY d.name, p.name""",
        company_id,
    )

    eval_rows = await conn.fetch(
        """SELECT evaluated_user_id::text, evaluator_user_id::text, eval_type, submitted_at
           FROM public.evaluations
           WHERE eval_cycle_id = $1 AND company_id = $2""",
        cycle_id, company_id,
    )

    # Build set of submitted (evaluated_user_id, eval_type)
    submitted_map: dict = {}
    for e in eval_rows:
        uid = str(e["evaluated_user_id"])
        submitted_map.setdefault(uid, {})[e["eval_type"]] = e["submitted_at"] is not None

    # Get consolidated scores if computed
    consolidated = await conn.fetch(
        "SELECT user_id::text, score_final, nine_box_quadrant FROM public.consolidated_scores WHERE eval_cycle_id = $1",
        cycle_id,
    )
    scores_map = {str(r["user_id"]): r for r in consolidated}

    result = []
    for p in profiles:
        uid = str(p["user_id"])
        ev = submitted_map.get(uid, {})
        cs = scores_map.get(uid)
        result.append({
            "user_id": uid,
            "name": p["name"],
            "email": p["email"],
            "department": p["department_name"],
            "self_submitted": ev.get("self", False),
            "manager_submitted": ev.get("manager", False),
            "score_final": float(cs["score_final"]) if cs and cs["score_final"] else None,
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
    company_id = await _get_company_id(user_id, conn)

    evals = await conn.fetch(
        """SELECT e.id, e.eval_type, e.evaluator_user_id::text, e.submitted_at
           FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.evaluated_user_id = $2 AND e.company_id = $3""",
        cycle_id, evaluated_user_id, company_id,
    )

    result = []
    for e in evals:
        scores = await conn.fetch(
            "SELECT behavior_key, score, comment FROM public.evaluation_scores WHERE evaluation_id = $1",
            str(e["id"]),
        )
        result.append({
            "eval_type": e["eval_type"],
            "submitted_at": e["submitted_at"].isoformat() if e["submitted_at"] else None,
            "scores": [dict(s) for s in scores],
        })
    return result


# ── Consolidate scores ────────────────────────────────────────────────────────

@router.post("/cycles/{cycle_id}/consolidate")
async def consolidate_scores(
    cycle_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Compute consolidated scores for all collaborators in a cycle."""
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    cycle = await conn.fetchrow(
        "SELECT id, management_cycle_id FROM public.evaluation_cycles WHERE id = $1 AND company_id = $2",
        cycle_id, company_id,
    )
    if not cycle:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")

    # Get all collaborators
    profiles = await conn.fetch(
        "SELECT user_id, department_id FROM public.profiles WHERE company_id = $1",
        company_id,
    )

    # Get all evaluations and scores for this cycle
    evals = await conn.fetch(
        """SELECT e.id, e.evaluated_user_id::text, e.eval_type
           FROM public.evaluations e
           WHERE e.eval_cycle_id = $1 AND e.submitted_at IS NOT NULL""",
        cycle_id,
    )

    # Group scores by evaluated_user_id
    eval_scores: dict = {}
    for e in evals:
        uid = str(e["evaluated_user_id"])
        scores_rows = await conn.fetch(
            "SELECT behavior_key, score FROM public.evaluation_scores WHERE evaluation_id = $1",
            str(e["id"]),
        )
        eval_scores.setdefault(uid, {}).setdefault(e["eval_type"], {
            b["behavior_key"]: b["score"] for b in scores_rows
        })

    # Get department goals progress if management_cycle_id is set
    dept_progress: dict = {}
    mgmt_cycle_id = str(cycle["management_cycle_id"]) if cycle["management_cycle_id"] else None
    if mgmt_cycle_id:
        current_month = datetime.now().month
        goal_rows = await conn.fetch(
            "SELECT id, department_id, calculation_type, target_value, weight FROM public.goals WHERE cycle_id = $1",
            mgmt_cycle_id,
        )
        if goal_rows:
            goal_ids = [str(r["id"]) for r in goal_rows]
            actual_rows = await conn.fetch(
                "SELECT goal_id::text, month, actual_value FROM public.goal_monthly_actuals WHERE goal_id = ANY($1::uuid[])",
                goal_ids,
            )
            plan_rows = await conn.fetch(
                "SELECT goal_id::text, month, planned_value FROM public.goal_monthly_plans WHERE goal_id = ANY($1::uuid[])",
                goal_ids,
            )
            actuals_map = {}
            for a in actual_rows:
                actuals_map.setdefault(str(a["goal_id"]), {})[a["month"]] = float(a["actual_value"]) if a["actual_value"] else None
            plans_map = {}
            for p in plan_rows:
                plans_map.setdefault(str(p["goal_id"]), {})[p["month"]] = float(p["planned_value"])

            # Compute pct_year per goal
            dept_goal_pcts: dict = {}
            for r in goal_rows:
                gid = str(r["id"])
                dept_id = str(r["department_id"])
                target = float(r["target_value"]) if r["target_value"] else 0
                calc = r["calculation_type"]
                months_range = range(1, current_month + 1)
                set_actuals = {m: actuals_map.get(gid, {}).get(m) for m in months_range if actuals_map.get(gid, {}).get(m) is not None}

                if not set_actuals or not target:
                    continue

                if calc in ("sum", "subtraction"):
                    cum = sum(set_actuals.values())
                elif calc == "average":
                    vals = list(set_actuals.values())
                    cum = sum(vals) / len(vals)
                elif calc == "repeat":
                    cum = set_actuals[max(set_actuals.keys())]
                else:
                    cum = sum(set_actuals.values())

                pct = cum / target * 100
                weight = float(r["weight"]) if r["weight"] else 0
                dept_goal_pcts.setdefault(dept_id, []).append((pct, weight))

            # Weighted avg per dept
            for dept_id, pct_weights in dept_goal_pcts.items():
                total_weight = sum(w for _, w in pct_weights)
                if total_weight > 0:
                    dept_progress[dept_id] = sum(p * w for p, w in pct_weights) / total_weight
                else:
                    dept_progress[dept_id] = sum(p for p, _ in pct_weights) / len(pct_weights)

    # Compute and upsert consolidated scores
    updated = 0
    for profile in profiles:
        uid = str(profile["user_id"])
        dept_id = str(profile["department_id"]) if profile["department_id"] else None
        user_evals = eval_scores.get(uid, {})

        if not user_evals:
            continue

        # Compose scores: 90% manager + 10% self (or just self if no manager)
        self_scores = user_evals.get("self", {})
        manager_scores = user_evals.get("manager", {})

        if manager_scores and self_scores:
            composed = {
                k: round(manager_scores.get(k, self_scores.get(k, 0)) * 0.9 + self_scores.get(k, 0) * 0.1, 4)
                for k in BEHAVIOR_KEYS
                if k in manager_scores or k in self_scores
            }
        elif manager_scores:
            composed = manager_scores
        else:
            composed = self_scores

        pillar = _compute_pillar_scores(composed)
        goals_pct = dept_progress.get(dept_id) if dept_id else None
        nx, ny, quadrant = _compute_9box(pillar["score_final"], goals_pct)

        await conn.execute(
            """INSERT INTO public.consolidated_scores
               (eval_cycle_id, user_id, company_id, score_cultura, score_entregas, score_desenvolvimento,
                score_final, nine_box_x, nine_box_y, nine_box_quadrant, computed_at)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, now())
               ON CONFLICT (eval_cycle_id, user_id) DO UPDATE SET
                 score_cultura = EXCLUDED.score_cultura,
                 score_entregas = EXCLUDED.score_entregas,
                 score_desenvolvimento = EXCLUDED.score_desenvolvimento,
                 score_final = EXCLUDED.score_final,
                 nine_box_x = EXCLUDED.nine_box_x,
                 nine_box_y = EXCLUDED.nine_box_y,
                 nine_box_quadrant = EXCLUDED.nine_box_quadrant,
                 computed_at = now()""",
            cycle_id, uid, company_id,
            pillar["score_cultura"], pillar["score_entregas"], pillar["score_desenvolvimento"],
            pillar["score_final"], nx, ny, quadrant,
        )
        updated += 1

    return {"ok": True, "updated": updated}


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

    quadrants = {
        (1, 1): "Insuficiente", (1, 2): "Contribuidor", (1, 3): "Alcança Resultados",
        (2, 1): "Competência Consistente", (2, 2): "Essenciais", (2, 3): "Futuro Talento",
        (3, 1): "Alta Competência", (3, 2): "Forte Talento", (3, 3): "Super Talento",
    }
    quadrant = quadrants.get((body.nine_box_y, body.nine_box_x))

    await conn.execute(
        """UPDATE public.consolidated_scores
           SET nine_box_x = $3, nine_box_y = $4, nine_box_quadrant = $5,
               calibrated = true, calibration_note = $6
           WHERE eval_cycle_id = $1 AND user_id = $2 AND company_id = $7""",
        cycle_id, body.user_id, body.nine_box_x, body.nine_box_y, quadrant,
        body.calibration_note, company_id,
    )
    return {"ok": True, "quadrant": quadrant}


# ── 9Box data ─────────────────────────────────────────────────────────────────

@router.get("/9box")
async def get_9box(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    consolidated = await conn.fetch(
        """SELECT cs.user_id::text, cs.score_final, cs.score_cultura, cs.score_entregas,
                  cs.score_desenvolvimento, cs.nine_box_x, cs.nine_box_y, cs.nine_box_quadrant,
                  cs.calibrated, cs.calibration_note, p.name, p.email,
                  d.name AS department_name
           FROM public.consolidated_scores cs
           JOIN public.profiles p ON p.user_id = cs.user_id
           LEFT JOIN public.departments d ON d.id = p.department_id
           WHERE cs.eval_cycle_id = $1 AND cs.company_id = $2
           ORDER BY cs.nine_box_y DESC, cs.nine_box_x DESC""",
        cycle_id, company_id,
    )

    # Group by quadrant position
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
            "score_final": float(r["score_final"]) if r["score_final"] else None,
            "nine_box_x": r["nine_box_x"],
            "nine_box_y": r["nine_box_y"],
            "nine_box_quadrant": r["nine_box_quadrant"],
            "calibrated": r["calibrated"],
        })

    return {"grid": grid, "total": len(consolidated)}
