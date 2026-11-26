# Ausências: colaborador edita o próprio pedido pendente

**Por quê:** quem cria um pedido errado hoje precisa cancelar e refazer.

**Decidido com o Erick:** só o dono, só enquanto Pendente; mesmos campos e regras da criação
(motivo ≥ 20); corrida com a decisão do RH → 409 "Solicitação já não está pendente";
RH vê "Editada em …" (coluna `updated_at`, migração 039); edição na auditoria.
**Decisão minha:** o Guardi não ganha a edição (allowlist inalterada). Versão 1.22.0.

**Abordagem:** `PUT /absences/{id}` reaproveitando a validação da criação; no frontend,
o mesmo diálogo de "Solicitar ausência" preenchido. Alternativa descartada: editar só o
motivo/datas inline na lista — dois formulários com regras duplicadas.
