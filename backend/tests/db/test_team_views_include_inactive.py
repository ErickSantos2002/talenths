import pytest

from app import video_storage
from tests.db.conftest import make_company, make_user
from tests.db.test_videos_admin_api import _create, _rules
from tests.db.test_videos_upload_api import SMALL


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    active = await make_user(db, company, name="Ativa")
    gone = await make_user(db, company, name="Saiu")
    return company, manager, active, gone


async def deactivate(db, user_id):
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", user_id)


async def check(c, url, names_of, expected_default, expected_all, gone_name="Saiu"):
    """Sem o parâmetro o desligado some; com include_inactive=true ele volta marcado."""
    sep = "&" if "?" in url else "?"
    r = await c.get(url)
    assert r.status_code == 200, r.text
    assert sorted(n for n, _ in names_of(r.json())) == expected_default
    r = await c.get(f"{url}{sep}include_inactive=true")
    assert r.status_code == 200, r.text
    items = names_of(r.json())
    assert sorted(n for n, _ in items) == expected_all
    flags = {n: d for n, d in items}
    assert flags[gone_name] is not None
    assert all(flags[n] is None for n in flags if n != gone_name)


def by(name_key):
    return lambda items: [(i[name_key], i["deactivated_at"]) for i in items]


async def test_pdi_team(db, client_as):
    company, manager, active, gone = await setup(db)
    for uid in (active, gone):
        await db.execute("INSERT INTO public.pdi_plans (company_id, user_id, title) VALUES ($1, $2, 'PDI')", company, uid)
    await deactivate(db, gone)

    await check(client_as(manager), "/pdi/team", by("user_name"), ["Ativa"], ["Ativa", "Saiu"])


async def test_onboarding_team(db, client_as):
    company, manager, active, gone = await setup(db)
    for uid in (active, gone):
        await db.execute("INSERT INTO public.onboarding_checklists (company_id, user_id) VALUES ($1, $2)", company, uid)
    await deactivate(db, gone)

    await check(client_as(manager), "/onboarding/team", by("user_name"), ["Ativa"], ["Ativa", "Saiu"])


async def test_learning_team(db, client_as):
    company, manager, active, gone = await setup(db)
    for uid in (active, gone):
        await db.execute(
            """INSERT INTO public.employee_courses (company_id, user_id, course_title, area, completed_at)
               VALUES ($1, $2, 'Excel', 'TI', CURRENT_DATE)""",
            company, uid,
        )
    await deactivate(db, gone)

    await check(client_as(manager), "/learning/team", by("user_name"), ["Ativa"], ["Ativa", "Saiu"])


async def test_timeclock_team_day(db, client_as):
    company, manager, active, gone = await setup(db)
    await db.execute(
        "UPDATE public.profiles SET timeclock_enabled = true WHERE user_id = ANY($1::uuid[])", [active, gone]
    )
    await deactivate(db, gone)

    await check(
        client_as(manager), "/timeclock/team",
        lambda body: [(p["user_name"], p["deactivated_at"]) for p in body["people"]],
        ["Ativa"], ["Ativa", "Saiu"],
    )


async def test_evaluations_team_status_and_9box(db, client_as):
    company, manager, active, gone = await setup(db)
    cycle = await db.fetchval(
        "INSERT INTO public.evaluation_cycles (company_id, name) VALUES ($1, 'Ciclo') RETURNING id", company
    )
    for uid in (active, gone):
        await db.execute(
            """INSERT INTO public.consolidated_scores
                 (eval_cycle_id, user_id, company_id, score_final, nine_box_x, nine_box_y, nine_box_quadrant)
               VALUES ($1, $2, $3, 3.5, 2, 2, 'core')""",
            cycle, uid, company,
        )
    await deactivate(db, gone)
    c = client_as(manager)

    await check(c, f"/evaluations/team-status?cycle_id={cycle}", by("name"),
                ["Ativa", "Gestora"], ["Ativa", "Gestora", "Saiu"])
    await check(c, f"/evaluations/9box?cycle_id={cycle}",
                lambda body: [(p["name"], p["deactivated_at"]) for cell in body["grid"].values() for p in cell],
                ["Ativa"], ["Ativa", "Saiu"])
    assert (await c.get(f"/evaluations/9box?cycle_id={cycle}")).json()["total"] == 1


async def test_career_team(db, client_as):
    company, manager, active, gone = await setup(db)
    await deactivate(db, gone)

    await check(client_as(manager), "/career/team", by("name"), ["Ativa", "Gestora"], ["Ativa", "Gestora", "Saiu"])


async def test_video_admin_detail(db, client_as, sample_mp4):
    company, manager, active, gone = await setup(db)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[active, gone]))
    await deactivate(db, gone)

    await check(
        client_as(manager), f"/videos/{video['id']}/admin",
        lambda body: [(p["name"], p["deactivated_at"]) for p in body["required"]],
        ["Ativa"], ["Ativa", "Saiu"],
    )


async def test_custom_test_attempts_and_assignments(db, client_as):
    from tests.db.test_custom_tests_take_api import CUSTOM_TESTS_DDL, _make_test

    await db.execute("DROP TABLE public.test_responses")
    await db.execute(CUSTOM_TESTS_DDL.read_text())
    company, manager, active, gone = await setup(db)
    test_id = await _make_test(db, company, manager)
    for uid in (active, gone):
        await db.execute("INSERT INTO public.test_assignments (test_id, user_id) VALUES ($1, $2)", test_id, uid)
        await db.execute("INSERT INTO public.test_attempts (test_id, user_id) VALUES ($1, $2)", test_id, uid)
    await deactivate(db, gone)
    c = client_as(manager)

    await check(c, f"/tests/{test_id}/attempts", by("collaborator_name"), ["Ativa"], ["Ativa", "Saiu"])
    await check(c, f"/tests/{test_id}/assignments", by("user_name"), ["Ativa"], ["Ativa", "Saiu"])
