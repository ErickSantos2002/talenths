from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone, date as date_type
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/communications", tags=["communications"])


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


def _ser_announcement(a) -> dict:
    return {
        "id": str(a["id"]),
        "title": a["title"],
        "content": a["content"],
        "category": a["category"],
        "status": a["status"],
        "published_at": a["published_at"].isoformat() if a["published_at"] else None,
        "created_at": a["created_at"].isoformat() if a["created_at"] else None,
        "updated_at": a["updated_at"].isoformat() if a["updated_at"] else None,
    }


# ── Announcements ─────────────────────────────────────────────────────────────

@router.get("/announcements")
async def list_announcements(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    # managers see all; regular users only see published
    is_manager = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if is_manager:
        rows = await conn.fetch(
            "SELECT * FROM announcements WHERE company_id = $1 ORDER BY created_at DESC",
            company_id,
        )
    else:
        rows = await conn.fetch(
            "SELECT * FROM announcements WHERE company_id = $1 AND status = 'published' ORDER BY published_at DESC",
            company_id,
        )
    return [_ser_announcement(r) for r in rows]


@router.post("/announcements", status_code=201)
async def create_announcement(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    status = body.get("status", "draft")
    published_at = datetime.now(timezone.utc) if status == "published" else None

    row = await conn.fetchrow(
        """INSERT INTO announcements
               (company_id, title, content, category, status, published_at, created_by)
           VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *""",
        company_id, body["title"], body["content"],
        body.get("category", "geral"), status, published_at, user_id,
    )
    return _ser_announcement(row)


@router.put("/announcements/{announcement_id}")
async def update_announcement(
    announcement_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    now = datetime.now(timezone.utc)
    status = body.get("status", "draft")

    existing = await conn.fetchrow(
        "SELECT published_at, status FROM announcements WHERE id = $1 AND company_id = $2",
        announcement_id, company_id,
    )
    if not existing:
        raise HTTPException(404, "Comunicado não encontrado")

    published_at = existing["published_at"]
    if status == "published" and not published_at:
        published_at = now

    row = await conn.fetchrow(
        """UPDATE announcements
           SET title = $1, content = $2, category = $3, status = $4,
               published_at = $5, updated_at = $6
           WHERE id = $7 AND company_id = $8 RETURNING *""",
        body["title"], body["content"], body.get("category", "geral"),
        status, published_at, now, announcement_id, company_id,
    )
    return _ser_announcement(row)


@router.delete("/announcements/{announcement_id}", status_code=204)
async def delete_announcement(
    announcement_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM announcements WHERE id = $1 AND company_id = $2",
        announcement_id, company_id,
    )


# ── Birthdays ─────────────────────────────────────────────────────────────────

@router.get("/birthdays")
async def get_birthdays(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    today = date_type.today()
    rows = await conn.fetch(
        """SELECT p.user_id, p.name, p.email, p.birth_date, d.name AS department
           FROM profiles p
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE p.company_id = $1
             AND p.birth_date IS NOT NULL
             AND EXTRACT(MONTH FROM p.birth_date) = $2
           ORDER BY EXTRACT(DAY FROM p.birth_date)""",
        company_id, today.month,
    )
    return [
        {
            "user_id": str(r["user_id"]),
            "name": r["name"],
            "email": r["email"],
            "department": r["department"],
            "birth_date": r["birth_date"].isoformat(),
            "day": r["birth_date"].day,
            "is_today": r["birth_date"].day == today.day,
        }
        for r in rows
    ]


# ── Work Milestones ────────────────────────────────────────────────────────────

@router.get("/milestones")
async def get_milestones(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    today = date_type.today()
    rows = await conn.fetch(
        """SELECT p.user_id, p.name, p.email, p.hire_date, d.name AS department
           FROM profiles p
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE p.company_id = $1
             AND p.hire_date IS NOT NULL
             AND EXTRACT(MONTH FROM p.hire_date) = $2
           ORDER BY EXTRACT(DAY FROM p.hire_date)""",
        company_id, today.month,
    )
    result = []
    for r in rows:
        years = today.year - r["hire_date"].year
        if years <= 0:
            continue
        result.append({
            "user_id": str(r["user_id"]),
            "name": r["name"],
            "email": r["email"],
            "department": r["department"],
            "hire_date": r["hire_date"].isoformat(),
            "years": years,
            "day": r["hire_date"].day,
            "is_today": r["hire_date"].day == today.day and r["hire_date"].month == today.month,
        })
    return result
