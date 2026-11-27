"""GET /agente/capacidades e a tabela SO_RH presa aos 403 reais das rotas."""
import uuid

import pytest

from app.auth.agente import SO_RH, capacidades, todas_as_rotas_do_agente
from tests.db.conftest import make_company, make_department, make_user
from tests.db.test_guardi_agent_api import agente, email_of, emitir  # noqa: F401 (fixture)

ROLES = ("user", "manager", "master_admin")

# Corpo e query mínimos para a validação passar e a rota chegar à regra de papel.
BODIES = {
    ("POST", "/feedbacks"): {"title": "t", "question": "q", "target_type": "all"},
    ("PUT", "/goals/{goal_id}/actuals/{month}"): {"actual_value": 1},
    ("POST", "/feedbacks/{feedback_id}/respond"): {"rating": 3},
}
QUERY = {"cycle_id": str(uuid.uuid4()), "evaluated_user_id": str(uuid.uuid4()), "reference_id": str(uuid.uuid4())}


def _path(template: str) -> str:
    path = template.replace("{month}", "1")
    while "{" in path:
        start = path.index("{")
        path = path[:start] + str(uuid.uuid4()) + path[path.index("}") + 1:]
    return path


def test_so_rh_e_parte_do_allowlist():
    assert SO_RH <= set(todas_as_rotas_do_agente())


async def test_tabela_so_rh_bate_com_o_403_de_cada_rota(db, agente):
    company = await make_company(db)
    dept = await make_department(db, company, "Geral")
    tokens = {}
    for role in ROLES:
        uid = await make_user(db, company, dept, role=role)
        # Lançar batida exige ponto habilitado: a rota vale para todos "em algum caso".
        await db.execute("UPDATE public.profiles SET timeclock_enabled = true WHERE user_id = $1", uid)
        tokens[role] = emitir(sub=await email_of(db, uid))

    wrong = []
    for method, template in todas_as_rotas_do_agente():
        if template == "/goals/{goal_id}/comments" and method == "POST":
            kw = {"data": {"body": "x"}}
        elif method in ("GET", "DELETE"):
            kw = {}
        else:
            kw = {"json": BODIES.get((method, template), {})}
        for role in ROLES:
            # Savepoint: um 500 de uma rota não pode abortar a transação das próximas.
            tx = db.transaction()
            await tx.start()
            r = await agente(_path(template), tokens[role], method=method, params=QUERY, **kw)
            await tx.rollback()
            expected_403 = role == "user" and (method, template) in SO_RH
            if (r.status_code == 403) != expected_403:
                wrong.append((role, method, template, r.status_code))
    assert wrong == []


@pytest.mark.parametrize("role,papel", [("user", "Colaborador"), ("manager", "RH"), ("master_admin", "Administrador")])
async def test_capacidades_do_login(db, agente, role, papel):
    company = await make_company(db)
    uid = await make_user(db, company, role=role)

    r = await agente("/agente/capacidades", emitir(sub=await email_of(db, uid)))

    assert r.status_code == 200
    body = r.json()
    assert body["papel"] == papel
    rotas = {tuple(p) for p in body["rotas"]}
    assert ("GET", "/agente/capacidades") in rotas
    assert ("POST", "/absences/request") in rotas
    assert ("POST", "/requests/request") in rotas
    # Durante a transição do HS.OS as duas formas valem (spec 2026-11-27-solicitacoes).
    rh_pair = {("PUT", "/requests/{request_id}/approve"), ("PUT", "/absences/{request_id}/approve")}
    assert (rh_pair <= rotas) == (role != "user")
    assert not (rh_pair & rotas) or role != "user"
    if role == "user":
        assert rotas == set(todas_as_rotas_do_agente()) - SO_RH
    else:
        assert rotas == set(todas_as_rotas_do_agente())


async def test_capacidades_pelo_login_normal_da_404(db, client_as):
    company = await make_company(db)
    uid = await make_user(db, company)

    assert (await client_as(uid).get("/agente/capacidades")).status_code == 404


async def test_capacidades_sem_conta_da_401(db, agente):
    assert (await agente("/agente/capacidades", emitir(sub="ninguem@hs.com"))).status_code == 401


def test_varios_papeis_vale_o_maior():
    assert capacidades({"user", "manager"})["papel"] == "RH"
    assert capacidades(set())["papel"] == "Colaborador"
