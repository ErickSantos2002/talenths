# Desligamento de Colaboradores — Design

**Data:** 29/10/2026 · **Status:** rascunho para aprovação · **Versão alvo:** v1.14.0 (minor — funcionalidade nova)

## Intenção

A Lidisay (RH, papel `manager`) precisa tirar do sistema quem saiu da empresa — hoje a
Karolaine e a Cláudia — e não consegue: só existe **excluir**, que é exclusivo do
Administrador e apaga login, perfil e histórico. Excluir é a decisão errada para quem foi
desligado: o RH perde avaliações, PDI, ponto e testes da pessoa.

O que o Erick pediu: o **RH desativa** o colaborador, que **para de contar para tudo** no
sistema, **não consegue mais entrar**, pode ser **reativado** depois (recontratação), e o
**histórico continua acessível ao RH**. Ao desativar, o RH registra **data e motivo** do
desligamento.

**Sucesso:** a Lidisay desliga a Karolaine e a Cláudia sozinha, pela tela de Colaboradores;
elas somem dos aniversários, das listas de seleção, das contagens e dos indicadores; não
conseguem mais entrar; e o RH ainda acha o PDI, a avaliação e o ponto delas quando precisa.

## Objetivos

1. `manager` e `master_admin` **desligam** e **reativam** colaboradores na Gestão de
   Colaboradores.
2. Ao desligar, o RH informa **data do desligamento**, **motivo** (lista fechada) e uma
   **observação** livre.
3. Desligado **não entra** (senha e Microsoft) e uma sessão já aberta **cai na próxima
   requisição** — sem esperar o token de 24h vencer.
4. Desligado **não conta** em nada que significa "equipe atual" (lista abaixo).
5. Desligado **não pode ser alvo** de nada novo (PDI, onboarding, curso, teste, vídeo,
   bingo, lançamento de ponto, notificação).
6. **Nada é apagado.** O histórico continua no banco e acessível ao RH.
7. Reativar devolve a pessoa a tudo, com o mesmo login, senha, papel e departamento.

## Não-objetivos

- Ficha individual da pessoa (tela nova que junta todo o histórico) — fica para outro projeto.
- Desligamento agendado (data futura que desativa sozinha). A data é informativa; a
  desativação vale na hora do clique.
- Relatório de rotatividade (turnover) — os dados ficam prontos para ele, mas a tela não
  entra agora.
- Mudar a exclusão definitiva: continua existindo, só para o Administrador.
- E-mail ou aviso para a pessoa desligada.

## Anti-objetivos (falha mesmo que "funcione")

- Qualquer dado da pessoa apagado ou alterado ao desligar — exceto os campos de
  desligamento e a data de fim dos benefícios em aberto (decisão do Erick, abaixo).
- Desligado que ainda consegue usar o sistema com um token antigo.
- Desligado que aparece em aniversário, lista de seleção ou contagem do dashboard.
- O RH não conseguir mais encontrar o PDI/avaliação/ponto de quem saiu.
- Filtro "só ativos" feito no frontend — o filtro é do backend (regra do projeto).

## Decisões do Erick

- **Desligar, não excluir.** Exclusão continua só do Administrador.
- **Sem login** depois de desligado; **pode ser reativado**.
- **Data + motivo** registrados. Motivo = **lista fechada + observação livre**.
- **Telas de gestão com histórico por pessoa**: desligados **ocultos por padrão**, com a
  opção **"Mostrar desligados"**; quando aparecem, levam a etiqueta **Desligado(a)**.
- **Benefícios em aberto são encerrados na data do desligamento**: todo
  `employee_benefits` da pessoa com `end_date IS NULL` (ou posterior à data) recebe
  `end_date = termination_date`, na mesma transação. Ao reativar, nada volta sozinho — o RH
  cadastra de novo o que valer.

## Decisões minhas (Claude) — conferir

- **Modelo de dados em duas partes** (detalhe abaixo): `profiles.deactivated_at` como
  a única coluna de filtro, e uma tabela de registros de desligamento que guarda um
  registro por desligamento — assim uma recontratação não apaga o desligamento anterior.
