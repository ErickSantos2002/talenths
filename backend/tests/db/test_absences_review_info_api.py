from tests.db.conftest import make_company, make_user


async def _type(db, company_id, requires_approval: bool) -> str:
    return str(await db.fetchval(
        "INSERT INTO public.hr_request_types (company_id, name, requires_approval) VALUES ($1, 'Tipo', $2) RETURNING id",
        company_id, requires_approval,
    ))


def _team_item(body, request_id):
    return next(r for r in body if r["id"] == request_id)


async def test_auto_approved_request_records_when_and_how(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, name="Welton")
    hr = await make_user(db, company, name="Gestora RH", role="manager")
    type_id = await _type(db, company, requires_approval=False)

    created = (await client_as(user).post("/absences/request", json={
        "type_id": type_id, "start_date": "2027-01-05", "start_time": "10:00", "end_time": "11:30",
        "reason": "Consulta médica de rotina",
    })).json()
    assert created["status"] == "approved"

    item = _team_item((await client_as(hr).get("/absences/team")).json(), created["id"])
    assert item["auto_approved"] is True
    assert item["reviewed_at"] == item["created_at"]
    assert item["reviewer_name"] is None


async def test_manual_approval_shows_reviewer_name(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, name="Ana")
    hr = await make_user(db, company, name="Gestora RH", role="manager")
    type_id = await _type(db, company, requires_approval=True)

    created = (await client_as(user).post("/absences/request", json={
        "type_id": type_id, "start_date": "2027-02-01", "end_date": "2027-02-03",
        "reason": "Viagem para resolver assuntos",
    })).json()
    assert created["status"] == "pending"
    assert created["auto_approved"] is False and created["reviewed_at"] is None

    await client_as(hr).put(f"/absences/{created['id']}/approve", json={"note": "ok"})

    item = _team_item((await client_as(hr).get("/absences/team")).json(), created["id"])
    assert item["auto_approved"] is False
    assert item["reviewer_name"] == "Gestora RH"
    assert item["reviewed_at"] is not None


async def test_report_csv_has_decision_columns(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company, name="Ana")
    hr = await make_user(db, company, name="Gestora RH", role="manager")
    auto_type = await _type(db, company, requires_approval=False)
    await client_as(user).post("/absences/request", json={
        "type_id": auto_type, "start_date": "2027-01-05", "end_date": "2027-01-05",
        "reason": "Consulta médica de rotina",
    })

    text = (await client_as(hr).get("/reports/absences")).content.decode("utf-8-sig")
    header, row = text.splitlines()[:2]
    assert "Decidido por" in header and "Decidido em" in header
    assert "Automática (sem análise)" in row
