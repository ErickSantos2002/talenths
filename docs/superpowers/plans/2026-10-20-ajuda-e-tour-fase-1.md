# Ajuda e Tour — Fase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tour de boas-vindas (colaborador e gestor) por convite no Dashboard, com progresso no banco, e uma `/ajuda` mínima para refazer o tour — entrega v1.10.0.

**Architecture:** Backend ganha a tabela `tour_progress` (030) e o router `/tour` (SQL cru, asyncpg). Frontend ganha uma tabela única de telas (`help/screens.ts`) que passa a montar o menu, um motor de tour próprio sobre `driver.js` (só destaque/balão), um `TourProvider` acima de `<Routes>` e uma ponte no `AdminLayout` que prepara a sidebar (expande se recolhida; no celular troca o alvo pelo botão ☰).

**Tech Stack:** React 18 + TS + Vite, shadcn/ui, React Query 5, React Router 6, vitest; `driver.js` **1.8.0** (versão exata); FastAPI + asyncpg; pytest com `TEST_DATABASE_URL`.

**Spec:** `docs/superpowers/specs/2026-10-20-ajuda-e-tour-design.md`. Referência de código (só leitura, outro repo): `~/github/docshs/frontend/src/ajuda/motorDoTour.ts`, `ProvedorDoTour.tsx`, `tutorialNucleo.ts`, `~/github/docshs/backend/app/services/tutorial.py`, e os defeitos do registro `~/github/docshs/docs/superpowers/execucao/2026-10-08-modulo-6-fase-1-registro-de-execucao.md`.

## Global Constraints

- Código e identificadores em inglês; interface em pt-BR. Na interface e no código novo: nunca "onboarding" (já é o checklist de RH) nem "treinamento".
- Migração nova `backend/migrations/030_tour_progress.sql`; nunca editar migrações existentes. Sem RLS (padrão 008–029); isolamento no SQL pelo usuário do token.
- Tour ids casam `^[a-z0-9-]{1,64}$`; versão 1–999; passo 0–999; teto **50** tours por pessoa; recusas de convite até **3**.
- Alvos do tour só por `data-tour="..."`. Alvo de página deve existir **mesmo com a lista vazia** (cabeçalho/contêiner, nunca "primeira linha").
- Textos dos passos: 1–2 frases, imperativo, nome do botão em `**negrito**` como aparece na tela.
- Espera do elemento: 400 ms em silêncio, depois balão no centro, até 3000 ms no total.
- Botões do balão: "← Anterior", "Próximo →", "Concluir" (último); progresso "N de M"; passo anterior a troca de tela ganha "Vamos para **X**.".
- Nada de CSS customizado além de `frontend/src/help/tour.css` (estilo do `.driver-popover`, justificado: é DOM do driver.js), usando os tokens HSL do tema, claro e escuro.
- Rotas do tour **fora** do log de auditoria.
- Versão **v1.10.0**, data **20/10/2026**, nos 3 lugares do `CLAUDE.md`.

## Review Focus

1. Clique duplo em **Próximo →** enquanto o próximo elemento ainda não apareceu → não pode pular passo (teste na Task 5).
2. Logout (ou troca de conta) no meio do tour → nenhum PUT atrasado sai com o token da outra pessoa (teste na Task 7).
3. Sidebar recolhida no computador → o tour expande para os passos de menu e **devolve recolhida** ao concluir ou fechar, mesmo tendo trocado de página (cookie `sidebar:state`) (teste na Task 7).
4. Celular → passo de menu destaca o botão ☰ com o texto extra, sem abrir a gaveta modal (teste na Task 7).
5. Pessoa sem nenhum vídeo/comunicado/teste → todos os alvos existem com a página vazia (contrato na Task 6 + verificação na tela na Task 9).

---

### Task 1: Migração 030 — `tour_progress`

**Files:**
- Create: `backend/migrations/030_tour_progress.sql`
- Test: `backend/tests/db/test_030_tour_progress.py`

