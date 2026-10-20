# Vídeos Internos Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Página de vídeos internos no TalentHS — RH sobe MP4, atribui a pessoas/departamentos/todos, e acompanha quem assistiu até o fim sem pular.

**Architecture:** Tabelas novas na migração `029` com atribuição materializada por pessoa e triggers em `profiles` (novo entrante, mudança de departamento, exclusão). Backend FastAPI com router `videos.py`; regras puras (antitrapaça, status, validação MP4) em `app/video_logic.py`, disco em `app/video_storage.py`. Upload em partes de 16 MB gravadas por offset em `/app/uploads/{company}/videos/`; reprodução por token curto na URL com `FileResponse` (Range). Frontend React: página admin, página do colaborador, player e card no dashboard.

**Tech Stack:** FastAPI 0.137 / Starlette 1.3.1 (FileResponse já responde Range), asyncpg (SQL cru), PyJWT, `mutagen` (novo, duração do MP4), pytest; React 18 + React Query + shadcn, Vitest.

**Spec:** `docs/superpowers/specs/2026-10-20-videos-internos-design.md`

## Global Constraints

- Somente MP4, até **2 GB** (`2 * 1024**3` bytes); outros formatos recusados com mensagem clara em pt-BR.
- Arquivos em `f"{settings.UPLOADS_DIR}/{company_id}/videos/"` — nunca caminho fixo; nome em disco = UUID, nunca o nome original.
- Migração nova `backend/migrations/029_internal_videos.sql`; nunca editar migrações existentes.
- Backend com **4 workers** uvicorn: nenhum estado de upload em memória — tudo em banco/disco.
- "Assistido" = `max_watched_s >= duration_seconds - 2`, validado no servidor; velocidade 1× e sem avanço até concluir.
- Prazo = `assigned_at + due_days` calculado na consulta; `due_days` nulo = sem prazo.
- "Todos"/departamento = todo perfil com `company_id` do vídeo, qualquer papel; `company_id` nulo não entra.
- Regras só acrescentam; `excluded = true` gruda até nova marcação individual.
- Colaborador excluído: linha sobrevive com `user_id` nulo + snapshots; fora de todas as contagens.
- UI em pt-BR, código em inglês; usar primitivos de `src/components/ui/`; Tailwind sem CSS custom.
- Notificações: `INSERT INTO public.notifications (user_id, type, title, message)` com `type = 'video'`.
- Versão **v1.9.0** nos 3 lugares do `CLAUDE.md`, data do dia da entrega.
- Trabalho na branch `feat/videos-internos` (criar a partir de `main` antes da Task 1).

## Review Focus

1. **Duas abas/dispositivos assistindo o mesmo vídeo** — relatos intercalados não podem fazer o máximo regredir nem saltar além do permitido; no pior caso o player volta ao máximo do servidor. (Task 1, `test_interleaved_reports_never_regress`)
2. **Parte de upload reenviada ou faltando** — reenvio da mesma parte é idempotente; `complete` com parte faltando é recusado mesmo que o arquivo tenha o tamanho final (escrita por offset cria arquivo esparso). (Task 3, `test_complete_rejects_missing_part_even_if_size_matches`)
3. **MP4 sem duração legível ou com menos de 3 s** — `complete` recusa com mensagem, não cria vídeo com duração 0 (que daria "concluído" instantâneo). (Task 1, `test_validate_duration_rejects_tiny_or_missing`)
4. **Edição de perfil que não muda o departamento** (nome, telefone) — não pode gerar atribuição nem notificação duplicada. (Task 2, `test_profile_update_same_department_no_duplicate_notification`)
5. **Token de reprodução reaproveitado** — token de vídeo arquivado, de versão de arquivo antiga, ou usado como Bearer de API, é recusado; JWT de login também não serve como token de stream. (Task 5, `test_stream_token_rejections`)

---

### Task 1: Regras puras — antitrapaça, status, validação MP4

**Files:**
- Create: `backend/app/video_logic.py`
- Modify: `backend/requirements.txt` (adicionar `mutagen>=1.47`)
- Test: `backend/tests/test_video_logic.py`

