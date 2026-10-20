# Ajuda e Tour — Fase 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Central de Ajuda completa (guias em Markdown para todas as telas, com capturas automáticas, busca e filtro por papel) e botão "?" com o guia da tela atual — entrega v1.11.0.

**Architecture:** Guias são arquivos `.md` versionados em `frontend/src/help/guides/<modulo>/<slug>.md`, carregados sob demanda num chunk separado (`import.meta.glob` com `?raw` atrás de `import()`), validados com zod e renderizados com `react-markdown` (sem HTML cru). A tabela única de telas (`help/screens.ts`, fase 1) decide quais guias cada pessoa vê e qual guia o "?" abre. Capturas `.webp` são geradas por um script `playwright-core` contra um banco local com dados fictícios e commitadas em `frontend/public/capturas/`.

**Tech Stack:** React 18 + TS + Vite, shadcn/ui (`Sheet`, `Card`, `Input`), React Router 6, React Query 5, `react-markdown` 10 (já instalado), zod (já instalado), `yaml` (novo, versão exata), `playwright-core` (novo, devDependency, versão exata) usando o Chrome do sistema (`/usr/bin/google-chrome`), vitest; backend FastAPI só para a semente de capturas.

**Spec:** `docs/superpowers/specs/2026-10-20-ajuda-e-tour-design.md` (seções "Ajuda (fase 2)", "Capturas automáticas (fase 2)", "Tabela única de telas", "Testes"; e a **Revisão do Erick** no topo: o tour de boas-vindas é obrigatório, em modal). Referência de código (só leitura, outro repo): `~/github/docshs/frontend/src/ajuda/` (`guiasNucleo.ts`, `guias.ts`, `guiasEmbutidos.ts`, `ConteudoDoGuia.tsx`, `paginas/Ajuda.tsx`, `paginas/AjudaGuia.tsx`, `componentes/BotaoDeAjuda.tsx`), `~/github/docshs/frontend/scripts/capturas.ts` e `capturas.config.ts`, `~/github/docshs/backend/app/semente_capturas.py`. Exemplos de guia: `~/github/docshs/frontend/src/ajuda/guias/**/*.md`.

## Global Constraints

- Código e identificadores em inglês; interface e guias em pt-BR. Nunca "onboarding" (é o nome do checklist de RH existente — guias **sobre** essa tela usam o nome dela, "Onboarding"/"Meu Onboarding") nem "treinamento" fora disso.
- Guias: um por tela de menu no mínimo; modelo **Para que serve · Quando usar · Passo a passo (com capturas) · O que acontece depois · Dúvidas comuns**; imperativo; nome do botão em `**negrito**` exatamente como na tela; primeiro rascunho escrito a partir do código da tela (não inventar função que a tela não tem).
- Front matter (YAML, validado com zod, erro de validação quebra o build de teste): `titulo` (string), `modulo` (um dos `MODULES`), `papeis` (array de `AppRole`), `telas` (array de `path` existentes em `SCREENS`), `ordem` (inteiro). Sem campo `tour` nesta fase.
- Módulos, nesta ordem: `primeiros-passos` "Primeiros passos", `meu-espaco` "Meu Espaço", `desempenho` "Desempenho", `desenvolvimento` "Desenvolvimento", `comunicacao` "Comunicação", `rh` "RH", `administracao` "Administração" (todas as telas `/admin/*`).
- Guia visível se o papel está em `papeis` **e** a pessoa abre todas as `telas` (`canOpen` com `{ roles, timeclockEnabled }`). Guia de outro papel aberto por link → "Guia não encontrado".
- Markdown: sem HTML cru (texto); links internos `/…` navegam pelo router; externos só `https://` com `target="_blank" rel="noreferrer"`; imagem só `/capturas/<kebab>.webp` com `alt` não vazio, `loading="lazy"`; qualquer outra coisa vira texto. Sem `dangerouslySetInnerHTML`.
- Busca no cliente, sem acento e sem caixa, todos os termos; acertos no título primeiro; consulta em `?busca=` (`replace`); região `aria-live="polite"` com "N guias encontrados" / "Nenhum guia encontrado".
- Capturas em `frontend/public/capturas/` (**nunca** `public/ajuda/` — o nginx redireciona `/ajuda` → `/ajuda/`). Tema claro, 1280×800, `.webp` qualidade 0.82. Banco de capturas: o nome tem de conter `capturas`, senão a semente recusa. Só dado fictício (`@exemplo.com.br`).
- "?" no `<header>` do `AdminLayout`, ao lado do sino, `data-tour="help-button"`, `aria-label="Ajuda desta tela"`; abre `Sheet` à direita; fecha ao trocar de rota e quando um tour começa.
- Tour de boas-vindas vai para **versão 2** com um passo novo no fim (`since: 2`) destacando o "?". O modal obrigatório da fase 1 continua: só `completed_at` libera.
- Nada de CSS customizado: tipografia do guia com `@tailwindcss/typography` (`prose`, `dark:prose-invert`), já instalado.
- Versão **v1.11.0**, data do dia da entrega, nos 3 lugares do `CLAUDE.md`.

