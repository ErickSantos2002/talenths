import csv
import io
from datetime import date, datetime, timedelta, timezone

import pytest

from app import video_storage
from tests.db.conftest import make_company, make_user
from tests.db.test_videos_admin_api import _create, _rules
from tests.db.test_videos_upload_api import SMALL


@pytest.fixture(autouse=True)
async def prod_columns(db, monkeypatch):
    monkeypatch.setattr(video_storage, "PART_SIZE", SMALL)
    # Colunas que só existem em produção (ver backend/scripts/captures-db.sh).
    await db.execute("ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS job_title text")
    await db.execute("ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS position text")


async def deactivate(db, user_id):
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", user_id)


async def setup(db):
    """Empresa com gestora, uma pessoa ativa e uma desligada, todas fazendo aniversário e
    aniversário de empresa neste mês."""
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    active = await make_user(db, company, name="Ativa")
    gone = await make_user(db, company, name="Saiu")
    today = date.today()
    await db.execute(
        "UPDATE public.profiles SET birth_date = $2, hire_date = $3 WHERE company_id = $1",
        company, today.replace(year=1990), today.replace(year=today.year - 2),
    )
    await deactivate(db, gone)
    return company, manager, active, gone


async def test_profiles_list_excludes_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    c = client_as(manager)

    for url in ("/profiles", f"/profiles?company_id={company}"):
        r = await c.get(url)
        assert r.status_code == 200, r.text
        assert sorted(p["name"] for p in r.json()) == ["Ativa", "Gestora"]


async def test_birthdays_and_milestones_exclude_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    c = client_as(manager)

    for url in ("/communications/birthdays", "/communications/milestones"):
        r = await c.get(url)
        assert r.status_code == 200, r.text
        assert sorted(p["name"] for p in r.json()) == ["Ativa", "Gestora"], url


async def test_calendar_hides_deactivated_birthdays_and_future_absences(db, client_as):
    company, manager, active, gone = await setup(db)
    absence_type = await db.fetchval(
        "INSERT INTO public.absence_types (company_id, name) VALUES ($1, 'Férias') RETURNING id", company
    )
    today = date.today()
    for uid, start in ((gone, today - timedelta(days=40)), (gone, today + timedelta(days=10)),
                       (active, today + timedelta(days=10))):
        await db.execute(
            """INSERT INTO public.absence_requests (company_id, user_id, type_id, start_date, end_date, days, status)
               VALUES ($1, $2, $3, $4, $4, 1, 'approved')""",
            company, uid, absence_type, start,
        )

    r = await client_as(manager).get(
        f"/calendar/feed?start={(today - timedelta(days=60)).isoformat()}&end={(today + timedelta(days=60)).isoformat()}"
    )

    assert r.status_code == 200, r.text
    items = r.json()
    birthday_titles = " ".join(i["title"] for i in items if i["source"] == "birthday")
    assert "Saiu" not in birthday_titles and "Ativa" in birthday_titles
    absences = [(i["title"], i["start_date"][:10]) for i in items if i["source"] == "absence"]
    assert any("Saiu" in t and s < today.isoformat() for t, s in absences)
    assert not any("Saiu" in t and s > today.isoformat() for t, s in absences)
    assert any("Ativa" in t for t, s in absences)


async def test_salary_positioning_excludes_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    ref = await db.fetchval(
        """INSERT INTO public.salary_market_references (company_id, name, market, region, reference_year)
           VALUES ($1, 'Ref', 'TI', 'BH', 2026) RETURNING id""",
        company,
    )

    r = await client_as(manager).get(f"/salary/positioning?reference_id={ref}")

    assert r.status_code == 200, r.text
    assert sorted(p["name"] for p in r.json()) == ["Ativa", "Gestora"]


async def test_tour_adoption_excludes_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)

    r = await client_as(manager).get("/tour/adoption")

    assert r.status_code == 200, r.text
    assert sorted(p["name"] for p in r.json()) == ["Ativa", "Gestora"]


def _csv(text):
    return list(csv.reader(io.StringIO(text.lstrip("﻿")), delimiter=";"))


async def test_reports_collaborators_default_and_include_inactive(db, client_as):
    company, manager, active, gone = await setup(db)
    await db.execute(
        """INSERT INTO public.collaborator_terminations
             (profile_id, company_id, termination_date, reason, deactivated_by)
           SELECT id, company_id, DATE '2026-10-01', 'contract_end', $2 FROM public.profiles WHERE user_id = $1""",
        gone, manager,
    )
    c = client_as(manager)

    default = _csv((await c.get("/reports/collaborators")).text)
    assert sorted(row[0] for row in default[1:]) == ["Ativa", "Gestora"]
    assert "Situação" not in default[0]

    full = _csv((await c.get("/reports/collaborators?include_inactive=true")).text)
    head = full[0]
    assert head[-3:] == ["Situação", "Data do desligamento", "Motivo"]
    rows = {row[0]: row for row in full[1:]}
    assert set(rows) == {"Ativa", "Gestora", "Saiu"}
    assert rows["Saiu"][-3:] == ["Desligado(a)", "2026-10-01", "Fim de contrato ou de experiência"]
    assert rows["Ativa"][-3:] == ["Ativo", "", ""]