**Interfaces:**
- Produces:
  - `MAX_FILE_SIZE = 2 * 1024**3`, `PART_SIZE = 16 * 1024**2`, `COMPLETION_TOLERANCE_S = 2.0`, `MIN_DURATION_S = 3.0`
  - `evaluate_progress(max_watched_s: float, last_report_at: datetime | None, now: datetime, position_s: float, duration_s: float) -> ProgressDecision` — `ProgressDecision` é `@dataclass(frozen=True)` com `accepted: bool`, `new_max_s: float`, `completed: bool`.
  - `is_completed(max_watched_s: float, duration_s: float) -> bool`
  - `viewer_status(completed_at: datetime | None, max_watched_s: float, assigned_at: datetime, due_days: int | None, now: datetime) -> Literal["concluido","atrasado","em_andamento","pendente"]`
  - `due_at(assigned_at: datetime, due_days: int | None) -> datetime | None`
  - `is_mp4_header(head: bytes) -> bool` — `head` = primeiros 4096 bytes.
  - `read_mp4_duration(path: str) -> float | None` (via `mutagen.mp4.MP4(path).info.length`; qualquer exceção → `None`)
  - `validate_duration(duration: float | None) -> float` — lança `ValueError("Não foi possível ler a duração do vídeo. Envie um MP4 válido.")` se `None` ou `< MIN_DURATION_S`.

- [ ] **Step 1: Write the failing tests**

```python
T0 = datetime(2026, 10, 20, 12, 0, tzinfo=timezone.utc)

def test_first_report_allows_15s_slack():
    d = evaluate_progress(0, None, T0, 15, 600)
    assert d.accepted and d.new_max_s == 15
    assert not evaluate_progress(0, None, T0, 16, 600).accepted

def test_report_after_10s_allows_elapsed_times_1_1_plus_slack():
    # limite = max + min(elapsed,30)*1.1 + min(5, elapsed)
    d = evaluate_progress(100, T0, T0 + timedelta(seconds=10), 116, 600)
    assert d.accepted and d.new_max_s == 116
    assert not evaluate_progress(100, T0, T0 + timedelta(seconds=10), 116.5, 600).accepted

def test_elapsed_capped_at_30s():
    # parado 10 min: limite = 100 + 30*1.1 + 5 = 138
    assert evaluate_progress(100, T0, T0 + timedelta(minutes=10), 138, 600).accepted
    assert not evaluate_progress(100, T0, T0 + timedelta(minutes=10), 139, 600).accepted

def test_rewind_accepted_keeps_max():
    d = evaluate_progress(300, T0, T0 + timedelta(seconds=10), 20, 600)
    assert d.accepted and d.new_max_s == 300

def test_position_clamped_to_duration_and_completes():
    d = evaluate_progress(590, T0, T0 + timedelta(seconds=10), 605, 600)
    assert d.accepted and d.new_max_s == 600 and d.completed

def test_completion_tolerance_2s():
    assert is_completed(598, 600) and not is_completed(597.9, 600)

def test_interleaved_reports_never_regress():
    # aba A em 200, aba B em 50, alternando a cada 10 s
    m, t = 200.0, T0
    for pos in (50, 210, 60, 220):
        t += timedelta(seconds=10)
        d = evaluate_progress(m, t - timedelta(seconds=10), t, pos, 600)
        assert d.new_max_s >= m
        m = d.new_max_s if d.accepted else m
    assert m == 220

def test_viewer_status():
    a = T0
    assert viewer_status(T0, 0, a, 7, T0 + timedelta(days=30)) == "concluido"
    assert viewer_status(None, 0, a, 7, T0 + timedelta(days=8)) == "atrasado"
    assert viewer_status(None, 10, a, 7, T0 + timedelta(days=1)) == "em_andamento"
    assert viewer_status(None, 0, a, None, T0 + timedelta(days=400)) == "pendente"

def test_is_mp4_header():
    assert is_mp4_header(b"\x00\x00\x00\x20ftypisom" + b"\x00" * 24)
    assert is_mp4_header(b"\x00\x00\x00\x18ftypmp42" + b"\x00" * 16)
    assert not is_mp4_header(b"\x00\x00\x00\x14ftypqt  " + b"\x00" * 12)   # QuickTime
    assert not is_mp4_header(b"\x1a\x45\xdf\xa3" + b"\x00" * 28)          # WebM/MKV
    assert not is_mp4_header(b"")

def test_validate_duration_rejects_tiny_or_missing():
    with pytest.raises(ValueError): validate_duration(None)
    with pytest.raises(ValueError): validate_duration(2.9)
    assert validate_duration(3.0) == 3.0
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd backend && .venv/bin/pip install -r requirements.txt -r requirements-dev.txt && .venv/bin/pytest tests/test_video_logic.py -v`
Expected: FAIL — `ModuleNotFoundError: app.video_logic`

- [ ] **Step 3: Implement `backend/app/video_logic.py`**

