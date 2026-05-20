# Módulo de Testes — Guia de Implementação no TalentHS

## Visão geral

O módulo de Testes substitui o antigo sistema de cenários psicométricos fixos por uma plataforma de avaliações totalmente configurável pelo RH. O objetivo é dar ao RH autonomia para criar qualquer tipo de teste — técnico, comportamental, de conhecimento, onboarding etc. — e disponibilizá-los aos colaboradores de forma controlada.

### Dois lados do módulo

**RH / Gestor — seção Desempenho › Empresa**
- Criar e gerenciar testes com quantas perguntas quiser
- Escolher o tipo de cada pergunta (múltipla escolha, texto aberto, escala, checklist)
- Configurar pontuação automática por gabarito ou deixar para avaliação manual
- Publicar, arquivar e atribuir testes a pessoas ou departamentos específicos
- Ver todas as tentativas e avaliar manualmente as questões abertas

**Colaborador — seção Pessoal › Desempenho**
- Ver os testes disponíveis para ele
- Realizar os testes no próprio sistema
- Acompanhar o histórico de tentativas com respostas e pontuação
- Ver a avaliação do RH quando disponível

---

## 1. Domínio e modelo de dados

### 1.1 Conceitos principais

```
Test (Teste)
  ├── TestQuestion[] (Perguntas)
  │     └── TestQuestionOption[] (Opções — para múltipla escolha / checklist)
  ├── TestAssignment[] (Atribuições — quem pode fazer)
  └── TestAttempt[] (Tentativas dos colaboradores)
        ├── TestResponse[] (Respostas por questão)
        └── TestEvaluation (Nota final + feedback do RH)
```

### 1.2 Tipos de pergunta (`question_type`)

| Valor              | Descrição                                          | Auto-pontuação? |
|--------------------|----------------------------------------------------|:---------------:|
| `single_choice`    | Múltipla escolha, apenas uma resposta correta       | ✅              |
| `multiple_choice`  | Múltipla escolha, N respostas corretas              | ✅              |
| `true_false`       | Verdadeiro ou Falso                                 | ✅              |
| `checklist`        | Lista de itens para marcar (N corretos esperados)   | ✅              |
| `scale`            | Escala numérica (ex: 1 a 5, NPS 0-10)              | ✅ (por peso)   |
| `open_text`        | Resposta escrita livre                              | ❌ (manual)     |

### 1.3 Modos de avaliação do teste (`scoring_mode`)

| Valor       | Comportamento                                                               |
|-------------|-----------------------------------------------------------------------------|
| `auto`      | Pontuação calculada automaticamente ao submeter; colaborador vê o resultado |
| `manual`    | RH avalia todas as respostas e atribui nota; resultado só aparece após isso  |
| `mixed`     | Questões com gabarito pontuam automaticamente; abertas vão para RH avaliar  |

### 1.4 Migração SQL

Criar novo arquivo em `backend/supabase/migrations/`.

