"""Ausências: 3 tipos fixos, todos com aprovação, e motivo obrigatório (mín. 20 caracteres)."""
from pathlib import Path

from tests.db.conftest import make_company, make_user

MIGRATION_038 = Path(__file__).parents[2] / "migrations" / "038_absence_fixed_types.sql"
FIXED = {"Ida ao médico", "Saída pessoal", "Outro"}
REASON_OK = "Consulta de rotina marcada"  # 26 caracteres


async def _types(client):
    return (await client.get("/absences/types")).json()


async def test_empresa_nova_ganha_os_3_tipos_com_aprovacao(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    types = await _types(client_as(user))
    assert {t["name"] for t in types} == FIXED
    assert all(t["requires_approval"] for t in types)


async def test_rh_nao_cria_edita_nem_apaga_tipo(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    c = client_as(hr)
    type_id = (await _types(c))[0]["id"]
    assert (await c.post("/absences/types", json={"name": "Férias"})).status_code in (404, 405)
    assert (await c.put(f"/absences/types/{type_id}", json={"name": "X"})).status_code in (404, 405)
    assert (await c.delete(f"/absences/types/{type_id}")).status_code in (404, 405)
    assert {t["name"] for t in await _types(c)} == FIXED


async def _post(c, type_id, reason):
    body = {"type_id": type_id, "start_date": "2027-03-01", "start_time": "09:00", "end_time": "10:00"}
    if reason is not None:
        body["reason"] = reason
    return await c.post("/absences/request", json=body)


async def test_motivo_obrigatorio_com_20_caracteres(db, client_as):
    company = await make_company(db)
    user = await make_user(db, company)
    c = client_as(user)
    type_id = (await _types(c))[0]["id"]
    for reason in (None, "", " " * 30, "a" * 19, "   " + "a" * 19 + "   "):
        r = await _post(c, type_id, reason)
        assert r.status_code == 400, reason
        assert r.json()["detail"] == "O motivo precisa ter pelo menos 20 caracteres"
    assert await db.fetchval("SELECT count(*) FROM public.absence_requests WHERE user_id = $1", user) == 0

    r = await _post(c, type_id, "  " + "a" * 20 + "  ")
    assert r.status_code == 201
    assert r.json()["reason"] == "a" * 20
    assert r.json()["status"] == "pending"


async def test_migracao_038_converte_os_tipos_antigos(db):
    company = await make_company(db)
    user = await make_user(db, company)
    ids = {}
    for name, approval in (("Férias", True), ("Atestado Médico", False), ("Folga Compensatória", True),
                           ("Licença Médica", True), ("Licença Maternidade/Paternidade", False), ("Outro", False)):
        ids[name] = await db.fetchval(
            "INSERT INTO public.absence_types (company_id, name, requires_approval) VALUES ($1, $2, $3) RETURNING id",
            company, name, approval,
        )
    req = await db.fetchval(
        """INSERT INTO public.absence_requests (company_id, user_id, type_id, start_date, end_date, days,
               status, auto_approved, reviewed_at)
           VALUES ($1, $2, $3, '2027-01-05', '2027-01-05', 0, 'approved', true, now()) RETURNING id""",
        company, user, ids["Atestado Médico"],
    )

    await db.execute(MIGRATION_038.read_text())

    rows = await db.fetch("SELECT name, requires_approval FROM public.absence_types WHERE company_id = $1", company)
    assert {r["name"] for r in rows} == FIXED
    assert all(r["requires_approval"] for r in rows)
    kept = await db.fetchrow(
        "SELECT t.name, r.status, r.auto_approved FROM public.absence_requests r "
        "JOIN public.absence_types t ON t.id = r.type_id WHERE r.id = $1", req,
    )
    assert dict(kept) == {"name": "Ida ao médico", "status": "approved", "auto_approved": True}