- **Motivos:** Pedido de demissão · Demissão sem justa causa · Demissão por justa causa ·
  Fim de contrato ou de experiência · Acordo entre as partes · Outro. Observação
  **obrigatória só quando o motivo é Outro**.
- **Data do desligamento:** padrão hoje, pode ser passada, **não pode ser futura**.
- **Quem pode desligar quem:** `manager` desliga `user` e `manager`; só `master_admin`
  desliga `master_admin`; **ninguém desliga a si mesmo**. Reativar segue a mesma regra.
- **Reativar** pede só confirmação (sem formulário).
- **Pendências abertas** (vídeo pendente, teste atribuído, onboarding em andamento, ciclo
  de avaliação aberto) **não são canceladas** ao desligar: ficam como histórico e saem
  das listas/contagens pelo filtro. Ao reativar, voltam como estavam.
- **Nome nas telas de histórico por item** (comentário de meta, feedback, ausência, cartela
  de bingo, documento): continua aparecendo o nome, **sem etiqueta** nesta versão — a
  etiqueta só entra nas telas de equipe com o filtro. É o que mantém o escopo contido.
- O vínculo `user_managers` **não é lido em lugar nenhum** do sistema; desligar não mexe nele.
- **Seletores de pessoa que levam ao histórico** (aba por pessoa do **Ponto**, aba
  **Colaboradores** dos **Benefícios**) seguem a decisão do Erick sobre histórico: ganham
  **"Mostrar desligados"** e usam `GET /collaborators?status=all` quando ligado. Seletores
  de **alvo** (atribuir, convidar, escolher responsável) nunca mostram desligados.
- **Indicadores e contagens de acompanhamento** (vídeos: obrigatórios/concluídos/
  atrasados; testes atribuídos; progresso de onboarding; inscritos em workshop; resumo de
  benefícios) **excluem desligados por inteiro** — pendentes e concluídos. As listas de
  detalhe dessas telas seguem a regra "ocultos + Mostrar desligados".
- **Reativar aplica de novo as regras de vídeo**: quem volta recebe os vídeos de "todos"
  ou do seu departamento publicados enquanto esteve fora (com as notificações). Na
  prática: o trigger de perfil da 029, recriado na 032, também dispara quando
  `deactivated_at` passa de preenchido para vazio.
- **Exclusão definitiva continua possível** depois de desligar: as colunas
  `deactivated_by`/`reactivated_by` aceitam nulo e usam `ON DELETE SET NULL`; o nome de
  quem fez continua no log de auditoria.

## Modelo de dados — migração `032_collaborator_deactivation.sql`

```sql
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS deactivated_at timestamptz;
CREATE INDEX IF NOT EXISTS idx_profiles_company_active
  ON public.profiles(company_id) WHERE deactivated_at IS NULL;

CREATE TABLE IF NOT EXISTS public.collaborator_terminations (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id        uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  company_id        uuid NOT NULL REFERENCES public.companies(id),
  termination_date  date NOT NULL,
  reason            text NOT NULL CHECK (reason IN (
                      'resignation', 'dismissal_without_cause', 'dismissal_with_cause',
                      'contract_end', 'mutual_agreement', 'other')),
  note              text,
  deactivated_at    timestamptz NOT NULL DEFAULT now(),
  deactivated_by    uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reactivated_at    timestamptz,
  reactivated_by    uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  CHECK (reason <> 'other' OR coalesce(btrim(note), '') <> '')
);
-- No máximo um desligamento em aberto por pessoa.
CREATE UNIQUE INDEX IF NOT EXISTS uq_collaborator_terminations_open
  ON public.collaborator_terminations(profile_id) WHERE reactivated_at IS NULL;
```

- **Ativo** = `profiles.deactivated_at IS NULL`. Toda consulta "equipe atual" usa só isso.
- Desligar = numa transação, `INSERT` em `collaborator_terminations` + `UPDATE profiles SET
  deactivated_at = now()` + encerramento dos benefícios em aberto. Reativar = `UPDATE` do registro aberto (`reactivated_at/by`) +
  `deactivated_at = NULL`.
- Script `backend/scripts/aplicar_032.py` no padrão dos anteriores, rodado pelo Erick.
- O DDL entra também no `captures-db.sh` (via migrações) e na semente das capturas, que
  deve ganhar **um desligado fictício** para as telas com "Mostrar desligados".
