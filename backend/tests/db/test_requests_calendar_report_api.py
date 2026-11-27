"""Pagar hora não entra no calendário (quem paga hora não está fora); o relatório diz a categoria."""
from tests.db.conftest import make_company, make_user

REASON = "Compensar a saída ao médico de terça"


async def _approved_pair(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, name="Ana")
    hr = await make_user(db, company, role="manager")
    types = {t["name"]: t["id"] for t in (await client_as(user).get("/requests/types")).json()}
    body = {"start_date": "2027-03-02", "end_date": "2027-03-02", "start_time": "18:00",
            "end_time": "20:00", "reason": REASON}
    ids = {}
    for name in ("Pagar hora", "Saída pessoal"):
        ids[name] = (await client_as(user).post("/requests/request", json=body | {"type_id": types[name]})).json()["id"]
        assert (await client_as(hr).put(f"/requests/{ids[name]}/approve", json={})).status_code == 200
    return user, hr, ids


async def test_feed_sem_pagar_hora(db, client_as):
    user, hr, ids = await _approved_pair(db, client_as)
    for who in (hr, user):
        items = (await client_as(who).get("/calendar/feed")).json()
        absence_ids = {i["id"] for i in items if i["source"] == "absence"}
        assert ids["Saída pessoal"] in absence_ids
        assert ids["Pagar hora"] not in absence_ids
    cal = {i["id"] for i in (await client_as(user).get("/requests/calendar")).json()}
    assert cal == {ids["Saída pessoal"]}


async def test_relatorio_tem_categoria(db, client_as):
    _, hr, _ = await _approved_pair(db, client_as)
    r = await client_as(hr).get("/reports/requests")
    assert r.status_code == 200
    assert "solicitacoes.csv" in r.headers["content-disposition"]
    text = r.content.decode("utf-8-sig")
    header, *rows = text.splitlines()
    assert "Categoria" in header
    assert any("Pagar hora" in row for row in rows)
    assert any(";Saída;" in row or ",Saída," in row for row in rows)


async def test_relatorio_pelo_apelido_igual_ao_de_antes(db, client_as):
    """O HS.OS ainda lê /reports/absences: só saídas, sem a coluna nova."""
    _, hr, _ = await _approved_pair(db, client_as)
    r = await client_as(hr).get("/reports/absences")
    assert r.status_code == 200
    assert "ausencias.csv" in r.headers["content-disposition"]
    header, *rows = r.content.decode("utf-8-sig").splitlines()
    assert "Categoria" not in header
    assert rows and not any("Pagar hora" in row for row in rows)
