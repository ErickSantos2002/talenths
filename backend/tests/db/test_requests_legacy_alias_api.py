"""O apelido /absences (HS.OS ainda não migrado) responde só saídas, como antes da 040."""
from tests.db.conftest import make_company, make_user

REASON = "Compensar a saída ao médico de terça"


async def _setup(db, client_as):
    """→ (colaborador, RH, tipos, id do pagar hora, id da saída). O client_as troca o
    usuário de forma global: criar o cliente logo antes de usar."""
    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    types = {t["name"]: t["id"] for t in (await client_as(user).get("/requests/types")).json()}
    body = {"start_date": "2027-03-02", "end_date": "2027-03-02", "start_time": "18:00",
            "end_time": "20:00", "reason": REASON}
    c = client_as(user)
    pay = (await c.post("/requests/request", json=body | {"type_id": types["Pagar hora"]})).json()["id"]
    leave = (await c.post("/requests/request", json=body | {"type_id": types["Saída pessoal"]})).json()["id"]
    return user, hr, types, pay, leave


async def test_alias_tipos_so_saida(db, client_as):
    user, _, _, _, _ = await _setup(db, client_as)
    names = {t["name"] for t in (await client_as(user).get("/absences/types")).json()}
    assert names == {"Ida ao médico", "Saída pessoal", "Outro"}


async def test_alias_listas_escondem_pagar_hora(db, client_as):
    user, hr, _, pay, leave = await _setup(db, client_as)
    for who, path in ((user, "/absences/my"), (hr, "/absences/team"), (hr, "/absences/team/pending")):
        assert [i["id"] for i in (await client_as(who).get(path)).json()] == [leave], path
    assert {i["id"] for i in (await client_as(hr).get("/requests/team/pending")).json()} == {pay, leave}


async def test_alias_nao_cria_pagar_hora(db, client_as):
    user, _, types, _, _ = await _setup(db, client_as)
    before = await db.fetchval("SELECT count(*) FROM public.hr_requests")
    r = await client_as(user).post("/absences/request", json={
        "type_id": types["Pagar hora"], "start_date": "2027-03-03", "end_date": "2027-03-03",
        "start_time": "18:00", "end_time": "20:00", "reason": REASON,
    })
    assert r.status_code == 404
    assert r.json()["detail"] == "Tipo de solicitação não encontrado"
    assert await db.fetchval("SELECT count(*) FROM public.hr_requests") == before


async def test_alias_aprova_saida(db, client_as):
    _, hr, _, _, leave = await _setup(db, client_as)
    r = await client_as(hr).put(f"/absences/{leave}/approve", json={})
    assert r.status_code == 200
    assert r.json()["status"] == "approved"