**Interfaces:**
- Produces: tabela `public.tour_progress(id uuid pk default gen_random_uuid(), user_id uuid not null → auth.users ON DELETE CASCADE, company_id uuid → companies ON DELETE CASCADE (nullable: perfil pode não ter empresa), tour text not null, version smallint not null, step smallint not null default 0, started_at, completed_at, dismissed_at timestamptz, invites_declined smallint not null default 0, created_at/updated_at timestamptz not null default now())`, `UNIQUE (user_id, tour)`, índice em `user_id`.
- CHECKs nomeados: `tour ~ '^[a-z0-9-]{1,64}$'`, `version BETWEEN 1 AND 999`, `step BETWEEN 0 AND 999`, `invites_declined >= 0`.

- [ ] **Step 1: Write the failing tests** (estilo de `test_029_internal_videos.py`, fixture `db`, helpers `make_company`/`make_user`)
  - `test_insert_minimal_row_defaults` — insere `(user_id, tour='boas-vindas-colaborador', version=1)`; `step == 0`, `invites_declined == 0`, datas nulas.
  - `test_tour_id_format_rejected` — `'Boas Vindas'`, `''` e 65 chars → `asyncpg.CheckViolationError`.
  - `test_version_and_step_ranges` — version 0 e 1000, step -1 e 1000 → `CheckViolationError`.
  - `test_negative_declines_rejected`.
  - `test_unique_per_user_and_tour` — segunda linha igual → `UniqueViolationError`; mesmo tour para outro usuário passa.
  - `test_deleting_user_cascades`.
- [ ] **Step 2: Rodar e ver falhar** — `cd backend && bash scripts/test-db.sh` (aplica migrações; exporta a URL impressa) e `pytest tests/db/test_030_tour_progress.py -v` → FAIL (`relation "public.tour_progress" does not exist`).
- [ ] **Step 3: Escrever `030_tour_progress.sql`** com cabeçalho de uma linha no estilo da 029, `IF NOT EXISTS` em tudo.
- [ ] **Step 4: Recriar o banco de teste e rodar** — `bash scripts/test-db.sh && pytest tests/db/test_030_tour_progress.py -v` → PASS.
- [ ] **Step 5: Commit** — `feat(tour): tabela tour_progress (030)`.

---

### Task 2: Router `/tour` + auditoria

**Files:**
- Create: `backend/app/routers/tour.py`
- Modify: `backend/app/main.py` (import + `app.include_router(tour_router)` após `videos_router`)
- Modify: `backend/app/middleware/audit.py` (`_SKIP_PATTERNS`)
- Test: `backend/tests/db/test_tour_api.py`, `backend/tests/test_audit_middleware.py`

**Interfaces:**
- Consumes: tabela da Task 1; `get_db`, `get_current_user_id` de `app.dependencies`.
- Produces (todas com `get_db`; usuário **sempre** do token; corpos Pydantic com `model_config = ConfigDict(extra="forbid")`; `{tour}` validado pelo mesmo regex → 422):
  - `GET /tour/progress` → `list[TourProgressOut]`
  - `PUT /tour/progress/{tour}` body `{version: int 1–999, step: int 0–999}` → `TourProgressOut`
  - `POST /tour/progress/{tour}/complete` body `{version}` → `TourProgressOut`
  - `POST /tour/progress/{tour}/dismiss` body `{version}` → `TourProgressOut`
  - `POST /tour/progress/{tour}/decline-invite` body `{version}` → `TourProgressOut`
  - `TourProgressOut = {tour: str, version: int, step: int, started_at, completed_at, dismissed_at: datetime | None, invites_declined: int}`
  - Constantes no módulo: `TOURS_PER_USER = 50`, `MAX_INVITE_DECLINES = 3`.

- [ ] **Step 1: Write the failing API tests** (fixture `client_as`, como `test_notifications_api.py`)
  - `test_get_empty_list` → `[]`.
  - `test_put_creates_with_started_at_and_step` — PUT `{version:1, step:2}` → `step == 2`, `started_at` preenchido; segundo PUT `step:3` mantém o mesmo `started_at`.
  - `test_put_updates_version_only_while_not_completed` — completa na v1; PUT `{version:2, step:0}` → `version == 1`.
  - `test_complete_keeps_first_date_and_version_only_rises` — complete v2, complete v1 → `version == 2`, `completed_at` igual ao primeiro; complete v3 → `version == 3`, mesma data.
  - `test_complete_without_put_sets_started_at`.
  - `test_dismiss_keeps_first_date`.
  - `test_decline_caps_at_3` — 4 chamadas → `invites_declined == 3`.
  - `test_body_with_user_id_is_422` e `test_bad_tour_id_is_422` (`/tour/progress/Boas%20Vindas`).
  - `test_version_out_of_range_is_422`.
  - `test_cap_of_50_tours_is_422` — 50 tours distintos via SQL, PUT do 51º → 422; PUT num tour **existente** continua 200.
  - `test_users_are_isolated` — progresso de A não aparece no GET de B; PUT de B no mesmo id cria linha própria.
  - Em `test_audit_middleware.py`: `test_tour_routes_not_logged` — `PUT /tour/progress/boas-vindas-colaborador`, `POST .../complete`, `.../dismiss`, `.../decline-invite` → `not _should_log(...)`.
