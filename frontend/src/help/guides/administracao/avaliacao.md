---
titulo: Avaliação de Desempenho
modulo: administracao
papeis: [manager, master_admin]
telas: [/admin/avaliacao]
ordem: 30
tour: tela-admin-avaliacao
---

## Para que serve

Na **Avaliação de Desempenho** você conduz os ciclos de avaliação: cria o ciclo com as datas de cada etapa, acompanha quem já fez a autoavaliação e quem já recebeu a nota do gestor, e calcula as notas finais, que também posicionam as pessoas no Mapa 9Box.

Clique no **?** e em **Mostrar nesta tela** para um passeio rápido por esta tela.

## Quando usar

- Para abrir um novo ciclo de avaliação.
- Durante o ciclo, para acompanhar o andamento e cobrar quem ainda não avaliou.
- No fim das avaliações, para calcular as notas.

## Antes de começar: o gestor de cada pessoa

A nota de gestor de cada colaborador é dada por uma pessoa só: o **gestor responsável** dele. Defina-o em [Colaboradores](/ajuda/administracao/colaboradores), no campo **Gestor responsável** de cada pessoa. Quem está sem gestor aparece na tabela com a etiqueta **Sem gestor**, e um aviso no topo mostra quantas pessoas estão assim.

## Passo a passo

**Para criar um ciclo:**

1. No menu, no bloco **Empresa**, em **Desempenho**, clique em **Avaliação**.
2. Clique em **Novo Ciclo** e preencha o **Nome do ciclo**.
3. Em **Vincular ao ciclo de metas (opcional)**, escolha o ciclo de metas do período. É ele que define o eixo de metas no Mapa 9Box.
4. Preencha o início e o fim de cada etapa: **Avaliação**, **Calibragem**, **Feedback** e **PDI**. Cada etapa começa depois do fim da anterior. Só **Avaliação** é obrigatória.
5. Deixe ligado **Avançar as etapas pelas datas**: o ciclo muda de etapa sozinho em cada data, e a autoavaliação abre para os colaboradores no primeiro dia de **Avaliação**.
6. Clique em **Criar Ciclo**.

**Para acompanhar o ciclo:**

1. No topo, escolha o ciclo. A tela abre no ciclo que está na etapa **Avaliação**.
2. Abaixo de **Etapa atual** ficam as datas de cada etapa, com a etapa de hoje destacada.
3. Veja o resumo: **Colaboradores**, **Autoavaliação** e **Aval. Gestor** (quantas já foram enviadas) e **Notas calc.**.
4. Na tabela, a coluna **Gestor** mostra o gestor responsável. As colunas **Auto** e **Gestor** mostram um visto verde para avaliação enviada e um relógio para pendente. Ao lado ficam a **Nota Final** e o quadrante do **9Box**.

Quem foi desligado não aparece na tabela nem entra no resumo, e o **Calcular Notas** não calcula nota para essa pessoa. Para ver a avaliação de quem saiu, ligue **Mostrar desligados**, ao lado de **Calcular Notas**: a pessoa aparece com a etiqueta **Desligado(a)**.

![Avaliação de Desempenho com as datas das etapas, o resumo do ciclo e a tabela de colaboradores com o gestor, as notas e o quadrante 9Box](/capturas/admin-avaliacao.webp)

**Para avaliar alguém como gestor:** se você é o gestor responsável da pessoa, o botão **Avaliar** aparece na linha dela. Você também pode avaliar a sua equipe em [Minha Avaliação](/ajuda/desempenho/minha-avaliacao), na aba **Avaliar minha equipe**.

**Para calcular as notas:** clique em **Calcular Notas**. A tela avisa para quantos colaboradores as notas foram calculadas e quantos ficaram sem nota por ainda não terem a avaliação do gestor.

**Para mudar as datas ou o nome:** clique em **Editar ciclo**, ajuste e clique em **Salvar**.

**Para travar uma etapa:** em **Etapa atual**, escolha a etapa. O ciclo para de seguir as datas e fica nela até você mudar. Para voltar a seguir as datas, escolha **Pelas datas**.

## O que acontece depois

- Os colaboradores fazem a autoavaliação em [Minha Avaliação](/ajuda/desempenho/minha-avaliacao) enquanto o ciclo está na etapa **Avaliação**.
- Os gestores podem enviar ou corrigir a nota de gestor nas etapas **Avaliação** e **Calibragem**.
- A nota final é a média ponderada das duas avaliações: **gestor 90%** e **autoavaliação 10%**. Embaixo da nota final aparecem as duas notas usadas no cálculo.
- A nota final define a posição da pessoa no Mapa 9Box, junto com o progresso das metas do time dela.

## Dúvidas comuns

**Criei o ciclo e os colaboradores não conseguem fazer a autoavaliação.** Confira as datas de **Avaliação** abaixo de **Etapa atual**: a autoavaliação só abre do primeiro ao último dia dela. Se a etapa foi travada à mão em outra, escolha **Pelas datas** em **Etapa atual**.

**Uma pessoa está sem Nota Final.** As notas só aparecem depois de **Calcular Notas**, e só para quem já tem a avaliação do gestor. Sem a autoavaliação, a nota final é só a do gestor.

**O botão Avaliar não aparece na linha de alguém.** Ele só aparece para o gestor responsável da pessoa, e só nas etapas **Avaliação** e **Calibragem**. Para mudar o gestor, edite a pessoa em [Colaboradores](/ajuda/administracao/colaboradores).

**Avaliei alguém e quero corrigir.** Clique em **Avaliar** de novo, ajuste as notas e envie. A nova avaliação substitui a anterior. Depois, clique em **Calcular Notas** para atualizar a nota.

**Posso calcular as notas mais de uma vez?** Sim. Cada cálculo refaz as notas com as avaliações enviadas até aquele momento. Quem foi mudado de quadrante na calibragem continua no quadrante calibrado.
