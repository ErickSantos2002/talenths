# Design — Módulo de Bingo (TalentHS)

**Data:** 02/07/2026
**Status:** Aprovado no brainstorming; aguardando revisão final antes do plano de implementação.

## 1. Objetivo

Adicionar ao TalentHS uma função de **Bingo** para confraternizações internas. O gerente (RH)
cria jogos, gera cartelas automaticamente para os participantes, conduz o sorteio pelo sistema
(com marcação automática, avisos de "quase lá", ranking de ganhadores e desempate por d20) e pode
**imprimir** as cartelas (9 por folha, 3×3, paisagem). Cada participante acompanha a própria
cartela ao vivo. Tudo é registrado para auditoria.

## 2. Escopo

**Dentro:**
- Página admin (gerentes) para criar/listar/conduzir/imprimir/excluir jogos.
- Página do participante para acompanhar a própria cartela ao vivo.
- Geração automática de cartelas únicas.
- Sorteio conduzido pelo servidor (manual e automático), marcação automática, detecção de vitória,
  avisos de "quase lá", ranking de ganhadores, desempate por d20.
- Impressão via navegador (sem biblioteca nova).
- Persistência completa para auditoria.

**Fora (agora):** WebSocket/tempo-real instantâneo (usaremos polling), prêmios por linha,
notificações push, exportação fiscal, temas customizáveis por jogo.

## 3. Papéis, páginas e rotas

| Página | Rota | Acesso |
|--------|------|--------|
| Bingo (admin) | `/admin/bingo` | `manager`, `master_admin` |
| Bingo (participante) | `/bingo` | qualquer autenticado (mostra só os jogos da pessoa) |

- Item **"Bingo"** na sidebar de administração e nas seções pessoais (`AdminSidebar.tsx`).
- Rotas em `App.tsx` (`/admin/bingo` com `ProtectedRoute requiredRoles={["manager","master_admin"]}`;
  `/bingo` com `ProtectedRoute` autenticado).
- Backend: router novo `backend/app/routers/bingo.py` (prefix `/bingo`), registrado em `main.py`.
- Migração nova: `backend/migrations/028_bingo.sql`.

## 4. Modelo de dados (`028_bingo.sql`)

Todas as tabelas têm `company_id` (single-tenant, RLS por empresa). Nada é apagado durante o jogo.

### 4.1 `bingo_games`
- `id uuid PK`, `company_id uuid`, `name text`
- `number_pool int` — tamanho do monte de números (múltiplo de 10; presets 30/60/90)
- `winners_target int` — quantidade de ganhadores (ex.: 3/5/7)
- `near_threshold int NOT NULL DEFAULT 2` — destacar cartelas às quais faltam ≤ N números
- `status text CHECK (status IN ('draft','running','finished','cancelled')) DEFAULT 'draft'`
- `created_by uuid`, `created_at timestamptz`, `started_at timestamptz`, `finished_at timestamptz`

### 4.2 `bingo_cards` — uma cartela por participante
- `id uuid PK`, `game_id uuid FK→bingo_games ON DELETE CASCADE`, `company_id uuid`, `user_id uuid`
- `code text` — código curto (ex.: `7A3F`), único por `game_id`, para conferência/impressão
- `numbers int[]` — os 20 números da cartela
- `layout jsonb` — grade 3×10 com posições cheias/vazias (mantém tela e impressão estáveis)
- `created_at timestamptz`
- Único por (`game_id`, `user_id`). Índice em (`game_id`).

### 4.3 `bingo_draws` — cada número sorteado (histórico ordenado)
- `id uuid PK`, `game_id uuid FK ON DELETE CASCADE`, `company_id uuid`
- `number int`, `draw_order int` (1,2,3…), `drawn_at timestamptz`, `drawn_by uuid`
- Único por (`game_id`, `number`) e por (`game_id`, `draw_order`).

### 4.4 `bingo_winners` — ganhadores
- `id uuid PK`, `game_id uuid FK ON DELETE CASCADE`, `company_id uuid`, `card_id uuid`, `user_id uuid`
- `place int` — 1, 2, 3…
- `won_on_draw int` — o número sorteado que fechou a cartela
- `by_tiebreak bool DEFAULT false` — se o lugar foi decidido no d20
- `won_at timestamptz`
- Único por (`game_id`, `place`) e por (`game_id`, `card_id`).