- Funções e trigger da migração 029 (`internal_video_apply_rules`,
  `internal_videos_on_profile_change`) passam a ignorar desligados — via
  `CREATE OR REPLACE` nesta migração nova, nunca editando a 029 — e o trigger passa a
  disparar também na reativação (ver decisões minhas).

## Backend

### Acesso (objetivo 3)

- `POST /auth/login` e `/auth/microsoft/callback`: desligado recebe **403** "Seu acesso foi
  desativado. Procure o RH." — **depois** de validar a senha, para não revelar a quem não
  sabe a senha que o e-mail existe.
- **Checagem por requisição** no `get_db` (já abre conexão em toda rota autenticada): a
  mesma ida ao banco do `set_config` passa a devolver `deactivated_at` do usuário; se
  preenchido → **401**. O frontend já trata 401 encerrando a sessão. Custa uma consulta
  por requisição, por índice único em `profiles.user_id` — aceitável para 28 pessoas.
  Rotas que não passam pelo `get_db` (ex.: stream de vídeo por token) precisam ser
  conferidas uma a uma.
- `/auth/me` de desligado → 401 pelo mesmo caminho.

### Novos endpoints (em `collaborators.py`)

| Rota | Quem | Faz |
|---|---|---|
| `POST /collaborators/{profile_id}/deactivate` | manager, master_admin | body `{termination_date, reason, note?}`; aplica as regras de quem-desliga-quem; 409 se já desligado |
| `POST /collaborators/{profile_id}/reactivate` | manager, master_admin | mesma regra de papéis; 409 se já ativo |
| `GET /collaborators?status=active\|inactive\|all` | manager, master_admin | padrão `active`; cada item traz `deactivated_at` e, se desligado, o desligamento em aberto (data, motivo, observação) |

O `GET /collaborators` também passa a **restringir à empresa de quem chama** quando
`company_id` não vem (hoje devolve todos os perfis) — é a mesma consulta que está sendo
mexida, e o sistema é single-tenant por regra.

### Onde filtrar — "equipe atual" (ocultar desligados)

Somem sempre, sem opção de mostrar:

- `GET /collaborators` (padrão) — alimenta **todas** as listas de seleção: bingo, público
  de vídeo, responsável de meta, benefícios, onboarding, ponto, atribuição de teste,
  feedbacks, PDI, documentos.
- `GET /profiles` — contagens do Dashboard e do Dashboard da Empresa.
- `GET /communications/birthdays` e `/milestones`; aniversários do `GET /calendar/feed`;
  ausências **futuras** de desligados no calendário.
- `GET /salary/positioning`; `GET /tour/adoption` (denominador); `GET /reports/collaborators`
  (CSV: padrão só ativos, com opção "Incluir desligados" que acrescenta as colunas
  Situação, Data do desligamento e Motivo).
- Contagem de pessoas por departamento na aba Departamentos.
- `POST /evaluations/cycles/{id}/consolidate` — não consolida desligados (notas já
  consolidadas ficam).
- Notificação a gestores ao enviar teste (`custom_tests.py`, submit) — não notifica
  gestor desligado.
- Indicadores de acompanhamento: `GET /videos/admin` e `GET /videos/{id}/admin`
  (contagens), `GET /benefits/summary`, contagens de testes atribuídos, progresso de
  onboarding e inscritos em workshop.

Ocultos por padrão, com `?include_inactive=true` e **"Mostrar desligados"** na tela:

- `GET /pdi/team` (PDI da Equipe), `GET /onboarding/team` (Onboarding),
  `GET /learning/team` (Universidade), `GET /timeclock/team` (Ponto),
  `GET /evaluations/team-status` e `GET /evaluations/9box` (Avaliação / Mapa 9-Box),
  `GET /career/team` (Trilha de Carreira), listas de pessoas por vídeo
  (`GET /videos/{id}/admin`) e por teste (tentativas/atribuições).
- Seletores de histórico do **Ponto** (aba por pessoa) e dos **Benefícios** (aba
  Colaboradores), via `GET /collaborators?status=all`.
- Cada item volta com `deactivated_at`, para a tela pôr a etiqueta **Desligado(a)**.

