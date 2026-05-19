from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from datetime import datetime, timezone, date as date_type
import asyncpg
import csv
import io

from app.dependencies import get_db, get_current_user_id

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
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT ec.*, p.name AS user_name, p.email AS user_email, d.name AS department
           FROM employee_courses ec
           JOIN profiles p ON p.user_id = ec.user_id
           LEFT JOIN departments d ON d.id = p.department_id
           WHERE ec.company_id = $1
           ORDER BY p.name, ec.completed_at DESC""",
        company_id,
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

@router.post("/import-csv")
async def import_csv(
    file: UploadFile = File(...),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    content = await file.read()
    text = content.decode("utf-8-sig")  # handle BOM
    reader = csv.DictReader(io.StringIO(text))

    inserted = 0
    errors = []

    for i, row in enumerate(reader, start=2):
        try:
            email = (row.get("email") or "").strip().lower()
            if not email:
                errors.append(f"Linha {i}: email ausente")
                continue

            profile = await conn.fetchrow(
                "SELECT user_id FROM profiles WHERE LOWER(email) = $1 AND company_id = $2",
                email, company_id,
            )
            if not profile:
                errors.append(f"Linha {i}: colaborador '{email}' não encontrado")
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

            await conn.execute(
                """INSERT INTO employee_courses
                       (company_id, user_id, course_title, area, hours, completed_at, source)
                   VALUES ($1, $2, $3, $4, $5, $6, 'csv')""",
                company_id, str(profile["user_id"]), title, area, hours, completed_at,
            )
            inserted += 1
        except Exception as e:
            errors.append(f"Linha {i}: {str(e)}")

    return {"inserted": inserted, "errors": errors}
