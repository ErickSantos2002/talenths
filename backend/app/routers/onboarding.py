from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone, date as date_type, timedelta
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/onboarding", tags=["onboarding"])


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


def _ser_template_task(t) -> dict:
    return {
        "id": str(t["id"]),
        "template_id": str(t["template_id"]),
        "title": t["title"],
        "description": t["description"],
        "responsible_role": t["responsible_role"],
        "due_days": t["due_days"],
        "position": t["position"],
    }


def _ser_template(t, tasks: list) -> dict:
    return {
        "id": str(t["id"]),
        "name": t["name"],
        "description": t["description"],
        "created_at": t["created_at"].isoformat() if t["created_at"] else None,
        "tasks": [_ser_template_task(x) for x in tasks],
    }


def _ser_checklist_task(t) -> dict:
    return {
        "id": str(t["id"]),
        "checklist_id": str(t["checklist_id"]),
        "title": t["title"],
        "description": t["description"],
        "responsible_role": t["responsible_role"],
        "due_date": t["due_date"].isoformat() if t["due_date"] else None,
        "position": t["position"],
        "completed_at": t["completed_at"].isoformat() if t["completed_at"] else None,
        "completed_by": str(t["completed_by"]) if t["completed_by"] else None,
    }


def _ser_checklist(c, tasks: list) -> dict:
    total = len(tasks)
    done = sum(1 for t in tasks if t["completed_at"])
    return {
        "id": str(c["id"]),
        "user_id": str(c["user_id"]),
        "user_name": c.get("user_name"),
        "user_email": c.get("user_email"),
        "department": c.get("department"),
        "template_id": str(c["template_id"]) if c["template_id"] else None,
        "template_name": c["template_name"],
        "started_at": c["started_at"].isoformat() if c["started_at"] else None,
        "created_at": c["created_at"].isoformat() if c["created_at"] else None,
        "progress": round(done / total * 100) if total > 0 else 0,
        "tasks_total": total,
        "tasks_done": done,
        "tasks": [_ser_checklist_task(t) for t in tasks],
    }


# ── Templates ─────────────────────────────────────────────────────────────────

