from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_db_public, get_current_user_id

router = APIRouter(prefix="/invitations", tags=["invitations"])


class InvitationCreate(BaseModel):
    company_id: str
    department_id: Optional[str] = None
    max_uses: Optional[int] = None
    description: Optional[str] = None
    expires_at: Optional[str] = None


class InvitationUpdate(BaseModel):
    is_active: Optional[bool] = None
    description: Optional[str] = None
    max_uses: Optional[int] = None
    department_id: Optional[str] = None


@router.get("")
async def list_invitations(
    company_id: Optional[str] = None,
    conn: asyncpg.Connection = Depends(get_db),
):
    if company_id:
        rows = await conn.fetch(
            "SELECT * FROM public.test_invitations WHERE company_id = $1 ORDER BY created_at DESC",
            company_id,
        )
    else:
        rows = await conn.fetch(
            "SELECT * FROM public.test_invitations ORDER BY created_at DESC"
        )
    return [dict(r) for r in rows]


@router.get("/token/{token}")
async def get_invitation_by_token(token: str, conn: asyncpg.Connection = Depends(get_db_public)):
    row = await conn.fetchrow(
        """
        SELECT ti.*, c.name as company_name
        FROM public.test_invitations ti
        LEFT JOIN public.companies c ON c.id = ti.company_id
        WHERE ti.token = $1 AND ti.is_active = true
        """,
        token,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Convite não encontrado ou inativo")
    return dict(row)


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_invitation(
    body: InvitationCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await conn.fetchrow(
        """
        INSERT INTO public.test_invitations (company_id, department_id, invited_by, max_uses, description, expires_at)
        VALUES ($1, $2, $3, $4, $5, $6::timestamptz) RETURNING *
        """,
        body.company_id, body.department_id, user_id,
        body.max_uses, body.description, body.expires_at,
    )
    return dict(row)


@router.patch("/{invitation_id}")
async def update_invitation(
    invitation_id: str,
    body: InvitationUpdate,
    conn: asyncpg.Connection = Depends(get_db),
):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.test_invitations SET {set_clause} WHERE id = $1 RETURNING *",
        invitation_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Convite não encontrado")
    return dict(row)
