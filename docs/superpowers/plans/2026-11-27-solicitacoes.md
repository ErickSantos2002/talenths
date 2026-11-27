# Solicitações (saída + pagar hora) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformar o módulo Ausências em Solicitações ao RH, com duas categorias — Saída (o que existe) e Pagar hora (novo pedido de hora extra com horário) — renomeando o conceito no banco, na API, no frontend e na ajuda, sem quebrar o HS.OS.

**Architecture:** Uma tabela só (`hr_requests`), com `category` no tipo (`hr_request_types.category`). O router passa a ser montado em `/requests` e, temporariamente, em `/absences` (apelido que só enxerga `saida`, para o HS.OS ver exatamente o que vê hoje). O frontend ganha rotas novas com redirecionamento das antigas.

**Tech Stack:** FastAPI + asyncpg (pytest async, banco de teste em `pg-teste`), React 18 + TS + Vite, Vitest, shadcn/ui.

**Spec:** `docs/superpowers/specs/2026-11-27-solicitacoes-design.md`

## Global Constraints

- Migração nova numerada `040_hr_requests.sql`; nunca editar 001–039. O backend aplica sozinho ao subir.
- Categorias exatas: `saida` | `pagar_hora`. Tipo novo: nome **"Pagar hora"**, `requires_approval = true`, `category = 'pagar_hora'`.
- Motivo ≥ 20 caracteres (após trim) para as duas categorias — mensagem `"O motivo precisa ter pelo menos 20 caracteres"`.
- Pagar hora exige `start_time` e `end_time` no mesmo dia; sem eles → 400 `"Pagar hora precisa do horário de início e de fim"`.
- Prefixo novo `/requests`; apelido `/absences` com `include_in_schema=False`, filtrando `category = 'saida'`.
- `/calendar/feed` mantém `"source": "absence"` / `"event_type": "absence"`; calendário só mostra `saida`.
- Rotas do frontend: `/admin/solicitacoes`, `/minhas-solicitacoes`; `/admin/ausencias` e `/minhas-ausencias` redirecionam (`<Navigate replace>`).
- Rótulos: menu **Solicitações** / **Minhas Solicitações**; botão **Nova solicitação**; selos **Saída** / **Pagar hora**; aba do ponto **Pedidos de ajuste**.
- Interface pt-BR, código em inglês. Versão **v1.24.0**, data do dia da entrega, nos 3 lugares do CLAUDE.md.
- Não editar o repo HS.OS — só entregar o documento da Task 7.
- Backend: rodar testes com `bash backend/scripts/test-db.sh` antes (recria o banco com as migrações) e `cd backend && TEST_DATABASE_URL=... pytest`. Frontend: `bun run --cwd frontend test` e `bun run --cwd frontend lint`.

## Review Focus

1. **Editar pendente trocando de categoria** (pedido de Pagar hora editado com `type_id` de Saída, ou vice-versa) → 400 `"Não é possível trocar a categoria da solicitação"`; o pedido fica como estava. Teste na Task 2.
2. **Pedido de Pagar hora pelo apelido `/absences/request`** (HS.OS antigo com um `type_id` de Pagar hora) → 404 `"Tipo de solicitação não encontrado"`, como se o tipo não existisse. Teste na Task 2.
3. **Pagar hora aprovado no calendário** — não pode aparecer nem para o RH nem para o colaborador em `/calendar/feed`, nem em `/requests/calendar`. Teste na Task 3.
4. **Link antigo salvo** (`/minhas-ausencias`, `/admin/ausencias`, link de guia `/ajuda/rh/minhas-ausencias`) cai na tela nova, sem 404. Teste na Task 4 (rotas) e contrato de links na Task 5.
5. **Pagar hora com fim antes do início ou igual** → 400 `"Horário de fim deve ser após o horário de início"` (regra existente, agora também para essa categoria). Teste na Task 2.

---

### Task 1: Migração 040 — renomear tabelas e criar a categoria

**Files:**
- Create: `backend/migrations/040_hr_requests.sql`
- Create: `backend/tests/db/test_040_hr_requests.py`
- Modify: `backend/tests/db/test_absences_fixed_types_api.py` — apagar `test_migracao_038_converte_os_tipos_antigos` (a 038 roda contra `absence_types`, que deixa de existir; ela já foi aplicada em produção e entra no banco de teste pelo `test-db.sh`).
- Modify: `backend/tests/db/test_rh_writes_scope_api.py` (`make_absence` → `make_request`, SQL em `hr_request_types`/`hr_requests`).

