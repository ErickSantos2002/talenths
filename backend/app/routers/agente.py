from fastapi import APIRouter, Depends, HTTPException, Request
import asyncpg

from app.auth.agente import capacidades
from app.dependencies import get_current_user_id, get_db, via_agente

router = APIRouter(prefix="/agente", tags=["agente"])


@router.get("/capacidades")
async def get_capacidades(
    request: Request,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    # Descreve o que o assistente do HS.OS pode fazer por este login; pela tela não existe.
    if not via_agente(request):
        raise HTTPException(status_code=404, detail="Not Found")
    rows = await conn.fetch("SELECT role::text FROM public.user_roles WHERE user_id = $1", user_id)
    return capacidades({r["role"] for r in rows})
