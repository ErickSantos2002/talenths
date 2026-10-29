# Desligamento de Colaboradores — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** RH (manager/master_admin) desliga e reativa colaboradores; desligado perde o acesso, sai da "equipe atual" e não vira alvo de nada novo, sem perder histórico.

**Architecture:** Uma coluna de filtro (`profiles.deactivated_at`) + tabela `collaborator_terminations` (migração 032). Os fragmentos SQL e a checagem de alvo ficam num módulo só (`backend/app/roster.py`); cada rota "equipe atual" usa o fragmento, e as telas de histórico recebem `include_inactive`. Acesso bloqueado no login (senha e Microsoft) e por requisição no `get_db`.

**Tech Stack:** FastAPI + asyncpg, pytest (asyncio, banco real via `TEST_DATABASE_URL`), React 18 + TS + shadcn/ui, Vitest.

**Spec:** `docs/superpowers/specs/2026-10-29-desligamento-colaboradores-design.md`

## Global Constraints

- Migração nova `backend/migrations/032_collaborator_deactivation.sql`; **nunca editar 001–031**.
- Ativo = `profiles.deactivated_at IS NULL`. Nenhum outro critério.
- Filtro de ativos **no backend**; o frontend só passa `status`/`include_inactive`.
- Motivos (valor → rótulo): `resignation` Pedido de demissão · `dismissal_without_cause` Demissão sem justa causa · `dismissal_with_cause` Demissão por justa causa · `contract_end` Fim de contrato ou de experiência · `mutual_agreement` Acordo entre as partes · `other` Outro.
- Observação obrigatória só com `other`; data do desligamento ≤ hoje.
- Mensagens fixas: login de desligado → 403 `"Seu acesso foi desativado. Procure o RH."`; token de desligado → 401 `"Acesso desativado"`; alvo desligado → 422 `"Colaborador desligado"`.
- Etiqueta na UI: **Desligado(a)**; controle: **Mostrar desligados** (`Switch`).
- UI em pt-BR, código em inglês; comentários só para o porquê.
- Versão **v1.14.0** nos 3 lugares do changelog, data 29/10/2026 (ou a do dia da entrega).
- Testes de banco num banco próprio desta frente: `TEST_DB_NAME=talenths_test_deslig bash backend/scripts/test-db.sh` e `export TEST_DATABASE_URL=postgresql://erick:dev123@localhost:5432/talenths_test_deslig` (pode haver sessão irmã usando `talenths_test`). Rodar a partir de `backend/` com `.venv/bin/pytest`.

## Review Focus

1. **Gerente tentando desligar Administrador, ou alguém desligando a si mesmo** → 403/400 e nada muda (Task 2).
2. **Token emitido antes do desligamento** usado depois → 401, inclusive `/auth/me` (Task 3).
3. **Desligar duas vezes / reativar quem está ativo** → 409, sem registro duplicado (Task 2; índice único da Task 1).
4. **Reativar e desligar de novo** → segundo registro em `collaborator_terminations`, o primeiro intacto (Task 2).
5. **Import CSV da Universidade com uma linha de desligado** → as demais linhas entram e a linha vira aviso (Task 6).

---

### Task 1: Migração 032 e script de aplicação

**Files:**
- Create: `backend/migrations/032_collaborator_deactivation.sql`
- Create: `backend/scripts/aplicar_032.py`
- Test: `backend/tests/db/test_032_deactivation.py`

**Interfaces:**
- Produces: `profiles.deactivated_at timestamptz`; tabela `collaborator_terminations` exatamente como no spec (com `ON DELETE SET NULL` em `deactivated_by`/`reactivated_by`, índice único parcial `uq_collaborator_terminations_open`, `CHECK` de `other`); `internal_video_apply_rules` e `internal_videos_on_profile_change` recriadas ignorando `p.deactivated_at IS NOT NULL`; trigger `trg_profiles_internal_videos` recriado como `AFTER INSERT OR UPDATE OF company_id, department_id, deactivated_at`, e a função só segue no UPDATE se empresa/departamento mudaram **ou** `OLD.deactivated_at IS NOT NULL AND NEW.deactivated_at IS NULL`; se `NEW.deactivated_at IS NOT NULL` retorna sem atribuir.

- [ ] **Step 1: Recriar o banco de teste desta frente** — `TEST_DB_NAME=talenths_test_deslig bash backend/scripts/test-db.sh` (ainda sem a 032). Esperado: termina com a linha `export TEST_DATABASE_URL=...`.