**Interfaces:**
- Produces: tabelas `public.hr_request_types(… category text NOT NULL DEFAULT 'saida' CHECK (category IN ('saida','pagar_hora')))` e `public.hr_requests` (mesmas colunas de `absence_requests`); índices `idx_hr_requests_company`, `idx_hr_requests_user`, `idx_hr_requests_dates`.

- [ ] **Step 1: Escrever `test_040_hr_requests.py`**
  - `test_tabelas_antigas_nao_existem`: `to_regclass('public.absence_requests')` e `to_regclass('public.absence_types')` são `NULL`; `to_regclass('public.hr_requests')` não é.
  - `test_categoria_padrao_e_check`: inserir tipo sem `category` → `'saida'`; inserir com `category = 'ferias'` levanta `asyncpg.CheckViolationError`.
  - `test_reaplicar_040_cria_pagar_hora_uma_vez`: com uma empresa que tem tipos de saída em `hr_request_types`, executar só o bloco de seed da 040 (ler o arquivo e rodar a parte depois do marcador `-- seed`) duas vezes → exatamente 1 tipo `'Pagar hora'` com `category = 'pagar_hora'` e `requires_approval`.
- [ ] **Step 2: Rodar e ver falhar** — `bash backend/scripts/test-db.sh && cd backend && pytest tests/db/test_040_hr_requests.py -v` → FAIL (`hr_requests` não existe).
- [ ] **Step 3: Escrever a 040**, em ordem: `ALTER TABLE … RENAME TO` das duas tabelas; `ALTER INDEX … RENAME TO` dos três índices; `ADD COLUMN IF NOT EXISTS category` com o CHECK; linha `-- seed` e o INSERT idempotente do tipo Pagar hora (cor `#10b981`) no padrão `SELECT DISTINCT company_id … WHERE NOT EXISTS` da 038. Comentário de topo explicando o porquê (Ausências virou Solicitações; pagar hora é pedido de hora extra para compensar, sem saldo).
- [ ] **Step 4: Atualizar os testes de DB que usam SQL direto** com os nomes novos (os da lista Files e qualquer outro achado por `grep -rln "absence_" backend/tests`).
- [ ] **Step 5: Rodar** — `bash backend/scripts/test-db.sh && cd backend && pytest tests/db/test_040_hr_requests.py tests/db/test_rh_writes_scope_api.py -v` → PASS. (Os testes de API das ausências ainda falham até a Task 2 — esperado.)
- [ ] **Step 6: Commit** — `feat(solicitacoes): migração 040 renomeia ausências para hr_requests com categoria`

### Task 2: Router `/requests` com categoria, Pagar hora e apelido `/absences`

**Files:**
- Move: `backend/app/routers/absences.py` → `backend/app/routers/requests.py` (`git mv`)
- Modify: `backend/app/main.py:31,117`
- Move + modify: `backend/tests/db/test_absences_{edit,fixed_types,history,review_info}_api.py` → `test_requests_*_api.py`, usando `/requests` e as tabelas novas
- Create: `backend/tests/db/test_requests_pay_hours_api.py`, `backend/tests/db/test_requests_legacy_alias_api.py`

**Interfaces:**
- Consumes: tabelas da Task 1.
- Produces:
  - `router = APIRouter(tags=["requests"])` **sem prefixo**; em `main.py`: `app.include_router(requests_router, prefix="/requests")` e `app.include_router(requests_router, prefix="/absences", include_in_schema=False)` com comentário: apelido temporário até o HS.OS migrar (ver `docs/superpowers/specs/2026-11-27-solicitacoes-hsos.md`).
  - `def legacy_alias(request: Request) -> bool` — `True` quando `request.url.path` começa com `/absences/`. Endpoints de lista (`/types`, `/my`, `/team`, `/team/pending`, `/team/history`, `/team/people`, `/calendar`) acrescentam `AND t.category = 'saida'` quando `True`; `_validated_fields` recebe `only_saida: bool` e trata tipo `pagar_hora` como não encontrado.
  - `CATEGORIES = ("saida", "pagar_hora")`; `DEFAULT_TYPES` com 4 itens (os 3 de saída + `{"name": "Pagar hora", "color": "#10b981", "requires_approval": True, "category": "pagar_hora"}`).
  - JSON: tipo ganha `"category"`; pedido ganha `"type_category"`. `/team/history` aceita filtro opcional `category: Literal["saida","pagar_hora"] | None`.
  - Mensagens: `"Tipo de solicitação não encontrado"`, `"Pagar hora precisa do horário de início e de fim"`, `"Não é possível trocar a categoria da solicitação"`.
  - O alias da tabela no SQL deixa de ser `at`/`ar` ambíguo: usar `t` (tipo) e `r` (pedido) no `REQUEST_JOIN`.

