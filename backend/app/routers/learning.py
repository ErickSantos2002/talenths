from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from datetime import datetime, timezone, date as date_type
import asyncpg
import csv
import io

from app.dependencies import get_db, get_current_user_id
from app.learning_import import decode, is_platform, parse_platform
from app.roster import active_unless, ensure_active_targets, iso_or_none

router = APIRouter(prefix="/learning", tags=["learning"])


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


def _ser_catalog(r) -> dict:
    return {
        "id": str(r["id"]),
        "title": r["title"],
        "area": r["area"],
        "description": r["description"],
        "duration_hours": float(r["duration_hours"]),
        "created_at": r["created_at"].isoformat() if r["created_at"] else None,
    }


def _ser_course(r) -> dict:
    return {
        "id": str(r["id"]),
        "user_id": str(r["user_id"]),
        "user_name": r.get("user_name"),
        "user_email": r.get("user_email"),
        "department": r.get("department"),
        "deactivated_at": iso_or_none(r.get("deactivated_at")),
        "catalog_id": str(r["catalog_id"]) if r["catalog_id"] else None,
        "course_title": r["course_title"],
        "area": r["area"],
        "hours": float(r["hours"]),
        "completed_at": r["completed_at"].isoformat() if r["completed_at"] else None,
        "source": r["source"],
        "created_at": r["created_at"].isoformat() if r["created_at"] else None,
    }


# ── Catalog ───────────────────────────────────────────────────────────────────

@router.get("/catalog")
async def list_catalog(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM course_catalog WHERE company_id = $1 ORDER BY area, title",
        company_id,
    )
    return [_ser_catalog(r) for r in rows]


@router.post("/catalog", status_code=201)
async def create_catalog_item(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """INSERT INTO course_catalog (company_id, title, area, description, duration_hours, created_by)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        company_id, body["title"], body["area"],
        body.get("description"), float(body.get("duration_hours", 0)), user_id,
    )
    return _ser_catalog(row)


@router.put("/catalog/{item_id}")
async def update_catalog_item(
    item_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE course_catalog SET title = $1, area = $2, description = $3, duration_hours = $4
           WHERE id = $5 AND company_id = $6 RETURNING *""",
        body["title"], body["area"], body.get("description"),
        float(body.get("duration_hours", 0)), item_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Curso não encontrado")
    return _ser_catalog(row)


@router.delete("/catalog/{item_id}", status_code=204)
async def delete_catalog_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM course_catalog WHERE id = $1 AND company_id = $2",
        item_id, company_id,
    )


# ── Employee Courses ──────────────────────────────────────────────────────────