- [ ] **Step 2: Rodar e ver falhar** — `pytest tests/db/test_tour_api.py tests/test_audit_middleware.py -v` → FAIL (404 / assert).
- [ ] **Step 3: Implementar `tour.py`.** Toda escrita passa por `_locked_row(conn, user_id, tour, version) -> asyncpg.Record`: se não existe linha, conta as do usuário e levanta 422 ("Limite de tours atingido.") se `>= TOURS_PER_USER`; `INSERT ... ON CONFLICT (user_id, tour) DO NOTHING` (com `company_id` do perfil); `SELECT ... FOR UPDATE`. Regras de cada rota exatamente como a tabela "Rotas" do spec (versão sobe com `GREATEST` após concluir; datas só na 1ª vez; `updated_at = now()`).
- [ ] **Step 4: Pular auditoria** — `re.compile(r"^(PUT|POST) /tour/progress/")` em `_SKIP_PATTERNS`, com o comentário existente cobrindo o motivo.
- [ ] **Step 5: Rodar** — `pytest tests -v` → tudo PASS (inclusive os testes antigos).
- [ ] **Step 6: Commit** — `feat(tour): rotas de progresso do tour`.

---

### Task 3: Tabela única de telas e menu

**Files:**
- Create: `frontend/src/help/screens.ts`
- Modify: `frontend/src/components/AdminSidebar.tsx` (remove `adminSections`/`personalSections` e os `built*` à mão; passa a usar `menuSections`; adiciona `data-tour` nos itens e grupos; item **Ajuda**)
- Test: `frontend/src/help/screens.test.ts`

**Interfaces:**
- Produces:
  ```ts
  export type AppRole = "master_admin" | "manager" | "user";
  export type MenuGroup = "main" | "company" | "personal";
  export interface Section { key: string; label: string; group: MenuGroup }
  export interface Screen {
    path: string;                       // padrão do react-router, igual ao App.tsx
    name: string;                       // usado em "Abrindo X…" / "Vamos para X"
    roles: AppRole[];
    requires?: "timeclock_enabled";
    section?: string;                   // Section.key; sem section = fora do menu
    menu?: { title: string; icon: LucideIcon; tour: string };   // tour = valor do data-tour
  }
  export interface ScreenContext { roles: AppRole[]; timeclockEnabled: boolean }
  export const SECTIONS: Section[];
  export const SCREENS: Screen[];
  export function screensFor(ctx: ScreenContext): Screen[];
  export function canOpen(path: string, ctx: ScreenContext): boolean;
  export function screenName(path: string): string;
  export function menuSections(group: MenuGroup, ctx: ScreenContext): { section: Section; items: Screen[] }[];
  ```
  - Grupo `main`: Apresentação, Dashboard, **Ajuda** (`/ajuda`, ícone `LifeBuoy`, `tour: "menu-help"`), todos os papéis.
  - Seções `company` e `personal` com as mesmas chaves, rótulos, ordem e ícones de hoje. Logs: `roles: ["master_admin"]` na seção `sistema`. Meu Ponto: `requires: "timeclock_enabled"` em `rh-pessoal`.
  - `tour` dos itens: `menu-` + último segmento da URL com prefixo `admin-` para admin (ex.: `menu-meus-videos`, `menu-admin-videos`).
  - SCREENS cobre **toda** rota protegida do `App.tsx`, incluindo as sem menu (`/videos/:id`, `/meus-testes/:testId/realizar`, `/admin/bingo/:gameId/imprimir` etc.).

