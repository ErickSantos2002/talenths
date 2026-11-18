"""Salário, CPF, telefone e nascimento de colega só para o RH (e o próprio)."""

from tests.db.conftest import make_company, make_user

SENSITIVE = ("current_salary", "cpf", "phone", "birth_date")


async def fill_sensitive(db, user_id):
    await db.execute(
        """UPDATE public.profiles
           SET current_salary = 9999, cpf = '000.000.000-00', phone = '11 99999-9999',
               birth_date = '1990-01-01', hire_date = '2020-01-01'
           WHERE user_id = $1""",
        user_id,
    )


async def test_colaborador_nao_ve_dado_sensivel_de_colega(db, client_as):
    company = await make_company(db)
    me = await make_user(db, company, name="Eu")
    colleague = await make_user(db, company, name="Colega")
    await fill_sensitive(db, colleague)
    client = client_as(me)

    one = (await client.get(f"/profiles/{colleague}")).json()
    listed = [p for p in (await client.get("/profiles")).json() if str(p["user_id"]) == colleague]

    for data in (one, listed[0]):
        assert data["name"] == "Colega"
        assert str(data["hire_date"]) == "2020-01-01"
        assert not set(SENSITIVE) & set(data)


async def test_colaborador_ve_o_proprio_dado_sensivel(db, client_as):
    company = await make_company(db)
    me = await make_user(db, company)
    await fill_sensitive(db, me)
    client = client_as(me)

    one = (await client.get(f"/profiles/{me}")).json()
    listed = [p for p in (await client.get("/profiles")).json() if str(p["user_id"]) == me]

    for data in (one, listed[0]):
        assert data["cpf"] == "000.000.000-00"
        assert float(data["current_salary"]) == 9999


async def test_rh_ve_dado_sensivel_de_todos(db, client_as):
    company = await make_company(db)
    colleague = await make_user(db, company)
    await fill_sensitive(db, colleague)

    for role in ("manager", "master_admin"):
        client = client_as(await make_user(db, company, role=role))
        one = (await client.get(f"/profiles/{colleague}")).json()
        listed = [p for p in (await client.get("/profiles")).json() if str(p["user_id"]) == colleague]
        for data in (one, listed[0]):
            assert data["cpf"] == "000.000.000-00", role
            assert float(data["current_salary"]) == 9999, role


async def test_notas_da_avaliacao_so_para_o_rh(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    colleague = await make_user(db, company)
    hr = await make_user(db, company, role="manager")
    cycle = await db.fetchval(
        "INSERT INTO public.evaluation_cycles (company_id, name) VALUES ($1, 'Ciclo') RETURNING id", company
    )
    qs = f"cycle_id={cycle}&evaluated_user_id={colleague}"

    assert (await client_as(user).get(f"/evaluations/scores?{qs}")).status_code == 403
    assert (await client_as(hr).get(f"/evaluations/scores?{qs}")).status_code == 200


async def test_patch_me_nao_troca_empresa_nem_departamento(db, client_as):
    company = await make_company(db)
    other = await make_company(db)
    me = await make_user(db, company)

    r = await client_as(me).patch("/profiles/me", json={"name": "Novo", "company_id": other})

    assert r.status_code == 200
    row = await db.fetchrow("SELECT name, company_id::text FROM public.profiles WHERE user_id = $1", me)
    assert (row["name"], row["company_id"]) == ("Novo", company)
