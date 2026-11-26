# Ausências: tipos fixos e motivo obrigatório — plano

**Spec:** docs/superpowers/specs/2026-11-26-ausencias-tipos-fixos-design.md
**Execução:** nativa, nesta sessão (mudança pequena, tarefas encadeadas).

## Review Focus
- Motivo só com espaços ("                         ") → 400.
- Motivo com exatamente 20 caracteres → aceito; 19 → 400.
- Empresa nova (sem tipos) → GET /absences/types cria os 3, todos com aprovação.
- Pedido via Guardi sem motivo → 400 (mesma rota).
- Migração em banco com pedido em tipo a apagar → falha (FK RESTRICT), não perde dado.

### Task 1: Backend + migração 038
- [ ] Teste `tests/db/test_absences_fixed_types_api.py`: tipos padrão = {Ida ao médico, Saída pessoal, Outro} com requires_approval; POST/PUT/DELETE /absences/types → 404/405; motivo None/espaços/19 chars → 400 "O motivo precisa ter pelo menos 20 caracteres"; 20 chars → 201 pending.
- [ ] Teste de migração: aplica 038 sobre os 6 tipos antigos → sobra o esperado, pedido em Atestado Médico vira Ida ao médico com auto_approved preservado.
- [ ] Implementar (absences.py, audit.py, 038), ajustar test_absences_review_info_api e test_agente_token.
- [ ] Suite backend verde.

### Task 2: Frontend, guias, semente, capturas, changelog
- [ ] AbsencesAdminPage sem aba Tipos; api.ts sem createType/updateType/deleteType.
- [ ] MyAbsencesPage: Motivo obrigatório, contador x/20, botão desabilitado < 20, sem aviso de aprovação automática.
- [ ] Guias ausencias.md e minhas-ausencias.md; semente com os 3 tipos; capturas admin-ausencias e minhas-ausencias refeitas e conferidas.
- [ ] Entrada no changelog v1.21.0; bun run test e lint verdes; commit.
