# Ajuda e Tour — Design

**Data:** 20/10/2026 · **Status:** rascunho para aprovação · **Versões alvo:** v1.10.0 (fase 1),
v1.11.0 (fase 2), v1.12.0 (fase 3) — cada fase é funcionalidade nova (minor)

> **Revisão do Erick (20/10/2026, antes do deploy da v1.10.0) — substitui o "convite":**
> o tour de boas-vindas é **obrigatório**. Ao entrar no sistema, quem ainda não concluiu vê um
> **modal** sem fechar e sem adiar, com um só botão ("Começar o tour" ou "Continuar de onde
> parou", que retoma direto no passo salvo). A pessoa pode fechar o tour no meio (X/Esc) para
> resolver algo urgente; o modal volta na **próxima entrada** (novo login ou recarregar a
> página) até concluir. Saem o cartão de convite, "Agora não" e "Não mostrar mais". Onde este
> documento fala em convite, recusas, dispensa ou "nunca bloqueia", vale esta revisão. As rotas
> `dismiss`/`decline-invite` do backend ficam, sem uso no frontend.

## Intenção

O TalentHS cresceu (mais de 20 telas só para o colaborador) e acabou de ganhar a tela de
**Vídeos**. O Erick não quer ir de pessoa em pessoa explicando como chegar no vídeo, nem em
nenhuma outra tela. O sistema precisa **se explicar sozinho**: um tour guiado que mostra
onde ficam as coisas e uma central de ajuda com um guia para cada tela.

O desenho é uma **réplica adaptada do Módulo 6 do DocsHS** ("Tutorial e central de ajuda"),
que já está em produção e foi aprovado pelo Erick. Referências (leitura obrigatória para
quem for construir, só leitura; outro repo):

- Spec: `~/github/docshs/docs/superpowers/specs/2026-10-08-docshs-modulo-6-tutorial-design.md`
- Registros de execução (defeitos que só apareceram testando na tela):
  `~/github/docshs/docs/superpowers/execucao/2026-10-0{8,9}-modulo-6-fase-*-registro-de-execucao.md`
- Código: `~/github/docshs/frontend/src/ajuda/` (motor, provedor, guias, tours) e
  `~/github/docshs/backend/app/services/tutorial.py`

**Primeiro público:** quase todo mundo já usa o TalentHS. Quando a fase 1 sair, o convite do
tour aparece para **a empresa inteira de uma vez**, não só para quem entra depois. O passo de
Vídeos precisa estar no tour de boas-vindas desde o início.

**Sucesso:** a pessoa recebe o aviso de um vídeo, abre o TalentHS e chega em **Vídeos** sem
mandar mensagem para ninguém; o RH vê quem já fez o tour.

## Objetivos

1. **Tour de boas-vindas** por papel, em forma de convite (nunca bloqueia), retomável de outro
   computador, com progresso no banco.
2. **Central de Ajuda** (`/ajuda`) com guias em Markdown para **todas as telas**, busca sem
   acento e filtro por papel.
3. **Botão "?"** no cabeçalho de toda página logada, abrindo o guia da tela atual.
4. **Capturas de tela automáticas** nos guias (Playwright + banco com dados fictícios).
5. **Tours por tela** ("Mostrar nesta tela") para as telas densas.
6. **"O que mudou"**: quando uma tela nova entra no tour (ex.: próxima funcionalidade), quem já
   concluiu vê só os passos novos.
7. **Tela de adoção** para o RH: quem fez, quem parou, quem dispensou, com exportação.

## Não-objetivos

- Editor de guias na interface — guias são mantidos no código, versionados no repo.
- Tour obrigatório ou que bloqueie o uso do sistema.
- Tour separado para `master_admin` (a tela de Logs fica de fora do tour; tem guia).
- Vídeos dentro dos guias.
- Tratar a adoção como evidência formal de treinamento (o progresso é autodeclarado).

## Anti-objetivos (seria falha mesmo funcionando)

- O tour aparecer em cima do trabalho da pessoa sem ela pedir (só convite no Dashboard).
- Um passo apontar para um elemento que não existe mais e ninguém perceber — os contratos
  (testes) têm que pegar isso.
- Guia mostrando tela ou função que o papel da pessoa não acessa.
- Confundir com o **Onboarding** existente (checklist de RH, `/meu-onboarding`). O recurso novo
  se chama **Tour** e **Ajuda**; nunca "onboarding" na interface nem no código novo.
- Um guia desatualizado: tela com guia muda **no mesmo commit** que o guia (regra a entrar no
  `CLAUDE.md` do repo).

## Decisões tomadas pelo Erick

| Tema | Decisão |
|---|---|
| Modelo | Mesmo comportamento do DocsHS |
| Entrega | 3 fases: (1) tour de boas-vindas + progresso no banco; (2) Ajuda + "?" + guias + capturas; (3) tours por tela + "O que mudou" + tela de adoção |
| Tours de boas-vindas | **Dois**: colaborador (`user`) e gestor (`manager` e `master_admin`); o do gestor é o do colaborador mais passos de admin |
| Roteiro | O proposto abaixo; ajustes pedidos pelo RH vêm depois |
| Guias | Cobrir **todas as telas**, com **capturas automáticas** — dá trabalho, mas tem que ficar bonito e organizado |
| Adoção | Tela para o RH na fase 3; progresso gravado no banco desde a fase 1 |
| Revisão dos guias | **Não bloqueia** a fase 2: os rascunhos saem no ar e Erick/RH revisam com o sistema rodando (é interno); a interface não sinaliza "rascunho" |

## Restrições

- Stack existente: React 18 + Vite + shadcn + React Query; FastAPI + asyncpg (SQL cru, sem ORM).
- Migração nova `backend/migrations/030_tour_progress.sql`; nunca editar migrações antigas.
  Tabela segue o padrão do banco (`uuid`, `user_id → auth.users`, `company_id`).
- `AdminLayout` é montado **por página** (50 páginas), e o `SidebarProvider` vive dentro dele.
  O provedor do tour fica **acima de `<Routes>`** (dentro do `AuthProvider`) para não
  desmontar ao trocar de tela — portanto ele **não enxerga o contexto da sidebar** diretamente.
- No celular a sidebar do shadcn é um `Sheet` (Radix Dialog modal: prende foco, põe
  `pointer-events: none` no resto). Abrir a gaveta durante um passo conflitaria com o balão do
  driver.js.
- Backend com 4 workers: nada de estado em memória.
- `AuditMiddleware` (`backend/app/middleware/audit.py`) registra requisições: as do tour
  **não** podem entrar no log (inundariam como as de progresso de vídeo).
- Testes do backend precisam de `TEST_DATABASE_URL` (`backend/scripts/test-db.sh`, container
  `pg-teste` local). Frontend: `vitest` (`bun test`).
- Changelog e versão em 3 lugares a cada fase (regra do `CLAUDE.md`).

## Como funciona

### Tour (fases 1, 2 e 3)

**Motor:** `driver.js` (versão exata fixada) só para destaque, balão, rolagem e
reposicionamento. O percurso é código próprio, passo a passo via `highlight()`, como o
`MotorDoTour` do DocsHS — incluindo tudo o que lá foi corrigido testando na tela:

- navega de rota quando o passo é de outra tela, com balão "Abrindo X…", e espera **dois
  `requestAnimationFrame`** antes de procurar o elemento;
- espera o elemento até 3 s (400 ms em silêncio, depois balão no centro; reposiciona se
  aparecer);
- **trava** Próximo/Anterior durante a espera; contador de geração invalida esperas velhas;
- elemento destacado não é clicável, salvo passo com `interagir`;
- textos dos passos são texto puro com `**negrito**`, escapados antes de ir ao driver.js;
- clicar fora não fecha; X e Esc fecham guardando o passo; setas do teclado navegam;
- "← Anterior", "Próximo →", "Concluir", "N de M"; o passo antes de uma troca de tela ganha
  "Vamos para **X**.".

**Alvos:** só `data-tour="..."` (nunca classe ou texto). Itens de menu recebem o atributo a
partir da tabela de telas (abaixo).

**Sidebar durante o tour:** `AdminLayout` registra no provedor do tour uma função de preparo
(ref/registro em contexto) que é trocada a cada página. Antes de um passo de menu, no
computador com sidebar recolhida, ela expande temporariamente e restaura ao fim do tour. **No
celular, passos de menu destacam o botão ☰** (o texto diz "toque aqui para abrir o menu") em
vez de abrir a gaveta.

**Disparo:**
1. **Convite no Dashboard** (cartão): "Começar" / "Continuar o tour", "Agora não" (soma uma
   recusa; some nesta aba), "Não mostrar mais". Some após 3 recusas, conclusão ou dispensa.
2. **`/ajuda`**: "Fazer o tour de boas-vindas"; se houver progresso pela metade **na mesma
   versão**, diálogo "Continuar do passo N / Recomeçar / Cancelar" (`AlertDialog` do shadcn).
3. **"?" → "Mostrar nesta tela"** (fase 3): tour curto da tela atual, sem navegar, removendo os
   passos cujo elemento não está visível.
4. **"?" → "O que mudou"** (fase 3): ponto no "?" quando o tour de boas-vindas foi concluído
   numa versão menor e há passos com `desde` maior; "Ver o que mudou" / "Dispensar". Se nenhum
   passo novo é visível para a pessoa, conclui direto.

**Persistência no servidor:** progresso a cada passo exibido, em fila (uma `Promise`) para não
chegar fora de ordem; conclusão com 3 tentativas e toast "Não foi possível registrar o tour —
Tentar de novo"; nada sai com o token de outro usuário depois de logout/troca de conta. O cache
do React Query é limpo ao entrar e sair (conferir se o `AuthContext` já faz; se não, fazer).

**Roteiro — tour do colaborador** (`boas-vindas-colaborador`, versão 1):

| # | Tela | Destaque | Conteúdo |
|---|---|---|---|
| 1 | `/dashboard` | painel | O que aparece na tela inicial |
| 2 | `/dashboard` | menu | Grupos: Meu Espaço, Desempenho, Desenvolvimento, Comunicação, RH |
| 3 | `/meus-videos` | lista | Onde ficam os vídeos que o RH pede para assistir e como abrir um |
| 4 | `/comunicados` | lista | Avisos da empresa |
| 5 | `/minha-avaliacao` | área principal | Onde responder avaliações |
| 6 | `/meus-testes` | lista | Testes que o RH aplica |
| 7 | `/meu-perfil` | dados | Dados pessoais |
| 8 | qualquer | sino | Avisa quando chega algo novo |
| 9 | `/ajuda` | item **Ajuda** do menu | Onde refazer o tour (e, a partir da fase 2, achar o guia de cada tela) |

**Fase 1 já traz uma `/ajuda` mínima** (como no DocsHS): item **Ajuda** no menu e a página só
com o cartão do tour (situação + "Fazer o tour de boas-vindas" + diálogo de retomada). É o
único jeito de refazer o tour depois de concluir ou de "Não mostrar mais". O botão "?" entra na
fase 2 com um passo novo (`desde: 2`, versão 2 do tour), que quem já concluiu vê pelo "O que
mudou" na fase 3 — o convite **não** reaparece para a empresa inteira. *(Decisão do Claude,
seguindo o DocsHS.)*

