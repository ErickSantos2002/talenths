import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, EmailStr, Field, model_validator
from typing import Literal, Optional
from datetime import date
import asyncpg

from app.auth.service import create_user, update_user_password
from app.dependencies import get_db, get_current_user_id, require_manager, require_master_admin
from app.roster import TERMINATION_REASONS

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
    # Não há envio de e-mail: sem senha a pessoa ficaria sem como entrar. O mínimo
    # é o mesmo das telas de redefinir senha e de cadastro por convite.
    password: str = Field(min_length=6)
    role: str = "user"
    job_title: Optional[str] = None


class PasswordUpdate(BaseModel):
    password: str = Field(min_length=6)


class CollaboratorUpdate(BaseModel):
    name: Optional[str] = None
    cpf: Optional[str] = None
    phone: Optional[str] = None
    birth_date: Optional[date] = None
    hire_date: Optional[date] = None
    company_id: Optional[str] = None
    department_id: Optional[str] = None
    job_title: Optional[str] = None
    timeclock_enabled: Optional[bool] = None
    daily_work_hours: Optional[float] = None


class RoleUpdate(BaseModel):
    role: str


class DeactivateBody(BaseModel):
    termination_date: date
    reason: str
    note: Optional[str] = Field(default=None, max_length=1000)

    @model_validator(mode="after")
    def check(self):
        if self.reason not in TERMINATION_REASONS:
            raise ValueError("Motivo de desligamento inválido")
        if self.termination_date > date.today():
            raise ValueError("A data do desligamento não pode ser futura")
        self.note = (self.note or "").strip() or None
        if self.reason == "other" and not self.note:
            raise ValueError("Descreva o motivo na observação")
        return self


@router.get("")
async def list_collaborators(
    company_id: Optional[str] = None,
    status_filter: Literal["active", "inactive", "all"] = Query("active", alias="status"),
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    own_company = await conn.fetchval(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not company_id:
        company_id = own_company
    elif company_id != str(own_company):
        await require_master_admin(user_id, conn)
    status_clause = {
        "active": "AND p.deactivated_at IS NULL",
        "inactive": "AND p.deactivated_at IS NOT NULL",
        "all": "",
    }[status_filter]
    rows = await conn.fetch(
        f"""SELECT p.*, t.termination_date, t.reason AS termination_reason, t.note AS termination_note
            FROM public.profiles p
            LEFT JOIN public.collaborator_terminations t
              ON t.profile_id = p.id AND t.reactivated_at IS NULL
            WHERE p.company_id = $1 {status_clause}""",
        company_id,
    )

    result = []
    for row in rows:
        p = dict(row)
        termination_date = p.pop("termination_date")
        reason = p.pop("termination_reason")
        note = p.pop("termination_note")
        roles = await conn.fetch(
            "SELECT id, role FROM public.user_roles WHERE user_id = $1", p["user_id"]
        )
        p["termination"] = (
            {"termination_date": termination_date, "reason": reason, "note": note}
            if p["deactivated_at"] is not None and termination_date is not None
            else None
        )
        result.append({**p, "roles": [dict(r) for r in roles]})

    return result


async def _status_target(profile_id: str, user_id: str, conn: asyncpg.Connection):
    """Quem pode desligar/reativar: gerente mexe em colaborador e gerente; administrador
    só por administrador; ninguém em si mesmo. Fora da empresa de quem chama é 404."""
    await require_manager(user_id, conn)
    target = await conn.fetchrow(
        """SELECT p.id, p.user_id, p.company_id, p.deactivated_at
           FROM public.profiles p
           WHERE p.id = $1
             AND p.company_id = (SELECT company_id FROM public.profiles WHERE user_id = $2)""",
        profile_id, user_id,
    )
    if not target:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Colaborador não encontrado")
    if str(target["user_id"]) == str(user_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Você não pode desligar a si mesmo")
    is_admin = await conn.fetchval(
        "SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = $1 AND role = 'master_admin')",
        target["user_id"],
    )
    if is_admin:
        await require_master_admin(user_id, conn)
    return target


@router.post("/{profile_id}/deactivate", status_code=status.HTTP_204_NO_CONTENT)
async def deactivate_collaborator(
    profile_id: uuid.UUID,
    body: DeactivateBody,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    target = await _status_target(str(profile_id), user_id, conn)
    if target["deactivated_at"] is not None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Colaborador já está desligado")

    async with conn.transaction():
        await conn.execute(
            """INSERT INTO public.collaborator_terminations
                 (profile_id, company_id, termination_date, reason, note, deactivated_by)
               VALUES ($1, $2, $3, $4, $5, $6)""",
            target["id"], target["company_id"], body.termination_date, body.reason, body.note, user_id,
        )
        await conn.execute(
            "UPDATE public.profiles SET deactivated_at = now() WHERE id = $1", target["id"]
        )
        await conn.execute(
            """UPDATE public.employee_benefits SET end_date = $2
               WHERE user_id = $1 AND (end_date IS NULL OR end_date > $2)""",
            target["user_id"], body.termination_date,
        )


@router.post("/{profile_id}/reactivate", status_code=status.HTTP_204_NO_CONTENT)
async def reactivate_collaborator(
    profile_id: uuid.UUID,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    target = await _status_target(str(profile_id), user_id, conn)
    if target["deactivated_at"] is None:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Colaborador já está ativo")

    async with conn.transaction():
        await conn.execute(
            """UPDATE public.collaborator_terminations SET reactivated_at = now(), reactivated_by = $2
               WHERE profile_id = $1 AND reactivated_at IS NULL""",
            target["id"], user_id,
        )
        await conn.execute(
            "UPDATE public.profiles SET deactivated_at = NULL WHERE id = $1", target["id"]
        )


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
        user = await create_user(conn, body.email, body.password, body.name)
        new_user_id = str(user["id"])

        await conn.execute(
            """UPDATE public.profiles
               SET company_id = $1, department_id = $2, cpf = $3, phone = $4, birth_date = $5, hire_date = $6, job_title = $7
               WHERE user_id = $8""",
            body.company_id, body.department_id, body.cpf, body.phone, body.birth_date, body.hire_date, body.job_title, new_user_id,
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


@router.patch("/{profile_id}/password", status_code=status.HTTP_204_NO_CONTENT)
async def reset_collaborator_password(
    profile_id: str,
    body: PasswordUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    profile = await conn.fetchrow(
        "SELECT user_id FROM public.profiles WHERE id = $1", profile_id
    )
    if not profile:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Colaborador não encontrado")
    await update_user_password(conn, str(profile["user_id"]), body.password)


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
        await conn.execute(
            "DELETE FROM public.user_managers WHERE user_id = $1 OR manager_id = $1", uid
        )
        await conn.execute("DELETE FROM public.user_roles WHERE user_id = $1", uid)
        await conn.execute("DELETE FROM public.profiles WHERE id = $1", profile_id)
        await conn.execute("DELETE FROM auth.users WHERE id = $1", uid)
