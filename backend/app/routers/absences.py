from fastapi import APIRouter, Depends, HTTPException, Request
from datetime import datetime, timezone, date as date_type, time as time_type
import asyncpg

from app.dependencies import get_db, get_current_user_id, via_agente

router = APIRouter(prefix="/absences", tags=["absences"])

# Tipos fixos (migração 038): Ausências é só o pedido prévio de saída, sempre com aprovação.
DEFAULT_TYPES = [
    {"name": "Ida ao médico", "color": "#f59e0b", "requires_approval": True},
    {"name": "Saída pessoal", "color": "#8b5cf6", "requires_approval": True},
    {"name": "Outro", "color": "#6b7280", "requires_approval": True},
]
MIN_REASON_LENGTH = 20


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
        "reviewer_name": r.get("reviewer_name"),
        "auto_approved": r.get("auto_approved", False),
        "created_at": r["created_at"].isoformat() if r["created_at"] else None,
        "updated_at": r["updated_at"].isoformat() if r.get("updated_at") else None,
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
        "SELECT * FROM absence_types WHERE company_id = $1 ORDER BY name = 'Outro', name", company_id
    )
    return [_ser_type(r) for r in rows]


# ── Requests ──────────────────────────────────────────────────────────────────

REQUEST_JOIN = """
    SELECT ar.*, p.name AS user_name, p.email AS user_email, d.name AS department,
           at.name AS type_name, at.color AS type_color, rp.name AS reviewer_name
    FROM absence_requests ar
    JOIN profiles p ON p.user_id = ar.user_id
    LEFT JOIN departments d ON d.id = p.department_id
    JOIN absence_types at ON at.id = ar.type_id
    LEFT JOIN profiles rp ON rp.user_id = ar.reviewed_by
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
        REQUEST_JOIN + """ WHERE ar.company_id = $1 AND ar.status = 'approved'
              AND (p.deactivated_at IS NULL OR ar.start_date <= CURRENT_DATE)
            ORDER BY ar.start_date""",
        company_id,
    )
    return [_ser_request(r) for r in rows]


async def _validated_fields(body: dict, company_id: str, conn: asyncpg.Connection) -> dict:
    """Campos de um pedido (criação ou edição), já validados com as regras da tela."""
    reason = (body.get("reason") or "").strip()
    if len(reason) < MIN_REASON_LENGTH:
        raise HTTPException(400, f"O motivo precisa ter pelo menos {MIN_REASON_LENGTH} caracteres")
    start = date_type.fromisoformat(body["start_date"])

    start_time_str = body.get("start_time")
    end_time_str = body.get("end_time")
    if start_time_str and end_time_str:
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
    return {
        "type": atype, "start": start, "end": end, "start_time": start_time,
        "end_time": end_time, "days": days, "reason": reason,
    }


@router.post("/request", status_code=201)
async def create_request(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    f = await _validated_fields(body, company_id, conn)
    auto_approved = not f["type"]["requires_approval"]
    status = "approved" if auto_approved else "pending"
    row = await conn.fetchrow(
        """INSERT INTO absence_requests
               (company_id, user_id, type_id, start_date, end_date, start_time, end_time, days, reason,
                status, auto_approved, reviewed_at)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, CASE WHEN $11 THEN now() END)
           RETURNING *""",
        company_id, user_id, f["type"]["id"], f["start"], f["end"], f["start_time"], f["end_time"],
        f["days"], f["reason"], status, auto_approved,
    )
    full = await conn.fetchrow(
        REQUEST_JOIN + " WHERE ar.id = $1", row["id"]
    )
    return _ser_request(full)


@router.put("/{request_id}")
async def update_request(
    request_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    current = await conn.fetchval(
        "SELECT status FROM absence_requests WHERE id = $1 AND user_id = $2 AND company_id = $3",
        request_id, user_id, company_id,
    )
    if current is None:
        raise HTTPException(404, "Solicitação não encontrada")
    if current != "pending":
        raise HTTPException(409, "Solicitação já não está pendente")
    f = await _validated_fields(body, company_id, conn)
    row = await conn.fetchrow(
        """UPDATE absence_requests
              SET type_id = $1, start_date = $2, end_date = $3, start_time = $4, end_time = $5,
                  days = $6, reason = $7, updated_at = now()
            WHERE id = $8 AND user_id = $9 AND status = 'pending' RETURNING id""",
        f["type"]["id"], f["start"], f["end"], f["start_time"], f["end_time"], f["days"], f["reason"],
        request_id, user_id,
    )
    if not row:
        raise HTTPException(409, "Solicitação já não está pendente")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE ar.id = $1", request_id)
    return _ser_request(full)


async def _review(request_id: str, new_status: str, note, user_id: str, conn: asyncpg.Connection) -> dict:
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    current = await conn.fetchval(
        "SELECT status FROM absence_requests WHERE id = $1 AND company_id = $2",
        request_id, company_id,
    )
    if current is None:
        raise HTTPException(404, "Solicitação não encontrada")
    if current != "pending":
        raise HTTPException(409, "Solicitação já não está pendente")
    row = await conn.fetchrow(
        """UPDATE absence_requests
           SET status = $1, reviewed_by = $2, reviewed_at = $3, review_note = $4
           WHERE id = $5 AND status = 'pending' RETURNING id""",
        new_status, user_id, datetime.now(timezone.utc), note, request_id,
    )
    if not row:
        raise HTTPException(409, "Solicitação já não está pendente")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE ar.id = $1", request_id)
    return _ser_request(full)


@router.put("/{request_id}/approve")
async def approve_request(
    request_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    return await _review(request_id, "approved", body.get("note"), user_id, conn)


@router.put("/{request_id}/reject")
async def reject_request(
    request_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    return await _review(request_id, "rejected", body.get("note"), user_id, conn)


@router.delete("/{request_id}", status_code=204)
async def delete_request(
    request_id: str,
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    is_manager = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    # Pelo assistente só existe "cancelar o meu pedido pendente"; excluir pedido de
    # outra pessoa (ou já decidido) fica para o RH na tela.
    if is_manager and not via_agente(request):
        await conn.execute("DELETE FROM absence_requests WHERE id = $1 AND company_id = $2", request_id, company_id)
    else:
        await conn.execute(
            "DELETE FROM absence_requests WHERE id = $1 AND user_id = $2 AND status = 'pending'",
            request_id, user_id,
        )
