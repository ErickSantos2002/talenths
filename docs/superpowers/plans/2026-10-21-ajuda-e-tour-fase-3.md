# Ajuda e Tour — Fase 3 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tours curtos por tela ("Mostrar nesta tela"), "O que mudou" para quem concluiu um tour numa versão anterior, e a tela **Adoção do tour** para o RH. Entrega v1.12.0.

**Architecture:** O motor (`help/tourEngine.ts`) passa a aceitar passo sem `route` (não navega), o que permite tours por tela. As regras novas são funções puras em `help/tourRules.ts`. Os tours por tela ficam em `help/tours/screenTours.ts`, ligados ao guia da tela pelo campo `tour` do front matter. O `TourProvider` ganha `showScreenTour`, `viewWhatsNew` e `dismissWhatsNew`. O `HelpButton` ganha a seção "O que mudou", o botão **Mostrar nesta tela** e um ponto no "?". A adoção é uma rota de leitura `GET /tour/adoption` (uma consulta só) e uma página `/admin/tour` que filtra e exporta CSV no cliente.

**Tech Stack:** React 18 + TS + Vite, shadcn/ui (`Table`, `Select`, `Card`, `Badge`), React Query 5, driver.js 1.8.0 (já instalado), vitest; FastAPI + asyncpg, pytest (`backend/tests/db/`).

**Spec:** `docs/superpowers/specs/2026-10-20-ajuda-e-tour-design.md`: seções "Tour (fases 1, 2 e 3)" (disparos 3 e 4, "Tours por tela"), "Tela de adoção (fase 3)", "Backend" e "Testes", mais a **Revisão do Erick** no topo, que torna o tour de boas-vindas obrigatório. Referência de código, só leitura e de outro repo: `~/github/docshs/frontend/src/ajuda/tutorialNucleo.ts` (`oQueMudou`, `tourDaTela`), `tours/porTela.ts`, `tours/tipos.ts`, `motorDoTour.ts` (`soOQueEstaNaTela`), `ProvedorDoTour.tsx` (`mostrarTour`, `verOQueMudou`, `dispensarOQueMudou`), `~/github/docshs/frontend/src/componentes/BotaoDeAjuda.tsx` e `~/github/docshs/frontend/src/ajuda/guias/administracao/adocao-do-tutorial.md`.

## Decisões deste plano (tomadas pelo Claude, conferir)

- **Situações da adoção: só três**, que são **Concluído**, **Em andamento** e **Não começou**. Sai "Dispensado" e saem as "recusas" do spec: com o tour obrigatório, nenhuma tela grava `dismissed_at` nem `invites_declined`.
- **A exportação é CSV gerado no navegador**, a partir das linhas já carregadas e com os filtros aplicados. Segue o formato dos relatórios (`;`, BOM UTF-8), como pede "seguir o que `reports.py` já usa". O spec previa `.xlsx` e `GET /tour/adoption/export`, mas o "passo N de M" depende do número de passos, que só o frontend conhece. Fazer a exportação no backend duplicaria esse número.
- **Tours por tela gravam progresso** com o próprio `id` (mesma tabela e rotas), como no DocsHS. Assim o "O que mudou" vale também para eles quando a tela mudar. Eles sempre começam do primeiro passo, sem diálogo de retomada.
- **Lista de tours por tela:** Minha Avaliação, Meu PDI, vídeo aberto (`/videos/:id`), Vídeos (admin), Avaliação (admin) e Mapa 9Box, que são as candidatas do spec.
- **O tour de boas-vindas continua na versão 2.** A tela de adoção não entra nele. Se o Erick quiser um passo para ela, é `since: 3`, e o "O que mudou" leva esse passo aos gestores.

## Global Constraints