**Tour do gestor** (`boas-vindas-gestor`): passos 1–8 do colaborador + menu de admin (seções
Pessoas, Desempenho, Desenvolvimento, Comunicação, Gestão de RH, Sistema) + Colaboradores
(cadastro e convites) + Vídeos admin (publicar e ver quem assistiu) + Relatórios + passo final
do "?". Os passos compartilhados são **constantes reaproveitadas**, não cópia.

Textos: 1–2 frases, imperativo, nome do botão em **negrito** como aparece na tela, sem
"onboarding"/"treinamento".

**Tours por tela (fase 3):** para as telas densas. Lista inicial é decisão do construtor, a
partir das telas com mais elementos (candidatas: Meu PDI, Minha Avaliação, vídeo aberto,
Vídeos admin, Avaliação admin, Mapa 9Box). Ligados ao guia da tela pelo campo `tour:`.

### Tabela única de telas

Um arquivo (ex.: `frontend/src/help/screens.ts`) com uma linha por rota: caminho, papéis,
condição (ex.: `timeclock_enabled`), grupo/seção do menu, rótulo, ícone e `tour`
(o `data-tour` do item). É a **única fonte** para:

- o menu da `AdminSidebar` (que hoje define `adminSections`/`personalSections` à mão — migrar);
- o filtro de guias por papel;
- o nome da tela no "Vamos para X";
- os testes de contrato dos tours.

