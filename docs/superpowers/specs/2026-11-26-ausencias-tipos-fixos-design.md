# Ausências: 3 tipos fixos e motivo obrigatório

**Por quê:** Ausências é só o pedido prévio de saída. Justificativa com atestado vai por
outro fluxo (anexo + banco de horas). Um "Atestado Médico" sem aprovação deixou o pedido
do Welton entrar aprovado sozinho (26/11/2026).

**Decidido com o Erick:**
- Tipos: Ida ao médico, Saída pessoal, Outro. Todos exigem aprovação.
- Tipos fixos: sai a aba Tipos e o CRUD de tipos.
- Motivo obrigatório, mínimo 20 caracteres (após trim), em pedido novo.
- Férias deixa de ser pedida pelo sistema.

**Abordagens:** manter `absence_types` travada pelo sistema (escolhida: calendário,
relatório e histórico dependem da tabela e da cor); trocar por coluna texto fixa
(descartada: mexe em tudo sem ganho); desativar tipos antigos com flag (descartada:
nenhum tem pedido, dá para apagar).

**Desenho:**
1. Migração 038: Atestado Médico → Ida ao médico; todos `requires_approval = true`;
   cria Saída pessoal; apaga Férias, Folga Compensatória, Licença Médica, Licença
   Maternidade/Paternidade (FK RESTRICT faz a migração falhar se houver pedido).
   Pedido já aprovado automaticamente continua marcado como tal.
2. Backend: remove POST/PUT/DELETE `/absences/types` e as linhas de auditoria;
   DEFAULT_TYPES com os 3; `POST /absences/request` → 400 com motivo < 20.
3. Frontend: sem aba Tipos; Motivo obrigatório com contador; sem aviso de aprovação
   automática no formulário.
4. Guias `ausencias.md` e `minhas-ausencias.md`, semente e capturas atualizadas.
5. Entra na v1.21.0 (ainda não publicada).
