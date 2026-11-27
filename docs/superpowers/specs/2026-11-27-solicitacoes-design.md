# Ausências vira Solicitações: saída e pagar hora

**Por quê:** quem sai durante o expediente fica devendo horas e paga fazendo hora extra
depois. Esse combinado hoje acontece fora do sistema. O melhor lugar para pedir é o
TalentHS, junto do pedido de saída. A tela deixa de ser "Ausências" e passa a ser
**Solicitações** ao RH: o foco é o pedido, não a falta.

**Decidido com o Erick (27/11/2026):**
- Dois tipos de solicitação: **Saída** (o que existe hoje) e **Pagar hora** (novo).
- Pagar hora é um **pedido solto**: dia + horário da hora extra + motivo, aprovado pelo
  RH. Não liga a uma saída anterior e **não controla saldo** — o ponto/banco de horas é
  em outro sistema.
- Renomear o conceito em tudo (banco, API, páginas, rotas, guias), não só na tela.
- A aba **Solicitações** do Ponto Eletrônico passa a se chamar **Pedidos de ajuste**,
  para não ter dois "Solicitações" no menu.

**Não é objetivo:** banco de horas, saldo devido/pago, vincular pagar hora a uma saída,
notificação da decisão, mudar as regras de aprovação ou edição que já existem.

**Anti-objetivo:** quebrar o Guardi (HS.OS), que chama `/absences/*` hoje.

## Abordagens

1. **Renomear tudo + categoria no tipo (escolhida).** Uma tabela só de solicitações, cada
   tipo com `category` (`saida` | `pagar_hora`). O fluxo (pedido → aprovação → histórico,
   edição do pendente, filtros, paginação) é idêntico, então reaproveita tudo.
2. **Só renomear a tela** (descartada): código continua `absences` com um tipo que não é
   ausência — o CLAUDE.md pede renomear o conceito quando o domínio muda.
3. **Tabela separada para pagar hora** (descartada): duplica fluxo, histórico e filtros;
   o RH olharia dois lugares.

## Desenho

### 1. Banco — migração `040_hr_requests.sql`
- `ALTER TABLE absence_types RENAME TO hr_request_types`;
  `ALTER TABLE absence_requests RENAME TO hr_requests`. Renomear os índices
  `idx_absence_requests_*` → `idx_hr_requests_*`. (FKs, defaults e eventuais policies
  acompanham o rename da tabela.)
- `hr_request_types.category text NOT NULL DEFAULT 'saida' CHECK (category IN ('saida','pagar_hora'))`.
- Inserir o tipo fixo **Pagar hora** (`category = 'pagar_hora'`, `requires_approval = true`,
  cor própria — sugestão `#10b981`) para cada empresa que já tem tipos, no mesmo padrão
  idempotente da 038.
- Colunas de `hr_requests` não mudam (`days = 0` em pedido de horário, como hoje).

### 2. Backend
- `routers/absences.py` → `routers/requests.py`, prefixo **`/requests`**. Tudo que diz
  `absence` no código vira `request`/`hr_request`.
- **Compatibilidade com o HS.OS:** o mesmo router também é incluído com prefixo
  `/absences` (apelido), até o HS.OS migrar. Comentário marcando o apelido como
  temporário, citando a spec do HS.OS. O allowlist do agente (`auth/agente.py`:
  leituras, `ESCRITAS_DO_AGENTE`, `SO_RH`) e o middleware de auditoria aceitam as duas
  formas; o teste `test_agente_capacidades_api.py` passa a cobrir as duas.
- **O apelido `/absences` responde exatamente o que responde hoje:** em `/types`, `/my`,
  `/team`, `/team/pending`, `/team/history`, `/team/people` e `/calendar` ele filtra
  `category = 'saida'` (dependência que olha o prefixo da URL). Assim o HS.OS sem migrar
  não avisa o RH de "ausência" que é hora extra, nem oferece o tipo Pagar hora num pedido
  sem horário. Testes cobrem o filtro pelo apelido. *(decisão do Claude)*
- **`GET /agente/capacidades` lista as duas formas** durante a transição. O HS.OS cruza
  a resposta como conjunto contra o próprio catálogo (`HS.OS/backend/app/capacidade.py`)
  e mostra assuntos escritos à mão, então par repetido não duplica nada na tela; listar
  só `/requests` faria as ações de ausência sumirem para quem ainda não migrou.
  *(decisão do Claude)*
- `DEFAULT_TYPES` ganha Pagar hora; `_ser_type` e `_ser_request` devolvem
  `category` / `type_category`.
