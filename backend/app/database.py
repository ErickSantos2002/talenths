from typing import Optional
import asyncpg
from app.config import settings

_pool: Optional[asyncpg.Pool] = None


async def init_db() -> None:
    global _pool
    _pool = await asyncpg.create_pool(
        settings.DATABASE_URL,
        min_size=2,
        max_size=10,
    )


async def close_db() -> None:
    if _pool:
        await _pool.close()


def get_pool() -> asyncpg.Pool:
    return _pool
