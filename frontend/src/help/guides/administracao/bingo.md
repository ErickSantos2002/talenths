---
titulo: Bingo
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/bingo, /admin/bingo/:gameId/imprimir]
ordem: 160
---

## Para que serve

No **Bingo** você organiza os bingos da empresa: cria o jogo, gera uma cartela para cada participante, imprime as cartelas e conduz o sorteio na tela, com o aviso de quem está perto de ganhar e o desempate automático.

## Quando usar

- Para preparar um bingo numa confraternização, na Semana de Segurança ou em outro evento.
- Durante o evento, para sortear os números e anunciar os ganhadores.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Comunicação**, clique em **Bingo**.
2. Veja os jogos. Cada um mostra a situação (**Rascunho**, **Em andamento**, **Encerrado** ou **Cancelado**), o monte de números, quantos ganhadores, quantos participantes e quantos números já saíram.

![Tela Bingo com um jogo em andamento e os botões Abrir, Imprimir e Cancelar](/capturas/admin-bingo.webp)

**Para criar um jogo:**

1. Clique em **Novo jogo**.
2. Preencha o **Nome do jogo**.
3. Em **Monte de números**, escolha de **1 a 30** até **1 a 120**. Montes maiores espalham os números e reduzem os empates no fim.
4. Em **Ganhadores**, informe quantas pessoas vão ganhar. Não pode passar do número de participantes.
5. Em **Avisar quando**, escolha **Faltando 1** ou **Faltando 1 e 2**: é quando a pessoa aparece em **Quase lá** durante o sorteio.
6. Em **Participantes**, marque quem vai jogar.
7. Clique em **Criar jogo**. As cartelas são geradas, uma por pessoa, e o jogo abre na tela.

**Para imprimir as cartelas:**

1. No jogo, clique em **Imprimir**. As cartelas abrem numa aba nova, quatro por folha, com o nome da pessoa e o código da cartela.
2. Clique em **Baixar cartelas (PDF)** e imprima o arquivo.
3. Clique em **Fechar** para sair.

![Página de impressão do bingo com quatro cartelas na folha e o botão Baixar cartelas (PDF)](/capturas/admin-bingo-imprimir.webp)

**Para conduzir o sorteio:**

1. No jogo, clique em **Abrir**. Se o jogo ainda é **Rascunho**, clique em **Iniciar jogo**.
2. Clique em **Girar próximo** para sortear um número. O número aparece em destaque e é marcado no quadro de números.
3. Para sortear sozinho a cada 5 segundos, clique em **Auto**. Para parar, clique em **Parar auto**.
4. Acompanhe à direita **Quase lá**, com quem está perto de completar a cartela, e **Ganhadores**. Clique num nome para ver a cartela da pessoa.
5. Quando alguém completa a cartela, aparece **Parabéns!** com o nome e o lugar. Clique em **Continuar** e siga sorteando.
6. Se duas ou mais pessoas completam no mesmo número, abre o **Desempate**. Clique em **Rolar d20**: quem tira o maior valor fica com o lugar melhor. Depois, clique em **Continuar**.

![Jogo de bingo aberto com o último número sorteado, os botões Girar próximo e Auto, o quadro de números e os painéis Quase lá e Ganhadores](/capturas/admin-bingo-jogo.webp)

**Para tirar um participante:** no jogo aberto, clique em **Participantes**, no ícone ao lado do nome e em **Remover**. Só a cartela dessa pessoa sai; as outras continuam iguais e não precisam ser reimpressas. Quem já ganhou não pode ser removido.

## O que acontece depois

- Cada participante vê a própria cartela na tela [Bingo](/ajuda/comunicacao/bingo), com os números sorteados marcados.
- O jogo passa a **Encerrado** sozinho quando todos os ganhadores saem ou quando acabam os números.

## Dúvidas comuns

**O botão Criar jogo não habilita.** Preencha o nome, marque ao menos um participante e informe um número de ganhadores entre 1 e o número de participantes.

**Cliquei em Cancelar num jogo em andamento.** O **Cancelar** encerra o jogo na hora, sem confirmação, e o sorteio não pode ser retomado. Para jogar de novo, crie outro jogo.

**Não vejo a lixeira de um jogo.** Um jogo em andamento não pode ser excluído. Cancele o jogo antes. A exclusão pede confirmação e apaga o jogo, as cartelas e o histórico.

**O botão Girar próximo está desabilitado.** Há um desempate pendente. Resolva o **Desempate** com **Rolar d20** e siga sorteando.
