# Registrar conclusão de vídeo pelo RH — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** O RH marca que uma pessoa já viu um vídeo antes (com a data), e pode desfazer a marcação.

**Architecture:** Duas colunas novas em `internal_video_viewers` (migração 033) distinguem a conclusão registrada pelo RH; duas rotas em `videos.py` fazem o upsert e o desfazer; o detalhe do vídeo ganha o formulário, o atalho por linha e a etiqueta.

**Tech Stack:** FastAPI + asyncpg + pytest (banco real), React + TanStack Query + shadcn/ui, Vitest.

**Spec:** descrição aprovada na conversa de 29/10/2026 (resumo abaixo — não há documento separado).
- Botão **Registrar conclusão** no detalhe do vídeo: **Colaborador** (ativos que ainda não concluíram) + **Data da conclusão** (≤ hoje). Atalho nas linhas **Pendente/Atrasado** dos Obrigatórios com a pessoa preenchida.
- Efeito: **Concluído** na data informada, etiqueta **Registrado pelo RH**, conta em "Concluídos", sai das pendências, não fica atrasado. Não obrigado aparece em **Voluntários**.
- **Desfazer registro** só em registros do RH; volta ao estado anterior.
- Quem já concluiu pelo sistema não pode ser registrado. Gestor e Administrador. Guarda quem marcou; auditoria mostra a ação.
- "Trocar arquivo" com zerar tudo zera também os registros do RH. Sem notificação ao registrar.

## Global Constraints

- Migração nova `backend/migrations/033_video_completion_by_hr.sql`; nunca editar as anteriores. Script `backend/scripts/aplicar_033.py` no molde do `aplicar_032.py`.
- Registrado pelo RH = `internal_video_viewers.completed_by IS NOT NULL`.
- A data vira `completed_at` às 12:00 de America/Sao_Paulo (não muda de dia em nenhum fuso do Brasil).
- Mensagens: já concluído → 409 `"Esta pessoa já concluiu este vídeo"`; desfazer algo que não é registro do RH → 409 `"Só dá para desfazer conclusões registradas pelo RH"`; data futura → 422; alvo desligado → 422 `"Colaborador desligado"` (`ensure_active_targets`); fora da empresa → 404 `"Colaborador não encontrado"`.
- Rótulos de auditoria: `"Conclusão de vídeo registrada"` e `"Registro de conclusão desfeito"`.
- UI pt-BR; versão **v1.15.0** nos 3 lugares do changelog.
- Testes de banco num banco próprio: `TEST_DB_NAME=talenths_test_videoconc bash backend/scripts/test-db.sh`, `TEST_DATABASE_URL=postgresql://erick:dev123@localhost:5432/talenths_test_videoconc`.

## Review Focus

1. Registrar quem já tem progresso parcial (assistiu metade) → fica concluído; desfazer devolve o progresso que tinha.
2. Registrar alguém removido do vídeo pelo RH (`excluded`) → aparece em Voluntários como concluído; desfazer some dele de novo.
3. Registrar em vídeo de outra empresa ou pessoa de outra empresa → 404.
4. Pessoa registrada abre o vídeo e assiste → continua concluída, sem erro no progresso.
5. "Trocar arquivo" só dos incompletos (`mode` diferente de `reset_all`) → registros do RH ficam.

---

### Task 1: Migração 033 e rotas de registrar/desfazer

**Files:**
- Create: `backend/migrations/033_video_completion_by_hr.sql`, `backend/scripts/aplicar_033.py`, `backend/tests/db/test_videos_completion_by_hr_api.py`
- Modify: `backend/app/routers/videos.py` (rotas, `_viewer_out`, consulta do detalhe, reset do replace-file), `backend/app/middleware/audit.py`, `backend/tests/test_audit_middleware.py`

**Interfaces:**
- Produces:
  - Colunas `completed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL`, `completed_registered_at timestamptz`, `CHECK (completed_by IS NULL OR completed_at IS NOT NULL)`.
  - `POST /videos/{video_id}/viewers/{target_user_id}/complete` body `{completed_on: date}` → 200 `{"ok": true}`.
  - `POST /videos/{video_id}/viewers/{target_user_id}/uncomplete` → 200 `{"ok": true}`.
  - Cada item de `required`/`voluntary` no `GET /videos/{id}/admin` ganha `registered_by_hr: bool`.

