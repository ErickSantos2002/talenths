import os
import uuid

import asyncpg
import httpx
import pytest


@pytest.fixture
async def db():
    url = os.environ.get("TEST_DATABASE_URL")
    if not url:
        pytest.skip("TEST_DATABASE_URL não definida (rode backend/scripts/test-db.sh)")
    conn = await asyncpg.connect(url)
    tx = conn.transaction()
    await tx.start()
    try:
        yield conn
    finally:
        await tx.rollback()
        await conn.close()


async def make_company(db) -> str:
    return str(await db.fetchval(
        "INSERT INTO public.companies (name) VALUES ('Empresa Teste') RETURNING id"
    ))


async def make_department(db, company_id, name) -> str:
    return str(await db.fetchval(
        "INSERT INTO public.departments (company_id, name) VALUES ($1, $2) RETURNING id",
        company_id, name,
    ))


async def make_user(db, company_id, department_id=None, name="Fulano", role="user") -> str:
    """Segue o caminho real: o trigger de signup cria o perfil sem empresa e o
    backend preenche empresa/departamento num UPDATE logo em seguida."""
    user_id = str(await db.fetchval(
        """INSERT INTO auth.users (email, raw_user_meta_data)
           VALUES ($1, jsonb_build_object('name', $2::text)) RETURNING id""",
        f"{uuid.uuid4()}@teste.local", name,
    ))
    await db.execute(
        "UPDATE public.profiles SET company_id = $1, department_id = $2 WHERE user_id = $3",
        company_id, department_id, user_id,
    )
    if role != "user":
        await db.execute(
            "UPDATE public.user_roles SET role = $1, company_id = $2 WHERE user_id = $3",
            role, company_id, user_id,
        )
    return user_id


@pytest.fixture
def sample_mp4() -> bytes:
    path = os.path.join(os.path.dirname(__file__), "..", "fixtures", "sample-5s.mp4")
    with open(path, "rb") as f:
        return f.read()


@pytest.fixture
def client_as(db, tmp_path, monkeypatch):
    """Cliente HTTP que age como `user_id`, usando a conexão (em transação) do teste."""
    from app.config import settings
    from app.dependencies import get_current_user_id, get_db, get_db_public
    from app.main import app

    monkeypatch.setattr(settings, "UPLOADS_DIR", str(tmp_path))
    clients = []

    def make(user_id: str) -> httpx.AsyncClient:
        async def _db():
            yield db

        app.dependency_overrides[get_db] = _db
        app.dependency_overrides[get_db_public] = _db
        app.dependency_overrides[get_current_user_id] = lambda: user_id
        client = httpx.AsyncClient(transport=httpx.ASGITransport(app=app), base_url="http://test")
        clients.append(client)
        return client

    yield make
    app.dependency_overrides.clear()
