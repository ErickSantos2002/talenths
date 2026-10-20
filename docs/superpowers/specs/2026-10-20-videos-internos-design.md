# Vídeos Internos — Design

**Data:** 20/10/2026 · **Status:** rascunho para aprovação · **Versão alvo:** v1.9.0 (minor — funcionalidade nova)

## Intenção

O RH pediu uma página de **vídeos internos** no TalentHS: o RH sobe um vídeo, marca quem
precisa assistir, e sabe com confiança **quem assistiu e quem não assistiu** — tanto
funcionários atuais quanto os que entrarem depois.

**Natureza dos vídeos:** não são treinamentos — são vídeos de **integração (onboarding) e
apresentação da empresa** (cultura, estrutura, boas-vindas etc.). Textos de UI, changelog e
comentários não devem falar em "treinamento" nem "curso".

Existe algo parecido no DocsHS (treinamento com vídeo), que serve de **base de
comportamento**, não de código a copiar: lá o vídeo é parte de uma "ata" de treinamento,
com prova e assinatura; aqui é só o vídeo.

**Sucesso:** o RH abre um vídeo e vê, sem planilha paralela, quem concluiu (com data/hora),
quem está pendente e quem está atrasado — e acredita no dado.

## Objetivos

1. RH (papéis `manager` e `master_admin`) sobe vídeos MP4 de até 2 GB.
2. RH marca quem deve assistir: **pessoas individuais, departamentos inteiros e/ou todos**.
3. Quem entrar depois num departamento marcado (ou na empresa, se "todos") **recebe o vídeo
   automaticamente**.
4. "Assistido" = viu **até o fim, sem pular**, verificado no servidor.
5. **Prazo opcional** por vídeo; atrasados aparecem destacados para o RH.
6. Funcionário é avisado por **notificação no sistema** (sino existente) e vê pendências
   destacadas no **dashboard**.
7. Funcionário pode assistir **qualquer vídeo da biblioteca**, não só os obrigatórios.

## Não-objetivos (fora desta versão)

- Prova/questionário após o vídeo.
- Exportação de relatório (planilha/PDF).
- Categorias/agrupamento de vídeos.
- E-mail.
- Conversão de formato (sem ffmpeg/transcodificação).
- Assinatura/ciência formal (como no DocsHS).

## Anti-objetivos (seria falha mesmo funcionando)

- O dado "assistiu" ser burlável com facilidade (arrastar a barra até o fim, acelerar 16×,
  chamar a API com a posição final).
- O vídeo precisar ser baixado inteiro antes de começar a tocar (o padrão de blob usado em
  `DocumentPreviewDialog` não serve para vídeo).
- Vídeos acessíveis sem autenticação por URL permanente.
- Vídeos sumirem num redeploy (arquivo fora do Volume persistente).
- Um funcionário que mudou de departamento perder histórico ou pendências.

## Decisões tomadas pelo Erick

| Tema | Decisão |
|---|---|
| Atribuição | Pessoas + departamentos + todos; novos entrantes em departamento marcado recebem automaticamente |
| Critério de "assistido" | Até o fim, sem pular (bloqueio no player + validação no servidor) |
| Prazo | Opcional por vídeo, em **dias após a pessoa receber** o vídeo (novo entrante não nasce atrasado); atrasados destacados |
| Quem conta em "todos"/departamento | Todos os perfis da empresa, inclusive `manager` e `master_admin` |
| Colaborador excluído | O registro de vídeo **sobrevive** com nome e departamento congelados; aparece como "ex-colaborador", fora das contagens |
| Aviso | Notificação no sistema + destaque no dashboard |
| Biblioteca | Todos os vídeos visíveis a todos; os atribuídos aparecem como obrigatórios |
| Extras | Nenhum nesta versão |
| Arquivo | Somente MP4, até 2 GB; outros formatos recusados com mensagem clara |
| Troca de arquivo | O RH escolhe na hora: "manter quem já concluiu" ou "todos assistem de novo" |
| Mudança de departamento | Mantém tudo o que já tinha; só ganha os vídeos do novo departamento |
| Armazenamento | Volume do EasyPanel no VPS (não S3) |

## Restrições