async def test_consolidate_skips_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    cycle = await db.fetchval(
        "INSERT INTO public.evaluation_cycles (company_id, name) VALUES ($1, 'Ciclo') RETURNING id", company
    )
    for uid in (active, gone):
        ev = await db.fetchval(
            """INSERT INTO public.evaluations (eval_cycle_id, company_id, evaluated_user_id, evaluator_user_id, eval_type, submitted_at)
               VALUES ($1, $2, $3, $3, 'self', now()) RETURNING id""",
            cycle, company, uid,
        )
        await db.execute(
            "INSERT INTO public.evaluation_scores (evaluation_id, behavior_key, score) VALUES ($1, 'proatividade', 4)", ev
        )

    r = await client_as(manager).post(f"/evaluations/cycles/{cycle}/consolidate")

    assert r.status_code == 200, r.text
    scored = {str(u) for u in await db.fetchval(
        "SELECT array_agg(user_id) FROM public.consolidated_scores WHERE eval_cycle_id = $1", cycle
    ) or []}
    assert scored == {active}


async def test_video_admin_counts_exclude_deactivated(db, client_as, sample_mp4):
    company, manager, active, gone = await setup(db)
    await db.execute("UPDATE public.profiles SET deactivated_at = NULL WHERE user_id = $1", gone)
    video = await _create(client_as(manager), sample_mp4, _rules(user_ids=[active, gone]))
    await deactivate(db, gone)

    r = await client_as(manager).get("/videos/admin")

    assert r.status_code == 200, r.text
    [row] = [v for v in r.json() if v["id"] == video["id"]]
    assert row["required_count"] == 1


async def test_benefits_summary_excludes_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    benefit = await db.fetchval(
        "INSERT INTO public.benefit_catalog (company_id, name, category) VALUES ($1, 'VR', 'alimentacao') RETURNING id",
        company,
    )
    for uid in (active, gone):
        await db.execute(
            "INSERT INTO public.employee_benefits (company_id, user_id, benefit_id) VALUES ($1, $2, $3)",
            company, uid, benefit,
        )

    r = await client_as(manager).get("/benefits/summary")

    assert r.status_code == 200, r.text
    assert [b["employee_count"] for b in r.json()] == [1]


async def test_workshop_seats_exclude_deactivated(db, client_as):
    company, manager, active, gone = await setup(db)
    workshop = await db.fetchval(
        """INSERT INTO public.workshops (company_id, title, area, starts_at, ends_at, max_seats)
           VALUES ($1, 'Oficina', 'Gestão', $2, $3, 10) RETURNING id""",
        company, datetime.now(timezone.utc) + timedelta(days=5), datetime.now(timezone.utc) + timedelta(days=5, hours=2),
    )
    for uid in (active, gone):
        await db.execute(
            "INSERT INTO public.workshop_registrations (company_id, workshop_id, user_id) VALUES ($1, $2, $3)", company, workshop, uid
        )

    r = await client_as(manager).get("/workshops")

    assert r.status_code == 200, r.text
    [w] = r.json()
    assert w["seats_taken"] == 1


async def test_test_submit_does_not_notify_deactivated_manager(db, client_as):
    from tests.db.test_custom_tests_take_api import CUSTOM_TESTS_DDL, _make_test

    await db.execute("DROP TABLE public.test_responses")
    await db.execute(CUSTOM_TESTS_DDL.read_text())
    company, manager, active, gone = await setup(db)
    old_manager = await make_user(db, company, name="Ex-gestora", role="manager")
    await deactivate(db, old_manager)
    test_id = await _make_test(db, company, manager, is_public=True)
    # Correção manual: o envio fica "submitted" e avisa os gestores.
    await db.execute("UPDATE public.custom_tests SET scoring_mode = 'manual' WHERE id = $1::uuid", test_id)
    c = client_as(active)
    attempt = (await c.post(f"/tests/{test_id}/start")).json()["id"]

    r = await c.post(f"/tests/attempts/{attempt}/submit")

    assert r.status_code == 200, r.text
    notified = {str(u) for u in await db.fetchval(
        "SELECT array_agg(user_id) FROM public.notifications WHERE type = 'test_pending_evaluation'"
    ) or []}
    assert manager in notified and old_manager not in notified


async def test_test_stats_exclude_deactivated(db, client_as):
    from tests.db.test_custom_tests_take_api import CUSTOM_TESTS_DDL, _make_test

    await db.execute("DROP TABLE public.test_responses")
    await db.execute(CUSTOM_TESTS_DDL.read_text())
    company, manager, active, gone = await setup(db)
    test_id = await _make_test(db, company, manager)
    for uid in (active, gone):
        await db.execute(
            "INSERT INTO public.test_attempts (test_id, user_id, status, passed) VALUES ($1, $2, 'submitted', true)",
            test_id, uid,
        )

    r = await client_as(manager).get(f"/tests/{test_id}/stats")

    assert r.status_code == 200, r.text
    assert (r.json()["total_attempts"], r.json()["submitted"], r.json()["approved"]) == (1, 1, 1)
