"""Token de agente do HS.OS: entra como o dono do e-mail, só GET e só a lista de rotas."""
import asyncio
import time
import uuid
from contextlib import asynccontextmanager

import httpx
import pytest

from app.middleware import audit
from tests.db.conftest import make_company, make_department, make_user
from tests.test_agente_token import PUB, emitir


@pytest.fixture
async def agente(db, monkeypatch):
    """Cliente HTTP SEM atalho de autenticação: o token passa pelo caminho real."""
    from app.config import settings
    from app.dependencies import get_auth_conn_opener, get_db, get_db_public
    from app.main import app

    monkeypatch.setattr(settings, "HSOS_AGENTE_CHAVE_PUBLICA", PUB)

    async def _db():
        yield db

    @asynccontextmanager
    async def _opener():
        yield db

    app.dependency_overrides[get_db] = _db
    app.dependency_overrides[get_db_public] = _db
    app.dependency_overrides[get_auth_conn_opener] = lambda: _opener
    # 500 de handler volta como resposta (e não exceção) para a varredura das escritas.
    client = httpx.AsyncClient(
        transport=httpx.ASGITransport(app=app, raise_app_exceptions=False), base_url="http://test"
    )

    async def get(path, token, method="GET", **kw):
        return await client.request(method, path, headers={"Authorization": f"Bearer {token}"}, **kw)

    yield get
    await client.aclose()
    app.dependency_overrides.clear()


async def email_of(db, user_id):
    return await db.fetchval("SELECT email FROM auth.users WHERE id = $1", user_id)


@pytest.fixture
def audit_calls(monkeypatch):
    calls = []

    def fake(*args):
        calls.append(args)
        return asyncio.sleep(0)

    monkeypatch.setattr(audit, "_write_log", fake)
    return calls


async def test_entra_como_o_dono_do_email(db, agente):
    company = await make_company(db)
    user = await make_user(db, company, name="Dona do Guardi")
    email = await email_of(db, user)

    r = await agente("/profiles/me", emitir(sub=email.upper()))

    assert r.status_code == 200
    assert str(r.json()["user_id"]) == user


async def test_ve_so_o_que_o_dono_ve(db, agente):
    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")

    assert (await agente("/absences/team", emitir(sub=await email_of(db, user)))).status_code == 403
    assert (await agente("/absences/team", emitir(sub=await email_of(db, hr)))).status_code == 200


async def test_email_sem_conta_ou_desativado_da_401(db, agente):
    company = await make_company(db)
    user = await make_user(db, company)
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", user)

    assert (await agente("/profiles/me", emitir(sub="ninguem@hs.com"))).status_code == 401
    assert (await agente("/profiles/me", emitir(sub=await email_of(db, user)))).status_code == 401


@pytest.mark.parametrize("extra", [
    {"aud": "datacore"},
    {"exp": int(time.time()) - 5},
    {"exp": int(time.time()) + 3600},
    {"act": None},
])
async def test_token_ruim_da_401(db, agente, extra):
    company = await make_company(db)
    user = await make_user(db, company)

    r = await agente("/profiles/me", emitir(sub=await email_of(db, user), **extra))

    assert r.status_code == 401


async def test_sem_chave_configurada_da_401(db, agente, monkeypatch):
    from app.config import settings

    monkeypatch.setattr(settings, "HSOS_AGENTE_CHAVE_PUBLICA", "")
    company = await make_company(db)
    user = await make_user(db, company)

    assert (await agente("/profiles/me", emitir(sub=await email_of(db, user)))).status_code == 401


async def test_fora_da_lista_ou_escrita_da_403_mesmo_para_master_admin(db, agente):
    company = await make_company(db)
    admin = await make_user(db, company, role="master_admin")
    token = emitir(sub=await email_of(db, admin))
    some_id = str(uuid.uuid4())

    for path in (
        f"/tests/{some_id}", f"/tests/{some_id}/take", f"/documents/{some_id}/download",
        "/invitations", "/logs", "/videos/admin", "/tour/progress", "/bingo/my",
    ):
        assert (await agente(path, token)).status_code == 403, path

    assert (await agente("/profiles/me", token, method="PATCH", json={"name": "x"})).status_code == 403
    assert (await agente("/timeclock/punch", token, method="POST", json={})).status_code == 403
    assert (await agente(f"/pdi/plans/{some_id}", token, method="DELETE")).status_code == 403
    assert (await agente("/absences/request", token, method="GET")).status_code in (403, 405)
    # Rota pública não vira porta de entrada: o bloqueio é global, não só no login.
    assert (await agente("/auth/login", token, method="POST", json={})).status_code == 403