```sql
-- ─────────────────────────────────────────────────────────────
-- Testes
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.custom_tests (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id        UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  created_by        UUID NOT NULL REFERENCES auth.users(id),

  title             TEXT NOT NULL,
  description       TEXT,
  instructions      TEXT,               -- Texto exibido antes do colaborador começar

  scoring_mode      TEXT NOT NULL DEFAULT 'auto'
                    CHECK (scoring_mode IN ('auto', 'manual', 'mixed')),

  -- Configuração de acesso
  is_public         BOOLEAN NOT NULL DEFAULT true,   -- false = atribuição explícita obrigatória
  max_attempts      INT,                             -- NULL = ilimitado
  time_limit_min    INT,                             -- Tempo limite em minutos (NULL = sem limite)
  pass_score        NUMERIC(5,2),                    -- Nota mínima para "aprovado" (NULL = sem corte)
  total_points      NUMERIC(8,2) NOT NULL DEFAULT 0, -- Calculado automaticamente

  status            TEXT NOT NULL DEFAULT 'draft'
                    CHECK (status IN ('draft', 'published', 'archived')),

  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Perguntas
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_questions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  test_id         UUID NOT NULL REFERENCES public.custom_tests(id) ON DELETE CASCADE,

  order_index     INT NOT NULL DEFAULT 0,
  question_type   TEXT NOT NULL
                  CHECK (question_type IN (
                    'single_choice', 'multiple_choice', 'true_false',
                    'checklist', 'scale', 'open_text'
                  )),
  text            TEXT NOT NULL,
  explanation     TEXT,           -- Texto explicativo exibido após a resposta (opcional)
  is_required     BOOLEAN NOT NULL DEFAULT true,
  points          NUMERIC(6,2) NOT NULL DEFAULT 1,

  -- Configuração específica para escala
  scale_min       INT,            -- Ex: 1
  scale_max       INT,            -- Ex: 5
  scale_labels    JSONB,          -- Ex: {"1": "Discordo totalmente", "5": "Concordo totalmente"}

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Opções de resposta (múltipla escolha, checklist, verdadeiro/falso)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_question_options (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id     UUID NOT NULL REFERENCES public.test_questions(id) ON DELETE CASCADE,

  order_index     INT NOT NULL DEFAULT 0,
  text            TEXT NOT NULL,
  is_correct      BOOLEAN NOT NULL DEFAULT false,   -- Para gabarito automático
  point_value     NUMERIC(6,2) NOT NULL DEFAULT 0,  -- Pontos se esta opção for selecionada

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Atribuições — quem pode acessar o teste
-- (ignorado se custom_tests.is_public = true)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_assignments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  test_id     UUID NOT NULL REFERENCES public.custom_tests(id) ON DELETE CASCADE,
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  department_id UUID REFERENCES public.departments(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Pelo menos um dos dois deve ser preenchido
  CHECK (user_id IS NOT NULL OR department_id IS NOT NULL)
);

-- ─────────────────────────────────────────────────────────────
-- Tentativas dos colaboradores
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_attempts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  test_id         UUID NOT NULL REFERENCES public.custom_tests(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  attempt_number  INT NOT NULL DEFAULT 1,
  status          TEXT NOT NULL DEFAULT 'in_progress'
                  CHECK (status IN ('in_progress', 'submitted', 'evaluated')),

  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  submitted_at    TIMESTAMPTZ,
  evaluated_at    TIMESTAMPTZ,
  evaluated_by    UUID REFERENCES auth.users(id),

  -- Pontuação
  auto_score      NUMERIC(8,2),    -- Calculada automaticamente
  manual_score    NUMERIC(8,2),    -- Atribuída pelo RH
  final_score     NUMERIC(8,2),    -- auto_score + manual_score
  passed          BOOLEAN,         -- true se final_score >= pass_score

  hr_feedback     TEXT,            -- Feedback textual do RH

  UNIQUE (test_id, user_id, attempt_number)
);

-- ─────────────────────────────────────────────────────────────
-- Respostas por questão
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_responses (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id      UUID NOT NULL REFERENCES public.test_attempts(id) ON DELETE CASCADE,
  question_id     UUID NOT NULL REFERENCES public.test_questions(id),

  -- Cada tipo de resposta usa um campo diferente
  selected_option_ids  UUID[],          -- single_choice, multiple_choice, checklist
  text_response        TEXT,            -- open_text
  scale_value          INT,             -- scale
  boolean_response     BOOLEAN,         -- true_false

  -- Pontuação automática desta questão
  auto_points     NUMERIC(6,2),
  -- Pontuação manual do RH para esta questão (open_text no modo mixed)
  manual_points   NUMERIC(6,2),
  hr_comment      TEXT,

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (attempt_id, question_id)
);

-- ─────────────────────────────────────────────────────────────
-- Índices
-- ─────────────────────────────────────────────────────────────
CREATE INDEX idx_custom_tests_company        ON public.custom_tests(company_id);
CREATE INDEX idx_test_questions_test         ON public.test_questions(test_id);
CREATE INDEX idx_test_options_question       ON public.test_question_options(question_id);
CREATE INDEX idx_test_attempts_user          ON public.test_attempts(user_id);
CREATE INDEX idx_test_attempts_test          ON public.test_attempts(test_id);
CREATE INDEX idx_test_responses_attempt      ON public.test_responses(attempt_id);
CREATE INDEX idx_test_assignments_test       ON public.test_assignments(test_id);
```

