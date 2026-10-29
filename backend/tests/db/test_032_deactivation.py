import asyncpg
import pytest

from tests.db.conftest import make_company, make_department, make_user
from tests.db.test_029_internal_videos import add_rule, make_video, video_notifications, viewer


async def profile_id(db, user_id) -> str:
    return str(await db.fetchval("SELECT id FROM public.profiles WHERE user_id = $1", user_id))


async def deactivate(db, user_id):
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", user_id)


async def insert_termination(db, company, user_id, actor, reason="resignation", note=None):
    await db.execute(
        """INSERT INTO public.collaborator_terminations
             (profile_id, company_id, termination_date, reason, note, deactivated_by)
           VALUES ($1, $2, CURRENT_DATE, $3, $4, $5)""",
        await profile_id(db, user_id), company, reason, note, actor,
    )


async def test_reason_other_requires_note(db):
    company = await make_company(db)
    actor = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    with pytest.raises(asyncpg.CheckViolationError):
        await insert_termination(db, company, user, actor, reason="other", note="  ")


async def test_only_one_open_termination(db):
    company = await make_company(db)
    actor = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    await insert_termination(db, company, user, actor)
    with pytest.raises(asyncpg.UniqueViolationError):
        await insert_termination(db, company, user, actor)


async def test_deleting_actor_keeps_record(db):
    company = await make_company(db)
    actor = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    await insert_termination(db, company, user, actor)

    await db.execute("DELETE FROM auth.users WHERE id = $1", actor)

    row = await db.fetchrow(
        "SELECT deactivated_by FROM public.collaborator_terminations WHERE profile_id = $1",
        await profile_id(db, user),
    )
    assert row is not None and row["deactivated_by"] is None


async def test_apply_rules_skips_deactivated(db):
    company = await make_company(db)
    active = await make_user(db, company, name="Ativa")
    gone = await make_user(db, company, name="Saiu")
    await deactivate(db, gone)
    video = await make_video(db, company)
    await add_rule(db, video, "all")

    await db.fetchval("SELECT public.internal_video_apply_rules($1)", video)

    assert await viewer(db, video, active) is not None
    assert await viewer(db, video, gone) is None


async def test_profile_change_skips_deactivated(db):
    company = await make_company(db)
    rh = await make_department(db, company, "RH")
    ti = await make_department(db, company, "TI")
    video = await make_video(db, company)
    await add_rule(db, video, "department", department_id=ti)
    gone = await make_user(db, company, rh)
    await deactivate(db, gone)

    await db.execute("UPDATE public.profiles SET department_id = $1 WHERE user_id = $2", ti, gone)

    assert await viewer(db, video, gone) is None


async def test_reactivation_assigns_missed_videos(db):
    company = await make_company(db)
    gone = await make_user(db, company)
    await deactivate(db, gone)
    video = await make_video(db, company, title="Novidades")
    await add_rule(db, video, "all")
    await db.fetchval("SELECT public.internal_video_apply_rules($1)", video)
    assert await viewer(db, video, gone) is None

    await db.execute("UPDATE public.profiles SET deactivated_at = NULL WHERE user_id = $1", gone)

    assert await viewer(db, video, gone) is not None
    assert await video_notifications(db, gone) == 1
