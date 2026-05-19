from fastapi import APIRouter, Depends, HTTPException, Query
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/logs", tags=["logs"])


async def _require_admin(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('master_admin', 'manager')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=403, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow("SELECT company_id FROM public.profiles WHERE user_id = $1", user_id)
    if not row or not row["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")
    return str(row["company_id"])


@router.get("")
async def list_logs(
    page: int = Query(1, ge=1),
    limit: int = Query(50, ge=1, le=200),
    search: str = Query("", alias="q"),
    method: str = Query(""),
    status: str = Query(""),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_admin(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    offset = (page - 1) * limit

    conditions = ["company_id = $1"]
    params: list = [company_id]
    idx = 2

    if search:
        conditions.append(f"(user_name ILIKE ${idx} OR path ILIKE ${idx} OR action ILIKE ${idx})")
        params.append(f"%{search}%")
        idx += 1

    if method:
        conditions.append(f"method = ${idx}")
        params.append(method.upper())
        idx += 1

    if status == "success":
        conditions.append(f"status_code < 400")
    elif status == "error":
        conditions.append(f"status_code >= 400")

    where = " AND ".join(conditions)

    total = await conn.fetchval(f"SELECT COUNT(*) FROM audit_logs WHERE {where}", *params)
    rows = await conn.fetch(
        f"""SELECT id, user_id, user_name, method, path, action, status_code, ip_address, created_at
            FROM audit_logs WHERE {where}
            ORDER BY created_at DESC
            LIMIT ${idx} OFFSET ${idx + 1}""",
        *params, limit, offset,
    )

    return {
        "total": total,
        "page": page,
        "limit": limit,
        "pages": max(1, -(-total // limit)),
        "items": [
            {
                "id": r["id"],
                "user_id": str(r["user_id"]) if r["user_id"] else None,
                "user_name": r["user_name"],
                "method": r["method"],
                "path": r["path"],
                "action": r["action"],
                "status_code": r["status_code"],
                "ip_address": r["ip_address"],
                "created_at": r["created_at"].isoformat() if r["created_at"] else None,
            }
            for r in rows
        ],
    }