- [ ] **Step 1: Write the failing tests**
  - `user does not see company group` — `menuSections("company", {roles:["user"], timeclockEnabled:false})` → `[]`.
  - `Logs only for master_admin` — presente em `sistema` para `["master_admin"]`, ausente para `["manager"]`.
  - `Meu Ponto only with timeclock` — em `rh-pessoal` só com `timeclockEnabled: true`.
  - `Ajuda is in main for everyone`.
  - `menu order matches today` — títulos de `personal` para `user`, achatados, iguais à lista atual (copiar de `AdminSidebar.tsx` antes de editar).
  - `screenName("/meus-videos") === "Vídeos"`; `screenName("/videos/:id")` retorna o `name` da tela.
  - `every protected route in App.tsx is in SCREENS` — lê `App.tsx` com `import appSource from "@/App.tsx?raw"`, extrai os `path="..."` dentro de `<ProtectedRoute`, e compara com `SCREENS.map(s => s.path)`.
  - `canOpen` respeita `roles` e `requires`.
- [ ] **Step 2: Rodar e ver falhar** — `cd frontend && bun test src/help/screens.test.ts` → FAIL (módulo não existe).
- [ ] **Step 3: Implementar `screens.ts`** e criar a rota `/ajuda` no `SCREENS` (a página vem na Task 8).
- [ ] **Step 4: Migrar `AdminSidebar`** para `menuSections`, mantendo exatamente o visual; `NavItem` repassa `data-tour={item.menu.tour}` ao `SidebarMenuButton`; `data-tour="menu"` no `SidebarContent`; `data-tour="menu-company"` num wrapper em volta do rótulo "Empresa" + seções de admin.
- [ ] **Step 5: Rodar** — `bun test && bun lint && bun run build` → PASS.
- [ ] **Step 6: Commit** — `refactor(menu): tabela única de telas com âncoras do tour`.

---

### Task 4: Tipos, regras puras e cliente da API

**Files:**
- Create: `frontend/src/help/tours/types.ts`, `frontend/src/help/tourRules.ts`
- Modify: `frontend/src/lib/api.ts` (seção `tour`)
- Test: `frontend/src/help/tourRules.test.ts`

**Interfaces:**
- Produces:
  ```ts
  // types.ts
  export interface TourStep { route: string; element?: string; title: string; text: string; interact?: boolean; since?: number }
  export interface Tour { id: string; version: number; steps: TourStep[] }
  export type Audience = "collaborator" | "manager";
  // api.ts
  export interface TourProgress { tour: string; version: number; step: number; started_at: string | null; completed_at: string | null; dismissed_at: string | null; invites_declined: number }
  export const tour = {
    list: () => get<TourProgress[]>("/tour/progress"),
    advance: (id: string, version: number, step: number) => put<TourProgress>(`/tour/progress/${id}`, { version, step }),
    complete: (id: string, version: number) => post<TourProgress>(`/tour/progress/${id}/complete`, { version }),
    dismiss: (id: string, version: number) => post<TourProgress>(`/tour/progress/${id}/dismiss`, { version }),
    declineInvite: (id: string, version: number) => post<TourProgress>(`/tour/progress/${id}/decline-invite`, { version }),
  };
  // tourRules.ts
  export const MAX_INVITE_DECLINES = 3;
  export function audienceOf(roles: AppRole[]): Audience;            // manager|master_admin → "manager"
  export function resumeStep(progress: TourProgress | null, t: Tour | null): number | null;
  export function shouldInvite(progress: TourProgress | null): boolean;
  export function tourStatus(progress: TourProgress | null, t: Tour): { kind: "done"; date: string } | { kind: "stopped"; step: number; total: number } | { kind: "not-started" };
  ```
- [ ] **Step 1: Write the failing tests**
  - `resumeStep`: `null` sem progresso; `null` se concluído; `null` se nunca iniciado; `null` se `progress.version !== t.version`; `null` se `step === 0` ou `step >= steps.length`; `3` se parou no 3 da mesma versão.
  - `shouldInvite`: `true` sem progresso; `false` se concluído, se dispensado, ou com `invites_declined === 3`; `true` com 2.
  - `audienceOf(["user"]) === "collaborator"`; `["manager"]` e `["master_admin","user"]` → `"manager"`.
  - `tourStatus`: concluído → `{kind:"done", date:"dd/MM/yyyy"}`; parado no passo 4 de 9 → `{kind:"stopped", step: 5, total: 9}` (passo exibido começando em 1); sem progresso → `not-started`.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar.**