- [ ] **Step 2: Escrever os testes que falham** (usar `make_company`, `make_department`, `make_user` do conftest)

```python
async def test_reason_other_requires_note(db): ...        # INSERT reason='other', note=' ' -> asyncpg.CheckViolationError
async def test_only_one_open_termination(db): ...         # 2º INSERT sem reactivated_at -> UniqueViolationError
async def test_deleting_actor_keeps_record(db): ...       # DELETE auth.users do ator -> deactivated_by IS NULL, linha existe
async def test_apply_rules_skips_deactivated(db): ...     # vídeo regra 'all'; perfil com deactivated_at=now(); apply_rules -> sem viewer para ele
async def test_profile_change_skips_deactivated(db): ...  # desligado muda de departamento com regra 'department' -> sem viewer
async def test_reactivation_assigns_missed_videos(db): ...# desligado; vídeo 'all' criado+regras aplicadas; UPDATE deactivated_at=NULL -> viewer criado + 1 notificação 'video'
```

- [ ] **Step 3: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_032_deactivation.py -v`. Esperado: FAIL (coluna/tabela inexistente).

- [ ] **Step 4: Escrever a 032** conforme Interfaces; funções via `CREATE OR REPLACE`, trigger via `DROP TRIGGER IF EXISTS` + `CREATE TRIGGER`. Comentário curto no topo, no estilo da 031.

- [ ] **Step 5: Recriar o banco e rodar** — repetir o Step 1 (agora aplica a 032) e `.venv/bin/pytest tests/db/test_032_deactivation.py tests/db/test_029_internal_videos.py -v`. Esperado: PASS em tudo.

- [ ] **Step 6: `aplicar_032.py`** no molde do `aplicar_031.py`: recusa se `profiles.deactivated_at` já existe; aplica numa transação; confere coluna, tabela, índice `uq_collaborator_terminations_open` e que o trigger `trg_profiles_internal_videos` inclui `deactivated_at` (`pg_get_triggerdef`); imprime "Migração 032 aplicada" e o total de perfis (todos ativos). Testar: `~/projetos/bancos/.venv/bin/python backend/scripts/aplicar_032.py --dsn postgresql://erick:dev123@localhost:5432/talenths_test_deslig` num banco recriado **sem** a 032 (mover a 032 temporariamente não vale — usar `psql -d talenths_test_deslig` para `DROP` dos objetos da 032 antes, ou criar outro banco com `TEST_DB_NAME`). Esperado: sucesso na 1ª, recusa na 2ª.

- [ ] **Step 7: Commit** — `feat(colaboradores): migração 032 do desligamento`.

---

### Task 2: Módulo de equipe ativa e endpoints de desligar/reativar

**Files:**
- Create: `backend/app/roster.py`
- Modify: `backend/app/routers/collaborators.py` (list, novos endpoints)
- Test: `backend/tests/db/test_collaborators_deactivation_api.py`

**Interfaces:**
- Produces (em `app/roster.py`):
  - `TERMINATION_REASONS: tuple[str, ...]` (os 6 valores).
  - `def active_only(alias: str = "p") -> str` → `"{alias}.deactivated_at IS NULL"`.
  - `def active_unless(alias: str, param: int) -> str` → `"({alias}.deactivated_at IS NULL OR ${param}::boolean)"`.
  - `async def ensure_active_targets(conn, user_ids: Iterable[str]) -> None` → 422 `"Colaborador desligado"` se algum `user_id` tem perfil desligado; ids inexistentes são ignorados (cada rota mantém sua validação atual).
- Produces (HTTP):
  - `GET /collaborators?status=active|inactive|all` (padrão `active`; `company_id` opcional, sem ele = empresa de quem chama). Cada item: perfil + `roles` + `termination: {termination_date, reason, note} | null` (o registro em aberto).
  - `POST /collaborators/{profile_id}/deactivate` body `{termination_date: date, reason: str, note?: str}` → 204.
  - `POST /collaborators/{profile_id}/reactivate` → 204.

- [ ] **Step 1: Testes que falham**

