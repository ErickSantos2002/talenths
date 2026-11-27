from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query, Request
from datetime import datetime, timezone, date as date_type, time as time_type
import asyncpg

from app.dependencies import get_db, get_current_user_id, via_agente

# Montado em /requests e, enquanto o HS.OS não migra, também em /absences (main.py).
router = APIRouter(tags=["requests"])

# Solicitações ao RH: pedido de saída ou de pagar hora (hora extra que compensa horas
# devidas). Tipos fixos, todos com aprovação. O saldo de horas é do sistema de ponto.
CATEGORIES = ("saida", "pagar_hora")
DEFAULT_TYPES = [
    {"name": "Ida ao médico", "color": "#f59e0b", "requires_approval": True, "category": "saida"},
    {"name": "Saída pessoal", "color": "#8b5cf6", "requires_approval": True, "category": "saida"},
    {"name": "Outro", "color": "#6b7280", "requires_approval": True, "category": "saida"},
    {"name": "Pagar hora", "color": "#10b981", "requires_approval": True, "category": "pagar_hora"},
]
MIN_REASON_LENGTH = 20
LEGACY_PREFIX = "/absences/"


# ── Helpers ───────────────────────────────────────────────────────────────────

def legacy_alias(request: Request) -> bool:
    """Chamada pelo apelido /absences: o HS.OS antigo só conhece saídas."""
    return request.url.path.startswith(LEGACY_PREFIX)


def _only_saida_sql(request: Request) -> str:
    return " AND t.category = 'saida'" if legacy_alias(request) else ""


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
        "category": t["category"],
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
        "type_category": r.get("type_category"),
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
        "SELECT COUNT(*) FROM hr_request_types WHERE company_id = $1", company_id
    )
    if count == 0:
        for t in DEFAULT_TYPES:
            await conn.execute(
                """INSERT INTO hr_request_types (company_id, name, color, requires_approval, category)
                   VALUES ($1, $2, $3, $4, $5)""",
                company_id, t["name"], t["color"], t["requires_approval"], t["category"],
            )


# ── Request Types ─────────────────────────────────────────────────────────────