- **Validação:** pedido de tipo `pagar_hora` exige `start_time` e `end_time` no mesmo
  dia (400 sem horário). Saída continua aceitando dia inteiro, período ou horário. Motivo
  ≥ 20 caracteres vale para os dois.
- **Calendário** (`/requests/calendar` e `/calendar/feed`): só `category = 'saida'` —
  o calendário mostra quem vai estar fora; quem vai fazer hora extra não está fora.
  No `/calendar/feed`, `"source": "absence"` e `"event_type": "absence"` **ficam como
  estão**: o item continua sendo uma ausência de verdade (só saídas entram), e o HS.OS e
  `types/calendar.ts` dependem desses valores. *(decisão do Claude)*
- **Relatório:** `/reports/requests` (com `/reports/absences` como apelido), coluna nova
  **Categoria**, arquivo `solicitacoes.csv`.
- Textos da auditoria: "Solicitação criada/aprovada/recusada/editada/removida".
- `bruce_agent.py` (raiz do repo) passa a usar `/requests`.

### 3. Frontend
- Rotas: **`/admin/solicitacoes`** e **`/minhas-solicitacoes`**; as antigas
  (`/admin/ausencias`, `/minhas-ausencias`) redirecionam com `<Navigate replace>`.
- Páginas `AbsencesAdminPage` → `RequestsAdminPage`, `MyAbsencesPage` →
  `MyRequestsPage`; `types/absences.ts` → `types/requests.ts`; funções da `lib/api.ts`
  renomeadas. Menu (`help/screens.ts`): **Solicitações** e **Minhas Solicitações**.
- **Colaborador:** botão **Nova solicitação** abre o diálogo com a escolha
  **Saída** | **Pagar hora** no topo.
  - Saída: o formulário de hoje (tipo entre Ida ao médico / Saída pessoal / Outro, dia
    inteiro ou parte do dia, motivo).
  - Pagar hora: **Dia**, **Das** / **Às** (obrigatórios), **Motivo**. Sem select de tipo.
  - Editar um pendente abre na categoria dele; não troca de categoria na edição.
  - Na lista, cada pedido mostra a categoria (selo "Saída" / "Pagar hora").
- **RH:** a lista de pendentes e o histórico mostram o selo da categoria. O filtro
  **Todos os tipos** inclui Pagar hora (não precisa de filtro separado). A aba
  **Calendário** continua só com saídas.
- **Ponto Eletrônico:** aba **Solicitações** → **Pedidos de ajuste** (rótulo, comentário
  e guia `ponto-eletronico.md`).

### 4. Ajuda, tour, capturas, versão
- Guias: `administracao/ausencias.md` → `solicitacoes.md`; `rh/minhas-ausencias.md` →
  `minhas-solicitacoes.md`, com `telas` nas rotas novas e seção sobre Pagar hora (e que
  ela não aparece no Calendário). Atualizar links internos em `relatorios.md`,
  `calendario.md`, `ajuda-desta-tela.md`, `como-navegar-pelo-menu.md`.
- Conferir tours/`data-tour` que apontem para as telas ou itens de menu renomeados.
- Semente (`seed_captures.py`): tabelas novas, rotas `/requests`, um pedido de Pagar
  hora pendente e um aprovado. Capturas `admin-solicitacoes` e `minhas-solicitacoes`
  (renomear em `captures.config.ts`, apagar os `.webp` antigos) e refazer `admin-ponto`
  se a aba aparecer nela.
- Changelog **v1.24.0** (minor), com data de entrega, nos 3 lugares.

### 5. Entrega para o HS.OS (outro repo — só spec, não edito)
Documento curto entregue ao Erick para a sessão do HS.OS:
- trocar `/absences/*` → `/requests/*` em `talenths_escrita.py`, `talenths_preparo.py`,
  `avisos_ausencia.py`;
- o aviso de ausência ao RH deve **ignorar `type_category = 'pagar_hora'`** (ou tratá-lo
  como aviso próprio) — ele passa a aparecer em `/requests/team`;
- rótulos das ações ("Pedir ausência" → "Pedir saída"/"Pedir solicitação", etc.) e,
  se quiser, uma ação nova de pedir Pagar hora (exige `start_time`/`end_time`).
Depois que o HS.OS migrar, um commit aqui remove o apelido `/absences`.

**Ordem de deploy:** backend (aplica a 040 sozinho) → frontend. Com o apelido, o HS.OS
continua funcionando durante e depois do deploy.

## Fica com quem constrói
Cor exata do tipo Pagar hora, texto dos selos, organização do diálogo (abas, radio ou
segmented control usando os primitivos shadcn), e a divisão em commits.