Limite de avanço: `max + 15` no primeiro relato; depois `max + min(elapsed, 30) * 1.1 + min(5, elapsed)`. `position <= max` é aceito sem mudar o máximo. Marcas aceitas em `is_mp4_header`: bytes 4–8 == `b"ftyp"` e marca (bytes 8–12) em `{b"isom", b"iso2", b"iso4", b"iso5", b"iso6", b"mp41", b"mp42", b"avc1", b"M4V ", b"dash"}` (lista do `docshs/backend/app/services/video_formato.py` — conferir lá e alinhar).

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd backend && .venv/bin/pytest tests/test_video_logic.py -v`
Expected: PASS (todos)

- [ ] **Step 5: Commit**

```bash
git add backend/app/video_logic.py backend/tests/test_video_logic.py backend/requirements.txt
git commit -m "feat(videos): regras de progresso, status e validacao de MP4"
```

---

### Task 2: Migração 029 + banco de teste

**Files:**
- Create: `backend/migrations/029_internal_videos.sql`
- Create: `backend/scripts/test-db.sh`
- Create: `backend/tests/db/__init__.py`, `backend/tests/db/conftest.py`
- Test: `backend/tests/db/test_029_internal_videos.py`

**Interfaces:**
- Produces (SQL):
  - Tabelas `internal_videos`, `internal_video_rules`, `internal_video_viewers` exatamente como na seção "Modelo de dados" da spec (`due_days int CHECK (due_days > 0)`, `file_version int NOT NULL DEFAULT 1`, `archived_at timestamptz`; viewers com `id uuid PK`, `user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL`, `UNIQUE (video_id, user_id)`, `required bool NOT NULL DEFAULT false`, `excluded bool NOT NULL DEFAULT false`, `max_watched_s numeric NOT NULL DEFAULT 0`).
  - Tabela `internal_video_uploads` (decisão de plano — upload compartilhado entre workers): `id uuid PK`, `company_id`, `created_by`, `total_size bigint`, `parts_received int[] NOT NULL DEFAULT '{}'`, `file_path text`, `completed_at timestamptz`, `consumed_at timestamptz`, `created_at`.
  - `public.internal_video_assign(p_video_id uuid, p_user_ids uuid[]) RETURNS int` — insere/promove linhas `required = true` para os usuários dados, pulando `excluded`, insere notificação "Novo vídeo para assistir" para cada um efetivamente novo/promovido; retorna quantos.
  - `public.internal_video_apply_rules(p_video_id uuid, p_rule_ids uuid[] DEFAULT NULL) RETURNS int` — resolve regras (todas ou só as dadas) em usuários da empresa e chama `internal_video_assign`. Vídeo arquivado → 0.
  - Trigger `trg_profiles_internal_videos` AFTER INSERT OR UPDATE OF `department_id` ON `profiles` — só age se `NEW.company_id` não nulo e (INSERT ou `department_id IS DISTINCT FROM`); atribui vídeos ativos com regra `all` ou `department = NEW.department_id`.
  - Trigger `trg_profiles_internal_videos_snapshot` BEFORE DELETE ON `profiles` — grava `user_name_snapshot`, `department_name_snapshot` nas linhas do usuário.
  - Atenção: `profiles` é apagado antes de `auth.users` (`collaborators.py:190-191`), então o snapshot no BEFORE DELETE de `profiles` vem antes do `SET NULL`.
- Produces (Python, `tests/db/conftest.py`): fixture `db` (conexão asyncpg a `TEST_DATABASE_URL` dentro de transação com rollback; `pytest.skip` se a variável não existir) e helpers `make_company(db) -> str`, `make_department(db, company_id, name) -> str`, `make_user(db, company_id, department_id=None, name="Fulano", role="user") -> str` (cria `auth.users` + `profiles` + `user_roles`).

- [ ] **Step 1: Write `backend/scripts/test-db.sh`**

Cria (ou recria) o banco `talenths_test` no container `pg-teste` (`~/projetos/postgres-teste`, usuário `erick`, porta 5432) e aplica `backend/migrations/0*.sql` em ordem com `psql -v ON_ERROR_STOP=1`. Imprime a `TEST_DATABASE_URL` a exportar.

- [ ] **Step 2: Rodar o script com as migrações 001–028**

Run: `bash backend/scripts/test-db.sh`
Expected: todas aplicam sem erro. Se alguma migração antiga falhar num banco limpo, parar e reportar (não editar a antiga).

- [ ] **Step 3: Write the failing tests** (`asyncio` via `pytest-asyncio` — adicionar `pytest-asyncio>=0.24` em `requirements-dev.txt`, `asyncio_mode = auto` em `backend/pytest.ini`)

```python
async def test_new_hire_in_department_gets_video_and_notification(db): ...
    # vídeo com regra department=D; make_user(dept=D) → viewer required, 1 notificação type='video'