## Review Focus

1. Pessoa colaboradora abre por link um guia de `/admin/...` → "Guia não encontrado", sem vazar título nem trecho (teste na Task 3).
2. Guia com Markdown malicioso (`<script>`, `javascript:` em link, imagem externa) → aparece como texto, nada executa nem carrega (teste na Task 2).
3. Tela sem guia próprio (ex.: `/videos/:id`, `/meus-testes/:testId/realizar`) → o "?" mostra os guias do módulo e, sem módulo, "Primeiros passos"; nunca painel vazio (teste na Task 4).
4. "?" aberto e a pessoa clica num item do menu ou começa o tour pela Ajuda → o painel fecha e não fica por cima do balão do tour (teste na Task 4 + verificação na tela na Task 9).
5. Busca "avaliacao" encontra "Avaliação"; busca vazia não lista "0 guias"; busca sem resultado mostra a mensagem e mantém os cards dos módulos acessíveis (teste na Task 3).

---

### Task 1: Núcleo dos guias e paridade de papéis

**Files:**
- Modify: `frontend/package.json` (`yaml` versão exata, `bun add yaml@<atual> --exact`)
- Create: `frontend/src/help/guides.ts`, `frontend/src/help/guidesBundle.ts`, `frontend/src/help/guides/primeiros-passos/o-tour-de-boas-vindas.md` (guia real, serve de fixture)
- Modify: `frontend/src/help/screens.ts` (exportar `matchScreen(pathname): Screen | null` usando `matchPath` do react-router; documentar que `screenName`/`canOpen` recebem padrões)
- Test: `frontend/src/help/guides.test.ts`, `frontend/src/help/screens.test.ts` (paridade de papéis)

**Interfaces:**
- Consumes: `SCREENS`, `canOpen`, `ScreenContext`, `AppRole` (fase 1, `help/screens.ts`).
- Produces:
  ```ts
  // guides.ts
  export const MODULES: readonly { id: ModuleId; name: string }[];
  export type ModuleId = "primeiros-passos" | "meu-espaco" | "desempenho" | "desenvolvimento" | "comunicacao" | "rh" | "administracao";
  export interface Guide { module: ModuleId; slug: string; title: string; roles: AppRole[]; screens: string[]; order: number; body: string; searchText: string }
  export function parseGuide(path: string, raw: string): Guide;            // lança Error com o path se o front matter for inválido
  export function normalize(text: string): string;                        // NFD sem diacríticos, minúsculo
  export function guidesFor(all: Guide[], ctx: ScreenContext): Guide[];   // filtro de papel + canOpen de todas as telas, ordenado por módulo, order, title
  export function searchGuides(visible: Guide[], query: string): Guide[]; // [] para consulta vazia; título primeiro
  export function guidesForPath(visible: Guide[], pathname: string): { main: Guide | null; others: Guide[]; origin: "screen" | "module" | "first-steps" };
  export function findGuide(visible: Guide[], module: string, slug: string): Guide | null;
  export function useGuides(enabled: boolean): { guides: Guide[] | undefined; isLoading: boolean; isError: boolean };
  // guidesBundle.ts — só importado via import() dentro de guides.ts
  export const RAW_GUIDES: Record<string, string>; // import.meta.glob("./guides/**/*.md", { query: "?raw", import: "default", eager: true })
  ```
  - `slug` = nome do arquivo sem `.md`; `module` do front matter tem de bater com a pasta (senão erro).
  - `guidesForPath`: `matchScreen(pathname)` → guias cujo `screens` inclui o padrão; o mais específico do papel primeiro (`roles.length` crescente), depois `order`. Sem guia da tela → guias do módulo da tela (pela `section` da tela mapeada para o módulo; telas `/admin/*` → `administracao`; telas ocultas herdam o módulo pelo prefixo da rota, ex. `/meus-testes/...` → `desempenho`, `/videos/:id` → `comunicacao`) com `origin: "module"`. Sem módulo → `primeiros-passos`.
  - `useGuides`: React Query `["help-guides"]`, `staleTime: Infinity`, `gcTime: Infinity`, `queryFn` faz `import("./guidesBundle")` e `parseGuide` em todos.
