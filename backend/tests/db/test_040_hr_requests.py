"""Migração 040: Ausências vira Solicitações (hr_requests) e cada tipo ganha categoria."""
from pathlib import Path

import asyncpg
import pytest

from tests.db.conftest import make_company

MIGRATION_040 = Path(__file__).parents[2] / "migrations" / "040_hr_requests.sql"


async def test_tabelas_antigas_nao_existem(db):
    assert await db.fetchval("SELECT to_regclass('public.absence_requests')") is None
    assert await db.fetchval("SELECT to_regclass('public.absence_types')") is None
    assert await db.fetchval("SELECT to_regclass('public.hr_requests')") is not None
    assert await db.fetchval("SELECT to_regclass('public.hr_request_types')") is not None


async def test_categoria_padrao_e_check(db):
    company = await make_company(db)
    category = await db.fetchval(
        "INSERT INTO public.hr_request_types (company_id, name) VALUES ($1, 'X') RETURNING category", company
    )
    assert category == "saida"
    with pytest.raises(asyncpg.CheckViolationError):
        await db.execute(
            "INSERT INTO public.hr_request_types (company_id, name, category) VALUES ($1, 'Y', 'ferias')", company
        )


async def test_reaplicar_seed_da_040_cria_pagar_hora_uma_vez(db):
    company = await make_company(db)
    await db.execute(
        "INSERT INTO public.hr_request_types (company_id, name) VALUES ($1, 'Saída pessoal')", company
    )
    seed = MIGRATION_040.read_text().split("-- seed", 1)[1]
    await db.execute(seed)
    await db.execute(seed)
    rows = await db.fetch(
        "SELECT category, requires_approval FROM public.hr_request_types WHERE company_id = $1 AND name = 'Pagar hora'",
        company,
    )
    assert len(rows) == 1
    assert rows[0]["category"] == "pagar_hora"
    assert rows[0]["requires_approval"] is True
