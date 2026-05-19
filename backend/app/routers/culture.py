from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional, List
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/culture", tags=["culture"])


class ValueInline(BaseModel):
    title: str
    description: Optional[str] = None


class CultureUpdate(BaseModel):
    purpose: Optional[str] = None
    manifesto: Optional[str] = None
    values: Optional[List[ValueInline]] = None


class ValueCreate(BaseModel):
    title: str
    description: Optional[str] = None


class ValueUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None


async def _require_manager(user_id: str, conn: asyncpg.Connection):
    row = await conn.fetchrow(
        "SELECT id FROM public.user_roles WHERE user_id = $1 AND role IN ('manager', 'master_admin')",
        user_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Acesso restrito")


async def _get_company_id(user_id: str, conn: asyncpg.Connection) -> str:
    row = await conn.fetchrow(
        "SELECT company_id FROM public.profiles WHERE user_id = $1", user_id
    )
    if not row or not row["company_id"]:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Empresa não encontrada")
    return str(row["company_id"])


@router.get("")
async def get_culture(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    company_id = await _get_company_id(user_id, conn)

    culture_row = await conn.fetchrow(
        "SELECT purpose, manifesto, updated_at FROM public.company_culture WHERE company_id = $1",
        company_id,
    )

    values_rows = await conn.fetch(
        "SELECT id, title, description, position FROM public.culture_values WHERE company_id = $1 ORDER BY position, created_at",
        company_id,
    )

    return {
        "purpose": culture_row["purpose"] if culture_row else None,
        "manifesto": culture_row["manifesto"] if culture_row else None,
        "updated_at": culture_row["updated_at"].isoformat() if culture_row and culture_row["updated_at"] else None,
        "values": [dict(r) for r in values_rows],
    }


@router.put("")
async def update_culture(
    body: CultureUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    existing = await conn.fetchrow(
        "SELECT id FROM public.company_culture WHERE company_id = $1", company_id
    )

    if existing:
        row = await conn.fetchrow(
            """UPDATE public.company_culture
               SET purpose = COALESCE($2, purpose),
                   manifesto = COALESCE($3, manifesto),
                   updated_at = now(),
                   updated_by = $4
               WHERE company_id = $1
               RETURNING purpose, manifesto, updated_at""",
            company_id, body.purpose, body.manifesto, user_id,
        )
    else:
        row = await conn.fetchrow(
            """INSERT INTO public.company_culture (company_id, purpose, manifesto, updated_by)
               VALUES ($1, $2, $3, $4)
               RETURNING purpose, manifesto, updated_at""",
            company_id, body.purpose, body.manifesto, user_id,
        )

    if body.values is not None:
        await conn.execute(
            "DELETE FROM public.culture_values WHERE company_id = $1", company_id
        )
        for i, v in enumerate(body.values):
            await conn.execute(
                """INSERT INTO public.culture_values (company_id, title, description, position)
                   VALUES ($1, $2, $3, $4)""",
                company_id, v.title, v.description, i,
            )

    values_rows = await conn.fetch(
        "SELECT id, title, description, position FROM public.culture_values WHERE company_id = $1 ORDER BY position, created_at",
        company_id,
    )

    return {
        "purpose": row["purpose"],
        "manifesto": row["manifesto"],
        "updated_at": row["updated_at"].isoformat() if row["updated_at"] else None,
        "values": [dict(r) for r in values_rows],
    }


@router.post("/values", status_code=status.HTTP_201_CREATED)
async def create_value(
    body: ValueCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    max_pos = await conn.fetchval(
        "SELECT COALESCE(MAX(position), -1) FROM public.culture_values WHERE company_id = $1",
        company_id,
    )

    row = await conn.fetchrow(
        """INSERT INTO public.culture_values (company_id, title, description, position)
           VALUES ($1, $2, $3, $4)
           RETURNING id, title, description, position""",
        company_id, body.title, body.description, max_pos + 1,
    )
    return dict(row)


@router.put("/values/{value_id}")
async def update_value(
    value_id: str,
    body: ValueUpdate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    row = await conn.fetchrow(
        """UPDATE public.culture_values
           SET title = COALESCE($3, title),
               description = COALESCE($4, description)
           WHERE id = $1 AND company_id = $2
           RETURNING id, title, description, position""",
        value_id, company_id, body.title, body.description,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Valor não encontrado")
    return dict(row)


@router.delete("/values/{value_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_value(
    value_id: str,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _require_manager(user_id, conn)
    company_id = await _get_company_id(user_id, conn)

    result = await conn.execute(
        "DELETE FROM public.culture_values WHERE id = $1 AND company_id = $2",
        value_id, company_id,
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Valor não encontrado")