- [ ] **Step 1: Escrever `test_requests_pay_hours_api.py`**
  - `test_tipos_incluem_pagar_hora`: `GET /requests/types` → nomes = `{"Ida ao médico","Saída pessoal","Outro","Pagar hora"}`; o de Pagar hora tem `category == "pagar_hora"`, os outros `"saida"`.
  - `test_pagar_hora_exige_horario`: POST `/requests/request` com tipo Pagar hora, `start_date` e `end_date` sem horário → 400 com a mensagem exata; com `start_time="18:00"`, `end_time="20:00"` → 201, `type_category == "pagar_hora"`, `days == 0`, `status == "pending"`.
  - `test_pagar_hora_fim_antes_do_inicio`: `18:00`→`17:00` e `18:00`→`18:00` → 400 `"Horário de fim deve ser após o horário de início"`.
  - `test_editar_nao_troca_categoria`: criar Pagar hora pendente; PUT com `type_id` de "Saída pessoal" → 400 com a mensagem exata; GET `/requests/my` mostra ainda `type_category == "pagar_hora"`. O inverso (saída → pagar hora) também 400.
  - `test_historico_filtra_por_categoria`: RH aprova uma saída e um pagar hora; `/requests/team/history?category=pagar_hora` → só o pagar hora.
- [ ] **Step 2: Escrever `test_requests_legacy_alias_api.py`**
  - `test_alias_tipos_so_saida`: `GET /absences/types` → os 3 de saída, sem "Pagar hora".
  - `test_alias_listas_escondem_pagar_hora`: um pedido de cada categoria, ambos pendentes; `/absences/my`, `/absences/team`, `/absences/team/pending` só trazem a saída; `/requests/team/pending` traz os dois.
  - `test_alias_nao_cria_pagar_hora`: POST `/absences/request` com `type_id` de Pagar hora e horário → 404 `"Tipo de solicitação não encontrado"`; nada gravado em `hr_requests`.
  - `test_alias_aprova_saida`: PUT `/absences/{id}/approve` numa saída → 200 `status == "approved"` (escritas por id continuam valendo).
- [ ] **Step 3: Mover os 4 testes existentes** para `test_requests_*`, trocando URL e SQL. Rodar todos → FAIL (rota `/requests` não existe).
- [ ] **Step 4: Implementar** — `git mv` do router, renomear identificadores (`absence` → `request`/`hr_request`), prefixo no `main.py`, `legacy_alias`, categoria, validações acima. Em `_validated_fields(body, company_id, conn, only_saida)`: buscar o tipo (filtrando `category = 'saida'` se `only_saida`), depois exigir horário se `pagar_hora`. Em `update_request`: comparar a categoria do tipo atual com a do novo antes de gravar.
- [ ] **Step 5: Rodar** — `cd backend && pytest tests/db/test_requests_*.py -v` → PASS.
- [ ] **Step 6: Commit** — `feat(solicitacoes): rota /requests com pagar hora; /absences vira apelido só de saídas`

### Task 3: Calendário, relatório, auditoria, Guardi e bruce_agent

**Files:**
- Modify: `backend/app/routers/calendar.py:153-175`, `backend/app/routers/reports.py:110-140`, `backend/app/middleware/audit.py:37-41`, `backend/app/auth/agente.py`, `bruce_agent.py`
- Modify: `backend/tests/test_audit_middleware.py`, `backend/tests/test_agente_token.py`, `backend/tests/db/test_agente_capacidades_api.py`
- Create: `backend/tests/db/test_requests_calendar_report_api.py`

