import asyncpg
import pytest

from tests.db.conftest import make_company, make_user

INSERT = "INSERT INTO public.tour_progress (user_id, tour, version, step) VALUES ($1, $2, $3, $4)"


async def test_insert_minimal_row_defaults(db):
    user = await make_user(db, await make_company(db))

    await db.execute(
        "INSERT INTO public.tour_progress (user_id, tour, version) VALUES ($1, 'boas-vindas-colaborador', 1)",
        user,
    )

    row = await db.fetchrow("SELECT * FROM public.tour_progress WHERE user_id = $1", user)
    assert row["step"] == 0 and row["invites_declined"] == 0
    assert row["started_at"] is None and row["completed_at"] is None and row["dismissed_at"] is None


@pytest.mark.parametrize("tour", ["Boas Vindas", "", "a" * 65])
async def test_tour_id_format_rejected(db, tour):
    user = await make_user(db, await make_company(db))
    with pytest.raises(asyncpg.CheckViolationError):
        await db.execute(INSERT, user, tour, 1, 0)


@pytest.mark.parametrize("version,step", [(0, 0), (1000, 0), (1, -1), (1, 1000)])
async def test_version_and_step_ranges(db, version, step):
    user = await make_user(db, await make_company(db))
    with pytest.raises(asyncpg.CheckViolationError):
        await db.execute(INSERT, user, "boas-vindas", version, step)


async def test_negative_declines_rejected(db):
    user = await make_user(db, await make_company(db))
    with pytest.raises(asyncpg.CheckViolationError):
        await db.execute(
            "INSERT INTO public.tour_progress (user_id, tour, version, invites_declined)"
            " VALUES ($1, 'boas-vindas', 1, -1)",
            user,
        )


async def test_unique_per_user_and_tour(db):
    company = await make_company(db)
    user = await make_user(db, company)
    other = await make_user(db, company)
    await db.execute(INSERT, user, "boas-vindas", 1, 0)

    with pytest.raises(asyncpg.UniqueViolationError):
        async with db.transaction():  # savepoint: a violação não aborta a transação do teste
            await db.execute(INSERT, user, "boas-vindas", 1, 0)
    await db.execute(INSERT, other, "boas-vindas", 1, 0)


async def test_deleting_user_cascades(db):
    user = await make_user(db, await make_company(db))
    await db.execute(INSERT, user, "boas-vindas", 1, 0)

    await db.execute("DELETE FROM public.user_roles WHERE user_id = $1", user)
    await db.execute("DELETE FROM public.profiles WHERE user_id = $1", user)
    await db.execute("DELETE FROM auth.users WHERE id = $1", user)

    assert await db.fetchval("SELECT count(*) FROM public.tour_progress") == 0
