from datetime import date, timedelta

import pytest

from app.evaluation_rules import BEHAVIOR_KEYS
from tests.db.conftest import make_company, make_user

TODAY = date.today()


def _scores(value):
    return [{"behavior_key": k, "score": value} for k in sorted(BEHAVIOR_KEYS)]


async def _setup(db):
    company = await make_company(db)
    rh = await make_user(db, company, name="RH", role="manager")
    boss = await make_user(db, company, name="Gestora")
    ana = await make_user(db, company, name="Ana")
    await db.execute("UPDATE public.profiles SET manager_user_id = $1 WHERE user_id = $2", boss, ana)
    return company, rh, boss, ana


async def _cycle(client, **kw):
    body = {"name": "Ciclo", "eval_start": str(TODAY - timedelta(days=1)),
            "eval_end": str(TODAY + timedelta(days=5))}
    body.update(kw)
    r = await client.post("/evaluations/cycles", json=body)
    assert r.status_code == 201, r.text
    return r.json()


async def _profile_id(db, user_id):
    return str(await db.fetchval("SELECT id FROM public.profiles WHERE user_id = $1", user_id))


# ── Datas ─────────────────────────────────────────────────────────────────────

async def test_cycle_with_dates_opens_self_evaluation_automatically(db, client_as):
    _, rh, _, ana = await _setup(db)
    cycle = await _cycle(client_as(rh))
    assert cycle["status"] == "evaluation" and cycle["manual_status"] == "draft"

    r = await client_as(ana).get("/evaluations/cycles")
    assert r.json()[0]["status"] == "evaluation"

    r = await client_as(ana).post("/evaluations/submit", json={
        "eval_cycle_id": cycle["id"], "evaluated_user_id": ana, "eval_type": "self", "scores": _scores(4)})
    assert r.status_code == 200, r.text


async def test_future_cycle_is_draft_and_blocks_self_evaluation(db, client_as):
    _, rh, _, ana = await _setup(db)
    cycle = await _cycle(client_as(rh), eval_start=str(TODAY + timedelta(days=3)),
                         eval_end=str(TODAY + timedelta(days=9)))
    assert cycle["status"] == "draft"
    r = await client_as(ana).post("/evaluations/submit", json={
        "eval_cycle_id": cycle["id"], "evaluated_user_id": ana, "eval_type": "self", "scores": _scores(4)})
    assert r.status_code == 409


async def test_invalid_dates_are_rejected(db, client_as):
    _, rh, _, _ = await _setup(db)
    r = await client_as(rh).post("/evaluations/cycles", json={
        "name": "X", "eval_start": str(TODAY), "eval_end": str(TODAY - timedelta(days=1))})
    assert r.status_code == 422
    r = await client_as(rh).post("/evaluations/cycles", json={"name": "X"})
    assert r.status_code == 422  # seguir as datas sem período de avaliação


async def test_manual_stage_and_clearing_dates(db, client_as):
    _, rh, _, _ = await _setup(db)
    cycle = await _cycle(client_as(rh))
    r = await client_as(rh).put(f"/evaluations/cycles/{cycle['id']}",
                                json={"stage_by_dates": False, "status": "feedback"})
    assert r.json()["status"] == "feedback"
    r = await client_as(rh).put(f"/evaluations/cycles/{cycle['id']}",
                                json={"eval_start": None, "eval_end": None})
    assert r.status_code == 200 and r.json()["eval_start"] is None
    r = await client_as(rh).put(f"/evaluations/cycles/{cycle['id']}", json={"stage_by_dates": True})
    assert r.status_code == 422


# ── Gestor responsável ────────────────────────────────────────────────────────