```python
async def test_manager_deactivates_user(db, client_as):        # 204; profiles.deactivated_at not null; 1 termination com reason/date/note/deactivated_by=manager
async def test_deactivate_closes_open_benefits(db, client_as): # employee_benefits end_date NULL e end_date futuro -> = termination_date; end_date passado intacto
async def test_manager_cannot_deactivate_master_admin(db, client_as): # 403; nada muda
async def test_master_admin_deactivates_master_admin(db, client_as):  # 204
async def test_cannot_deactivate_self(db, client_as):          # 400
async def test_deactivate_twice_is_409(db, client_as):
async def test_future_date_is_422(db, client_as):
async def test_other_without_note_is_422(db, client_as):
async def test_other_company_profile_is_404(db, client_as):
async def test_reactivate_and_deactivate_again(db, client_as): # reactivate 204 -> deactivated_at NULL, termination.reactivated_at/by preenchidos; novo deactivate -> 2 linhas
async def test_reactivate_active_is_409(db, client_as):
async def test_list_by_status(db, client_as):                  # 1 ativo + 1 desligado: padrão só ativo; inactive só desligado com termination preenchido; all os dois
async def test_list_scoped_to_caller_company(db, client_as):   # perfil de outra empresa não aparece sem company_id
async def test_ensure_active_targets(db):                      # desligado -> HTTPException 422; ativos e id inexistente -> ok
```

- [ ] **Step 2: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_collaborators_deactivation_api.py -v`. Esperado: FAIL (404/422 de rota inexistente).

- [ ] **Step 3: Implementar `roster.py` e os endpoints.** Regra de papel: o papel do alvo vem de `user_roles`; se o alvo é `master_admin`, exigir `require_master_admin`; senão `require_manager`. Self → 400 `"Você não pode desligar a si mesmo"`. Data futura e `other` sem observação → 422 (validar no Pydantic com `Literal` para `reason` e um `model_validator`). Desligar numa transação: INSERT termination, UPDATE profile, `UPDATE employee_benefits SET end_date = $date WHERE user_id = $uid AND (end_date IS NULL OR end_date > $date)` (conferir a coluna de pessoa em `migrations/` do benefício). Reativar segue a mesma regra de papel e de self.

- [ ] **Step 4: Rodar** — mesmo comando + `tests/db/test_collaborators_create_api.py`. Esperado: PASS.

- [ ] **Step 5: Commit** — `feat(colaboradores): desligar e reativar pela API`.

---

### Task 3: Bloqueio de acesso do desligado

**Files:**
- Modify: `backend/app/dependencies.py` (`get_db`), `backend/app/auth/router.py` (login, microsoft callback), `backend/app/auth/service.py`, `backend/app/routers/videos.py` (stream por token ~764)
- Modify: `frontend/src/pages/AuthCallback.tsx` (mensagem `account_deactivated`)
- Test: `backend/tests/db/test_auth_deactivated.py`

**Interfaces:**
- Produces: `async def ensure_active_user(conn, user_id: str) -> None` em `dependencies.py` (401 `"Acesso desativado"`; usuário sem perfil passa). `get_db` chama depois do `set_config`. `async def is_deactivated(conn, user_id: str) -> bool` em `auth/service.py`.
- Microsoft callback: desligado → redirect `.../auth/callback?error=account_deactivated`; `AuthCallback.tsx` mapeia para `"Seu acesso foi desativado. Procure o RH."`.

- [ ] **Step 1: Testes que falham**

```python
async def test_ensure_active_user_rejects_deactivated(db):   # HTTPException 401 "Acesso desativado"
async def test_ensure_active_user_allows_active(db):
async def test_login_deactivated_is_403_after_password(db, client_as): # senha certa -> 403 com a mensagem; senha errada -> 401 "Email ou senha incorretos"
async def test_stream_token_of_deactivated_is_rejected(db, client_as, sample_mp4): # token emitido, depois desliga -> GET /videos/stream/{token} 403/404 (seguir o código de "sem acesso" que a rota já usa)
```
O login usa `get_pool()`; se o teste não conseguir injetar a conexão, extrair a decisão para `is_deactivated` e testar a função + um teste do router com `monkeypatch` em `get_pool`.

- [ ] **Step 2: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_auth_deactivated.py -v`.

- [ ] **Step 3: Implementar.** Uma consulta por requisição: `SELECT deactivated_at FROM public.profiles WHERE user_id = $1`.

- [ ] **Step 4: Rodar a suíte inteira de banco** — `.venv/bin/pytest -q`. Esperado: PASS (o `client_as` sobrescreve `get_db`, então os outros testes não mudam).

- [ ] **Step 5: Commit** — `feat(auth): desligado não entra e perde a sessão`.

---

### Task 4: "Equipe atual" sem desligados