---

## 2. Backend (FastAPI)

### 2.1 Estrutura do router

Criar `backend/app/routers/custom_tests.py` e registrar em `main.py`:

```python
from app.routers.custom_tests import router as custom_tests_router
app.include_router(custom_tests_router)
```

### 2.2 Mapa completo de endpoints

```
# ── Gestão de testes (manager+) ──────────────────────────────
GET    /tests                              → listar todos os testes da empresa
POST   /tests                             → criar teste
GET    /tests/{test_id}                   → detalhes + perguntas + opções
PUT    /tests/{test_id}                   → atualizar metadados do teste
DELETE /tests/{test_id}                   → remover teste (só em draft)
POST   /tests/{test_id}/publish           → publicar (draft → published)
POST   /tests/{test_id}/archive           → arquivar (published → archived)
POST   /tests/{test_id}/duplicate         → clonar teste inteiro

# ── Perguntas ────────────────────────────────────────────────
POST   /tests/{test_id}/questions          → adicionar pergunta
PUT    /tests/questions/{question_id}      → editar pergunta
DELETE /tests/questions/{question_id}      → remover pergunta
PUT    /tests/{test_id}/questions/reorder  → reordenar perguntas (array de IDs)

# ── Opções de resposta ───────────────────────────────────────
POST   /tests/questions/{question_id}/options   → adicionar opção
PUT    /tests/options/{option_id}               → editar opção
DELETE /tests/options/{option_id}               → remover opção

# ── Atribuições ──────────────────────────────────────────────
GET    /tests/{test_id}/assignments        → listar atribuições
POST   /tests/{test_id}/assignments        → atribuir a usuário ou departamento
DELETE /tests/{test_id}/assignments/{id}   → remover atribuição

# ── Visão do RH sobre tentativas ─────────────────────────────
GET    /tests/{test_id}/attempts           → todas as tentativas de um teste
GET    /tests/attempts/{attempt_id}        → detalhes de uma tentativa
POST   /tests/attempts/{attempt_id}/evaluate → avaliar tentativa (score + feedback)
GET    /tests/{test_id}/stats              → estatísticas agregadas do teste

# ── Lado do colaborador ──────────────────────────────────────
GET    /tests/available                    → testes disponíveis para o usuário logado
POST   /tests/{test_id}/start             → iniciar tentativa
GET    /tests/my-attempts                  → histórico de tentativas do colaborador
GET    /tests/my-attempts/{attempt_id}     → detalhes de uma tentativa própria
POST   /tests/attempts/{attempt_id}/respond → salvar respostas (parcial ou total)
POST   /tests/attempts/{attempt_id}/submit  → submeter tentativa finalizada
```

### 2.3 Lógica de pontuação automática

Ao chamar `POST /tests/attempts/{attempt_id}/submit`, o sistema percorre todas as respostas e calcula `auto_points` por questão:

