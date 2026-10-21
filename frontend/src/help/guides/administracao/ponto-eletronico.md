---
titulo: Ponto Eletrônico
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/ponto]
ordem: 190
---

## Para que serve

No **Ponto Eletrônico** você acompanha as batidas de ponto de quem registra o ponto pelo TalentHS, corrige batidas e responde aos pedidos de registro manual e de ajuste de horário.

## Quando usar

- Para ver quem já começou a trabalhar hoje e quem não registrou ponto.
- Para conferir as horas de uma pessoa no mês, antes do fechamento.
- Quando houver pedidos na aba **Solicitações**.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Gestão de RH**, clique em **Ponto Eletrônico**.
2. Na aba **Hoje**, veja cada pessoa com o **Status** (**Trabalhando**, **Encerrado**, **Incompleto** ou **Sem registro**), as horas **Trabalhado** sobre as horas previstas e as **Batidas** do dia. Para ver outro dia, mude o **Dia**.

![Ponto Eletrônico na aba Hoje com três colaboradores trabalhando, cada um com a entrada do dia](/capturas/admin-ponto.webp)

**Para conferir e corrigir o ponto de uma pessoa:**

1. Abra a aba **Por período**.
2. Em **Colaborador**, escolha a pessoa e ajuste as datas em **De** e **Até**.
3. Veja os dias com as batidas, as horas trabalhadas e as previstas. Um dia passado com batida faltando aparece com **Incompleto — falta batida**.
4. Para incluir uma batida que faltou, clique em **Adicionar batida**, preencha **Data e hora**, o **Tipo** e, se quiser, a **Observação (opcional)**, e clique em **Salvar**. O **Tipo** escolhido não decide se a batida conta como entrada ou saída: veja em Dúvidas comuns.
5. Para corrigir uma batida, clique no lápis dela, altere e clique em **Salvar**. Para apagar, clique na lixeira e confirme em **Excluir**.

**Para responder às solicitações:**

1. Abra a aba **Solicitações**. O número ao lado do nome da aba mostra quantos pedidos esperam resposta.
2. Em **Registros manuais pendentes**, veja as batidas que a pessoa registrou depois, com o motivo. Clique em **Confirmar** para valer a batida ou em **Cancelar** para descartá-la.
3. Em **Ajustes de horário**, veja o horário atual riscado, o horário pedido e o motivo. Clique em **Aprovar** para trocar o horário ou em **Negar** para manter o atual.

![Aba Solicitações do Ponto Eletrônico com um pedido de ajuste de saída, o horário atual riscado, o horário pedido e os botões Aprovar e Negar](/capturas/admin-ponto-solicitacoes.webp)

## O que acontece depois

- A pessoa vê o resultado na tela **Meu Ponto**: a batida confirmada perde o **Aguardando RH**, e a batida com ajuste aprovado ganha o link **ajustado**, com o **Histórico de ajustes**.
- As batidas que você adiciona aparecem com a etiqueta **RH**.

## Dúvidas comuns

**Uma pessoa não aparece na lista.** Só aparece quem tem **Bater ponto pelo sistema** ligado no cadastro, em [Colaboradores](/ajuda/administracao/colaboradores). As horas previstas vêm da **Jornada diária (horas)** do mesmo cadastro.

**Escolhi Saída numa batida e ela aparece como Entrada.** O TalentHS alterna as batidas de cada dia pela ordem do horário: a primeira é entrada, a segunda é saída, a terceira é entrada, e assim por diante. As horas são somadas de cada entrada até a saída seguinte. Confira se o dia tem todas as batidas.

**As horas já contam um registro manual que eu ainda não confirmei?** Sim. Nas abas **Hoje** e **Por período**, o registro pendente já entra na soma das horas; em **Por período**, ele aparece com a etiqueta **Pendente**. Se cancelar o registro, ele sai da conta.

**A pessoa recebe notificação da minha resposta?** Não. A resposta aparece na tela **Meu Ponto** dela, mas o TalentHS não envia notificação.

**Confirmei, cancelei, aprovei ou neguei por engano.** Os botões de **Solicitações** agem na hora, sem confirmação. Corrija a batida na aba **Por período**, com o lápis, **Adicionar batida** ou a lixeira.
