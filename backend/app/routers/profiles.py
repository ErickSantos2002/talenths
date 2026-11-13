from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id, is_manager
from app.roster import active_only

router = APIRouter(prefix="/profiles", tags=["profiles"])

# O que um colega vê de outro. Lista do que pode sair (não do que esconder): coluna
# nova em profiles fica fora até alguém decidir que colega pode vê-la.
COLLEAGUE_FIELDS = (
    "id", "user_id", "email", "name", "company_id", "department_id", "job_title", "hire_date",
)


def _visible(row: asyncpg.Record, viewer_id: str, viewer_is_hr: bool) -> dict:
    data = dict(row)
    if viewer_is_hr or str(data.get("user_id")) == viewer_id:
        return data
    return {k: data[k] for k in COLLEAGUE_FIELDS if k in data}


class ProfileUpdate(BaseModel):
    name: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None


@router.get("/me")
async def get_my_profile(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await conn.fetchrow(
        """
        SELECT
            p.*,
            c.name AS company_name,
            d.name AS department_name
        FROM public.profiles p
        LEFT JOIN public.companies c ON c.id = p.company_id
        LEFT JOIN public.departments d ON d.id = p.department_id
        WHERE p.user_id = $1
        """,
        user_id,
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
    viewer_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    if company_id:
        rows = await conn.fetch(
            f"SELECT * FROM public.profiles p WHERE p.company_id = $1 AND {active_only()}", company_id
        )
    else:
        rows = await conn.fetch(f"SELECT * FROM public.profiles p WHERE {active_only()}")
    viewer_is_hr = await is_manager(viewer_id, conn)
    return [_visible(r, viewer_id, viewer_is_hr) for r in rows]


@router.get("/{user_id}")
async def get_profile(
    user_id: str,
    viewer_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await conn.fetchrow(
        "SELECT * FROM public.profiles WHERE user_id = $1", user_id
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Perfil não encontrado")
    return _visible(row, viewer_id, await is_manager(viewer_id, conn))