### 4.5 `bingo_tiebreak_rolls` — rolagens do d20 (auditoria do desempate)
- `id uuid PK`, `game_id uuid FK ON DELETE CASCADE`, `company_id uuid`, `card_id uuid`
- `round int` — 1, 2… (rola de novo se empatar no dado)
- `roll int CHECK (roll BETWEEN 1 AND 20)`
- `created_at timestamptz`

**Auditoria:** com essas tabelas dá para reconstruir o jogo inteiro — cartelas (números + código),
ordem exata dos sorteios com horário, ganhadores (lugar + como foi decidido) e cada rolagem de d20.

## 5. Regras de negócio

### 5.1 Geração das cartelas (únicas, estilo coluna — "Opção B")
- 10 colunas; cada coluna cobre uma faixa contígua de tamanho `number_pool / 10`
  (30 → 1-3, 4-6, …; 60 → 1-6, 7-12, …; 90 → 1-9, 10-18, …).
- Para cada coluna: sorteia **2 números distintos** da faixa e deixa **1 das 3 linhas vazia**.
  Resultado: 20 números preenchidos + 10 vazios.
- **Unicidade:** guarda-se o conjunto ordenado dos 20 números; se uma nova cartela repetir
  exatamente o conjunto de outra do mesmo jogo, gera de novo (com limite de tentativas).
  Combinações possíveis ≥ `C(pool/10, 2)^10` (monte 30 ⇒ ~59 mil), suficiente para qualquer time.
  Se o monte for pequeno demais para a quantidade de participantes, a criação retorna erro claro.
- `layout` guarda em qual linha cada número ficou e quais casas são vazias.

### 5.2 Sorteio
- O **backend** escolhe o próximo número aleatório entre os que ainda não saíram (1…`number_pool`),
  grava em `bingo_draws` (com `draw_order`) e **marca automaticamente** em todas as cartelas que o têm.
- Marcação é derivada: uma casa está "marcada" se seu número está no conjunto de sorteados do jogo.

### 5.3 Vitória (cartela cheia)
- Após cada sorteio, identifica as cartelas que atingiram os **20** números marcados **exatamente
  neste sorteio** (não eram ganhadoras antes).
- **1 cartela fechou** → recebe o próximo lugar disponível (1º, 2º…).
- **2+ cartelas fecharam no mesmo número** → **empate**: o jogo pausa (não pode sortear), o gerente
  aciona o **Desempate**. Ver 5.6.

### 5.4 "Quase lá"
- Após cada sorteio, calcula para cada cartela não-ganhadora quantos números faltam
  (`20 - marcados`). Destaca as que faltam ≤ `near_threshold` (default 2), com aviso mais forte
  para "falta 1".

### 5.5 Fim do jogo
- Termina quando o número de ganhadores atinge `winners_target` **ou** os números acabam.
- Se os números acabarem antes, encerra com os ganhadores que houver. `status='finished'`,
  `finished_at` preenchido.

### 5.6 Desempate por d20
- Quando `k ≥ 2` cartelas fecham no mesmo sorteio, forma-se um grupo de empate. O gerente clica
  **Desempate**; o servidor rola um **d20 (1–20)** para cada cartela do grupo (`round=1`, gravado).
- Ordena por rolagem **decrescente** (maior valor = lugar melhor). Se houver empate no dado entre
  cartelas cuja ordem relativa ainda importa, rola novamente **apenas entre as empatadas**
  (`round=2`, 3…), até obter ordem estrita.
- Atribui os lugares consecutivos a partir do próximo lugar disponível, **até `winners_target`**.
  Se sobrarem cartelas do grupo além dos prêmios restantes, elas **ficam sem prêmio**.
- Só depois de resolvido o desempate o jogo volta a permitir sorteio (ou encerra, se bateu a meta).

### 5.7 Modo de sorteio (manual + auto)
- **Manual** (padrão): o gerente clica "Girar" a cada número.
- **Auto**: o front chama o sorteio sozinho a cada X segundos (controle na tela, default ~5s),
  **pausando automaticamente** quando há empate (para rolar o d20) ou quando o jogo termina.
  O servidor não roda timer próprio.

### 5.8 Participação
- Participantes são colaboradores selecionados na criação. Uma cartela por participante por jogo.
- Um colaborador pode estar em **vários jogos** ao mesmo tempo (uma cartela por jogo, independentes).
- `winners_target` deve ser ≤ número de participantes (validado na criação).

## 6. API (`/bingo`)