Inclui as condições já existentes no menu (Logs só para `master_admin`; Meu Ponto só com
`timeclock_enabled`). O comportamento visível do menu não muda.

### Ajuda (fase 2)

- **Guias** em `frontend/src/help/guides/<modulo>/<slug>.md`, um por tela (ou mais, quando a
  tela tem tarefas distintas). Módulos seguem as seções do menu, mais "Primeiros passos" e
  "Administração". Front matter: `titulo`, `modulo`, `papeis`, `telas`, `ordem`, `tour?` —
  lido com parser de verdade e validado com **zod** (não o parser caseiro do DocsHS).
- Modelo de guia: para que serve · quando usar · passo a passo com capturas · o que acontece
  depois · dúvidas comuns. Imperativo, botões em **negrito**.
- **Primeiro rascunho** de cada guia é escrito pelo Claude a partir do código da tela;
  Erick/RH revisam depois da entrega, com o sistema no ar.
- **Renderização:** `react-markdown` (já instalado; não renderiza HTML cru) com componentes
  próprios para `a` (link interno vai pelo router; externo só `https`) e `img` (só
  `/capturas/*.webp`, `alt` obrigatório). Sem `dangerouslySetInnerHTML`.
- Guias carregados **sob demanda** (`import.meta.glob` com `?raw` atrás de um `import()`), num
  chunk separado; React Query com `staleTime: Infinity`.