async def test_auditoria_marca_o_bot(db, agente, audit_calls):
    company = await make_company(db)
    user = await make_user(db, company)

    r = await agente("/absences/my", emitir(sub=await email_of(db, user)))

    assert r.status_code == 200
    (user_id, method, path, action, status_code, _ip, via), = audit_calls
    assert (user_id, method, path, status_code, via) == (user, "GET", "/absences/my", 200, "erick-bot")
    assert action == "Consulta pelo assistente"


async def test_login_normal_get_continua_sem_auditoria(db, client_as, audit_calls):
    company = await make_company(db)
    user = await make_user(db, company)

    assert (await client_as(user).get("/absences/my")).status_code == 200
    assert audit_calls == []


GATE_DETAIL = "Fora do que o assistente pode consultar"


async def test_toda_escrita_da_lista_passa_pela_porta_do_agente(db, agente):
    from app.auth.agente import ESCRITAS_DO_AGENTE

    company = await make_company(db)
    admin = await make_user(db, company, role="master_admin")
    token = emitir(sub=await email_of(db, admin))

    for method, template in sorted(ESCRITAS_DO_AGENTE):
        path = template.replace("{month}", "1")
        while "{" in path:
            start = path.index("{")
            path = path[:start] + str(uuid.uuid4()) + path[path.index("}") + 1:]
        r = await agente(path, token, method=method, json={})
        assert not (r.status_code == 403 and r.json().get("detail") == GATE_DETAIL), (method, template)


async def test_escrita_respeita_o_papel_do_dono(db, agente):
    from tests.db.test_rh_writes_scope_api import make_absence

    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    req = await make_absence(db, company, user)

    r_user = await agente(f"/absences/{req}/approve", emitir(sub=await email_of(db, user)), method="PUT", json={})
    assert r_user.status_code == 403 and r_user.json()["detail"] != GATE_DETAIL

    r_hr = await agente(f"/absences/{req}/approve", emitir(sub=await email_of(db, hr)), method="PUT", json={})
    assert r_hr.status_code == 200
    assert str(await db.fetchval("SELECT reviewed_by FROM public.hr_requests WHERE id = $1", req)) == hr


async def test_escrita_do_agente_na_auditoria_com_rotulo_e_via(db, agente, audit_calls):
    from tests.db.test_rh_writes_scope_api import make_absence

    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    req = await make_absence(db, company, user)

    await agente(f"/absences/{req}/reject", emitir(sub=await email_of(db, hr)), method="PUT", json={})

    (user_id, method, _path, action, status_code, _ip, via), = audit_calls
    assert (user_id, method, action, status_code, via) == (hr, "PUT", "Ausência recusada", 200, "erick-bot")


async def test_rh_pelo_agente_so_cancela_o_proprio_pedido_pendente(db, agente):
    from tests.db.test_rh_writes_scope_api import make_absence

    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    colleague_req = await make_absence(db, company, user)
    own_approved = await make_absence(db, company, hr, status="approved")
    own_pending = await make_absence(db, company, hr)
    token = emitir(sub=await email_of(db, hr))

    for req in (colleague_req, own_approved, own_pending):
        await agente(f"/absences/{req}", token, method="DELETE")

    left = {str(r["id"]) for r in await db.fetch("SELECT id FROM public.hr_requests WHERE company_id = $1", company)}
    assert left == {colleague_req, own_approved}


async def test_comentario_de_meta_pelo_agente_sem_anexo(db, agente):
    company = await make_company(db)
    dept = await make_department(db, company, "Vendas")
    hr = await make_user(db, company, role="manager")
    cycle = await db.fetchval(
        """INSERT INTO public.management_cycles (company_id, name, start_date, end_date)
           VALUES ($1, '2026', '2026-01-01', '2026-12-31') RETURNING id""",
        company,
    )
    goal = await db.fetchval(
        "INSERT INTO public.goals (cycle_id, department_id, company_id, title) VALUES ($1, $2, $3, 'Vendas') RETURNING id",
        cycle, dept, company,
    )
    token = emitir(sub=await email_of(db, hr))

    with_file = await agente(
        f"/goals/{goal}/comments", token, method="POST",
        data={"body": "oi"}, files={"files": ("x.txt", b"conteudo", "text/plain")},
    )
    text_only = await agente(f"/goals/{goal}/comments", token, method="POST", data={"body": "Bom mês"})

    assert with_file.status_code == 403
    assert text_only.status_code == 201
    assert await db.fetchval("SELECT count(*) FROM public.goal_comments WHERE goal_id = $1", goal) == 1
