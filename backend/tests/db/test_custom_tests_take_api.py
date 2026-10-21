from pathlib import Path

import pytest

from tests.db.conftest import make_company, make_department, make_user

# As tabelas dos testes configuráveis só existem em produção e no banco das
# capturas (ver backend/scripts/captures-db.sh); aqui entram dentro da transação
# do teste e saem no rollback.
CUSTOM_TESTS_DDL = (
    Path(__file__).resolve().parents[2] / "supabase" / "migrations" / "20260520000002_custom_tests.sql"
)


@pytest.fixture(autouse=True)
async def custom_tests_schema(db):
    await db.execute("DROP TABLE public.test_responses")
    await db.execute(CUSTOM_TESTS_DDL.read_text())


async def _make_test(db, company_id, created_by, *, status="published", is_public=False):
    test_id = str(await db.fetchval(
        """INSERT INTO public.custom_tests
               (company_id, created_by, title, instructions, scoring_mode, is_public,
                time_limit_min, status, total_points)
           VALUES ($1, $2, 'Normas internas', 'Leia com atenção', 'auto', $3, 15, $4, 2)
           RETURNING id""",
        company_id, created_by, is_public, status,
    ))
    q1 = await db.fetchval(
        """INSERT INTO public.test_questions
               (test_id, order_index, question_type, text, explanation, points)
           VALUES ($1, 0, 'single_choice', 'Qual o horário de entrada?', 'É às 8h, ver regulamento', 1)
           RETURNING id""",
        test_id,
    )
    for i, (text, correct) in enumerate([("8h", True), ("9h", False), ("10h", False)]):
        await db.execute(
            """INSERT INTO public.test_question_options (question_id, order_index, text, is_correct, point_value)
               VALUES ($1, $2, $3, $4, $5)""",
            q1, i, text, correct, 1 if correct else 0,
        )
    q2 = await db.fetchval(
        """INSERT INTO public.test_questions
               (test_id, order_index, question_type, text, points, scale_min, scale_max, scale_labels)
           VALUES ($1, 1, 'scale', 'Quanto você conhece as normas?', 1, 1, 3,
                   '{"1": "Pouco", "3": "Muito"}'::jsonb)
           RETURNING id""",
        test_id,
    )
    for i in range(1, 4):
        await db.execute(
            """INSERT INTO public.test_question_options (question_id, order_index, text, point_value)
               VALUES ($1, $2, $3, $4)""",
            q2, i, str(i), i / 3,
        )
    return test_id


async def _assign(db, test_id, *, user_id=None, department_id=None):
    await db.execute(
        "INSERT INTO public.test_assignments (test_id, user_id, department_id) VALUES ($1, $2, $3)",
        test_id, user_id, department_id,
    )


async def _setup(db):
    company = await make_company(db)
    dept = await make_department(db, company, "Operações")
    manager = await make_user(db, company, name="Gestora", role="manager")
    user = await make_user(db, company, dept, name="Ana")
    return company, dept, manager, user


def _assert_no_answers(body):
    assert body["questions"], body
    for q in body["questions"]:
        assert "explanation" not in q
        for opt in q["options"]:
            assert set(opt) == {"id", "order_index", "text"}, opt


async def test_take_assigned_by_user_hides_answers(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager)
    await _assign(db, test_id, user_id=user)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["id"] == test_id
    assert body["title"] == "Normas internas"
    assert body["instructions"] == "Leia com atenção"
    assert body["time_limit_min"] == 15
    assert [q["question_type"] for q in body["questions"]] == ["single_choice", "scale"]
    assert [o["text"] for o in body["questions"][0]["options"]] == ["8h", "9h", "10h"]
    scale = body["questions"][1]
    assert (scale["scale_min"], scale["scale_max"]) == (1, 3)
    assert scale["scale_labels"] == {"1": "Pouco", "3": "Muito"}
    _assert_no_answers(body)


async def test_take_assigned_by_department(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager)
    await _assign(db, test_id, department_id=dept)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 200, r.text
    _assert_no_answers(r.json())


async def test_take_public_test(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager, is_public=True)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 200, r.text
    _assert_no_answers(r.json())


async def test_take_not_assigned_is_404(db, client_as):
    company, dept, manager, user = await _setup(db)
    other_dept = await make_department(db, company, "Vendas")
    test_id = await _make_test(db, company, manager)
    await _assign(db, test_id, department_id=other_dept)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 404, r.text
    assert r.json()["detail"] == "Teste não encontrado"