- Código em inglês, interface e guias em pt-BR. Nunca usar "onboarding" nem "treinamento" para o recurso novo: ele se chama **Tour** e **Ajuda**.
- Alvos só por `data-tour="..."` (kebab-case, `^[a-z0-9-]+$`). Tela que ganha âncora muda no mesmo commit que o tour e o guia dela (regra do `CLAUDE.md`, seção "Tour e Ajuda").
- Textos dos passos: 1–2 frases, imperativo, nome do botão em `**negrito**` como aparece na tela, escritos **a partir do código da tela**. Não inventar função que a tela não tem.
- Tour por tela: `id` no formato `tela-<slug>` (`^[a-z0-9-]{1,64}$`), `version` começa em 1, não navega, sempre do primeiro passo e só com os passos cujo elemento está visível ao começar.
- "O que mudou" só para quem **concluiu** uma versão menor que a atual e tem passos com `since` maior que essa versão. Quem não concluiu o boas-vindas continua no modal obrigatório da fase 1, sem mudança.
- Requisições do tour não entram no log de auditoria (`_SKIP_PATTERNS` já cobre `PUT|POST /tour/progress/`). `GET /tour/adoption` é leitura normal e entra.
- `/admin/tour` só para `manager` e `master_admin`. Item de menu **Adoção do tour**, seção **Sistema**, ícone `UserCheck` do lucide (`ListChecks` já é do Onboarding).
- Sem CSS customizado novo. O ponto no "?" é um `span` com classes Tailwind (`bg-primary`, `rounded-full`, `h-2 w-2`) e `sr-only` "(há novidades)".
- Versão **v1.12.0** nos 3 lugares do `CLAUDE.md`, com a data do dia da entrega.
- Testes: frontend `bun run --cwd frontend test` (`bun test` é o runner errado); backend com banco de teste próprio: `TEST_DB_NAME=talenths_test_f3 bash backend/scripts/test-db.sh` e, de `backend/`, `DATABASE_URL=postgresql://erick:dev123@localhost:5432/talenths_test_f3 JWT_SECRET=test-secret TEST_DATABASE_URL=<mesma> .venv/bin/python -m pytest tests -q`. O lint não pode passar da linha de base atual, 53 problemas: `bun run --cwd frontend lint`.

## Review Focus

1. Quem concluiu a v1 e agora vê a v2: aparece o ponto no "?", e **Ver o que mudou** mostra só o passo `since: 2`. Ao concluir, o servidor fica com `version = 2` e o ponto some. **Dispensar** faz o mesmo sem rodar o tour (testes nas Tasks 2 e 4).
2. Tour por tela numa tela onde parte dos blocos não aparece (lista vazia, papel que não vê o bloco): esses passos saem. Se nenhum sobra, aparece o toast "Nada para mostrar nesta tela agora." e o tour não começa (testes nas Tasks 1 e 4).
3. A pessoa sai da tela no meio de um tour por tela (voltar do navegador, link): o tour fecha e não fica um balão órfão em outra tela (teste na Task 4).
4. Pessoa promovida de colaborador a gestor: na adoção aparece o tour **do papel atual**, "Não começou" mesmo tendo concluído o do colaborador (teste na Task 5).
5. Gestor da empresa A não vê ninguém da empresa B. Colaborador chamando `GET /tour/adoption` recebe 403 (teste na Task 5).

---

### Task 1: Motor e regras puras

**Files:**
- Modify: `frontend/src/help/tours/types.ts`, `frontend/src/help/tourEngine.ts`, `frontend/src/help/tourRules.ts`
- Test: `frontend/src/help/tourEngine.test.ts`, `frontend/src/help/tourRules.test.ts`

**Interfaces:**
- Consumes: `Tour`, `TourStep`, `TourProgress`, `AppRole`.
- Produces:
  ```ts
  // types.ts
  export interface TourStep { route?: string; element?: string; title: string; text: string; interact?: boolean; since?: number }
  export interface ScreenTour { id: string; version: number; screen: string; roles: AppRole[]; steps: Omit<TourStep, "route" | "interact">[] }
  // tourEngine.ts
  export function onlyPresent(t: Tour): Tour;   // remove passos com `element` sem elemento visível agora; passos sem `element` ficam
  // tourRules.ts
  export function whatsNew(t: Tour, progress: TourProgress | null): Tour | null;
  export function screenTourFor(tours: ScreenTour[], screenPath: string | null, roles: AppRole[]): ScreenTour | null;
  export function asTour(s: ScreenTour): Tour;  // { id, version, steps } sem route
  ```

