from datetime import datetime, timedelta, timezone

import jwt
import pytest

from app import video_storage
from app.auth.service import create_access_token
from app.config import settings
from tests.db.conftest import make_company, make_user
from tests.db.test_videos_admin_api import _create, _rules, _upload, _viewer
from tests.db.test_videos_upload_api import SMALL


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def _setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    user = await make_user(db, company, name="Ana")
    return company, manager, user


async def _set_duration(db, video_id, seconds):
    await db.execute(
        "UPDATE public.internal_videos SET duration_seconds = $2 WHERE id = $1::uuid", video_id, seconds
    )


async def _age_last_report(db, video_id, user_id, seconds):
    await db.execute(
        """UPDATE public.internal_video_viewers SET last_report_at = last_report_at - make_interval(secs => $3)
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        video_id, user_id, seconds,
    )


async def _stream_url(c, video_id) -> str:
    r = await c.post(f"/videos/{video_id}/stream-token")
    assert r.status_code == 200, r.text
    return r.json()["url"]


async def test_mine_splits_required_and_library(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    m = client_as(manager)
    late = await _create(m, sample_mp4, _rules(user_ids=[user]), due_days=3)
    pending = await _create(m, sample_mp4, _rules(user_ids=[user]), due_days=30)
    done = await _create(m, sample_mp4, _rules(user_ids=[user]))
    removed = await _create(m, sample_mp4, _rules(user_ids=[user]))
    free = await _create(m, sample_mp4, _rules())
    await db.execute(
        """UPDATE public.internal_video_viewers SET assigned_at = now() - interval '10 days'
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        late["id"], user)
    await db.execute(
        """UPDATE public.internal_video_viewers SET completed_at = now(), max_watched_s = 5
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        done["id"], user)
    assert (await m.post(f"/videos/{removed['id']}/viewers/{user}/remove")).status_code == 200

    r = await client_as(user).get("/videos/mine")
    assert r.status_code == 200, r.text
    body = r.json()
    assert [v["id"] for v in body["required"]] == [late["id"], pending["id"], done["id"]]
    assert [v["status"] for v in body["required"]] == ["atrasado", "pendente", "concluido"]
    assert body["required"][2]["progress_pct"] == 100 and body["required"][2]["completed_at"]
    assert body["required"][0]["due_at"] is not None
    assert {v["id"] for v in body["library"]} == {removed["id"], free["id"]}
    assert all(v["due_at"] is None for v in body["library"])
    first = body["required"][0]
    assert set(first) == {
        "id", "title", "description", "duration_seconds", "status", "progress_pct", "due_at", "completed_at",
    }


async def test_archived_hidden_from_mine(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    m = client_as(manager)
    video = await _create(m, sample_mp4, _rules(user_ids=[user]))
    assert (await m.post(f"/videos/{video['id']}/archive")).status_code == 200

    c = client_as(user)
    body = (await c.get("/videos/mine")).json()
    assert body == {"required": [], "library": []}
    assert (await c.get(f"/videos/{video['id']}")).status_code == 404


async def test_video_detail_includes_max_watched(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]), due_days=7)
    await db.execute(
        "UPDATE public.internal_video_viewers SET max_watched_s = 2.5 WHERE video_id = $1::uuid", video["id"]
    )
    r = await client_as(user).get(f"/videos/{video['id']}")
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["max_watched_s"] == 2.5 and body["status"] == "em_andamento" and body["due_at"]

    other_company = await make_company(db)
    outsider = await make_user(db, other_company)
    assert (await client_as(outsider).get(f"/videos/{video['id']}")).status_code == 404


async def test_stream_supports_range(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules())
    c = client_as(user)
    url = await _stream_url(c, video["id"])
    assert url.startswith("/videos/stream/")

    full = await c.get(url)
    assert full.status_code == 200
    assert full.content == sample_mp4
    assert full.headers["content-type"] == "video/mp4"
    assert full.headers["cache-control"] == "no-store"

    part = await c.get(url, headers={"Range": "bytes=0-99"})
    assert part.status_code == 206
    assert part.headers["content-range"] == f"bytes 0-99/{len(sample_mp4)}"
    assert part.content == sample_mp4[:100]

    claims = jwt.decode(url.rsplit("/", 1)[1], settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
    assert "sub" not in claims and claims["typ"] == "video_stream"


async def test_stream_token_rejections(db, client_as, sample_mp4):
    from app.dependencies import get_current_user_id
    from app.main import app

    company, manager, user = await _setup(db)
    # client_as troca o usuário de todos os clientes: refazer o cliente a cada troca de papel.
    as_manager = lambda: client_as(manager)  # noqa: E731
    as_user = lambda: client_as(user)  # noqa: E731

    archived = await _create(as_manager(), sample_mp4, _rules())
    old_url = await _stream_url(as_user(), archived["id"])
    assert (await as_manager().post(f"/videos/{archived['id']}/archive")).status_code == 200
    c = as_user()
    assert (await c.post(f"/videos/{archived['id']}/stream-token")).status_code == 404
    assert (await c.get(old_url)).status_code == 404

    replaced = await _create(as_manager(), sample_mp4, _rules())
    stale_url = await _stream_url(as_user(), replaced["id"])
    m = as_manager()
    upload_id = await _upload(m, sample_mp4)
    r = await m.post(f"/videos/{replaced['id']}/replace-file", json={"upload_id": upload_id, "mode": "reset_all"})
    assert r.status_code == 200, r.text
    c = as_user()
    assert (await c.get(stale_url)).status_code == 404
    assert (await c.get(await _stream_url(c, replaced["id"]))).status_code == 200

    left_url = await _stream_url(c, replaced["id"])
    await db.execute("UPDATE public.profiles SET company_id = NULL WHERE user_id = $1::uuid", user)
    assert (await c.get(left_url)).status_code == 404
    await db.execute("UPDATE public.profiles SET company_id = $1::uuid WHERE user_id = $2::uuid", company, user)

    expired = jwt.encode(
        {"typ": "video_stream", "vid": replaced["id"], "uid": user, "ver": 2,
         "exp": datetime.now(timezone.utc) - timedelta(seconds=1)},
        settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM,
    )
    assert (await c.get(f"/videos/stream/{expired}")).status_code == 404
    assert (await c.get("/videos/stream/lixo")).status_code == 404
    assert (await c.get(f"/videos/stream/{create_access_token(user)}")).status_code == 404

    stream_token = (await _stream_url(c, replaced["id"])).rsplit("/", 1)[1]
    app.dependency_overrides.pop(get_current_user_id)
    r = await c.get("/auth/me", headers={"Authorization": f"Bearer {stream_token}"})
    assert r.status_code == 401


async def test_progress_skip_returns_409_with_server_max(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]))
    await _set_duration(db, video["id"], 600)
    c = client_as(user)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 10})
    assert r.status_code == 200, r.text
    assert r.json() == {"max_watched_s": 10.0, "completed": False}
    await _age_last_report(db, video["id"], user, 20)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 200})
    assert r.status_code == 409
    assert r.json()["max_watched_s"] == 10.0 and r.json()["detail"]
    assert float((await _viewer(db, video["id"], user))["max_watched_s"]) == 10.0


async def test_progress_under_5s_is_noop_and_keeps_last_report_at(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]))
    await _set_duration(db, video["id"], 600)
    c = client_as(user)

    assert (await c.post(f"/videos/{video['id']}/progress", json={"position_s": 10})).status_code == 200
    before = await _viewer(db, video["id"], user)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 12})
    assert r.status_code == 200, r.text
    assert r.json() == {"max_watched_s": 10.0, "completed": False}
    after = await _viewer(db, video["id"], user)
    assert float(after["max_watched_s"]) == 10.0
    assert after["last_report_at"] == before["last_report_at"]


async def test_progress_end_of_video_3s_after_tick_completes(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]))
    await _set_duration(db, video["id"], 600)
    await db.execute(
        """UPDATE public.internal_video_viewers
           SET max_watched_s = 590, last_report_at = now() - interval '20 seconds'
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        video["id"], user)
    c = client_as(user)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 597})
    assert r.json() == {"max_watched_s": 597.0, "completed": False}
    await _age_last_report(db, video["id"], user, 3)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 600})
    assert r.status_code == 200, r.text
    assert r.json() == {"max_watched_s": 600.0, "completed": True}
    row = await _viewer(db, video["id"], user)
    assert row["completed_at"] is not None and float(row["max_watched_s"]) == 600.0


