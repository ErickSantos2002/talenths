from typing import AsyncGenerator
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
import jwt
import asyncpg

from app.config import settings
from app.database import get_pool

security = HTTPBearer()


def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token expirado")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido")


def get_current_user_id(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> str:
    payload = decode_token(credentials.credentials)
    return payload["sub"]


async def get_db(
    user_id: str = Depends(get_current_user_id),
) -> AsyncGenerator[asyncpg.Connection, None]:
    async with get_pool().acquire() as conn:
        async with conn.transaction():
            await conn.execute("SELECT set_config('app.current_user_id', $1, true)", str(user_id))
            yield conn


async def require_manager(user_id: str, conn: asyncpg.Connection) -> None:
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=403, detail="Acesso restrito a gestores")


async def require_master_admin(user_id: str, conn: asyncpg.Connection) -> None:
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role = 'master_admin'",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=403, detail="Acesso restrito a administradores")


async def get_db_public() -> AsyncGenerator[asyncpg.Connection, None]:
    """Conexão sem autenticação — para rotas públicas (convites, resultados compartilhados)."""
    async with get_pool().acquire() as conn:
        yield conn