**Interfaces:**
- Consumes: tabelas (Task 1), rotas `/requests/*` e `/absences/*` (Task 2).
- Produces: `GET /reports/requests` (CSV `solicitacoes.csv`, coluna **Categoria** com "Saída"/"Pagar hora" depois de **Tipo**) e `/reports/absences` como segunda rota do mesmo handler (mesmo CSV). `CATEGORY_LABELS = {"saida": "Saída", "pagar_hora": "Pagar hora"}`.

- [ ] **Step 1: Escrever `test_requests_calendar_report_api.py`**
  - `test_feed_sem_pagar_hora`: uma saída e um pagar hora aprovados do mesmo colaborador; `/calendar/feed` como RH e como o próprio colaborador → só a saída entre os itens `source == "absence"`; `/requests/calendar` → só a saída.
  - `test_relatorio_tem_categoria`: `/reports/requests` → cabeçalho contém `"Categoria"`; linhas com `"Saída"` e `"Pagar hora"`; `content-disposition` com `solicitacoes.csv`. `/reports/absences` → 200, mesmo corpo.
- [ ] **Step 2: Atualizar os testes puros**
  - `test_agente_token.py`: as mesmas asserções de hoje para `/absences/*` **e** equivalentes para `/requests/my`, `/requests/request`, `/requests/{request_id}/approve`.
  - `test_audit_middleware.py`: `POST /requests/request` → `"Solicitação criada"`; `PUT /requests/{id}/approve` → `"Solicitação aprovada"`; `/absences/...` gera os mesmos textos.
  - `test_agente_capacidades_api.py`: a resposta do RH contém `["PUT", "/requests/{request_id}/approve"]` **e** `["PUT", "/absences/{request_id}/approve"]`; a de colaborador não contém nenhuma das duas.
- [ ] **Step 3: Rodar** → FAIL.
- [ ] **Step 4: Implementar**
  - Calendário: SQL nas tabelas novas com `AND t.category = 'saida'` nos dois ramos; `source`/`event_type` continuam `"absence"`.
  - Relatório: handler com dois decorators `@router.get("/requests")` e `@router.get("/absences", include_in_schema=False)`.
  - Auditoria: padrões para os dois prefixos (`(?:requests|absences)`), textos "Solicitação criada/aprovada/recusada/editada/removida".
  - `agente.py`: para cada rota `/absences/...` em `ROTAS_DO_AGENTE`, `ESCRITAS_DO_AGENTE` e `SO_RH`, acrescentar a equivalente `/requests/...`; incluir `/reports/requests`. Comentário: as `/absences` saem quando o HS.OS migrar.
  - `bruce_agent.py`: trocar as URLs para `/requests` e `/reports/requests`.
- [ ] **Step 5: Rodar** — `cd backend && pytest -v` (suite inteira) → PASS.
- [ ] **Step 6: Commit** — `feat(solicitacoes): calendário sem pagar hora, relatório com categoria, Guardi aceita /requests`

### Task 4: Frontend — telas Solicitações

**Files:**
- Move: `frontend/src/types/absences.ts` → `frontend/src/types/requests.ts`; `pages/MyAbsencesPage.tsx` → `pages/MyRequestsPage.tsx`; `pages/AbsencesAdminPage.tsx` → `pages/RequestsAdminPage.tsx`
- Modify: `frontend/src/lib/api.ts:406-427,539`, `frontend/src/App.tsx:42-43,330-345`, `frontend/src/help/screens.ts:110,145`, `frontend/src/pages/AdminTimeclockPage.tsx:346,448`, `frontend/src/pages/ReportsAdminPage.tsx`, `frontend/src/help/screens.test.ts`
- Create: `frontend/src/components/requests/RequestCategoryBadge.tsx`

**Interfaces:**
- Consumes: JSON da Task 2/3 (`category`, `type_category`, filtro `category`, `/reports/requests`).
- Produces:
  - `type RequestCategory = "saida" | "pagar_hora"`; `HrRequestType` (= `AbsenceType` + `category: RequestCategory`), `HrRequest` (= `AbsenceRequest` + `type_category: RequestCategory`), `HrRequestHistoryPage`.
  - `export const requests = { types, my, teamPending, teamHistory, teamPeople, calendar, request, update, approve, reject, delete }` em `lib/api.ts` apontando para `/requests/*`; `reports.requests()` baixa `/reports/requests` como `solicitacoes.csv`.
  - `RequestCategoryBadge({ category }: { category: RequestCategory })` — selo "Saída" / "Pagar hora".
  - `CATEGORY_LABEL: Record<RequestCategory, string>` em `types/requests.ts`.

