from fastapi import APIRouter, Depends, HTTPException, status
from datetime import datetime, timezone
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/pdi", tags=["pdi"])


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


def _serialize_plan(plan, actions):
    total = len(actions)
    done = sum(1 for a in actions if a["status"] == "done")
    return {
        "id": str(plan["id"]),
        "user_id": str(plan["user_id"]),
        "user_name": plan.get("user_name"),
        "user_email": plan.get("user_email"),
        "department": plan.get("department"),
        "eval_cycle_id": str(plan["eval_cycle_id"]) if plan["eval_cycle_id"] else None,
        "eval_cycle_name": plan.get("eval_cycle_name"),
        "title": plan["title"],
        "description": plan["description"],
        "status": plan["status"],
        "created_at": plan["created_at"].isoformat() if plan["created_at"] else None,
        "updated_at": plan["updated_at"].isoformat() if plan["updated_at"] else None,
        "progress": round(done / total * 100) if total > 0 else 0,
        "actions_total": total,
        "actions_done": done,
        "actions": [_serialize_action(a) for a in actions],
    }


def _serialize_action(a):
    return {
        "id": str(a["id"]),
        "plan_id": str(a["plan_id"]),
        "title": a["title"],
        "description": a["description"],
        "how": a["how"],
        "due_date": a["due_date"].isoformat() if a["due_date"] else None,
        "status": a["status"],
        "completed_at": a["completed_at"].isoformat() if a["completed_at"] else None,
        "position": a["position"],
        "created_at": a["created_at"].isoformat() if a["created_at"] else None,
    }


async def _get_plan_with_actions(plan_id: str, conn: asyncpg.Connection):
    plan = await conn.fetchrow(
        """SELECT pp.*, p.name AS user_name, p.email AS user_email,
                  d.name AS department, ec.name AS eval_cycle_name
           FROM pdi_plans pp
           JOIN profiles p ON p.user_id = pp.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           LEFT JOIN evaluation_cycles ec ON ec.id = pp.eval_cycle_id
           WHERE pp.id = $1""",
        plan_id,
    )
    if not plan:
        raise HTTPException(404, "Plano não encontrado")
    actions = await conn.fetch(
        "SELECT * FROM pdi_actions WHERE plan_id = $1 ORDER BY position, created_at",
        plan_id,
    )
    return plan, list(actions)


# ── Plans ─────────────────────────────────────────────────────────────────────