**Gerente (`manager`/`master_admin`, via `require_manager`):**
- `POST /bingo/games` — cria o jogo `{name, number_pool, winners_target, near_threshold,
  participant_user_ids[]}` → gera as cartelas. Valida monte múltiplo de 10, `winners_target` ≤ nº
  de participantes e monte suficiente para unicidade.
- `GET /bingo/games` — lista os jogos da empresa (com status e contadores).
- `GET /bingo/games/{id}` — detalhe: cartelas, sorteados (ordenados), ganhadores, e o estado de
  "quase lá" calculado.
- `POST /bingo/games/{id}/start` — `draft` → `running` (`started_at`).
- `POST /bingo/games/{id}/draw` — sorteia o próximo número (servidor), marca, detecta vitória/empate;
  devolve o número e o estado atualizado. Bloqueado se houver empate pendente ou jogo não-`running`.
- `POST /bingo/games/{id}/tiebreak` — rola o d20 do grupo empatado e resolve os lugares (re-rola se
  empatar no dado); devolve as rolagens e a ordem final.
- `POST /bingo/games/{id}/cancel` — `status='cancelled'`.
- `DELETE /bingo/games/{id}` — exclui (permitido em `draft`/`cancelled`/`finished`).

**Participante (autenticado, só os próprios dados):**
- `GET /bingo/my` — jogos em que a pessoa está + estado resumido.
- `GET /bingo/my/{game_id}` — a cartela da pessoa + sorteados + situação (faltam N, posição na corrida).

**Tempo real:** o front dá `GET` nesses endpoints a cada ~2s (React Query `refetchInterval`).
O gerente que sorteia recebe o estado na resposta do próprio `POST /draw`.

## 7. Frontend

**Admin (`/admin/bingo`):**
- `BingoAdminPage` — lista de jogos + botão criar.
- `CreateBingoGameDialog` — form (nome, monte 30/60/90, nº ganhadores, aviso faltando 1–2, seleção
  de participantes via `Combobox`/multi-seleção de colaboradores).
- `BingoLiveGame` — tela ao vivo aprovada: roleta/bola do número atual, botões Girar e Auto,
  últimos sorteados, painel 1…`pool`, painel "quase lá", painel de ganhadores, avisos.
- `BingoTiebreakDialog` — o momento do d20 (rolagens por cartela, re-rolar em empate).
- `BingoPrintSheet` — folha 3×3 paisagem com `@media print` (`@page { size: A4 landscape }`,
  quebra a cada 9 cartelas), visual azul + `hs.ico`, código e faixas por coluna.

**Participante (`/bingo`):**
- `MyBingoPage` — lista dos jogos da pessoa → `BingoPlayerCard` (cartela ao vivo + status:
  "18/20", faltam N, posição, aviso de vitória).

**Compartilhado:**
- `BingoCard` — componente da cartela 10×3 (reusado em tela e impressão), estados marcado/pendente/vazio.
- `src/types/bingo.ts`, e objeto `bingo` em `src/lib/api.ts` (padrão dos outros módulos).

**Identidade visual:** azul para o Bingo (casas marcadas, destaques), sobre o tema escuro do app;
impressão em azul suave (tinta-amigável) com `hs.ico` no topo de cada cartela.

## 8. Segurança e auditoria
- Endpoints de gerente exigem `require_manager`; endpoints do participante só retornam dados da
  própria pessoa. RLS por `company_id`.
- Sorteio e d20 acontecem no servidor (não forjáveis). Todo o histórico (cartelas, sorteios,
  ganhadores, rolagens) fica persistido.

## 9. Changelog e versão
Feature nova visível ao usuário → bump **minor** (ex.: `v1.8.0`), atualizando os 3 lugares
(`ChangelogModal.tsx`, `AdminSidebar.tsx`, `package.json`) conforme o CLAUDE.md.

## 10. Decisões tomadas no brainstorming
- Vitória = cartela cheia (20 números). Cartela = sempre 30 casas (10×3), 20 cheias + 10 vazias.
- Monte de números configurável por jogo (30/60/90); nº de ganhadores configurável (3/5/7…).
- Layout da cartela = estilo coluna (Opção B). Impressão em paisagem, 9 por folha (3×3), azul + hs.ico.
- Empate → botão Desempate → d20 por cartela, maior leva o lugar melhor; empate no dado rola de novo.
  Se sobrarem empatados além dos prêmios restantes, ficam sem prêmio.
- Tempo real por polling (~2s); sorteio no servidor; auto conduzido pelo front.
