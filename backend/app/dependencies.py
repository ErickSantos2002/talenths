from contextlib import asynccontextmanager
from typing import AsyncGenerator
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
import jwt
import asyncpg

from app.auth.agente import (
    TokenDeAgenteInvalido,
    eh_token_de_agente,
    rota_liberada_ao_agente,
    validar_token_de_agente,
)
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


@asynccontextmanager
async def _pool_conn():
    async with get_pool().acquire() as conn:
        yield conn


def get_auth_conn_opener():
    """Conexão usada só para resolver o dono do token de agente (substituível nos testes)."""
    return _pool_conn


async def _user_id_do_agente(request: Request, token: str, conn_opener) -> str:
    try:
        email, bot = validar_token_de_agente(token, settings.HSOS_AGENTE_CHAVE_PUBLICA)
    except TokenDeAgenteInvalido:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido")
    async with conn_opener() as conn:
        user_id = await conn.fetchval(
            "SELECT id::text FROM auth.users WHERE lower(email) = $1", email
        )
        if not user_id:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido")
        # Nem toda rota passa pelo get_db; desligado não entra por agente em nenhuma.
        await ensure_active_user(conn, user_id)
    request.state.agente_bot = bot
    request.state.agente_user_id = user_id
    return user_id


def via_agente(request: Request) -> bool:
    """Requisição autenticada por token de agente (posto por get_current_user_id)."""
    return bool(getattr(request.state, "agente_bot", None))


def bloquear_agente_fora_da_lista(request: Request) -> None:
    """Dependência global do app: vale também para rota pública, que não passa por
    get_current_user_id. Aqui só se decide o caminho; quem valida a assinatura é
    get_current_user_id."""
    auth = request.headers.get("Authorization", "")
    if not auth[:7].lower() == "bearer " or not eh_token_de_agente(auth[7:].strip()):
        return
    route = request.scope.get("route")
    if not rota_liberada_ao_agente(request.method, getattr(route, "path", None)):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Fora do que o assistente pode consultar")


async def get_current_user_id(
    request: Request,
    credentials: HTTPAuthorizationCredentials = Depends(security),
    conn_opener=Depends(get_auth_conn_opener),
) -> str:
    token = credentials.credentials
    if eh_token_de_agente(token):
        return await _user_id_do_agente(request, token, conn_opener)
    payload = decode_token(token)
    # Tokens de uso restrito (ex.: reprodução de vídeo) não têm "sub" e não valem como login.
    sub = payload.get("sub")
    if not sub:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido")
    return sub


async def ensure_active_user(conn: asyncpg.Connection, user_id: str) -> None:
    # O JWT vale 24h e não tem revogação: é aqui que quem foi desligado perde a sessão.
    deactivated = await conn.fetchval(
        "SELECT deactivated_at IS NOT NULL FROM public.profiles WHERE user_id = $1", user_id
    )
    if deactivated:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Acesso desativado")


async def get_db(
    user_id: str = Depends(get_current_user_id),
) -> AsyncGenerator[asyncpg.Connection, None]:
    async with get_pool().acquire() as conn:
        async with conn.transaction():
            await conn.execute("SELECT set_config('app.current_user_id', $1, true)", str(user_id))
            await ensure_active_user(conn, user_id)
            yield conn


async def is_manager(user_id: str, conn: asyncpg.Connection) -> bool:
    return await conn.fetchval(
        "SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin'))",
        user_id,
    )


async def require_manager(user_id: str, conn: asyncpg.Connection) -> None:
    if not await is_manager(user_id, conn):
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
