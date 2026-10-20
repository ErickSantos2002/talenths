from tests.db.conftest import make_company, make_user


async def _notification(db, user_id) -> str:
    return str(await db.fetchval(
        "INSERT INTO public.notifications (user_id, type, title) VALUES ($1, 'video', 'Novo vídeo') RETURNING id",
        user_id,
    ))


async def test_owner_can_mark_read_and_delete(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, name="Ana")
    nid = await _notification(db, user)
    c = client_as(user)
    assert (await c.patch(f"/notifications/{nid}/read")).status_code == 200
    assert (await c.delete(f"/notifications/{nid}")).status_code == 204


async def test_other_user_cannot_mark_read_or_delete(db, client_as):
    company = await make_company(db)
    owner = await make_user(db, company, name="Ana")
    other = await make_user(db, company, name="Beto")
    nid = await _notification(db, owner)
    c = client_as(other)
    assert (await c.patch(f"/notifications/{nid}/read")).status_code == 404
    assert (await c.delete(f"/notifications/{nid}")).status_code == 404
    row = await db.fetchrow("SELECT read FROM public.notifications WHERE id = $1::uuid", nid)
    assert row is not None and row["read"] is False
