import pytest

from app import video_storage
from tests.db.conftest import make_company, make_user
from tests.db.test_029_internal_videos import make_video
from tests.db.test_videos_admin_api import _create, _rules
from tests.db.test_videos_upload_api import SMALL


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def _setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    user = await make_user(db, company, name="Ana")
    return company, manager, user


async def _admin_order(c) -> list[tuple[str, int | None]]:
    r = await c.get("/videos/admin")
    assert r.status_code == 200, r.text
    return [(v["title"], v["order"]) for v in r.json()]


async def test_insert_goes_to_the_end_per_company(db):
    a = await make_company(db)
    b = await make_company(db)
    first = await make_video(db, a, "1")
    second = await make_video(db, a, "2")
    other = await make_video(db, b, "x")
    positions = {
        str(r["id"]): r["position"]
        for r in await db.fetch("SELECT id, position FROM public.internal_videos")
    }
    assert positions[first] == 1 and positions[second] == 2 and positions[other] == 1


async def test_admin_list_follows_position_and_numbers_active_only(db, client_as, sample_mp4):
    company, manager, _ = await _setup(db)
    m = client_as(manager)
    for title in ("A", "B", "C"):
        await _create(m, sample_mp4, _rules(all=True), title=title)
    videos = (await m.get("/videos/admin")).json()
    b = next(v for v in videos if v["title"] == "B")
    assert (await m.post(f"/videos/{b['id']}/archive")).status_code == 200

    assert await _admin_order(m) == [("A", 1), ("C", 2), ("B", None)]


async def test_move_up_and_down(db, client_as, sample_mp4):
    company, manager, _ = await _setup(db)
    m = client_as(manager)
    ids = {}
    for title in ("A", "B", "C"):
        ids[title] = (await _create(m, sample_mp4, _rules(all=True), title=title))["id"]

    r = await m.post(f"/videos/{ids['C']}/move", json={"direction": "up"})
    assert r.status_code == 204, r.text
    assert await _admin_order(m) == [("A", 1), ("C", 2), ("B", 3)]

    assert (await m.post(f"/videos/{ids['A']}/move", json={"direction": "down"})).status_code == 204
    assert await _admin_order(m) == [("C", 1), ("A", 2), ("B", 3)]

    # Already at the edge: nothing changes.
    assert (await m.post(f"/videos/{ids['C']}/move", json={"direction": "up"})).status_code == 204
    assert (await m.post(f"/videos/{ids['B']}/move", json={"direction": "down"})).status_code == 204
    assert await _admin_order(m) == [("C", 1), ("A", 2), ("B", 3)]


async def test_move_skips_archived_and_rejects_moving_one(db, client_as, sample_mp4):
    company, manager, _ = await _setup(db)
    m = client_as(manager)
    ids = {}
    for title in ("A", "B", "C"):
        ids[title] = (await _create(m, sample_mp4, _rules(all=True), title=title))["id"]
    assert (await m.post(f"/videos/{ids['B']}/archive")).status_code == 200

    assert (await m.post(f"/videos/{ids['C']}/move", json={"direction": "up"})).status_code == 204
    assert await _admin_order(m) == [("C", 1), ("A", 2), ("B", None)]

    r = await m.post(f"/videos/{ids['B']}/move", json={"direction": "up"})
    assert r.status_code == 409


async def test_unarchive_goes_to_the_end(db, client_as, sample_mp4):
    company, manager, _ = await _setup(db)
    m = client_as(manager)
    ids = {}
    for title in ("A", "B", "C"):
        ids[title] = (await _create(m, sample_mp4, _rules(all=True), title=title))["id"]
    assert (await m.post(f"/videos/{ids['A']}/archive")).status_code == 200
    assert (await m.post(f"/videos/{ids['A']}/unarchive")).status_code == 200
    assert await _admin_order(m) == [("B", 1), ("C", 2), ("A", 3)]


async def test_move_access_and_validation(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    m = client_as(manager)
    video = await _create(m, sample_mp4, _rules(all=True))

    assert (await client_as(user).post(f"/videos/{video['id']}/move", json={"direction": "up"})).status_code == 403

    other_company = await make_company(db)
    other_manager = await make_user(db, other_company, role="manager")
    r = await client_as(other_manager).post(f"/videos/{video['id']}/move", json={"direction": "up"})
    assert r.status_code == 404

    assert (await m.post(f"/videos/{video['id']}/move", json={"direction": "left"})).status_code == 422
    r = await m.post(f"/videos/{video['id']}/move", json={"direction": "up", "extra": 1})
    assert r.status_code == 422


async def test_mine_uses_rh_order_and_numbers(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    m = client_as(manager)
    first = await _create(m, sample_mp4, _rules(user_ids=[user]), title="Primeiro")
    library = await _create(m, sample_mp4, _rules(), title="Biblioteca")
    third = await _create(m, sample_mp4, _rules(user_ids=[user]), title="Terceiro", due_days=3)
    # A late or finished video no longer jumps ahead of the RH order.
    await db.execute(
        """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '10 days'
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        third["id"], user)
    await db.execute(
        """UPDATE public.internal_video_viewers SET completed_at = now(), max_watched_s = 5
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        first["id"], user)

    body = (await client_as(user).get("/videos/mine")).json()
    assert [(v["id"], v["order"]) for v in body["required"]] == [(first["id"], 1), (third["id"], 3)]
    assert [(v["id"], v["order"]) for v in body["library"]] == [(library["id"], 2)]
