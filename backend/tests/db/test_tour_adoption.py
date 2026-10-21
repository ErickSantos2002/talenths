from tests.db.conftest import make_company, make_department, make_user

COLAB = "boas-vindas-colaborador"
GESTOR = "boas-vindas-gestor"


async def _adoption(client):
    r = await client.get("/tour/adoption")
    assert r.status_code == 200
    return {row["name"]: row for row in r.json()}


async def test_manager_sees_company_with_status(db, client_as):
    company = await make_company(db)
    dept = await make_department(db, company, "Vendas")
    boss = await make_user(db, company, name="Chefe", role="manager")
    done = await make_user(db, company, dept, name="Concluiu")
    going = await make_user(db, company, name="Andamento")
    await make_user(db, company, name="Sem linha")
    for uid, extra in (
        (done, "started_at = now(), completed_at = now()"),
        (going, "started_at = now(), step = 2"),
    ):
        await db.execute(
            """INSERT INTO public.tour_progress (user_id, company_id, tour, version)
               VALUES ($1, $2, $3, 1)""",
            uid, company, COLAB,
        )
        await db.execute(f"UPDATE public.tour_progress SET {extra} WHERE user_id = $1", uid)

    rows = await _adoption(client_as(boss))
    assert set(rows) == {"Chefe", "Concluiu", "Andamento", "Sem linha"}
    assert rows["Concluiu"]["status"] == "completed"
    assert rows["Concluiu"]["department"] == "Vendas"
    assert rows["Concluiu"]["audience"] == "collaborator"
    assert rows["Concluiu"]["tour"] == COLAB
    assert rows["Andamento"]["status"] == "in_progress" and rows["Andamento"]["step"] == 2
    assert rows["Sem linha"]["status"] == "not_started"
    assert rows["Sem linha"]["version"] is None and rows["Sem linha"]["step"] is None


async def test_manager_audience_uses_manager_tour(db, client_as):
    company = await make_company(db)
    boss = await make_user(db, company, name="Chefe", role="manager")
    await db.execute(
        """INSERT INTO public.tour_progress (user_id, company_id, tour, version, started_at, completed_at)
           VALUES ($1, $2, $3, 1, now(), now())""",
        boss, company, COLAB,
    )
    row = (await _adoption(client_as(boss)))["Chefe"]
    assert row["audience"] == "manager" and row["tour"] == GESTOR
    assert row["status"] == "not_started"


async def test_other_company_not_visible(db, client_as):
    a = await make_company(db)
    b = await make_company(db)
    boss_a = await make_user(db, a, name="Chefe A", role="manager")
    await make_user(db, a, name="Pessoa A")
    boss_b = await make_user(db, b, name="Chefe B", role="manager")
    assert set(await _adoption(client_as(boss_b))) == {"Chefe B"}
    assert "Chefe B" not in await _adoption(client_as(boss_a))


async def test_collaborator_gets_403(db, client_as):
    user = await make_user(db, await make_company(db))
    assert (await client_as(user).get("/tour/adoption")).status_code == 403


async def test_adoption_does_not_create_rows(db, client_as):
    company = await make_company(db)
    boss = await make_user(db, company, role="manager")
    await make_user(db, company)
    await client_as(boss).get("/tour/adoption")
    assert await db.fetchval("SELECT count(*) FROM public.tour_progress") == 0
