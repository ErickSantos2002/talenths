"""Tela do RH: Pendentes completos e Histórico paginado com filtros."""
from tests.db.conftest import make_company, make_user


async def _types(db, company):
    ids = {}
    for name in ("Ida ao médico", "Saída pessoal", "Outro"):
        ids[name] = str(await db.fetchval(
            "INSERT INTO public.hr_request_types (company_id, name) VALUES ($1, $2) RETURNING id", company, name))
    return ids


async def _req(db, company, user, type_id, start, status):
    return str(await db.fetchval(
        """INSERT INTO public.hr_requests (company_id, user_id, type_id, start_date, end_date, days, status, reason)
           VALUES ($1, $2, $3, $4::text::date, $4::text::date, 1, $5, 'Motivo com mais de vinte caracteres') RETURNING id""",
        company, user, type_id, start, status,
    ))


async def _scenario(db):
    company = await make_company(db)
    hr = await make_user(db, company, name="Gestora", role="manager")
    ana = await make_user(db, company, name="Ana")
    beto = await make_user(db, company, name="Beto")
    t = await _types(db, company)
    pending = [await _req(db, company, ana, t["Outro"], f"2027-02-0{d}", "pending") for d in (1, 2)]
    # 25 decididos: Ana tem 15 (dias 1..15 de jan), Beto tem 10 (dias 16..25)
    for d in range(1, 26):
        user = ana if d <= 15 else beto
        tid = t["Ida ao médico"] if d % 2 else t["Saída pessoal"]
        await _req(db, company, user, tid, f"2027-01-{d:02d}", "approved" if d % 5 else "rejected")
    other_company = await make_company(db)
    stranger = await make_user(db, other_company)
    other_t = await _types(db, other_company)
    await _req(db, other_company, stranger, other_t["Outro"], "2027-01-10", "approved")
    return hr, ana, beto, t, pending


async def test_pendentes_vem_completos_e_so_da_empresa(db, client_as):
    hr, *_ , pending = await _scenario(db)
    body = (await client_as(hr).get("/requests/team/pending")).json()
    assert sorted(r["id"] for r in body) == sorted(pending)


async def test_historico_paginado_mais_recente_primeiro(db, client_as):
    hr, *_ = await _scenario(db)
    c = client_as(hr)
    p1 = (await c.get("/requests/team/history", params={"limit": 10})).json()
    assert (p1["total"], p1["page"], p1["limit"], p1["pages"]) == (25, 1, 10, 3)
    assert [r["start_date"] for r in p1["items"]][:2] == ["2027-01-25", "2027-01-24"]
    assert all(r["status"] != "pending" for r in p1["items"])
    p3 = (await c.get("/requests/team/history", params={"limit": 10, "page": 3})).json()
    assert len(p3["items"]) == 5 and p3["items"][-1]["start_date"] == "2027-01-01"


async def test_historico_filtra_por_pessoa_tipo_e_situacao(db, client_as):
    hr, ana, beto, t, _ = await _scenario(db)
    c = client_as(hr)

    async def total(**params):
        return (await c.get("/requests/team/history", params=params)).json()["total"]

    assert await total(user_id=beto) == 10
    assert await total(type_id=t["Ida ao médico"]) == 13
    assert await total(status="rejected") == 5
    assert await total(user_id=ana, status="rejected", type_id=t["Ida ao médico"]) == 2  # dias 5 e 15
    assert (await c.get("/requests/team/history", params={"status": "pending"})).status_code == 422


async def test_pessoas_do_filtro_sao_quem_tem_pedido(db, client_as):
    hr, ana, beto, *_ = await _scenario(db)
    body = (await client_as(hr).get("/requests/team/people")).json()
    assert body == [{"user_id": ana, "name": "Ana"}, {"user_id": beto, "name": "Beto"}]


async def test_colaborador_nao_acessa(db, client_as):
    _, ana, *_ = await _scenario(db)
    for path in ("/requests/team/pending", "/requests/team/history", "/requests/team/people"):
        assert (await client_as(ana).get(path)).status_code == 403
