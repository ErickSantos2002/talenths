import asyncpg

from tests.db.conftest import make_company, make_department, make_user


async def make_video(db, company_id, title="Integração", archived=False) -> str:
    return str(await db.fetchval(
        """INSERT INTO public.internal_videos
             (company_id, title, file_path, file_size, duration_seconds, archived_at)
           VALUES ($1, $2, 'x.mp4', 1000, 600, CASE WHEN $3 THEN now() END)
           RETURNING id""",
        company_id, title, archived,
    ))


async def add_rule(db, video_id, target_type, department_id=None, user_id=None) -> str:
    return str(await db.fetchval(
        """INSERT INTO public.internal_video_rules (video_id, target_type, department_id, user_id)
           VALUES ($1, $2, $3, $4) RETURNING id""",
        video_id, target_type, department_id, user_id,
    ))


async def viewer(db, video_id, user_id):
    return await db.fetchrow(
        "SELECT * FROM public.internal_video_viewers WHERE video_id = $1 AND user_id = $2",
        video_id, user_id,
    )


async def video_notifications(db, user_id) -> int:
    return await db.fetchval(
        "SELECT count(*) FROM public.notifications WHERE user_id = $1 AND type = 'video'",
        user_id,
    )


async def test_new_hire_in_department_gets_video_and_notification(db):
    company = await make_company(db)
    dept = await make_department(db, company, "RH")
    video = await make_video(db, company, title="Boas-vindas")
    await add_rule(db, video, "department", department_id=dept)

    user = await make_user(db, company, dept)

    row = await viewer(db, video, user)
    assert row is not None and row["required"] is True and row["excluded"] is False
    notes = await db.fetch(
        "SELECT title, message FROM public.notifications WHERE user_id = $1 AND type = 'video'",
        user,
    )
    assert [(n["title"], n["message"]) for n in notes] == [("Novo vídeo para assistir", "Boas-vindas")]


async def test_rule_all_includes_managers(db):
    company = await make_company(db)
    video = await make_video(db, company)
    await add_rule(db, video, "all")

    manager = await make_user(db, company, role="manager")

    row = await viewer(db, video, manager)
    assert row is not None and row["required"] is True


async def test_company_set_after_signup_assigns_rule_all(db):
    company = await make_company(db)
    video = await make_video(db, company)
    await add_rule(db, video, "all")
    user = str(await db.fetchval(
        "INSERT INTO auth.users (email) VALUES ('sem-empresa@teste.local') RETURNING id"
    ))
    assert await viewer(db, video, user) is None

    await db.execute("UPDATE public.profiles SET company_id = $1 WHERE user_id = $2", company, user)

    row = await viewer(db, video, user)
    assert row is not None and row["required"] is True


async def test_null_company_profile_not_assigned(db):
    company = await make_company(db)
    video = await make_video(db, company)
    await add_rule(db, video, "all")

    user = await make_user(db, None)

    assert await viewer(db, video, user) is None
    assert await db.fetchval(
        "SELECT public.internal_video_apply_rules($1)", video
    ) == 0
    assert await video_notifications(db, user) == 0


async def test_department_change_keeps_old_and_adds_new(db):
    company = await make_company(db)
    d1 = await make_department(db, company, "Vendas")
    d2 = await make_department(db, company, "Suporte")
    video_a = await make_video(db, company, title="A")
    video_b = await make_video(db, company, title="B")
    await add_rule(db, video_a, "department", department_id=d1)
    await add_rule(db, video_b, "department", department_id=d2)
    user = await make_user(db, company, d1)

    await db.execute("UPDATE public.profiles SET department_id = $1 WHERE user_id = $2", d2, user)

    assert (await viewer(db, video_a, user))["required"] is True
    assert (await viewer(db, video_b, user))["required"] is True
    assert await video_notifications(db, user) == 2


async def test_profile_update_same_department_no_duplicate_notification(db):
    company = await make_company(db)
    dept = await make_department(db, company, "RH")
    video = await make_video(db, company)
    await add_rule(db, video, "department", department_id=dept)
    user = await make_user(db, company, dept)

    await db.execute("UPDATE public.profiles SET name = 'x' WHERE user_id = $1", user)
    await db.execute("UPDATE public.profiles SET department_id = $1 WHERE user_id = $2", dept, user)

    assert await video_notifications(db, user) == 1


