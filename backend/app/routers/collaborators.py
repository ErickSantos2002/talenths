from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import date
import asyncpg

from app.auth.service import create_user
from app.dependencies import get_db, get_current_user_id, require_manager, require_master_admin

router = APIRouter(prefix="/collaborators", tags=["collaborators"])


class CollaboratorCreate(BaseModel):
    email: EmailStr
    name: str
    company_id: str
    department_id: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    birth_date: Optional[date] = None
    hire_date: Optional[date] = None
    role: str = "user"


class CollaboratorUpdate(BaseModel):
    name: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    birth_date: Optional[date] = None
    hire_date: Optional[date] = None
    company_id: Optional[str] = None
    department_id: Optional[str] = None


class RoleUpdate(BaseModel):
    role: str


@router.get("")
async def list_collaborators(
    company_id: Optional[str] = None,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    if company_id:
        rows = await conn.fetch(
            "SELECT * FROM public.profiles WHERE company_id = $1", company_id
        )
    else:
        rows = await conn.fetch("SELECT * FROM public.profiles")

    result = []
    for p in rows:
        roles = await conn.fetch(
            "SELECT id, role FROM public.user_roles WHERE user_id = $1", p["user_id"]
        )
        has_result = await conn.fetchval(
            "SELECT EXISTS(SELECT 1 FROM public.test_results WHERE user_id = $1)", p["user_id"]
        )
        result.append({**dict(p), "roles": [dict(r) for r in roles], "has_result": has_result})

    return result


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_collaborator(
    body: CollaboratorCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    existing = await conn.fetchrow(
        "SELECT id FROM auth.users WHERE email = $1", body.email
    )
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email já cadastrado")

    async with conn.transaction():
        import secrets
        temp_password = secrets.token_urlsafe(16)
        user = await create_user(conn, body.email, temp_password, body.name)
        new_user_id = str(user["id"])

        await conn.execute(
            """UPDATE public.profiles
               SET company_id = $1, department_id = $2, cpf = $3, phone = $4, birth_date = $5, hire_date = $6
               WHERE user_id = $7""",
            body.company_id, body.department_id, body.cpf, body.phone, body.birth_date, body.hire_date, new_user_id,
        )

        if body.role != "user":
            role_row = await conn.fetchrow(
                "SELECT id FROM public.user_roles WHERE user_id = $1 AND role = 'user'", new_user_id
            )
            if role_row:
                await conn.execute(
                    "UPDATE public.user_roles SET role = $1, company_id = $2 WHERE id = $3",
                    body.role, body.company_id, role_row["id"],
                )
            else:
                await conn.execute(
                    "INSERT INTO public.user_roles (user_id, role, company_id) VALUES ($1, $2, $3)",
                    new_user_id, body.role, body.company_id,
                )

    return {"id": new_user_id, "email": body.email, "name": body.name}


@router.patch("/{profile_id}")
async def update_collaborator(
    profile_id: str,
    body: CollaboratorUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.profiles SET {set_clause} WHERE id = $1 RETURNING *",
        profile_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Colaborador não encontrado")
    return dict(row)


@router.patch("/{role_id}/role")
async def update_collaborator_role(
    role_id: str,
    body: RoleUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_master_admin(user_id, conn)
    row = await conn.fetchrow(
        "UPDATE public.user_roles SET role = $1 WHERE id = $2 RETURNING *",
        body.role, role_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Papel não encontrado")
    return dict(row)


@router.delete("/{profile_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_collaborator(
    profile_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_master_admin(user_id, conn)
    profile = await conn.fetchrow(
        "SELECT user_id FROM public.profiles WHERE id = $1", profile_id
    )
    if not profile:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Colaborador não encontrado")

    uid = profile["user_id"]
    async with conn.transaction():
        await conn.execute("DELETE FROM public.test_responses WHERE user_id = $1", uid)
        await conn.execute("DELETE FROM public.test_results WHERE user_id = $1", uid)
        await conn.execute(
            "DELETE FROM public.profile_comparisons WHERE user1_id = $1 OR user2_id = $1", uid
        )
        await conn.execute(
            "DELETE FROM public.user_managers WHERE user_id = $1 OR manager_id = $1", uid
        )
        await conn.execute("DELETE FROM public.user_roles WHERE user_id = $1", uid)
        await conn.execute("DELETE FROM public.profiles WHERE id = $1", profile_id)
        await conn.execute("DELETE FROM auth.users WHERE id = $1", uid)
