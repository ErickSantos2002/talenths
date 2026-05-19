from fastapi import APIRouter, Depends, HTTPException, status
from typing import Optional
from datetime import date
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/career", tags=["career"])


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


def _check_eligibility(score_final, nine_box_quadrant, months_in_level,
                       min_score_final, required_quadrants, min_months) -> bool:
    if min_score_final is not None:
        if score_final is None or float(score_final) < float(min_score_final):
            return False
    if required_quadrants:
        if not nine_box_quadrant or nine_box_quadrant not in required_quadrants:
            return False
    if min_months is not None:
        if months_in_level is None or months_in_level < min_months:
            return False
    return True


# ── Tracks ────────────────────────────────────────────────────────────────────

@router.get("/tracks")
async def list_tracks(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    tracks = await conn.fetch(
        "SELECT id, name, description, created_at FROM career_tracks WHERE company_id = $1 ORDER BY name",
        company_id,
    )
    result = []
    for t in tracks:
        levels = await conn.fetch(
            """SELECT id, name, position, description,
                      min_score_final, required_9box_quadrants, min_months_in_level
               FROM career_levels WHERE track_id = $1 ORDER BY position""",
            t["id"],
        )
        result.append({**dict(t), "levels": [dict(l) for l in levels]})
    return result


@router.post("/tracks", status_code=201)
async def create_track(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """INSERT INTO career_tracks (company_id, name, description, created_by)
           VALUES ($1, $2, $3, $4) RETURNING id, name, description, created_at""",
        company_id, body["name"], body.get("description"), user_id,
    )
    return dict(row)


@router.put("/tracks/{track_id}")
async def update_track(
    track_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE career_tracks SET name = $1, description = $2
           WHERE id = $3 AND company_id = $4
           RETURNING id, name, description""",
        body["name"], body.get("description"), track_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Trilha não encontrada")
    return dict(row)


@router.delete("/tracks/{track_id}", status_code=204)
async def delete_track(
    track_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM career_tracks WHERE id = $1 AND company_id = $2",
        track_id, company_id,
    )


# ── Levels ────────────────────────────────────────────────────────────────────

@router.post("/tracks/{track_id}/levels", status_code=201)
async def create_level(
    track_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    track = await conn.fetchrow(
        "SELECT id FROM career_tracks WHERE id = $1 AND company_id = $2", track_id, company_id,
    )
    if not track:
        raise HTTPException(404, "Trilha não encontrada")

    quadrants = body.get("required_9box_quadrants") or []
    row = await conn.fetchrow(
        """INSERT INTO career_levels
             (track_id, name, position, description, min_score_final, required_9box_quadrants, min_months_in_level)
           VALUES ($1,$2,$3,$4,$5,$6::text[],$7)
           RETURNING id, name, position, description, min_score_final, required_9box_quadrants, min_months_in_level""",
        track_id, body["name"], body["position"], body.get("description"),
        body.get("min_score_final"), quadrants, body.get("min_months_in_level"),
    )
    return dict(row)


@router.put("/levels/{level_id}")
async def update_level(
    level_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    quadrants = body.get("required_9box_quadrants") or []
    row = await conn.fetchrow(
        """UPDATE career_levels cl
           SET name = $1, position = $2, description = $3,
               min_score_final = $4, required_9box_quadrants = $5::text[], min_months_in_level = $6
           FROM career_tracks ct
           WHERE cl.id = $7 AND cl.track_id = ct.id AND ct.company_id = $8
           RETURNING cl.id, cl.name, cl.position, cl.description,
                     cl.min_score_final, cl.required_9box_quadrants, cl.min_months_in_level""",
        body["name"], body["position"], body.get("description"),
        body.get("min_score_final"), quadrants, body.get("min_months_in_level"),
        level_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Nível não encontrado")
    return dict(row)


@router.delete("/levels/{level_id}", status_code=204)
async def delete_level(
    level_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        """DELETE FROM career_levels cl USING career_tracks ct
           WHERE cl.id = $1 AND cl.track_id = ct.id AND ct.company_id = $2""",
        level_id, company_id,
    )


# ── Employee Career Position ───────────────────────────────────────────────────

@router.get("/team")
async def get_team_career(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    rows = await conn.fetch(
        """SELECT
             p.user_id, p.name, p.email,
             d.name AS department,
             ec.id AS career_id,
             ec.track_id, ct.name AS track_name,
             ec.level_id, cl.name AS level_name, cl.position AS level_position,
             ec.started_at,
             cl.min_score_final, cl.required_9box_quadrants, cl.min_months_in_level,
             cs.score_final, cs.nine_box_quadrant
           FROM profiles p
           LEFT JOIN departments d ON p.department_id = d.id
           LEFT JOIN employee_career ec ON ec.user_id = p.user_id AND ec.company_id = p.company_id
           LEFT JOIN career_tracks ct ON ct.id = ec.track_id
           LEFT JOIN career_levels cl ON cl.id = ec.level_id
           LEFT JOIN LATERAL (
             SELECT score_final, nine_box_quadrant
             FROM consolidated_scores
             WHERE user_id = p.user_id AND company_id = p.company_id
             ORDER BY computed_at DESC LIMIT 1
           ) cs ON true
           WHERE p.company_id = $1
           ORDER BY p.name""",
        company_id,
    )

    result = []
    for r in rows:
        months_in_level = None
        if r["started_at"]:
            today = date.today()
            started = r["started_at"]
            months_in_level = (today.year - started.year) * 12 + (today.month - started.month)

        eligible = _check_eligibility(
            score_final=r["score_final"],
            nine_box_quadrant=r["nine_box_quadrant"],
            months_in_level=months_in_level,
            min_score_final=r["min_score_final"],
            required_quadrants=list(r["required_9box_quadrants"]) if r["required_9box_quadrants"] else [],
            min_months=r["min_months_in_level"],
        )

        result.append({
            "user_id": str(r["user_id"]),
            "name": r["name"],
            "email": r["email"],
            "department": r["department"],
            "career_id": str(r["career_id"]) if r["career_id"] else None,
            "track_id": str(r["track_id"]) if r["track_id"] else None,
            "track_name": r["track_name"],
            "level_id": str(r["level_id"]) if r["level_id"] else None,
            "level_name": r["level_name"],
            "level_position": r["level_position"],
            "started_at": r["started_at"].isoformat() if r["started_at"] else None,
            "months_in_level": months_in_level,
            "score_final": float(r["score_final"]) if r["score_final"] is not None else None,
            "nine_box_quadrant": r["nine_box_quadrant"],
            "eligible_for_next": eligible,
        })
    return result


@router.get("/my")
async def get_my_career(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    row = await conn.fetchrow(
        """SELECT
             ec.id, ec.track_id, ct.name AS track_name, ct.description AS track_description,
             ec.level_id, cl.name AS level_name, cl.position AS level_position,
             cl.description AS level_description,
             cl.min_score_final, cl.required_9box_quadrants, cl.min_months_in_level,
             ec.started_at, ec.notes,
             cs.score_final, cs.nine_box_quadrant
           FROM employee_career ec
           JOIN career_tracks ct ON ct.id = ec.track_id
           JOIN career_levels cl ON cl.id = ec.level_id
           LEFT JOIN LATERAL (
             SELECT score_final, nine_box_quadrant
             FROM consolidated_scores
             WHERE user_id = $1 AND company_id = $2
             ORDER BY computed_at DESC LIMIT 1
           ) cs ON true
           WHERE ec.user_id = $1 AND ec.company_id = $2""",
        user_id, company_id,
    )

    if not row:
        return None

    next_level = await conn.fetchrow(
        """SELECT id, name, position, description,
                  min_score_final, required_9box_quadrants, min_months_in_level
           FROM career_levels
           WHERE track_id = $1 AND position = $2
           LIMIT 1""",
        row["track_id"], (row["level_position"] or 0) + 1,
    )

    months_in_level = None
    if row["started_at"]:
        today = date.today()
        started = row["started_at"]
        months_in_level = (today.year - started.year) * 12 + (today.month - started.month)

    eligible = _check_eligibility(
        score_final=row["score_final"],
        nine_box_quadrant=row["nine_box_quadrant"],
        months_in_level=months_in_level,
        min_score_final=next_level["min_score_final"] if next_level else None,
        required_quadrants=list(next_level["required_9box_quadrants"]) if next_level and next_level["required_9box_quadrants"] else [],
        min_months=next_level["min_months_in_level"] if next_level else None,
    )

    return {
        "track_id": str(row["track_id"]),
        "track_name": row["track_name"],
        "track_description": row["track_description"],
        "level_id": str(row["level_id"]),
        "level_name": row["level_name"],
        "level_position": row["level_position"],
        "level_description": row["level_description"],
        "started_at": row["started_at"].isoformat() if row["started_at"] else None,
        "months_in_level": months_in_level,
        "notes": row["notes"],
        "score_final": float(row["score_final"]) if row["score_final"] is not None else None,
        "nine_box_quadrant": row["nine_box_quadrant"],
        "next_level": dict(next_level) if next_level else None,
        "eligible_for_next": eligible,
    }


@router.put("/employee/{target_user_id}")
async def set_employee_career(
    target_user_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    started_at_raw = body.get("started_at") or date.today().isoformat()
    from datetime import date as date_type
    started_at = date_type.fromisoformat(started_at_raw) if isinstance(started_at_raw, str) else started_at_raw

    await conn.execute(
        """INSERT INTO employee_career (user_id, company_id, track_id, level_id, started_at, promoted_by, notes)
           VALUES ($1, $2, $3, $4, $5, $6, $7)
           ON CONFLICT (user_id, company_id) DO UPDATE
             SET track_id = EXCLUDED.track_id,
                 level_id = EXCLUDED.level_id,
                 started_at = EXCLUDED.started_at,
                 promoted_by = EXCLUDED.promoted_by,
                 notes = EXCLUDED.notes""",
        target_user_id, company_id, body["track_id"], body["level_id"],
        started_at, user_id, body.get("notes"),
    )
    return {"ok": True}
