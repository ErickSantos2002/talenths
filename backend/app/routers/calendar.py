from fastapi import APIRouter, Depends, HTTPException
from datetime import date as date_type
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/calendar", tags=["calendar"])


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


def _ser_event(e) -> dict:
    return {
        "id": str(e["id"]),
        "title": e["title"],
        "description": e["description"],
        "event_type": e["event_type"],
        "color": e["color"],
        "start_date": e["start_date"].isoformat() if e["start_date"] else None,
        "end_date": e["end_date"].isoformat() if e["end_date"] else None,
        "all_day": e["all_day"],
        "created_by": str(e["created_by"]),
        "created_at": e["created_at"].isoformat() if e["created_at"] else None,
    }


EVENT_COLORS = {
    "event": "#6366f1",
    "holiday": "#ef4444",
    "deadline": "#f59e0b",
    "meeting": "#3b82f6",
    "training": "#10b981",
}


# ── Events ────────────────────────────────────────────────────────────────────

@router.get("/events")
async def list_events(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM calendar_events WHERE company_id = $1 ORDER BY start_date, title",
        company_id,
    )
    return [_ser_event(r) for r in rows]


@router.post("/events", status_code=201)
async def create_event(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    event_type = body.get("event_type", "event")
    start = date_type.fromisoformat(body["start_date"])
    end = date_type.fromisoformat(body.get("end_date", body["start_date"]))
    if end < start:
        raise HTTPException(400, "Data de fim deve ser após a data de início")
    color = body.get("color") or EVENT_COLORS.get(event_type, "#6366f1")
    row = await conn.fetchrow(
        """INSERT INTO calendar_events
               (company_id, title, description, event_type, color, start_date, end_date, all_day, created_by)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *""",
        company_id, body["title"], body.get("description"),
        event_type, color, start, end, body.get("all_day", True), user_id,
    )
    return _ser_event(row)


@router.put("/events/{event_id}")
async def update_event(
    event_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    start = date_type.fromisoformat(body["start_date"]) if body.get("start_date") else None
    end = date_type.fromisoformat(body["end_date"]) if body.get("end_date") else None
    row = await conn.fetchrow(
        """UPDATE calendar_events
           SET title = COALESCE($1, title),
               description = COALESCE($2, description),
               event_type = COALESCE($3, event_type),
               color = COALESCE($4, color),
               start_date = COALESCE($5, start_date),
               end_date = COALESCE($6, end_date),
               all_day = COALESCE($7, all_day)
           WHERE id = $8 AND company_id = $9 RETURNING *""",
        body.get("title"), body.get("description"), body.get("event_type"),
        body.get("color"), start, end, body.get("all_day"),
        event_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Evento não encontrado")
    return _ser_event(row)


@router.delete("/events/{event_id}", status_code=204)
async def delete_event(
    event_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM calendar_events WHERE id = $1 AND company_id = $2", event_id, company_id
    )


# ── Combined feed (events + absences + birthdays) ─────────────────────────────

@router.get("/feed")
async def get_feed(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    events = await conn.fetch(
        "SELECT * FROM calendar_events WHERE company_id = $1 ORDER BY start_date",
        company_id,
    )

    is_manager = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )

    if is_manager:
        absences = await conn.fetch(
            """SELECT ar.id, ar.start_date, ar.end_date, ar.days,
                      p.name AS user_name, at.name AS type_name, at.color
               FROM absence_requests ar
               JOIN profiles p ON p.user_id = ar.user_id
               JOIN absence_types at ON at.id = ar.type_id
               WHERE ar.company_id = $1 AND ar.status = 'approved'
               ORDER BY ar.start_date""",
            company_id,
        )
    else:
        absences = await conn.fetch(
            """SELECT ar.id, ar.start_date, ar.end_date, ar.days,
                      p.name AS user_name, at.name AS type_name, at.color
               FROM absence_requests ar
               JOIN profiles p ON p.user_id = ar.user_id
               JOIN absence_types at ON at.id = ar.type_id
               WHERE ar.user_id = $1 AND ar.status = 'approved'
               ORDER BY ar.start_date""",
            user_id,
        )

    birthdays = await conn.fetch(
        """SELECT p.name, p.birth_date
           FROM profiles p
           WHERE p.company_id = $1 AND p.birth_date IS NOT NULL
           ORDER BY EXTRACT(MONTH FROM p.birth_date), EXTRACT(DAY FROM p.birth_date)""",
        company_id,
    )

    result = []

    for e in events:
        result.append({
            "id": str(e["id"]),
            "source": "event",
            "title": e["title"],
            "description": e["description"],
            "event_type": e["event_type"],
            "color": e["color"],
            "start_date": e["start_date"].isoformat(),
            "end_date": e["end_date"].isoformat(),
        })

    for a in absences:
        result.append({
            "id": str(a["id"]),
            "source": "absence",
            "title": f"{a['user_name']} — {a['type_name']}",
            "description": f"{a['days']} dias",
            "event_type": "absence",
            "color": a["color"] or "#6b7280",
            "start_date": a["start_date"].isoformat(),
            "end_date": a["end_date"].isoformat(),
        })

    for b in birthdays:
        bd = b["birth_date"]
        result.append({
            "id": f"birthday-{b['name']}",
            "source": "birthday",
            "title": f"🎂 Aniversário: {b['name']}",
            "description": None,
            "event_type": "birthday",
            "color": "#ec4899",
            "start_date": f"{bd.month:02d}-{bd.day:02d}",
            "end_date": f"{bd.month:02d}-{bd.day:02d}",
            "recurring_monthly": True,
        })

    return result