- [ ] **Step 1: Write the failing tests**
  - `parseGuide` aceita o front matter válido e devolve `body` sem o bloco YAML; recusa: `modulo` fora da lista, `papeis` com papel inexistente, `telas` com caminho fora de `SCREENS`, pasta ≠ `modulo`, YAML ausente.
  - `normalize("Avaliação Ÿ") === "avaliacao y"`.
  - `searchGuides`: `"avaliacao"` acha título "Minha Avaliação"; todos os termos obrigatórios; acerto no título antes de acerto só no corpo; `""` e `"   "` → `[]`.
  - `guidesFor`: guia `papeis: ["manager","master_admin"]` com tela `/admin/videos` não aparece para `{roles:["user"]}`; guia de `/meu-ponto` só com `timeclockEnabled: true`; guia de `/admin/logs` só para `master_admin`.
  - `guidesForPath`: tela com guia → `origin "screen"` e o guia mais específico do papel primeiro; `/videos/abc` sem guia próprio → `origin "module"` com guias de `comunicacao`; rota desconhecida → `origin "first-steps"`.
  - `screens.test.ts` — **paridade de papéis**: para cada `<Route path=... >` protegida do `App.tsx`, os `requiredRoles` (ausente = todos) são iguais aos `roles` da tela em `SCREENS` (fecha o débito da fase 1).
  - `matchScreen("/admin/testes/42/editar")?.path === "/admin/testes/:testId/editar"`.
- [ ] **Step 2: Rodar e ver falhar** — `bun run --cwd frontend test -- src/help/guides.test.ts src/help/screens.test.ts` → FAIL.
- [ ] **Step 3: Implementar** (YAML com o pacote `yaml`, schema zod; `RAW_GUIDES` só por `import()`).
- [ ] **Step 4: Rodar** — `bun run --cwd frontend test && bun run --cwd frontend build` → PASS; conferir no build que os guias saem num chunk separado.
- [ ] **Step 5: Commit** — `feat(ajuda): núcleo dos guias, busca e filtro por papel`.

---

### Task 2: Renderização segura do guia

**Files:**
- Create: `frontend/src/help/GuideContent.tsx`
- Test: `frontend/src/help/GuideContent.test.tsx`

**Interfaces:**
- Consumes: `Guide` (Task 1).
- Produces: `export function GuideContent({ body }: { body: string }): JSX.Element` — `react-markdown` sem `rehype-raw`, `components` para `a` e `img`; envolve em `<div className="prose prose-sm max-w-none dark:prose-invert">`.
- [ ] **Step 1: Write the failing tests** (Testing Library + `MemoryRouter`)
  - `**Salvar**` vira `<strong>`; lista e títulos renderizam.
  - `<script>alert(1)</script>` e `<img src=x onerror=…>` aparecem como texto; nenhum `script`/`img[onerror]` no DOM.
  - link `[x](javascript:alert(1))` e `[x](http://exemplo.com)` → só texto, sem `<a>`.
  - link `[x](https://exemplo.com)` → `<a target="_blank" rel="noreferrer">`.
  - link `[Meu Perfil](/meu-perfil)` → clicar navega no router (asserção pela rota renderizada no `MemoryRouter`), sem recarregar.
  - imagem `![Tela de vídeos](/capturas/meus-videos.webp)` → `<img loading="lazy" alt="Tela de vídeos">`; imagem externa ou sem `alt` → texto do alt (ou nada), sem `<img>`.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar.**
