from datetime import datetime
from typing import Annotated, Literal

import asyncpg
from fastapi import APIRouter, Depends, HTTPException, Path
from pydantic import BaseModel, ConfigDict, Field

from app.dependencies import get_current_user_id, get_db, require_manager

router = APIRouter(prefix="/tour", tags=["tour"])

TOURS_PER_USER = 50
MAX_INVITE_DECLINES = 3

# Mesmos ids de frontend/src/help/tours/welcome.ts (backend.contract.test.ts confere).
WELCOME_TOUR_IDS = {"collaborator": "boas-vindas-colaborador", "manager": "boas-vindas-gestor"}

TourId = Annotated[str, Path(pattern=r"^[a-z0-9-]{1,64}$")]
Version = Annotated[int, Field(ge=1, le=999)]


class _Body(BaseModel):
    model_config = ConfigDict(extra="forbid")


class ProgressIn(_Body):
    version: Version
    step: int = Field(ge=0, le=999)


class VersionIn(_Body):
    version: Version


class TourProgressOut(BaseModel):
    tour: str
    version: int
    step: int
    started_at: datetime | None
    completed_at: datetime | None
    dismissed_at: datetime | None
    invites_declined: int


async def _locked_row(
    conn: asyncpg.Connection, user_id: str, tour: str, version: int
) -> asyncpg.Record:
    """Garante a linha (sem corrida entre abas) e a devolve travada para escrita."""
    exists = await conn.fetchval(
        "SELECT 1 FROM public.tour_progress WHERE user_id = $1 AND tour = $2", user_id, tour
    )
    if not exists:
        total = await conn.fetchval(
            "SELECT count(*) FROM public.tour_progress WHERE user_id = $1", user_id
        )
        # Teto aproximado, só contra laço: a contagem não é travada.
        if total >= TOURS_PER_USER:
            raise HTTPException(status_code=422, detail="Limite de tours atingido.")
        await conn.execute(
            """INSERT INTO public.tour_progress (user_id, company_id, tour, version)
               VALUES ($1, (SELECT company_id FROM public.profiles WHERE user_id = $1), $2, $3)
               ON CONFLICT (user_id, tour) DO NOTHING""",
            user_id, tour, version,
        )
    return await conn.fetchrow(
        "SELECT * FROM public.tour_progress WHERE user_id = $1 AND tour = $2 FOR UPDATE",
        user_id, tour,
    )


def _out(row: asyncpg.Record) -> TourProgressOut:
    return TourProgressOut(**{k: row[k] for k in TourProgressOut.model_fields})


@router.get("/progress", response_model=list[TourProgressOut])
async def list_progress(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        "SELECT * FROM public.tour_progress WHERE user_id = $1 ORDER BY tour", user_id
    )
    return [_out(r) for r in rows]


@router.put("/progress/{tour}", response_model=TourProgressOut)
async def save_step(
    tour: TourId,
    body: ProgressIn,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _locked_row(conn, user_id, tour, body.version)
    row = await conn.fetchrow(
        """UPDATE public.tour_progress
           SET step = $3,
               version = CASE WHEN completed_at IS NULL THEN $4 ELSE version END,
               started_at = COALESCE(started_at, now()),
               updated_at = now()
           WHERE user_id = $1 AND tour = $2 RETURNING *""",
        user_id, tour, body.step, body.version,
    )
    return _out(row)


@router.post("/progress/{tour}/complete", response_model=TourProgressOut)
async def complete(
    tour: TourId,
    body: VersionIn,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _locked_row(conn, user_id, tour, body.version)
    row = await conn.fetchrow(
        """UPDATE public.tour_progress
           SET version = CASE WHEN completed_at IS NULL THEN $3 ELSE GREATEST(version, $3) END,
               started_at = COALESCE(started_at, now()),
               completed_at = COALESCE(completed_at, now()),
               updated_at = now()
           WHERE user_id = $1 AND tour = $2 RETURNING *""",
        user_id, tour, body.version,
    )
    return _out(row)


@router.post("/progress/{tour}/dismiss", response_model=TourProgressOut)
async def dismiss(
    tour: TourId,
    body: VersionIn,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _locked_row(conn, user_id, tour, body.version)
    row = await conn.fetchrow(
        """UPDATE public.tour_progress
           SET dismissed_at = COALESCE(dismissed_at, now()), updated_at = now()
           WHERE user_id = $1 AND tour = $2 RETURNING *""",
        user_id, tour,
    )
    return _out(row)


@router.post("/progress/{tour}/decline-invite", response_model=TourProgressOut)
async def decline_invite(
    tour: TourId,
    body: VersionIn,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await _locked_row(conn, user_id, tour, body.version)
    row = await conn.fetchrow(
        """UPDATE public.tour_progress
           SET invites_declined = LEAST(invites_declined + 1, $3), updated_at = now()
           WHERE user_id = $1 AND tour = $2 RETURNING *""",
        user_id, tour, MAX_INVITE_DECLINES,
    )
    return _out(row)


class AdoptionRow(BaseModel):
    user_id: str
    name: str
    email: str | None
    department_id: str | None
    department: str | None
    audience: Literal["collaborator", "manager"]
    tour: str
    version: int | None
    step: int | None
    started_at: datetime | None
    completed_at: datetime | None
    status: Literal["completed", "in_progress", "not_started"]


@router.get("/adoption", response_model=list[AdoptionRow])
async def adoption(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    await require_manager(user_id, conn)
    # Uma consulta só: quem é gestor vê o tour de gestor; sem linha em tour_progress = não iniciou.
    rows = await conn.fetch(
        """SELECT p.user_id::text AS user_id, p.name, p.email,
                  p.department_id::text AS department_id, d.name AS department,
                  a.audience, t.tour_id AS tour, tp.version, tp.step,
                  tp.started_at, tp.completed_at,
                  CASE WHEN tp.completed_at IS NOT NULL THEN 'completed'
                       WHEN tp.started_at IS NOT NULL THEN 'in_progress'
                       ELSE 'not_started' END AS status
           FROM public.profiles p
           LEFT JOIN public.departments d ON d.id = p.department_id
           CROSS JOIN LATERAL (
               SELECT CASE WHEN COALESCE(bool_or(r.role IN ('manager', 'master_admin')), false)
                           THEN 'manager' ELSE 'collaborator' END AS audience
               FROM public.user_roles r WHERE r.user_id = p.user_id
           ) a
           CROSS JOIN LATERAL (
               SELECT CASE a.audience WHEN 'manager' THEN $2::text ELSE $3::text END AS tour_id
           ) t
           LEFT JOIN public.tour_progress tp ON tp.user_id = p.user_id AND tp.tour = t.tour_id
           WHERE p.company_id = (SELECT company_id FROM public.profiles WHERE user_id = $1)
             AND p.deactivated_at IS NULL
           ORDER BY p.name, p.user_id""",
        user_id, WELCOME_TOUR_IDS["manager"], WELCOME_TOUR_IDS["collaborator"],
    )
    return [AdoptionRow(**dict(r)) for r in rows]
