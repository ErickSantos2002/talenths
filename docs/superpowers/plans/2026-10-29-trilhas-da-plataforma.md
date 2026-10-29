# Importação das trilhas da plataforma de cursos — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Universidade importa o CSV exportado da plataforma de cursos (trilhas por pessoa), guardando o progresso das trilhas em andamento e registrando as concluídas.

**Architecture:** Tabela nova `learning_track_progress` (migração 034) com upsert por pessoa+trilha; o `POST /learning/import-csv` detecta o formato pelo cabeçalho e delega a um parser puro (`app/learning_import.py`); duas rotas de leitura alimentam a tela do RH e a do colaborador.

**Tech Stack:** FastAPI + asyncpg + pytest, React + TanStack Query, Vitest.

**Spec:** descrição aprovada na conversa de 29/10/2026. Exemplo real: `~/Downloads/trilha-MARKETING.csv` (`;`, Latin-1/CP1252, CRLF; colunas `Id do Colaborador;Matrícula Interna;Nome do Colaborador;CPF;Cargo;E-mail;Celular;Grupo;Id da Trilha;Nome da Trilha;Cursos da Trilha;Data que Iniciou a Trilha;Data que Finalizou a Trilha;Progresso na Trilha em %;Aproveitamento na Trilha em %`).
- Detecção automática; o padrão antigo (`email,titulo,area,horas,data`) continua igual.
- Toda linha entra em progresso de trilha (pessoa, `Id da Trilha`, nome, grupo, cursos, início, fim, % progresso, % aproveitamento, data da importação). Reimportar atualiza, sem duplicar.
- Trilha com data de fim vira também um registro concluído (`employee_courses`: título = nome da trilha, área = grupo, 0 h, data = fim), uma vez só.
- RH: card **Trilhas em andamento** e, por pessoa, as trilhas em andamento com barra de %, início e "Atualizado em".
- Colaborador: **Minha Universidade** mostra as próprias trilhas em andamento.
- Resultado: linhas lidas, trilhas atualizadas, concluídas registradas, erros por linha. Pessoa pelo e-mail; se não achar, pelo CPF (só dígitos).

## Global Constraints

- Migração nova `backend/migrations/034_learning_track_progress.sql` + `backend/scripts/aplicar_034.py` (molde do 033).
- Decodificação: tenta UTF-8 (com BOM); se falhar, CP1252.
- Cada linha roda num savepoint (`async with conn.transaction()`): erro numa linha não derruba as outras.
- Em andamento = `finished_at IS NULL`.
- Desligado → erro da linha `"Linha N: colaborador '<email>' desligado"`; não encontrado → `"Linha N: colaborador '<email>' não encontrado"`.
- Versão **v1.16.0**.
- Testes num banco próprio: `TEST_DB_NAME=talenths_test_trilhas`.

## Review Focus

1. Arquivo em UTF-8 com BOM no formato da plataforma → lido igual ao Latin-1.
2. Progresso com vírgula decimal ("6,5") ou vazio → 6.5 / 0.
3. Reimportar a mesma trilha concluída → nenhum registro concluído a mais.
4. Pessoa sem e-mail no cadastro mas com CPF igual → encontrada pelo CPF.
5. Uma linha com data inválida no meio do arquivo → as outras linhas entram.

---

### Task 1: Parser, migração e importação

**Files:** Create `backend/app/learning_import.py`, `backend/tests/test_learning_import.py`, `backend/migrations/034_learning_track_progress.sql`, `backend/scripts/aplicar_034.py`, `backend/tests/db/test_learning_tracks_api.py`; Modify `backend/app/routers/learning.py`.

**Interfaces (Produces):**
- `learning_import.decode(content: bytes) -> str`
- `learning_import.is_platform(header: list[str]) -> bool`
- `learning_import.parse_platform(text: str) -> list[PlatformRow]` — `PlatformRow` (dataclass): `line, email, cpf_digits, name, group, external_track_id, track_name, courses: list[str], started_at: datetime|None, finished_at: datetime|None, progress_pct: float, score_pct: float|None, error: str|None`.
- Tabela `learning_track_progress(id, company_id, user_id, external_track_id, track_name, group_name, courses text[], started_at, finished_at, progress_pct numeric(5,2) CHECK 0..100, score_pct numeric(5,2), imported_at, imported_by → auth.users SET NULL, employee_course_id → employee_courses SET NULL, created_at, UNIQUE(company_id, user_id, external_track_id))`.
- `POST /learning/import-csv` → `{format: "plataforma"|"padrao", inserted, tracks_updated, tracks_completed, errors}` (`inserted` = registros concluídos criados, compatível com a tela atual).
- `GET /learning/team-tracks?include_inactive=` → itens `{id, user_id, user_name, department, deactivated_at, track_name, group_name, courses, started_at, finished_at, progress_pct, score_pct, imported_at}`, só em andamento.
- `GET /learning/my-tracks` → mesmos campos, só da pessoa, só em andamento.

- [ ] Testes puros (decode Latin-1/UTF-8-BOM, is_platform, parse com o exemplo real, vírgula decimal, data inválida vira `error`) → RED → GREEN.
- [ ] Testes de banco: importa em andamento (cria progresso, 0 concluídos); reimporta com % maior (atualiza, sem duplicar); reimporta concluída (1 registro em `employee_courses`, `employee_course_id` preenchido) e de novo (continua 1); CPF como fallback; desligado e não encontrado em `errors`; linha ruim não derruba as outras; formato antigo continua; `team-tracks` e `my-tracks` (só em andamento, desligado só com `include_inactive`). RED → GREEN.
- [ ] Suíte inteira verde; commit `feat(universidade): importa trilhas da plataforma de cursos`.

### Task 2: Telas, guia, captura, changelog

**Files:** `frontend/src/lib/api.ts`, `frontend/src/types/learning.ts` (`TrackProgress`), `frontend/src/pages/LearningAdminPage.tsx`, `frontend/src/pages/MyLearningPage.tsx`, guias `administracao/universidade.md` e `desenvolvimento/minha-universidade.md`, semente das capturas (uma trilha em andamento), capturas `admin-universidade` e `minha-universidade`, changelog v1.16.0.

- [ ] RH: texto da importação explica os dois formatos; resultado mostra trilhas atualizadas e concluídas; card **Trilhas em andamento**; na pessoa, lista de trilhas em andamento (nome, `Progress`, início, "Atualizado em").
- [ ] Colaborador: seção **Trilhas em andamento** em Minha Universidade.
- [ ] Guias, semente, capturas (abrir e olhar), changelog; `bun run test`, lint, build.
- [ ] Commit `feat(universidade): trilhas em andamento na tela, versão 1.16.0`.

### Task 3: Fechamento

- [ ] Revisão por revisor novo, correções RED→GREEN, merge na `main`, push, aviso de deploy (034 → backend → frontend).