**Files (Modify):** `routers/profiles.py` (GET /profiles), `routers/communications.py` (birthdays, milestones), `routers/calendar.py` (aniversários; ausências futuras de desligados), `routers/salary.py` (positioning), `routers/tour.py` (adoption), `routers/reports.py` (collaborators CSV), `routers/evaluations.py` (consolidate), `routers/custom_tests.py` (notificação no submit; `GET /{test_id}/stats`), `routers/videos.py` (`GET /admin` contagens), `routers/benefits.py` (`GET /summary`), `routers/onboarding.py` e `routers/workshops.py` (contagens de progresso/inscritos, se existirem como agregados)
- Test: `backend/tests/db/test_roster_active_filter.py`

**Interfaces:**
- Consumes: `active_only`, `active_unless` (Task 2).
- Produces: `GET /reports/collaborators?include_inactive=true` acrescenta colunas `Situação` (`Ativo`/`Desligado(a)`), `Data do desligamento` (DD/MM/AAAA), `Motivo` (rótulo pt-BR).

- [ ] **Step 1: Testes que falham** — um por rota, padrão: empresa com 1 ativo e 1 desligado (`UPDATE profiles SET deactivated_at = now()`), chamar como manager, conferir que o desligado não aparece/não conta.

```python
async def test_profiles_list_excludes_deactivated(...)
async def test_birthdays_and_milestones_exclude_deactivated(...)
async def test_calendar_birthdays_exclude_deactivated(...)
async def test_salary_positioning_excludes_deactivated(...)
async def test_tour_adoption_denominator_excludes_deactivated(...)
async def test_reports_collaborators_default_and_include_inactive(...)  # padrão sem desligado; include_inactive tem as 3 colunas e "Desligado(a)"
async def test_consolidate_skips_deactivated(...)                       # sem consolidated_scores novo para o desligado
async def test_test_submit_does_not_notify_deactivated_manager(...)
async def test_video_admin_counts_exclude_deactivated(...)              # required_count/completed_count
async def test_benefits_summary_excludes_deactivated(...)
```

- [ ] **Step 2: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_roster_active_filter.py -v`.
- [ ] **Step 3: Aplicar `active_only(...)` em cada consulta** (no JOIN com `profiles`; onde a consulta não junta `profiles`, juntar).
- [ ] **Step 4: Rodar** — `.venv/bin/pytest -q`. Esperado: PASS.
- [ ] **Step 5: Commit** — `feat(colaboradores): desligado sai da equipe atual`.

---

### Task 5: Telas de histórico com `include_inactive`

**Files (Modify):** `routers/pdi.py` (`GET /team`), `routers/onboarding.py` (`GET /team`), `routers/learning.py` (`GET /team`), `routers/timeclock.py` (`GET /team`, visão do dia), `routers/evaluations.py` (`GET /team-status`, `GET /9box`), `routers/career.py` (`GET /team`), `routers/videos.py` (`GET /{video_id}/admin`), `routers/custom_tests.py` (`GET /{test_id}/attempts`, `GET /{test_id}/assignments`)
- Test: `backend/tests/db/test_team_views_include_inactive.py`

**Interfaces:**
- Consumes: `active_unless` (Task 2).
- Produces: cada rota aceita `include_inactive: bool = False` e devolve `deactivated_at` (ISO ou `null`) em cada item de pessoa. No `GET /videos/{id}/admin`, desligados ficam fora de `required`/`voluntary` por padrão (o grupo `former` — perfis excluídos — não muda).

- [ ] **Step 1: Testes que falham** — um por rota: padrão sem o desligado; `?include_inactive=true` com ele e `deactivated_at` preenchido.
- [ ] **Step 2: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_team_views_include_inactive.py -v`.
- [ ] **Step 3: Implementar** com `active_unless("p", n)`.
- [ ] **Step 4: Rodar** — `.venv/bin/pytest -q`. Esperado: PASS.
- [ ] **Step 5: Commit** — `feat(colaboradores): mostrar desligados nas telas de equipe`.

---

### Task 6: Desligado não vira alvo

**Files (Modify):** `routers/pdi.py` (`POST /plans`), `routers/onboarding.py` (`POST /assign`), `routers/learning.py` (`POST /employee/{id}`, `POST /import-csv`), `routers/custom_tests.py` (`POST /{test_id}/assignments`), `routers/videos.py` (alvos `user` em upload/regras ~320), `routers/bingo.py` (`POST /games`), `routers/timeclock.py` (`POST /manual`), `routers/goals.py` (`responsible_user_id` no create/update)
- Test: `backend/tests/db/test_deactivated_targets.py`