- [ ] **Step 4: Rodar** → PASS.
- [ ] **Step 5: Commit** — `feat(tour): regras do convite e da retomada`.

---

### Task 5: Motor do tour

**Files:**
- Modify: `frontend/package.json` (`"driver.js": "1.8.0"` exato; `bun add driver.js@1.8.0 --exact`)
- Create: `frontend/src/help/tourEngine.ts`, `frontend/src/help/tour.css`
- Test: `frontend/src/help/tourEngine.test.ts`

**Interfaces:**
- Consumes: `Tour`, `TourStep` (Task 4).
- Produces:
  ```ts
  export const ELEMENT_WAIT_MS = 3000;
  export const SHORT_WAIT_MS = 400;
  export interface PreparedTarget { element?: string; extraText?: string }
  export interface EngineCallbacks {
    navigate: (route: string) => void;
    screenName: (route: string) => string;
    onShow: (step: number) => void;
    onComplete: () => void;
    onClose: (step: number) => void;
    prepare?: (element: string | undefined) => Promise<PreparedTarget>;
  }
  export function safeText(text: string): string;          // escapa HTML, depois **x** → <strong>x</strong>
  export class TourEngine {
    constructor(cb: EngineCallbacks);
    get active(): boolean;
    start(t: Tour, from?: number): void;
    stop(): void;                                          // encerra sem callbacks
  }
  ```
  Port do `MotorDoTour` do DocsHS (mesma lógica: geração, trava `waiting`, dois `requestAnimationFrame` após navegar, `MutationObserver` limitado ao tempo de espera, teclado ← →, `overlayClickBehavior: () => {}`, `disableActiveInteraction: !step.interact`, `popoverClass: "talenths-tour"`). Diferença: o alvo efetivo e o texto extra vêm de `prepare()` (`extraText` é acrescentado como último parágrafo). Sem tours por tela nesta fase.
- [ ] **Step 1: Write the failing tests** — `vi.mock("driver.js")` com um fake que grava as chamadas de `highlight` e expõe os `onNextClick`/`onPrevClick`/`onCloseClick` do último popover; `Element.prototype.getClientRects` e `getBoundingClientRect` stubados para elementos com `data-visible`; `vi.useFakeTimers()`; `requestAnimationFrame` stubado.
  - `safeText escapes html and bolds` — `safeText('<b>a</b> **B**') === '&lt;b&gt;a&lt;/b&gt; <strong>B</strong>'`.
  - `navigates when step route differs from location` — passo em `/meus-videos` com `location.pathname = "/dashboard"` → `navigate("/meus-videos")` chamado e primeiro balão é "Abrindo Vídeos…".
  - `double next during wait does not skip` — passo 1 sem elemento no DOM; chama next duas vezes durante a espera; ao aparecer, o passo mostrado é o 1 (não o 2).
  - `missing element shows centered after 400ms and repositions when it appears` — `highlight` sem `element` após 400 ms; elemento inserido aos 1500 ms → novo `highlight` com o elemento.
  - `last step label and complete` — no último passo `nextBtnText === "Concluir"`; next → `onComplete` chamado e `active === false`.
  - `close reports current step` — close no passo 2 → `onClose(2)`.
  - `adds "Vamos para" when next step changes route`.
  - `appends extraText from prepare` e usa `prepare().element` como alvo.
  - `progress text is "N de M"`.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar `tourEngine.ts` e `tour.css`** (sobrescreve `.driver-popover.talenths-tour`: fundo/borda/texto/raio com `hsl(var(--popover))`, `--border`, `--foreground`, `--radius`; botão Próximo como primário `hsl(var(--primary))`; setas pintando só o lado que aponta; `.talenths-tour-opening` esconde descrição e rodapé; `min-width: 280px; max-width: 360px`; overlay via `overlayColor` com `rgb(0 0 0)` e opacidade 0.55).
- [ ] **Step 4: Rodar** → PASS.
- [ ] **Step 5: Commit** — `feat(tour): motor do tour sobre driver.js`.