@router.get("/my")
async def get_my_pdi(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    plans = await conn.fetch(
        """SELECT pp.*, p.name AS user_name, p.email AS user_email,
                  d.name AS department, ec.name AS eval_cycle_name
           FROM pdi_plans pp
           JOIN profiles p ON p.user_id = pp.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           LEFT JOIN evaluation_cycles ec ON ec.id = pp.eval_cycle_id
           WHERE pp.user_id = $1 AND pp.company_id = $2
           ORDER BY pp.created_at DESC""",
        user_id, company_id,
    )
    result = []
    for plan in plans:
        actions = await conn.fetch(
            "SELECT * FROM pdi_actions WHERE plan_id = $1 ORDER BY position, created_at",
            plan["id"],
        )
        result.append(_serialize_plan(plan, list(actions)))
    return result


@router.get("/team")
async def get_team_pdi(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    plans = await conn.fetch(
        """SELECT pp.*, p.name AS user_name, p.email AS user_email,
                  d.name AS department, ec.name AS eval_cycle_name
           FROM pdi_plans pp
           JOIN profiles p ON p.user_id = pp.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           LEFT JOIN evaluation_cycles ec ON ec.id = pp.eval_cycle_id
           WHERE pp.company_id = $1
           ORDER BY p.name, pp.created_at DESC""",
        company_id,
    )
    result = []
    for plan in plans:
        actions = await conn.fetch(
            "SELECT * FROM pdi_actions WHERE plan_id = $1 ORDER BY position, created_at",
            plan["id"],
        )
        result.append(_serialize_plan(plan, list(actions)))
    return result


@router.post("/plans", status_code=201)
async def create_plan(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    plan = await conn.fetchrow(
        """INSERT INTO pdi_plans (company_id, user_id, eval_cycle_id, title, description, created_by)
           VALUES ($1, $2, $3, $4, $5, $6)
           RETURNING *""",
        company_id, body["user_id"], body.get("eval_cycle_id"),
        body["title"], body.get("description"), user_id,
    )
    # insert initial actions if provided
    actions = []
    for i, action in enumerate(body.get("actions", [])):
        a = await conn.fetchrow(
            """INSERT INTO pdi_actions (plan_id, title, description, how, due_date, position)
               VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
            str(plan["id"]), action["title"], action.get("description"),
            action.get("how"), action.get("due_date"), i,
        )
        actions.append(a)

    full_plan = await conn.fetchrow(
        """SELECT pp.*, p.name AS user_name, p.email AS user_email,
                  d.name AS department, ec.name AS eval_cycle_name
           FROM pdi_plans pp
           JOIN profiles p ON p.user_id = pp.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           LEFT JOIN evaluation_cycles ec ON ec.id = pp.eval_cycle_id
           WHERE pp.id = $1""",
        plan["id"],
    )
    return _serialize_plan(full_plan, actions)


@router.put("/plans/{plan_id}")
async def update_plan(
    plan_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    now = datetime.now(timezone.utc)

    row = await conn.fetchrow(
        """UPDATE pdi_plans SET title = $1, description = $2, status = $3, updated_at = $4
           WHERE id = $5 AND company_id = $6
           RETURNING id""",
        body.get("title"), body.get("description"), body.get("status", "active"),
        now, plan_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Plano não encontrado")
    plan, actions = await _get_plan_with_actions(plan_id, conn)
    return _serialize_plan(plan, actions)


@router.delete("/plans/{plan_id}", status_code=204)
async def delete_plan(
    plan_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM pdi_plans WHERE id = $1 AND company_id = $2",
        plan_id, company_id,
    )


# ── Actions ───────────────────────────────────────────────────────────────────

@router.post("/plans/{plan_id}/actions", status_code=201)
async def add_action(
    plan_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    count = await conn.fetchval("SELECT COUNT(*) FROM pdi_actions WHERE plan_id = $1", plan_id)
    due_date = None
    if body.get("due_date"):
        from datetime import date as date_type
        due_date = date_type.fromisoformat(body["due_date"])

    row = await conn.fetchrow(
        """INSERT INTO pdi_actions (plan_id, title, description, how, due_date, position)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        plan_id, body["title"], body.get("description"),
        body.get("how"), due_date, count,
    )
    return _serialize_action(row)


@router.put("/actions/{action_id}")
async def update_action(
    action_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    now = datetime.now(timezone.utc)
    completed_at = now if body.get("status") == "done" else None

    due_date = None
    if body.get("due_date"):
        from datetime import date as date_type
        due_date = date_type.fromisoformat(body["due_date"])

    row = await conn.fetchrow(
        """UPDATE pdi_actions
           SET title = COALESCE($1, title),
               description = COALESCE($2, description),
               how = COALESCE($3, how),
               due_date = COALESCE($4, due_date),
               status = COALESCE($5, status),
               completed_at = COALESCE($6, completed_at),
               updated_by = $7, updated_at = $8
           WHERE id = $9
           RETURNING *""",
        body.get("title"), body.get("description"), body.get("how"),
        due_date, body.get("status"), completed_at,
        user_id, now, action_id,
    )
    if not row:
        raise HTTPException(404, "Ação não encontrada")
    return _serialize_action(row)


@router.delete("/actions/{action_id}", status_code=204)
async def delete_action(
    action_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    await conn.execute("DELETE FROM pdi_actions WHERE id = $1", action_id)
