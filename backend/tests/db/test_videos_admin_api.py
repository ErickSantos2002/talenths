import os

import pytest

from app import video_storage
from tests.db.conftest import make_company, make_department, make_user
from tests.db.test_videos_upload_api import SMALL, _split


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def _upload(c, data: bytes) -> str:
    info = (await c.post("/videos/uploads", json={"total_size": len(data)})).json()
    for n, part in enumerate(_split(data)):
        r = await c.put(f"/videos/uploads/{info['upload_id']}/parts/{n}", content=part)
        assert r.status_code == 204
    r = await c.post(f"/videos/uploads/{info['upload_id']}/complete")
    assert r.status_code == 200
    return info["upload_id"]


def _rules(all=False, department_ids=(), user_ids=()):
    return {"all": all, "department_ids": list(department_ids), "user_ids": list(user_ids)}


async def _create(c, data, rules, **extra) -> dict:
    upload_id = await _upload(c, data)
    r = await c.post("/videos", json={"upload_id": upload_id, "title": "Integração", "rules": rules, **extra})
    assert r.status_code == 201, r.text
    return r.json()


async def _viewer(db, video_id, user_id):
    return await db.fetchrow(
        "SELECT * FROM public.internal_video_viewers WHERE video_id = $1::uuid AND user_id = $2::uuid",
        video_id, user_id,
    )


async def _video_notes(db, user_id) -> list[str]:
    rows = await db.fetch(
        "SELECT title FROM public.notifications WHERE user_id = $1::uuid AND type = 'video' ORDER BY created_at",
        user_id,
    )
    return [r["title"] for r in rows]


async def _setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    return company, manager


