"""Colaborador edita o próprio pedido (solicitação) enquanto ele está pendente."""
from tests.db.conftest import make_company, make_user

REASON = "Consulta de rotina marcada"
NEW_REASON = "Exame de sangue no laboratório"


async def _setup(db, client_as):
    company = await make_company(db)
    owner = await make_user(db, company, name="Welton")
    types = (await client_as(owner).get("/requests/types")).json()
    by_name = {t["name"]: t["id"] for t in types}
    created = (await client_as(owner).post("/requests/request", json={
        "type_id": by_name["Ida ao médico"], "start_date": "2027-01-05",
        "start_time": "10:00", "end_time": "11:30", "reason": REASON,
    })).json()
    return company, owner, by_name, created


async def test_dono_edita_pedido_pendente(db, client_as):
    company, owner, types, created = await _setup(db, client_as)
    assert created["updated_at"] is None

    r = await client_as(owner).put(f"/requests/{created['id']}", json={
        "type_id": types["Saída pessoal"], "start_date": "2027-01-06", "end_date": "2027-01-07",
        "reason": "  " + NEW_REASON + "  ",
    })
    assert r.status_code == 200
    body = r.json()
    assert body["type_name"] == "Saída pessoal"
    assert (body["start_date"], body["end_date"], body["days"]) == ("2027-01-06", "2027-01-07", 2)
    assert body["start_time"] is None and body["end_time"] is None
    assert body["reason"] == NEW_REASON
    assert body["status"] == "pending"
    assert body["created_at"] == created["created_at"]
    assert body["updated_at"] is not None

    hr = await make_user(db, company, role="manager")
    team = (await client_as(hr).get("/requests/team")).json()
    assert next(x for x in team if x["id"] == created["id"])["updated_at"] == body["updated_at"]


async def test_edicao_valida_como_na_criacao(db, client_as):
    _, owner, types, created = await _setup(db, client_as)
    c = client_as(owner)
    base = {"type_id": types["Outro"], "start_date": "2027-01-06", "end_date": "2027-01-06"}
    r = await c.put(f"/requests/{created['id']}", json={**base, "reason": "curto"})
    assert r.status_code == 400 and r.json()["detail"] == "O motivo precisa ter pelo menos 20 caracteres"
    r = await c.put(f"/requests/{created['id']}", json={**base, "end_date": "2027-01-05", "reason": NEW_REASON})
    assert r.status_code == 400
    row = await db.fetchrow("SELECT reason, updated_at FROM public.hr_requests WHERE id = $1::uuid", created["id"])
    assert row["reason"] == REASON and row["updated_at"] is None


async def test_outra_pessoa_e_rh_nao_editam(db, client_as):
    company, owner, types, created = await _setup(db, client_as)
    other = await make_user(db, company, name="Outra")
    hr = await make_user(db, company, role="manager")
    payload = {"type_id": types["Outro"], "start_date": "2027-01-06", "end_date": "2027-01-06", "reason": NEW_REASON}
    for user in (other, hr):
        assert (await client_as(user).put(f"/requests/{created['id']}", json=payload)).status_code == 404
    assert await db.fetchval("SELECT reason FROM public.hr_requests WHERE id = $1::uuid", created["id"]) == REASON


async def test_pedido_ja_decidido_nao_edita(db, client_as):
    company, owner, types, created = await _setup(db, client_as)
    hr = await make_user(db, company, role="manager")
    await client_as(hr).put(f"/requests/{created['id']}/approve", json={})
    r = await client_as(owner).put(f"/requests/{created['id']}", json={
        "type_id": types["Outro"], "start_date": "2027-01-06", "end_date": "2027-01-06", "reason": NEW_REASON,
    })
    assert r.status_code == 409 and r.json()["detail"] == "Solicitação já não está pendente"
    assert await db.fetchval("SELECT status FROM public.hr_requests WHERE id = $1::uuid", created["id"]) == "approved"
