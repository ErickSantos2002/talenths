from tests.db.conftest import make_company, make_user


async def _setup(db):
    company = await make_company(db)
    manager = await make_user(db, company, name="Gestora", role="manager")
    owner = await make_user(db, company, name="Ana")
    colleague = await make_user(db, company, name="Bruno")
    other_company = await make_company(db)
    other_manager = await make_user(db, other_company, name="Gestor de fora", role="manager")
    return company, manager, owner, colleague, other_manager


# ── PDI ───────────────────────────────────────────────────────────────────────

async def _make_action(db, company_id, owner, manager) -> str:
    plan_id = await db.fetchval(
        """INSERT INTO public.pdi_plans (company_id, user_id, title, created_by)
           VALUES ($1, $2, 'Plano', $3) RETURNING id""",
        company_id, owner, manager,
    )
    return str(await db.fetchval(
        "INSERT INTO public.pdi_actions (plan_id, title) VALUES ($1, 'Curso de Excel') RETURNING id",
        plan_id,
    ))


async def _action_status(db, action_id) -> str:
    return await db.fetchval("SELECT status FROM public.pdi_actions WHERE id = $1::uuid", action_id)


async def test_pdi_owner_updates_own_action_status(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    action = await _make_action(db, company, owner, manager)

    r = await client_as(owner).put(f"/pdi/actions/{action}", json={"status": "done"})
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "done"
    assert r.json()["completed_at"] is not None


async def test_pdi_other_collaborator_gets_404(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    action = await _make_action(db, company, owner, manager)

    r = await client_as(colleague).put(f"/pdi/actions/{action}", json={"status": "done"})
    assert r.status_code == 404, r.text
    assert await _action_status(db, action) == "pending"


async def test_pdi_manager_same_company_edits_action(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    action = await _make_action(db, company, owner, manager)

    r = await client_as(manager).put(
        f"/pdi/actions/{action}",
        json={"title": "Curso de Excel avançado", "status": "in_progress", "due_date": "2026-12-01"},
    )
    assert r.status_code == 200, r.text
    assert r.json()["title"] == "Curso de Excel avançado"
    assert r.json()["status"] == "in_progress"


async def test_pdi_manager_other_company_gets_404(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    action = await _make_action(db, company, owner, manager)

    r = await client_as(other_manager).put(f"/pdi/actions/{action}", json={"status": "done"})
    assert r.status_code == 404, r.text
    assert await _action_status(db, action) == "pending"


# ── Onboarding ────────────────────────────────────────────────────────────────

async def _make_tasks(db, company_id, owner, manager) -> tuple[str, str]:
    checklist_id = await db.fetchval(
        """INSERT INTO public.onboarding_checklists (company_id, user_id, created_by)
           VALUES ($1, $2, $3) RETURNING id""",
        company_id, owner, manager,
    )
    user_task = str(await db.fetchval(
        """INSERT INTO public.onboarding_checklist_tasks (checklist_id, title, responsible_role, position)
           VALUES ($1, 'Ler o manual', 'user', 0) RETURNING id""",
        checklist_id,
    ))
    hr_task = str(await db.fetchval(
        """INSERT INTO public.onboarding_checklist_tasks (checklist_id, title, responsible_role, position)
           VALUES ($1, 'Entregar o crachá', 'manager', 1) RETURNING id""",
        checklist_id,
    ))
    return user_task, hr_task


async def _completed(db, task_id) -> bool:
    return await db.fetchval(
        "SELECT completed_at IS NOT NULL FROM public.onboarding_checklist_tasks WHERE id = $1::uuid", task_id
    )


async def test_onboarding_owner_toggles_own_task(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    user_task, hr_task = await _make_tasks(db, company, owner, manager)
    c = client_as(owner)

    r = await c.put(f"/onboarding/checklist-tasks/{user_task}/complete")
    assert r.status_code == 200, r.text
    assert r.json()["completed_at"] is not None
    assert r.json()["completed_by"] == owner

    r = await c.put(f"/onboarding/checklist-tasks/{user_task}/complete")
    assert r.status_code == 200, r.text
    assert r.json()["completed_at"] is None


async def test_onboarding_owner_cannot_toggle_hr_task(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    user_task, hr_task = await _make_tasks(db, company, owner, manager)

    r = await client_as(owner).put(f"/onboarding/checklist-tasks/{hr_task}/complete")
    assert r.status_code == 403, r.text
    assert not await _completed(db, hr_task)


async def test_onboarding_other_collaborator_gets_404(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    user_task, hr_task = await _make_tasks(db, company, owner, manager)
    c = client_as(colleague)

    for task in (user_task, hr_task):
        r = await c.put(f"/onboarding/checklist-tasks/{task}/complete")
        assert r.status_code == 404, r.text
        assert not await _completed(db, task)


async def test_onboarding_manager_same_company_toggles_any_task(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    user_task, hr_task = await _make_tasks(db, company, owner, manager)
    c = client_as(manager)

    for task in (user_task, hr_task):
        r = await c.put(f"/onboarding/checklist-tasks/{task}/complete")
        assert r.status_code == 200, r.text
        assert r.json()["completed_by"] == manager


async def test_onboarding_manager_other_company_gets_404(db, client_as):
    company, manager, owner, colleague, other_manager = await _setup(db)
    user_task, hr_task = await _make_tasks(db, company, owner, manager)
    c = client_as(other_manager)

    for task in (user_task, hr_task):
        r = await c.put(f"/onboarding/checklist-tasks/{task}/complete")
        assert r.status_code == 404, r.text
        assert not await _completed(db, task)
