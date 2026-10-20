---
titulo: Tabela Salarial
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/tabela-salarial]
ordem: 200
---

## Para que serve

Na **Tabela Salarial** você registra pesquisas salariais de mercado, com cinco valores por cargo, e compara o salário de cada colaborador com a mediana do cargo dele.

## Quando usar

- Quando receber uma pesquisa salarial nova.
- Para cadastrar o salário, a família de cargo e a senioridade de um colaborador.
- Antes de discutir reajustes e promoções, para ver quem está abaixo ou acima do mercado.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Gestão de RH**, clique em **Tabela Salarial**.
2. No seletor do topo, escolha a referência de mercado. Abaixo dele aparecem o mercado, a região e o ano.

**Para criar uma referência:**

1. Clique em **Nova referência**.
2. Preencha **Nome**, **Mercado**, **Região** e **Ano de referência**.
3. Clique em **Criar**. A referência nova já fica escolhida.

**Para montar a lista de cargos:**

1. Abra a aba **Cargos**. Uma referência nova começa com uma lista pronta (Diretor, Gerente, Coordenador e Analista).
2. Para incluir um cargo, preencha **Família** e **Nível** e clique em **Adicionar**. Para tirar um cargo, clique no **×** dele.
3. Volte à aba **Tabela Salarial** e clique em **Salvar tabela**. As mudanças da aba **Cargos** só ficam gravadas quando você salva a tabela.

**Para preencher os valores:**

1. Na aba **Tabela Salarial**, preencha, em cada cargo, os cinco valores: **P90**, **P95**, **Mediana**, **P105** e **P110**. Eles precisam crescer da esquerda para a direita.
2. Preencha a linha inteira ou deixe a linha toda vazia. Linha pela metade fica marcada e impede o salvamento.
3. Clique em **Salvar tabela**.

![Tabela Salarial com a referência escolhida e os valores P90, P95, Mediana, P105 e P110 de cada cargo](/capturas/admin-tabela-salarial.webp)

**Para ver o posicionamento da equipe:**

1. Abra a aba **Posicionamento**. Cada colaborador aparece com o **Cargo**, o **Salário atual**, a **Mediana ref.** do cargo, o **% da mediana**, o **Desvio** em reais e a **Faixa**.
2. Para cadastrar ou mudar os dados de uma pessoa, clique no lápis da linha. Preencha **Salário atual**, **Família de cargo** e, se a família tiver níveis, **Senioridade**, e clique em **Salvar**.

![Aba Posicionamento com o salário, a mediana, o percentual da mediana, o desvio e a faixa de cada colaborador](/capturas/admin-tabela-salarial-posicionamento.webp)

Atenção: a **Faixa** não compara o salário com os valores P90 e P110 da tabela. Ela usa só o **% da mediana**: abaixo de 92,5% aparece **Abaixo do mín.**; de 92,5% a 97,5%, **Faixa 90**; de 97,5% a 102,5%, **Mediana**; de 102,5% a 107,5%, **Faixa 105**; e a partir de 107,5%, **Acima do máx.**. Uma pessoa pode aparecer como **Abaixo do mín.** ganhando mais que o P90, ou **Acima do máx.** ganhando menos que o P110. Antes de decidir um reajuste, compare o **Salário atual** com os valores do cargo na aba **Tabela Salarial**.

## O que acontece depois

- O posicionamento é refeito na hora, para a referência escolhida no topo.
- O salário, a família de cargo e a senioridade ficam no cadastro da pessoa e valem para todas as referências.

## Dúvidas comuns

**Uma pessoa aparece com "Sem dados" na Faixa.** Faltam o **Salário atual** ou o cargo dela, ou o cargo não está na tabela dessa referência com o mesmo nome de família e de nível. Um cargo sem **Nível**, como o Diretor da lista pronta, nunca casa com uma pessoa e sempre fica **Sem dados**. Cadastre os cargos sempre com o **Nível**.

**Escolhi "—" para apagar o salário ou o cargo de uma pessoa, e nada mudou.** Escolher "—" ou apagar o **Salário atual** não limpa o dado: o valor antigo continua. Também ao trocar para uma família sem níveis, a senioridade antiga continua. Para corrigir, escolha a família e a senioridade certas.

**Tirei um cargo e os valores dele sumiram.** Ao salvar a tabela, os cargos que não estão na lista, ou que estão com a linha vazia, saem da referência. Se foi engano, adicione o cargo de novo em **Cargos**, preencha a linha e salve.

**Troquei de referência e perdi o que tinha digitado.** Os valores só ficam gravados com **Salvar tabela**. Salve antes de trocar de referência.

**Excluir referência apaga o quê?** A referência e a tabela dela, depois de confirmar. O salário e o cargo das pessoas continuam no cadastro.