- [ ] **Step 1: Atualizar `screens.test.ts`** com as rotas `/admin/solicitacoes` ("Solicitações") e `/minhas-solicitacoes` ("Minhas Solicitações"). Rodar `bun run --cwd frontend test` → FAIL.
- [ ] **Step 2: Renomear tipos/api/páginas** (`git mv`) e rotas no `App.tsx`, com `<Navigate to="/admin/solicitacoes" replace />` em `/admin/ausencias` e `<Navigate to="/minhas-solicitacoes" replace />` em `/minhas-ausencias`. Menu em `screens.ts`.
- [ ] **Step 3: Colaborador (`MyRequestsPage`)** — título **Minhas Solicitações**; botão **Nova solicitação**; no diálogo, primeiro a escolha **Saída** | **Pagar hora** (shadcn `Tabs` ou `ToggleGroup`), travada na edição (mostra a categoria do pedido). Saída = formulário atual com os tipos `category === "saida"`. Pagar hora = **Dia**, **Das**, **Às**, **Motivo** (com o contador de 20), mandando o `type_id` do tipo `pagar_hora`, `start_date = end_date = dia`, `start_time`/`end_time`. Lista com `RequestCategoryBadge`.
- [ ] **Step 4: RH (`RequestsAdminPage`)** — título **Solicitações**; `RequestCategoryBadge` nos pendentes e no histórico; o filtro **Todos os tipos** lista os 4 tipos. Aba **Calendário** sem mudança de comportamento (o backend já filtra).
- [ ] **Step 5: Ponto** — `AdminTimeclockPage`: aba **Solicitações** → **Pedidos de ajuste** (rótulo e comentário da seção). `ReportsAdminPage`: botão do relatório "Solicitações" chamando `reports.requests()`.
- [ ] **Step 6: Rodar** — `bun run --cwd frontend test && bun run --cwd frontend lint && bun run --cwd frontend build` → PASS. Os contratos de guia (`guides.contract.test.ts`) podem falhar por rota sem guia — resolvido na Task 5; se falhar, fazer as Tasks 4 e 5 no mesmo commit.
- [ ] **Step 7: Conferir na tela** — subir backend + `bun dev`, criar uma saída e um pagar hora como colaborador, aprovar como RH, abrir `/minhas-ausencias` e ver o redirecionamento.
- [ ] **Step 8: Commit** (junto com a Task 5 se os contratos exigirem).

### Task 5: Ajuda, tour, semente, capturas e versão

**Files:**
- Move + modify: `frontend/src/help/guides/administracao/ausencias.md` → `solicitacoes.md`; `frontend/src/help/guides/rh/minhas-ausencias.md` → `minhas-solicitacoes.md`
- Modify: `frontend/src/help/guides/administracao/{relatorios,ponto-eletronico}.md`, `meu-espaco/calendario.md`, `primeiros-passos/{ajuda-desta-tela,como-navegar-pelo-menu}.md`; `frontend/src/help/tours/*` se algum passo citar as telas/menus; `backend/scripts/seed_captures.py:715-820`; `frontend/scripts/captures.config.ts:83,118`
- Delete: `frontend/public/capturas/{admin-ausencias,minhas-ausencias}.webp`; Create: `…/{admin-solicitacoes,minhas-solicitacoes}.webp` (e refazer `admin-ponto.webp` se a aba aparecer nela)
- Modify: `frontend/src/components/ChangelogModal.tsx`, `frontend/src/components/AdminSidebar.tsx`, `frontend/package.json`