- [ ] **Step 4: Rodar** → PASS.
- [ ] **Step 5: Commit** — `feat(ajuda): renderização segura dos guias`.

---

### Task 3: Central de Ajuda e página do guia

**Files:**
- Modify: `frontend/src/pages/HelpPage.tsx` (mantém o cartão do tour exatamente como está; acrescenta busca e cards por módulo)
- Create: `frontend/src/pages/HelpGuidePage.tsx`
- Modify: `frontend/src/App.tsx` (rota `/ajuda/:module/:slug`, `ProtectedRoute` sem `requiredRoles`), `frontend/src/help/screens.ts` (`hidden("/ajuda/:module/:slug", "Guia de ajuda", ALL)`)
- Test: `frontend/src/pages/HelpPage.test.tsx` (estender), `frontend/src/pages/HelpGuidePage.test.tsx`

**Interfaces:**
- Consumes: `useGuides`, `guidesFor`, `searchGuides`, `findGuide`, `MODULES` (Task 1); `GuideContent` (Task 2); `useAuth` (`roles`, `profile.timeclock_enabled`); `useTour` (fase 1).
- Produces: páginas. `data-tour="help-search"` no campo de busca (fase 3 usa).
  - `HelpPage`: título "Ajuda"; cartão do tour (igual hoje); `Input` "Buscar na ajuda" ligado a `?busca=` com `setSearchParams(..., { replace: true })`; com consulta → lista de resultados (título + módulo + link); sem consulta → um `Card` por módulo **que tenha guias visíveis**, na ordem de `MODULES`, com os títulos linkados; `aria-live` como nos Global Constraints; carregando → `Skeleton`; erro → mensagem "Não foi possível carregar os guias." com **Tentar de novo**.
  - `HelpGuidePage`: migalha "Ajuda › {módulo}" (links), título, `GuideContent`, coluna "Mais sobre {módulo}" com os outros guias visíveis do módulo; guia inexistente ou não visível → "Guia não encontrado" + link "Voltar para a Ajuda". Muda `document.title` para "{título} · Ajuda · TalentHS".
- [ ] **Step 1: Write the failing tests** (`useGuides`/`useAuth`/`useTour` mockados, `MemoryRouter`)
  - Review Focus 1: `user` abrindo `/ajuda/administracao/videos-do-rh` → "Guia não encontrado" e o título do guia **não** aparece.
  - Review Focus 5: digitar "avaliacao" lista o guia "Minha Avaliação" e o `aria-live` diz "1 guia encontrado"; consulta sem resultado → "Nenhum guia encontrado" e o link "Ver todos os guias" limpa a busca; consulta vazia não mostra contagem.
  - Cards por módulo seguem a ordem de `MODULES` e escondem módulo sem guia visível (colaborador não vê "Administração").
  - Cartão do tour continua com o botão **Fazer o tour de boas-vindas** (`data-tour="help-start-tour"`).
  - `?busca=testes` na URL inicial já filtra.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar.**
- [ ] **Step 4: Rodar** — `bun run --cwd frontend test && bun run --cwd frontend lint && bun run --cwd frontend build` → PASS (lint sem problema novo além da base de 55).
- [ ] **Step 5: Commit** — `feat(ajuda): central de ajuda com busca e página do guia`.

---

### Task 4: Botão "?" e passo novo do tour

**Files:**
- Create: `frontend/src/help/HelpButton.tsx`
- Modify: `frontend/src/components/AdminLayout.tsx` (`<HelpButton />` antes do `<NotificationBell />` no `<header>`)
- Modify: `frontend/src/help/tours/welcome.ts` (passo novo em `FINAL_STEPS`, versão 2 nos dois tours)
- Test: `frontend/src/help/HelpButton.test.tsx`, `frontend/src/help/tours/welcome.contract.test.ts` (ajustar)

