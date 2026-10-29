---
titulo: Benefícios
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/beneficios]
ordem: 180
---

## Para que serve

Em **Benefícios** você mantém o catálogo de benefícios da empresa e diz quais benefícios cada colaborador recebe, com o valor de cada um. O vale-transporte tem uma calculadora própria, que usa os dias úteis do próximo mês.

## Quando usar

- Para cadastrar um benefício novo ou mudar o valor padrão de um benefício.
- Quando alguém entra na empresa ou passa a ter direito a um benefício.
- Para ver quantas pessoas usam cada benefício.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Gestão de RH**, clique em **Benefícios**.
2. Na aba **Visão Geral**, veja quantos benefícios há **No catálogo**, as **Atribuições ativas**, os **Colaboradores contemplados** e, em **Adesão por benefício**, quantas pessoas recebem cada um.

Quem foi desligado não aparece na aba **Colaboradores** nem entra nos números da **Visão Geral**. Os benefícios em aberto da pessoa são encerrados na data do desligamento. Para ver os benefícios de quem saiu, ligue **Mostrar desligados**, ao lado da busca.

**Para cadastrar um benefício no catálogo:**

1. Abra a aba **Catálogo** e clique em **+ Novo benefício**.
2. Preencha o **Nome** e escolha a **Categoria**.
3. Em **Tipo de valor**, escolha **Fixo (R$)**, **Variável (R$)**, **Percentual (%)** ou **Informativo** (sem valor, como um plano de saúde incluso). Nos três primeiros, informe o **Valor padrão**.
4. Se quiser, preencha **Fornecedor / operadora (opcional)** e **Descrição (opcional)**.
5. Deixe **Benefício ativo** ligado para que ele possa ser atribuído.
6. Clique em **Salvar**.

**Para atribuir benefícios a um colaborador:**

1. Abra a aba **Colaboradores**. Cada pessoa aparece com os benefícios que já recebe e o valor de cada um. Use a busca para achar a pessoa ou o departamento.
2. Clique em **+ Atribuir**, na linha da pessoa.
3. Em **Benefício**, escolha o benefício. Só aparecem os ativos que a pessoa ainda não tem.
4. Se quiser um valor diferente do catálogo só para essa pessoa, preencha **Valor**.
5. Clique em **Atribuir**.

![Aba Colaboradores de Benefícios com os benefícios de cada pessoa e o botão Atribuir](/capturas/admin-beneficios.webp)

Para mudar o valor de um benefício de uma pessoa, clique no lápis do benefício. Para tirar o benefício, clique no **×** e confirme.

**Para o vale-transporte:** ao atribuir um benefício com "transporte" no nome, aparece a calculadora. Informe o **Preço da passagem** e as **Passagens por dia**. O total é calculado com os dias úteis do próximo mês e refeito sozinho a cada mês. Se um mês precisa de dias a mais ou a menos, ajuste no catálogo, em **Ajuste de dias úteis**, no benefício da categoria **Transporte**. O ajuste vale para todos.

## O que acontece depois

- A pessoa vê os benefícios dela, com o valor, na tela [Meus Benefícios](/ajuda/rh/meus-beneficios).
- A **Visão Geral** e a **Adesão por benefício** passam a contar a atribuição.

## Dúvidas comuns

**Atribuí o vale-transporte e não apareceu a calculadora.** A calculadora só aparece quando o nome do benefício tem a palavra "transporte". Confira o **Nome** no **Catálogo**.

**Apaguei o valor de uma pessoa para voltar ao valor do catálogo, e nada mudou.** Apagar o **Valor** e salvar não tem efeito: o valor antigo continua. Para voltar ao valor do catálogo, tire o benefício da pessoa e atribua de novo, sem preencher o **Valor**.

**Apaguei o fornecedor ou a descrição de um benefício e eles continuam lá.** Deixar esses campos em branco não apaga o que estava escrito. Para mudar, escreva o texto novo.

**Não consigo remover um benefício do catálogo.** Um benefício que ainda está atribuído a alguém não pode ser removido: aparece "Benefício em uso — remova as atribuições antes de excluir". Tire o benefício de quem o recebe, ou desligue **Benefício ativo** para que ele não seja mais atribuído.

**Um benefício sumiu da lista do Atribuir.** Ele está inativo no **Catálogo**, ou a pessoa já o recebe.