- [ ] **Step 1: Write the failing tests**

`tourRules.test.ts`:
- `whatsNew`: `null` sem progresso, sem `completed_at`, ou com `progress.version >= t.version`. Com o tour na v2 (passos sem `since` e um com `since: 2`) e o progresso concluído na v1, devolve `{ id, version: 2, steps: [só o since 2] }`. Se a versão subiu sem passo novo, devolve `null`.
- `screenTourFor`: acha pela `screen` exata e por papel (`roles` com qualquer papel em comum). `null` para `screenPath` nulo, outro papel ou tela sem tour.

`tourEngine.test.ts`:
- `onlyPresent`: em jsdom com `<div data-tour="a">` visível e sem `b`, um tour `[a, b, sem element]` vira `[a, sem element]`. Usar o mesmo critério de visível que `findVisible`, porque o jsdom não tem layout. Se o teste existente já simula visibilidade, seguir o mesmo truque.
- Passo sem `route`: `start` não chama `navigate` e o texto não ganha "Vamos para". Passo com `route` igual ao da tela seguinte continua sem "Vamos para", e passo com rota diferente continua com.

- [ ] **Step 2: Rodar e ver falhar.** `bun run --cwd frontend test -- tourRules tourEngine`. FAIL nas funções inexistentes.

- [ ] **Step 3: Implementar.** No motor, `if (step.route && window.location.pathname !== step.route)` e o "Vamos para" só quando os dois passos têm `route` e elas diferem. `onlyPresent` reusa `findVisible`.

- [ ] **Step 4: Rodar e ver passar**, junto com `welcome.contract.test.ts`, que precisa continuar verde: os passos de boas-vindas seguem com `route`. Se o contrato exige `route` por tipo, garanta isso no teste (`expect(step.route).toBeTruthy()`).

- [ ] **Step 5: Commit.** `feat(tour): passo sem rota, recorte do que mudou e tour da tela`

---

### Task 2: Provedor (tour por tela e "O que mudou")

**Files:**
- Modify: `frontend/src/help/TourProvider.tsx`
- Test: `frontend/src/help/TourProvider.test.tsx` (novo; seguir o padrão de mocks de `HelpButton.test.tsx` para `useAuth` e `@/lib/api`)

**Interfaces:**
- Consumes: Task 1 (`whatsNew`, `onlyPresent`, `asTour`, `ScreenTour`).
- Produces, no `TourContextValue`:
  ```ts
  progressAll: TourProgress[];                 // query.data ?? []
  showScreenTour(s: ScreenTour): void;          // onlyPresent(asTour(s)); vazio → toast "Nada para mostrar nesta tela agora."
  viewWhatsNew(cut: Tour): void;                // boas-vindas: start(cut, 0); tour de tela: onlyPresent primeiro; vazio → complete(cut) sem rodar
  dismissWhatsNew(cut: Tour): void;             // complete(cut) sem rodar
  ```

- [ ] **Step 1: Write the failing tests** (mock de `TourEngine` com `start`/`stop` espiões e de `tour.complete`/`tour.advance`):
- `dismissWhatsNew(cut)` chama `tourApi.complete(cut.id, cut.version)` uma vez e invalida a query.
- `showScreenTour` com nenhum elemento presente: `engine.start` não é chamado e `toast` recebe "Nada para mostrar nesta tela agora.".
- `showScreenTour` com elemento presente: `engine.start` recebe só os passos presentes, a partir do 0.
- Tour por tela ativo e mudança de `pathname` (renderizar com `MemoryRouter` e navegar): `engine.stop` é chamado e `active` volta a `false`. Tour de boas-vindas ativo e mudança de `pathname`: `stop` **não** é chamado, porque o boas-vindas navega sozinho.

- [ ] **Step 2: Rodar e ver falhar.**