**Interfaces:**
- Consumes: `useGuides`, `guidesFor`, `guidesForPath` (Task 1); `GuideContent` (Task 2); `useTour().active` (fase 1).
- Produces: `HelpButton` (sem props). Botão ghost/ícone `HelpCircle`, `data-tour="help-button"`, `aria-label="Ajuda desta tela"`. Abre `Sheet` (`side="right"`, `sm:max-w-md`) com: título do guia principal + `GuideContent`; "Outros guias desta tela" (links para `/ajuda/...`); quando `origin` ≠ `"screen"`, cabeçalho "Guias de {módulo}" ou "Primeiros passos"; rodapé **Abrir a central de ajuda** → `/ajuda`. Carrega os guias só ao abrir (`useGuides(open)`). Fecha quando `location.pathname` muda e quando `useTour().active` vira `true`.
  - Passo novo (último de `FINAL_STEPS`): `route: "/ajuda"`, `element: "help-button"`, `since: 2`, título "Ajuda desta tela", texto em 1–2 frases no imperativo dizendo que o **?** no topo abre o guia da tela em que a pessoa está. `WELCOME_TOURS.collaborator.version = 2`, `manager.version = 2`.
- [ ] **Step 1: Write the failing tests**
  - Review Focus 3: em `/videos/abc` (sem guia próprio) o painel mostra "Guias de Comunicação" com a lista; em rota sem módulo mostra "Primeiros passos"; nunca vazio.
  - em `/meus-videos` mostra o guia da tela como principal.
  - Review Focus 4: painel aberto + mudança de rota (navegar no `MemoryRouter`) → fecha; painel aberto + `active` passa a `true` → fecha.
  - botão tem `aria-label` e `data-tour`.
  - contrato: o tour de boas-vindas termina em `help-button`; o passo tem `since: 2`; as duas versões são 2; os textos seguem as regras do contrato existente.
- [ ] **Step 2: Rodar e ver falhar** → FAIL.
- [ ] **Step 3: Implementar.**
- [ ] **Step 4: Rodar** — test + lint + build → PASS.
- [ ] **Step 5: Commit** — `feat(ajuda): botão de ajuda da tela e passo novo no tour`.

---

### Task 5: Infraestrutura de capturas

**Files:**
- Modify: `frontend/package.json` (`playwright-core` versão exata em `devDependencies`; script `"capturas": "bun scripts/captures.ts"`)
- Create: `frontend/scripts/captures.ts`, `frontend/scripts/captures.config.ts`
- Create: `backend/scripts/seed_captures.py`, `backend/scripts/captures-db.sh`
- Create: `frontend/public/capturas/.gitkeep` e as capturas das telas do tour (prova do pipeline)
- Modify: repo `CLAUDE.md` (seção "Tour e Ajuda": como refazer as capturas)

