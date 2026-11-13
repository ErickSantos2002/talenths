import shutil

import pytest

from app import migrate


@pytest.fixture
def migrations_dir(tmp_path):
    shutil.copy(migrate.MIGRATIONS_DIR / migrate.TRACKING_FILE, tmp_path)
    (tmp_path / "034_ja_em_producao.sql").write_text("CREATE TABLE public.nunca_roda (id int);")
    (tmp_path / "035_primeira_automatica.sql").write_text("CREATE TABLE public.mig_teste_a (id int);")
    return tmp_path


async def versions(db):
    return {r["version"] for r in await db.fetch("SELECT version FROM public.schema_migrations")}


async def test_banco_de_producao_sem_registro_marca_a_base_e_aplica_o_resto(db, migrations_dir):
    await db.execute("DELETE FROM public.schema_migrations")

    assert await migrate.apply_pending(db, migrations_dir) == ["035_primeira_automatica.sql"]

    assert await db.fetchval("SELECT to_regclass('public.nunca_roda') IS NULL")
    assert await db.fetchval("SELECT to_regclass('public.mig_teste_a') IS NOT NULL")
    assert {34, 35} <= await versions(db)


async def test_segunda_subida_nao_aplica_nada(db, migrations_dir):
    await db.execute("DELETE FROM public.schema_migrations")
    await migrate.apply_pending(db, migrations_dir)

    assert await migrate.apply_pending(db, migrations_dir) == []


async def test_so_aplica_o_que_falta(db, migrations_dir):
    (migrations_dir / "099_nova.sql").write_text("CREATE TABLE public.mig_teste_b (id int);")

    # O banco de teste já tem 001..035 registradas pelo test-db.sh.
    assert await migrate.apply_pending(db, migrations_dir) == ["099_nova.sql"]
    assert 99 in await versions(db)


async def test_migracao_que_falha_nao_fica_registrada_e_nao_deixa_rastro(db, migrations_dir):
    (migrations_dir / "098_quebra.sql").write_text(
        "CREATE TABLE public.mig_teste_c (id int); SELECT * FROM tabela_que_nao_existe;"
    )

    with pytest.raises(Exception):
        await migrate.apply_pending(db, migrations_dir)

    assert 98 not in await versions(db)
    assert await db.fetchval("SELECT to_regclass('public.mig_teste_c') IS NULL")


def test_as_migracoes_do_repositorio_tem_numero_unico_e_a_035_vem_depois_da_base():
    files = migrate.migration_files()
    assert files[0][0] == 1
    assert [v for v, _ in files if v > migrate.BASELINE][0] == 35
