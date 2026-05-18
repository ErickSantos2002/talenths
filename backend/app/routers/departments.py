from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db

router = APIRouter(prefix="/departments", tags=["departments"])


class DepartmentCreate(BaseModel):
    name: str
    company_id: str


class DepartmentUpdate(BaseModel):
    name: Optional[str] = None
    company_id: Optional[str] = None


@router.get("")
async def list_departments(
    company_id: Optional[str] = None,
    conn: asyncpg.Connection = Depends(get_db),
):
    if company_id:
        rows = await conn.fetch(
            "SELECT * FROM public.departments WHERE company_id = $1 ORDER BY name",
            company_id,
        )
    else:
        rows = await conn.fetch("SELECT * FROM public.departments ORDER BY name")
    return [dict(r) for r in rows]


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_department(body: DepartmentCreate, conn: asyncpg.Connection = Depends(get_db)):
    row = await conn.fetchrow(
        "INSERT INTO public.departments (name, company_id) VALUES ($1, $2) RETURNING *",
        body.name, body.company_id,
    )
    return dict(row)


@router.patch("/{department_id}")
async def update_department(
    department_id: str,
    body: DepartmentUpdate,
    conn: asyncpg.Connection = Depends(get_db),
):
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if not fields:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Nenhum campo para atualizar")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(fields))
    row = await conn.fetchrow(
        f"UPDATE public.departments SET {set_clause} WHERE id = $1 RETURNING *",
        department_id, *list(fields.values()),
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Departamento não encontrado")
    return dict(row)


@router.delete("/{department_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_department(department_id: str, conn: asyncpg.Connection = Depends(get_db)):
    result = await conn.execute(
        "DELETE FROM public.departments WHERE id = $1", department_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Departamento não encontrado")
