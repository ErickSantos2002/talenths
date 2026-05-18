from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/profiles", tags=["profiles"])


class ProfileUpdate(BaseModel):
    name: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    company_id: Optional[str] = None
    department_id: Optional[str] = None


@router.get("/me")
async def get_my_profile(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await conn.fetchrow(
        "SELECT * FROM public.profiles WHERE user_id = $1", user_id
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Perfil não encontrado")
    return dict(row)


@router.patch("/me")
async def update_my_profile(
    body: ProfileUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.profiles SET {set_clause} WHERE user_id = $1 RETURNING *",
        user_id, *list(fields.values()),
    )
    return dict(row)


@router.get("")
async def list_profiles(
    company_id: Optional[str] = None,
    conn: asyncpg.Connection = Depends(get_db),
):
    if company_id:
        rows = await conn.fetch(
            "SELECT * FROM public.profiles WHERE company_id = $1", company_id
        )
    else:
        rows = await conn.fetch("SELECT * FROM public.profiles")
    return [dict(r) for r in rows]


@router.get("/{user_id}")
async def get_profile(user_id: str, conn: asyncpg.Connection = Depends(get_db)):
    row = await conn.fetchrow(
        "SELECT * FROM public.profiles WHERE user_id = $1", user_id
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Perfil não encontrado")
    return dict(row)
