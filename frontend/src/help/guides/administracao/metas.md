---
titulo: Metas
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/metas]
ordem: 20
---

## Para que serve

Em **Metas** você cadastra as metas de cada time num ciclo (por exemplo, um ano), distribui o valor planejado pelos meses e lança o realizado mês a mês. A tela mostra quanto cada meta e cada time já atingiram.

## Quando usar

- No início do ciclo, para criar o ciclo e as metas de cada time.
- Todo mês, para lançar o valor realizado de cada meta.
- Para acompanhar o andamento e exportar os números.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Desempenho**, clique em **Metas**.
2. No topo, escolha o ciclo e o mês. A tela abre no ciclo ativo e no mês atual.
3. Clique na aba de um time. No quadro do time, os três círculos mostram o atingimento em **Mês**, **Até o mês** e **Do ano**.
4. Na tabela, veja cada meta com o **Responsável**, o tipo de **Cálculo**, o **Peso** e os mesmos três indicadores.

![Metas do ciclo ativo, com as abas dos times e a tabela de metas do time Comercial](/capturas/admin-metas.webp)

**Para criar um ciclo:** clique em **Novo Ciclo**, preencha **Nome do ciclo**, **Data inicial**, **Data final** e **Status**, e clique em **Criar Ciclo**. Os campos **Curva mínima** e **Teto de progresso** já vêm preenchidos com 0.80 e 1.20.

**Para criar uma meta:**

1. Clique em **Nova Meta**.
2. Em **1. Configuração**, preencha **Título da meta** e **Time**. **Responsável (opcional)** é a pessoa que responde pela meta.
3. Escolha o **Objetivo** (**Aumentar valor** ou **Diminuir valor**), a **Expressão de cálculo** (**Soma**, **Subtração**, **Média** ou **Repetir**) e o **Tipo de resultado** (**R$**, **%** ou **Valor**).
4. Informe o **Peso no departamento (%)** e o **Valor alvo total (anual)**.
5. Se a meta vira nota, marque **Usar curva de nota** e preencha **% para Nota 80**, **% para Nota 100** e **% para Nota 120**.
6. Clique em **Próximo: Mensalização →**.
7. Em **2. Mensalização**, escolha **Dividir igualmente entre os meses**, **Repetir o valor alvo em todos os meses** ou **Personalizado** (você digita o valor de cada mês).
8. Clique em **Criar Meta**.

**Para lançar o realizado:**

1. Clique na linha da meta. Abre o detalhe, na aba **Progresso Mensal**.
2. Na linha do mês, clique no lápis, digite o **Valor realizado** e, se quiser, um **Comentário (opcional)**. Clique em **Salvar**.
3. Quando o número do mês estiver certo, clique no cadeado para fechar o mês.

Para editar, mover ou excluir uma meta, use o menu de três pontos no fim da linha.

## O que acontece depois

- Os círculos da meta e do time são recalculados com o novo realizado.
- Cada lançamento fica registrado na aba **Histórico** da meta, com quem lançou, quando e o valor anterior. Na mesma aba ficam os comentários da meta, que podem ter anexos.
- Um mês fechado aparece com cadeado e não pode ser editado até ser reaberto (cadeado aberto).
- O progresso das metas do time é usado no eixo de metas do Mapa 9Box, quando o ciclo de avaliação está vinculado a este ciclo de metas.

## Dúvidas comuns

**O que é o peso ponderado?** Na coluna **Peso**, em cima fica o peso que você digitou. Embaixo, o peso ponderado, recalculado para que as metas do time somem 100%.

**Apareceu "o total de pesos deste departamento não soma 100%".** A meta foi criada mesmo assim. Ajuste os pesos das metas do time para fechar 100%.

**Não consigo excluir um ciclo.** Só é possível excluir um ciclo sem metas. Exclua as metas dele antes.

**Como exporto os números?** Clique no botão de download, ao lado do mês. Ele baixa um arquivo CSV com as metas de todos os times no mês escolhido.