async def test_progress_rejects_nan_and_inf(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]))
    c = client_as(user)
    for raw in ('{"position_s": NaN}', '{"position_s": Infinity}', '{"position_s": -1}'):
        r = await c.post(
            f"/videos/{video['id']}/progress", content=raw, headers={"Content-Type": "application/json"}
        )
        assert r.status_code == 422, raw


async def test_progress_completes_and_sets_completed_at(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[user]))
    await _set_duration(db, video["id"], 600)
    await db.execute(
        """UPDATE public.internal_video_viewers
           SET max_watched_s = 590, last_report_at = now() - interval '20 seconds'
           WHERE video_id = $1::uuid AND user_id = $2::uuid""",
        video["id"], user)
    c = client_as(user)

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 598.5})
    assert r.status_code == 200, r.text
    assert r.json() == {"max_watched_s": 598.5, "completed": True}
    row = await _viewer(db, video["id"], user)
    assert row["completed_at"] is not None and float(row["max_watched_s"]) == 598.5

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 0})
    assert r.status_code == 200
    assert r.json() == {"max_watched_s": 598.5, "completed": True}
    after = await _viewer(db, video["id"], user)
    assert after["completed_at"] == row["completed_at"] and after["last_report_at"] == row["last_report_at"]
    assert (await c.get(f"/videos/{video['id']}")).json()["status"] == "concluido"


async def test_progress_voluntary_creates_non_required_row(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules())
    c = client_as(user)
    assert await _viewer(db, video["id"], user) is None

    r = await c.post(f"/videos/{video['id']}/progress", json={"position_s": 1.5})
    assert r.status_code == 200, r.text
    row = await _viewer(db, video["id"], user)
    assert row["required"] is False and float(row["max_watched_s"]) == 1.5
    assert row["last_report_at"] is not None
    body = (await c.get("/videos/mine")).json()
    assert body["required"] == [] and body["library"][0]["status"] == "em_andamento"


async def test_progress_rejected_on_archived_video(db, client_as, sample_mp4):
    company, manager, user = await _setup(db)
    m = client_as(manager)
    video = await _create(m, sample_mp4, _rules())
    assert (await m.post(f"/videos/{video['id']}/archive")).status_code == 200
    r = await client_as(user).post(f"/videos/{video['id']}/progress", json={"position_s": 1})
    assert r.status_code == 404
    assert await _viewer(db, video["id"], user) is None