- **Filtro por papel:** guia aparece se o papel está em `papeis` **e** a pessoa abre todas as
  telas de `telas` (pela tabela única). Guia de outro papel aberto por link → "Guia não
  encontrado".
- **Busca** no cliente, sem acento, todos os termos; acertos no título primeiro; consulta em
  `?busca=`; região `aria-live` com "N guias encontrados".
- **`/ajuda`**: cartão do tour com situação ("Concluído em dd/mm", "Parou no passo N de M",
  "Você ainda não fez" — só depois do progresso carregar) + busca + cards por módulo.
  **`/ajuda/:modulo/:guia`**: guia com migalha e "Mais sobre o módulo" ao lado.
- **Botão "?"** no `<header>` do `AdminLayout`, ao lado do sino: abre `Sheet` do shadcn à
  direita com o guia da tela (o mais específico do papel primeiro), outros guias da tela,
  "Mostrar nesta tela" e "O que mudou" (fase 3), "Abrir na central". Sem guia próprio → guias do
  módulo → "Primeiros passos". Fecha ao trocar de rota ou ao começar um tour.
- Item **Ajuda** no menu (rota `/ajuda`), visível para todos.
- O `HelpTip` existente (ícone "(?)" com tooltip em campos) continua como está — é dica de
  campo, não guia.

### Capturas automáticas (fase 2)

- Script Playwright (no frontend) que sobe o app contra um **banco de capturas** com dados
  fictícios (empresa, departamentos, pessoas, vídeos, avaliações etc.), loga com cada papel e
  fotografa as telas listadas numa configuração, gravando `frontend/public/capturas/*.webp`
  (commitadas).
- Banco de capturas no container `pg-teste` local, criado a partir das migrações como o
  `test-db.sh`; a semente **recusa rodar** se o nome do banco não contiver `capturas`.
- A pasta pública **não** pode se chamar `ajuda` (o nginx com `try_files $uri/` redireciona
  `/ajuda` → `/ajuda/` e quebra a rota da SPA). Por isso `public/capturas/`.