async def test_create_assigns_by_rules_and_notifies(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    dept = await make_department(db, company, "Vendas")
    a = await make_user(db, company, dept, name="Ana")
    b = await make_user(db, company, dept, name="Bruno")
    x = await make_user(db, company, name="Xavier")
    outsider = await make_user(db, company, name="Fora")
    c = client_as(manager)

    video = await _create(c, sample_mp4, _rules(department_ids=[dept], user_ids=[x]), due_days=7)

    assert video["title"] == "Integração" and video["due_days"] == 7 and video["file_version"] == 1
    assert video["duration_seconds"] > 0 and "file_path" not in video
    for u in (a, b, x):
        row = await _viewer(db, video["id"], u)
        assert row["required"] is True
        assert await _video_notes(db, u) == ["Novo vídeo para assistir"]
    assert await _viewer(db, video["id"], outsider) is None
    consumed = await db.fetchval("SELECT consumed_at FROM public.internal_video_uploads")
    assert consumed is not None

    detail = (await c.get(f"/videos/{video['id']}/admin")).json()
    assert detail["rules"] == {"all": False, "department_ids": [dept], "user_ids": [x]}
    assert sorted(v["name"] for v in detail["required"]) == ["Ana", "Bruno", "Xavier"]
    row = next(v for v in detail["required"] if v["user_id"] == a)
    assert row["department"] == "Vendas" and row["status"] == "pendente" and row["progress_pct"] == 0
    assert row["due_at"] is not None


async def test_create_rejects_consumed_upload_and_foreign_targets(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    other = await make_company(db)
    foreign_dept = await make_department(db, other, "Outra")
    c = client_as(manager)
    upload_id = await _upload(c, sample_mp4)
    r = await c.post("/videos", json={"upload_id": upload_id, "title": "T", "rules": _rules(department_ids=[foreign_dept])})
    assert r.status_code == 400
    r = await c.post("/videos", json={"upload_id": upload_id, "title": "T", "rules": _rules()})
    assert r.status_code == 201
    r = await c.post("/videos", json={"upload_id": upload_id, "title": "T", "rules": _rules()})
    assert r.status_code == 409


async def test_create_requires_manager(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    r = await client_as(user).get("/videos/admin")
    assert r.status_code == 403


async def test_list_counts_exclude_former_and_excluded(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    done = await make_user(db, company, name="Concluiu")
    late = await make_user(db, company, name="Atrasado")
    gone = await make_user(db, company, name="Saiu")
    removed = await make_user(db, company, name="Removido")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[done, late, gone, removed]), due_days=3)
    vid = video["id"]
    await db.execute(
        "UPDATE public.internal_video_viewers SET completed_at = now() WHERE video_id = $1::uuid AND user_id = $2::uuid",
        vid, done)
    await db.execute(
        """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '10 days'
           WHERE video_id = $1::uuid AND user_id = ANY($2::uuid[])""",
        vid, [late, gone, removed])
    assert (await c.post(f"/videos/{vid}/viewers/{removed}/remove")).status_code == 200
    # mesma ordem de collaborators.py: perfil antes de auth.users
    await db.execute("DELETE FROM public.user_roles WHERE user_id = $1::uuid", gone)
    await db.execute("DELETE FROM public.profiles WHERE user_id = $1::uuid", gone)
    await db.execute("DELETE FROM auth.users WHERE id = $1::uuid", gone)

    items = (await c.get("/videos/admin")).json()
    assert len(items) == 1
    item = items[0]
    assert (item["required_count"], item["completed_count"], item["overdue_count"]) == (2, 1, 1)
    detail = (await c.get(f"/videos/{vid}/admin")).json()
    assert [v["name"] for v in detail["former"]] == ["Saiu"]
    assert {v["name"] for v in detail["required"]} == {"Concluiu", "Atrasado"}
    late_row = next(v for v in detail["required"] if v["name"] == "Atrasado")
    assert late_row["status"] == "atrasado"


async def test_patch_new_rule_only_adds(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    d1 = await make_department(db, company, "D1")
    d2 = await make_department(db, company, "D2")
    u1 = await make_user(db, company, d1, name="Um")
    u2 = await make_user(db, company, d2, name="Dois")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(department_ids=[d1]))
    vid = video["id"]

    r = await c.patch(f"/videos/{vid}", json={"title": "Novo título", "due_days": 5, "rules": _rules(department_ids=[d2])})
    assert r.status_code == 200, r.text
    assert r.json()["title"] == "Novo título" and r.json()["due_days"] == 5
    assert (await _viewer(db, vid, u1))["required"] is True
    assert (await _viewer(db, vid, u2))["required"] is True
    assert await _video_notes(db, u1) == ["Novo vídeo para assistir"]
    assert await _video_notes(db, u2) == ["Novo vídeo para assistir"]
    detail = (await c.get(f"/videos/{vid}/admin")).json()
    assert detail["rules"] == {"all": False, "department_ids": [d2], "user_ids": []}

    r = await c.patch(f"/videos/{vid}", json={"due_days": None})
    assert r.status_code == 200 and r.json()["due_days"] is None and r.json()["title"] == "Novo título"


async def test_remove_department_viewer_sticks(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    dept = await make_department(db, company, "D")
    u = await make_user(db, company, dept, name="Sai")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(department_ids=[dept]))
    vid = video["id"]
    await db.execute(
        "UPDATE public.internal_video_viewers SET max_watched_s = 2 WHERE video_id = $1::uuid AND user_id = $2::uuid",
        vid, u)

    assert (await c.post(f"/videos/{vid}/viewers/{u}/remove")).status_code == 200
    r = await c.patch(f"/videos/{vid}", json={"rules": _rules(department_ids=[dept])})
    assert r.status_code == 200
    await db.execute(
        "UPDATE public.profiles SET department_id = NULL WHERE user_id = $1::uuid", u)
    await db.execute(
        "UPDATE public.profiles SET department_id = $1::uuid WHERE user_id = $2::uuid", dept, u)

    row = await _viewer(db, vid, u)
    assert row["excluded"] is True and row["required"] is False and float(row["max_watched_s"]) == 2
    detail = (await c.get(f"/videos/{vid}/admin")).json()
    assert detail["required"] == []


async def test_remove_viewer_deletes_user_rule(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    u = await make_user(db, company, name="Individual")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[u]))
    assert (await c.post(f"/videos/{video['id']}/viewers/{u}/remove")).status_code == 200
    detail = (await c.get(f"/videos/{video['id']}/admin")).json()
    assert detail["rules"]["user_ids"] == []
    stranger = await make_user(db, company, name="Nunca")
    assert (await c.post(f"/videos/{video['id']}/viewers/{stranger}/remove")).status_code == 404


async def test_readding_user_individually_clears_excluded(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    dept = await make_department(db, company, "D")
    u = await make_user(db, company, dept, name="Volta")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(department_ids=[dept]))
    vid = video["id"]
    await c.post(f"/videos/{vid}/viewers/{u}/remove")

    r = await c.patch(f"/videos/{vid}", json={"rules": _rules(department_ids=[dept], user_ids=[u])})
    assert r.status_code == 200
    row = await _viewer(db, vid, u)
    assert row["excluded"] is False and row["required"] is True
    assert await _video_notes(db, u) == ["Novo vídeo para assistir", "Novo vídeo para assistir"]


async def _progress_fixture(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    done = await make_user(db, company, name="Concluiu")
    watching = await make_user(db, company, name="Assistindo")
    idle = await make_user(db, company, name="Parado")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[done, watching, idle]), due_days=1)
    vid = video["id"]
    await db.execute(
        """UPDATE public.internal_video_viewers
           SET max_watched_s = 5, completed_at = now(), last_report_at = now(),
               assigned_at = now() - interval '3 days'
           WHERE video_id = $1::uuid AND user_id = $2::uuid""", vid, done)
    await db.execute(
        """UPDATE public.internal_video_viewers SET max_watched_s = 2, last_report_at = now()
           WHERE video_id = $1::uuid AND user_id = $2::uuid""", vid, watching)
    old_path = await db.fetchval("SELECT file_path FROM public.internal_videos WHERE id = $1::uuid", vid)
    return c, vid, done, watching, idle, old_path