- [ ] **Step 3: Implementar.** Guardar em `runningRef` se o percurso é de tela, com um `screenPathRef` com o padrão em que começou. Um efeito em `useLocation().pathname` chama `engine.stop()` e `onClose` quando `matchScreen(pathname)?.path` difere do padrão. `onShow` e `complete` continuam iguais e usam `t.id`/`t.version` do percurso, então o recorte conclui a versão atual.

- [ ] **Step 4: Rodar e ver passar**, com a suíte inteira.

- [ ] **Step 5: Commit.** `feat(tour): mostrar nesta tela e o que mudou no provedor`

---

### Task 3: Tours por tela, âncoras e ligação com os guias

**Files:**
- Create: `frontend/src/help/tours/screenTours.ts`, `frontend/src/help/tours/screenTours.contract.test.ts`
- Modify: as 6 páginas (`data-tour` nos blocos); `frontend/src/help/guideParser.ts` e `guides.ts` (campo opcional `tour` → `Guide.tour?: string`); os 6 guias das telas (`tour: tela-...` no front matter e uma linha "Clique no **?** e em **Mostrar nesta tela** para um passeio rápido por esta tela." em "Para que serve"). O vídeo aberto não tem guia próprio, e o tour `tela-video` liga ao guia `comunicacao/videos.md`, que ganha `/videos/:id` em `telas` se ainda não tiver.

**Interfaces:**
- Consumes: `ScreenTour` (Task 1), `SCREENS`, `canOpen`.
- Produces: `export const SCREEN_TOURS: ScreenTour[]` com ids `tela-minha-avaliacao` (`/minha-avaliacao`, ALL), `tela-meu-pdi` (`/meu-pdi`, ALL), `tela-video` (`/videos/:id`, ALL), `tela-admin-videos` (`/admin/videos`, ADMIN), `tela-admin-avaliacao` (`/admin/avaliacao`, ADMIN), `tela-admin-9box` (`/admin/9box`, ADMIN). ALL = `["master_admin", "manager", "user"]`, ADMIN = `["master_admin", "manager"]`, escritos por extenso (as constantes de `screens.ts` não são exportadas). Cada um tem de 3 a 6 passos, version 1, com âncoras novas prefixadas pela tela (ex.: `pdi-actions`, `video-player`).

- [ ] **Step 1: Write the failing contract test** (`screenTours.contract.test.ts`, mesmo leitor de `data-tour` de `welcome.contract.test.ts`, extraído para um helper `tours/anchors.ts` se for duplicar):
- ids únicos, `^[a-z0-9-]{1,64}$`, distintos dos ids de boas-vindas;
- `screen` é `path` de `SCREENS`; cada papel em `roles` abre a tela (`canOpen(screen, { roles: [r], timeclockEnabled: true })`);
- todo `element` existe como `data-tour` em algum `.tsx`; nenhum texto tem `<`; nenhum passo tem `route`;
- todo tour é citado por `tour:` em ao menos um guia cujo `telas` inclui a `screen`, e todo `tour:` de guia aponta para um id de `SCREEN_TOURS`. Ler os `.md` com `import.meta.glob` e `parseGuide`, como `guides.contract.test.ts`.

- [ ] **Step 2: Rodar e ver falhar.**

- [ ] **Step 3: Implementar.** Ler cada página, pôr `data-tour` só em blocos que existem para os papéis do tour e escrever os passos a partir do que o bloco faz. Passo de bloco que só aparece numa situação (ex.: avaliação aberta) é escrito sem supor a situação, porque `onlyPresent` o remove quando o bloco não está na tela. Ajustar os guias, refazer a captura de cada guia tocado só se a âncora mudou algo visível (não deve) e manter `guides.contract.test.ts` verde.

- [ ] **Step 4: Rodar e ver passar** (`bun run --cwd frontend test`), mais `npx tsc --noEmit -p tsconfig.app.json` sem erro novo nos arquivos tocados.

- [ ] **Step 5: Commit.** `feat(tour): tours curtos para seis telas densas`

---

### Task 4: "?" com "O que mudou", "Mostrar nesta tela" e ponto