async def test_only_assigned_manager_gives_manager_score(db, client_as):
    _, rh, boss, ana = await _setup(db)
    cycle = await _cycle(client_as(rh))
    body = {"eval_cycle_id": cycle["id"], "evaluated_user_id": ana, "eval_type": "manager", "scores": _scores(4)}

    assert (await client_as(rh).post("/evaluations/submit", json=body)).status_code == 403
    assert (await client_as(boss).post("/evaluations/submit", json=body)).status_code == 200

    team = (await client_as(boss).get(f"/evaluations/my-team?cycle_id={cycle['id']}")).json()
    assert [t["user_id"] for t in team] == [ana]
    assert team[0]["manager_submitted"] and len(team[0]["scores"]) == len(BEHAVIOR_KEYS)
    assert (await client_as(ana).get(f"/evaluations/my-team?cycle_id={cycle['id']}")).json() == []


async def test_incomplete_evaluation_is_rejected(db, client_as):
    _, rh, boss, ana = await _setup(db)
    cycle = await _cycle(client_as(rh))
    r = await client_as(boss).post("/evaluations/submit", json={
        "eval_cycle_id": cycle["id"], "evaluated_user_id": ana, "eval_type": "manager",
        "scores": _scores(4)[:-1]})
    assert r.status_code == 422


async def test_set_manager_endpoint(db, client_as):
    company, rh, boss, ana = await _setup(db)
    pid = await _profile_id(db, ana)
    r = await client_as(rh).put(f"/collaborators/{pid}/manager", json={"manager_user_id": None})
    assert r.status_code == 200
    assert await db.fetchval("SELECT manager_user_id FROM public.profiles WHERE id = $1::uuid", pid) is None

    r = await client_as(rh).put(f"/collaborators/{pid}/manager", json={"manager_user_id": ana})
    assert r.status_code == 400
    r = await client_as(boss).put(f"/collaborators/{pid}/manager", json={"manager_user_id": boss})
    assert r.status_code == 403

    other = await make_user(db, await make_company(db), name="De fora")
    r = await client_as(rh).put(f"/collaborators/{pid}/manager", json={"manager_user_id": other})
    assert r.status_code == 404

    r = await client_as(rh).put(f"/collaborators/{pid}/manager", json={"manager_user_id": boss})
    assert r.status_code == 200
    status = (await client_as(rh).get(f"/evaluations/team-status?cycle_id={(await _cycle(client_as(rh)))['id']}")).json()
    assert next(s for s in status if s["user_id"] == ana)["manager_name"] == "Gestora"


# ── Cálculo ───────────────────────────────────────────────────────────────────

async def test_consolidate_weighted_90_10_and_keeps_calibration(db, client_as):
    _, rh, boss, ana = await _setup(db)
    cycle = await _cycle(client_as(rh))
    cid = cycle["id"]
    await client_as(ana).post("/evaluations/submit", json={
        "eval_cycle_id": cid, "evaluated_user_id": ana, "eval_type": "self", "scores": _scores(5)})

    r = await client_as(rh).post(f"/evaluations/cycles/{cid}/consolidate")
    assert r.json()["updated"] == 0  # só autoavaliação não gera nota

    await client_as(boss).post("/evaluations/submit", json={
        "eval_cycle_id": cid, "evaluated_user_id": ana, "eval_type": "manager", "scores": _scores(4)})
    r = await client_as(rh).post(f"/evaluations/cycles/{cid}/consolidate")
    assert r.json()["updated"] == 1

    row = next(s for s in (await client_as(rh).get(f"/evaluations/team-status?cycle_id={cid}")).json()
               if s["user_id"] == ana)
    assert row["score_final"] == pytest.approx(4.1)
    assert row["score_manager"] == 4 and row["score_self"] == 5

    await db.execute(
        """UPDATE public.consolidated_scores SET nine_box_x = 3, nine_box_y = 3,
           nine_box_quadrant = 'Super Talento', calibrated = true WHERE user_id = $1""", ana)
    await client_as(rh).post(f"/evaluations/cycles/{cid}/consolidate")
    assert await db.fetchval(
        "SELECT nine_box_quadrant FROM public.consolidated_scores WHERE user_id = $1", ana) == "Super Talento"
