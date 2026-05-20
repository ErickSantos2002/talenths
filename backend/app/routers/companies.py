from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, field_validator
from typing import Optional, List, Union
import asyncpg
import json

from app.dependencies import get_db, get_current_user_id, require_master_admin, require_manager

router = APIRouter(prefix="/companies", tags=["companies"])


class CompanyCreate(BaseModel):
    name: str
    cnpj: Optional[str] = None
    status: str = "active"


class CompanyUpdate(BaseModel):
    name: Optional[str] = None
    cnpj: Optional[str] = None
    status: Optional[str] = None


class PresentationValue(BaseModel):
    title: str
    description: str = ""


class PresentationUpdate(BaseModel):
    presentation_mission: Optional[str] = None
    presentation_vision: Optional[str] = None
    presentation_history: Optional[str] = None
    presentation_cover_url: Optional[str] = None
    presentation_values: Optional[List[Union[PresentationValue, str]]] = None

    @field_validator("presentation_values", mode="before")
    @classmethod
    def coerce_values(cls, v):
        if not v:
            return v
        return [{"title": item, "description": ""} if isinstance(item, str) else item for item in v]


class InternalRule(BaseModel):
    title: str
    content: str


class InternalRulesUpdate(BaseModel):
    rules: List[InternalRule]


# ── Static routes first (must come before /{company_id}) ──────────────────────

@router.get("")
async def list_companies(conn: asyncpg.Connection = Depends(get_db)):
    rows = await conn.fetch(
        "SELECT * FROM public.companies ORDER BY created_at DESC"
    )
    return [dict(r) for r in rows]


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_company(body: CompanyCreate, conn: asyncpg.Connection = Depends(get_db)):
    row = await conn.fetchrow(
        "INSERT INTO public.companies (name, cnpj, status) VALUES ($1, $2, $3) RETURNING *",
        body.name, body.cnpj, body.status,
    )
    return dict(row)


@router.get("/presentation")
async def get_presentation(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile or not profile["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    row = await conn.fetchrow(
        """SELECT name, cnpj,
                  presentation_mission, presentation_vision, presentation_history,
                  presentation_values, presentation_cover_url
           FROM public.companies WHERE id = $1""",
        profile["company_id"],
    )
    if not row:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    result = dict(row)
    vals = result["presentation_values"]
    result["presentation_values"] = json.loads(vals) if isinstance(vals, str) else (vals or [])
    return result


@router.patch("/presentation")
async def update_presentation(
    body: PresentationUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile or not profile["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    await conn.execute(
        """UPDATE public.companies SET
            presentation_mission   = $2,
            presentation_vision    = $3,
            presentation_history   = $4,
            presentation_cover_url = $5,
            presentation_values    = $6::jsonb
           WHERE id = $1""",
        profile["company_id"],
        body.presentation_mission,
        body.presentation_vision,
        body.presentation_history,
        body.presentation_cover_url,
        json.dumps([v.model_dump() for v in body.presentation_values] if body.presentation_values else []),
    )
    return await get_presentation(user_id=user_id, conn=conn)


@router.get("/internal-rules")
async def get_internal_rules(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile or not profile["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    row = await conn.fetchrow(
        "SELECT internal_rules FROM public.companies WHERE id = $1",
        profile["company_id"],
    )
    if not row:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    rules = row["internal_rules"]
    return {"rules": json.loads(rules) if isinstance(rules, str) else (rules or [])}


@router.patch("/internal-rules")
async def update_internal_rules(
    body: InternalRulesUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)

    profile = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not profile or not profile["company_id"]:
        raise HTTPException(status_code=404, detail="Empresa não encontrada")

    await conn.execute(
        "UPDATE public.companies SET internal_rules = $1::jsonb WHERE id = $2",
        json.dumps([r.model_dump() for r in body.rules]),
        profile["company_id"],
    )
    return {"rules": [r.model_dump() for r in body.rules]}


# ── Parameterized routes last ─────────────────────────────────────────────────

@router.patch("/{company_id}")
async def update_company(
    company_id: str,
    body: CompanyUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_master_admin(user_id, conn)
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(fields))
    values = list(fields.values())

    row = await conn.fetchrow(
        f"UPDATE public.companies SET {set_clause} WHERE id = $1 RETURNING *",
        company_id, *values,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Empresa não encontrada")
    return dict(row)


@router.delete("/{company_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_company(company_id: str, conn: asyncpg.Connection = Depends(get_db)):
    await conn.execute("SELECT public.delete_company_cascade($1)", company_id)