**Files:**
- Modify: `frontend/src/help/HelpButton.tsx`, `frontend/src/help/HelpButton.test.tsx`

**Interfaces:**
- Consumes: Task 1 (`whatsNew`, `screenTourFor`), Task 2 (`progressAll`, `welcome`, `showScreenTour`, `viewWhatsNew`, `dismissWhatsNew`), Task 3 (`SCREEN_TOURS`), `matchScreen`.
- Produces: nada para outras tasks.

Comportamento: `screen = matchScreen(pathname)?.path ?? null`, `screenTour = screenTourFor(SCREEN_TOURS, screen, roles)`. Os recortes, em ordem: `whatsNew(welcome, progress)` e, se houver `screenTour`, `whatsNew(asTour(screenTour), progressOf(screenTour.id))`. Ponto no "?" quando há recorte. O painel mostra, no topo e antes do guia, um bloco por recorte: "**O que mudou**", uma frase ("O tour de boas-vindas ganhou N passo(s) novo(s)." ou "O tour desta tela ganhou N passo(s) novo(s).") e os botões **Ver o que mudou** e **Dispensar**. Se houver `screenTour`, o botão **Mostrar nesta tela** fica abaixo do título. O painel fecha ao clicar em qualquer um desses botões, como já fecha quando o tour começa. Tudo isso aparece sem esperar os guias carregarem.

- [ ] **Step 1: Write the failing tests:**
- progresso de boas-vindas concluído na v1 com tour v2: o botão "?" tem o ponto (`getByText("(há novidades)")`); o painel mostra "O que mudou"; **Ver o que mudou** chama `viewWhatsNew` com 1 passo e **Dispensar** chama `dismissWhatsNew`;
- concluído na v2: sem ponto e sem bloco;
- em `/meu-pdi` como `user`: **Mostrar nesta tela** chama `showScreenTour` com `tela-meu-pdi`; em `/dashboard` o botão não aparece;
- em `/admin/videos` como `user` (a rota não abre para o papel, mas o teste pode forçar o pathname): o botão não aparece.

- [ ] **Step 2: Rodar e ver falhar.** **Step 3: Implementar.** **Step 4: Rodar e ver passar.**

- [ ] **Step 5: Commit.** `feat(ajuda): o que mudou e mostrar nesta tela no botão de ajuda`

---

### Task 5: Backend da adoção

**Files:**
- Modify: `backend/app/routers/tour.py`
- Create: `backend/tests/db/test_tour_adoption.py`
- Create: `frontend/src/help/tours/backend.contract.test.ts`

**Interfaces:**
- Produces:
  ```python
  WELCOME_TOUR_IDS = {"collaborator": "boas-vindas-colaborador", "manager": "boas-vindas-gestor"}

  class AdoptionRow(BaseModel):
      user_id: str; name: str; email: str | None
      department_id: str | None; department: str | None
      audience: Literal["collaborator", "manager"]; tour: str
      version: int | None; step: int | None
      started_at: datetime | None; completed_at: datetime | None
      status: Literal["completed", "in_progress", "not_started"]

  # GET /tour/adoption -> list[AdoptionRow], ordenado por name; require_manager (app.dependencies)
  ```
  Uma consulta: `profiles p` da empresa do gestor, `LEFT JOIN departments`, o público pelo `bool_or(role IN ('manager','master_admin'))` de `user_roles` (subconsulta lateral), e `LEFT JOIN tour_progress tp ON tp.user_id = p.user_id AND tp.tour = CASE ... END` com os ids como parâmetros. A situação é calculada no SQL: `completed_at` → completed, `started_at` → in_progress, senão not_started.