---

### Task 6: Tours de boas-vindas e âncoras nas páginas

**Files:**
- Create: `frontend/src/help/tours/welcome.ts`
- Modify (só `data-tour` no contêiner indicado): `pages/DashboardPage.tsx` (bloco do título → `dashboard-header`), `pages/MeusVideosPage.tsx` (`my-videos`), `pages/ComunicadosPage.tsx` (`announcements`), `pages/MyEvaluationPage.tsx` (`my-evaluation`), `pages/MeusTestesPage.tsx` (`my-tests`), `pages/MyProfilePage.tsx` (`my-profile`), `pages/AdminCollaboratorsPage.tsx` (`admin-collaborators`), `pages/AdminVideosPage.tsx` (`admin-videos`), `pages/ReportsAdminPage.tsx` (`admin-reports`), `components/NotificationBell.tsx` (`notifications` no botão do sino), `components/AdminLayout.tsx` (`menu-mobile` no wrapper do `SidebarTrigger` mobile) — sempre no contêiner principal que existe também com dados vazios e nos estados de carregamento/erro.
- Test: `frontend/src/help/tours/welcome.contract.test.ts`

**Interfaces:**
- Consumes: `Tour` (Task 4), `SCREENS`/`canOpen` (Task 3).
- Produces:
  ```ts
  export const COLLABORATOR_STEPS: TourStep[];   // passos 1–8 do roteiro do spec
  export const FINAL_STEPS: TourStep[];          // passo 9: route "/ajuda", element "menu-help"
  export const WELCOME_TOURS: Record<Audience, Tour>;
  // collaborator: { id: "boas-vindas-colaborador", version: 1, steps: [...COLLABORATOR_STEPS, ...FINAL_STEPS] }
  // manager:      { id: "boas-vindas-gestor", version: 1, steps: [...COLLABORATOR_STEPS, ...ADMIN_STEPS, ...FINAL_STEPS] }
  ```
  - Roteiro exatamente como a tabela do spec. Passo 8 (sino) usa `route: "/meu-perfil"` (mesma tela do 7, sem navegar), `element: "notifications"`. Passo 2: `route: "/dashboard"`, `element: "menu"`.
  - `ADMIN_STEPS`: `menu-company` em `/dashboard`; `admin-collaborators` em `/admin/colaboradores`; `admin-videos` em `/admin/videos`; `admin-reports` em `/admin/relatorios`.
  - Todo passo com `since` omitido (versão 1).
- [ ] **Step 1: Write the failing contract tests**
  - `every element exists as data-tour` — `import.meta.glob("/src/**/*.tsx", { query: "?raw", import: "default", eager: true })`; junta os valores literais `data-tour="x"` e os `tour: "x"` de `screens.ts`; todo `step.element` de todo tour está no conjunto.
  - `every route is openable by the audience` — collaborator com `{roles:["user"], timeclockEnabled:false}`, manager com `{roles:["manager"], timeclockEnabled:false}`: `canOpen(step.route, ctx)` para todos os passos.
  - `ids and versions are valid` — regex `^[a-z0-9-]{1,64}$`, versão 1–999, ids distintos.
  - `manager tour starts with the collaborator steps and ends at /ajuda`.
  - `texts are short` — cada `text` tem no máximo 2 frases (contar `.`/`!`/`?` finais) e não contém "onboarding" nem "treinamento" (case-insensitive).
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Escrever `welcome.ts`** (textos pt-BR, imperativo, botões em `**negrito**`) e adicionar as âncoras nas páginas.
- [ ] **Step 4: Rodar** — `bun test` → PASS.
- [ ] **Step 5: Commit** — `feat(tour): tours de boas-vindas do colaborador e do gestor`.

---

### Task 7: `TourProvider`, ponte da sidebar e fiação

**Files:**
- Create: `frontend/src/help/TourProvider.tsx`, `frontend/src/help/progressQueue.ts`, `frontend/src/help/TourLayoutBridge.tsx`, `frontend/src/help/sidebarTarget.ts`
- Modify: `frontend/src/App.tsx` (`<TourProvider>` dentro do `AuthProvider`, envolvendo `<Routes>`)
- Modify: `frontend/src/components/AdminLayout.tsx` (renderiza `<TourLayoutBridge />` dentro do `SidebarProvider`)
- Modify: `frontend/src/contexts/AuthContext.tsx` (`queryClient.clear()` também em `signIn`/`signUp` antes de `loadMe`)
- Test: `frontend/src/help/progressQueue.test.ts`, `frontend/src/help/sidebarTarget.test.ts`

