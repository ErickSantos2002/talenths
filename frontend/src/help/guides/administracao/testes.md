---
titulo: Testes
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/testes, /admin/testes/:testId/editar, /admin/testes/:testId/tentativas]
ordem: 50
---

## Para que serve

Em **Testes** você monta os testes que os colaboradores fazem pelo TalentHS: escreve as perguntas, define quem pode fazer o teste e acompanha as tentativas, com a nota e a avaliação de cada uma.

## Quando usar

- Para criar um teste novo ou preparar um rascunho.
- Para publicar um teste e liberá-lo aos colaboradores.
- Para ver os resultados e avaliar as tentativas que precisam de correção.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Desempenho**, clique em **Testes**.
2. Veja a lista de testes. Cada um mostra a situação (**Rascunho**, **Publicado** ou **Arquivado**), o modo de avaliação, o número de perguntas, o total de pontos e quantas tentativas já houve.

![Lista de testes com um rascunho e dois testes publicados](/capturas/admin-testes.webp)

**Para criar um teste:**

1. Clique em **Novo Teste**.
2. Preencha o **Título** e, se quiser, a **Descrição**.
3. Em **Modo de avaliação**, escolha:
   - **Automática — resultado imediato**: o sistema corrige e a pessoa vê o resultado ao enviar;
   - **Manual — RH avalia tudo**: você dá a nota de cada tentativa;
   - **Mista — automática + revisão de abertas**: o sistema corrige as perguntas fechadas e você pontua as de texto aberto.
4. Clique em **Criar e editar**. O editor do teste abre em seguida.

**Para montar o teste no editor:**

1. Em **Configurações**, preencha **Limite de tentativas**, **Tempo limite (min)** e **Nota mínima para aprovação**. Em branco, fica sem limite ou sem corte.
2. Ligue **Acesso público** para liberar o teste a todos os colaboradores. Desligado, só quem estiver em **Atribuições** pode fazer. Clique em **Salvar**.
3. Em **Atribuições**, escolha **Colaborador** ou **Departamento**, selecione na lista e clique em **Atribuir**.
4. Clique em **Adicionar pergunta**, escolha o **Tipo**, escreva o **Texto da pergunta**, defina os **Pontos** e clique em **Adicionar**.
5. Para as perguntas com opções, clique em **Ver opções**. Digite cada opção no campo e tecle Enter (ou clique em **+**). Depois, marque a caixa das opções corretas.
6. Use as setas à esquerda de cada pergunta para mudar a ordem.
7. Quando terminar, clique em **Publicar**.

![Editor de um teste em rascunho, com as configurações, as atribuições e as perguntas](/capturas/admin-teste-editar.webp)

**Para ver as tentativas:**

1. Na lista, clique no olho do teste.
2. No topo, veja **Total**, **Avaliados**, **Aguardando** e **Aprovados**.
3. Clique numa tentativa para ver as respostas. As opções corretas aparecem em verde.
4. Se o teste é manual ou misto, preencha a nota (**Nota final** ou os **Pontos** de cada pergunta aberta), escreva o **Feedback para o colaborador** se quiser e clique em **Salvar avaliação**.

![Tentativas de um teste, com o resumo e a lista de tentativas avaliadas](/capturas/admin-teste-tentativas.webp)

## O que acontece depois

- Depois de publicado, o teste aparece para os colaboradores em [Meus Testes](/ajuda/desempenho/meus-testes).
- Quando é enviada uma tentativa que precisa de correção (teste manual, ou misto com pergunta aberta), gestores e administradores recebem a notificação "Nova tentativa aguarda avaliação". Ela aparece na lista como **Aguardando avaliação**.
- Ao salvar a avaliação de uma tentativa, a pessoa recebe a notificação "Resultado disponível".

## Dúvidas comuns

**Não consigo editar um teste publicado.** Testes publicados ou arquivados não podem ser editados. Para mudar, use o botão de duplicar, na lista: a cópia é criada como rascunho, com "[Cópia]" no título.

**Não vejo a lixeira de um teste.** Só rascunhos podem ser excluídos.

**Apareceu "Adicione ao menos uma pergunta antes de publicar".** O teste precisa de pelo menos uma pergunta para ser publicado.

**As atribuições não fazem efeito.** Com **Acesso público** ligado, as atribuições são ignoradas. Desligue o acesso público e salve.