@router.get("/templates")
async def list_templates(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    templates = await conn.fetch(
        "SELECT * FROM onboarding_templates WHERE company_id = $1 ORDER BY created_at DESC",
        company_id,
    )
    result = []
    for t in templates:
        tasks = await conn.fetch(
            "SELECT * FROM onboarding_template_tasks WHERE template_id = $1 ORDER BY position",
            t["id"],
        )
        result.append(_ser_template(t, list(tasks)))
    return result


@router.post("/templates", status_code=201)
async def create_template(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    t = await conn.fetchrow(
        "INSERT INTO onboarding_templates (company_id, name, description, created_by) VALUES ($1, $2, $3, $4) RETURNING *",
        company_id, body["name"], body.get("description"), user_id,
    )
    tasks = []
    for i, task in enumerate(body.get("tasks", [])):
        row = await conn.fetchrow(
            """INSERT INTO onboarding_template_tasks (template_id, title, description, responsible_role, due_days, position)
               VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
            str(t["id"]), task["title"], task.get("description"),
            task.get("responsible_role", "user"), task.get("due_days", 7), i,
        )
        tasks.append(row)
    return _ser_template(t, tasks)


@router.put("/templates/{template_id}")
async def update_template(
    template_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    t = await conn.fetchrow(
        "UPDATE onboarding_templates SET name = $1, description = $2 WHERE id = $3 AND company_id = $4 RETURNING *",
        body["name"], body.get("description"), template_id, company_id,
    )
    if not t:
        raise HTTPException(404, "Template não encontrado")
    tasks = await conn.fetch(
        "SELECT * FROM onboarding_template_tasks WHERE template_id = $1 ORDER BY position", template_id
    )
    return _ser_template(t, list(tasks))


@router.delete("/templates/{template_id}", status_code=204)
async def delete_template(
    template_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM onboarding_templates WHERE id = $1 AND company_id = $2", template_id, company_id
    )


# ── Template Tasks ────────────────────────────────────────────────────────────

@router.post("/templates/{template_id}/tasks", status_code=201)
async def add_template_task(
    template_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    count = await conn.fetchval(
        "SELECT COUNT(*) FROM onboarding_template_tasks WHERE template_id = $1", template_id
    )
    row = await conn.fetchrow(
        """INSERT INTO onboarding_template_tasks (template_id, title, description, responsible_role, due_days, position)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        template_id, body["title"], body.get("description"),
        body.get("responsible_role", "user"), body.get("due_days", 7), count,
    )
    return _ser_template_task(row)


@router.put("/template-tasks/{task_id}")
async def update_template_task(
    task_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE onboarding_template_tasks
           SET title = $1, description = $2, responsible_role = $3, due_days = $4
           WHERE id = $5 RETURNING *""",
        body["title"], body.get("description"),
        body.get("responsible_role", "user"), body.get("due_days", 7), task_id,
    )
    if not row:
        raise HTTPException(404, "Tarefa não encontrada")
    return _ser_template_task(row)


@router.delete("/template-tasks/{task_id}", status_code=204)
async def delete_template_task(
    task_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    await conn.execute("DELETE FROM onboarding_template_tasks WHERE id = $1", task_id)


# ── Checklists ────────────────────────────────────────────────────────────────

@router.get("/team")
async def get_team_checklists(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    checklists = await conn.fetch(
        """SELECT oc.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM onboarding_checklists oc
           JOIN profiles p ON p.user_id = oc.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE oc.company_id = $1
           ORDER BY oc.created_at DESC""",
        company_id,
    )
    result = []
    for c in checklists:
        tasks = await conn.fetch(
            "SELECT * FROM onboarding_checklist_tasks WHERE checklist_id = $1 ORDER BY position", c["id"]
        )
        result.append(_ser_checklist(c, list(tasks)))
    return result


@router.get("/my")
async def get_my_checklist(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    c = await conn.fetchrow(
        """SELECT oc.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM onboarding_checklists oc
           JOIN profiles p ON p.user_id = oc.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE oc.user_id = $1 AND oc.company_id = $2""",
        user_id, company_id,
    )
    if not c:
        return None
    tasks = await conn.fetch(
        "SELECT * FROM onboarding_checklist_tasks WHERE checklist_id = $1 ORDER BY position", c["id"]
    )
    return _ser_checklist(c, list(tasks))


@router.post("/assign", status_code=201)
async def assign_checklist(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    target_user_id = body["user_id"]
    template_id = body.get("template_id")
    started_at_raw = body.get("started_at")
    started_at = date_type.fromisoformat(started_at_raw) if started_at_raw else date_type.today()

    existing = await conn.fetchrow(
        "SELECT id FROM onboarding_checklists WHERE company_id = $1 AND user_id = $2",
        company_id, target_user_id,
    )
    if existing:
        raise HTTPException(400, "Colaborador já possui um checklist de onboarding")

    template_name = None
    template_tasks = []
    if template_id:
        tmpl = await conn.fetchrow(
            "SELECT * FROM onboarding_templates WHERE id = $1 AND company_id = $2",
            template_id, company_id,
        )
        if tmpl:
            template_name = tmpl["name"]
            template_tasks = await conn.fetch(
                "SELECT * FROM onboarding_template_tasks WHERE template_id = $1 ORDER BY position",
                template_id,
            )

    c = await conn.fetchrow(
        """INSERT INTO onboarding_checklists (company_id, user_id, template_id, template_name, started_at, created_by)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        company_id, target_user_id, template_id, template_name, started_at, user_id,
    )

    tasks = []
    for i, tt in enumerate(template_tasks):
        due_date = started_at + timedelta(days=tt["due_days"])
        row = await conn.fetchrow(
            """INSERT INTO onboarding_checklist_tasks
                   (checklist_id, title, description, responsible_role, due_date, position)
               VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
            str(c["id"]), tt["title"], tt["description"],
            tt["responsible_role"], due_date, i,
        )
        tasks.append(row)

    full = await conn.fetchrow(
        """SELECT oc.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM onboarding_checklists oc
           JOIN profiles p ON p.user_id = oc.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE oc.id = $1""",
        c["id"],
    )
    return _ser_checklist(full, tasks)


@router.delete("/checklists/{checklist_id}", status_code=204)
async def delete_checklist(
    checklist_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM onboarding_checklists WHERE id = $1 AND company_id = $2", checklist_id, company_id
    )


# ── Checklist Tasks ───────────────────────────────────────────────────────────

@router.put("/checklist-tasks/{task_id}/complete")
async def complete_task(
    task_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    now = datetime.now(timezone.utc)
    row = await conn.fetchrow(
        "SELECT completed_at FROM onboarding_checklist_tasks WHERE id = $1", task_id
    )
    if not row:
        raise HTTPException(404, "Tarefa não encontrada")
    # toggle
    new_completed = None if row["completed_at"] else now
    new_completed_by = None if row["completed_at"] else user_id
    updated = await conn.fetchrow(
        """UPDATE onboarding_checklist_tasks
           SET completed_at = $1, completed_by = $2
           WHERE id = $3 RETURNING *""",
        new_completed, new_completed_by, task_id,
    )
    return _ser_checklist_task(updated)


@router.post("/checklist-tasks", status_code=201)
async def add_checklist_task(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    checklist_id = body["checklist_id"]
    count = await conn.fetchval(
        "SELECT COUNT(*) FROM onboarding_checklist_tasks WHERE checklist_id = $1", checklist_id
    )
    due_date = None
    if body.get("due_date"):
        due_date = date_type.fromisoformat(body["due_date"])
    row = await conn.fetchrow(
        """INSERT INTO onboarding_checklist_tasks
               (checklist_id, title, description, responsible_role, due_date, position)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        checklist_id, body["title"], body.get("description"),
        body.get("responsible_role", "user"), due_date, count,
    )
    return _ser_checklist_task(row)