**Interfaces:**
- Consumes: `TourEngine` (Task 5), `tour` API e regras (Task 4), `screenName` (Task 3), `WELCOME_TOURS` (Task 6).
- Produces:
  ```ts
  // progressQueue.ts — fila serial que descarta envios de outro dono
  export function createProgressQueue(getOwner: () => string | undefined): {
    push(owner: string | undefined, send: () => Promise<unknown>): void;
    drain(): Promise<void>;
  };
  // sidebarTarget.ts — decisão pura do alvo
  export const MOBILE_MENU_TEXT = "No celular, toque no botão **☰** para abrir o menu.";
  export function sidebarTarget(element: string | undefined, s: { isMobile: boolean; collapsed: boolean }):
    { target: PreparedTarget; expand: boolean; closeMobile: boolean };
  // TourProvider.tsx
  export const TOUR_QUERY_KEY = "tour-progress";
  export function useTour(): {
    welcome: Tour | null; progress: TourProgress | null; loaded: boolean; active: boolean;
    startWelcome(): void;            // abre o diálogo de retomada se resumeStep !== null
    declineInvite(): Promise<void>; dismissInvite(): Promise<void>;
    registerLayout(hooks: LayoutHooks | null): void;
  };
  export interface LayoutHooks { prepare(element: string | undefined): Promise<PreparedTarget>; restore(): void }
  ```
  - `sidebarTarget`: elemento `menu`/`menu-*` no celular → `{ target: { element: "menu-mobile", extraText: MOBILE_MENU_TEXT }, expand: false, closeMobile: true }`; no computador recolhido → `expand: true`; outros elementos → `closeMobile: true`, alvo inalterado.
  - `TourLayoutBridge` usa `useSidebar()` e `useLayoutEffect` para registrar `LayoutHooks`; quando expande, marca num ref **do provider** (`expandedByTour`) e espera 320 ms; `restore()` chama `setOpen(false)` só se o provider marcou. O provider chama `restore()` do layout montado quando `active` vira `false`.
  - Provider: React Query `[TOUR_QUERY_KEY, user?.id]` (`enabled: !!user`); motor criado uma vez (`useMemo`) com refs para `navigate`, papel e dono; `onShow` empurra `tour.advance` na fila; `onComplete` drena a fila e chama `tour.complete` com 3 tentativas (espera `800 * n` ms); falha final → `toast` (sonner) "Não foi possível registrar o tour." com ação **Tentar de novo**; `onClose` invalida a query. Logout (`user` vira `null`) encerra o motor e limpa estado. Diálogo de retomada: `AlertDialog` "Continuar de onde parou?" com **Continuar do passo N**, **Recomeçar**, **Cancelar**.
- [ ] **Step 1: Write the failing tests**
  - `progressQueue`: `sends in push order even when first is slower` (duas promessas com atrasos invertidos; ordem de execução 1, 2); `skips sends whose owner changed` (`push("a", f)`; dono vira `"b"`; `f` não é chamado); `a failing send does not block the next`.
  - `sidebarTarget`: os três casos acima + `undefined` element (balão no centro) não expande nem troca alvo.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar** `progressQueue.ts`, `sidebarTarget.ts`, `TourLayoutBridge.tsx`, `TourProvider.tsx`, e as modificações listadas.
- [ ] **Step 4: Rodar** — `bun test && bun lint && bun run build` → PASS.
- [ ] **Step 5: Commit** — `feat(tour): provedor do tour e ponte com a sidebar`.

---

### Task 8: Convite no Dashboard e `/ajuda` mínima

**Files:**
- Create: `frontend/src/components/TourInvite.tsx`, `frontend/src/pages/HelpPage.tsx`
- Modify: `frontend/src/pages/DashboardPage.tsx` (`<TourInvite />` logo abaixo do cabeçalho, antes de `<PendingVideosCard />`), `frontend/src/App.tsx` (rota `/ajuda` com `<ProtectedRoute>`)
- Test: `frontend/src/components/TourInvite.test.tsx`