async def test_replace_keep_completed(db, client_as, sample_mp4):
    c, vid, done, watching, idle, old_path = await _progress_fixture(db, client_as, sample_mp4)
    assigned_before = (await _viewer(db, vid, done))["assigned_at"]
    upload_id = await _upload(c, sample_mp4)

    r = await c.post(f"/videos/{vid}/replace-file", json={"upload_id": upload_id, "mode": "keep_completed"})
    assert r.status_code == 200, r.text
    assert r.json()["file_version"] == 2
    assert not os.path.exists(old_path)
    new_path = await db.fetchval("SELECT file_path FROM public.internal_videos WHERE id = $1::uuid", vid)
    assert new_path != old_path and os.path.exists(new_path)

    d = await _viewer(db, vid, done)
    assert d["completed_at"] is not None and d["assigned_at"] == assigned_before
    w = await _viewer(db, vid, watching)
    assert float(w["max_watched_s"]) == 0 and w["completed_at"] is None and w["last_report_at"] is None
    assert "Vídeo atualizado: assista novamente" in await _video_notes(db, watching)
    assert "Vídeo atualizado: assista novamente" not in await _video_notes(db, done)
    assert "Vídeo atualizado: assista novamente" not in await _video_notes(db, idle)


async def test_replace_reset_all(db, client_as, sample_mp4):
    c, vid, done, watching, idle, _ = await _progress_fixture(db, client_as, sample_mp4)
    assigned_before = (await _viewer(db, vid, done))["assigned_at"]
    upload_id = await _upload(c, sample_mp4)

    r = await c.post(f"/videos/{vid}/replace-file", json={"upload_id": upload_id, "mode": "reset_all"})
    assert r.status_code == 200
    for u in (done, watching):
        row = await _viewer(db, vid, u)
        assert row["completed_at"] is None and float(row["max_watched_s"]) == 0
        assert "Vídeo atualizado: assista novamente" in await _video_notes(db, u)
    assert (await _viewer(db, vid, done))["assigned_at"] == assigned_before
    detail = (await c.get(f"/videos/{vid}/admin")).json()
    assert next(v for v in detail["required"] if v["user_id"] == done)["status"] == "atrasado"
    assert (await c.post(f"/videos/{vid}/replace-file", json={"upload_id": upload_id, "mode": "reset_all"})).status_code == 409


async def test_replace_rejects_bad_mode(db, client_as, sample_mp4):
    c, vid, *_ = await _progress_fixture(db, client_as, sample_mp4)
    upload_id = await _upload(c, sample_mp4)
    r = await c.post(f"/videos/{vid}/replace-file", json={"upload_id": upload_id, "mode": "outro"})
    assert r.status_code == 422


