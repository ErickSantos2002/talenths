from datetime import datetime, timedelta, timezone
from typing import Optional
import jwt
import bcrypt
import asyncpg

from app.config import settings


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(plain: str, hashed: str) -> bool:
    return bcrypt.checkpw(plain.encode(), hashed.encode())


def create_access_token(user_id: str) -> str:
    payload = {
        "sub": str(user_id),
        "iat": datetime.now(timezone.utc),
        "exp": datetime.now(timezone.utc) + timedelta(hours=settings.JWT_EXPIRE_HOURS),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)


async def get_user_by_email(conn: asyncpg.Connection, email: str) -> Optional[asyncpg.Record]:
    return await conn.fetchrow(
        "SELECT id, email, encrypted_password, raw_user_meta_data FROM auth.users WHERE email = $1",
        email,
    )


async def get_user_by_id(conn: asyncpg.Connection, user_id: str) -> Optional[asyncpg.Record]:
    return await conn.fetchrow(
        "SELECT id, email, raw_user_meta_data FROM auth.users WHERE id = $1",
        user_id,
    )


async def create_user(conn: asyncpg.Connection, email: str, password: str, name: str) -> asyncpg.Record:
    hashed = hash_password(password)
    return await conn.fetchrow(
        """
        INSERT INTO auth.users (email, encrypted_password, email_confirmed_at, raw_user_meta_data)
        VALUES ($1, $2, now(), $3)
        RETURNING id, email, raw_user_meta_data
        """,
        email,
        hashed,
        {"name": name},
    )


async def update_user_password(conn: asyncpg.Connection, user_id: str, password: str) -> None:
    hashed = hash_password(password)
    await conn.execute(
        "UPDATE auth.users SET encrypted_password = $1, updated_at = now() WHERE id = $2",
        hashed,
        user_id,
    )