**Interfaces:**
- Consumes: `useTour()` (Task 7), `shouldInvite`, `resumeStep`, `tourStatus` (Task 4).
- Produces: `TourInvite` (sem props) e `HelpPage`.
  - `TourInvite` aparece só se `loaded && !active && shouldInvite(progress) && !snoozed`. "Agora não" grava `sessionStorage["talenths_tour_invite_snoozed_<userId>"] = "1"` (try/catch) e chama `declineInvite()`. Botões: **Começar** (ou **Continuar o tour** se `resumeStep !== null`), **Agora não**, **Não mostrar mais** (`dismissInvite()`). Card shadcn com título "Conheça o TalentHS" e uma frase.
  - `HelpPage` dentro de `AdminLayout`: título "Ajuda"; card "Tour de boas-vindas" com badge de `tourStatus` (Concluído em dd/mm/aaaa · Parou no passo N de M · Você ainda não fez) mostrado **só quando `loaded`**; botão **Fazer o tour de boas-vindas** (`data-tour="help-start-tour"`) → `startWelcome()`.
- [ ] **Step 1: Write the failing tests** (Testing Library, `useTour` mockado)
  - `hidden while progress not loaded`.
  - `shows Começar without progress`, `shows Continuar o tour when resumable`.
  - `Agora não hides and declines` — chama `declineInvite` e some; remontar com o mesmo `sessionStorage` continua escondido.
  - `Não mostrar mais calls dismissInvite`.
  - `hidden after 3 declines` (`invites_declined: 3`).
  - `hidden while tour active`.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar.**
- [ ] **Step 4: Rodar** — `bun test && bun lint && bun run build` → PASS.
- [ ] **Step 5: Commit** — `feat(tour): convite no dashboard e página de ajuda`.

---

### Task 9: Verificação na tela, changelog e versão

**Files:**
- Modify: `frontend/src/components/ChangelogModal.tsx` (entrada `v1.10.0`, `20/10/2026`, `current: true`; remove `current` da v1.9.0), `frontend/src/components/AdminSidebar.tsx` (`TalentHS v1.10.0`), `frontend/package.json` (`"version": "1.10.0"`)
- Modify: `CLAUDE.md` do repo — seção curta "Tour e Ajuda": alvos só por `data-tour`; tela citada num tour muda no mesmo commit que o tour (e, a partir da fase 2, que o guia); contratos em `src/help/**/*.test.ts`.

- [ ] **Step 1: Subir o app local** (skill `run`) com backend apontando para o banco de teste (`test-db.sh`) e dois usuários criados (um `user`, um `manager`).
- [ ] **Step 2: Percorrer na tela, com Playwright**, e anotar cada defeito antes de corrigir:
  - os dois tours inteiros no computador (sidebar aberta), com páginas vazias;
  - sidebar **recolhida** → expande nos passos de menu e volta recolhida ao concluir e ao fechar no meio;
  - largura de celular (390 px) → passos de menu destacam o ☰ com o texto extra; nenhum passo trava;
  - fechar no passo 4, abrir outra aba → `/ajuda` mostra "Parou no passo 4 de N"; **Fazer o tour** → diálogo de retomada continua do 4;
  - **Agora não** 3 vezes (abas novas) → convite some de vez; **Não mostrar mais** → some e `/ajuda` ainda refaz o tour;
  - logout no meio do tour → nada quebra; login com outro usuário → convite próprio;
  - tema escuro → balão legível.
- [ ] **Step 3: Corrigir o que apareceu**, cada correção com teste quando for lógica (motor, provider, regras).
- [ ] **Step 4: Changelog** — entradas pt-BR para o usuário final:
  - novidade: "Tour de boas-vindas: um passeio guiado pelas principais telas do TalentHS, incluindo onde encontrar os vídeos que você precisa assistir."
  - novidade: "Nova página Ajuda no menu, de onde você refaz o tour quando quiser."
- [ ] **Step 5: Rodar tudo** — `cd backend && pytest tests -v`; `cd frontend && bun test && bun lint && bun run build` → PASS.
- [ ] **Step 6: Commit** — `feat(tour): v1.10.0 — tour de boas-vindas`.
