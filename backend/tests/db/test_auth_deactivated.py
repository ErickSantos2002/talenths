from contextlib import asynccontextmanager

import httpx
import pytest
from fastapi import HTTPException

from app import video_storage
from app.auth.service import hash_password
from app.dependencies import ensure_active_user
from tests.db.conftest import make_company, make_user
from tests.db.test_videos_admin_api import _create, _rules
from tests.db.test_videos_upload_api import SMALL


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def deactivate(db, user_id):
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", user_id)


async def test_ensure_active_user_rejects_deactivated(db):
    company = await make_company(db)
    user = await make_user(db, company)
    await deactivate(db, user)

    with pytest.raises(HTTPException) as exc:
        await ensure_active_user(db, user)

    assert (exc.value.status_code, exc.value.detail) == (401, "Acesso desativado")


async def test_ensure_active_user_allows_active(db):
    company = await make_company(db)
    user = await make_user(db, company)

    await ensure_active_user(db, user)


@pytest.fixture
async def login_client(db, monkeypatch):
    """O login abre conexão pelo pool; aqui o pool devolve a conexão (em transação) do teste."""
    from app.auth import router as auth_router
    from app.database import _setup_conn
    from app.main import app

    await _setup_conn(db)

    class _Pool:
        @asynccontextmanager
        async def acquire(self):
            yield db

    monkeypatch.setattr(auth_router, "get_pool", lambda: _Pool())
    return httpx.AsyncClient(transport=httpx.ASGITransport(app=app), base_url="http://test")


async def test_login_deactivated_is_403_after_password(db, login_client):
    company = await make_company(db)
    user = await make_user(db, company)
    email = f"{user}@exemplo.com.br"
    await db.execute(
        "UPDATE auth.users SET email = $2, encrypted_password = $3 WHERE id = $1",
        user, email, hash_password("senha123"),
    )
    async with login_client as c:
        assert (await c.post("/auth/login", json={"email": email, "password": "senha123"})).status_code == 200
        await deactivate(db, user)

        wrong = await c.post("/auth/login", json={"email": email, "password": "errada"})
        right = await c.post("/auth/login", json={"email": email, "password": "senha123"})

    assert (wrong.status_code, wrong.json()["detail"]) == (401, "Email ou senha incorretos")
    assert (right.status_code, right.json()["detail"]) == (403, "Seu acesso foi desativado. Procure o RH.")


async def test_stream_token_of_deactivated_is_rejected(db, client_as, sample_mp4):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    video = await _create(client_as(manager), sample_mp4, _rules())
    c = client_as(user)
    r = await c.post(f"/videos/{video['id']}/stream-token")
    assert r.status_code == 200, r.text
    url = r.json()["url"]

    await deactivate(db, user)

    assert (await c.get(url)).status_code == 404