**Interfaces:**
- Produces:
  - `captures-db.sh`: cria (recria) o banco `talenths_capturas` no `pg-teste` como o `test-db.sh` faz **e** aplica o DDL das tabelas que existem em produção mas não em `backend/migrations/` (hoje `custom_tests`/`test_attempts`, que só estão em `backend/supabase/migrations/20260520000002_custom_tests.sql`) — conferir com o `\d` de produção pelo usuário de leitura (`bancos.consultar("talenths", ...)`) se faltar mais alguma tabela usada pelas telas. **Não** criar migração numerada para tabela que já existe em produção.
  - `seed_captures.py`: recusa se o nome do banco não contém `capturas`; cria empresa "Empresa Exemplo", departamentos, contas fictícias com senha conhecida (`ana@exemplo.com.br` colaboradora, `bruno@exemplo.com.br` colaborador com ponto habilitado, `gestor@exemplo.com.br` manager, `admin@exemplo.com.br` master_admin) e dados para toda tela de menu não ficar vazia (vídeos com metadados — sem arquivo real, comunicados, avaliação, testes, trilha, PDI, workshops, pesquisa, feedbacks, documentos, ausências, benefícios, ponto, metas, 9box, bingo, calendário, cultura, regras, apresentação da empresa). Imprime JSON com os ids na última linha. Marca o tour de boas-vindas como concluído para todas as contas (o modal obrigatório não pode aparecer nas fotos).
  - `captures.config.ts`: `ACCOUNTS`, `interface Capture { name: string; account: Account; route: (ids: Ids) => string; click?: string /* data-tour a clicar antes */; width?: number; height?: number }`, `CAPTURES: Capture[]`.
  - `captures.ts`: sobe nada sozinho — espera backend em `:8011` e frontend em `:8091` (documentar os comandos no topo do arquivo, iguais aos da verificação da fase 1); roda a semente, faz login por conta pela tela de login, tema claro, 1280×800, fotografa cada `Capture` depois de a rede ficar ociosa, converte PNG → WebP 0.82 no próprio Chrome (canvas, como o DocsHS), grava `public/capturas/<name>.webp`; `--only nome1,nome2` para refazer só algumas. Chrome: `CHROME` env ou `/usr/bin/google-chrome`.
- [ ] **Step 1:** Escrever `captures-db.sh` + `seed_captures.py`; rodar e conferir com `psql` que cada tela tem dados (listar contagens).
- [ ] **Step 2:** Escrever `captures.config.ts` só com as capturas usadas pelo guia da Task 1 e pelas telas do tour; `captures.ts`; rodar `bun run --cwd frontend capturas`; abrir 2–3 imagens e conferir (sem modal, sem dado real, sem erro na tela).
- [ ] **Step 3:** Teste rápido em `frontend/src/help/captures.contract.test.ts`: todo `name` em `CAPTURES` é kebab-case e único; todo arquivo em `public/capturas/*.webp` está em `CAPTURES` (sem órfão).
- [ ] **Step 4:** Rodar test + lint + build; backend pytest (não deve mudar).
- [ ] **Step 5: Commit** — `feat(ajuda): capturas automáticas das telas para os guias`.

---

### Task 6: Guias — Primeiros passos e telas pessoais

**Files:**
- Create: `frontend/src/help/guides/{primeiros-passos,meu-espaco,desempenho,desenvolvimento,comunicacao,rh}/*.md` — um guia por tela de menu pessoal (`/apresentacao`, `/dashboard`, `/meu-perfil`, `/cultura`, `/regras-internas`, `/calendario`, `/minha-avaliacao`, `/meus-testes`, `/minha-trilha`, `/meu-pdi`, `/minha-universidade`, `/workshops`, `/comunicados`, `/pesquisas`, `/meus-feedbacks`, `/meus-documentos`, `/meus-videos`, `/bingo`, `/minhas-ausencias`, `/meus-beneficios`, `/meu-onboarding`, `/meu-ponto`) + Primeiros passos: "O tour de boas-vindas" (Task 1), "Como navegar pelo menu", "Notificações", "Ajuda desta tela"
- Modify: `frontend/scripts/captures.config.ts` + `frontend/public/capturas/*.webp` (capturas citadas)
- Test: `frontend/src/help/guides.contract.test.ts`

**Interfaces:**
- Consumes: `RAW_GUIDES`, `parseGuide`, `SCREENS` (Task 1); capturas (Task 5).
- Produces: os guias. `/apresentacao` e `/dashboard` ficam no módulo `primeiros-passos`.
- [ ] **Step 1: Write the failing contract test** (`guides.contract.test.ts`)
  - todo guia faz `parseGuide` sem erro;
  - toda tela de menu **não** `/admin/*` tem ao menos um guia que a cita em `screens` (a Task 7 estende para `/admin/*`);
  - toda imagem citada existe em `public/capturas/` e está em `CAPTURES`;
  - todo guia tem as seções `## Para que serve`, `## Passo a passo` e `## Dúvidas comuns`; nenhum contém "treinamento"; links internos apontam para rotas de `SCREENS` ou `/ajuda/<modulo>/<slug>` existente.