**Interfaces:**
- Consumes: `ensure_active_targets` (Task 2).
- Produces: `POST /learning/import-csv` devolve, além do que já devolve, as linhas de desligados em `warnings` (lista de strings `"<email>: colaborador desligado"`) sem abortar o arquivo.

- [ ] **Step 1: Testes que falham** — um por rota: alvo desligado → 422 `"Colaborador desligado"` e nada gravado; import CSV com 1 ativo + 1 desligado → ativo importado, aviso para o desligado.
- [ ] **Step 2: Rodar e ver falhar** — `.venv/bin/pytest tests/db/test_deactivated_targets.py -v`.
- [ ] **Step 3: Chamar `ensure_active_targets` antes de gravar** em cada rota.
- [ ] **Step 4: Rodar** — `.venv/bin/pytest -q`. Esperado: PASS.
- [ ] **Step 5: Commit** — `feat(colaboradores): desligado não recebe atribuições`.

---

### Task 7: Gestão de Colaboradores — desligar, reativar, filtro

**Files:**
- Create: `frontend/src/lib/termination.ts`, `frontend/src/lib/termination.test.ts`, `frontend/src/components/InactiveBadge.tsx`, `frontend/src/components/collaborators/DeactivateCollaboratorDialog.tsx`
- Modify: `frontend/src/lib/api.ts` (collaborators), `frontend/src/pages/AdminCollaboratorsPage.tsx`

**Interfaces:**
- Produces:
  - `termination.ts`: `type TerminationReason`, `TERMINATION_REASONS: { value: TerminationReason; label: string }[]` (rótulos do Global Constraints), `reasonLabel(value: string): string`, `canManageStatus(actorRoles: AppRole[], targetRoles: AppRole[], isSelf: boolean): boolean`.
  - `InactiveBadge({ since?: string })` → `Badge` "Desligado(a)" e, com `since`, "Desligado(a) em DD/MM/AAAA".
  - `api.ts`: `type CollaboratorStatus = "active" | "inactive" | "all"`; `collaborators.list(companyId?: string, status: CollaboratorStatus = "active")`; `collaborators.deactivate(profileId: string, body: { termination_date: string; reason: TerminationReason; note?: string })`; `collaborators.reactivate(profileId: string)`.

- [ ] **Step 1: Teste Vitest que falha** (`termination.test.ts`): `canManageStatus(["manager"], ["user"], false) === true`; `(["manager"], ["manager"], false) === true`; `(["manager"], ["master_admin"], false) === false`; `(["master_admin"], ["master_admin"], false) === true`; `(…, true) === false` para qualquer papel; `reasonLabel("contract_end") === "Fim de contrato ou de experiência"`.
- [ ] **Step 2: Rodar e ver falhar** — `bun run --cwd frontend test src/lib/termination.test.ts`.
- [ ] **Step 3: Implementar** `termination.ts`, `InactiveBadge`, as funções do `api.ts` e o diálogo (Data — `type="date"` com `max` = hoje, padrão hoje; Motivo — `Select`; Observação — `Textarea`, obrigatória se `other`; botão **Desligar colaborador**; frase: "A pessoa perde o acesso na hora e sai das listas e contagens. O histórico fica guardado e você pode reativar depois.").
- [ ] **Step 4: Página.** Carregar com `status="all"`; seletor **Ativos / Desligados / Todos** (padrão Ativos) filtrando por `deactivated_at`; contagem de pessoas por departamento só com ativos; ação **Desligar** (`UserX`) quando `canManageStatus`; em desligados: `InactiveBadge since`, motivo em linha secundária, **Reativar** (`UserCheck`) com `AlertDialog`, sem editar/redefinir senha; Excluir continua só para admin. Se o cabeçalho com `data-tour` mudar, ajustar o passo do tour.
- [ ] **Step 5: Verificar** — `bun run --cwd frontend test` e `bun run --cwd frontend lint` sem erros novos; subir backend+frontend e desligar/reativar um perfil no banco de teste (skill `run`).
- [ ] **Step 6: Commit** — `feat(colaboradores): tela de desligar e reativar`.

---

### Task 8: "Mostrar desligados" nas telas de equipe

**Files (Modify):** `frontend/src/lib/api.ts` (parâmetro `includeInactive?: boolean` nas funções de `pdi.team`, `onboarding.team`, `learning.team`, `timeclock.team`, `evaluations.teamStatus`, `evaluations.nineBox`, `career.team`, `videos.adminDetail`, `customTests.attempts`/`assignments` — usar os nomes reais do arquivo), páginas `PdiTeamPage.tsx`, `OnboardingAdminPage.tsx`, página da Universidade admin, `AdminTimeclockPage.tsx` (visão do dia e seletor da aba por pessoa via `collaborators.list(undefined, show ? "all" : "active")`), `BenefitsAdminPage.tsx` (aba Colaboradores, idem), páginas de Avaliação, 9-Box, Trilhas, detalhe de vídeo, tentativas de teste.