- Tema claro, largura de computador; capturas de celular só onde o guia fala do celular.
- Refazer as capturas é um comando só, documentado no README/CLAUDE.md.

### Tela de adoção (fase 3)

`/admin/tour` (nome do item no menu a definir pelo construtor, ex.: "Adoção do tour"), para
`manager` e `master_admin`: uma linha por pessoa ativa, com o tour de boas-vindas **do papel
atual** e situação (concluído > em andamento > dispensado > não começou), data, passo, recusas;
totais; filtro por departamento e situação (totais seguem só o de departamento); exportação
`.xlsx`. Uma consulta só (sem N+1).

### Backend

**Tabela `tour_progress`** (030): `id`, `user_id` (FK `auth.users`, `ON DELETE CASCADE`),
`company_id`, `tour` (`text`, CHECK `^[a-z0-9-]{1,64}$`), `version` (1–999), `step` (0–999,
default 0), `started_at`, `completed_at`, `dismissed_at`, `invites_declined` (≥ 0),
`created_at`/`updated_at`; `UNIQUE (user_id, tour)`. **Sem RLS**, como da 008 à 029: o
isolamento é no SQL do backend (sempre filtrando pelo usuário do token). *(Decisão do Claude.)*

**Rotas** (prefixo `/tour`; usuário sempre do token; corpo com `extra="forbid"`):

| Rota | Efeito |
|---|---|
| `GET /tour/progress` | progressos da pessoa |
| `PUT /tour/progress/{tour}` `{version, step}` | upsert; `started_at` só na 1ª vez; versão atualiza enquanto não concluiu |
| `POST /tour/progress/{tour}/complete` `{version}` | `completed_at` só na 1ª vez; depois a versão só sobe |
| `POST /tour/progress/{tour}/dismiss` `{version}` | `dismissed_at`, só a 1ª data |
| `POST /tour/progress/{tour}/decline-invite` `{version}` | soma recusa, até 3 |
| `GET /tour/adoption` (+ `/export`) | fase 3; `require_manager` |

Upsert seguro com duas abas: `INSERT ... ON CONFLICT DO NOTHING` + `SELECT ... FOR UPDATE`.
Teto de tours por pessoa (50) contra laço criando linhas.

**Diferente do DocsHS:** a regra do convite (sem conclusão, sem dispensa, < 3 recusas) fica
**no frontend**, que já recebe os progressos. O backend só precisa saber o tour de boas-vindas
de cada papel para a tela de adoção (fase 3): uma constante no backend, e um teste de
contrato garante que bate com o frontend.

Rotas do tour entram em `_SKIP_PATTERNS` do `AuditMiddleware`.

## Testes

- **Backend** (`backend/tests/db/`): migração 030 (constraints), rotas (upsert, versão só sobe,
  conclusão idempotente, recusa até 3, `extra="forbid"`, teto, isolamento por usuário), adoção.
- **Frontend** (vitest): regras puras (retomar, "O que mudou", tour da tela, busca, filtro por
  papel, guia da tela) e **contratos em TS** (não Python lendo TS por regex como no DocsHS):
  - todo `elemento` de passo existe como `data-tour` em algum `.tsx`;
  - toda `rota` de passo é tela que o papel do tour abre;
  - todo guia tem front matter válido, `telas` existentes e capturas que existem em
    `public/capturas/`;
  - toda tela da tabela tem ao menos um guia;
  - ids de tour de boas-vindas iguais aos do backend.
- **Na tela** (obrigatório antes de cada entrega): percorrer os dois tours no computador e no
  celular, com sidebar aberta e recolhida, inclusive fechar no meio e retomar em outra aba.

## Deixado para o construtor

- Nomes exatos de arquivos/componentes (código em inglês, interface em pt-BR).
- Visual do balão (CSS do `.driver-popover` com os tokens do Tailwind/tema, claro e escuro).
- Lista e quantidade de guias por módulo; lista de tours por tela.
- Lista de telas fotografadas e o conteúdo da semente de capturas.
- Como o `AdminLayout` registra a função de preparo da sidebar no provedor.
- Formato do `.xlsx` (seguir o que `reports.py` já usa, se usar algo).
