---
titulo: Universidade Corporativa
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/universidade]
ordem: 80
---

## Para que serve

A **Universidade Corporativa** registra os cursos que os colaboradores concluíram e mostra as horas de estudo da equipe por pessoa e por área. Ela também guarda o catálogo de cursos da empresa.

## Quando usar

- Para registrar cursos concluídos pela equipe, de uma vez, com uma planilha.
- Para consultar as horas de estudo de cada pessoa ou de cada área.
- Para manter a lista de cursos da empresa.

## Passo a passo

1. No menu, no bloco **Empresa**, em **Desenvolvimento**, clique em **Universidade**.
2. Na aba **Progresso da Equipe**, veja o resumo: **Colaboradores**, **Total de horas**, **Cursos concluídos** e **Média por pessoa**. Logo abaixo, as horas de cada área.
3. Clique no nome de uma pessoa para ver os cursos dela, com a área, as horas e a data de conclusão. Para achar alguém, digite o nome ou o departamento no campo de filtro.

Quem foi desligado não aparece na lista nem entra no resumo. Para ver os cursos de quem saiu, ligue **Mostrar desligados**, ao lado do campo de filtro: a pessoa aparece com a etiqueta **Desligado(a)**.

![Universidade Corporativa com a importação por CSV, o resumo de horas da equipe e a lista de colaboradores](/capturas/admin-universidade.webp)

**Para registrar cursos com uma planilha:**

1. Monte um arquivo CSV, separado por vírgulas, com as colunas `email`, `titulo`, `area`, `horas` e `data`.
   - `email` é o e-mail da pessoa no TalentHS;
   - `data` é a data de conclusão no formato AAAA-MM-DD. Sem data, vale o dia da importação.
2. Em **Importar cursos via CSV**, clique em **Selecionar CSV** e escolha o arquivo.
3. Confira o resultado: quantos registros foram importados e, em vermelho, as linhas com problema.

**Para cuidar do catálogo:**

1. Abra a aba **Catálogo**. Os cursos aparecem agrupados por área.
2. Clique em **Adicionar curso**, preencha **Título**, **Área** e **Carga horária (h)** e, se quiser, a **Descrição**. Clique em **Salvar**.
3. Para alterar um curso, clique no lápis. Para tirá-lo do catálogo, clique na lixeira.

## O que acontece depois

- Os cursos importados entram no histórico de cada pessoa, em [Minha Universidade](/ajuda/desenvolvimento/minha-universidade), com a etiqueta **CSV**.
- O resumo e as horas por área da equipe são atualizados na hora.

## Dúvidas comuns

**Uma linha deu "colaborador não encontrado".** O e-mail da linha não corresponde a ninguém da empresa. Corrija o e-mail e importe só essa linha de novo.

**Uma linha deu "título ou área ausente".** As colunas `titulo` e `area` são obrigatórias em todas as linhas.

**Registrei um curso errado.** Abra a pessoa em **Progresso da Equipe** e clique na lixeira do curso. A remoção é imediata, sem confirmação.

**Cadastrar um curso no catálogo registra o curso para alguém?** Não. O catálogo é só a lista de cursos da empresa. Os cursos concluídos entram pela importação do CSV.
