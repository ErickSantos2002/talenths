from fastapi import APIRouter, Depends, HTTPException
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/salary", tags=["salary"])


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


def _compute_positioning(current_salary, band_90, band_95, band_100, band_105, band_110):
    if band_100 == 0:
        return {"band": None, "pct_of_median": None, "deviation": None, "is_above_max": False, "is_below_min": False}
    pct = (current_salary / band_100) * 100
    deviation = current_salary - band_100
    if pct < 92.5:
        band = "abaixo_minimo"
    elif pct < 97.5:
        band = "band_90"
    elif pct < 102.5:
        band = "mediana"
    elif pct < 107.5:
        band = "band_105"
    else:
        band = "maximo_ou_acima"
    return {
        "pct_of_median": round(pct, 1),
        "deviation": round(deviation, 2),
        "band": band,
        "is_above_max": current_salary > band_110,
        "is_below_min": current_salary < band_90,
    }


def _ser_reference(r) -> dict:
    return {
        "id": str(r["id"]),
        "name": r["name"],
        "market": r["market"],
        "region": r["region"],
        "reference_year": r["reference_year"],
        "is_active": r["is_active"],
        "created_at": r["created_at"].isoformat() if r["created_at"] else None,
    }


def _ser_entry(e) -> dict:
    return {
        "id": str(e["id"]),
        "reference_id": str(e["reference_id"]),
        "job_family": e["job_family"],
        "seniority": e["seniority"],
        "band_90": float(e["band_90"]),
        "band_95": float(e["band_95"]),
        "band_100": float(e["band_100"]),
        "band_105": float(e["band_105"]),
        "band_110": float(e["band_110"]),
    }


# ── References ────────────────────────────────────────────────────────────────

@router.get("/references")
async def list_references(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        "SELECT * FROM public.salary_market_references WHERE company_id = $1 ORDER BY reference_year DESC, name",
        company_id,
    )
    return [_ser_reference(r) for r in rows]


@router.post("/references", status_code=201)
async def create_reference(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """INSERT INTO public.salary_market_references (company_id, name, market, region, reference_year, is_active)
           VALUES ($1, $2, $3, $4, $5, $6) RETURNING *""",
        company_id,
        body["name"],
        body["market"],
        body["region"],
        int(body["reference_year"]),
        body.get("is_active", True),
    )
    return _ser_reference(row)


