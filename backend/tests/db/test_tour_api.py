from tests.db.conftest import make_company, make_user

T = "boas-vindas-colaborador"


async def _backdate(db, column):
    # now() é o início da transação do teste: sem isso, "só na 1ª vez" nunca falharia.
    await db.execute(f"UPDATE public.tour_progress SET {column} = '2020-01-01T00:00:00Z'")


async def _user(db, name="Ana"):
    return await make_user(db, await make_company(db), name=name)


async def test_get_empty_list(db, client_as):
    c = client_as(await _user(db))
    r = await c.get("/tour/progress")
    assert r.status_code == 200 and r.json() == []


async def test_put_creates_with_started_at_and_step(db, client_as):
    c = client_as(await _user(db))
    first = (await c.put(f"/tour/progress/{T}", json={"version": 1, "step": 2})).json()
    assert first["step"] == 2 and first["started_at"] is not None and first["tour"] == T
    await _backdate(db, "started_at")
    second = (await c.put(f"/tour/progress/{T}", json={"version": 1, "step": 3})).json()
    assert second["step"] == 3 and second["started_at"].startswith("2020-01-01")


async def test_put_updates_version_only_while_not_completed(db, client_as):
    c = client_as(await _user(db))
    await c.put(f"/tour/progress/{T}", json={"version": 1, "step": 1})
    assert (await c.put(f"/tour/progress/{T}", json={"version": 2, "step": 0})).json()["version"] == 2
    await c.post(f"/tour/progress/{T}/complete", json={"version": 2})
    body = (await c.put(f"/tour/progress/{T}", json={"version": 3, "step": 0})).json()
    assert body["version"] == 2


async def test_put_after_complete_on_v1_keeps_v1(db, client_as):
    c = client_as(await _user(db))
    await c.post(f"/tour/progress/{T}/complete", json={"version": 1})
    body = (await c.put(f"/tour/progress/{T}", json={"version": 2, "step": 0})).json()
    assert body["version"] == 1


async def test_complete_keeps_first_date_and_version_only_rises(db, client_as):
    c = client_as(await _user(db))
    await c.post(f"/tour/progress/{T}/complete", json={"version": 2})
    await _backdate(db, "completed_at")
    await _backdate(db, "started_at")
    b = (await c.post(f"/tour/progress/{T}/complete", json={"version": 1})).json()
    assert b["version"] == 2 and b["completed_at"].startswith("2020-01-01")
    assert b["started_at"].startswith("2020-01-01")
    d = (await c.post(f"/tour/progress/{T}/complete", json={"version": 3})).json()
    assert d["version"] == 3 and d["completed_at"].startswith("2020-01-01")


async def test_complete_without_put_sets_started_at(db, client_as):
    c = client_as(await _user(db))
    body = (await c.post(f"/tour/progress/{T}/complete", json={"version": 1})).json()
    assert body["started_at"] is not None and body["completed_at"] is not None


async def test_dismiss_keeps_first_date(db, client_as):
    c = client_as(await _user(db))
    a = (await c.post(f"/tour/progress/{T}/dismiss", json={"version": 1})).json()
    assert a["dismissed_at"] is not None
    await _backdate(db, "dismissed_at")
    b = (await c.post(f"/tour/progress/{T}/dismiss", json={"version": 1})).json()
    assert b["dismissed_at"].startswith("2020-01-01")


async def test_decline_caps_at_3(db, client_as):
    c = client_as(await _user(db))
    for _ in range(4):
        r = await c.post(f"/tour/progress/{T}/decline-invite", json={"version": 1})
    assert r.status_code == 200 and r.json()["invites_declined"] == 3


async def test_body_with_user_id_is_422(db, client_as):
    user = await _user(db)
    r = await client_as(user).put(
        f"/tour/progress/{T}", json={"version": 1, "step": 0, "user_id": user}
    )
    assert r.status_code == 422


async def test_bad_tour_id_is_422(db, client_as):
    c = client_as(await _user(db))
    assert (await c.put("/tour/progress/Boas%20Vindas", json={"version": 1, "step": 0})).status_code == 422
    assert (await c.post("/tour/progress/Boas%20Vindas/complete", json={"version": 1})).status_code == 422


async def test_version_out_of_range_is_422(db, client_as):
    c = client_as(await _user(db))
    for v in (0, 1000):
        assert (await c.put(f"/tour/progress/{T}", json={"version": v, "step": 0})).status_code == 422
    assert (await c.put(f"/tour/progress/{T}", json={"version": 1, "step": 1000})).status_code == 422
    assert (await c.put(f"/tour/progress/{T}", json={"version": 1, "step": -1})).status_code == 422


async def test_cap_of_50_tours_is_422(db, client_as):
    user = await _user(db)
    await db.execute(
        """INSERT INTO public.tour_progress (user_id, tour, version)
           SELECT $1, 'tour-' || n, 1 FROM generate_series(1, 50) AS n""",
        user,
    )
    c = client_as(user)
    assert (await c.put("/tour/progress/tour-novo", json={"version": 1, "step": 0})).status_code == 422
    assert (await c.put("/tour/progress/tour-7", json={"version": 1, "step": 1})).status_code == 200


async def test_users_are_isolated(db, client_as):
    a, b = await _user(db, "Ana"), await _user(db, "Beto")
    await client_as(a).put(f"/tour/progress/{T}", json={"version": 1, "step": 4})
    assert (await client_as(b).get("/tour/progress")).json() == []
    rb = (await client_as(b).put(f"/tour/progress/{T}", json={"version": 1, "step": 1})).json()
    assert rb["step"] == 1
    assert (await client_as(a).get("/tour/progress")).json()[0]["step"] == 4