async def test_rule_all_includes_managers(db): ...
    # regra all; make_user(role="manager") → viewer required
async def test_null_company_profile_not_assigned(db): ...
async def test_department_change_keeps_old_and_adds_new(db): ...
    # vídeo A regra dept D1, vídeo B regra dept D2; user em D1 → muda p/ D2 → tem A e B required
async def test_profile_update_same_department_no_duplicate_notification(db): ...
    # UPDATE profiles SET name='x' e SET department_id = mesmo → 1 notificação no total
async def test_excluded_viewer_not_reassigned(db): ...
    # excluded=true; muda de dept e volta; apply_rules → continua excluded, required=false
async def test_archived_video_not_assigned_then_backfilled(db): ...
    # archived_at set; novo usuário → nada; archived_at=NULL + apply_rules → atribuído + notificado
async def test_voluntary_row_promoted_to_required(db): ...
    # linha required=false com progresso 50 → assign → required=true, max_watched_s=50
async def test_deleted_user_row_survives_with_snapshot(db): ...
    # DELETE profiles + auth.users → linha com user_id NULL, user_name_snapshot='Fulano', department_name_snapshot='RH'
```

- [ ] **Step 4: Run tests to verify they fail**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests/db -v`
Expected: FAIL — relação `internal_videos` não existe

- [ ] **Step 5: Write `029_internal_videos.sql`** e rodar `bash backend/scripts/test-db.sh` de novo

- [ ] **Step 6: Run tests to verify they pass**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests/db -v`
Expected: PASS (9)

- [ ] **Step 7: Commit**

```bash
git add backend/migrations/029_internal_videos.sql backend/scripts/test-db.sh backend/tests/db backend/pytest.ini backend/requirements-dev.txt
git commit -m "feat(videos): migracao 029 com atribuicao automatica por trigger"
```

---

### Task 3: Armazenamento e upload em partes

**Files:**
- Create: `backend/app/video_storage.py`
- Create: `backend/app/routers/videos.py` (só os endpoints de upload nesta task)
- Modify: `backend/app/main.py` (import + `include_router` de `videos_router`, junto aos demais)
- Modify: `backend/tests/db/conftest.py` (fixture `client_as`)
- Test: `backend/tests/test_video_storage.py`, `backend/tests/db/test_videos_upload_api.py`

**Interfaces:**
- Consumes: `MAX_FILE_SIZE`, `PART_SIZE`, `is_mp4_header`, `read_mp4_duration`, `validate_duration` (Task 1); tabela `internal_video_uploads` (Task 2).
- Produces:
  - `video_dir(company_id: str) -> str`, `tmp_path(company_id: str, upload_id: str) -> str`
  - `expected_parts(total_size: int) -> int`
  - `write_part(path: str, part_number: int, data: bytes, total_size: int) -> None` — `os.pwrite` no offset `part_number * PART_SIZE`; valida tamanho da parte (`PART_SIZE`, exceto a última = resto); `ValueError` se fora.
  - `finalize_file(tmp: str, company_id: str) -> tuple[str, int, float]` — valida tamanho, header MP4 e duração; move para `video_dir/{uuid}.mp4`; retorna `(final_path, size, duration)`. `ValueError` com mensagem pt-BR.
  - `ensure_free_space(company_id: str, needed: int) -> None` — `shutil.disk_usage`; exige `needed + 1 GB` livres.
  - `cleanup_stale_uploads(conn) -> None` — apaga temporários e linhas não concluídas com mais de 24 h; chamada no início de `POST /videos/uploads`.
  - Endpoints (RH): `POST /videos/uploads {total_size}` → `{upload_id, part_size, parts}`; `PUT /videos/uploads/{upload_id}/parts/{n}` (corpo binário cru, `Request.body()`); `POST /videos/uploads/{upload_id}/complete` → `{upload_id, duration_seconds, file_size}`; `DELETE /videos/uploads/{upload_id}`.
  - Fixture `client_as(user_id) -> httpx.AsyncClient` com `ASGITransport(app)` e `dependency_overrides` de `get_db`, `get_db_public`, `get_current_user_id` apontando para a conexão de teste; `settings.UPLOADS_DIR` → `tmp_path` via `monkeypatch`.

- [ ] **Step 1: Write the failing tests**

```python
# test_video_storage.py (puro, tmp_path)
def test_expected_parts(): assert expected_parts(PART_SIZE * 2 + 1) == 3
def test_write_part_rejects_wrong_size(tmp_path): ...  # parte do meio com PART_SIZE-1 → ValueError
def test_write_part_same_part_twice_is_idempotent(tmp_path): ...
def test_finalize_rejects_non_mp4(tmp_path): ...       # bytes de WebM → ValueError com "MP4"