- Stack existente: FastAPI + asyncpg (SQL cru, sem ORM), React + React Query + shadcn.
- Migração nova `backend/migrations/029_internal_videos.sql`; nunca editar migrações antigas.
- Single-tenant, mas as tabelas seguem o padrão `company_id` do resto do banco.
- Backend roda uvicorn com **4 workers** — nada de estado de upload em memória; tudo em
  disco/banco.
- Arquivos sob `settings.UPLOADS_DIR` (`/app/uploads`), em `/{company_id}/videos/`.
  Usar `settings`, não caminho fixo (o `documents.py` tem caminho fixo — não copiar isso;
  seguir o padrão de `goals.py:835-899`).
- `<video>` não envia header `Authorization` → reprodução por **token curto na URL**.
- UI em pt-BR; código em inglês; changelog/versão nos 3 lugares do `CLAUDE.md`.

## Como funciona

### Modelo de dados (migração 029)

**`internal_videos`** — o vídeo.
`id`, `company_id`, `title`, `description` (opcional), `file_path`, `file_size`,
`duration_seconds` (numérico, lido do arquivo no servidor), `due_days` (int > 0, nulo = sem
prazo), `file_version` (int, incrementa a cada troca), `archived_at` (nulo = ativo),
`created_by`, `created_at`, `updated_at`.

**`internal_video_rules`** — *como* o RH marcou (para reexibir a seleção e para atribuir
automaticamente quem chega depois).
`id`, `video_id`, `target_type` (`all` | `department` | `user`), `department_id`, `user_id`,
`created_at`. CHECK coerente com `target_type`.

**`internal_video_viewers`** — *quem* está obrigado, materializado por pessoa, mais o
progresso. Uma linha por (vídeo, usuário). Também registra quem assistiu por vontade
própria.
`id` (PK), `video_id`, `user_id` (**nulo após exclusão do colaborador**, FK com
`ON DELETE SET NULL`), `user_name_snapshot`, `department_name_snapshot`, `required` (bool),
`excluded` (bool — o RH tirou a pessoa; ver abaixo), `assigned_at`, `max_watched_s`,
`last_report_at`, `completed_at`. UNIQUE (`video_id`, `user_id`).

**Exclusão de colaborador:** trigger BEFORE DELETE em `profiles` preenche os snapshots
(nome, nome do departamento) das linhas daquela pessoa antes do `SET NULL`. No detalhe do
vídeo essas linhas aparecem como "ex-colaborador" e **não entram** nas contagens
concluídos/obrigatórios nem em atrasados.

**Quem é "da empresa":** todo perfil com `company_id` igual ao do vídeo, qualquer papel
(inclusive `manager`/`master_admin`). Perfis com `company_id` nulo não entram. Como não há
filtro por papel, basta o trigger em `profiles` (nada em `user_roles`).

Por que materializar: regra dinâmica ("quem está no departamento X agora") tiraria a
pendência de quem muda de departamento — contraria a decisão "mantém o que já tinha".
As regras servem para **acrescentar** linhas; nunca removem.

**Atribuição automática de quem chega depois:** trigger em `profiles` (AFTER INSERT, e
AFTER UPDATE OF `department_id`) que insere em `internal_video_viewers` as linhas
`required = true` dos vídeos ativos cujas regras casam (`all` ou o departamento novo), com
`ON CONFLICT DO NOTHING` (e promovendo `required` para `true` se a linha existia como
voluntária), e cria a notificação correspondente. Trigger e não código no router porque
perfis são criados/alterados por vários caminhos (register, register-invite, trigger de
signup, edição de colaborador) e nenhum deve escapar.

