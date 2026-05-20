-- ─────────────────────────────────────────────────────────────
-- Testes configuráveis pelo RH
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.custom_tests (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id        UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  created_by        UUID NOT NULL REFERENCES auth.users(id),

  title             TEXT NOT NULL,
  description       TEXT,
  instructions      TEXT,

  scoring_mode      TEXT NOT NULL DEFAULT 'auto'
                    CHECK (scoring_mode IN ('auto', 'manual', 'mixed')),

  is_public         BOOLEAN NOT NULL DEFAULT true,
  max_attempts      INT,
  time_limit_min    INT,
  pass_score        NUMERIC(5,2),
  total_points      NUMERIC(8,2) NOT NULL DEFAULT 0,

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
  explanation     TEXT,
  is_required     BOOLEAN NOT NULL DEFAULT true,
  points          NUMERIC(6,2) NOT NULL DEFAULT 1,

  scale_min       INT,
  scale_max       INT,
  scale_labels    JSONB,

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Opções de resposta
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_question_options (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id     UUID NOT NULL REFERENCES public.test_questions(id) ON DELETE CASCADE,

  order_index     INT NOT NULL DEFAULT 0,
  text            TEXT NOT NULL,
  is_correct      BOOLEAN NOT NULL DEFAULT false,
  point_value     NUMERIC(6,2) NOT NULL DEFAULT 0,

  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ─────────────────────────────────────────────────────────────
-- Atribuições
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_assignments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  test_id       UUID NOT NULL REFERENCES public.custom_tests(id) ON DELETE CASCADE,
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  department_id UUID REFERENCES public.departments(id) ON DELETE CASCADE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

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

  auto_score      NUMERIC(8,2),
  manual_score    NUMERIC(8,2),
  final_score     NUMERIC(8,2),
  passed          BOOLEAN,
  hr_feedback     TEXT,

  UNIQUE (test_id, user_id, attempt_number)
);

-- ─────────────────────────────────────────────────────────────
-- Respostas por questão
-- ─────────────────────────────────────────────────────────────
CREATE TABLE public.test_responses (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id           UUID NOT NULL REFERENCES public.test_attempts(id) ON DELETE CASCADE,
  question_id          UUID NOT NULL REFERENCES public.test_questions(id),

  selected_option_ids  UUID[],
  text_response        TEXT,
  scale_value          INT,
  boolean_response     BOOLEAN,

  auto_points          NUMERIC(6,2),
  manual_points        NUMERIC(6,2),
  hr_comment           TEXT,

  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (attempt_id, question_id)
);

-- ─────────────────────────────────────────────────────────────
-- Índices
-- ─────────────────────────────────────────────────────────────
CREATE INDEX idx_custom_tests_company     ON public.custom_tests(company_id);
CREATE INDEX idx_custom_tests_status      ON public.custom_tests(status);
CREATE INDEX idx_test_questions_test      ON public.test_questions(test_id);
CREATE INDEX idx_test_options_question    ON public.test_question_options(question_id);
CREATE INDEX idx_test_attempts_user       ON public.test_attempts(user_id);
CREATE INDEX idx_test_attempts_test       ON public.test_attempts(test_id);
CREATE INDEX idx_test_responses_attempt   ON public.test_responses(attempt_id);
CREATE INDEX idx_test_assignments_test    ON public.test_assignments(test_id);