```python
def score_response(question: dict, options: list[dict], response: dict) -> float:
    qtype = question["question_type"]

    if qtype == "open_text":
        return 0  # Sem pontuação automática

    if qtype in ("single_choice", "true_false"):
        selected = response.get("selected_option_ids", [])
        correct = [o["id"] for o in options if o["is_correct"]]
        return question["points"] if selected == correct else 0

    if qtype == "multiple_choice":
        selected = set(response.get("selected_option_ids", []))
        correct = {o["id"] for o in options if o["is_correct"]}
        # Pontuação total só se acertar todas e não marcar erradas
        return question["points"] if selected == correct else 0

    if qtype == "checklist":
        # Pontuação proporcional: pontos por item correto
        selected = set(response.get("selected_option_ids", []))
        per_item = question["points"] / max(len([o for o in options if o["is_correct"]]), 1)
        earned = sum(per_item for o in options if o["is_correct"] and o["id"] in selected)
        penalty = sum(per_item for o in options if not o["is_correct"] and o["id"] in selected)
        return max(0, earned - penalty)

    if qtype == "scale":
        # Cada opção da escala tem point_value configurado pelo RH
        matched = next((o for o in options if o["order_index"] == response.get("scale_value")), None)
        return matched["point_value"] if matched else 0

    return 0
```

Após calcular todos os `auto_points`:

```python
auto_score = sum(r["auto_points"] for r in responses)

# No modo 'auto' ou quando não há questões abertas pendentes:
if test["scoring_mode"] == "auto":
    final_score = auto_score
    passed = final_score >= test["pass_score"] if test["pass_score"] else None
    status = "evaluated"
else:
    # 'mixed' ou 'manual' → aguarda avaliação do RH
    status = "submitted"
```

### 2.4 Endpoint de avaliação manual (`POST /tests/attempts/{attempt_id}/evaluate`)

```python
# Payload esperado:
{
  "manual_score": 8.5,          # Nota global atribuída pelo RH (modo manual)
  "hr_feedback": "Boa resposta, mas poderia detalhar mais X.",
  "question_scores": [           # Opcional — pontos por questão aberta (modo mixed)
    { "question_id": "uuid", "manual_points": 3.0, "hr_comment": "..." }
  ]
}

# O backend:
# 1. Salva manual_score e hr_feedback em test_attempts
# 2. Atualiza manual_points nas test_responses referenciadas
# 3. Recalcula final_score = auto_score + manual_score
# 4. Atualiza passed e muda status para 'evaluated'
# 5. Dispara notificação para o colaborador
```

### 2.5 Verificação de acesso (`GET /tests/available`)

```python
# O colaborador vê um teste se:
# 1. O teste está publicado
# 2. is_public = true  OU  existe uma atribuição para ele ou seu departamento
# 3. max_attempts é NULL  OU  número de tentativas já feitas < max_attempts

SELECT t.* FROM custom_tests t
LEFT JOIN test_assignments ta ON ta.test_id = t.id
  AND (ta.user_id = :user_id OR ta.department_id = :dept_id)
LEFT JOIN (
  SELECT test_id, COUNT(*) as cnt FROM test_attempts
  WHERE user_id = :user_id GROUP BY test_id
) att ON att.test_id = t.id
WHERE t.company_id = :company_id
  AND t.status = 'published'
  AND (t.is_public = true OR ta.id IS NOT NULL)
  AND (t.max_attempts IS NULL OR COALESCE(att.cnt, 0) < t.max_attempts)
```

---

## 3. Frontend (React + TypeScript)

### 3.1 Novas páginas

```
# RH / Gestor
src/pages/admin/Testes.tsx                  → listagem + criação de testes
src/pages/admin/TesteEditor.tsx             → editor completo do teste e perguntas
src/pages/admin/TesteTentativas.tsx         → tentativas de um teste + avaliação manual

# Colaborador
src/pages/desempenho/MeusTestes.tsx         → testes disponíveis + histórico
src/pages/desempenho/RealizarTeste.tsx      → fluxo de realização do teste
src/pages/desempenho/ResultadoTeste.tsx     → resultado de uma tentativa concluída
```

Registrar em `src/App.tsx`:

