# HS.OS: migrar o Guardi de `/absences` para `/requests` (TalentHS v1.24.0)

**Para a sessão do HS.OS** (`cl HS.OS`). Este documento só descreve o que muda; a edição é
lá.

## O que mudou no TalentHS (27/11/2026)

Ausências virou **Solicitações**. Além do pedido de **saída** (o de sempre), o colaborador
pede para **pagar hora**: o dia e o horário da hora extra que compensa horas devidas. Os
dois passam pela aprovação do RH. O TalentHS não controla saldo de horas.

- Rotas novas: `/requests/*` (mesmos caminhos, corpos e respostas de `/absences/*`) e o
  relatório `/reports/requests`.
- **`/absences/*` continua funcionando como apelido**, mas **só enxerga saídas**: tipos,
  listas e histórico filtram `category = 'saida'`, e criar pedido com o tipo Pagar hora
  por ele dá 404. Ou seja, o Guardi de hoje segue igual e não vê pagar hora.
- O tipo (`GET /requests/types`) ganhou `category`: `"saida"` | `"pagar_hora"`.
- O pedido ganhou `type_category`, com os mesmos valores.
- Pagar hora **exige** `start_time` e `end_time` (mesmo dia). Sem eles: 400
  `"Pagar hora precisa do horário de início e de fim"`.
- Na edição, trocar de categoria dá 400 `"Não é possível trocar a categoria da solicitação"`.
- `/requests/team/history` aceita `category` como filtro.
- `GET /agente/capacidades` lista as duas formas durante a transição.
- Auditoria: os rótulos passaram a ser "Solicitação criada/aprovada/recusada/editada/removida".
- `/calendar/feed` não mudou (`source`/`event_type` continuam `"absence"`) e não traz pagar hora.

## O que mudar no HS.OS

1. **Trocar `/absences` → `/requests`** nos 4 arquivos que chamam:
   `backend/app/talenths_escrita.py`, `talenths_consultas.py`, `talenths_preparo.py`,
   `avisos_ausencia.py` (e `/reports/absences` → `/reports/requests`, se usado). As rotas
   do catálogo de capacidade acompanham.
2. **Aviso ao RH (`avisos_ausencia.py`)**: em `/requests/team` passam a vir pedidos de pagar
   hora. Decidir: ignorar `type_category == "pagar_hora"` ou avisar com texto próprio
   ("pediu para pagar hora em DD/MM, das HH:MM às HH:MM"). O aviso de decisão ao colaborador
   também precisa do texto certo para cada categoria.
3. **`pedir_ausencia`**: a descrição ainda fala em "férias, folga" (fora do TalentHS desde a
   038). Passar a "pedir saída (ida ao médico, saída pessoal ou outro)" e, em
   `talenths_preparo._ausencia_nova`, recusar tipo de `category == "pagar_hora"`.
4. **Ação nova, opcional — `pedir_pagar_hora`**: `POST /requests/request` com `type_id` do
   tipo `category == "pagar_hora"`, `start_date`, `start_time`, `end_time` obrigatórios e
   `reason` ≥ 20 caracteres.
5. **Rótulos** em `frontend/src/lib/acoes.ts` ("Pedir ausência", "Aprovar ausência"…) e o
   assunto "Férias e ausências" da capacidade: "Solicitações ao RH" / "Pedir saída" etc.

## Depois

Quando o HS.OS estiver em produção usando `/requests`, avisar a sessão do TalentHS: ela
remove o apelido `/absences` (router `legacy_router` em `app/routers/requests.py`, as rotas
`/absences` em `app/auth/agente.py`, o `/reports/absences` e os padrões da auditoria).
