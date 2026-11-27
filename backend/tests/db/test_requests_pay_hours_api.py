"""Pagar hora: pedido de hora extra com horário, aprovado pelo RH como a saída."""
from tests.db.conftest import make_company, make_user

REASON = "Compensar a saída ao médico de terça"  # >= 20 caracteres
CATEGORY_MSG = "Não é possível trocar a categoria da solicitação"


async def _types(c):
    return {t["name"]: t for t in (await c.get("/requests/types")).json()}


def _pay(type_id, start="18:00", end="20:00", **extra):
    body = {"type_id": type_id, "start_date": "2027-03-02", "end_date": "2027-03-02", "reason": REASON}
    if start is not None:
        body |= {"start_time": start, "end_time": end}
    return body | extra


async def test_tipos_incluem_pagar_hora(db, client_as):
    company = await make_company(db)
    types = await _types(client_as(await make_user(db, company)))
    assert set(types) == {"Ida ao médico", "Saída pessoal", "Outro", "Pagar hora"}
    assert types["Pagar hora"]["category"] == "pagar_hora"
    assert {types[n]["category"] for n in ("Ida ao médico", "Saída pessoal", "Outro")} == {"saida"}


async def test_pagar_hora_exige_horario(db, client_as):
    company = await make_company(db)
    c = client_as(await make_user(db, company))
    pay = (await _types(c))["Pagar hora"]["id"]

    r = await c.post("/requests/request", json=_pay(pay, start=None))
    assert r.status_code == 400
    assert r.json()["detail"] == "Pagar hora precisa do horário de início e de fim"

    r = await c.post("/requests/request", json=_pay(pay))
    assert r.status_code == 201
    body = r.json()
    assert body["type_category"] == "pagar_hora"
    assert body["days"] == 0
    assert body["status"] == "pending"
    assert (body["start_time"], body["end_time"]) == ("18:00", "20:00")


async def test_pagar_hora_fim_antes_do_inicio(db, client_as):
    company = await make_company(db)
    c = client_as(await make_user(db, company))
    pay = (await _types(c))["Pagar hora"]["id"]
    for end in ("17:00", "18:00"):
        r = await c.post("/requests/request", json=_pay(pay, end=end))
        assert r.status_code == 400, end
        assert r.json()["detail"] == "Horário de fim deve ser após o horário de início"


async def test_editar_nao_troca_categoria(db, client_as):
    company = await make_company(db)
    c = client_as(await make_user(db, company))
    types = await _types(c)
    pay, leave = types["Pagar hora"]["id"], types["Saída pessoal"]["id"]

    pay_req = (await c.post("/requests/request", json=_pay(pay))).json()
    r = await c.put(f"/requests/{pay_req['id']}", json=_pay(leave))
    assert r.status_code == 400
    assert r.json()["detail"] == CATEGORY_MSG

    leave_req = (await c.post("/requests/request", json=_pay(leave))).json()
    r = await c.put(f"/requests/{leave_req['id']}", json=_pay(pay))
    assert r.status_code == 400
    assert r.json()["detail"] == CATEGORY_MSG

    mine = {x["id"]: x for x in (await c.get("/requests/my")).json()}
    assert mine[pay_req["id"]]["type_category"] == "pagar_hora"
    assert mine[leave_req["id"]]["type_category"] == "saida"


async def test_historico_filtra_por_categoria(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    types = await _types(client_as(user))
    ids = {}
    for name in ("Pagar hora", "Saída pessoal"):
        ids[name] = (await client_as(user).post("/requests/request", json=_pay(types[name]["id"]))).json()["id"]
        assert (await client_as(hr).put(f"/requests/{ids[name]}/approve", json={})).status_code == 200

    page = (await client_as(hr).get("/requests/team/history", params={"category": "pagar_hora"})).json()
    assert [i["id"] for i in page["items"]] == [ids["Pagar hora"]]
    assert page["total"] == 1