- [ ] **Step 2: Rodar e ver falhar** → FAIL (guias faltando).
- [ ] **Step 3: Escrever os guias** lendo cada página em `frontend/src/pages/` (rótulos de botão exatos) e gerar as capturas citadas (`bun run --cwd frontend capturas -- --only ...`).
- [ ] **Step 4: Rodar** → PASS; abrir 3 guias na central (dev server) e conferir imagens e links.
- [ ] **Step 5: Commit** — `docs(ajuda): guias das telas pessoais e primeiros passos`.

---

### Task 7: Guias — Administração

**Files:**
- Create: `frontend/src/help/guides/administracao/*.md` — um por tela de menu `/admin/*` (inclui "Logs", só `master_admin`; "Testes" cobre também editar e tentativas)
- Modify: `frontend/scripts/captures.config.ts`, `frontend/public/capturas/*.webp`, `frontend/src/help/guides.contract.test.ts` (cobertura passa a valer para **todas** as telas de menu)
- [ ] **Step 1:** Estender o contrato para todas as telas de menu → FAIL.
- [ ] **Step 2:** Escrever os guias (conta `gestor` nas capturas; `admin` só para Logs) e gerar capturas.
- [ ] **Step 3: Rodar** → PASS.
- [ ] **Step 4: Commit** — `docs(ajuda): guias das telas de administração`.

---

### Task 8: Captura do "?" e passo do tour nas imagens

**Files:**
- Modify: `frontend/scripts/captures.config.ts` (captura `ajuda-desta-tela` com `click: "help-button"` em `/meus-videos`), `frontend/src/help/guides/primeiros-passos/ajuda-desta-tela.md` (cita a imagem), `public/capturas/`
- [ ] **Step 1:** Gerar a captura com o painel aberto; conferir que o painel mostra o guia de Vídeos.
- [ ] **Step 2:** Rodar contrato + test → PASS.
- [ ] **Step 3: Commit** — `docs(ajuda): captura do painel de ajuda da tela`.

---

### Task 9: Verificação na tela, changelog e versão

**Files:**
- Modify: `frontend/src/components/ChangelogModal.tsx` (entrada v1.11.0, `current: true`, tira da v1.10.0), `frontend/src/components/AdminSidebar.tsx` (`TalentHS v1.11.0`), `frontend/package.json` (`1.11.0`)
- Modify: repo `CLAUDE.md` — "Tour e Ajuda": tela com guia muda **no mesmo commit** que o guia (e a captura, `bun run capturas -- --only ...`); contrato em `src/help/guides.contract.test.ts`.

- [ ] **Step 1:** Subir backend (8011) e frontend (8091) contra o banco de capturas; Playwright, desktop 1366×800 e celular 390×844.
- [ ] **Step 2:** Percorrer e anotar cada defeito antes de corrigir:
  - colaboradora e gestor: `/ajuda` mostra só os módulos devidos; busca "avaliacao", "ponto" (só Bruno acha), "logs" (só admin);
  - abrir 3 guias de cada papel: imagens carregam, links internos navegam sem recarregar, "Mais sobre" coerente;
  - "?" em 5 telas, inclusive `/videos/:id` e `/meus-testes/:id/realizar` (fallback do módulo);
  - "?" aberto + clicar no menu → fecha; "?" aberto + **Fazer o tour** na Ajuda → fecha e o balão fica clicável;
  - tour v2: conta nova faz o tour inteiro e o último passo destaca o "?"; conta que concluiu a v1 **não** vê o modal;
  - celular: painel do "?" ocupa a largura, rola, fecha; tema escuro legível (`prose-invert`).
- [ ] **Step 3:** Corrigir o que apareceu (lógica com teste).
- [ ] **Step 4: Changelog** — novidades para o usuário final: central de Ajuda com guias de todas as telas e busca; botão **?** no topo com o guia da tela; tour ganha um passo mostrando o **?**.
- [ ] **Step 5: Rodar tudo** — frontend test/lint/build; backend pytest.
- [ ] **Step 6: Commit** — `feat(ajuda): v1.11.0 — central de ajuda e guias`.
