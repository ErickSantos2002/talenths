"""Equipe ativa: quem foi desligado (profiles.deactivated_at preenchido) não conta como
equipe atual nem pode receber nada novo, mas o histórico dele continua consultável."""
from typing import Iterable

import asyncpg
from fastapi import HTTPException

TERMINATION_REASONS = (
    "resignation",
    "dismissal_without_cause",
    "dismissal_with_cause",
    "contract_end",
    "mutual_agreement",
    "other",
)

TERMINATION_REASON_LABELS = {
    "resignation": "Pedido de demissão",
    "dismissal_without_cause": "Demissão sem justa causa",
    "dismissal_with_cause": "Demissão por justa causa",
    "contract_end": "Fim de contrato ou de experiência",
    "mutual_agreement": "Acordo entre as partes",
    "other": "Outro",
}


def iso_or_none(value):
    return value.isoformat() if value else None


def active_only(alias: str = "p") -> str:
    return f"{alias}.deactivated_at IS NULL"


def active_unless(alias: str, param: int) -> str:
    return f"({alias}.deactivated_at IS NULL OR ${param}::boolean)"


async def ensure_active_targets(conn: asyncpg.Connection, user_ids: Iterable[str]) -> None:
    ids = [str(u) for u in user_ids if u]
    if not ids:
        return
    found = await conn.fetchval(
        "SELECT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = ANY($1::uuid[]) AND deactivated_at IS NOT NULL)",
        ids,
    )
    if found:
        raise HTTPException(status_code=422, detail="Colaborador desligado")
