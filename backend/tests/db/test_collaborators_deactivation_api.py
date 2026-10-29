from datetime import date, timedelta

import pytest
from fastapi import HTTPException

from app.roster import ensure_active_targets
from tests.db.conftest import make_company, make_user


@pytest.fixture(autouse=True)
async def prod_like_conn(db):
    # profiles.job_title só existe em produção (ver backend/scripts/captures-db.sh).
    await db.execute("ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS job_title text")


async def profile_id(db, user_id) -> str:
    return str(await db.fetchval("SELECT id FROM public.profiles WHERE user_id = $1", user_id))


def body(**extra):
    return {"termination_date": date.today().isoformat(), "reason": "resignation", **extra}


async def terminations(db, user_id):
    return await db.fetch(
        """SELECT t.* FROM public.collaborator_terminations t
           JOIN public.profiles p ON p.id = t.profile_id
           WHERE p.user_id = $1 ORDER BY t.deactivated_at""",
        user_id,
    )


async def is_deactivated(db, user_id) -> bool:
    return await db.fetchval(
        "SELECT deactivated_at IS NOT NULL FROM public.profiles WHERE user_id = $1", user_id
    )


async def test_manager_deactivates_user(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    user = await make_user(db, company, name="Karol")
    day = (date.today() - timedelta(days=3)).isoformat()

    r = await client_as(manager).post(
        f"/collaborators/{await profile_id(db, user)}/deactivate",
        json=body(termination_date=day, reason="contract_end", note="Fim da experiência"),
    )

    assert r.status_code == 204, r.text
    assert await is_deactivated(db, user)
    [t] = await terminations(db, user)
    assert (t["termination_date"].isoformat(), t["reason"], t["note"], str(t["deactivated_by"])) == (
        day, "contract_end", "Fim da experiência", manager,
    )
    assert str(t["company_id"]) == company


async def test_deactivate_closes_open_benefits(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    benefit = await db.fetchval(
        "INSERT INTO public.benefit_catalog (company_id, name, category) VALUES ($1, 'VR', 'alimentacao') RETURNING id",
        company,
    )
    day = date.today() - timedelta(days=2)
    past = date.today() - timedelta(days=30)
    future = date.today() + timedelta(days=30)
    ids = {}
    for key, end in (("open", None), ("future", future), ("past", past)):
        ids[key] = await db.fetchval(
            """INSERT INTO public.employee_benefits (company_id, user_id, benefit_id, start_date, end_date)
               VALUES ($1, $2, $3, $4, $5) RETURNING id""",
            company, user, benefit, date.today() - timedelta(days=60), end,
        )

    r = await client_as(manager).post(
        f"/collaborators/{await profile_id(db, user)}/deactivate", json=body(termination_date=day.isoformat())
    )

    assert r.status_code == 204, r.text
    ends = {k: await db.fetchval("SELECT end_date FROM public.employee_benefits WHERE id = $1", v) for k, v in ids.items()}
    assert ends == {"open": day, "future": day, "past": past}


async def test_manager_cannot_deactivate_master_admin(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    admin = await make_user(db, company, role="master_admin")

    r = await client_as(manager).post(f"/collaborators/{await profile_id(db, admin)}/deactivate", json=body())

    assert r.status_code == 403, r.text
    assert not await is_deactivated(db, admin)
    assert await terminations(db, admin) == []


async def test_manager_deactivates_manager(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    other = await make_user(db, company, role="manager")

    r = await client_as(manager).post(f"/collaborators/{await profile_id(db, other)}/deactivate", json=body())

    assert r.status_code == 204, r.text


async def test_master_admin_deactivates_master_admin(db, client_as):
    company = await make_company(db)
    admin = await make_user(db, company, role="master_admin")
    other = await make_user(db, company, role="master_admin")

    r = await client_as(admin).post(f"/collaborators/{await profile_id(db, other)}/deactivate", json=body())

    assert r.status_code == 204, r.text


async def test_user_cannot_deactivate(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    other = await make_user(db, company)

    r = await client_as(user).post(f"/collaborators/{await profile_id(db, other)}/deactivate", json=body())

    assert r.status_code == 403, r.text


async def test_cannot_deactivate_self(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")

    r = await client_as(manager).post(f"/collaborators/{await profile_id(db, manager)}/deactivate", json=body())

    assert r.status_code == 400, r.text
    assert not await is_deactivated(db, manager)


async def test_deactivate_twice_is_409(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    c = client_as(manager)
    url = f"/collaborators/{await profile_id(db, user)}/deactivate"

    assert (await c.post(url, json=body())).status_code == 204
    r = await c.post(url, json=body())

    assert r.status_code == 409, r.text
    assert len(await terminations(db, user)) == 1


async def test_future_date_is_422(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    tomorrow = (date.today() + timedelta(days=1)).isoformat()

    r = await client_as(manager).post(
        f"/collaborators/{await profile_id(db, user)}/deactivate", json=body(termination_date=tomorrow)
    )

    assert r.status_code == 422, r.text
    assert not await is_deactivated(db, user)


async def test_other_without_note_is_422(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    c = client_as(manager)
    url = f"/collaborators/{await profile_id(db, user)}/deactivate"

    for extra in ({}, {"note": "   "}):
        r = await c.post(url, json=body(reason="other", **extra))
        assert r.status_code == 422, r.text
    assert (await c.post(url, json=body(reason="other", note="Mudou de cidade"))).status_code == 204


async def test_unknown_reason_is_422(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)

    r = await client_as(manager).post(
        f"/collaborators/{await profile_id(db, user)}/deactivate", json=body(reason="sumiu")
    )

    assert r.status_code == 422, r.text


async def test_other_company_profile_is_404(db, client_as):
    company = await make_company(db)
    other_company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    stranger = await make_user(db, other_company)
    c = client_as(manager)

    r = await c.post(f"/collaborators/{await profile_id(db, stranger)}/deactivate", json=body())
    assert r.status_code == 404, r.text
    r = await c.post(f"/collaborators/{await profile_id(db, stranger)}/reactivate")
    assert r.status_code == 404, r.text


async def test_reactivate_and_deactivate_again(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    c = client_as(manager)
    pid = await profile_id(db, user)

    assert (await c.post(f"/collaborators/{pid}/deactivate", json=body(reason="resignation"))).status_code == 204
    r = await c.post(f"/collaborators/{pid}/reactivate")
    assert r.status_code == 204, r.text
    assert not await is_deactivated(db, user)
    [first] = await terminations(db, user)
    assert first["reactivated_at"] is not None and str(first["reactivated_by"]) == manager

    assert (await c.post(f"/collaborators/{pid}/deactivate", json=body(reason="mutual_agreement"))).status_code == 204
    rows = await terminations(db, user)
    assert [t["reason"] for t in rows] == ["resignation", "mutual_agreement"]
    assert rows[0]["reactivated_at"] is not None and rows[1]["reactivated_at"] is None


async def test_reactivate_active_is_409(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, role="manager")
    user = await make_user(db, company)

    r = await client_as(manager).post(f"/collaborators/{await profile_id(db, user)}/reactivate")

    assert r.status_code == 409, r.text


async def test_manager_cannot_reactivate_master_admin(db, client_as):
    company = await make_company(db)
    admin = await make_user(db, company, role="master_admin")
    other_admin = await make_user(db, company, role="master_admin")
    manager = await make_user(db, company, role="manager")
    pid = await profile_id(db, other_admin)
    assert (await client_as(admin).post(f"/collaborators/{pid}/deactivate", json=body())).status_code == 204

    r = await client_as(manager).post(f"/collaborators/{pid}/reactivate")

    assert r.status_code == 403, r.text
    assert await is_deactivated(db, other_admin)


async def test_list_by_status(db, client_as):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    gone = await make_user(db, company, name="Saiu")
    c = client_as(manager)
    assert (await c.post(
        f"/collaborators/{await profile_id(db, gone)}/deactivate",
        json=body(reason="other", note="Mudou de cidade"),
    )).status_code == 204

    async def names(query=""):
        r = await c.get(f"/collaborators{query}")
        assert r.status_code == 200, r.text
        return {p["name"]: p for p in r.json()}

    assert set(await names()) == {"Gestora"}
    assert set(await names("?status=active")) == {"Gestora"}
    inactive = await names("?status=inactive")
    assert set(inactive) == {"Saiu"}
    t = inactive["Saiu"]["termination"]
    assert (t["termination_date"], t["reason"], t["note"]) == (date.today().isoformat(), "other", "Mudou de cidade")
    assert inactive["Saiu"]["deactivated_at"] is not None
    everyone = await names("?status=all")
    assert set(everyone) == {"Gestora", "Saiu"}
    assert everyone["Gestora"]["termination"] is None


async def test_list_scoped_to_caller_company(db, client_as):
    company = await make_company(db)
    other_company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    await make_user(db, other_company, name="Estranha")

    r = await client_as(manager).get("/collaborators?status=all")

    assert r.status_code == 200, r.text
    assert [p["name"] for p in r.json()] == ["Gestora"]


async def test_ensure_active_targets(db):
    company = await make_company(db)
    active = await make_user(db, company)
    gone = await make_user(db, company)
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", gone)

    await ensure_active_targets(db, [active, "00000000-0000-0000-0000-000000000000"])
    await ensure_active_targets(db, [])
    with pytest.raises(HTTPException) as exc:
        await ensure_active_targets(db, [active, gone])
    assert (exc.value.status_code, exc.value.detail) == (422, "Colaborador desligado")