```tsx
// Admin
<Route path="/admin/testes"                   element={<Testes />} />
<Route path="/admin/testes/:testId/editar"    element={<TesteEditor />} />
<Route path="/admin/testes/:testId/tentativas" element={<TesteTentativas />} />

// Colaborador
<Route path="/meus-testes"                    element={<MeusTestes />} />
<Route path="/meus-testes/:testId/realizar"   element={<RealizarTeste />} />
<Route path="/meus-testes/tentativas/:attemptId" element={<ResultadoTeste />} />
```

### 3.2 Componentes sugeridos

```
src/components/tests/
  builder/
    QuestionBuilder.tsx           → formulário de criação/edição de pergunta
    OptionsList.tsx               → lista de opções com drag-and-drop para reordenar
    QuestionTypeSelector.tsx      → seletor de tipo com ícones descritivos
    TestSettingsForm.tsx          → formulário de metadados (scoring_mode, max_attempts etc.)
  player/
    QuestionPlayer.tsx            → renderiza uma pergunta de acordo com seu tipo
    SingleChoiceInput.tsx
    MultipleChoiceInput.tsx
    ScaleInput.tsx
    ChecklistInput.tsx
    OpenTextInput.tsx
    ProgressBar.tsx               → progresso da tentativa (questão X de Y)
  results/
    AttemptSummary.tsx            → resumo de uma tentativa (score, passou/não passou)
    QuestionReview.tsx            → revisão pergunta a pergunta com gabarito
    ManualEvaluationForm.tsx      → formulário do RH para avaliar tentativa
```

### 3.3 Fluxo do editor de testes (RH)

```
1. TesteEditor carrega o teste existente ou inicia vazio
2. Seção de metadados: título, descrição, instruções, scoring_mode,
   max_attempts, time_limit_min, pass_score, is_public
3. Lista de perguntas com drag-and-drop para reordenar
4. Botão "+ Pergunta" abre QuestionBuilder:
   - Selecionar tipo
   - Digitar texto da pergunta e pontos
   - Se tipo ≠ open_text: adicionar opções com flag "correta" e valor de ponto
   - Para scale: configurar min, max e labels
5. Salvar altera status para 'draft' (não publica ainda)
6. Botão "Publicar" faz POST /tests/{id}/publish
7. Teste publicado: edição bloqueada (exibe banner de aviso),
   botão "Arquivar" disponível
```

### 3.4 Fluxo de realização do teste (Colaborador)

```
1. MeusTestes exibe cards: testes disponíveis vs. histórico de tentativas
2. Clicar em "Iniciar" → POST /tests/{id}/start → redireciona para RealizarTeste
3. RealizarTeste exibe uma pergunta por vez (ou todas, conforme preferência)
   - Respostas são salvas automaticamente ao avançar
     (POST /tests/attempts/{id}/respond com respostas parciais)
   - Barra de progresso no topo
   - Contador de tempo se time_limit_min estiver configurado
4. Na última questão: botão "Enviar teste"
   → Confirmação → POST /tests/attempts/{id}/submit
5. Redirecionamento para ResultadoTeste:
   - scoring_mode = 'auto': resultado imediato com score e gabarito
   - scoring_mode = 'manual' | 'mixed': mensagem "Aguardando avaliação do RH"
```

### 3.5 Fluxo de avaliação manual (RH)

```
1. TesteTentativas lista todas as tentativas de um teste
   - Status: "Em progresso", "Aguardando avaliação", "Avaliado"
   - Filtros por colaborador, departamento, status
2. Clicar em uma tentativa "Aguardando avaliação":
   - Exibe todas as perguntas e respostas do colaborador
   - Para questões automáticas: mostra pontuação já calculada
   - Para questões abertas: campo de pontos + comentário por questão
   - Campo de feedback geral e nota final
3. "Salvar avaliação" → POST /tests/attempts/{id}/evaluate
4. Colaborador recebe notificação e pode ver o resultado
```

### 3.6 Estatísticas do teste (RH)