- [ ] **Step 1: Guias** — `telas` nas rotas novas, títulos **Solicitações** / **Minhas Solicitações**, textos de "ausência" → "solicitação" onde é o pedido. Seção nova **Pagar hora**: para que serve (combinar a hora extra para compensar horas devidas), campos (Dia, Das, Às, Motivo), que o RH aprova igual, que **não aparece no Calendário** e que o TalentHS **não soma saldo** (o banco de horas fica no sistema de ponto). Guia do RH: o selo de categoria. `ponto-eletronico.md`: aba **Pedidos de ajuste**. Links internos `/ajuda/rh/minhas-ausencias` → `/ajuda/rh/minhas-solicitacoes`. Rodar `grep -rn "Atenção:" frontend/src/help/guides` e conferir se algum aviso fala desta tela.
- [ ] **Step 2: Tours** — `grep -rn -i "ausên\|ausenc\|Solicitações" frontend/src/help/tours`; atualizar textos/alvos; passo novo em tour publicado leva `since: "1.24.0"` e o tour sobe `version`.
- [ ] **Step 3: Rodar** `bun run --cwd frontend test` → PASS (contratos de rotas, âncoras, links, imagens — as imagens novas entram no Step 5).
- [ ] **Step 4: Semente** — `seed_captures.py`: tabelas novas, tipo Pagar hora com `category`, um Pagar hora pendente (ana) e um aprovado; os logs de auditoria em `/requests/...` com os textos novos. `captures.config.ts`: `minhas-solicitacoes` (`/minhas-solicitacoes`) e `admin-solicitacoes` (`/admin/solicitacoes`).
- [ ] **Step 5: Capturas** — seguir o CLAUDE.md (`captures-db.sh`, backend 8021, frontend 8091, `bun run --cwd frontend capturas -- --only minhas-solicitacoes,admin-solicitacoes,admin-ponto`); apagar os `.webp` antigos; **abrir e olhar** cada imagem. Atualizar as referências de imagem nos guias.
- [ ] **Step 6: Versão** — `ChangelogModal.tsx` entrada `v1.24.0` no topo, `current: true` (tirar da v1.23.0), entradas ao usuário final, ex.: `novidade` "Ausências agora se chama Solicitações: além de pedir saída, você pode pedir para pagar hora, informando o dia e o horário da hora extra."; `melhoria` "No Ponto Eletrônico, a aba de pedidos passou a se chamar Pedidos de ajuste.". `AdminSidebar.tsx` `TalentHS v1.24.0`; `package.json` `"version": "1.24.0"`.
- [ ] **Step 7: Rodar** — `bun run --cwd frontend test && bun run --cwd frontend lint` → PASS.
- [ ] **Step 8: Commit** — `feat(solicitacoes): Ausências vira Solicitações com pedido de pagar hora, versão 1.24.0`

### Task 6: Revisão final e fechamento

- [ ] **Step 1:** `bash backend/scripts/test-db.sh && cd backend && pytest` e `bun run --cwd frontend test && bun run --cwd frontend lint && bun run --cwd frontend build` → tudo PASS.
- [ ] **Step 2:** `grep -rn -i "absence\|ausênc\|ausenc" backend/app frontend/src` — o que sobrar deve ser só: apelido `/absences` (main.py, agente.py, audit, reports), `source/event_type "absence"` do calendário e a legenda "Ausências" do Calendário (são ausências de fato).
- [ ] **Step 3:** Merge na `main` e push (memória "fechamento de entrega"); avisar "pode dar Deploy" (backend → frontend).

### Task 7: Documento de entrega para o HS.OS

**Files:**
- Create: `docs/superpowers/specs/2026-11-27-solicitacoes-hsos.md`

- [ ] **Step 1:** Escrever o documento para a sessão do HS.OS: trocar `/absences/*` → `/requests/*` em `backend/app/talenths_escrita.py`, `talenths_preparo.py`, `avisos_ausencia.py`; o aviso ao RH ignora `type_category == "pagar_hora"` (ou vira aviso próprio); renomear rótulos em `frontend/src/lib/acoes.ts` ("Pedir ausência" → "Pedir saída" etc.); opcional: ação nova "Pedir para pagar hora" (`POST /requests/request` com `type_id` do tipo `category == "pagar_hora"`, `start_date`, `start_time`, `end_time`, `reason` ≥ 20). Avisar que, depois de migrar, o TalentHS remove o apelido `/absences`.
- [ ] **Step 2:** Commit junto com a Task 6 e mostrar o caminho ao Erick, sugerindo `cl HS.OS`.