- [ ] **Step 1: Testes que falham** (`test_videos_completion_by_hr_api.py`, reaproveitando `_create`, `_rules`, `_viewer` de `test_videos_admin_api`):
  `test_register_required_pending` (fica `concluido`, `registered_by_hr` true, `completed_at` no dia informado, `GET /videos/admin` `completed_count` sobe 1);
  `test_register_not_required_goes_to_voluntary`;
  `test_register_keeps_partial_progress_on_undo` (max_watched_s preservado após desfazer);
  `test_register_excluded_then_undo_hides_again`;
  `test_cannot_register_already_completed` (409);
  `test_future_date_is_422`; `test_deactivated_target_is_422`; `test_other_company_target_is_404`; `test_user_role_is_403`;
  `test_undo_system_completion_is_409`; `test_undo_restores_pending`;
  `test_progress_after_registration_keeps_completed` (POST progress do colaborador → continua concluído);
  `test_replace_file_reset_all_clears_registration` e `test_replace_file_incomplete_only_keeps_registration`.
  E em `test_audit_middleware.py`: `test_video_completion_labels`.
- [ ] **Step 2: Rodar e ver falhar.**
- [ ] **Step 3: Migração 033** (+ `aplicar_033.py`: recusa se a coluna existe, confere colunas e o CHECK).
- [ ] **Step 4: Rotas.** `complete`: `_manager_company`, `_get_video(lock=True)`, alvo na empresa (404), `ensure_active_targets`, upsert `INSERT ... ON CONFLICT (video_id, user_id) DO UPDATE ... WHERE internal_video_viewers.completed_at IS NULL RETURNING id` (sem linha → 409). `uncomplete`: `UPDATE ... SET completed_at = NULL, completed_by = NULL, completed_registered_at = NULL WHERE video_id AND user_id AND completed_by IS NOT NULL RETURNING id` (sem linha → 409 ou 404 se a linha não existe). Reset do replace-file limpa `completed_by`/`completed_registered_at` junto com `completed_at`.
- [ ] **Step 5: Rodar o arquivo e a suíte inteira** — tudo PASS.
- [ ] **Step 6: Commit** `feat(videos): RH registra conclusão de vídeo`.

### Task 2: Tela, guia, captura e changelog

**Files:**
- Create: `frontend/src/components/videos/RegisterCompletionDialog.tsx`
- Modify: `frontend/src/lib/api.ts` (`videos.registerCompletion(id, userId, completedOn)`, `videos.undoCompletion(id, userId)`, `ViewerRow.registered_by_hr`), `frontend/src/components/videos/VideoDetailDialog.tsx`, `frontend/src/help/guides/administracao/videos.md`, `backend/scripts/seed_captures.py` (uma conclusão registrada pelo RH no vídeo da captura `admin-video-detalhe`), `frontend/public/capturas/admin-video-detalhe.webp`, changelog (3 lugares)

- [ ] **Step 1:** Formulário: `Combobox` com `collaborators.list()` menos quem já está concluído no vídeo; data `type="date"` com `max` = hoje (padrão hoje); botão **Registrar conclusão**. Invalida `admin-video` e `admin-videos`.
- [ ] **Step 2:** No detalhe: botão **Registrar conclusão** na barra de ações; ação **Registrar** nas linhas pendente/atrasado (abre o formulário com a pessoa); `Badge` **Registrado pelo RH** ao lado do status; ação **Desfazer** (com `AlertDialog`) nessas linhas.
- [ ] **Step 3:** Guia de Vídeos: seção **Para registrar quem já assistiu antes** e **Para desfazer um registro**; dúvida comum sobre a etiqueta.
- [ ] **Step 4:** Semente + captura `admin-video-detalhe`; **abrir e olhar**.
- [ ] **Step 5:** Changelog v1.15.0; `bun run test`, `lint` sem problemas novos, `build`.
- [ ] **Step 6:** Commit `feat(videos): tela para registrar conclusão pelo RH, versão 1.15.0`.

### Task 3: Fechamento

- [ ] Suítes completas; revisão do branch por revisor novo; correções RED→GREEN; merge na `main`, push, aviso de deploy (migração 033 → backend → frontend).