async def test_unarchive_backfills_new_hires(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    dept = await make_department(db, company, "D")
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(department_ids=[dept]))
    vid = video["id"]

    r = await c.post(f"/videos/{vid}/archive")
    assert r.status_code == 200 and r.json()["archived_at"] is not None
    newbie = await make_user(db, company, dept, name="Novato")
    assert await _viewer(db, vid, newbie) is None

    r = await c.post(f"/videos/{vid}/unarchive")
    assert r.status_code == 200 and r.json()["archived_at"] is None
    assert (await _viewer(db, vid, newbie))["required"] is True
    assert await _video_notes(db, newbie) == ["Novo vídeo para assistir"]


async def test_other_company_video_404(db, client_as, sample_mp4):
    _, manager_a = await _setup(db)
    company_b, manager_b = await _setup(db)
    user_b = await make_user(db, company_b)
    # client_as troca o usuário global a cada chamada: tudo de A antes de criar B
    a = client_as(manager_a)
    vid = (await _create(a, sample_mp4, _rules()))["id"]
    upload_a = await _upload(a, sample_mp4)
    b = client_as(manager_b)
    upload_b = await _upload(b, sample_mp4)
    assert (await b.get(f"/videos/{vid}/admin")).status_code == 404
    assert (await b.patch(f"/videos/{vid}", json={"title": "x"})).status_code == 404
    assert (await b.post(f"/videos/{vid}/viewers/{user_b}/remove")).status_code == 404
    assert (await b.post(f"/videos/{vid}/replace-file", json={"upload_id": upload_b, "mode": "reset_all"})).status_code == 404
    assert (await b.post(f"/videos/{vid}/archive")).status_code == 404
    assert (await b.post(f"/videos/{vid}/unarchive")).status_code == 404
    assert (await b.delete(f"/videos/{vid}")).status_code == 404
    assert (await b.get("/videos/admin")).json() == []
    r = await b.post("/videos", json={"upload_id": upload_a, "title": "T", "rules": _rules()})
    assert r.status_code == 404


async def test_delete_removes_file(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    u = await make_user(db, company)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[u]))
    vid = video["id"]
    path = await db.fetchval("SELECT file_path FROM public.internal_videos WHERE id = $1::uuid", vid)
    assert os.path.exists(path)

    assert (await c.delete(f"/videos/{vid}")).status_code == 204
    assert not os.path.exists(path)
    assert await db.fetchval("SELECT count(*) FROM public.internal_videos") == 0
    assert await db.fetchval("SELECT count(*) FROM public.internal_video_viewers") == 0
    assert await db.fetchval("SELECT count(*) FROM public.internal_video_rules") == 0
    assert (await c.get(f"/videos/{vid}/admin")).status_code == 404


async def test_stale_completed_unconsumed_upload_is_cleaned(db, client_as, sample_mp4):
    company, manager = await _setup(db)
    c = client_as(manager)
    stale = await _upload(c, sample_mp4)
    kept = await _upload(c, sample_mp4)
    await _create(c, sample_mp4, _rules())  # consome um terceiro upload
    await db.execute(
        "UPDATE public.internal_video_uploads SET created_at = now() - interval '25 hours', completed_at = now() - interval '25 hours' WHERE id = $1::uuid",
        stale)
    stale_path = await db.fetchval("SELECT file_path FROM public.internal_video_uploads WHERE id = $1::uuid", stale)
    await db.execute(
        "UPDATE public.internal_video_uploads SET created_at = now() - interval '25 hours', completed_at = now() - interval '1 hour' WHERE id = $1::uuid",
        kept)
    await db.execute(
        "UPDATE public.internal_video_uploads SET created_at = now() - interval '30 hours', completed_at = now() - interval '30 hours' WHERE consumed_at IS NOT NULL")
    consumed_path = await db.fetchval("SELECT file_path FROM public.internal_video_uploads WHERE consumed_at IS NOT NULL")

    assert (await c.post("/videos/uploads", json={"total_size": 10})).status_code == 201
    assert not os.path.exists(stale_path)
    assert await db.fetchval("SELECT count(*) FROM public.internal_video_uploads WHERE id = $1::uuid", stale) == 0
    assert await db.fetchval("SELECT count(*) FROM public.internal_video_uploads WHERE id = $1::uuid", kept) == 1
    assert os.path.exists(consumed_path)