O endpoint `GET /tests/{test_id}/stats` deve retornar, e a página `TesteTentativas` deve exibir:

- Total de tentativas / concluídas / em andamento
- Taxa de aprovação (se `pass_score` configurado)
- Score médio, mínimo e máximo
- Por pergunta: distribuição das respostas (quais opções mais selecionadas)
- Tempo médio de conclusão

---

## 4. Notificações

Disparar notificações (tabela `notifications` existente) nos eventos:

| Evento                             | Destinatário       | Mensagem sugerida                              |
|------------------------------------|--------------------|------------------------------------------------|
| Teste publicado e atribuído        | Colaborador        | "Você tem um novo teste disponível: [título]"  |
| Tentativa submetida (manual/mixed) | Manager da empresa | "Nova tentativa aguarda avaliação: [título]"   |
| Tentativa avaliada pelo RH         | Colaborador        | "Seu resultado em [título] está disponível"    |

---

## 5. Integração com outros módulos

### 5.1 PDI

Ao criar um PDI, o RH pode vincular um teste como forma de acompanhar o desenvolvimento. Adicionar campo opcional `test_id` em `pdi_actions` para indicar "complete este teste como parte desta ação".

### 5.2 Avaliações de desempenho

O histórico de testes completados pode ser exibido no painel de avaliação do colaborador como evidência de desenvolvimento — leitura apenas, sem integração de pontuação.

### 5.3 Relatórios

Adicionar em `reports.py`:

```
GET /reports/tests   → CSV com: colaborador, teste, tentativa nº, data, score final,
                       passou/não passou, status de avaliação
```

---

## 6. Regras de negócio

- Um teste só pode ser publicado se tiver **ao menos uma pergunta**.
- Testes com status `published` ou `archived` **não podem ser editados** — o RH deve duplicar e criar uma nova versão.
- Um colaborador só pode ter **uma tentativa `in_progress`** por teste ao mesmo tempo.
- Respostas parciais (salvas durante a realização) não contam como tentativa concluída — o `status` permanece `in_progress` até o submit.
- O gabarito (quais opções são corretas) **nunca é exposto** em endpoints acessíveis pelo colaborador — nem antes nem durante a tentativa.
- O colaborador só vê o gabarito depois que a tentativa está com status `evaluated`.
- O campo `scoring_mode = 'manual'` desabilita completamente a exibição de resultado para o colaborador até o RH avaliar.

---

## 7. Checklist de implementação

**Banco de dados**
- [ ] Criar migration com as 5 novas tabelas
- [ ] Criar índices listados na migration

**Backend**
- [ ] Criar `backend/app/routers/custom_tests.py`
- [ ] Implementar todos os endpoints (gestão, perguntas, opções, atribuições, tentativas)
- [ ] Implementar lógica de pontuação automática (`score_response`)
- [ ] Implementar verificação de acesso (`/tests/available`)
- [ ] Implementar avaliação manual e recalculo de `final_score`
- [ ] Disparar notificações nos eventos mapeados
- [ ] Registrar router em `main.py`
- [ ] Adicionar `GET /reports/tests` em `reports.py`

**Frontend**
- [ ] Criar páginas admin: `Testes`, `TesteEditor`, `TesteTentativas`
- [ ] Criar páginas colaborador: `MeusTestes`, `RealizarTeste`, `ResultadoTeste`
- [ ] Criar componentes `builder/` e `player/`
- [ ] Registrar rotas em `App.tsx`
- [ ] Adicionar links de navegação nos menus (admin e colaborador)
- [ ] Criar hooks React Query para todos os endpoints
- [ ] Implementar salvamento automático de respostas parciais
- [ ] Implementar contador de tempo (se `time_limit_min` configurado)

**Integrações**
- [ ] Exibir histórico de testes no painel de avaliação do colaborador
- [ ] Adicionar campo `test_id` opcional em `pdi_actions` (segunda etapa)