async def test_take_draft_is_404(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager, status="draft", is_public=True)
    await _assign(db, test_id, user_id=user)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 404, r.text
    assert r.json()["detail"] == "Teste não encontrado"


async def test_take_other_company_is_404(db, client_as):
    company, dept, manager, user = await _setup(db)
    other = await make_company(db)
    other_manager = await make_user(db, other, name="Outro gestor", role="manager")
    test_id = await _make_test(db, other, other_manager, is_public=True)

    r = await client_as(user).get(f"/tests/{test_id}/take")
    assert r.status_code == 404, r.text
    assert r.json()["detail"] == "Teste não encontrado"


async def test_start_assigned_creates_attempt(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager)
    await _assign(db, test_id, user_id=user)

    r = await client_as(user).post(f"/tests/{test_id}/start")
    assert r.status_code == 201, r.text
    assert r.json()["attempt_number"] == 1


async def test_start_without_access_is_404(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager)
    other = await make_company(db)
    other_manager = await make_user(db, other, name="Outro gestor", role="manager")
    other_test = await _make_test(db, other, other_manager, is_public=True)
    draft = await _make_test(db, company, manager, status="draft", is_public=True)

    c = client_as(user)
    for tid in (test_id, other_test, draft):
        r = await c.post(f"/tests/{tid}/start")
        assert r.status_code == 404, (tid, r.text)
    assert await db.fetchval("SELECT COUNT(*) FROM public.test_attempts") == 0


async def test_manager_still_gets_full_detail(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager)

    r = await client_as(manager).get(f"/tests/{test_id}")
    assert r.status_code == 200, r.text
    opts = r.json()["questions"][0]["options"]
    assert [o["is_correct"] for o in opts] == [True, False, False]

    assert (await client_as(user).get(f"/tests/{test_id}")).status_code == 403


async def _questions(db, test_id):
    rows = await db.fetch(
        "SELECT id FROM public.test_questions WHERE test_id = $1::uuid ORDER BY order_index", test_id
    )
    return [str(r["id"]) for r in rows]


async def _correct_option(db, question_id):
    return str(await db.fetchval(
        "SELECT id FROM public.test_question_options WHERE question_id = $1::uuid AND is_correct", question_id
    ))


async def test_my_attempt_hides_explanation_until_evaluated(db, client_as):
    company, dept, manager, user = await _setup(db)
    test_id = await _make_test(db, company, manager, is_public=True)
    c = client_as(user)
    attempt = (await c.post(f"/tests/{test_id}/start")).json()["id"]
    q1, _ = await _questions(db, test_id)
    r = await c.post(f"/tests/attempts/{attempt}/respond",
                     json={"responses": [{"question_id": q1, "selected_option_ids": []}]})
    assert r.status_code == 200, r.text

    r = await c.get(f"/tests/my-attempts/{attempt}")
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "in_progress"
    assert all("explanation" not in resp for resp in r.json()["responses"]), r.json()
    assert all("options" not in resp for resp in r.json()["responses"])

    assert (await c.post(f"/tests/attempts/{attempt}/submit")).status_code == 200
    r = await c.get(f"/tests/my-attempts/{attempt}")
    assert r.json()["status"] == "evaluated"
    assert r.json()["responses"][0]["explanation"] == "É às 8h, ver regulamento"


async def test_respond_rejects_question_of_another_test(db, client_as):
    company, dept, manager, user = await _setup(db)
    target = await _make_test(db, company, manager)  # não atribuído ao usuário
    probe = await _make_test(db, company, manager, is_public=True)
    c = client_as(user)
    attempt = (await c.post(f"/tests/{probe}/start")).json()["id"]
    probe_q1, _ = await _questions(db, probe)
    target_q1, _ = await _questions(db, target)
    guess = await _correct_option(db, target_q1)

    r = await c.post(f"/tests/attempts/{attempt}/respond", json={"responses": [
        {"question_id": probe_q1, "selected_option_ids": []},
        {"question_id": target_q1, "selected_option_ids": [guess]},
    ]})
    assert r.status_code == 422, r.text
    assert await db.fetchval(
        "SELECT COUNT(*) FROM public.test_responses WHERE attempt_id = $1::uuid", attempt
    ) == 0

    r = await c.post(f"/tests/attempts/{attempt}/respond",
                     json={"responses": [{"question_id": "não-é-uuid", "text_response": "x"}]})
    assert r.status_code == 422, r.text
