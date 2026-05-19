from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone, date as date_type, time as time_type
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/absences", tags=["absences"])

DEFAULT_TYPES = [
    {"name": "Férias", "color": "#3b82f6", "requires_approval": True},
    {"name": "Atestado Médico", "color": "#f59e0b", "requires_approval": False},
    {"name": "Licença Médica", "color": "#ef4444", "requires_approval": True},
    {"name": "Folga Compensatória", "color": "#8b5cf6", "requires_approval": True},
    {"name": "Licença Maternidade/Paternidade", "color": "#ec4899", "requires_approval": True},
    {"name": "Outro", "color": "#6b7280", "requires_approval": True},
]


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


def _ser_type(t) -> dict:
    return {
        "id": str(t["id"]),
        "name": t["name"],
        "color": t["color"],
        "requires_approval": t["requires_approval"],
        "created_at": t["created_at"].isoformat() if t["created_at"] else None,
    }


def _ser_request(r) -> dict:
    return {
        "id": str(r["id"]),
        "user_id": str(r["user_id"]),
        "user_name": r.get("user_name"),
        "user_email": r.get("user_email"),
        "department": r.get("department"),
        "type_id": str(r["type_id"]),
        "type_name": r.get("type_name"),
        "type_color": r.get("type_color"),
        "start_date": r["start_date"].isoformat() if r["start_date"] else None,
        "end_date": r["end_date"].isoformat() if r["end_date"] else None,
        "start_time": r["start_time"].strftime("%H:%M") if r.get("start_time") else None,
        "end_time": r["end_time"].strftime("%H:%M") if r.get("end_time") else None,
        "days": r["days"],
        "reason": r["reason"],
        "status": r["status"],
        "review_note": r.get("review_note"),
        "reviewed_at": r["reviewed_at"].isoformat() if r.get("reviewed_at") else None,
        "created_at": r["created_at"].isoformat() if r["created_at"] else None,
    }


async def _ensure_default_types(company_id: str, conn: asyncpg.Connection):
    count = await conn.fetchval(
        "SELECT COUNT(*) FROM absence_types WHERE company_id = $1", company_id
    )
    if count == 0:
        for t in DEFAULT_TYPES:
            await conn.execute(
                "INSERT INTO absence_types (company_id, name, color, requires_approval) VALUES ($1, $2, $3, $4)",
                company_id, t["name"], t["color"], t["requires_approval"],
            )


# ── Absence Types ─────────────────────────────────────────────────────────────

@router.get("/types")
async def list_types(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    await _ensure_default_types(company_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM absence_types WHERE company_id = $1 ORDER BY name", company_id
    )
    return [_ser_type(r) for r in rows]


@router.post("/types", status_code=201)
async def create_type(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        "INSERT INTO absence_types (company_id, name, color, requires_approval) VALUES ($1, $2, $3, $4) RETURNING *",
        company_id, body["name"], body.get("color", "#6366f1"), body.get("requires_approval", True),
    )
    return _ser_type(row)


@router.put("/types/{type_id}")
async def update_type(
    type_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        "UPDATE absence_types SET name = $1, color = $2, requires_approval = $3 WHERE id = $4 AND company_id = $5 RETURNING *",
        body["name"], body.get("color", "#6366f1"), body.get("requires_approval", True),
        type_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Tipo não encontrado")
    return _ser_type(row)


@router.delete("/types/{type_id}", status_code=204)
async def delete_type(
    type_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM absence_types WHERE id = $1 AND company_id = $2", type_id, company_id
    )


# ── Requests ──────────────────────────────────────────────────────────────────

REQUEST_JOIN = """
    SELECT ar.*, p.name AS user_name, p.email AS user_email, d.name AS department,
           at.name AS type_name, at.color AS type_color
    FROM absence_requests ar
    JOIN profiles p ON p.user_id = ar.user_id
    LEFT JOIN departments d ON d.id = p.department_id
    JOIN absence_types at ON at.id = ar.type_id
"""


@router.get("/my")
async def get_my_requests(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE ar.user_id = $1 AND ar.company_id = $2 ORDER BY ar.created_at DESC",
        user_id, company_id,
    )
    return [_ser_request(r) for r in rows]


@router.get("/team")
async def get_team_requests(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE ar.company_id = $1 ORDER BY ar.status, ar.start_date",
        company_id,
    )
    return [_ser_request(r) for r in rows]


@router.get("/calendar")
async def get_calendar(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE ar.company_id = $1 AND ar.status = 'approved' ORDER BY ar.start_date",
        company_id,
    )
    return [_ser_request(r) for r in rows]


@router.post("/request", status_code=201)
async def create_request(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    start = date_type.fromisoformat(body["start_date"])

    start_time_str = body.get("start_time")
    end_time_str = body.get("end_time")
    is_partial = bool(start_time_str and end_time_str)

    if is_partial:
        end = start
        start_time = time_type.fromisoformat(start_time_str)
        end_time = time_type.fromisoformat(end_time_str)
        if end_time <= start_time:
            raise HTTPException(400, "Horário de fim deve ser após o horário de início")
        days = 0
    else:
        end = date_type.fromisoformat(body["end_date"])
        start_time = None
        end_time = None
        if end < start:
            raise HTTPException(400, "Data de fim deve ser após a data de início")
        days = (end - start).days + 1

    atype = await conn.fetchrow(
        "SELECT * FROM absence_types WHERE id = $1 AND company_id = $2",
        body["type_id"], company_id,
    )
    if not atype:
        raise HTTPException(404, "Tipo de ausência não encontrado")

    status = "pending" if atype["requires_approval"] else "approved"
    row = await conn.fetchrow(
        """INSERT INTO absence_requests
               (company_id, user_id, type_id, start_date, end_date, start_time, end_time, days, reason, status)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *""",
        company_id, user_id, body["type_id"], start, end, start_time, end_time, days,
        body.get("reason"), status,
    )
    full = await conn.fetchrow(
        REQUEST_JOIN + " WHERE ar.id = $1", row["id"]
    )
    return _ser_request(full)


@router.put("/{request_id}/approve")
async def approve_request(
    request_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    now = datetime.now(timezone.utc)
    row = await conn.fetchrow(
        """UPDATE absence_requests
           SET status = 'approved', reviewed_by = $1, reviewed_at = $2, review_note = $3
           WHERE id = $4 RETURNING *""",
        user_id, now, body.get("note"), request_id,
    )
    if not row:
        raise HTTPException(404, "Solicitação não encontrada")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE ar.id = $1", request_id)
    return _ser_request(full)


@router.put("/{request_id}/reject")
async def reject_request(
    request_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    now = datetime.now(timezone.utc)
    row = await conn.fetchrow(
        """UPDATE absence_requests
           SET status = 'rejected', reviewed_by = $1, reviewed_at = $2, review_note = $3
           WHERE id = $4 RETURNING *""",
        user_id, now, body.get("note"), request_id,
    )
    if not row:
        raise HTTPException(404, "Solicitação não encontrada")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE ar.id = $1", request_id)
    return _ser_request(full)


@router.delete("/{request_id}", status_code=204)
async def delete_request(
    request_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    is_manager = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if is_manager:
        await conn.execute("DELETE FROM absence_requests WHERE id = $1 AND company_id = $2", request_id, company_id)
    else:
        await conn.execute(
            "DELETE FROM absence_requests WHERE id = $1 AND user_id = $2 AND status = 'pending'",
            request_id, user_id,
        )