@router.get("/types")
async def list_types(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    await _ensure_default_types(company_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM hr_request_types t WHERE t.company_id = $1" + _only_saida_sql(request)
        + " ORDER BY t.category = 'pagar_hora', t.name = 'Outro', t.name",
        company_id,
    )
    return [_ser_type(r) for r in rows]


# ── Requests ──────────────────────────────────────────────────────────────────

REQUEST_JOIN = """
    SELECT r.*, p.name AS user_name, p.email AS user_email, d.name AS department,
           t.name AS type_name, t.color AS type_color, t.category AS type_category,
           rp.name AS reviewer_name
    FROM hr_requests r
    JOIN profiles p ON p.user_id = r.user_id
    LEFT JOIN departments d ON d.id = p.department_id
    JOIN hr_request_types t ON t.id = r.type_id
    LEFT JOIN profiles rp ON rp.user_id = r.reviewed_by
"""


@router.get("/my")
async def get_my_requests(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE r.user_id = $1 AND r.company_id = $2" + _only_saida_sql(request)
        + " ORDER BY r.created_at DESC",
        user_id, company_id,
    )
    return [_ser_request(r) for r in rows]


@router.get("/team")
async def get_team_requests(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE r.company_id = $1" + _only_saida_sql(request) + " ORDER BY r.status, r.start_date",
        company_id,
    )
    return [_ser_request(r) for r in rows]


@router.get("/team/pending")
async def get_team_pending(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + " WHERE r.company_id = $1 AND r.status = 'pending'" + _only_saida_sql(request)
        + " ORDER BY r.start_date, r.created_at",
        company_id,
    )
    return [_ser_request(r) for r in rows]


@router.get("/team/history")
async def get_team_history(
    request: Request,
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1, le=100),
    person: str | None = Query(None, alias="user_id"),
    type_id: str | None = None,
    status: Literal["approved", "rejected"] | None = None,
    category: Literal["saida", "pagar_hora"] | None = None,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    if legacy_alias(request):
        category = "saida"
    where = ["r.company_id = $1", "r.status <> 'pending'"]
    params: list = [company_id]
    filters = (("r.user_id", person), ("r.type_id", type_id), ("r.status", status), ("t.category", category))
    for column, value in filters:
        if value:
            params.append(value)
            where.append(f"{column} = ${len(params)}")
    where_sql = " WHERE " + " AND ".join(where)
    total = await conn.fetchval(
        f"SELECT count(*) FROM hr_requests r JOIN hr_request_types t ON t.id = r.type_id{where_sql}", *params
    )
    rows = await conn.fetch(
        REQUEST_JOIN + where_sql
        + f" ORDER BY r.start_date DESC, r.created_at DESC LIMIT ${len(params) + 1} OFFSET ${len(params) + 2}",
        *params, limit, (page - 1) * limit,
    )
    return {
        "total": total,
        "page": page,
        "limit": limit,
        "pages": max(1, -(-total // limit)),
        "items": [_ser_request(r) for r in rows],
    }


@router.get("/team/people")
async def get_team_people(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    """Quem já fez solicitação — as opções do filtro por pessoa do Histórico."""
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT DISTINCT p.user_id, p.name FROM hr_requests r
           JOIN profiles p ON p.user_id = r.user_id
           JOIN hr_request_types t ON t.id = r.type_id
           WHERE r.company_id = $1""" + _only_saida_sql(request) + " ORDER BY p.name",
        company_id,
    )
    return [{"user_id": str(r["user_id"]), "name": r["name"]} for r in rows]


@router.get("/calendar")
async def get_calendar(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    # O calendário mostra quem vai estar fora; quem vai pagar hora está trabalhando.
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        REQUEST_JOIN + """ WHERE r.company_id = $1 AND r.status = 'approved' AND t.category = 'saida'
              AND (p.deactivated_at IS NULL OR r.start_date <= CURRENT_DATE)
            ORDER BY r.start_date""",
        company_id,
    )
    return [_ser_request(r) for r in rows]


async def _validated_fields(body: dict, company_id: str, conn: asyncpg.Connection, only_saida: bool) -> dict:
    """Campos de um pedido (criação ou edição), já validados com as regras da tela."""
    reason = (body.get("reason") or "").strip()
    if len(reason) < MIN_REASON_LENGTH:
        raise HTTPException(400, f"O motivo precisa ter pelo menos {MIN_REASON_LENGTH} caracteres")

    rtype = await conn.fetchrow(
        "SELECT * FROM hr_request_types WHERE id = $1 AND company_id = $2"
        + (" AND category = 'saida'" if only_saida else ""),
        body["type_id"], company_id,
    )
    if not rtype:
        raise HTTPException(404, "Tipo de solicitação não encontrado")

    start = date_type.fromisoformat(body["start_date"])
    start_time_str = body.get("start_time")
    end_time_str = body.get("end_time")
    if rtype["category"] == "pagar_hora" and not (start_time_str and end_time_str):
        raise HTTPException(400, "Pagar hora precisa do horário de início e de fim")
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

    return {
        "type": rtype, "start": start, "end": end, "start_time": start_time,
        "end_time": end_time, "days": days, "reason": reason,
    }


@router.post("/request", status_code=201)
async def create_request(
    body: dict,
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    f = await _validated_fields(body, company_id, conn, legacy_alias(request))
    auto_approved = not f["type"]["requires_approval"]
    status = "approved" if auto_approved else "pending"
    row = await conn.fetchrow(
        """INSERT INTO hr_requests
               (company_id, user_id, type_id, start_date, end_date, start_time, end_time, days, reason,
                status, auto_approved, reviewed_at)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, CASE WHEN $11 THEN now() END)
           RETURNING *""",
        company_id, user_id, f["type"]["id"], f["start"], f["end"], f["start_time"], f["end_time"],
        f["days"], f["reason"], status, auto_approved,
    )
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE r.id = $1", row["id"])
    return _ser_request(full)


@router.put("/{request_id}")
async def update_request(
    request_id: str, body: dict,
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    current = await conn.fetchrow(
        """SELECT r.status, t.category FROM hr_requests r JOIN hr_request_types t ON t.id = r.type_id
            WHERE r.id = $1 AND r.user_id = $2 AND r.company_id = $3""",
        request_id, user_id, company_id,
    )
    if current is None:
        raise HTTPException(404, "Solicitação não encontrada")
    if current["status"] != "pending":
        raise HTTPException(409, "Solicitação já não está pendente")
    f = await _validated_fields(body, company_id, conn, legacy_alias(request))
    if f["type"]["category"] != current["category"]:
        raise HTTPException(400, "Não é possível trocar a categoria da solicitação")
    row = await conn.fetchrow(
        """UPDATE hr_requests
              SET type_id = $1, start_date = $2, end_date = $3, start_time = $4, end_time = $5,
                  days = $6, reason = $7, updated_at = now()
            WHERE id = $8 AND user_id = $9 AND status = 'pending' RETURNING id""",
        f["type"]["id"], f["start"], f["end"], f["start_time"], f["end_time"], f["days"], f["reason"],
        request_id, user_id,
    )
    if not row:
        raise HTTPException(409, "Solicitação já não está pendente")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE r.id = $1", request_id)
    return _ser_request(full)


async def _review(request_id: str, new_status: str, note, user_id: str, conn: asyncpg.Connection) -> dict:
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    current = await conn.fetchval(
        "SELECT status FROM hr_requests WHERE id = $1 AND company_id = $2",
        request_id, company_id,
    )
    if current is None:
        raise HTTPException(404, "Solicitação não encontrada")
    if current != "pending":
        raise HTTPException(409, "Solicitação já não está pendente")
    row = await conn.fetchrow(
        """UPDATE hr_requests
           SET status = $1, reviewed_by = $2, reviewed_at = $3, review_note = $4
           WHERE id = $5 AND status = 'pending' RETURNING id""",
        new_status, user_id, datetime.now(timezone.utc), note, request_id,
    )
    if not row:
        raise HTTPException(409, "Solicitação já não está pendente")
    full = await conn.fetchrow(REQUEST_JOIN + " WHERE r.id = $1", request_id)
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
        await conn.execute("DELETE FROM hr_requests WHERE id = $1 AND company_id = $2", request_id, company_id)
    else:
        await conn.execute(
            "DELETE FROM hr_requests WHERE id = $1 AND user_id = $2 AND status = 'pending'",
            request_id, user_id,
        )