# test_videos_upload_api.py (banco)
async def test_upload_requires_manager(db, client_as): ...          # role user → 403
async def test_upload_rejects_over_2gb(db, client_as): ...          # total_size = MAX_FILE_SIZE + 1 → 400
async def test_full_upload_flow(db, client_as, sample_mp4): ...     # start → parts → complete → duração > 0
async def test_complete_rejects_missing_part_even_if_size_matches(db, client_as, sample_mp4): ...
    # envia só a última parte (pwrite deixa o arquivo com tamanho final) → complete 400
async def test_cancel_deletes_tmp(db, client_as): ...
```

`sample_mp4`: fixture que gera um MP4 válido de ~5 s. Se houver `ffmpeg` na máquina, gerar com `ffmpeg -f lavfi -i testsrc=duration=5:size=160x120 -pix_fmt yuv420p`; senão, commitar um arquivo pequeno em `backend/tests/fixtures/sample-5s.mp4` (< 100 KB). Para testar multi-partes sem 32 MB, `monkeypatch` de `video_storage.PART_SIZE` para 64 KB.

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests/test_video_storage.py tests/db/test_videos_upload_api.py -v`
Expected: FAIL — `ModuleNotFoundError: app.video_storage`

- [ ] **Step 3: Implement `video_storage.py` e os endpoints de upload**

`parts_received` atualizado com `array_append` só se a parte ainda não está no array; `complete` confere `cardinality(parts_received) == expected_parts(total_size)` antes de `finalize_file`.

- [ ] **Step 4: Run tests to verify they pass**

Run: mesmo comando do Step 2
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add backend/app/video_storage.py backend/app/routers/videos.py backend/app/main.py backend/tests
git commit -m "feat(videos): upload em partes com validacao de MP4"
```

---

### Task 4: Endpoints do RH — criar, listar, detalhar, editar, trocar, arquivar, excluir

**Files:**
- Modify: `backend/app/routers/videos.py`
- Test: `backend/tests/db/test_videos_admin_api.py`

**Interfaces:**
- Consumes: `internal_video_apply_rules`, `internal_video_assign` (Task 2); `video_storage` (Task 3); `viewer_status`, `due_at` (Task 1).
- Produces:
  - Corpo de regras (pydantic): `RulesIn { all: bool, department_ids: list[str], user_ids: list[str] }`.
  - `POST /videos {upload_id, title, description?, due_days?, rules: RulesIn}` → vídeo. Consome o upload (`consumed_at`), grava regras, `apply_rules`.
  - `GET /videos/admin` → lista: `{id, title, duration_seconds, due_days, archived_at, required_count, completed_count, overdue_count, created_at}` (contagens só de `required AND NOT excluded AND user_id IS NOT NULL`).
  - `GET /videos/{id}/admin` → `{video, rules: RulesIn, required: [ViewerRow], voluntary: [ViewerRow], former: [ViewerRow]}`; `ViewerRow {user_id, name, department, status, progress_pct, completed_at, assigned_at, due_at}`.
  - `PATCH /videos/{id} {title?, description?, due_days?, rules?}` — se `rules`: grava o novo conjunto; aplica **só as regras novas** (`apply_rules(id, new_rule_ids)`); `user_id` adicionado individualmente limpa `excluded` antes do assign.
  - `POST /videos/{id}/viewers/{user_id}/remove` — apaga regra `user` dele se houver; `excluded = true, required = false`.
  - `POST /videos/{id}/replace-file {upload_id, mode: "keep_completed" | "reset_all"}` — conforme spec "Troca de arquivo"; `file_version += 1`; apaga o arquivo antigo; notifica ("Vídeo atualizado: assista novamente") quem voltou a pendente; `assigned_at` não muda.
  - `POST /videos/{id}/archive`, `POST /videos/{id}/unarchive` (reativar chama `apply_rules(id)`).
  - `DELETE /videos/{id}` — apaga arquivo e linhas.
  - Todos com `require_manager` e checagem de `company_id`.

- [ ] **Step 1: Write the failing tests**

```python
async def test_create_assigns_by_rules_and_notifies(...): ...   # dept D (2 pessoas) + user X → 3 required, 3 notificações
async def test_list_counts_exclude_former_and_excluded(...): ...
async def test_patch_new_rule_only_adds(...): ...                # remover dept não tira; adicionar dept novo atribui
async def test_remove_department_viewer_sticks(...): ...         # remove → PATCH com mesmas regras → continua fora
async def test_readding_user_individually_clears_excluded(...): ...
async def test_replace_keep_completed(...): ...                  # concluído fica; em andamento volta a 0; version=2
async def test_replace_reset_all(...): ...                       # todos completed_at NULL, max 0, notificados
async def test_unarchive_backfills_new_hires(...): ...
async def test_other_company_video_404(...): ...
async def test_delete_removes_file(...): ...
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests/db/test_videos_admin_api.py -v`
Expected: FAIL (404 nas rotas)

- [ ] **Step 3: Implement the endpoints**

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests -v`
Expected: PASS (suíte inteira)