**Tirar alguém da lista (decisão minha):** o RH pode tirar qualquer pessoa, venha ela de
regra individual, de departamento ou de "todos". Tirar = apagar a regra `user` dela, se
houver, e marcar a linha `excluded = true, required = false` (o progresso fica). A
exclusão **gruda**: o trigger de novo entrante/mudança de departamento e a gravação de
regras ignoram linhas `excluded`. Só volta se o RH a marcar de novo individualmente (o
que limpa `excluded`). Ao salvar regras (`PATCH`), só as regras **novas** são
materializadas; regras removidas não tiram ninguém já atribuído (coerente com "regras só
acrescentam").

**Arquivar (decisão minha):** vídeo arquivado some para os colaboradores (`/meus-videos`,
biblioteca, card do dashboard) e não recebe atribuição automática. Ao **reativar**, as
regras são reaplicadas para quem entrou ou mudou de departamento no meio tempo (respeitando
`excluded`), com notificação para os novos atribuídos.

### Envio do arquivo (upload em partes)

Direto do navegador para o backend, em partes, para não esbarrar em limite de corpo/timeout
do proxy do EasyPanel com arquivos de 2 GB:

1. `POST /videos/uploads` com nome e tamanho → valida tamanho ≤ 2 GB e espaço livre em
   disco; cria `/app/uploads/{company}/videos/tmp/{upload_id}.part`; devolve `upload_id`
   e tamanho de parte.
2. `PUT /videos/uploads/{upload_id}/parts/{n}` — grava a parte no offset certo
   (sequencial ou com escrita por offset, a critério do builder; precisa funcionar com
   4 workers).
3. `POST /videos/uploads/{upload_id}/complete` → confere tamanho total, valida **MP4 por
   magic bytes** (caixa `ftyp` com marca aceita, como `docshs/backend/app/services/video_formato.py`),
   lê a duração dos metadados MP4 no servidor, move para o caminho final.
4. `DELETE /videos/uploads/{upload_id}` cancela e apaga o temporário.

Temporários abandonados (> 24 h) são limpos (no `complete`/`start` seguinte ou em tarefa
periódica — critério do builder).

A criação do vídeo (título, descrição, prazo, regras) usa o `upload_id` concluído; trocar
o arquivo de um vídeo existente usa o mesmo fluxo de upload e um endpoint de troca.

### Troca de arquivo

`POST /videos/{id}/replace-file` com `upload_id` e `mode`:
- `keep_completed` — quem concluiu continua concluído; quem não concluiu volta a 0
  (a linha do tempo mudou).
- `reset_all` — todos voltam a pendente, `max_watched_s = 0`, `completed_at = null`.

Incrementa `file_version`, atualiza duração, apaga o arquivo antigo do disco, notifica os
obrigatórios que voltaram a pendente.

### Reprodução

- `POST /videos/{id}/stream-token` → JWT HS256 curto (~10 min) com `video_id`, `user_id`,
  `file_version`.
- `GET /videos/stream/{token}` (sem header de auth) → revalida no banco que o vídeo está
  ativo e a versão bate; responde o arquivo **com suporte a Range** (206), para permitir
  tocar sem baixar tudo e voltar no vídeo. `Cache-Control: no-store`.
- Token expirado no meio → o player pede outro e retoma da posição atual (como o DocsHS
  faz no `onError`).

### Progresso e o "assistiu" (antitrapaça, base DocsHS)

Referência: `docshs/backend/app/services/percurso_treinamento.py:176-249` e
`docshs/frontend/src/paginas/VideoDoTreinamento.tsx`.

- **Player:** `<video controls controlsList="nodownload noplaybackrate">` sem biblioteca.
  Avanço além do máximo já assistido é puxado de volta; velocidade presa em 1× até
  concluir. Depois de concluído, navegação livre.
- **Envio:** `POST /videos/{id}/progress {position_s}` a cada 10 s, e também em pause,
  `visibilitychange`, `pagehide` e ao sair da página.
- **Servidor guarda só o máximo assistido** e aceita avanço até
  `max + min(tempo_decorrido, 30 s) × 1,1 + folga` (folga de 15 s no primeiro envio, nunca
  maior que o tempo decorrido depois). Acima disso → 409 com o máximo atual e o player volta.
- **Conclusão:** `max_watched_s ≥ duration_seconds − 2 s` → grava `completed_at`.
- Assistir sem estar obrigado cria/atualiza a linha com `required = false`.

### Prazo e status

Prazo de cada pessoa = `assigned_at + due_days`, calculado na consulta (não gravado), de
modo que o RH alterar `due_days` vale para todos os pendentes. Quando uma troca de arquivo
faz alguém voltar a pendente, `assigned_at` **não** muda (decisão minha — o prazo segue o
original; o RH pode aumentar `due_days` se quiser).

Status de cada (vídeo, pessoa obrigatória):
- **Concluído** — `completed_at` preenchido.
- **Atrasado** — não concluído e agora > `assigned_at + due_days`.
- **Em andamento** — `max_watched_s > 0`.
- **Pendente** — o resto.

### Notificações

Insere em `public.notifications` (padrão `_notify` de `custom_tests.py:140-147`), tipo
`video`:
- ao ser atribuído (criação, edição de regras, trigger de novo entrante);
- quando uma troca de arquivo o faz voltar a pendente.

Sem lembretes de prazo nesta versão.

### Telas

**RH — `/admin/videos`** (`ProtectedRoute requiredRoles={["master_admin","manager"]}`;
entrada na seção "Comunicação" do `AdminSidebar`, ícone lucide):
- Lista de vídeos: título, duração, prazo, contagem concluídos / obrigatórios, atrasados
  destacados. Paginação com `TablePagination` + `usePageSize`.
- "Novo vídeo": diálogo com arquivo (barra de progresso do upload, cancelar), título,
  descrição, prazo opcional, seleção de quem assiste (todos / departamentos / pessoas,
  busca por nome).
- Detalhe do vídeo: editar dados e regras, trocar arquivo (pergunta o modo), arquivar,
  assistir, e a tabela de pessoas com status, progresso (%) e data/hora de conclusão,
  filtrável por status e departamento. Voluntários aparecem separados dos obrigatórios.

**Colaborador — `/meus-videos`** (`ProtectedRoute`; entrada em `personalSections`):
- "Obrigatórios": pendentes/atrasados primeiro, com prazo; concluídos depois.
- "Biblioteca": demais vídeos ativos.

**Player — `/videos/:id`**: título, descrição, player, indicador de progresso e estado
("concluído em ...").

**Dashboard do colaborador:** card "Vídeos pendentes" com quantidade e atalho, só quando
há pendências.

### Endpoints (resumo)

| Método e rota | Quem | Para quê |
|---|---|---|
| `POST /videos/uploads` · `PUT …/parts/{n}` · `POST …/complete` · `DELETE …` | RH | Upload em partes |
| `POST /videos` | RH | Cria vídeo (upload concluído + dados + regras) |
| `GET /videos/admin` · `GET /videos/{id}/admin` | RH | Lista e detalhe com status por pessoa |
| `PATCH /videos/{id}` | RH | Edita título, descrição, prazo, regras |
| `POST /videos/{id}/replace-file` | RH | Troca arquivo (`keep_completed` / `reset_all`) |
| `POST /videos/{id}/archive` · `…/unarchive` | RH | Arquivar/reativar |
| `DELETE /videos/{id}` | RH | Exclui de vez (arquivo + registros), com confirmação |
| `GET /videos/mine` | Todos | Obrigatórios + biblioteca do usuário |
| `GET /videos/{id}` | Todos | Dados do vídeo + progresso próprio |
| `POST /videos/{id}/stream-token` · `GET /videos/stream/{token}` | Todos | Reprodução |
| `POST /videos/{id}/progress` | Todos | Envio de posição |

## Deixado para o builder

- Tamanho de parte do upload, paralelismo e estratégia de escrita (precisa ser segura com
  4 workers).
- Biblioteca para ler a duração do MP4 no servidor (ex.: `mutagen`, pura Python) — sem
  ffmpeg.
- Confirmar que o `FileResponse` da versão instalada do Starlette atende Range; se não,
  implementar a resposta 206 manualmente.
- Forma da limpeza de temporários.
- Layout exato das telas, dentro do padrão das páginas admin existentes
  (`AdminDocumentosPage.tsx` / `MeusDocumentosPage.tsx`).
- Testes: no mínimo, a regra antitrapaça e a atribuição automática (trigger).

## Pré-requisitos de deploy (verificar antes de publicar)

- O serviço backend no EasyPanel tem **Volume montado em `/app/uploads`** (sem ele, vídeos e
  documentos somem a cada redeploy). Conferir espaço livre no VPS.
- Proxy do EasyPanel não corta requisições de upload de parte (tamanho de parte escolhido
  bem abaixo de qualquer limite) nem respostas longas de streaming.
- `CORS`/headers: a resposta de streaming é consumida pelo `<video>` em outra origem
  (`VITE_API_URL`) — garantir que o Range funciona cross-origin.

## Changelog

Entrada v1.9.0 nos 3 lugares (`ChangelogModal.tsx`, `AdminSidebar.tsx`, `package.json`),
texto ao usuário final, ex.: "Nova página de Vídeos: o RH publica vídeos e acompanha quem
já assistiu."
