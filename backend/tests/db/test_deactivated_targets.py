from datetime import date

import pytest

from app import video_storage
from tests.db.conftest import make_company, make_department, make_user
from tests.db.test_videos_admin_api import _create, _rules, _upload
from tests.db.test_videos_upload_api import SMALL

GONE = (422, "Colaborador desligado")


@pytest.fixture(autouse=True)
def small_parts(monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)


async def setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    active = await make_user(db, company, name="Ativa")
    gone = await make_user(db, company, name="Saiu")
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", gone)
    return company, manager, active, gone


def status(r):
    return r.status_code, r.json().get("detail")


async def count(db, table, user_id) -> int:
    return await db.fetchval(f"SELECT count(*) FROM public.{table} WHERE user_id = $1", user_id)


async def test_pdi_plan(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).post("/pdi/plans", json={"user_id": gone, "title": "PDI"})

    assert status(r) == GONE
    assert await count(db, "pdi_plans", gone) == 0


async def test_onboarding_assign(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).post("/onboarding/assign", json={"user_id": gone})

    assert status(r) == GONE
    assert await count(db, "onboarding_checklists", gone) == 0


async def test_learning_employee_course(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).post(
        f"/learning/employee/{gone}", json={"course_title": "Excel", "area": "TI"}
    )

    assert status(r) == GONE
    assert await count(db, "employee_courses", gone) == 0


async def test_learning_import_csv_skips_deactivated_row(db, client_as):
    company, manager, active, gone = await setup(db)
    emails = dict(await db.fetch(
        "SELECT user_id::text, email FROM public.profiles WHERE user_id = ANY($1::uuid[])", [active, gone]
    ))
    csv_text = "email,titulo,area,horas,data\n" + "".join(
        f"{emails[u]},Excel,TI,2,{date.today().isoformat()}\n" for u in (active, gone)
    )

    r = await client_as(manager).post(
        "/learning/import-csv", files={"file": ("cursos.csv", csv_text.encode(), "text/csv")}
    )

    assert r.status_code == 200, r.text
    assert r.json()["inserted"] == 1
    assert r.json()["errors"] == [f"Linha 3: colaborador '{emails[gone]}' desligado"]
    assert await count(db, "employee_courses", active) == 1
    assert await count(db, "employee_courses", gone) == 0


async def test_custom_test_assignment(db, client_as):
    from tests.db.test_custom_tests_take_api import CUSTOM_TESTS_DDL, _make_test

    await db.execute("DROP TABLE public.test_responses")
    await db.execute(CUSTOM_TESTS_DDL.read_text())
    company, manager, active, gone = await setup(db)
    test_id = await _make_test(db, company, manager)

    r = await client_as(manager).post(f"/tests/{test_id}/assignments", json={"user_id": gone})

    assert status(r) == GONE
    assert await count(db, "test_assignments", gone) == 0


async def test_video_new_target(db, client_as, sample_mp4):
    company, manager, active, gone = await setup(db)
    c = client_as(manager)
    upload_id = await _upload(c, sample_mp4)

    r = await c.post("/videos", json={"upload_id": upload_id, "title": "Integração", "rules": _rules(user_ids=[gone])})

    assert status(r) == GONE


async def test_video_patch_keeps_existing_deactivated_target(db, client_as, sample_mp4):
    company, manager, active, gone = await setup(db)
    other = await make_user(db, company, name="Outra")
    await db.execute("UPDATE public.profiles SET deactivated_at = NULL WHERE user_id = $1", gone)
    c = client_as(manager)
    video = await _create(c, sample_mp4, _rules(user_ids=[gone]))
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", gone)

    kept = await c.patch(f"/videos/{video['id']}", json={"rules": _rules(user_ids=[gone, active])})
    assert kept.status_code == 200, kept.text

    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", other)
    added = await c.patch(f"/videos/{video['id']}", json={"rules": _rules(user_ids=[gone, active, other])})
    assert status(added) == GONE


async def test_bingo_participants(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).post("/bingo/games", json={
        "name": "Bingo", "number_pool": 30, "winners_target": 1, "participant_user_ids": [active, gone],
    })

    assert status(r) == GONE
    assert await db.fetchval("SELECT count(*) FROM public.bingo_games WHERE company_id = $1", company) == 0


async def test_timeclock_manual(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).post("/timeclock/manual", json={
        "user_id": gone, "kind": "in", "punched_at": "2026-10-28T08:00:00",
    })

    assert status(r) == GONE
    assert await count(db, "timeclock_punches", gone) == 0


async def test_goal_responsible(db, client_as):
    company, manager, active, gone = await setup(db)
    dept = await make_department(db, company, "Vendas")
    cycle = await db.fetchval(
        """INSERT INTO public.management_cycles (company_id, name, start_date, end_date)
           VALUES ($1, '2026', '2026-01-01', '2026-12-31') RETURNING id""",
        company,
    )
    c = client_as(manager)
    goal = {"cycle_id": str(cycle), "department_id": dept, "title": "Vendas", "target_value": 100}

    r = await c.post("/goals", json={**goal, "responsible_user_id": gone})
    assert status(r) == GONE

    created = await c.post("/goals", json={**goal, "responsible_user_id": active})
    assert created.status_code == 201, created.text
    goal_id = created.json()["id"]
    r = await c.put(f"/goals/{goal_id}", json={"responsible_user_id": gone})
    assert status(r) == GONE

    # Meta antiga cujo responsável saiu continua editável sem trocar o responsável.
    await db.execute("UPDATE public.goals SET responsible_user_id = $2 WHERE id = $1", goal_id, gone)
    r = await c.put(f"/goals/{goal_id}", json={"responsible_user_id": gone, "title": "Vendas 2"})
    assert r.status_code == 200, r.text


async def test_benefit_assign(db, client_as):
    company, manager, active, gone = await setup(db)
    benefit = await db.fetchval(
        "INSERT INTO public.benefit_catalog (company_id, name, category) VALUES ($1, 'VR', 'alimentacao') RETURNING id",
        company,
    )

    r = await client_as(manager).post("/benefits/assign", json={"user_id": gone, "benefit_id": str(benefit)})

    assert status(r) == GONE
    assert await count(db, "employee_benefits", gone) == 0
