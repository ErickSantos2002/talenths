import uuid

import pytest

from app.auth.service import verify_password
from app.database import _setup_conn
from tests.db.conftest import make_company, make_user


@pytest.fixture(autouse=True)
async def prod_like_conn(db):
    # create_user grava jsonb como dict, contando com os codecs do pool da app.
    await _setup_conn(db)
    # profiles.job_title só existe em produção (ver backend/scripts/captures-db.sh).
    await db.execute("ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS job_title text")


def _payload(company_id, **extra):
    return {
        "email": f"{uuid.uuid4()}@exemplo.com.br",
        "name": "Carla",
        "company_id": company_id,
        "role": "user",
        **extra,
    }


async def test_create_without_password_is_422(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    c = client_as(manager)

    for body in (_payload(company), _payload(company, password=None), _payload(company, password="")):
        r = await c.post("/collaborators", json=body)
        assert r.status_code == 422, r.text
        assert [e["loc"] for e in r.json()["detail"]] == [["body", "password"]]
        assert await db.fetchval("SELECT COUNT(*) FROM auth.users WHERE email = $1", body["email"]) == 0


async def test_create_with_short_password_is_422(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")

    r = await client_as(manager).post("/collaborators", json=_payload(company, password="12345"))
    assert r.status_code == 422, r.text
    assert [e["loc"] for e in r.json()["detail"]] == [["body", "password"]]


async def test_create_with_password_logs_in_with_it(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    body = _payload(company, password="senha123")

    r = await client_as(manager).post("/collaborators", json=body)
    assert r.status_code == 201, r.text
    hashed = await db.fetchval("SELECT encrypted_password FROM auth.users WHERE email = $1", body["email"])
    assert verify_password("senha123", hashed)
