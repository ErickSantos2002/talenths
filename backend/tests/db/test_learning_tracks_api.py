from tests.db.conftest import make_company, make_user

HEADER = (
    "Id do Colaborador;Matrícula Interna;Nome do Colaborador;CPF;Cargo;E-mail;Celular;Grupo;Id da Trilha;"
    "Nome da Trilha;Cursos da Trilha;Data que Iniciou a Trilha;Data que Finalizou a Trilha;"
    "Progresso na Trilha em %;Aproveitamento na Trilha em %"
)


def csv_file(*lines: str, encoding="cp1252") -> dict:
    content = ("\r\n".join([HEADER, *lines]) + "\r\n").encode(encoding)
    return {"file": ("trilha.csv", content, "text/csv")}


def line(email, track_id="14427", track="MARKETING", finished="", progress="6", cpf=""):
    return f"1;;Pessoa;{cpf};;{email};;MARKETING;{track_id};{track};Copywriting, Social Selling;2026-07-09 10:08:41;{finished};{progress};100"


async def setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    ana = await make_user(db, company, name="Ana")
    email = await db.fetchval("SELECT email FROM public.profiles WHERE user_id = $1", ana)
    return company, manager, ana, email


async def tracks(db, user_id):
    return await db.fetch("SELECT * FROM public.learning_track_progress WHERE user_id = $1", user_id)


async def courses(db, user_id):
    return await db.fetch("SELECT * FROM public.employee_courses WHERE user_id = $1", user_id)


async def test_import_in_progress_track(db, client_as):
    company, manager, ana, email = await setup(db)

    r = await client_as(manager).post("/learning/import-csv", files=csv_file(line(email)))

    assert r.status_code == 200, r.text
    body = r.json()
    assert (body["format"], body["inserted"], body["tracks_updated"], body["tracks_completed"], body["errors"]) == (
        "plataforma", 0, 1, 0, [],
    )
    [t] = await tracks(db, ana)
    assert (t["track_name"], t["group_name"], float(t["progress_pct"]), t["finished_at"]) == ("MARKETING", "MARKETING", 6.0, None)
    assert t["courses"] == "Copywriting, Social Selling"
    assert str(t["imported_by"]) == manager
    assert await courses(db, ana) == []


async def test_reimport_updates_without_duplicating(db, client_as):
    company, manager, ana, email = await setup(db)
    c = client_as(manager)
    await c.post("/learning/import-csv", files=csv_file(line(email, progress="6")))
    first = (await tracks(db, ana))[0]["imported_at"]

    r = await c.post("/learning/import-csv", files=csv_file(line(email, progress="40")))

    assert r.json()["tracks_updated"] == 1
    [t] = await tracks(db, ana)
    assert float(t["progress_pct"]) == 40.0 and t["imported_at"] >= first


async def test_finished_track_creates_one_course_record(db, client_as):
    company, manager, ana, email = await setup(db)
    c = client_as(manager)
    done = line(email, finished="2026-08-20 17:30:00", progress="100")

    r = await c.post("/learning/import-csv", files=csv_file(done))
    assert (r.json()["inserted"], r.json()["tracks_completed"]) == (1, 1)
    r = await c.post("/learning/import-csv", files=csv_file(done))
    assert (r.json()["inserted"], r.json()["tracks_completed"]) == (0, 0)

    [course] = await courses(db, ana)
    assert (course["course_title"], course["area"], float(course["hours"]), course["completed_at"].isoformat(), course["source"]) == (
        "MARKETING", "MARKETING", 0.0, "2026-08-20", "csv",
    )
    [t] = await tracks(db, ana)
    assert t["employee_course_id"] == course["id"]


async def test_utf8_with_bom_is_read(db, client_as):
    company, manager, ana, email = await setup(db)
    content = ("﻿" + HEADER + "\r\n" + line(email) + "\r\n").encode("utf-8")

    r = await client_as(manager).post("/learning/import-csv", files={"file": ("t.csv", content, "text/csv")})

    assert (r.json()["format"], r.json()["tracks_updated"]) == ("plataforma", 1)