- [ ] **Step 5: Commit**

```bash
git add backend/app/routers/videos.py backend/tests/db/test_videos_admin_api.py
git commit -m "feat(videos): gestao de videos pelo RH"
```

---

### Task 5: Endpoints do colaborador — meus vídeos, reprodução, progresso

**Files:**
- Modify: `backend/app/routers/videos.py`
- Test: `backend/tests/db/test_videos_viewer_api.py`

**Interfaces:**
- Consumes: `evaluate_progress`, `viewer_status`, `due_at` (Task 1).
- Produces:
  - `GET /videos/mine` → `{required: [MyVideo], library: [MyVideo]}`; `MyVideo {id, title, description, duration_seconds, status, progress_pct, due_at, completed_at}`. Só vídeos ativos; `required` = `required AND NOT excluded`; ordem: atrasado, pendente/em andamento (por `due_at`), concluído.
  - `GET /videos/{id}` → `MyVideo` + `max_watched_s`.
  - `POST /videos/{id}/stream-token` → `{url}` com `url = f"/videos/stream/{token}"`; JWT `{"typ": "video_stream", "vid", "uid", "ver", "exp": now+10min}` — **sem `sub`**, para não servir como login.
  - `GET /videos/stream/{token}` (`get_db_public`) — decodifica, exige `typ == "video_stream"`, vídeo ativo, `file_version == ver`, usuário ainda na empresa; `FileResponse(path, media_type="video/mp4", headers={"Cache-Control": "no-store"})`. Erro → 404/410 sem detalhe do motivo.
  - `POST /videos/{id}/progress {position_s: float}` → `{max_watched_s, completed}` ou 409 `{detail, max_watched_s}`. Cria linha `required = false` se não existir (voluntário). `SELECT ... FOR UPDATE` na linha antes de avaliar (duas abas).
- Ajustar `CORSMiddleware` em `main.py` se preciso para `expose_headers=["Content-Range", "Accept-Ranges", "Content-Length"]`.

- [ ] **Step 1: Write the failing tests**

```python
async def test_mine_splits_required_and_library(...): ...
async def test_archived_hidden_from_mine(...): ...
async def test_stream_supports_range(...): ...        # Range: bytes=0-99 → 206, Content-Range presente
async def test_stream_token_rejections(...): ...
    # vídeo arquivado → 404; token com ver antigo após replace → 404;
    # JWT de login (com sub) em /videos/stream → 404; token de stream como Bearer em /auth/me → 401
async def test_progress_skip_returns_409_with_server_max(...): ...
async def test_progress_completes_and_sets_completed_at(...): ...
async def test_progress_voluntary_creates_non_required_row(...): ...
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests/db/test_videos_viewer_api.py -v`
Expected: FAIL

