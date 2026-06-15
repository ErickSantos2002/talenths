from fastapi import APIRouter, Depends, HTTPException, status, Query
from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/goals", tags=["goals"])


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _require_manager(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not row or not row["company_id"]:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Empresa não encontrada")
    return str(row["company_id"])


async def _validate_goal_ownership(goal_id: str, company_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.goals WHERE id = $1 AND company_id = $2",
        goal_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meta não encontrada")


def _curve_nota(realizado: float, v_low: float, v_mid: float, v_high: float, cap: float) -> float:
    """Régua crescente de atingimento: (v_low → 80), (v_mid → 100), (v_high → 120).

    Abaixo de v_low a nota é proporcional até zero; acima de v_high satura no teto (cap).
    """
    if realizado <= 0:
        return 0.0
    if v_low and realizado <= v_low:
        return round(realizado / v_low * 80, 2)
    if realizado <= v_mid:
        span = v_mid - v_low
        return round(80 + (realizado - v_low) / span * 20, 2) if span else 100.0
    if realizado <= v_high:
        span = v_high - v_mid
        return round(100 + (realizado - v_mid) / span * 20, 2) if span else cap
    return cap


def _compute_nota(
    realizado: Optional[float],
    target_value: float,
    curve_v80: Optional[float],
    curve_v100: Optional[float],
    curve_v120: Optional[float],
    objective: str,
    min_curve: float,
    max_curve: float,
) -> Optional[float]:
    """Converte o realizado acumulado em nota de atingimento (%) via curva.

    O ponto de 100% é o valor alvo total (curve_v100, ou target_value se não informado).
    Para metas de 'diminuir', a curva é espelhada (menor realizado = nota maior).
    """
    if realizado is None:
        return None
    # Âncora de 100% = valor alvo total. Valores de curva nulos/<=0 contam como "não configurados".
    v100 = curve_v100 if (curve_v100 is not None and curve_v100 > 0) else target_value
    if not v100:
        return None
    cap = round(max_curve * 100, 2)

    if objective == "decrease":
        v80 = curve_v80 if (curve_v80 is not None and curve_v80 > 0) else v100 * (2 - min_curve)
        v120 = curve_v120 if (curve_v120 is not None and curve_v120 > 0) else v100 * (2 - max_curve)
        # Espelha realizado e âncoras em torno de v100 → curva volta a ser crescente.
        return _curve_nota(2 * v100 - realizado, 2 * v100 - v80, v100, 2 * v100 - v120, cap)

    v80 = curve_v80 if (curve_v80 is not None and curve_v80 > 0) else v100 * min_curve
    v120 = curve_v120 if (curve_v120 is not None and curve_v120 > 0) else v100 * max_curve
    return _curve_nota(realizado, v80, v100, v120, cap)


def _compute_progress(
    goal_id: str,
    calculation_type: str,
    target_value: float,
    objective: str,
    curve_v80: Optional[float],
    curve_v100: Optional[float],
    curve_v120: Optional[float],
    min_curve: float,
    max_curve: float,
    plans_map: dict,
    actuals_map: dict,
    current_month: int,
) -> dict:
    months_range = range(1, current_month + 1)
    goal_plans = plans_map.get(goal_id, {})
    goal_actuals = actuals_map.get(goal_id, {})

    set_actuals = {
        m: goal_actuals[m]
        for m in months_range
        if m in goal_actuals and goal_actuals[m] is not None
    }
    set_months = sorted(set_actuals.keys())

    if calculation_type in ("sum", "subtraction"):
        cum_actual = sum(set_actuals.values()) if set_actuals else 0.0
        cum_planned = sum(goal_plans.get(m, 0.0) or 0.0 for m in months_range)
    elif calculation_type == "average":
        vals = list(set_actuals.values())
        cum_actual = sum(vals) / len(vals) if vals else 0.0
        # Planejado acumulado também é a média (dos meses com realizado), não a soma.
        planned_set = [goal_plans.get(m, 0.0) or 0.0 for m in set_months]
        cum_planned = sum(planned_set) / len(planned_set) if planned_set else 0.0
    elif calculation_type == "repeat":
        cum_actual = set_actuals[set_months[-1]] if set_months else 0.0
        cum_planned = (goal_plans.get(set_months[-1], 0.0) or 0.0) if set_months else 0.0
    else:
        cum_actual = 0.0
        cum_planned = 0.0

    actual_this_month = goal_actuals.get(current_month)
    planned_this_month = goal_plans.get(current_month, 0.0) or 0.0

    pct_month = None
    if actual_this_month is not None and planned_this_month:
        pct_month = round(actual_this_month / planned_this_month * 100, 2)

    pct_cumulative = None
    if cum_planned:
        pct_cumulative = round(cum_actual / cum_planned * 100, 2)

    pct_year = None
    if target_value:
        pct_year = round(cum_actual / target_value * 100, 2)

    nota = _compute_nota(
        cum_actual if set_actuals else None,
        target_value, curve_v80, curve_v100, curve_v120,
        objective, min_curve, max_curve,
    )

    return {
        "pct_month": pct_month,
        "pct_cumulative": pct_cumulative,
        "pct_year": pct_year,
        "nota": nota,
        "cum_actual": cum_actual,
        "cum_planned": cum_planned,
    }


def _serialize_goal(row) -> dict:
    d = dict(row)
    d["id"] = str(d["id"])
    d["cycle_id"] = str(d["cycle_id"])
    d["department_id"] = str(d["department_id"])
    d["company_id"] = str(d["company_id"])
    if d.get("responsible_user_id"):
        d["responsible_user_id"] = str(d["responsible_user_id"])
    if d.get("weight") is not None:
        d["weight"] = float(d["weight"])
    if d.get("target_value") is not None:
        d["target_value"] = float(d["target_value"])
    for field in ("curve_v80", "curve_v100", "curve_v120"):
        if d.get(field) is not None:
            d[field] = float(d[field])
    return d


# ── Pydantic Models ───────────────────────────────────────────────────────────

class CycleCreate(BaseModel):
    name: str
    start_date: date
    end_date: date
    min_curve_value: float = 0.80
    max_progress_value: float = 1.20
    status: str = "draft"


class CycleUpdate(BaseModel):
    name: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    min_curve_value: Optional[float] = None
    max_progress_value: Optional[float] = None
    status: Optional[str] = None


class GoalCreate(BaseModel):
    cycle_id: str
    department_id: str
    responsible_user_id: Optional[str] = None
    title: str
    objective: str = "increase"
    calculation_type: str = "sum"
    result_type: str = "value"
    weight: float = 0
    target_value: float
    curve_v80: Optional[float] = None
    curve_v100: Optional[float] = None
    curve_v120: Optional[float] = None
    position: int = 0


class GoalUpdate(BaseModel):
    department_id: Optional[str] = None
    responsible_user_id: Optional[str] = None
    title: Optional[str] = None
    objective: Optional[str] = None
    calculation_type: Optional[str] = None
    result_type: Optional[str] = None
    weight: Optional[float] = None
    target_value: Optional[float] = None
    curve_v80: Optional[float] = None
    curve_v100: Optional[float] = None
    curve_v120: Optional[float] = None
    position: Optional[int] = None


class MonthlyPlanItem(BaseModel):
    month: int
    planned_value: float


class MonthlyPlansUpdate(BaseModel):
    plans: List[MonthlyPlanItem]


class ActualUpdate(BaseModel):
    actual_value: float
    comment: Optional[str] = None


# ── Cycles ────────────────────────────────────────────────────────────────────

@router.get("/cycles")
async def list_cycles(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM public.management_cycles WHERE company_id = $1 ORDER BY start_date DESC",
        company_id,
    )
    result = []
    for r in rows:
        d = dict(r)
        d["id"] = str(d["id"])
        d["company_id"] = str(d["company_id"])
        if d.get("start_date"):
            d["start_date"] = d["start_date"].isoformat()
        if d.get("end_date"):
            d["end_date"] = d["end_date"].isoformat()
        if d.get("created_at"):
            d["created_at"] = d["created_at"].isoformat()
        for f in ("min_curve_value", "max_progress_value"):
            if d.get(f) is not None:
                d[f] = float(d[f])
        result.append(d)
    return result


@router.post("/cycles", status_code=status.HTTP_201_CREATED)
async def create_cycle(
    body: CycleCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    row = await conn.fetchrow(
        """INSERT INTO public.management_cycles
           (company_id, name, start_date, end_date, min_curve_value, max_progress_value, status, created_by)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
           RETURNING *""",
        company_id, body.name, body.start_date, body.end_date,
        body.min_curve_value, body.max_progress_value, body.status, user_id,
    )
    d = dict(row)
    d["id"] = str(d["id"])
    d["company_id"] = str(d["company_id"])
    if d.get("start_date"):
        d["start_date"] = d["start_date"].isoformat()
    if d.get("end_date"):
        d["end_date"] = d["end_date"].isoformat()
    if d.get("created_at"):
        d["created_at"] = d["created_at"].isoformat()
    for f in ("min_curve_value", "max_progress_value"):
        if d.get(f) is not None:
            d[f] = float(d[f])
    return d


@router.put("/cycles/{cycle_id}")
async def update_cycle(
    cycle_id: str,
    body: CycleUpdate,
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
        f"UPDATE public.management_cycles SET {set_clause} WHERE id = $1 AND company_id = $2 RETURNING *",
        cycle_id, company_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")

    d = dict(row)
    d["id"] = str(d["id"])
    d["company_id"] = str(d["company_id"])
    if d.get("start_date"):
        d["start_date"] = d["start_date"].isoformat()
    if d.get("end_date"):
        d["end_date"] = d["end_date"].isoformat()
    if d.get("created_at"):
        d["created_at"] = d["created_at"].isoformat()
    for f in ("min_curve_value", "max_progress_value"):
        if d.get(f) is not None:
            d[f] = float(d[f])
    return d


# ── Overview ──────────────────────────────────────────────────────────────────

@router.get("/overview")
async def get_overview(
    cycle_id: str = Query(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    cycle = await conn.fetchrow(
        "SELECT id, min_curve_value, max_progress_value FROM public.management_cycles WHERE id = $1 AND company_id = $2",
        cycle_id, company_id,
    )
    if not cycle:
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")

    min_curve = float(cycle["min_curve_value"]) if cycle["min_curve_value"] is not None else 0.80
    max_curve = float(cycle["max_progress_value"]) if cycle["max_progress_value"] is not None else 1.20

    goal_rows = await conn.fetch(
        """SELECT g.*, p.name AS responsible_name, d.name AS department_name
           FROM public.goals g
           LEFT JOIN public.profiles p ON p.user_id = g.responsible_user_id
           JOIN public.departments d ON d.id = g.department_id
           WHERE g.cycle_id = $1
           ORDER BY d.name, g.position, g.created_at""",
        cycle_id,
    )

    if not goal_rows:
        return []

    goal_ids = [str(r["id"]) for r in goal_rows]

    plan_rows = await conn.fetch(
        "SELECT goal_id::text, month, planned_value FROM public.goal_monthly_plans WHERE goal_id = ANY($1::uuid[])",
        goal_ids,
    )
    actual_rows = await conn.fetch(
        "SELECT goal_id::text, month, actual_value FROM public.goal_monthly_actuals WHERE goal_id = ANY($1::uuid[])",
        goal_ids,
    )

    plans_map: dict = {}
    for p in plan_rows:
        gid = str(p["goal_id"])
        plans_map.setdefault(gid, {})[p["month"]] = float(p["planned_value"]) if p["planned_value"] is not None else 0.0

    actuals_map: dict = {}
    for a in actual_rows:
        gid = str(a["goal_id"])
        actuals_map.setdefault(gid, {})[a["month"]] = float(a["actual_value"]) if a["actual_value"] is not None else None

    current_month = datetime.now().month

    dept_map: dict = {}
    for r in goal_rows:
        dept_id = str(r["department_id"])
        if dept_id not in dept_map:
            dept_map[dept_id] = {
                "department_id": dept_id,
                "department_name": r["department_name"],
                "goals": [],
            }

        goal_id = str(r["id"])
        progress = _compute_progress(
            goal_id,
            r["calculation_type"],
            float(r["target_value"]) if r["target_value"] else 0.0,
            r["objective"],
            float(r["curve_v80"]) if r["curve_v80"] is not None else None,
            float(r["curve_v100"]) if r["curve_v100"] is not None else None,
            float(r["curve_v120"]) if r["curve_v120"] is not None else None,
            min_curve,
            max_curve,
            plans_map,
            actuals_map,
            current_month,
        )

        goal_dict = _serialize_goal(r)
        goal_dict.update(progress)
        dept_map[dept_id]["goals"].append(goal_dict)

    result = []
    for dept in dept_map.values():
        dept["weight_total"] = round(sum(float(g["weight"]) for g in dept["goals"]), 2)
        result.append(dept)

    result.sort(key=lambda d: d["department_name"])
    return result


# ── Goals CRUD ────────────────────────────────────────────────────────────────

@router.post("", status_code=status.HTTP_201_CREATED)
async def create_goal(
    body: GoalCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    if not await conn.fetchrow(
        "SELECT id FROM public.management_cycles WHERE id = $1 AND company_id = $2",
        body.cycle_id, company_id,
    ):
        raise HTTPException(status_code=404, detail="Ciclo não encontrado")

    if not await conn.fetchrow(
        "SELECT id FROM public.departments WHERE id = $1 AND company_id = $2",
        body.department_id, company_id,
    ):
        raise HTTPException(status_code=404, detail="Departamento não encontrado")

    row = await conn.fetchrow(
        """INSERT INTO public.goals
           (cycle_id, department_id, company_id, responsible_user_id, title, objective,
            calculation_type, result_type, weight, target_value, curve_v80, curve_v100, curve_v120, position)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
           RETURNING *""",
        body.cycle_id, body.department_id, company_id, body.responsible_user_id,
        body.title, body.objective, body.calculation_type, body.result_type,
        body.weight, body.target_value, body.curve_v80, body.curve_v100, body.curve_v120,
        body.position,
    )

    weight_sum = await conn.fetchval(
        "SELECT COALESCE(SUM(weight), 0) FROM public.goals WHERE cycle_id = $1 AND department_id = $2",
        body.cycle_id, body.department_id,
    )

    result = _serialize_goal(row)
    result["weight_warning"] = abs(float(weight_sum) - 100.0) > 0.01
    return result


@router.get("/{goal_id}")
async def get_goal(
    goal_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    row = await conn.fetchrow(
        """SELECT g.*, p.name AS responsible_name, d.name AS department_name
           FROM public.goals g
           LEFT JOIN public.profiles p ON p.user_id = g.responsible_user_id
           JOIN public.departments d ON d.id = g.department_id
           WHERE g.id = $1 AND g.company_id = $2""",
        goal_id, company_id,
    )
    if not row:
        raise HTTPException(status_code=404, detail="Meta não encontrada")

    plans = await conn.fetch(
        "SELECT month, planned_value FROM public.goal_monthly_plans WHERE goal_id = $1 ORDER BY month",
        goal_id,
    )
    actuals = await conn.fetch(
        "SELECT month, actual_value, comment, is_closed, updated_at FROM public.goal_monthly_actuals WHERE goal_id = $1 ORDER BY month",
        goal_id,
    )
    history = await conn.fetch(
        """SELECT h.id, h.month, h.previous_value, h.new_value, h.comment, h.changed_at, p.name AS changed_by_name
           FROM public.goal_update_history h
           LEFT JOIN public.profiles p ON p.user_id = h.changed_by
           WHERE h.goal_id = $1
           ORDER BY h.changed_at DESC LIMIT 50""",
        goal_id,
    )

    cycle = await conn.fetchrow(
        "SELECT min_curve_value, max_progress_value FROM public.management_cycles WHERE id = $1",
        row["cycle_id"],
    )
    min_curve = float(cycle["min_curve_value"]) if cycle and cycle["min_curve_value"] is not None else 0.80
    max_curve = float(cycle["max_progress_value"]) if cycle and cycle["max_progress_value"] is not None else 1.20

    plans_map = {goal_id: {p["month"]: float(p["planned_value"]) for p in plans}}
    actuals_map = {
        goal_id: {
            a["month"]: float(a["actual_value"]) if a["actual_value"] is not None else None
            for a in actuals
        }
    }
    current_month = datetime.now().month
    progress = _compute_progress(
        goal_id, row["calculation_type"],
        float(row["target_value"]) if row["target_value"] else 0.0,
        row["objective"],
        float(row["curve_v80"]) if row["curve_v80"] is not None else None,
        float(row["curve_v100"]) if row["curve_v100"] is not None else None,
        float(row["curve_v120"]) if row["curve_v120"] is not None else None,
        min_curve, max_curve,
        plans_map, actuals_map, current_month,
    )

    result = _serialize_goal(row)
    result.update(progress)
    result["plans"] = [{"month": p["month"], "planned_value": float(p["planned_value"])} for p in plans]
    result["actuals"] = [
        {
            "month": a["month"],
            "actual_value": float(a["actual_value"]) if a["actual_value"] is not None else None,
            "comment": a["comment"],
            "is_closed": a["is_closed"],
            "updated_at": a["updated_at"].isoformat() if a["updated_at"] else None,
        }
        for a in actuals
    ]
    result["history"] = [
        {
            "id": str(h["id"]),
            "month": h["month"],
            "previous_value": float(h["previous_value"]) if h["previous_value"] is not None else None,
            "new_value": float(h["new_value"]),
            "comment": h["comment"],
            "changed_at": h["changed_at"].isoformat(),
            "changed_by_name": h["changed_by_name"],
        }
        for h in history
    ]
    return result


@router.put("/{goal_id}")
async def update_goal(
    goal_id: str,
    body: GoalUpdate,
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
        f"UPDATE public.goals SET {set_clause} WHERE id = $1 AND company_id = $2 RETURNING *",
        goal_id, company_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=404, detail="Meta não encontrada")
    return _serialize_goal(row)


@router.delete("/{goal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_goal(
    goal_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    result = await conn.execute(
        "DELETE FROM public.goals WHERE id = $1 AND company_id = $2", goal_id, company_id,
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=404, detail="Meta não encontrada")


# ── Monthly Plans ─────────────────────────────────────────────────────────────

@router.put("/{goal_id}/plans")
async def update_plans(
    goal_id: str,
    body: MonthlyPlansUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _validate_goal_ownership(goal_id, company_id, conn)

    for item in body.plans:
        await conn.execute(
            """INSERT INTO public.goal_monthly_plans (goal_id, month, planned_value)
               VALUES ($1, $2, $3)
               ON CONFLICT (goal_id, month) DO UPDATE SET planned_value = EXCLUDED.planned_value""",
            goal_id, item.month, item.planned_value,
        )

    rows = await conn.fetch(
        "SELECT month, planned_value FROM public.goal_monthly_plans WHERE goal_id = $1 ORDER BY month",
        goal_id,
    )
    return [{"month": r["month"], "planned_value": float(r["planned_value"])} for r in rows]


# ── Monthly Actuals ───────────────────────────────────────────────────────────

@router.put("/{goal_id}/actuals/{month}")
async def update_actual(
    goal_id: str,
    month: int,
    body: ActualUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _validate_goal_ownership(goal_id, company_id, conn)

    if not 1 <= month <= 12:
        raise HTTPException(status_code=400, detail="Mês inválido")

    existing = await conn.fetchrow(
        "SELECT actual_value, is_closed FROM public.goal_monthly_actuals WHERE goal_id = $1 AND month = $2",
        goal_id, month,
    )
    if existing and existing["is_closed"]:
        raise HTTPException(status_code=409, detail="Este mês já foi fechado e não pode ser editado")

    previous_value = float(existing["actual_value"]) if existing and existing["actual_value"] is not None else None

    await conn.execute(
        """INSERT INTO public.goal_monthly_actuals (goal_id, month, actual_value, comment, updated_by, updated_at)
           VALUES ($1, $2, $3, $4, $5, now())
           ON CONFLICT (goal_id, month) DO UPDATE SET
             actual_value = EXCLUDED.actual_value,
             comment = EXCLUDED.comment,
             updated_by = EXCLUDED.updated_by,
             updated_at = now()""",
        goal_id, month, body.actual_value, body.comment, user_id,
    )
    await conn.execute(
        """INSERT INTO public.goal_update_history (goal_id, month, previous_value, new_value, comment, changed_by)
           VALUES ($1, $2, $3, $4, $5, $6)""",
        goal_id, month, previous_value, body.actual_value, body.comment, user_id,
    )
    return {"ok": True}


@router.post("/{goal_id}/close/{month}")
async def close_month(
    goal_id: str,
    month: int,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _validate_goal_ownership(goal_id, company_id, conn)

    if not 1 <= month <= 12:
        raise HTTPException(status_code=400, detail="Mês inválido")

    existing = await conn.fetchrow(
        "SELECT actual_value FROM public.goal_monthly_actuals WHERE goal_id = $1 AND month = $2",
        goal_id, month,
    )
    if not existing or existing["actual_value"] is None:
        raise HTTPException(status_code=422, detail="Não é possível fechar um mês sem valor realizado")

    await conn.execute(
        "UPDATE public.goal_monthly_actuals SET is_closed = true WHERE goal_id = $1 AND month = $2",
        goal_id, month,
    )
    return {"ok": True}


@router.post("/{goal_id}/reopen/{month}")
async def reopen_month(
    goal_id: str,
    month: int,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await _validate_goal_ownership(goal_id, company_id, conn)

    if not 1 <= month <= 12:
        raise HTTPException(status_code=400, detail="Mês inválido")

    existing = await conn.fetchrow(
        "SELECT is_closed FROM public.goal_monthly_actuals WHERE goal_id = $1 AND month = $2",
        goal_id, month,
    )
    if not existing or not existing["is_closed"]:
        raise HTTPException(status_code=422, detail="Este mês não está fechado")

    await conn.execute(
        "UPDATE public.goal_monthly_actuals SET is_closed = false WHERE goal_id = $1 AND month = $2",
        goal_id, month,
    )
    return {"ok": True}
