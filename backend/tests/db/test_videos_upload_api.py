import os

import pytest

from app import video_storage
from app.video_logic import MAX_FILE_SIZE
from tests.db.conftest import make_company, make_user

SMALL = 2048


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def _manager(db):
    company = await make_company(db)
    return company, await make_user(db, company, role="manager")


def _split(data: bytes) -> list[bytes]:
    return [data[i:i + SMALL] for i in range(0, len(data), SMALL)]


async def test_upload_requires_manager(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, role="user")
    r = await client_as(user).post("/videos/uploads", json={"total_size": 100})
    assert r.status_code == 403


async def test_upload_rejects_over_2gb(db, client_as):
    _, manager = await _manager(db)
    r = await client_as(manager).post("/videos/uploads", json={"total_size": MAX_FILE_SIZE + 1})
    assert r.status_code == 400


async def test_full_upload_flow(db, client_as, sample_mp4):
    _, manager = await _manager(db)
    c = client_as(manager)
    r = await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})
    assert r.status_code == 201
    info = r.json()
    parts = _split(sample_mp4)
    assert info["part_size"] == SMALL and info["parts"] == len(parts) > 1
    # fora de ordem e com a parte 0 repetida
    for n in [2, 0, 0, 1] + list(range(3, len(parts))):
        r = await c.put(f"/videos/uploads/{info['upload_id']}/parts/{n}", content=parts[n])
        assert r.status_code == 204
    r = await c.post(f"/videos/uploads/{info['upload_id']}/complete")
    assert r.status_code == 200
    body = r.json()
    assert body["duration_seconds"] > 0 and body["file_size"] == len(sample_mp4)
    row = await db.fetchrow(
        "SELECT file_path, completed_at FROM public.internal_video_uploads WHERE id = $1::uuid", info["upload_id"]
    )
    assert row["completed_at"] and open(row["file_path"], "rb").read() == sample_mp4


async def test_complete_rejects_missing_part_even_if_size_matches(db, client_as, sample_mp4):
    _, manager = await _manager(db)
    c = client_as(manager)
    info = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    parts = _split(sample_mp4)
    last = len(parts) - 1
    await c.put(f"/videos/uploads/{info['upload_id']}/parts/{last}", content=parts[last])
    r = await c.post(f"/videos/uploads/{info['upload_id']}/complete")
    assert r.status_code == 400


async def test_part_with_wrong_size_is_rejected(db, client_as, sample_mp4):
    _, manager = await _manager(db)
    c = client_as(manager)
    info = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    r = await c.put(f"/videos/uploads/{info['upload_id']}/parts/0", content=b"x")
    assert r.status_code == 400


async def test_cancel_deletes_tmp(db, client_as, sample_mp4):
    company, manager = await _manager(db)
    c = client_as(manager)
    info = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    await c.put(f"/videos/uploads/{info['upload_id']}/parts/0", content=_split(sample_mp4)[0])
    tmp = video_storage.tmp_path(company, info["upload_id"])
    assert os.path.exists(tmp)
    r = await c.delete(f"/videos/uploads/{info['upload_id']}")
    assert r.status_code == 204
    assert not os.path.exists(tmp)
    assert await db.fetchval(
        "SELECT count(*) FROM public.internal_video_uploads WHERE id = $1::uuid", info["upload_id"]
    ) == 0


async def test_stale_uploads_are_cleaned_on_start(db, client_as):
    company, manager = await _manager(db)
    stale = str(await db.fetchval(
        """INSERT INTO public.internal_video_uploads (company_id, total_size, created_at)
           VALUES ($1::uuid, 10, now() - interval '25 hours') RETURNING id""", company))
    tmp = video_storage.tmp_path(company, stale)
    os.makedirs(os.path.dirname(tmp))
    open(tmp, "wb").close()
    r = await client_as(manager).post("/videos/uploads", json={"total_size": 10})
    assert r.status_code == 201
    assert not os.path.exists(tmp)
    assert await db.fetchval("SELECT count(*) FROM public.internal_video_uploads WHERE id=$1::uuid", stale) == 0


async def test_part_rejected_when_body_exceeds_part_size(db, client_as, sample_mp4):
    _, manager = await _manager(db)
    c = client_as(manager)
    info = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    r = await c.put(f"/videos/uploads/{info['upload_id']}/parts/0", content=b"x" * (SMALL + 1))
    assert r.status_code == 413


async def test_non_canonical_upload_id_cannot_create_holes(db, client_as, sample_mp4):
    company, manager = await _manager(db)
    c = client_as(manager)
    info = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    parts = _split(sample_mp4)
    upper = info["upload_id"].upper()
    for n in range(len(parts)):
        r = await c.put(f"/videos/uploads/{upper}/parts/{n}", content=parts[n])
        assert r.status_code == 204
    tmp = video_storage.tmp_path(company, info["upload_id"])
    assert open(tmp, "rb").read() == sample_mp4
    assert len(os.listdir(os.path.dirname(tmp))) == 1
    # sem partes registradas, complete segue impossível
    other = (await c.post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    r = await c.post(f"/videos/uploads/{other['upload_id'].upper()}/complete")
    assert r.status_code == 400


async def test_invalid_upload_id_is_422(db, client_as):
    _, manager = await _manager(db)
    r = await client_as(manager).delete("/videos/uploads/nao-e-uuid")
    assert r.status_code == 422


async def test_other_company_gets_404(db, client_as, sample_mp4):
    _, manager_a = await _manager(db)
    _, manager_b = await _manager(db)
    info = (await client_as(manager_a).post("/videos/uploads", json={"total_size": len(sample_mp4)})).json()
    uid = info["upload_id"]
    b = client_as(manager_b)
    assert (await b.put(f"/videos/uploads/{uid}/parts/0", content=_split(sample_mp4)[0])).status_code == 404
    assert (await b.post(f"/videos/uploads/{uid}/complete")).status_code == 404
    assert (await b.delete(f"/videos/uploads/{uid}")).status_code == 404