- [ ] **Step 1: Write the failing tests** (fixture `client_as` e o padrão dos testes de `test_tour_*.py` existentes):
- gestor vê todos da própria empresa, com `status` certo para concluído, em andamento (`step` presente) e sem linha;
- pessoa com `manager` aparece com `tour == "boas-vindas-gestor"`. Ela concluiu `boas-vindas-colaborador` e não o de gestor, e aparece como `not_started`;
- gestor de outra empresa não vê ninguém da primeira;
- colaborador → 403;
- `GET /tour/adoption` não cria linha em `tour_progress`.
- Frontend `backend.contract.test.ts`: lê `backend/app/routers/tour.py` como texto (`fs` + caminho relativo ao arquivo de teste) e confere que os valores de `WELCOME_TOUR_IDS` são `WELCOME_TOURS.collaborator.id` e `WELCOME_TOURS.manager.id`.

- [ ] **Step 2: Rodar e ver falhar.** **Step 3: Implementar.** **Step 4: Rodar e ver passar** (backend inteiro e frontend inteiro).

- [ ] **Step 5: Commit.** `feat(tour): rota de adoção do tour de boas-vindas`

---

### Task 6: Tela "Adoção do tour"

**Files:**
- Create: `frontend/src/pages/TourAdoptionPage.tsx`, `frontend/src/pages/TourAdoptionPage.test.tsx`, `frontend/src/help/tourAdoption.ts` (regras puras), `frontend/src/help/tourAdoption.test.ts`
- Modify: `frontend/src/lib/api.ts` (`tour.adoption()` e o tipo `TourAdoptionRow`), `frontend/src/App.tsx` (rota `/admin/tour` com o mesmo guarda das outras `/admin/*`), `frontend/src/help/screens.ts` (`item("/admin/tour", "Adoção do tour", UserCheck, "sistema", ADMIN)`, antes de Relatórios)
- Create: `frontend/src/help/guides/administracao/adocao-do-tour.md` (`papeis: [manager, master_admin]`, `telas: [/admin/tour]`), a entrada em `frontend/scripts/captures.config.ts` e a captura `frontend/public/capturas/adocao-do-tour.webp`
- Modify: `backend/scripts/seed_captures.py`. Nem todo mundo conclui: das pessoas da semente que **não** são `ana`, `bruno`, `gestor` e `admin`, uma fica em andamento no passo 4 e uma fica sem linha. As quatro contas de login continuam concluídas.

**Interfaces:**
- Consumes: Task 5 (`GET /tour/adoption`), `WELCOME_TOURS` (total de passos por público), `tourStatus` não (a linha não é `TourProgress`).
- Produces (`tourAdoption.ts`):
  ```ts
  export type AdoptionStatus = "completed" | "in_progress" | "not_started";
  export const STATUS_LABEL: Record<AdoptionStatus, string>; // "Concluído" | "Em andamento" | "Não começou"
  export function filterRows(rows: TourAdoptionRow[], f: { department: string | "all"; status: AdoptionStatus | "all" }): TourAdoptionRow[];
  export function totals(rows: TourAdoptionRow[], department: string | "all"): Record<AdoptionStatus, number> & { total: number }; // só o filtro de departamento
  export function stepLabel(row: TourAdoptionRow): string; // in_progress → "Passo N de M" (N = step + 1, M = WELCOME_TOURS[audience].steps.length); demais → ""
  export function toCsv(rows: TourAdoptionRow[]): string;  // BOM + ";" ; colunas: Nome;E-mail;Departamento;Tour;Situação;Passo;Concluído em (dd/mm/aaaa)
  ```

Tela: título "Adoção do tour" com `data-tour="admin-tour-adoption"`; uma frase explicando que mostra quem já fez o tour de boas-vindas do papel atual; 4 cards de totais (Total, Concluído, Em andamento, Não começou); `Select` de departamento ("Todos os departamentos" + os presentes nas linhas) e de situação ("Todas as situações"); `Table` com Nome, Departamento, Tour ("Colaborador"/"Gestor"), Situação (`Badge`), Passo, Concluído em; botão **Exportar CSV** (`adocao-do-tour.csv`). Estados de carregando (`Skeleton`), erro (mensagem + **Tentar de novo**) e lista vazia ("Ninguém nesta seleção.").