- [ ] **Step 3: Implement the endpoints**

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd backend && TEST_DATABASE_URL=... .venv/bin/pytest tests -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add backend/app/routers/videos.py backend/app/main.py backend/tests/db/test_videos_viewer_api.py
git commit -m "feat(videos): reproducao com token curto e progresso antitrapaca"
```

---

### Task 6: Cliente da API e lógica do player no frontend

**Files:**
- Modify: `frontend/src/lib/api.ts` (namespace `videos` após `documents`, tipos exportados)
- Create: `frontend/src/lib/videoUpload.ts`, `frontend/src/lib/videoPlayback.ts`
- Test: `frontend/src/lib/videoUpload.test.ts`, `frontend/src/lib/videoPlayback.test.ts`

**Interfaces:**
- Consumes: endpoints das Tasks 3–5.
- Produces:
  - Tipos `VideoRules`, `AdminVideo`, `AdminVideoDetail`, `ViewerRow`, `MyVideo`, `ViewerStatus`.
  - `videos.{start, cancel, create, listAdmin, getAdmin, update, removeViewer, replaceFile, archive, unarchive, remove, listMine, get, streamUrl, reportProgress}`; `streamUrl(id)` devolve URL absoluta (`BASE_URL + url`). `reportProgress` lança `ProgressRejected { maxWatched }` no 409.
  - `uploadVideoFile(file: File, opts: { onProgress(pct: number), signal: AbortSignal }) -> Promise<{ upload_id, duration_seconds }>` em `videoUpload.ts` — recusa no cliente arquivo ≠ `video/mp4` ou > 2 GB com a mesma mensagem do servidor; 3 partes em paralelo, 3 tentativas por parte; abort → `DELETE` do upload.
  - `partRanges(size: number, partSize: number): Array<[start, end]>`
  - `clampSeek(target: number, maxWatched: number, completed: boolean): number` e `nextMaxWatched(prev: number, current: number): number` em `videoPlayback.ts`.

- [ ] **Step 1: Write the failing tests**

```ts
test("partRanges divide e a última parte leva o resto", () => {
  expect(partRanges(10, 4)).toEqual([[0, 4], [4, 8], [8, 10]]);
});
test("clampSeek puxa de volta avanço além do assistido", () => {
  expect(clampSeek(100, 40, false)).toBe(40);
  expect(clampSeek(20, 40, false)).toBe(20);
  expect(clampSeek(100, 40, true)).toBe(100);
});
test("uploadVideoFile recusa não-MP4 e > 2 GB sem chamar a API", async () => { /* fetch mock não chamado */ });
test("uploadVideoFile tenta de novo parte que falhou", async () => { /* 1ª PUT 500, 2ª 200 */ });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd frontend && bun test src/lib/videoUpload.test.ts src/lib/videoPlayback.test.ts`
Expected: FAIL (módulos inexistentes)

- [ ] **Step 3: Implement** (`PUT` das partes via `XMLHttpRequest` para ter `upload.onprogress`, com header `Authorization` como em `documents.upload`)

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd frontend && bun test && bun lint`
Expected: PASS, lint sem erros novos

- [ ] **Step 5: Commit**

```bash
git add frontend/src/lib
git commit -m "feat(videos): cliente da API, upload em partes e regras do player"
```

---

### Task 7: Tela do RH — `/admin/videos`

**Files:**
- Create: `frontend/src/pages/AdminVideosPage.tsx`
- Create: `frontend/src/components/videos/VideoFormDialog.tsx` (novo vídeo / editar: arquivo + barra de progresso + cancelar, título, descrição, prazo em dias, quem assiste)
- Create: `frontend/src/components/videos/AudiencePicker.tsx` (todos / departamentos / pessoas com busca)
- Create: `frontend/src/components/videos/VideoDetailDialog.tsx` (abas Obrigatórios / Voluntários / Ex-colaboradores; filtro por status e departamento; tirar pessoa; trocar arquivo com escolha do modo; arquivar/reativar; excluir com confirmação; assistir)
- Create: `frontend/src/components/videos/VideoStatusBadge.tsx`
- Modify: `frontend/src/App.tsx` (rota `/admin/videos`, `requiredRoles={["master_admin","manager"]}`, ao lado de `/admin/documentos`)
- Modify: `frontend/src/components/AdminSidebar.tsx` (item "Vídeos", ícone `Video` do lucide, na seção "Comunicação", após "Documentos")

**Interfaces:**
- Consumes: `videos.*`, `uploadVideoFile`, tipos (Task 6); `GET /departments`, `GET /collaborators` (já existentes, chaves React Query `["departments"]`, `["collaborators"]`).
- Produces: `VideoStatusBadge({ status: ViewerStatus })` — rótulos "Concluído" / "Atrasado" / "Em andamento" / "Pendente"; usado também na Task 8.

Padrão de página: `AdminDocumentosPage.tsx` (AdminLayout, useQuery/useMutation + `invalidateQueries(["admin-videos"])`), tabela com `TablePagination` + `usePageSize("admin-videos")`. Atrasados destacados na lista (contagem em vermelho). Trocar arquivo abre `AlertDialog` com as duas opções da spec: "Manter quem já concluiu" / "Todos precisam assistir de novo".

- [ ] **Step 1: Implementar as telas e rotas**
- [ ] **Step 2: Verificar** — `cd frontend && bun lint && bun run build` sem erros; com backend local (`TEST_DATABASE_URL` como `DATABASE_URL`), subir um MP4, atribuir a um departamento, abrir o detalhe e ver as pessoas como "Pendente".
- [ ] **Step 3: Commit**

```bash
git add frontend/src
git commit -m "feat(videos): pagina de videos do RH"
```

---

### Task 8: Telas do colaborador — `/meus-videos`, player `/videos/:id`, card no dashboard