**Interfaces:**
- Consumes: `InactiveBadge` (Task 7), `include_inactive` (Task 5).

- [ ] **Step 1: Em cada tela**, `Switch` **Mostrar desligados** junto aos filtros existentes (estado local, padrão desligado), refazendo a consulta; itens com `deactivated_at` ganham `InactiveBadge`.
- [ ] **Step 2: Seletores de alvo** (bingo, público de vídeo, responsável de meta, atribuição de teste, onboarding, PDI novo, feedbacks, documentos) continuam com `collaborators.list()` padrão — conferir que nenhum passou a mostrar desligados.
- [ ] **Step 3: Verificar** — `bun run --cwd frontend test`, `lint`, e olhar cada tela com o desligado do banco de teste ligando/desligando o switch.
- [ ] **Step 4: Commit** — `feat(colaboradores): mostrar desligados nas telas de gestão`.

---

### Task 9: Guias, capturas e changelog

**Files (Modify):** `frontend/src/help/guides/administracao/colaboradores.md` (+ uma frase sobre **Mostrar desligados** em `pdi-da-equipe`, `onboarding`, `universidade`, `ponto-eletronico`, `beneficios`, `avaliacao`, `mapa-9box`, `trilha-de-carreira`, `videos`, `testes`), `backend/scripts/seed_captures.py` (um desligado fictício com histórico de PDI/ponto), `frontend/src/components/ChangelogModal.tsx`, `frontend/src/components/AdminSidebar.tsx`, `frontend/package.json`, capturas em `frontend/public/capturas/`.

- [ ] **Step 1: Guia de Colaboradores** — seções **Para desligar uma pessoa** e **Para reativar uma pessoa**; em "O que acontece depois", o efeito de desligar (perde o acesso, sai das listas e contagens, benefícios em aberto encerrados na data, histórico guardado); em "Dúvidas comuns", **Desligar ou excluir?** (excluir apaga tudo e é só do Administrador). Rodar `grep -rn "Atenção:" frontend/src/help/guides` e ajustar se algum aviso tratar disso.
- [ ] **Step 2: Frase nos demais guias** sobre **Mostrar desligados**.
- [ ] **Step 3: Semente** com 1 desligado ("Carlos Exemplo", motivo `contract_end`), e capturas: `bash backend/scripts/captures-db.sh`, subir backend 8021/frontend 8091 conforme CLAUDE.md, `bun run --cwd frontend capturas -- --only admin-colaboradores` (e as telas cuja captura mostre o switch). **Abrir e olhar** cada imagem.
- [ ] **Step 4: Changelog v1.14.0** (3 lugares; remover `current` da 1.13.0). Entradas: novidade — "O RH agora pode desligar colaboradores que saíram da empresa, registrando a data e o motivo. Quem foi desligado perde o acesso e deixa de aparecer nas listas e contagens, mas todo o histórico continua guardado."; novidade — "As telas de gestão ganharam a opção Mostrar desligados, para consultar o histórico de quem saiu."; melhoria — "Colaboradores desligados podem ser reativados, por exemplo numa recontratação."
- [ ] **Step 5: Verificar** — `bun run --cwd frontend test` (contratos de ajuda e capturas) e `bun run --cwd frontend build`.
- [ ] **Step 6: Commit** — `docs(ajuda): desligamento de colaboradores, versão 1.14.0`.

---

### Task 10: Verificação final

- [ ] **Step 1:** `TEST_DB_NAME=talenths_test_deslig bash backend/scripts/test-db.sh` e `.venv/bin/pytest -q` (backend) → tudo PASS.
- [ ] **Step 2:** `bun run --cwd frontend test`, `lint`, `build` → sem erro.
- [ ] **Step 3:** Fluxo ponta a ponta no app local: manager desliga um user → user é deslogado na próxima ação e não entra de novo; some de aniversários/dashboard; aparece com "Mostrar desligados" no PDI; reativar → entra de novo.
- [ ] **Step 4:** Revisão do branch inteiro (superpowers:requesting-code-review) antes de dar como pronto. Deploy fica com o Erick: `aplicar_032.py` → backend → frontend.