### Bloquear como alvo (objetivo 5) — 422 "Colaborador desligado"

`POST /pdi/plans`, `POST /onboarding/assign`, `POST /learning/employee/{id}`,
`POST /learning/import-csv` (linha de desligado vira aviso, não erro do arquivo todo),
atribuição de teste em `custom_tests.py`, alvos individuais de vídeo (`videos.py`),
`POST /bingo/games` (`participant_user_ids` hoje nem são validados), `POST /timeclock/manual`,
responsável de meta. A regra também vale para "todos"/"departamento" nas regras de vídeo
(SQL da 029).

### Fica como está (histórico — mostra desligados)

Consultas por id e listas de itens: resultados de teste e tentativas, feedbacks,
documentos, ausências, benefícios por pessoa, comentários e histórico de metas, cartelas
de bingo, inscrições em workshop, histórico de ponto por pessoa, relatórios de período
(ausências, benefícios, PDI, universidade), log de auditoria.

### Auditoria

Desligar e reativar passam pelo middleware de auditoria como qualquer POST; conferir que
o log mostra quem fez e em quem.

## Frontend

**Gestão de Colaboradores** (`AdminCollaboratorsPage.tsx`):
- Seletor **Ativos / Desligados / Todos** acima da lista (padrão Ativos).
- Na linha de um ativo: ação **Desligar** (ícone `UserX`), visível para quem pode
  desligar aquela pessoa. Abre um diálogo: **Data do desligamento** (padrão hoje, sem
  data futura), **Motivo** (select), **Observação** (obrigatória se Outro). Botão
  **Desligar colaborador**. O texto do diálogo diz em uma frase o que acontece: a pessoa
  perde o acesso na hora, sai das listas e contagens, e o histórico fica guardado.
- Na linha de um desligado: etiqueta **Desligado(a) em DD/MM/AAAA**, motivo visível
  (tooltip ou linha secundária), ação **Reativar** com confirmação. Editar e redefinir
  senha somem para desligados (reativar primeiro).
- Excluir continua só para Administrador, também para desligados.

**Telas com "Mostrar desligados"**: PDI da Equipe, Onboarding, Universidade, Ponto
(visão do dia e aba por pessoa), Benefícios (aba Colaboradores), Avaliação, Mapa 9-Box,
Trilha de Carreira, detalhe de vídeo e tentativas de teste — um `Switch` (shadcn) no cabeçalho dos
filtros; desligados com `Badge` **Desligado(a)**.

**Login**: mensagem do 403 aparece como está ("Seu acesso foi desativado. Procure o RH.").

**Componente de etiqueta** único (ex.: `InactiveBadge`) reaproveitado em todas as telas.

## Ajuda, changelog, testes

- Guia `administracao/colaboradores.md`: seção **Para desligar uma pessoa** e **Para
  reativar**; atualizar "Dúvidas comuns" (excluir × desligar); refazer a captura
  `admin-colaboradores`. Guias das telas que ganham "Mostrar desligados" ganham uma frase
  cada (e captura refeita se o controle aparecer nela).
- Se algum cabeçalho com `data-tour` mudar, conferir o passo do tour no mesmo commit.
- Changelog **v1.14.0** nos 3 lugares (modal, sidebar, `package.json`), texto para o
  usuário final.
- **Testes de banco** (`backend/tests/db/`, padrão dos existentes): migração 032; desligar
  e reativar (regras de papel, 409, data futura, Outro sem observação); login e token de
  desligado rejeitados; `GET /collaborators` por status; ao menos uma rota de cada grupo
  (equipe atual, com `include_inactive`, alvo bloqueado); regras de vídeo da 029 ignorando
  desligado.
- `bun run test` (contratos de ajuda) e `pytest` antes de commitar.

## Deploy

1. Erick roda `backend/scripts/aplicar_032.py`.
2. Backend.
3. Frontend.
4. Lidisay desliga a Karolaine e a Cláudia pela tela.

## Deixado para quem implementar

- Como organizar o filtro no código (helper SQL, fragmento reaproveitado ou parâmetro) —
  desde que fique num lugar só e seja difícil esquecer numa consulta nova.
- Texto exato de diálogos e mensagens, seguindo o tom das telas vizinhas.
- Ordem das tarefas no plano.