async def test_cpf_fallback(db, client_as):
    company, manager, ana, email = await setup(db)
    await db.execute("UPDATE public.profiles SET cpf = '000.000.001-91' WHERE user_id = $1", ana)

    r = await client_as(manager).post(
        "/learning/import-csv", files=csv_file(line("outro@empresa.com", cpf="00000000191"))
    )

    assert (r.json()["tracks_updated"], r.json()["errors"]) == (1, [])
    assert len(await tracks(db, ana)) == 1


async def test_errors_per_line_do_not_stop_import(db, client_as):
    company, manager, ana, email = await setup(db)
    gone = await make_user(db, company, name="Saiu")
    gone_email = await db.fetchval("SELECT email FROM public.profiles WHERE user_id = $1", gone)
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", gone)

    r = await client_as(manager).post("/learning/import-csv", files=csv_file(
        line("ninguem@empresa.com"),
        line(gone_email),
        "1;;X;;;" + email + ";;G;99;T;A;ontem;;10;",
        line(email, track_id="200", track="Vendas"),
    ))

    body = r.json()
    assert body["tracks_updated"] == 1
    assert body["errors"][0] == "Linha 2: colaborador 'ninguem@empresa.com' não encontrado"
    assert body["errors"][1] == f"Linha 3: colaborador '{gone_email}' desligado"
    assert body["errors"][2].startswith("Linha 4:")
    assert [t["track_name"] for t in await tracks(db, ana)] == ["Vendas"]


async def test_old_format_still_works(db, client_as):
    company, manager, ana, email = await setup(db)
    content = f"email,titulo,area,horas,data\n{email},Excel,TI,2,2026-09-01\n".encode()

    r = await client_as(manager).post("/learning/import-csv", files={"file": ("c.csv", content, "text/csv")})

    assert (r.json()["format"], r.json()["inserted"], r.json()["errors"]) == ("padrao", 1, [])


async def test_team_and_my_tracks_show_only_in_progress(db, client_as):
    company, manager, ana, email = await setup(db)
    gone = await make_user(db, company, name="Saiu")
    gone_email = await db.fetchval("SELECT email FROM public.profiles WHERE user_id = $1", gone)
    c = client_as(manager)
    await c.post("/learning/import-csv", files=csv_file(
        line(email),
        line(email, track_id="300", track="Concluída", finished="2026-08-20 17:30:00", progress="100"),
        line(gone_email, track_id="400", track="Da que saiu"),
    ))
    await db.execute("UPDATE public.profiles SET deactivated_at = now() WHERE user_id = $1", gone)

    team = (await c.get("/learning/team-tracks")).json()
    assert [(t["user_name"], t["track_name"], t["progress_pct"]) for t in team] == [("Ana", "MARKETING", 6.0)]
    assert team[0]["imported_at"] and team[0]["courses"] == "Copywriting, Social Selling"
    full = (await c.get("/learning/team-tracks?include_inactive=true")).json()
    assert sorted(t["track_name"] for t in full) == ["Da que saiu", "MARKETING"]

    mine = (await client_as(ana).get("/learning/my-tracks")).json()
    assert [t["track_name"] for t in mine] == ["MARKETING"]
    assert (await client_as(ana).get("/learning/team-tracks")).status_code == 403


async def test_course_deleted_by_hr_does_not_come_back(db, client_as):
    company, manager, ana, email = await setup(db)
    c = client_as(manager)
    done = line(email, finished="2026-08-20 17:30:00", progress="100")
    await c.post("/learning/import-csv", files=csv_file(done))
    [course] = await courses(db, ana)

    assert (await c.delete(f"/learning/employee/course/{course['id']}")).status_code == 204
    r = await c.post("/learning/import-csv", files=csv_file(done))

    assert (r.json()["inserted"], r.json()["tracks_completed"]) == (0, 0)
    assert await courses(db, ana) == []
