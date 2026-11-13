"""Aplica, quando o backend sobe, as migrações de backend/migrations/ que faltam no banco."""
import logging
import re
from pathlib import Path

import asyncpg

log = logging.getLogger("talenths.migrate")

MIGRATIONS_DIR = Path(__file__).resolve().parent.parent / "migrations"
TRACKING_FILE = "000_schema_migrations.sql"
# Até a 034 tudo foi aplicado à mão (scripts/aplicar_0NN.py). Num banco que já tem o
# TalentHS e ainda não tem registro, elas entram como aplicadas sem rodar de novo.
BASELINE = 34
# Com --workers 4, cada worker passa por aqui: só um aplica, os outros esperam e
# encontram tudo registrado.
_LOCK_KEY = 4_202_611_13
_NAME = re.compile(r"^(\d{3})_.+\.sql$")


def migration_files(directory: Path | None = None) -> list[tuple[int, Path]]:
    directory = directory or MIGRATIONS_DIR
    files = []
    for path in directory.iterdir():
        m = _NAME.match(path.name)
        if m and path.name != TRACKING_FILE:
            files.append((int(m.group(1)), path))
    files.sort()
    versions = [v for v, _ in files]
    if len(versions) != len(set(versions)):
        raise RuntimeError(f"Duas migrações com o mesmo número em {directory}")
    return files


async def apply_pending(conn: asyncpg.Connection, directory: Path | None = None) -> list[str]:
    directory = directory or MIGRATIONS_DIR
    files = migration_files(directory)
    await conn.execute("SELECT pg_advisory_lock($1)", _LOCK_KEY)
    try:
        await conn.execute((directory / TRACKING_FILE).read_text(encoding="utf-8"))
        applied = {r["version"] for r in await conn.fetch("SELECT version FROM public.schema_migrations")}
        if not applied:
            if await conn.fetchval("SELECT to_regclass('public.profiles') IS NULL"):
                raise RuntimeError(
                    "Banco sem o esquema do TalentHS: crie com backend/scripts/test-db.sh, não subindo o backend."
                )
            baseline = [(v, p.name) for v, p in files if v <= BASELINE]
            await conn.executemany(
                "INSERT INTO public.schema_migrations (version, name) VALUES ($1, $2) ON CONFLICT DO NOTHING",
                baseline,
            )
            applied = {v for v, _ in baseline}

        done = []
        for version, path in files:
            if version in applied:
                continue
            log.info("Aplicando migração %s", path.name)
            async with conn.transaction():
                await conn.execute(path.read_text(encoding="utf-8"))
                await conn.execute(
                    "INSERT INTO public.schema_migrations (version, name) VALUES ($1, $2)",
                    version, path.name,
                )
            done.append(path.name)
        return done
    finally:
        await conn.execute("SELECT pg_advisory_unlock($1)", _LOCK_KEY)
