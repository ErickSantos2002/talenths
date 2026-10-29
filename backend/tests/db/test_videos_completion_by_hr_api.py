from datetime import date, timedelta

import pytest

from app import video_storage
from tests.db.conftest import make_company, make_user
from tests.db.test_videos_admin_api import _create, _rules, _upload, _viewer
from tests.db.test_videos_upload_api import SMALL

DAY = (date.today() - timedelta(days=40)).isoformat()


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    ana = await make_user(db, company, name="Ana")
    bia = await make_user(db, company, name="Bia")
    return company, manager, ana, bia


def register(c, video_id, user_id, day=DAY):
    return c.post(f"/videos/{video_id}/viewers/{user_id}/complete", json={"completed_on": day})


def undo(c, video_id, user_id):
    return c.post(f"/videos/{video_id}/viewers/{user_id}/uncomplete")


async def detail(c, video_id):
    r = await c.get(f"/videos/{video_id}/admin")
    assert r.status_code == 200, r.text
    return r.json()


def row(rows, user_id):
    return next((x for x in rows if x["user_id"] == user_id), None)


async def test_register_required_pending(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana, bia]))

    r = await register(c, video["id"], ana)

    assert r.status_code == 200, r.text
    d = await detail(c, video["id"])
    a = row(d["required"], ana)
    assert (a["status"], a["registered_by_hr"], a["progress_pct"]) == ("concluido", True, 100)
    assert str(a["completed_at"])[:10] == DAY
    assert row(d["required"], bia)["registered_by_hr"] is False
    v = await _viewer(db, video["id"], ana)
    assert str(v["completed_by"]) == manager and v["completed_registered_at"] is not None
    listing = (await c.get("/videos/admin")).json()
    assert [x["completed_count"] for x in listing if x["id"] == video["id"]] == [1]


async def test_register_not_required_goes_to_voluntary(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))

    assert (await register(c, video["id"], bia)).status_code == 200

    d = await detail(c, video["id"])
    assert row(d["required"], bia) is None
    b = row(d["voluntary"], bia)
    assert (b["status"], b["registered_by_hr"]) == ("concluido", True)


async def test_register_keeps_partial_progress_on_undo(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    await db.execute(
        "UPDATE public.internal_video_viewers SET max_watched_s = 2 WHERE video_id = $1::uuid AND user_id = $2::uuid",
        video["id"], ana,
    )

    assert (await register(c, video["id"], ana)).status_code == 200
    assert (await undo(c, video["id"], ana)).status_code == 200

    v = await _viewer(db, video["id"], ana)
    assert (float(v["max_watched_s"]), v["completed_at"], v["completed_by"]) == (2.0, None, None)
    assert row((await detail(c, video["id"]))["required"], ana)["status"] in ("em_andamento", "pendente")


async def test_register_excluded_then_undo_hides_again(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    assert (await c.post(f"/videos/{video['id']}/viewers/{ana}/remove")).status_code == 200

    assert (await register(c, video["id"], ana)).status_code == 200
    assert row((await detail(c, video["id"]))["voluntary"], ana)["registered_by_hr"] is True

    assert (await undo(c, video["id"], ana)).status_code == 200
    d = await detail(c, video["id"])
    assert row(d["voluntary"], ana) is None and row(d["required"], ana) is None


async def test_cannot_register_already_completed(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    await db.execute(
        "UPDATE public.internal_video_viewers SET completed_at = now() WHERE video_id = $1::uuid AND user_id = $2::uuid",
        video["id"], ana,
    )

    r = await register(c, video["id"], ana)

    assert (r.status_code, r.json()["detail"]) == (409, "Esta pessoa já concluiu este vídeo")
    assert (await register(c, video["id"], bia)).status_code == 200
    r = await register(c, video["id"], bia)
    assert r.status_code == 409


async def test_future_date_is_422(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))

    r = await register(c, video["id"], ana, (date.today() + timedelta(days=1)).isoformat())

    assert r.status_code == 422, r.text
    assert (await _viewer(db, video["id"], ana))["completed_at"] is None


async def test_deactivated_target_is_422(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", bia)

    r = await register(c, video["id"], bia)

    assert (r.status_code, r.json()["detail"]) == (422, "Colaborador desligado")


async def test_other_company_target_is_404(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    stranger = await make_user(db, await make_company(db), name="Estranha")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))

    r = await register(c, video["id"], stranger)

    assert (r.status_code, r.json()["detail"]) == (404, "Colaborador não encontrado")


async def test_user_role_is_403(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[ana]))

    assert (await register(client_as(bia), video["id"], ana)).status_code == 403
    assert (await undo(client_as(bia), video["id"], ana)).status_code == 403


async def test_undo_system_completion_is_409(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    await db.execute(
        "UPDATE public.internal_video_viewers SET completed_at = now() WHERE video_id = $1::uuid AND user_id = $2::uuid",
        video["id"], ana,
    )

    r = await undo(c, video["id"], ana)

    assert (r.status_code, r.json()["detail"]) == (409, "Só dá para desfazer conclusões registradas pelo RH")
    assert (await _viewer(db, video["id"], ana))["completed_at"] is not None


async def test_undo_restores_pending(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    assert (await register(c, video["id"], ana)).status_code == 200

    assert (await undo(c, video["id"], ana)).status_code == 200

    a = row((await detail(c, video["id"]))["required"], ana)
    assert (a["status"], a["registered_by_hr"], a["completed_at"]) == ("pendente", False, None)


async def test_progress_after_registration_keeps_completed(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[ana]))
    assert (await register(client_as(manager), video["id"], ana)).status_code == 200

    r = await client_as(ana).post(f"/videos/{video['id']}/progress", json={"position_s": 1})

    assert r.status_code == 200, r.text
    assert r.json()["completed"] is True
    assert (await _viewer(db, video["id"], ana))["completed_by"] is not None


async def test_replace_file_reset_all_clears_registration(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    assert (await register(c, video["id"], ana)).status_code == 200

    upload_id = await _upload(c, sample_mp4)
    r = await c.post(f"/videos/{video['id']}/replace-file", json={"upload_id": upload_id, "mode": "reset_all"})

    assert r.status_code == 200, r.text
    v = await _viewer(db, video["id"], ana)
    assert (v["completed_at"], v["completed_by"], v["completed_registered_at"]) == (None, None, None)


async def test_replace_file_keep_completed_keeps_registration(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[ana]))
    assert (await register(c, video["id"], ana)).status_code == 200

    upload_id = await _upload(c, sample_mp4)
    r = await c.post(f"/videos/{video['id']}/replace-file", json={"upload_id": upload_id, "mode": "keep_completed"})

    assert r.status_code == 200, r.text
    assert (await _viewer(db, video["id"], ana))["completed_by"] is not None


async def test_registration_survives_deleting_who_registered(db, client_as, sample_mp4):
    company, manager, ana, bia = await setup(db)
    other_manager = await make_user(db, company, name="Outra Gestora", role="manager")
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[ana]))
    assert (await register(client_as(other_manager), video["id"], ana)).status_code == 200

    await db.execute("DELETE FROM auth.users WHERE id = $1", other_manager)

    c = client_as(manager)
    assert row((await detail(c, video["id"]))["required"], ana)["registered_by_hr"] is True
    assert (await undo(c, video["id"], ana)).status_code == 200
