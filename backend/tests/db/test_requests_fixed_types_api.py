"""Solicitações: tipos fixos (3 de saída + Pagar hora), todos com aprovação, e motivo obrigatório (mín. 20 caracteres)."""
from tests.db.conftest import make_company, make_user

FIXED = {"Ida ao médico", "Saída pessoal", "Outro", "Pagar hora"}
REASON_OK = "Consulta de rotina marcada"  # 26 caracteres


async def _types(client):
    return (await client.get("/requests/types")).json()


async def test_empresa_nova_ganha_os_tipos_fixos_com_aprovacao(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    types = await _types(client_as(user))
    assert {t["name"] for t in types} == FIXED
    assert all(t["requires_approval"] for t in types)


async def test_rh_nao_cria_edita_nem_apaga_tipo(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    c = client_as(hr)
    type_id = (await _types(c))[0]["id"]
    assert (await c.post("/requests/types", json={"name": "Férias"})).status_code in (404, 405)
    assert (await c.put(f"/requests/types/{type_id}", json={"name": "X"})).status_code in (404, 405)
    assert (await c.delete(f"/requests/types/{type_id}")).status_code in (404, 405)
    assert {t["name"] for t in await _types(c)} == FIXED


async def _post(c, type_id, reason):
    body = {"type_id": type_id, "start_date": "2027-03-01", "start_time": "09:00", "end_time": "10:00"}
    if reason is not None:
        body["reason"] = reason
    return await c.post("/requests/request", json=body)


async def test_motivo_obrigatorio_com_20_caracteres(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    c = client_as(user)
    type_id = (await _types(c))[0]["id"]
    for reason in (None, "", " " * 30, "a" * 19, "   " + "a" * 19 + "   "):
        r = await _post(c, type_id, reason)
        assert r.status_code == 400, reason
        assert r.json()["detail"] == "O motivo precisa ter pelo menos 20 caracteres"
    assert await db.fetchval("SELECT count(*) FROM public.hr_requests WHERE user_id = $1", user) == 0

    r = await _post(c, type_id, "  " + "a" * 20 + "  ")
    assert r.status_code == 201
    assert r.json()["reason"] == "a" * 20
    assert r.json()["status"] == "pending"