- [ ] **Step 1: Write the failing tests:** `tourAdoption.test.ts` (filtro combinado, totais ignorando a situação, `stepLabel` com 0 → "Passo 1 de M", CSV com BOM, `;`, aspas escapadas e data dd/mm/aaaa) e `TourAdoptionPage.test.tsx` (com a API mockada: linhas renderizadas, filtro por situação reduz a tabela e mantém os totais, e erro mostra **Tentar de novo**).
- [ ] **Step 2: Rodar e ver falhar.** **Step 3: Implementar.** O guia segue o modelo dos outros (Para que serve · Quando usar · Passo a passo · O que acontece depois · Dúvidas comuns). Nas dúvidas, diz que o tour é obrigatório para todos e que "concluído" é o que a própria pessoa fez no sistema, não um treinamento formal.
- [ ] **Step 4: Gerar a captura**, seguindo os passos de "Capturas dos guias" no `CLAUDE.md`: `bun run --cwd frontend capturas -- --only adocao-do-tour`. **Abrir a imagem e olhar** antes de commitar. Rodar a suíte inteira, com os contratos de guias, capturas e telas.
- [ ] **Step 5: Commit.** `feat(ajuda): tela de adoção do tour para o RH`

---

### Task 7: Guias, CLAUDE.md, changelog e verificação na tela

**Files:**
- Modify: `frontend/src/help/guides/primeiros-passos/ajuda-desta-tela.md` (seções **Mostrar nesta tela** e **O que mudou** e o ponto no "?"), `primeiros-passos/o-tour-de-boas-vindas.md` (o "O que mudou" quando o tour ganha passo novo)
- Modify: `CLAUDE.md`, seção "Tour e Ajuda", com 2 linhas: (1) tour por tela fica em `help/tours/screenTours.ts`, ligado ao guia por `tour:`, e a tela dele muda no mesmo commit que ele; (2) passo novo em tour já publicado leva `since: <nova versão>` e sobe `version`, e quem concluiu vê pelo "O que mudou". Remover ou subir passo sem `since` não aparece para quem concluiu.
- Modify: `frontend/src/components/ChangelogModal.tsx`, `frontend/src/components/AdminSidebar.tsx`, `frontend/package.json` → **v1.12.0**. Entradas `novidade`: "Botão **Mostrar nesta tela** na ajuda (?) de seis telas: um passeio rápido pelos blocos da tela.", "Quando o tour ganha algo novo, um ponto no (?) mostra só o que mudou.", "Nova tela **Adoção do tour** para o RH acompanhar quem já fez o tour de boas-vindas."

- [ ] **Step 1:** Atualizar os guias e manter `guides.contract.test.ts` verde. Refazer as capturas desses guias se mostrarem o painel do "?" (`bun run --cwd frontend capturas -- --only <nomes>`) e olhar as imagens.
- [ ] **Step 2:** Changelog e versão nos 3 lugares. Suíte inteira (frontend e backend), `bun run --cwd frontend build` e lint em ≤ 53.
- [ ] **Step 3: Verificação na tela**, obrigatória pelo spec, com o app local contra o banco de capturas (`ana@` e `gestor@exemplo.com.br`, senha `exemplo123`):
  - como `ana`, depois de baixar o progresso do boas-vindas para v1 concluído no banco de capturas (`UPDATE tour_progress SET version = 1 ...`, só no `talenths_capturas`): aparece o ponto no "?", **Ver o que mudou** destaca o "?", ao concluir o ponto some e um recarregar mantém;
  - **Mostrar nesta tela** em cada uma das 6 telas, no computador (sidebar aberta e recolhida) e no celular (375 px). Fechar no meio com Esc e voltar do navegador no meio;
  - como `gestor`: **Adoção do tour** no menu, filtros, totais e **Exportar CSV**, abrindo o arquivo e conferindo os acentos.
  Registrar o que foi visto, e qualquer defeito vira correção antes do commit.
- [ ] **Step 4: Commit.** `docs(ajuda): guias do que mudou e da tela, versão 1.12.0`

**Deploy:** nada de migração. Subir primeiro o backend e depois o frontend, porque a tela de adoção usa a rota nova.
