from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/workshops", tags=["workshops"])


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


def _ser_workshop(w, seats_taken: int = 0, user_status: str | None = None) -> dict:
    return {
        "id": str(w["id"]),
        "title": w["title"],
        "area": w["area"],
        "description": w["description"],
        "location": w["location"],
        "starts_at": w["starts_at"].isoformat() if w["starts_at"] else None,
        "ends_at": w["ends_at"].isoformat() if w["ends_at"] else None,
        "max_seats": w["max_seats"],
        "seats_taken": seats_taken,
        "status": w["status"],
        "created_at": w["created_at"].isoformat() if w["created_at"] else None,
        "user_registration_status": user_status,
    }


def _ser_registration(r) -> dict:
    return {
        "id": str(r["id"]),
        "workshop_id": str(r["workshop_id"]),
        "user_id": str(r["user_id"]),
        "user_name": r.get("user_name"),
        "user_email": r.get("user_email"),
        "department": r.get("department"),
        "status": r["status"],
        "registered_at": r["registered_at"].isoformat() if r["registered_at"] else None,
    }


# ── Workshop CRUD ─────────────────────────────────────────────────────────────

@router.get("")
async def list_workshops(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    workshops = await conn.fetch(
        "SELECT * FROM workshops WHERE company_id = $1 ORDER BY starts_at DESC",
        company_id,
    )
    result = []
    for w in workshops:
        seats_taken = await conn.fetchval(
            "SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id = $1", w["id"]
        )
        reg = await conn.fetchrow(
            "SELECT status FROM workshop_registrations WHERE workshop_id = $1 AND user_id = $2",
            w["id"], user_id,
        )
        result.append(_ser_workshop(w, seats_taken, reg["status"] if reg else None))
    return result


@router.post("", status_code=201)
async def create_workshop(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    starts_at = datetime.fromisoformat(body["starts_at"])
    ends_at = datetime.fromisoformat(body["ends_at"])
    row = await conn.fetchrow(
        """INSERT INTO workshops (company_id, title, area, description, location,
               starts_at, ends_at, max_seats, status, created_by)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *""",
        company_id, body["title"], body["area"], body.get("description"),
        body.get("location"), starts_at, ends_at,
        body.get("max_seats"), body.get("status", "open"), user_id,
    )
    return _ser_workshop(row)


@router.put("/{workshop_id}")
async def update_workshop(
    workshop_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    starts_at = datetime.fromisoformat(body["starts_at"])
    ends_at = datetime.fromisoformat(body["ends_at"])
    row = await conn.fetchrow(
        """UPDATE workshops
           SET title = $1, area = $2, description = $3, location = $4,
               starts_at = $5, ends_at = $6, max_seats = $7, status = $8
           WHERE id = $9 AND company_id = $10 RETURNING *""",
        body["title"], body["area"], body.get("description"), body.get("location"),
        starts_at, ends_at, body.get("max_seats"), body.get("status", "open"),
        workshop_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Workshop não encontrado")
    seats_taken = await conn.fetchval(
        "SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id = $1", workshop_id
    )
    return _ser_workshop(row, seats_taken)


@router.delete("/{workshop_id}", status_code=204)
async def delete_workshop(
    workshop_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM workshops WHERE id = $1 AND company_id = $2", workshop_id, company_id
    )


# ── Registrations ─────────────────────────────────────────────────────────────

@router.post("/{workshop_id}/register", status_code=201)
async def register(
    workshop_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    workshop = await conn.fetchrow(
        "SELECT * FROM workshops WHERE id = $1 AND company_id = $2", workshop_id, company_id
    )
    if not workshop:
        raise HTTPException(404, "Workshop não encontrado")
    if workshop["status"] != "open":
        raise HTTPException(400, "Inscrições não estão abertas")

    if workshop["max_seats"]:
        seats_taken = await conn.fetchval(
            "SELECT COUNT(*) FROM workshop_registrations WHERE workshop_id = $1", workshop_id
        )
        if seats_taken >= workshop["max_seats"]:
            raise HTTPException(400, "Vagas esgotadas")

    existing = await conn.fetchrow(
        "SELECT id FROM workshop_registrations WHERE workshop_id = $1 AND user_id = $2",
        workshop_id, user_id,
    )
    if existing:
        raise HTTPException(400, "Você já está inscrito")

    await conn.execute(
        "INSERT INTO workshop_registrations (workshop_id, user_id, company_id) VALUES ($1, $2, $3)",
        workshop_id, user_id, company_id,
    )
    return {"ok": True}


@router.delete("/{workshop_id}/register", status_code=204)
async def unregister(
    workshop_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await conn.execute(
        "DELETE FROM workshop_registrations WHERE workshop_id = $1 AND user_id = $2",
        workshop_id, user_id,
    )


@router.get("/{workshop_id}/registrations")
async def get_registrations(
    workshop_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    rows = await conn.fetch(
        """SELECT wr.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM workshop_registrations wr
           JOIN profiles p ON p.user_id = wr.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE wr.workshop_id = $1
           ORDER BY p.name""",
        workshop_id,
    )
    return [_ser_registration(r) for r in rows]


@router.put("/{workshop_id}/attendance")
async def mark_attendance(
    workshop_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    entries = body.get("attendance", [])
    for entry in entries:
        status = "attended" if entry.get("attended") else "absent"
        await conn.execute(
            """UPDATE workshop_registrations SET status = $1
               WHERE workshop_id = $2 AND user_id = $3""",
            status, workshop_id, entry["user_id"],
        )
    return {"ok": True, "updated": len(entries)}
