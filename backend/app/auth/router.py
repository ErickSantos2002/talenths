from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import RedirectResponse
from typing import AsyncGenerator
import asyncpg

from app.auth.schemas import (
    AuthResponse,
    ForgotPasswordRequest,
    LoginRequest,
    RegisterInviteRequest,
    RegisterRequest,
    UpdatePasswordRequest,
    UserResponse,
)
from app.auth import service
from app.dependencies import get_db, get_db_public, get_current_user_id
from app.database import get_pool

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login", response_model=AuthResponse)
async def login(body: LoginRequest):
    async with get_pool().acquire() as conn:
        user = await service.get_user_by_email(conn, body.email)
        if not user or not service.verify_password(body.password, user["encrypted_password"]):
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Email ou senha incorretos")

        token = service.create_access_token(str(user["id"]))
        return AuthResponse(
            access_token=token,
            user=UserResponse(
                id=str(user["id"]),
                email=user["email"],
                name=user["raw_user_meta_data"].get("name") if user["raw_user_meta_data"] else None,
            ),
        )


@router.post("/register", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def register(body: RegisterRequest):
    async with get_pool().acquire() as conn:
        existing = await service.get_user_by_email(conn, body.email)
        if existing:
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email já cadastrado")

        user = await service.create_user(conn, body.email, body.password, body.name)
        token = service.create_access_token(str(user["id"]))
        return AuthResponse(
            access_token=token,
            user=UserResponse(
                id=str(user["id"]),
                email=user["email"],
                name=body.name,
            ),
        )


@router.post("/register-invite", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def register_invite(body: RegisterInviteRequest):
    async with get_pool().acquire() as conn:
        invite = await conn.fetchrow(
            """
            SELECT * FROM public.test_invitations
            WHERE token = $1 AND is_active = true
              AND (expires_at IS NULL OR expires_at > now())
              AND (max_uses IS NULL OR used_count < max_uses)
            """,
            body.token,
        )
        if not invite:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Convite inválido ou expirado")

        existing = await service.get_user_by_email(conn, body.email)
        if existing:
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email já cadastrado")

        async with conn.transaction():
            user = await service.create_user(conn, body.email, body.password, body.name)
            user_id = str(user["id"])

            if body.phone:
                await conn.execute(
                    "UPDATE public.profiles SET phone = $1 WHERE user_id = $2",
                    body.phone, user_id,
                )

            await conn.execute(
                "UPDATE public.profiles SET company_id = $1, department_id = $2 WHERE user_id = $3",
                invite["company_id"], invite["department_id"], user_id,
            )

            await conn.execute(
                "UPDATE public.test_invitations SET used_count = used_count + 1 WHERE id = $1",
                invite["id"],
            )

        token = service.create_access_token(user_id)
        return AuthResponse(
            access_token=token,
            user=UserResponse(id=user_id, email=body.email, name=body.name),
        )


@router.get("/me", response_model=dict)
async def me(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    user = await service.get_user_by_id(conn, user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuário não encontrado")

    profile = await conn.fetchrow(
        "SELECT * FROM public.profiles WHERE user_id = $1", user_id
    )
    roles = await conn.fetch(
        "SELECT role, company_id FROM public.user_roles WHERE user_id = $1", user_id
    )

    return {
        "id": str(user["id"]),
        "email": user["email"],
        "profile": dict(profile) if profile else None,
        "roles": [dict(r) for r in roles],
    }


@router.patch("/password")
async def update_password(
    body: UpdatePasswordRequest,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await service.update_user_password(conn, user_id, body.password)
    return {"message": "Senha atualizada com sucesso"}


@router.post("/logout")
async def logout():
    # JWT é stateless — o cliente descarta o token
    return {"message": "Logout realizado"}


@router.get("/microsoft")
async def microsoft_login():
    from app.auth.microsoft import microsoft_auth_service
    from app.config import settings
    if not settings.MS_CLIENT_ID:
        raise HTTPException(status_code=501, detail="Login Microsoft não configurado")
    return RedirectResponse(url=microsoft_auth_service.get_authorization_url(), status_code=302)


@router.get("/microsoft/callback")
async def microsoft_callback(code: str = None, error: str = None):
    from app.auth.microsoft import microsoft_auth_service
    from app.config import settings

    frontend_url = settings.FRONTEND_URL

    if error or not code:
        return RedirectResponse(url=f"{frontend_url}/auth/callback?error=microsoft_auth_failed", status_code=302)

    try:
        token_result = microsoft_auth_service.exchange_code_for_token(code)
        profile = microsoft_auth_service.get_user_profile(token_result["access_token"])
    except Exception as e:
        print(f"[SSO Microsoft] {e}")
        return RedirectResponse(url=f"{frontend_url}/auth/callback?error=microsoft_auth_failed", status_code=302)

    email = profile.get("email", "")
    if not email:
        return RedirectResponse(url=f"{frontend_url}/auth/callback?error=microsoft_auth_failed", status_code=302)

    async with get_pool().acquire() as conn:
        user = await service.get_user_by_email(conn, email)

    if not user:
        return RedirectResponse(url=f"{frontend_url}/auth/callback?error=user_not_found", status_code=302)

    access_token = service.create_access_token(str(user["id"]))
    return RedirectResponse(
        url=f"{frontend_url}/auth/callback?access_token={access_token}",
        status_code=302,
    )