async def test_excluded_viewer_not_reassigned(db):
    company = await make_company(db)
    d1 = await make_department(db, company, "RH")
    d2 = await make_department(db, company, "TI")
    video = await make_video(db, company)
    await add_rule(db, video, "department", department_id=d1)
    user = await make_user(db, company, d1)
    await db.execute(
        """UPDATE public.internal_video_viewers SET excluded = true, required = false
           WHERE video_id = $1 AND user_id = $2""",
        video, user,
    )

    await db.execute("UPDATE public.profiles SET department_id = $1 WHERE user_id = $2", d2, user)
    await db.execute("UPDATE public.profiles SET department_id = $1 WHERE user_id = $2", d1, user)
    assert await db.fetchval("SELECT public.internal_video_apply_rules($1)", video) == 0

    row = await viewer(db, video, user)
    assert row["excluded"] is True and row["required"] is False
    assert await video_notifications(db, user) == 1


async def test_archived_video_not_assigned_then_backfilled(db):
    company = await make_company(db)
    video = await make_video(db, company, archived=True)
    await add_rule(db, video, "all")

    user = await make_user(db, company)
    assert await viewer(db, video, user) is None
    assert await db.fetchval("SELECT public.internal_video_apply_rules($1)", video) == 0

    await db.execute("UPDATE public.internal_videos SET archived_at = NULL WHERE id = $1", video)
    assert await db.fetchval("SELECT public.internal_video_apply_rules($1)", video) == 1

    assert (await viewer(db, video, user))["required"] is True
    assert await video_notifications(db, user) == 1


async def test_voluntary_row_promoted_to_required(db):
    company = await make_company(db)
    video = await make_video(db, company)
    user = await make_user(db, company)
    await db.execute(
        """INSERT INTO public.internal_video_viewers (video_id, user_id, required, max_watched_s)
           VALUES ($1, $2, false, 50)""",
        video, user,
    )

    assert await db.fetchval(
        "SELECT public.internal_video_assign($1, $2::uuid[])", video, [user]
    ) == 1
    assert await db.fetchval(
        "SELECT public.internal_video_assign($1, $2::uuid[])", video, [user]
    ) == 0

    row = await viewer(db, video, user)
    assert row["required"] is True and row["max_watched_s"] == 50
    assert await video_notifications(db, user) == 1


async def test_deleted_user_row_survives_with_snapshot(db):
    company = await make_company(db)
    dept = await make_department(db, company, "RH")
    video = await make_video(db, company)
    await add_rule(db, video, "department", department_id=dept)
    user = await make_user(db, company, dept, name="Fulano")

    await db.execute("DELETE FROM public.user_roles WHERE user_id = $1", user)
    await db.execute("DELETE FROM public.profiles WHERE user_id = $1", user)
    await db.execute("DELETE FROM auth.users WHERE id = $1", user)

    rows = await db.fetch(
        "SELECT * FROM public.internal_video_viewers WHERE video_id = $1", video
    )
    assert len(rows) == 1
    assert rows[0]["user_id"] is None
    assert rows[0]["user_name_snapshot"] == "Fulano"
    assert rows[0]["department_name_snapshot"] == "RH"


async def _violates_check(db, sql, *args) -> bool:
    try:
        async with db.transaction():
            await db.execute(sql, *args)
    except asyncpg.CheckViolationError:
        return True
    return False


async def test_size_duration_and_progress_checks(db):
    company = await make_company(db)
    user = await make_user(db, company)
    insert_video = """INSERT INTO public.internal_videos (company_id, title, file_path, file_size, duration_seconds)
                      VALUES ($1, 'T', 'x.mp4', $2, $3)"""
    assert await _violates_check(db, insert_video, company, 1000, 0)
    assert await _violates_check(db, insert_video, company, 0, 600)
    video = await make_video(db, company)
    assert await _violates_check(
        db, "INSERT INTO public.internal_video_viewers (video_id, user_id, max_watched_s) VALUES ($1, $2, -1)",
        video, user,
    )
    assert await _violates_check(
        db, "INSERT INTO public.internal_video_uploads (company_id, total_size) VALUES ($1, 0)", company
    )