@router.put("/references/{ref_id}")
async def update_reference(
    ref_id: str,
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    row = await conn.fetchrow(
        """UPDATE public.salary_market_references
           SET name = COALESCE($1, name),
               market = COALESCE($2, market),
               region = COALESCE($3, region),
               reference_year = COALESCE($4, reference_year),
               is_active = COALESCE($5, is_active),
               updated_at = now()
           WHERE id = $6 AND company_id = $7 RETURNING *""",
        body.get("name"),
        body.get("market"),
        body.get("region"),
        int(body["reference_year"]) if body.get("reference_year") is not None else None,
        body.get("is_active"),
        ref_id,
        company_id,
    )
    if not row:
        raise HTTPException(404, "Referência não encontrada")
    return _ser_reference(row)


@router.delete("/references/{ref_id}", status_code=204)
async def delete_reference(
    ref_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        "DELETE FROM public.salary_market_references WHERE id = $1 AND company_id = $2",
        ref_id,
        company_id,
    )


# ── Table entries ─────────────────────────────────────────────────────────────

@router.get("/table")
async def list_entries(
    reference_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    rows = await conn.fetch(
        """SELECT * FROM public.salary_table_entries
           WHERE reference_id = $1 AND company_id = $2
           ORDER BY job_family, seniority""",
        reference_id,
        company_id,
    )
    return [_ser_entry(r) for r in rows]


@router.post("/table", status_code=201)
async def upsert_entries(
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    reference_id = body["reference_id"]
    entries = body.get("entries", [])

    for e in entries:
        b90, b95, b100, b105, b110 = (
            float(e["band_90"]), float(e["band_95"]), float(e["band_100"]),
            float(e["band_105"]), float(e["band_110"]),
        )
        if not (b90 < b95 < b100 < b105 < b110):
            raise HTTPException(
                422,
                f"Bandas inválidas para {e['job_family']} {e['seniority']}: devem ser crescentes (90 < 95 < 100 < 105 < 110)",
            )

    async with conn.transaction():
        await conn.execute(
            "DELETE FROM public.salary_table_entries WHERE reference_id = $1 AND company_id = $2",
            reference_id, company_id,
        )
        result = []
        for e in entries:
            row = await conn.fetchrow(
                """INSERT INTO public.salary_table_entries
                       (reference_id, company_id, job_family, seniority, band_90, band_95, band_100, band_105, band_110)
                   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *""",
                reference_id, company_id,
                e["job_family"], e["seniority"],
                float(e["band_90"]), float(e["band_95"]), float(e["band_100"]),
                float(e["band_105"]), float(e["band_110"]),
            )
            result.append(_ser_entry(row))
    return result


@router.put("/table/{entry_id}")
async def update_entry(
    entry_id: str,
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    b90 = float(body["band_90"])
    b95 = float(body["band_95"])
    b100 = float(body["band_100"])
    b105 = float(body["band_105"])
    b110 = float(body["band_110"])
    if not (b90 < b95 < b100 < b105 < b110):
        raise HTTPException(422, "Bandas inválidas: devem ser crescentes (90 < 95 < 100 < 105 < 110)")
    row = await conn.fetchrow(
        """UPDATE public.salary_table_entries
           SET band_90 = $1, band_95 = $2, band_100 = $3, band_105 = $4, band_110 = $5, updated_at = now()
           WHERE id = $6 AND company_id = $7 RETURNING *""",
        b90, b95, b100, b105, b110, entry_id, company_id,
    )
    if not row:
        raise HTTPException(404, "Entrada não encontrada")
    return _ser_entry(row)


# ── Positioning ───────────────────────────────────────────────────────────────

@router.get("/positioning")
async def get_positioning(
    reference_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    ref_row = await conn.fetchrow(
        "SELECT id FROM public.salary_market_references WHERE id = $1 AND company_id = $2",
        reference_id, company_id,
    )
    if not ref_row:
        raise HTTPException(404, "Referência não encontrada")
    rows = await conn.fetch(
        """SELECT p.user_id, p.name, p.current_salary, p.job_family, p.seniority,
                  d.name AS department,
                  e.band_90, e.band_95, e.band_100, e.band_105, e.band_110
           FROM public.profiles p
           LEFT JOIN public.departments d ON d.id = p.department_id
           LEFT JOIN public.salary_table_entries e
               ON e.reference_id = $2
               AND e.job_family = p.job_family
               AND e.seniority = p.seniority
               AND e.company_id = p.company_id
           WHERE p.company_id = $1
           ORDER BY p.name""",
        company_id, reference_id,
    )

    result = []
    for r in rows:
        pos = {}
        if r["current_salary"] is not None and r["band_100"] is not None:
            pos = _compute_positioning(
                float(r["current_salary"]),
                float(r["band_90"]),
                float(r["band_95"]),
                float(r["band_100"]),
                float(r["band_105"]),
                float(r["band_110"]),
            )
        result.append({
            "user_id": str(r["user_id"]),
            "name": r["name"],
            "department": r["department"],
            "job_family": r["job_family"],
            "seniority": r["seniority"],
            "current_salary": float(r["current_salary"]) if r["current_salary"] is not None else None,
            "band_90": float(r["band_90"]) if r["band_90"] is not None else None,
            "band_95": float(r["band_95"]) if r["band_95"] is not None else None,
            "band_100": float(r["band_100"]) if r["band_100"] is not None else None,
            "band_105": float(r["band_105"]) if r["band_105"] is not None else None,
            "band_110": float(r["band_110"]) if r["band_110"] is not None else None,
            **pos,
        })
    return result


# ── Employee salary update ────────────────────────────────────────────────────

@router.patch("/employee/{profile_id}")
async def update_employee_salary(
    profile_id: str,
    body: dict,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)
    await conn.execute(
        """UPDATE public.profiles
           SET current_salary = COALESCE($1, current_salary),
               job_family = COALESCE($2, job_family),
               seniority = COALESCE($3, seniority)
           WHERE user_id = $4 AND company_id = $5""",
        body.get("current_salary"),
        body.get("job_family"),
        body.get("seniority"),
        profile_id,
        company_id,
    )
    return {"ok": True}
