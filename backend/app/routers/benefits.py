from fastapi import APIRouter, Depends, HTTPException
from datetime import date as date_type
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/benefits", tags=["benefits"])

DEFAULT_CATALOG = [
    {"name": "Plano de Saúde", "category": "saude", "value_type": "variable", "provider": None},
    {"name": "Plano Odontológico", "category": "saude", "value_type": "variable", "provider": None},
    {"name": "Vale-Refeição", "category": "alimentacao", "value_type": "fixed", "provider": None},
    {"name": "Vale-Alimentação", "category": "alimentacao", "value_type": "fixed", "provider": None},
    {"name": "Vale-Transporte", "category": "transporte", "value_type": "fixed", "provider": None},
    {"name": "Seguro de Vida", "category": "financeiro", "value_type": "info", "provider": None},
    {"name": "Participação nos Lucros (PLR)", "category": "financeiro", "value_type": "percentage", "provider": None},
    {"name": "Auxílio Educação", "category": "educacao", "value_type": "variable", "provider": None},
    {"name": "Gympass / Wellhub", "category": "bem_estar", "value_type": "fixed", "provider": None},
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


async def _ensure_default_catalog(company_id: str, conn: asyncpg.Connection):
    count = await conn.fetchval(
        "SELECT COUNT(*) FROM benefit_catalog WHERE company_id = $1", company_id
    )
    if count == 0:
        for b in DEFAULT_CATALOG:
            await conn.execute(
                "INSERT INTO benefit_catalog (company_id, name, category, value_type, provider) VALUES ($1, $2, $3, $4, $5)",
                company_id, b["name"], b["category"], b["value_type"], b["provider"],
            )


def _ser_catalog(b) -> dict:
    return {
        "id": str(b["id"]),
        "name": b["name"],
        "category": b["category"],
        "description": b["description"],
        "provider": b["provider"],
        "value_type": b["value_type"],
        "value": float(b["value"]) if b["value"] is not None else None,
        "active": b["active"],
        "working_days_adjustment": b.get("working_days_adjustment") or 0,
        "created_at": b["created_at"].isoformat() if b["created_at"] else None,
    }


BENEFIT_JOIN = """
    SELECT eb.*, bc.name AS benefit_name, bc.category AS benefit_category,
           bc.provider AS benefit_provider, bc.value_type, bc.value AS catalog_value,
           bc.working_days_adjustment,
           p.name AS user_name, p.email AS user_email, d.name AS department
    FROM employee_benefits eb
    JOIN benefit_catalog bc ON bc.id = eb.benefit_id
    JOIN profiles p ON p.user_id = eb.user_id
    LEFT JOIN departments d ON d.id = p.department_id
"""


def _ser_assignment(a) -> dict:
    value_override = float(a["value_override"]) if a["value_override"] is not None else None
    catalog_value = float(a["catalog_value"]) if a["catalog_value"] is not None else None
    return {
        "id": str(a["id"]),
        "user_id": str(a["user_id"]),
        "user_name": a.get("user_name"),
        "user_email": a.get("user_email"),
        "department": a.get("department"),
        "benefit_id": str(a["benefit_id"]),
        "benefit_name": a.get("benefit_name"),
        "benefit_category": a.get("benefit_category"),
        "benefit_provider": a.get("benefit_provider"),
        "value_type": a.get("value_type"),
        "value": value_override if value_override is not None else catalog_value,
        "value_override": value_override,
        "ticket_price": float(a["ticket_price"]) if a.get("ticket_price") is not None else None,
        "tickets_per_day": a.get("tickets_per_day"),
        "working_days_adjustment": a.get("working_days_adjustment") or 0,
        "start_date": a["start_date"].isoformat() if a["start_date"] else None,
        "end_date": a["end_date"].isoformat() if a["end_date"] else None,
        "notes": a["notes"],
        "created_at": a["created_at"].isoformat() if a["created_at"] else None,
    }


# ── Catalog ───────────────────────────────────────────────────────────────────

@router.get("/catalog")
async def list_catalog(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)
    await _ensure_default_catalog(company_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM benefit_catalog WHERE company_id = $1 ORDER BY category, name", company_id
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
        """INSERT INTO benefit_catalog (company_id, name, category, description, provider, value_type, value, active, working_days_adjustment)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *""",
        company_id, body["name"], body["category"],
        body.get("description"), body.get("provider"),
        body.get("value_type", "info"),
        body.get("value"),
        body.get("active", True),
        body.get("working_days_adjustment", 0),
    )
    return _ser_catalog(row)


@router.put("/catalog/{benefit_id}")
async def update_catalog_item(
    benefit_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE benefit_catalog
           SET name = COALESCE($1, name),
               category = COALESCE($2, category),
               description = COALESCE($3, description),
               provider = COALESCE($4, provider),
               value_type = COALESCE($5, value_type),
               value = COALESCE($6, value),
               active = COALESCE($7, active),
               working_days_adjustment = COALESCE($8, working_days_adjustment)
           WHERE id = $9 AND company_id = $10 RETURNING *""",
        body.get("name"), body.get("category"),
        body.get("description"), body.get("provider"),
        body.get("value_type"), body.get("value"),
        body.get("active"),
        body.get("working_days_adjustment"),
        benefit_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Benefício não encontrado")
    return _ser_catalog(row)


@router.delete("/catalog/{benefit_id}", status_code=204)
async def delete_catalog_item(
    benefit_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    in_use = await conn.fetchval(
        "SELECT COUNT(*) FROM employee_benefits WHERE benefit_id = $1", benefit_id
    )
    if in_use:
        raise HTTPException(409, "Benefício em uso — remova as atribuições antes de excluir")
    await conn.execute(
        "DELETE FROM benefit_catalog WHERE id = $1 AND company_id = $2", benefit_id, company_id
    )


# ── Assignments ───────────────────────────────────────────────────────────────

@router.get("/team")
async def get_team_benefits(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        BENEFIT_JOIN + " WHERE eb.company_id = $1 ORDER BY p.name, bc.name",
        company_id,
    )
    return [_ser_assignment(r) for r in rows]


@router.get("/employee/{target_user_id}")
async def get_employee_benefits(
    target_user_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    rows = await conn.fetch(
        BENEFIT_JOIN + " WHERE eb.user_id = $1 ORDER BY bc.name",
        target_user_id,
    )
    return [_ser_assignment(r) for r in rows]


@router.get("/my")
async def get_my_benefits(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        BENEFIT_JOIN + " WHERE eb.user_id = $1 AND (eb.end_date IS NULL OR eb.end_date >= CURRENT_DATE) ORDER BY bc.category, bc.name",
        user_id,
    )
    return [_ser_assignment(r) for r in rows]


@router.get("/summary")
async def get_summary(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT bc.id AS benefit_id, bc.name AS benefit_name, bc.category AS benefit_category,
                  COUNT(eb.id) AS employee_count
           FROM benefit_catalog bc
           LEFT JOIN employee_benefits eb ON eb.benefit_id = bc.id
               AND (eb.end_date IS NULL OR eb.end_date >= CURRENT_DATE)
           WHERE bc.company_id = $1
           GROUP BY bc.id, bc.name, bc.category
           ORDER BY bc.category, bc.name""",
        company_id,
    )
    return [
        {
            "benefit_id": str(r["benefit_id"]),
            "benefit_name": r["benefit_name"],
            "benefit_category": r["benefit_category"],
            "employee_count": r["employee_count"],
        }
        for r in rows
    ]


@router.post("/assign", status_code=201)
async def assign_benefit(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    start = date_type.fromisoformat(body.get("start_date", str(date_type.today())))
    end = date_type.fromisoformat(body["end_date"]) if body.get("end_date") else None

    row = await conn.fetchrow(
        """INSERT INTO employee_benefits
               (company_id, user_id, benefit_id, value_override, start_date, end_date, notes, ticket_price, tickets_per_day)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *""",
        company_id, body["user_id"], body["benefit_id"],
        body.get("value_override"), start, end, body.get("notes"),
        body.get("ticket_price"), body.get("tickets_per_day"),
    )
    full = await conn.fetchrow(BENEFIT_JOIN + " WHERE eb.id = $1", row["id"])
    return _ser_assignment(full)


@router.put("/assignment/{assignment_id}")
async def update_assignment(
    assignment_id: str, body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    end = date_type.fromisoformat(body["end_date"]) if body.get("end_date") else None
    row = await conn.fetchrow(
        """UPDATE employee_benefits
           SET value_override = COALESCE($1, value_override),
               end_date = $2,
               notes = COALESCE($3, notes),
               ticket_price = COALESCE($5, ticket_price),
               tickets_per_day = COALESCE($6, tickets_per_day)
           WHERE id = $4 RETURNING *""",
        body.get("value_override"), end, body.get("notes"), assignment_id,
        body.get("ticket_price"), body.get("tickets_per_day"),
    )
    if not row:
        raise HTTPException(404, "Atribuição não encontrada")
    full = await conn.fetchrow(BENEFIT_JOIN + " WHERE eb.id = $1", assignment_id)
    return _ser_assignment(full)


@router.delete("/assignment/{assignment_id}", status_code=204)
async def delete_assignment(
    assignment_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    await conn.execute("DELETE FROM employee_benefits WHERE id = $1", assignment_id)