@router.get("/my")
async def get_my_courses(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT ec.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM employee_courses ec
           JOIN profiles p ON p.user_id = ec.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE ec.user_id = $1 AND ec.company_id = $2
           ORDER BY ec.completed_at DESC""",
        user_id, company_id,
    )
    return [_ser_course(r) for r in rows]


@router.get("/team")
async def get_team_courses(
    include_inactive: bool = False,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        f"""SELECT ec.*, p.name AS user_name, p.email AS user_email, p.deactivated_at,
                   d.name AS department
            FROM employee_courses ec
            JOIN profiles p ON p.user_id = ec.user_id
            LEFT JOIN departments d ON d.id = p.department_id
            WHERE ec.company_id = $1 AND {active_unless("p", 2)}
            ORDER BY p.name, ec.completed_at DESC""",
        company_id, include_inactive,
    )
    return [_ser_course(r) for r in rows]


@router.post("/employee/{target_user_id}", status_code=201)
async def add_employee_course(
    target_user_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await ensure_active_targets(conn, [target_user_id])
    completed_at = date_type.fromisoformat(body["completed_at"]) if body.get("completed_at") else date_type.today()
    row = await conn.fetchrow(
        """INSERT INTO employee_courses
               (company_id, user_id, catalog_id, course_title, area, hours, completed_at, source)
           VALUES ($1, $2, $3, $4, $5, $6, $7, 'manual')
           RETURNING *""",
        company_id, target_user_id,
        body.get("catalog_id"), body["course_title"], body["area"],
        float(body.get("hours", 0)), completed_at,
    )
    full = await conn.fetchrow(
        """SELECT ec.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM employee_courses ec
           JOIN profiles p ON p.user_id = ec.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE ec.id = $1""",
        row["id"],
    )
    return _ser_course(full)


@router.delete("/employee/course/{course_id}", status_code=204)
async def delete_employee_course(
    course_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM employee_courses WHERE id = $1 AND company_id = $2",
        course_id, company_id,
    )


# ── CSV Import ────────────────────────────────────────────────────────────────

async def _find_person(conn: asyncpg.Connection, company_id: str, email: str, cpf_digits: str = ""):
    profile = await conn.fetchrow(
        "SELECT user_id, deactivated_at FROM profiles WHERE LOWER(email) = $1 AND company_id = $2",
        email, company_id,
    ) if email else None
    if not profile and cpf_digits:
        profile = await conn.fetchrow(
            """SELECT user_id, deactivated_at FROM profiles
               WHERE regexp_replace(cpf, '\\D', '', 'g') = $1 AND company_id = $2""",
            cpf_digits, company_id,
        )
    return profile


async def _import_platform(rows, company_id: str, user_id: str, conn: asyncpg.Connection) -> dict:
    updated = completed = 0
    errors = []
    for row in rows:
        who = row.email or row.name or "sem e-mail"
        if row.error:
            errors.append(f"Linha {row.line}: {row.error}")
            continue
        profile = await _find_person(conn, company_id, row.email, row.cpf_digits)
        if not profile:
            errors.append(f"Linha {row.line}: colaborador '{who}' não encontrado")
            continue
        if profile["deactivated_at"] is not None:
            errors.append(f"Linha {row.line}: colaborador '{who}' desligado")
            continue
        try:
            # Savepoint por linha: um erro aqui não aborta a transação da importação inteira.
            async with conn.transaction():
                track = await conn.fetchrow(
                    """INSERT INTO learning_track_progress
                         (company_id, user_id, external_track_id, track_name, group_name, courses,
                          started_at, finished_at, progress_pct, score_pct, imported_at, imported_by)
                       VALUES ($1, $2, $3, $4, $5, $6,
                               $7::timestamp AT TIME ZONE 'America/Sao_Paulo',
                               $8::timestamp AT TIME ZONE 'America/Sao_Paulo', $9, $10, now(), $11)
                       ON CONFLICT (company_id, user_id, external_track_id) DO UPDATE SET
                         track_name = EXCLUDED.track_name, group_name = EXCLUDED.group_name,
                         courses = EXCLUDED.courses, started_at = EXCLUDED.started_at,
                         finished_at = EXCLUDED.finished_at, progress_pct = EXCLUDED.progress_pct,
                         score_pct = EXCLUDED.score_pct, imported_at = now(), imported_by = EXCLUDED.imported_by
                       RETURNING id, course_registered_at""",
                    company_id, profile["user_id"], row.external_track_id, row.track_name, row.group or None,
                    row.courses, row.started_at, row.finished_at, row.progress_pct, row.score_pct, user_id,
                )
                if row.finished_at and track["course_registered_at"] is None:
                    course_id = await conn.fetchval(
                        """INSERT INTO employee_courses (company_id, user_id, course_title, area, hours, completed_at, source)
                           VALUES ($1, $2, $3, $4, 0, $5, 'csv') RETURNING id""",
                        company_id, profile["user_id"], row.track_name, row.group or row.track_name,
                        row.finished_at.date(),
                    )
                    await conn.execute(
                        """UPDATE learning_track_progress SET employee_course_id = $2, course_registered_at = now()
                           WHERE id = $1""",
                        track["id"], course_id,
                    )
                    completed += 1
            updated += 1
        except Exception as e:
            errors.append(f"Linha {row.line}: {str(e)}")
    return {"format": "plataforma", "inserted": completed, "tracks_updated": updated,
            "tracks_completed": completed, "errors": errors}


@router.post("/import-csv")
async def import_csv(
    file: UploadFile = File(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    text = decode(await file.read())
    first_line = text.split("\n", 1)[0]
    if is_platform(first_line.strip().split(";")):
        return await _import_platform(parse_platform(text), company_id, user_id, conn)

    reader = csv.DictReader(io.StringIO(text))

    inserted = 0
    errors = []

    for i, row in enumerate(reader, start=2):
        try:
            email = (row.get("email") or "").strip().lower()
            if not email:
                errors.append(f"Linha {i}: email ausente")
                continue

            profile = await _find_person(conn, company_id, email)
            if not profile:
                errors.append(f"Linha {i}: colaborador '{email}' não encontrado")
                continue
            if profile["deactivated_at"] is not None:
                errors.append(f"Linha {i}: colaborador '{email}' desligado")
                continue

            title = (row.get("titulo") or row.get("title") or "").strip()
            area = (row.get("area") or "").strip()
            hours_raw = (row.get("horas") or row.get("hours") or "0").strip().replace(",", ".")
            date_raw = (row.get("data") or row.get("completed_at") or "").strip()

            if not title or not area:
                errors.append(f"Linha {i}: título ou área ausente")
                continue

            hours = float(hours_raw) if hours_raw else 0.0
            completed_at = date_type.fromisoformat(date_raw) if date_raw else date_type.today()

            async with conn.transaction():
                await conn.execute(
                    """INSERT INTO employee_courses
                           (company_id, user_id, course_title, area, hours, completed_at, source)
                       VALUES ($1, $2, $3, $4, $5, $6, 'csv')""",
                    company_id, str(profile["user_id"]), title, area, hours, completed_at,
                )
            inserted += 1
        except Exception as e:
            errors.append(f"Linha {i}: {str(e)}")

    return {"format": "padrao", "inserted": inserted, "tracks_updated": 0, "tracks_completed": 0, "errors": errors}


def _ser_track(r) -> dict:
    return {
        "id": str(r["id"]),
        "user_id": str(r["user_id"]),
        "user_name": r.get("user_name"),
        "department": r.get("department"),
        "deactivated_at": iso_or_none(r.get("deactivated_at")),
        "track_name": r["track_name"],
        "group_name": r["group_name"],
        "courses": r["courses"] or "",
        "started_at": iso_or_none(r["started_at"]),
        "finished_at": iso_or_none(r["finished_at"]),
        "progress_pct": float(r["progress_pct"]),
        "score_pct": float(r["score_pct"]) if r["score_pct"] is not None else None,
        "imported_at": iso_or_none(r["imported_at"]),
    }


@router.get("/team-tracks")
async def get_team_tracks(
    include_inactive: bool = False,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        f"""SELECT t.*, p.name AS user_name, p.deactivated_at, d.name AS department
            FROM learning_track_progress t
            JOIN profiles p ON p.user_id = t.user_id
            LEFT JOIN departments d ON d.id = p.department_id
            WHERE t.company_id = $1 AND t.finished_at IS NULL AND {active_unless("p", 2)}
            ORDER BY p.name, t.track_name""",
        company_id, include_inactive,
    )
    return [_ser_track(r) for r in rows]


@router.get("/my-tracks")
async def get_my_tracks(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        """SELECT * FROM learning_track_progress
           WHERE user_id = $1 AND finished_at IS NULL ORDER BY track_name""",
        user_id,
    )
    return [_ser_track(r) for r in rows]