**Files:**
- Create: `frontend/src/pages/MeusVideosPage.tsx` (seções "Obrigatórios" e "Biblioteca")
- Create: `frontend/src/pages/VideoPlayerPage.tsx`
- Create: `frontend/src/components/videos/PendingVideosCard.tsx`
- Modify: `frontend/src/App.tsx` (rotas `/meus-videos` e `/videos/:id` com `ProtectedRoute`)
- Modify: `frontend/src/components/AdminSidebar.tsx` (item "Vídeos" em `personalSections`, após "Documentos")
- Modify: `frontend/src/pages/DashboardPage.tsx` (renderiza `PendingVideosCard` só se houver pendentes)

**Interfaces:**
- Consumes: `videos.listMine/get/streamUrl/reportProgress`, `clampSeek`, `nextMaxWatched`, `ProgressRejected`, `VideoStatusBadge`.

Player (referência `docshs/frontend/src/paginas/VideoDoTreinamento.tsx`): `<video controls controlsList="nodownload noplaybackrate" disablePictureInPicture>`; `onSeeking`/`onTimeUpdate` aplicam `clampSeek`; `onRateChange` força `playbackRate = 1` até concluir; relata a cada 10 s e em pause, `visibilitychange` (hidden), `pagehide` e unmount (`navigator.sendBeacon` não leva header — no `pagehide` usar `fetch(..., { keepalive: true })` com Authorization); `ProgressRejected` → `currentTime = maxWatched`; `onError` → pede novo `streamUrl` e retoma do `currentTime`. Ao concluir: mensagem "Vídeo concluído em DD/MM/AAAA HH:mm" e invalida `["my-videos"]`.

- [ ] **Step 1: Implementar telas, rotas, sidebar e card**
- [ ] **Step 2: Verificar** — `cd frontend && bun lint && bun test && bun run build`; no navegador com backend local: como colaborador, a notificação aparece no sino; arrastar a barra adiante volta ao ponto assistido; velocidade não muda; ao final aparece "concluído" e o RH vê "Concluído" com data/hora; card some do dashboard.
- [ ] **Step 3: Commit**

```bash
git add frontend/src
git commit -m "feat(videos): meus videos, player e card de pendencias"
```

---

### Task 9: Changelog v1.9.0, script de migração e checagem de deploy

**Files:**
- Modify: `frontend/src/components/ChangelogModal.tsx` (entrada `v1.9.0` no topo com `current: true`; remover `current` da `v1.8.5`)
- Modify: `frontend/src/components/AdminSidebar.tsx` (`TalentHS v1.9.0`)
- Modify: `frontend/package.json` (`"version": "1.9.0"`)
- Create: `backend/scripts/aplicar_029.py`

Changelog `entries`:
- `{ type: "novidade", text: "Nova página de Vídeos: o RH publica vídeos de integração e apresentação da empresa e escolhe quem precisa assistir." }`
- `{ type: "novidade", text: "Em Meus Vídeos você vê os vídeos que precisa assistir, com prazo, e todos os vídeos da empresa." }`
- `{ type: "novidade", text: "O RH acompanha quem já assistiu até o fim, quem está pendente e quem está atrasado." }`

Também nesta task: trocar o comentário da linha 1 de `029_internal_videos.sql` para "vídeos internos de integração e apresentação da empresa, com atribuição obrigatória" (a 029 ainda não foi aplicada em produção — só no banco de teste), e conferir que nenhum texto de UI fala em "treinamento"/"curso".

`aplicar_029.py`: usa `bancos.conectar("talenths", perfil="admin")` (ver `~/projetos/bancos/README.md`), aplica `029_internal_videos.sql` numa transação e confere que as 4 tabelas e os 2 triggers existem. **O Claude não roda** — o Erick roda no Konsole: `backend/.venv/bin/python backend/scripts/aplicar_029.py`.

- [ ] **Step 1: Changelog e versão nos 3 lugares** (mesma data)
- [ ] **Step 2: Escrever `aplicar_029.py`**
- [ ] **Step 3: Checagem de deploy (somente leitura)** — via MCP EasyPanel, confirmar que o serviço backend do TalentHS tem mount persistente em `/app/uploads` e ver espaço em disco do VPS. Se não houver Volume, **parar e avisar o Erick** antes de publicar.
- [ ] **Step 4: Verificar** — `cd frontend && bun lint && bun test && bun run build`; `cd backend && .venv/bin/pytest -v` (com `TEST_DATABASE_URL`).
- [ ] **Step 5: Commit**

```bash
git add frontend/src/components/ChangelogModal.tsx frontend/src/components/AdminSidebar.tsx frontend/package.json backend/scripts/aplicar_029.py
git commit -m "feat(videos): v1.9.0 — pagina de videos internos"
```
