# TalentHS — Sistema de Gestão de Pessoas da H&S

> Documento de especificação técnica e funcional do sistema TalentHS, plataforma integrada de Recursos Humanos da H&S Health & Safety.
>
> **Versão:** 1.0
> **Status:** Especificação inicial — base para construção
> **Escopo desta versão:** PDI, Plano de Carreira e módulos integrados de gestão de talentos

---

## Sumário

1. [Visão Geral do Produto](#1-visão-geral-do-produto)
2. [Princípios e Linguagem](#2-princípios-e-linguagem)
3. [Arquitetura de Módulos](#3-arquitetura-de-módulos)
4. [Módulo 1 — Sistema Cultural](#4-módulo-1--sistema-cultural)
5. [Módulo 2 — Sistema de Metas](#5-módulo-2--sistema-de-metas)
6. [Módulo 3 — Avaliação de Desempenho e 9Box](#6-módulo-3--avaliação-de-desempenho-e-9box)
7. [Módulo 4 — Trilha de Carreira](#7-módulo-4--trilha-de-carreira)
8. [Módulo 5 — PDI (Plano de Desenvolvimento Individual)](#8-módulo-5--pdi-plano-de-desenvolvimento-individual)
9. [Módulo 6 — Universidade Corporativa (Uni.H&S)](#9-módulo-6--universidade-corporativa-unihs)
10. [Módulo 7 — Programa de Desenvolvimento](#10-módulo-7--programa-de-desenvolvimento)
11. [Módulo 8 — Comunicação Interna](#11-módulo-8--comunicação-interna)
12. [Módulo 9 — Subsistemas de RH (Governança, Atração, Retenção)](#12-módulo-9--subsistemas-de-rh)
13. [Perfis de Acesso e Permissões](#13-perfis-de-acesso-e-permissões)
14. [Modelo de Dados (visão lógica)](#14-modelo-de-dados-visão-lógica)
15. [Integrações](#15-integrações)
16. [Stack Tecnológica Sugerida](#16-stack-tecnológica-sugerida)
17. [Roadmap de Implementação](#17-roadmap-de-implementação)
18. [Glossário](#18-glossário)

---

## 1. Visão Geral do Produto

### 1.1 O que é o TalentHS

O **TalentHS** é a plataforma única de gestão de pessoas da H&S Health & Safety. Ele unifica em um único sistema os processos de cultura, metas, avaliação de desempenho, trilha de carreira, PDI, desenvolvimento e comunicação interna — todos hoje espalhados em documentos, planilhas e ferramentas externas.

O nome do colaborador no sistema é **Guardião** (Guardião H&S), em coerência com o propósito da empresa: *"Transformar prevenção em proteção real à vida"*.

### 1.2 Problema que resolve

Hoje, na H&S, processos de gestão de pessoas vivem em PDFs, slides e planilhas, sem integração entre si. Isso gera:

- Falta de visibilidade do desempenho real do Guardião ao longo do ano.
- Avaliações de desempenho desconectadas das metas e dos comportamentos culturais.
- Trilha de Carreira difícil de operacionalizar (vários requisitos vindo de fontes diferentes).
- PDI sem rastreabilidade e sem ligação com a avaliação.
- Universidade Corporativa em uma plataforma externa, sem refletir no sistema de RH.
- Comunicação interna avulsa, sem histórico nem governança.

### 1.3 Objetivo

Centralizar o **Ciclo de Gestão de Pessoas** (Cultura → Metas → Avaliação → 9Box → PDI → Carreira → Desenvolvimento) em uma única plataforma, com dados conectados, automações e visibilidade para Guardiões, Gestores (Nics) e RH.

### 1.4 Visão de uso (3 personas)

- **Guardião:** acompanha suas metas, consulta sua trilha de carreira, faz autoavaliação, vê seu PDI, acessa Uni.H&S, recebe comunicados.
- **Gestor (Nic):** acompanha o time, atualiza progresso de metas, faz avaliações, dá feedback, define PDI junto com o Guardião, aprova movimentações.
- **RH:** configura ciclos, parametriza Trilha de Carreira, calibra avaliações, monta o Mapa de Talentos (9Box), publica comunicados, gere subsistemas.

---

## 2. Princípios e Linguagem

### 2.1 Princípios de produto

1. **Conexão entre os módulos.** Nada é silo. Metas alimentam a Avaliação. Avaliação alimenta o 9Box. 9Box alimenta a Trilha de Carreira e o PDI. Tudo conversa.
2. **Transparência para o Guardião.** O Guardião enxerga sua nota, seu 9Box, seus requisitos de carreira e seu PDI em tempo real.
3. **Mérito e justiça.** Os critérios são objetivos, públicos e iguais para todos.
4. **Cultura no centro.** Avaliação cultural pesa 40% — a maior fatia. A H&S quer pessoas que vivam a cultura, não só batam meta.
5. **Histórico e auditoria.** Tudo o que muda é registrado: quem, quando, o que. Especialmente em metas, avaliações e movimentações salariais.

### 2.2 Linguagem H&S no sistema

| Termo no mercado | Termo no TalentHS |
|---|---|
| Colaborador | **Guardião** |
| Gestor | **Nic** (gestor) |
| Equipe | **Time** |
| Universidade Corporativa | **Uni.H&S** |
| Ciclo de metas/avaliação | **Ciclo de Gestão** |

> Manter essa linguagem ao longo de toda a UI — labels, e-mails, notificações.

---

## 3. Arquitetura de Módulos

```
                       ┌─────────────────────────┐
                       │  1. SISTEMA CULTURAL    │ (Propósito, Manifesto, Valores)
                       └───────────┬─────────────┘
                                   │ orienta
                                   ▼
   ┌─────────────────┐   ┌─────────────────────┐   ┌──────────────────────┐
   │  2. METAS       │──▶│ 3. AVALIAÇÃO + 9BOX │◀──│ 6. UNI.H&S (cursos)  │
   └─────────────────┘   └──────────┬──────────┘   └──────────┬───────────┘
                                    │                          │
                                    ▼                          │
                          ┌─────────────────┐                  │
                          │ 4. TRILHA       │◀─────────────────┤
                          │    DE CARREIRA  │                  │
                          └────────┬────────┘                  │
                                   │                           │
                                   ▼                           │
                          ┌─────────────────┐                  │
                          │ 5. PDI          │──────────────────┘
                          └─────────────────┘

  Transversais: 7. Programa de Desenvolvimento │ 8. Comunicação Interna │ 9. Subsistemas RH
```

### 3.1 Módulos do TalentHS

| # | Módulo | Status atual na H&S | Prioridade |
|---|---|---|---|
| 1 | Sistema Cultural | Definido (manifesto, propósito, valores) | Base |
| 2 | Sistema de Metas | Definido + protótipo de tela | **Alta** |
| 3 | Avaliação de Desempenho + 9Box | Definido (régua, pesos, curva) | **Alta** |
| 4 | Trilha de Carreira | Definida (regras, gatilhos, requisitos) | **Alta** |
| 5 | PDI | A construir (mencionado, sem detalhe) | **Alta** |
| 6 | Uni.H&S | Plataforma externa (catálogo + trilhas por área) | Média (integração) |
| 7 | Programa de Desenvolvimento | Workshops presenciais agendados | Média |
| 8 | Comunicação Interna | Templates definidos (comunicado, aniversário, tempo de casa) | Média |
| 9 | Subsistemas RH (Governança, Atração, Retenção) | Estruturado em organograma de subsistemas | Baixa (fase 2) |

---

## 4. Módulo 1 — Sistema Cultural

### 4.1 O que é

A base cultural da H&S que orienta todos os outros módulos. **Não é um módulo "operacional"** — ele alimenta o sistema de avaliação (Cultura = 40%) e a comunicação.

### 4.2 Conteúdo (vindo do PDF "Sistema Cultural")

**Propósito:**
> Transformar prevenção em proteção real à vida.

**Manifesto — Somos H&S:**
> Nascemos da urgência de proteger pessoas.
> Transformamos prevenção em ação, tecnologia em cuidado e responsabilidade em impacto real.
> Não é apenas um detalhe. É segurança.
> Não é apenas um equipamento. É proteção.
> Não é apenas um teste. É a chance de evitar um acidente.
> É compromisso com a vida.
> Estamos aqui para ajudar empresas a cuidarem de suas pessoas, fortalecerem sua cultura de segurança e tomarem decisões mais responsáveis.
> Somos H&S Health & Safety. O sopro que salva vidas.

**Valores:**
1. Vida em Primeiro Lugar
2. Tecnologia que Protege
3. Integridade que Gera Confiança
4. Cliente no Centro da Proteção
5. Evolução que Salva Mais Vidas

### 4.3 Como o TalentHS implementa

- **Página "Cultura H&S"** acessível por todos os Guardiões, com propósito, manifesto e valores.
- Os valores aparecem como **referência visual** em telas-chave (rodapé do dashboard, página de avaliação).
- A avaliação cultural (módulo 3) usa esses valores como ancoragem dos comportamentos avaliados.
- O onboarding obriga leitura/aceite do Sistema Cultural na primeira semana.

### 4.4 Tela sugerida

- Hero com manifesto.
- Cards dos 5 valores, com descrição expandida.
- Botão "Já li" (registra confirmação para onboarding).

---

## 5. Módulo 2 — Sistema de Metas

### 5.1 Conceito

O Sistema de Metas é composto por **dois grandes blocos** com peso igual:

```
Resultado Total do Guardião = 50% Meta Empresa + 50% Metas Área
```

- **Meta Empresa (50%):** indicadores corporativos que valem para todos (ex.: Engajamento, Inadimplência).
- **Metas Área (50%):** metas específicas de cada time (Comercial, SGI, Administrativo, Laboratório, Estoque e Expedição).

### 5.2 Estrutura hierárquica das metas

```
EMPRESA
  └─ TIME (ex.: Time Gente e Gestão)
       └─ META (ex.: "Reduzir turnover")
            └─ MENSALIZAÇÃO (Jan → Dez, com valor planejado por mês)
                 └─ ATUALIZAÇÃO MENSAL (valor realizado)
```

### 5.3 Ciclo de Metas

Um **Ciclo** é o período em que as metas vigoram (geralmente o ano calendário, mas configurável).

**Atributos do Ciclo:**
- Nome do ciclo (ex.: "2026 | Jan à Dez")
- Data inicial
- Data final
- Valor mínimo da curva (régua de nota — ex.: 80%)
- Valor máximo do progresso (teto — ex.: 120%)

> Múltiplos ciclos podem coexistir (histórico de 2024, 2025, 2026 ativos no seletor).

### 5.4 Estrutura de uma Meta

Quando uma meta é criada, ela tem:

| Campo | Descrição | Exemplo |
|---|---|---|
| **Título** | Nome da meta | "Reduzir inadimplência" |
| **Responsável** | Guardião dono da meta | "Carlos Cavalcanti" |
| **Objetivo** | Aumentar valor / Diminuir valor | Aumentar |
| **Expressão de cálculo** | Como agregar os meses | Soma / Subtração / Média / Repetir |
| **Tipo de resultado** | Unidade | R$ / % / Valor (número) |
| **Peso** | Peso da meta dentro do conjunto do time | 25 |
| **Valor alvo total** | Meta anual | 120 |
| **Mensalização** | Valor planejado por mês (Jan–Dez) | 10 por mês |
| **Curva de Nota** | Valores de referência 80% / 100% / 120% | opcional |

**Opção "Dividir o valor alvo igualmente entre os meses"** — divide o valor alvo total pelos 12 meses automaticamente.

### 5.5 Expressões de cálculo (importante)

São quatro modos de agregar o realizado mensal para gerar o resultado acumulado:

| Expressão | Regra | Caso de uso |
|---|---|---|
| **Soma** | Realizado acumulado = soma dos meses | Faturamento, vendas, número de leads |
| **Subtração** | Realizado acumulado = saldo (subtrai meses) | Redução de despesas |
| **Média** | Realizado acumulado = média dos meses fechados | NPS, satisfação, engajamento |
| **Repetir** | Cada mês "reseta" — o último valor é o que vale | Indicadores instantâneos (turnover do mês) |

### 5.6 Cálculo de progresso (3 visões obrigatórias)

Cada meta exibe **três percentuais simultaneamente** (telas 3 e 4 do PDF):

1. **Mês** — desempenho do mês corrente
   `% Mês = realizado_mês / meta_pontual_mês`
2. **Até o mês** — desempenho acumulado até o último mês fechado
   `% Até o mês = realizado_acumulado / meta_acumulada`
3. **Do ano** — desempenho contra a meta anual total
   `% Do ano = realizado_acumulado / valor_alvo_total`

Cada um vira um **anel/donut** colorido (verde = bom, vermelho = abaixo).

### 5.7 Curva de Nota (régua)

Quando ativada, transforma o realizado em uma "nota" usando 3 pontos de referência:

- Valor a 80% (mínimo aceitável)
- Valor a 100% (meta atingida)
- Valor a 120% (teto — superação)

Usada principalmente para alimentar o eixo **Metas** do 9Box (ver §6.6).

### 5.8 Atualização mensal (fluxo do gestor)

A partir da tela de detalhe da meta (tela 4 do PDF):

1. Gestor clica em **Atualizar**.
2. Seleciona o mês (default = mês corrente).
3. Digita o valor realizado (ex.: "12" de uma meta de 10).
4. Sistema calcula automaticamente:
   - Desvio pontual (real − meta) e %
   - Desvio acumulado (acum_real − acum_meta) e %
5. Sistema registra no **histórico** quem atualizou, quando e o valor anterior.
6. Permite adicionar **comentário + anexo** (PDF, Excel, imagem) explicando o resultado.
7. Após fechar o mês, o gestor pode "**Fechar Março**" (impede edição) ou "**Limpar Março**" (remove valor).

### 5.9 Telas (mapeadas do protótipo)

- **Home / Times / Guardiões HS** (lista hierárquica)
- Lista de metas por Time com 3 anéis (Mês / Até o mês / Do ano)
- Modal **Nova Meta** (todos os campos do §5.4)
- Modal **Novo Ciclo de Metas**
- Detalhe da Meta com:
  - Tabela mensal (Meta pontual / Realizado pontual / Desvio / Meta acumulada / Realizado acumulado / Desvio)
  - Gráfico Planejado vs. Realizado (linha)
  - Painel lateral de Histórico e Comentários
  - Ações: Editar / Mover para cima / Mover para baixo / Excluir

### 5.10 Regras de negócio críticas

- **Pesos das metas de um time devem somar 100** (validar no salvar).
- Meta não pode ser editada após o **fechamento do mês**, exceto por RH com motivo.
- Histórico de toda alteração é imutável.
- Valor realizado pode ser **> que meta** (até o teto da curva — 120% padrão).
- Cada Time tem 1 Gestor (Nic) responsável; metas pertencem ao Time, e o Responsável pela Meta é um Guardião desse Time.

---

## 6. Módulo 3 — Avaliação de Desempenho e 9Box

### 6.1 Conceito

A Avaliação de Desempenho mede o Guardião em **três pilares**, com pesos definidos:

| Pilar | Peso | O que mede |
|---|---|---|
| **Cultura e Comportamentos** | **40%** | Vivência da cultura H&S (visível + genuína) |
| **Entregas e Resultados** | **30%** | Qualidade, prazo, organização, colaboração |
| **Desenvolvimento e Evolução** | **30%** | Feedback, autonomia, protagonismo |

### 6.2 Comportamentos avaliados (vindos do PDF)

**Cultura e Comportamentos Selfit (40%)**
- Alinhamento Cultural Visível (comportamento em público)
- Alinhamento Cultural Genuíno (postura consistente)

**Entregas e Resultados (30%)**
- Entregas (qualidade, prazo e impacto)
- Organização e priorização
- Colaboração entre as pessoas do time e outras áreas

**Desenvolvimento e Evolução (30%)**
- Abertura a feedback
- Autonomia e aprendizado
- Protagonismo com o próprio desenvolvimento

> Cada comportamento é avaliado em **escala de 1 a 5 estrelas**.

### 6.3 Régua de Avaliação (escala)

| Nota | Rótulo | Significado |
|---|---|---|
| 1 | Precisa Melhorar | Não é percebida |
| 2 | Tá no Caminho | Poucas vezes percebida |
| 3 | Atende às Expectativas | Às vezes sim, às vezes não |
| 4 | Tá Mandando Bem | Sempre presente |
| 5 | É Referência | Destaque |

### 6.4 Quem avalia (composição da nota)

A H&S aplica uma **composição diferente para Gestores e para Times**:

**Para Gestores:**
- Gestor (auto) — não, na verdade chefia. Reinterpretando o PDF: **Chefia do gestor = 80%**, **Autoavaliação = 10%**, **Time (subordinados) = 10%**

**Para Times (Guardiões não-gestores):**
- **Gestor (Nic) = 90%**
- **Autoavaliação = 10%**

> Validar com RH antes de codar — o PDF está enxuto. Mantemos como configurável por perfil.

### 6.5 Curva 20-70-10 (Jack Welch)

A H&S adota a curva de vitalidade. Após calibragem, a distribuição esperada é:

- **20%** — Potenciais (notas 4,6 a 5,0)
- **70%** — Esperado / curva (notas 3,0 a 4,5)
- **10%** — Pontos de Atenção (notas 1,0 a 2,9)

O sistema deve **mostrar o histograma do time/empresa** e sinalizar quando a calibragem está fora da curva (ex.: 60% de notas 5).

### 6.6 Mapa de Talentos — 9Box

O **9Box** cruza dois eixos:

- **Eixo Y — Avaliação** (Curva de Vitalidade)
  - Faixa baixa: 1,0 – 2,9
  - Faixa média: 3,0 – 4,5
  - Faixa alta: 4,6 – 5,0
- **Eixo X — Metas** (Progresso Total do Time)
  - Faixa baixa: 0 – 90%
  - Faixa média: 91 – 105%
  - Faixa alta: 106 – 120%

**Os 9 quadrantes (do canto inferior esquerdo ao superior direito):**

| Quadrante | Avaliação | Metas |
|---|---|---|
| Insuficiente | 1,0–2,9 | 0–90% |
| Contribuidor | 1,0–2,9 | 91–105% |
| Alcança Resultados | 1,0–2,9 | 106–120% |
| Competência Consistente | 3,0–4,5 | 0–90% |
| Essenciais | 3,0–4,5 | 91–105% |
| Futuro Talento | 3,0–4,5 | 106–120% |
| Alta Competência | 4,6–5,0 | 0–90% |
| Forte Talento | 4,6–5,0 | 91–105% |
| **Super Talento** | 4,6–5,0 | 106–120% |

> Os quatro quadrantes superiores (Alta Competência, Forte Talento, Super Talento, Futuro Talento) são os **elegíveis para a Trilha de Carreira** (§7).

### 6.7 Etapas do Ciclo de Avaliação

| # | Etapa | O que acontece |
|---|---|---|
| 1 | **Avaliação** | Guardião faz auto + Nic avalia o time; análise objetiva considerando entregas, resultados e cultura |
| 2 | **Calibragem** | Alinhamento entre Nics e RH para garantir coerência e respeitar a curva |
| 3 | **Feedback** | Conversa Nic ↔ Guardião compartilhando a avaliação, pontos fortes, expectativas |
| 4 | **PDI** | Definição dos focos de desenvolvimento para o próximo ciclo |

Cada etapa tem **data início e fim** configurável por RH.

### 6.8 Telas necessárias

1. **Configurar Ciclo de Avaliação** (RH): datas das 4 etapas, pesos, perguntas, escala.
2. **Minha Avaliação** (Guardião): formulário com os 8 comportamentos em estrelas + campo aberto.
3. **Avaliar meu Time** (Nic): lista de Guardiões; mesmo formulário aplicado a cada um.
4. **Calibragem** (RH + Nics): tabela com todas as notas, distribuição na curva, drag-and-drop para reposicionar no 9Box.
5. **Mapa de Talentos 9Box** (visualização): cada Guardião como ponto no quadrante. Filtros por Time / Cargo / Ciclo.
6. **Feedback** (Nic): tela de registro do feedback dado (data, resumo, anexos).

### 6.9 Regras de negócio

- Avaliação só fica **visível para o Guardião após a etapa de Feedback**.
- Calibragem pode mover o Guardião dentro do 9Box — mas a movimentação fica registrada com justificativa.
- O Progresso Total do Time (eixo X do 9Box) vem direto do Sistema de Metas — não é digitado.
- A Avaliação (eixo Y) é a média ponderada das três dimensões (40-30-30).

---

## 7. Módulo 4 — Trilha de Carreira

### 7.1 Conceito

A Trilha de Carreira é o programa anual de **progressão horizontal** (mesmo cargo, salário maior) com base em mérito. **Não é promoção vertical** (mudança de cargo) — isso é tratado fora da Trilha.

### 7.2 Gatilho (pré-requisito da empresa)

> **A Trilha só acontece se a H&S atingir +100% de Faturamento até o fechamento do ciclo.**

Se faturamento < 100%, **ninguém progride**, mesmo que atenda a todos os requisitos individuais. O sistema deve checar isso automaticamente.

### 7.3 Período do ciclo (calendário 2026)

| Fase | Quando |
|---|---|
| Lançamento da Trilha | Jun/2026 |
| Inscrição + envio de comprovações | Até o último dia de jun/2026 |
| Análise dos requisitos (RH) | Jul/2026 |
| Aplicação da progressão salarial | Folha de ago/2026 |

> Datas configuráveis por ciclo. Fora do período, inscrição é bloqueada.

### 7.4 Cargos elegíveis

- Assistente
- Analista
- Coordenador(a)
- Gerente

(Diretoria fora; Operacional sem cargo nessa nomenclatura também é tratado separadamente.)

### 7.5 Requisitos (matriz completa)

Cada Guardião precisa atender **todos** os requisitos do seu cargo. O sistema mostra cada um como "Concluído" ✅ ou "Em andamento" ⏳.

| Requisito | Detalhe | Assistente | Analista | Coord. | Gerente |
|---|---|:-:|:-:|:-:|:-:|
| **Graduação** | Bacharel ou Licenciatura | ⏳ (em andamento ok) | ✅ (concluída) | ✅ | ✅ |
| **Pós-Graduação** | Pós, MBA ou Extensão | — | — | ⏳ | ✅ |
| **Tempo na função** | Mín. 1 ano (12 meses) | ✅ | ✅ | ✅ | ✅ |
| **9Box** | Super Talento / Forte Talento / Futuro Talento / Alta Competência | ✅ | ✅ | ✅ | ✅ |
| **Cultura H&S (Uni.H&S)** | 100% da trilha obrigatória, aprovação ≥70% em cada curso | ✅ | ✅ | ✅ | ✅ |
| **Autodesenvolvimento** | 40h de cursos/treinamentos externos com certificado, últimos 180 dias | ✅ | ✅ | ✅ | ✅ |
| **Metas Parciais** | 100% ou mais até a data limite | ✅ | ✅ | ✅ | ✅ |

> **Observação importante:** cursos da trilha obrigatória da Uni.H&S **não contam** para as 40h de autodesenvolvimento. Cursos abertos da Uni.H&S (mais de mil) **contam**.

### 7.6 Bloqueadores adicionais

- Afastamento pelo INSS no último ano = **inelegível**
- Medidas disciplinares ativas no período = **inelegível**
- Curso trancado **não** vale como "em andamento"

### 7.7 Percentual de progressão (baseado no 9Box)

| Quadrante 9Box | Progressão salarial |
|---|---|
| Super Talento | **+20%** |
| Forte Talento | +10% |
| Futuro Talento | +10% |
| Alta Competência | +10% |

> Aplicado **sobre o salário base vigente**. Não incide sobre benefícios nem variáveis.

### 7.8 Tela "Minha Trilha" (Guardião)

A tela mais importante deste módulo. Mostra:

- **Header com o cargo atual** e o cargo-alvo da trilha (mesmo cargo, mas com indicação visual de progressão).
- **Checklist visual** dos 7 requisitos, com status ✅ / ⏳ / ❌.
- Para cada requisito, link para a fonte de verdade:
  - Graduação → upload de certificado / matrícula
  - Pós → upload
  - Tempo na função → automático (vem do cadastro)
  - 9Box → automático (vem da Avaliação)
  - Cultura Uni.H&S → automático (vem da Uni.H&S)
  - Autodesenvolvimento → upload de certificados; sistema soma horas
  - Metas Parciais → automático (vem do Sistema de Metas)
- **Progressão estimada** (se elegível): "Você seria promovido em **+20%** caso o gatilho de faturamento seja atingido."
- **Status do gatilho de faturamento** (verde / amarelo / vermelho).
- Botão "**Inscrever-me no ciclo**" (ativo apenas durante o período de inscrição).

### 7.9 Tela "Carreira H&S" (visão de crescimento vertical)

Visão informativa, sem ação automática — só para o Guardião enxergar o caminho:

```
Assistente  ──▶  Analista  ──▶  Coordenador(a)  ──▶  Gerente  ──▶  Diretor(a)
```

> A promoção vertical é tratada por processo separado (não automática pela Trilha).

### 7.10 Tela RH — Gestão da Trilha

- Lista de inscritos no ciclo
- Status de cada requisito por Guardião (✅ / ⏳ / ❌)
- Validação manual dos comprovantes enviados
- Aplicação em massa do percentual (gera export para folha)
- Relatório final do ciclo (quem progrediu, quanto, novo salário)

### 7.11 Regras de negócio críticas

- Sem 100% dos requisitos, sem progressão (não há "quase elegível").
- Sem +100% de faturamento, ciclo cancelado para todos.
- Cada Guardião só pode usar 1 ciclo por ano.
- Histórico permanente de todas as progressões (data, %, salário antes/depois).

---

## 8. Módulo 5 — PDI (Plano de Desenvolvimento Individual)

> **Atenção:** este módulo é mencionado nos PDFs (etapa 4 do Ciclo de Avaliação) mas **não tem documento próprio**. A especificação abaixo é uma proposta baseada nas melhores práticas e no que faz sentido para a H&S — **validar com RH antes de construir**.

### 8.1 Conceito

O PDI é o plano de ação individual de desenvolvimento de cada Guardião, definido **após a avaliação** e com base nos gaps identificados. Conecta a Avaliação ao desenvolvimento real (cursos, projetos, mentorias).

### 8.2 Quando o PDI é criado

- Imediatamente após a etapa de **Feedback** do Ciclo de Avaliação.
- Tem o mesmo período do próximo ciclo (geralmente 1 ano).
- Pode ser revisado a qualquer momento (idealmente, em reuniões 1:1 trimestrais).

### 8.3 Estrutura do PDI

Cada PDI tem **de 3 a 5 focos de desenvolvimento**. Cada foco contém:

| Campo | Descrição |
|---|---|
| **Tema** | Comportamento ou competência a desenvolver (ex.: "Comunicação assertiva") |
| **Por que** | Justificativa, ligando ao gap da avaliação |
| **Pilar** | Cultura / Entregas / Desenvolvimento |
| **Comportamento ligado** | Qual comportamento da avaliação (ex.: "Colaboração") |
| **Ações** | Lista de ações concretas (ver §8.4) |
| **Prazo final** | Data |
| **Status** | Não iniciado / Em andamento / Concluído / Cancelado |
| **% de progresso** | 0–100% (média do progresso das ações) |

### 8.4 Tipos de Ação (modelo 70-20-10)

Boa prática de PDI: 70% aprendizagem na prática, 20% com outras pessoas, 10% educação formal.

| Tipo | Exemplo | Comprovação |
|---|---|---|
| **Prática (70%)** | Liderar projeto X, assumir cliente Y | Registro do gestor |
| **Social (20%)** | Mentoria com Fulano, shadowing | Registro de sessões |
| **Formal (10%)** | Curso na Uni.H&S, workshop externo | Certificado (e conta para o autodesenvolvimento da Trilha!) |

### 8.5 Conexões com outros módulos

- **Avaliação** alimenta os gaps que viram focos no PDI.
- **Uni.H&S** é uma das fontes principais de ações formais (curso vira ação do PDI).
- **Programa de Desenvolvimento** (workshops presenciais) também vira ação do PDI.
- **Trilha de Carreira:** horas de curso registradas no PDI **contam** para o requisito de autodesenvolvimento (40h).

### 8.6 Telas

- **Meu PDI** (Guardião): visão dos focos, ações, % de cada um. Pode atualizar status das ações dele.
- **PDI do Time** (Nic): visão consolidada do time, com semáforo de quem está atrasado.
- **Criar/Editar PDI** (Nic + Guardião conjuntamente): wizard de criação dos focos.
- **Histórico de PDIs** (ambos): PDIs encerrados de ciclos anteriores, com resultado final.

### 8.7 Notificações

- Lembrete mensal: "Você tem 3 ações em andamento. Atualize seu PDI."
- Lembrete de prazo: 30 dias antes do fim do ciclo.
- Notificação ao Nic: ação vencida sem atualização há 60 dias.

### 8.8 Regras de negócio

- PDI é **obrigatório** para todos os Guardiões após cada Ciclo de Avaliação.
- Aprovação dupla: Guardião escreve, Nic aprova.
- RH tem visão consolidada para identificar temas recorrentes (informa o Programa de Desenvolvimento).

---

## 9. Módulo 6 — Universidade Corporativa (Uni.H&S)

### 9.1 Status atual

A Uni.H&S é uma plataforma **externa** (provavelmente iped.com.br, baseado nos links dos PDFs), com:

- **Catálogo aberto** de mais de mil cursos.
- **Trilhas de aprendizagem por área** já definidas (ver §9.2).
- **Tutora IA "Lina"** disponível 24h.
- **Preço por usuário**, escalonado (R$9,69 até 50 / R$7,76 acima de 1000).
- Setup de R$1.000 + faturamento mínimo de R$250/mês.

### 9.2 Trilhas por área (catálogo H&S)

**Comercial (Vendas, SDR, Serviços):**
1. Negociação: Treinando Habilidades com IA
2. Closer, Hunter e Farmer em Vendas
3. Técnicas de Vendas
4. Gestão de Relacionamento com o Cliente
5. Analisando Vendas: KPIs

**Administrativo (Financeiro, RH):**
1. Microsoft Copilot: IA para Ferramentas Office
2. Gestão Financeira
3. Fluxo de Caixa na Prática
4. Departamento Pessoal
5. RH Estratégico

**SGI (TI, Qualidade, Suporte):**
1. ChatGPT para Trabalho
2. Assistência de Operação de Suporte Técnico
3. Analista de Cibersegurança
4. Gestão de Qualidade
5. Power BI

**Laboratório:**
1. Microsoft Copilot: IA para Ferramentas Office
2. Estatística Geral
3. Gestão de Qualidade
4. Lean Six Sigma
5. Power BI

**Estoque e Expedição:**
1. Microsoft Copilot: IA para Ferramentas Office
2. Gestão de Estoque
3. Administração de Armazenagem
4. Logística Empresarial
5. Gestão de Riscos na Logística

### 9.3 Como o TalentHS conversa com a Uni.H&S

O TalentHS **não precisa replicar a plataforma de cursos**. Ele precisa **integrar** para:

1. Saber quais cursos cada Guardião concluiu (com nota ≥70%).
2. Saber a carga horária acumulada (para o requisito de Trilha de Carreira).
3. Marcar automaticamente o requisito "Cultura H&S" da Trilha como ✅.
4. Recomendar cursos da trilha da área do Guardião.

### 9.4 Integração técnica

**Opção A — API:** se a plataforma (iped) tiver API, consumir em background diariamente.
**Opção B — Importação CSV:** RH exporta CSV mensal e importa no TalentHS.
**Opção C — Webhook:** plataforma envia evento de "curso concluído" → TalentHS recebe e atualiza.

> Começar pela opção B (mais simples e independente) e migrar para A/C quando viável.

### 9.5 Telas

- **Catálogo H&S** (Guardião): mostra cursos recomendados (área + obrigatórios) + acesso à plataforma externa.
- **Meu Aprendizado** (Guardião): cursos concluídos, em andamento, horas totais.
- **Indicadores de Uni.H&S** (RH): adesão, horas/Guardião, gaps de área.

---

## 10. Módulo 7 — Programa de Desenvolvimento

### 10.1 Conceito

Workshops presenciais e atividades formativas pontuais. Diferente da Uni.H&S (auto-instrucional), esses são **eventos com data, local e instrutor**.

### 10.2 Exemplos atuais (PDF)

| Workshop | Data | Local | Objetivo |
|---|---|---|---|
| Comunicação Empresarial | 10/jun (qua), 12h–17h | Coco Bambu Derby | Comunicação clara, empática, assertiva |
| Autoconhecimento e Flexibilidade | 29/jun (seg), 12h–17h | Coco Bambu Derby | Revisão de crenças e padrões |

### 10.3 Estrutura no TalentHS

| Campo | Descrição |
|---|---|
| Nome | Comunicação Empresarial |
| Tipo | Workshop / Treinamento / Imersão |
| Data e hora | 10/jun, 12h–17h |
| Local | Coco Bambu Derby |
| Modalidade | Presencial / Online / Híbrido |
| Objetivo | (texto) |
| Público-alvo | Nics / Time X / Toda empresa |
| Vagas | (número) |
| Custo por participante | (opcional) |
| Inscrição | Link para inscrição |
| Status pós-evento | Realizado, lista de presença |

### 10.4 Telas

- **Calendário de Desenvolvimento** (Guardião): vê todos os eventos do trimestre.
- **Detalhe do evento + Inscrição**.
- **Gestão de Programas** (RH): cria, edita, controla presença.

### 10.5 Conexões

- Inscrição automática para Guardiões cujo PDI tenha tema correspondente (sugestão).
- Presença confirmada conta como ação de PDI concluída.
- Horas presenciais somam ao autodesenvolvimento (se houver certificado).

---

## 11. Módulo 8 — Comunicação Interna

### 11.1 Tipos de comunicação

| Tipo | Template | Frequência |
|---|---|---|
| **Comunicado oficial** | Layout com cabeçalho azul "Título do Comunicado" + corpo | Sob demanda |
| **Aniversário do Guardião** | "Parabéns + idade" + foto polaroid + balões | Mensal/diário |
| **Tempo de casa ("Sou H&S há X anos")** | Layout azul com foto + "Transformando prevenção em proteção" | No aniversário H&S |
| **Bolo no fim do mês** | Comunicado coletivo dos aniversariantes | Mensal |
| **Boas-vindas** | A definir (sugestão para implantação) | Por contratação |
| **Datas comemorativas** | Variável | Conforme calendário |

### 11.2 Estrutura no TalentHS

Funcionalidades necessárias:
- Editor de comunicados (rico texto + upload de imagem + categoria).
- **Templates pré-prontos** (carregar layout, trocar variáveis: {nome}, {anos}, {foto}).
- Disparador automático:
  - Aniversário (todo dia 00:00 verifica e dispara cartões dos aniversariantes).
  - Tempo de casa (idem, com base na data de admissão).
- Histórico de comunicados (mural / feed da empresa).
- Notificação push + e-mail.

### 11.3 Telas

- **Mural H&S** (todos): feed de comunicados, aniversários, novidades.
- **Criar comunicado** (RH / Comunicação).
- **Gestor de templates** (RH).

### 11.4 Regras

- Comunicados oficiais precisam de aprovação (workflow: rascunho → revisão → publicado).
- Aniversários e tempo de casa são automáticos (não dependem de aprovação).
- Guardião pode optar por não aparecer no mural (privacidade).

---

## 12. Módulo 9 — Subsistemas de RH

> Esta é a visão organizacional do RH da H&S, que servirá de base para um eventual **módulo de governança** do TalentHS na fase 2.

### 12.1 Estrutura (organograma de subsistemas)

```
RECURSOS HUMANOS
├── GOVERNANÇA      → Políticas*, Código de Conduta Ética*, Canal de Conduta*
├── ATRAÇÃO         → Recrutamento e Seleção, Admissão, Exames
├── RETENÇÃO        → Ticket Alimentação/Refeição, Vale Transporte, TotalPass,
│                     Hapvida, OdontoPrev, Bolsa de Graduação e Pós*
├── TREINAMENTO     → Onboarding, Equipe de Qualidade, Programa de Liderança*, Uni.H&S*
├── CULTURA         → Sou H&S Há (tempo empresa)*, Pesquisa de Engajamento*, GPTW*
├── ENDOMARKETING   → Comunicados, Datas comemorativas, Confras, Day-off,
│                     Comunicado do Aniversariante, Bolo no fim do mês,
│                     Comunicado de boas-vindas*, Happy Hour*, Calendário de ações*
└── SISTEMA GESTÃO  → RMR*, Trilha de Carreira*, Metas*, Avaliação de Desempenho*, Organograma*
```

*Itens marcados como "sugestão para implantação".*

### 12.2 Mapa de cobertura — quais subsistemas o TalentHS atende

| Subsistema | TalentHS cobre? | Como |
|---|---|---|
| Governança | Parcial | Documentos publicados no portal |
| Atração | Não (fase 2) | — |
| Retenção | Parcial (Bolsa Grad/Pós) | Workflow de solicitação |
| Treinamento | Sim | Uni.H&S + Programa de Desenvolvimento + Onboarding |
| Cultura | Sim | Sistema Cultural + Sou H&S Há + Pesquisa de Engajamento |
| Endomarketing | Sim | Módulo de Comunicação Interna |
| Sistema Gestão | Sim (core) | Metas + Avaliação + Trilha de Carreira + Organograma |

---

## 13. Perfis de Acesso e Permissões

| Perfil | Vê | Cria | Edita | Aprova |
|---|---|---|---|---|
| **Guardião** | Suas metas, sua avaliação (pós-feedback), seu PDI, sua trilha, seu aprendizado | Comentários, autoavaliação, upload de certificados | Seu PDI (parte dele) | — |
| **Nic (Gestor)** | Tudo de seu time + agregado | Metas do time, avaliações dos liderados, PDIs do time, atualizações de progresso | Metas, avaliações, PDIs do time | PDI dos liderados, justificativas |
| **RH** | Tudo da empresa | Ciclos, configurações, comunicados, trilha (regras), templates | Tudo administrativo, calibragem | Trilha de Carreira, comunicados oficiais |
| **Diretoria** | Tudo (read-only por padrão) | Pode disparar comunicados executivos | — | Casos excepcionais (Trilha) |
| **Admin TI** | Configurações técnicas | Usuários, integrações | — | — |

### 13.1 Hierarquia e visibilidade

- Um Guardião só vê seus próprios dados.
- Um Nic vê todos do seu time direto + indireto (cascata).
- RH vê todos.
- Não há visibilidade horizontal sem permissão (pares não veem avaliação um do outro).

---

## 14. Modelo de Dados (visão lógica)

### 14.1 Entidades principais

```
Guardião (User)
├── id, nome, email, foto, data_admissão, data_nascimento
├── cargo, cargo_nivel (Assistente/Analista/Coord./Gerente)
├── time_id (FK), nic_id (FK → Guardião)
├── salário_base, está_afastado_inss, tem_medida_disciplinar
└── status (ativo/inativo/afastado)

Time
├── id, nome, descrição
├── nic_id (FK → Guardião)
└── área (Comercial / Administrativo / SGI / Laboratório / Estoque)

CicloGestão
├── id, nome, data_início, data_fim
├── valor_mín_curva, valor_máx_progresso
└── status (rascunho / ativo / encerrado)

Meta
├── id, ciclo_id, time_id, responsável_id
├── título, objetivo (aumentar/diminuir)
├── expressão (soma/subtração/média/repetir)
├── tipo_resultado (R$/%/valor), peso, valor_alvo_total
├── valores_mensais [{mês, planejado}]
└── curva_nota {v80, v100, v120}

AtualizaçãoMeta
├── id, meta_id, mês, valor_realizado
├── atualizado_por (FK), atualizado_em
├── comentário, anexos[]
└── fechado (bool)

Avaliação
├── id, ciclo_id, guardião_avaliado_id, avaliador_id
├── tipo (auto/nic/chefia/time)
├── peso_na_composição (10/80/90/etc)
└── notas [{comportamento, estrelas, comentário}]

NotaConsolidada
├── id, guardião_id, ciclo_id
├── nota_cultura, nota_entregas, nota_desenvolvimento
├── nota_final (40+30+30)
├── posição_9box (calculada com Progresso de Metas)
└── calibragem_aplicada (bool, justificativa)

TrilhaCarreira
├── id, ciclo_ano, gatilho_faturamento (%)
└── status (rascunho/aberto/análise/aplicado/encerrado)

InscriçãoTrilha
├── id, trilha_id, guardião_id
├── requisitos {graduação, pós, tempo, 9box, cultura_uni, autodes, metas} (cada um: status + comprovações[])
├── elegível (bool, calculado)
└── progressão_aplicada (% + salário_novo)

PDI
├── id, guardião_id, ciclo_id
├── status, % progresso
└── focos[]

FocoPDI
├── id, pdi_id, tema, por_que, pilar, comportamento_ligado
├── prazo, status
└── ações[]

AçãoPDI
├── id, foco_id, tipo (prática/social/formal)
├── descrição, prazo, status
└── horas_realizadas, certificado_url

CursoUni
├── id, nome, plataforma_externa_id
├── carga_horária, área
└── obrigatório (bool)

ConclusãoCurso
├── id, guardião_id, curso_id
├── nota_final, data_conclusão
└── certificado_url

Comunicado
├── id, título, corpo, autor_id, tipo
├── data_publicação, público_alvo
└── status (rascunho/revisão/publicado)
```

### 14.2 Relacionamentos críticos

- `Guardião 1—N Meta` (responsável)
- `Time 1—N Meta`
- `CicloGestão 1—N Avaliação 1—N NotaConsolidada`
- `NotaConsolidada` → calcula `9Box` → alimenta `InscriçãoTrilha`
- `Avaliação` → identifica gaps → cria `PDI`
- `ConclusãoCurso` → soma horas → alimenta `InscriçãoTrilha` (requisito autodesenvolvimento)

---

## 15. Integrações

| Sistema | Direção | O que troca |
|---|---|---|
| Uni.H&S (iped ou similar) | Recebe | Cursos concluídos, notas, certificados, horas |
| Folha de Pagamento | Envia | Salário novo após Trilha de Carreira |
| ERP financeiro | Recebe | Faturamento mensal (para gatilho da Trilha) |
| E-mail (SMTP) | Envia | Notificações, comunicados |
| WhatsApp Business API (opcional) | Envia | Aniversários, lembretes |
| Hapvida / OdontoPrev / TotalPass | Recebe | Status de plano por Guardião |
| SSO corporativo (Google/Microsoft) | Bidirecional | Login |

---

## 16. Stack Tecnológica Sugerida

Considerando que o foco da H&S é simplicidade e produtividade do time interno:

| Camada | Sugestão |
|---|---|
| Frontend | React + TypeScript + TailwindCSS + shadcn/ui |
| Backend | Node.js (NestJS) ou Python (FastAPI) |
| Banco de dados | PostgreSQL |
| Cache | Redis (sessões, gatilhos) |
| Storage de arquivos (certificados, anexos) | S3 compatível |
| Auth | Auth0 ou Clerk (SSO + MFA pronto) |
| Notificações | Resend (e-mail) + provider WhatsApp |
| Hospedagem | AWS, Vercel ou Railway |
| Observabilidade | Sentry + Posthog |

Para o **MVP**, priorizar entregar rápido com pouca infra: Vercel (front) + Railway (back+db) + S3.

---

## 17. Roadmap de Implementação

### Fase 0 — Fundação (4 semanas)

- Autenticação, cadastro de Guardiões, Times, organograma
- Página do Sistema Cultural (estática)
- Estrutura base de Ciclo de Gestão
- Perfis e permissões

### Fase 1 — Núcleo de Performance (8 semanas) 🎯 **Mais alta prioridade**

- **Sistema de Metas** completo (criação, mensalização, atualização, histórico, anexos)
- **Avaliação de Desempenho** (auto + Nic, com pesos 40/30/30)
- **Calibragem** + Mapa de Talentos 9Box
- Dashboard do Guardião e do Nic

### Fase 2 — Carreira e Desenvolvimento (6 semanas)

- **Trilha de Carreira** com checklist de requisitos
- **PDI** integrado à Avaliação
- Gatilho de faturamento (integração financeira)
- Tela "Minha Trilha"

### Fase 3 — Aprendizado e Comunicação (4 semanas)

- Integração com **Uni.H&S** (importação CSV)
- **Programa de Desenvolvimento** (workshops)
- **Comunicação Interna** (mural + aniversários automáticos)

### Fase 4 — Subsistemas e Extras (4 semanas)

- Onboarding digital
- Pesquisa de Engajamento / GPTW
- Bolsa de Graduação e Pós (workflow)
- Relatórios executivos

### Fase 5 — Otimização e Mobile (contínua)

- App mobile (React Native ou PWA)
- IA: sugestão de PDI baseada na avaliação
- IA: análise de tendência de metas

> **Tempo total estimado para o sistema completo:** ~26 semanas (6 meses) com um time de 2 devs full-stack + 1 designer + 1 PM.

---

## 18. Glossário

| Termo | Definição |
|---|---|
| **Guardião** | Colaborador da H&S |
| **Nic** | Gestor de time (líder direto) |
| **Time** | Equipe sob um Nic |
| **Ciclo de Gestão** | Período em que metas e avaliações vigoram (geralmente anual) |
| **9Box / Mapa de Talentos** | Matriz 3×3 cruzando Avaliação (Y) e Metas (X) |
| **Trilha de Carreira** | Programa anual de progressão horizontal (mesmo cargo, salário maior) |
| **PDI** | Plano de Desenvolvimento Individual |
| **Uni.H&S** | Universidade Corporativa da H&S |
| **Curva 20-70-10** | Distribuição esperada das notas (Jack Welch) |
| **Gatilho de Faturamento** | Condição da empresa atingir +100% para a Trilha acontecer |
| **Calibragem** | Etapa de revisão das avaliações para garantir coerência |
| **Manifesto Somos H&S** | Texto cultural fundador |
| **Sopro que salva vidas** | Tagline cultural da empresa |

---

## Anexo A — Checklist de Decisões Pendentes com RH

Antes de começar a implementação, validar os pontos abaixo com o time de RH da H&S:

- [ ] Composição da avaliação para Gestores está correta? (Chefia 80% + Auto 10% + Time 10%)
- [ ] PDI é obrigatório para todos os Guardiões ou só para alguns quadrantes?
- [ ] Quantos focos mínimos/máximos no PDI?
- [ ] Cursos da Uni.H&S oferecidos gratuitamente entram nas 40h ou não? (PDF diz que **entram**, mas trilha obrigatória **não**)
- [ ] Promoção vertical: como entra no TalentHS? (Hoje é fora da Trilha, mas precisa estar registrada.)
- [ ] Pesquisa de Engajamento: qual ferramenta? (Pulses, eNPS?)
- [ ] Bolo no fim do mês e Day-off do aniversariante são automáticos no TalentHS ou só comunicado?
- [ ] Bolsa de Graduação e Pós: % de subsídio? Workflow de aprovação?
- [ ] Quem é o aprovador final da Trilha de Carreira: RH ou Diretoria?
- [ ] Salário base inclui ou não 13º, férias, etc., para cálculo do +20%?

---

## Anexo B — Referências aos Documentos Originais

Este especificação consolida e estrutura o conteúdo dos seguintes PDFs fornecidos pela H&S:

1. **H&S — Sistema Cultural** (propósito, manifesto, valores)
2. **H&S — Sistema de Metas** (estrutura empresa + área)
3. **H&S — Sistema de Metas Plataforma** (protótipo de telas)
4. **H&S — Avaliação de Desempenho** (pesos, escala, curva, 9Box, etapas)
5. **H&S — Trilha de Carreira v001** (regras gerais, requisitos, gatilho, progressão)
6. **H&S — Universidade Corporativa** (Uni.H&S, trilhas por área, plataforma)
7. **H&S — Programa de Desenvolvimento** (workshops presenciais)
8. **H&S — Comunicação Interna** (templates: comunicado, aniversário, tempo de casa)
9. **H&S — Desenho Padronizado dos Subsistemas** (organograma do RH)

---

*Documento gerado para apoiar a construção do TalentHS. Sugestões e ajustes são bem-vindos — este documento deve evoluir junto com o produto.*
