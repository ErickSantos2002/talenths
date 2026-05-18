from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/companies", tags=["companies"])


class CompanyCreate(BaseModel):
    name: str
    cnpj: Optional[str] = None
    status: str = "active"


class CompanyUpdate(BaseModel):
    name: Optional[str] = None
    cnpj: Optional[str] = None
    status: Optional[str] = None


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


@router.patch("/{company_id}")
async def update_company(
    company_id: str,
    body: CompanyUpdate,
    conn: asyncpg.Connection = Depends(get_db),
):
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
