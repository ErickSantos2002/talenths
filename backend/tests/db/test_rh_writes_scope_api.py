"""Escritas do RH só valem dentro da empresa dele, e aprovação só sobre o que está pendente."""
import uuid

from tests.db.conftest import make_company, make_department, make_user


async def make_absence(db, company, user, status="pending") -> str:
    type_id = await db.fetchval(
        "INSERT INTO public.hr_request_types (company_id, name) VALUES ($1, 'Folga') RETURNING id", company
    )
    return str(await db.fetchval(
        """INSERT INTO public.hr_requests (company_id, user_id, type_id, start_date, end_date, days, status)
           VALUES ($1, $2, $3, '2026-12-01', '2026-12-01', 1, $4) RETURNING id""",
        company, user, type_id, status,
    ))


async def test_aprovar_e_recusar_ausencia_de_outra_empresa_da_404(db, client_as):
    mine, other = await make_company(db), await make_company(db)
    hr = await make_user(db, mine, role="manager")
    stranger = await make_user(db, other)
    req = await make_absence(db, other, stranger)

    for verb in ("approve", "reject"):
        assert (await client_as(hr).put(f"/absences/{req}/{verb}", json={})).status_code == 404
    assert await db.fetchval("SELECT status FROM public.hr_requests WHERE id = $1", req) == "pending"


async def test_aprovar_o_que_ja_nao_esta_pendente_da_409(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    req = await make_absence(db, company, user, status="rejected")

    r = await client_as(hr).put(f"/absences/{req}/approve", json={})

    assert r.status_code == 409
    assert await db.fetchval("SELECT status FROM public.hr_requests WHERE id = $1", req) == "rejected"


async def test_aprovar_pendente_da_empresa_funciona(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    req = await make_absence(db, company, user)

    r = await client_as(hr).put(f"/absences/{req}/approve", json={"note": "ok"})

    assert r.status_code == 200
    assert r.json()["status"] == "approved"


async def make_feedback(db, company, author, target_type="all", dept=None, target=None) -> str:
    return str(await db.fetchval(
        """INSERT INTO public.feedback_requests
               (company_id, created_by, title, question, target_type, target_department_id, target_user_id)
           VALUES ($1, $2, 'Clima', 'Como está?', $3, $4, $5) RETURNING id""",
        company, author, target_type, dept, target,
    ))


async def test_responder_feedback_so_se_for_dirigido_a_pessoa(db, client_as):
    company, other = await make_company(db), await make_company(db)
    sales = await make_department(db, company, "Vendas")
    lab = await make_department(db, company, "Laboratório")
    hr = await make_user(db, company, role="manager")
    me = await make_user(db, company, department_id=sales)
    colleague = await make_user(db, company, department_id=sales)
    outsider_hr = await make_user(db, other, role="manager")
    client = client_as(me)

    allowed = [
        await make_feedback(db, company, hr),
        await make_feedback(db, company, hr, "department", dept=sales),
        await make_feedback(db, company, hr, "individual", target=me),
    ]
    denied = [
        await make_feedback(db, company, hr, "department", dept=lab),
        await make_feedback(db, company, hr, "individual", target=colleague),
        await make_feedback(db, other, outsider_hr),
        str(uuid.uuid4()),
    ]

    for fid in allowed:
        assert (await client.post(f"/feedbacks/{fid}/respond", json={"rating": 4})).status_code == 201, fid
    for fid in denied:
        assert (await client.post(f"/feedbacks/{fid}/respond", json={"rating": 4})).status_code == 404, fid


async def test_pdi_curso_e_onboarding_para_pessoa_de_outra_empresa_da_404(db, client_as):
    mine, other = await make_company(db), await make_company(db)
    hr = await make_user(db, mine, role="manager")
    stranger = await make_user(db, other)
    client = client_as(hr)

    r_pdi = await client.post("/pdi/plans", json={"user_id": stranger, "title": "Plano"})
    r_course = await client.post(f"/learning/employee/{stranger}", json={"course_title": "NR-10", "area": "Segurança"})
    r_onb = await client.post("/onboarding/assign", json={"user_id": stranger})

    assert (r_pdi.status_code, r_course.status_code, r_onb.status_code) == (404, 404, 404)
    assert await db.fetchval("SELECT count(*) FROM public.pdi_plans WHERE user_id = $1", stranger) == 0
    assert await db.fetchval("SELECT count(*) FROM public.employee_courses WHERE user_id = $1", stranger) == 0
    assert await db.fetchval("SELECT count(*) FROM public.onboarding_checklists WHERE user_id = $1", stranger) == 0


async def test_acao_em_plano_de_outra_empresa_da_404(db, client_as):
    mine, other = await make_company(db), await make_company(db)
    hr = await make_user(db, mine, role="manager")
    stranger = await make_user(db, other)
    plan = await db.fetchval(
        "INSERT INTO public.pdi_plans (company_id, user_id, title) VALUES ($1, $2, 'P') RETURNING id", other, stranger
    )

    r = await client_as(hr).post(f"/pdi/plans/{plan}/actions", json={"title": "Ação"})

    assert r.status_code == 404
    assert await db.fetchval("SELECT count(*) FROM public.pdi_actions WHERE plan_id = $1", plan) == 0


async def test_plano_de_pdi_com_prazo_nas_acoes(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    user = await make_user(db, company)

    r = await client_as(hr).post("/pdi/plans", json={
        "user_id": user, "title": "Plano",
        "actions": [{"title": "Curso", "due_date": "2026-12-15"}, {"title": "Mentoria"}],
    })

    assert r.status_code == 201
    assert [a["due_date"] for a in r.json()["actions"]] == ["2026-12-15", None]


async def test_plano_de_pdi_com_prazo_invalido_da_422(db, client_as):
    company = await make_company(db)
    hr = await make_user(db, company, role="manager")
    user = await make_user(db, company)

    r = await client_as(hr).post("/pdi/plans", json={
        "user_id": user, "title": "Plano", "actions": [{"title": "Curso", "due_date": "15/12/2026"}],
    })

    assert r.status_code == 422


async def test_onboarding_com_modelo_inexistente_da_404(db, client_as):
    company, other = await make_company(db), await make_company(db)
    hr = await make_user(db, company, role="manager")
    user = await make_user(db, company)
    foreign_template = await db.fetchval(
        "INSERT INTO public.onboarding_templates (company_id, name) VALUES ($1, 'Outro') RETURNING id", other
    )

    for template_id in (str(uuid.uuid4()), str(foreign_template), "nao-e-uuid"):
        r = await client_as(hr).post("/onboarding/assign", json={"user_id": user, "template_id": template_id})
        assert r.status_code == 404, template_id
    assert await db.fetchval("SELECT count(*) FROM public.onboarding_checklists WHERE user_id = $1", user) == 0
