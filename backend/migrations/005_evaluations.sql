-- Ciclos de Avaliação de Desempenho
CREATE TABLE IF NOT EXISTS public.evaluation_cycles (
  id                   uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id           uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  management_cycle_id  uuid        REFERENCES public.management_cycles(id) ON DELETE SET NULL,
  name                 text        NOT NULL,
  -- Datas de cada etapa
  eval_start           date,
  eval_end             date,
  calibration_start    date,
  calibration_end      date,
  feedback_start       date,
  feedback_end         date,
  pdi_start            date,
  pdi_end              date,
  status               text        NOT NULL DEFAULT 'draft'
    CHECK (status IN ('draft', 'evaluation', 'calibration', 'feedback', 'pdi', 'closed')),
  created_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid
);
ALTER TABLE public.evaluation_cycles ENABLE ROW LEVEL SECURITY;

-- Avaliações (uma por avaliador × avaliado × ciclo × tipo)
CREATE TABLE IF NOT EXISTS public.evaluations (
  id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  eval_cycle_id     uuid        NOT NULL REFERENCES public.evaluation_cycles(id) ON DELETE CASCADE,
  company_id        uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  evaluated_user_id uuid        NOT NULL,
  evaluator_user_id uuid        NOT NULL,
  eval_type         text        NOT NULL CHECK (eval_type IN ('self', 'manager', 'chief', 'team')),
  submitted_at      timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now(),
  UNIQUE (eval_cycle_id, evaluated_user_id, evaluator_user_id, eval_type)
);
ALTER TABLE public.evaluations ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_evaluations_cycle_evaluated ON public.evaluations(eval_cycle_id, evaluated_user_id);

-- Notas por comportamento
CREATE TABLE IF NOT EXISTS public.evaluation_scores (
  id             uuid     PRIMARY KEY DEFAULT gen_random_uuid(),
  evaluation_id  uuid     NOT NULL REFERENCES public.evaluations(id) ON DELETE CASCADE,
  behavior_key   text     NOT NULL,
  score          integer  NOT NULL CHECK (score BETWEEN 1 AND 5),
  comment        text,
  UNIQUE (evaluation_id, behavior_key)
);
ALTER TABLE public.evaluation_scores ENABLE ROW LEVEL SECURITY;

-- Notas consolidadas por colaborador × ciclo (calculadas pelo sistema)
CREATE TABLE IF NOT EXISTS public.consolidated_scores (
  id                  uuid         PRIMARY KEY DEFAULT gen_random_uuid(),
  eval_cycle_id       uuid         NOT NULL REFERENCES public.evaluation_cycles(id) ON DELETE CASCADE,
  user_id             uuid         NOT NULL,
  company_id          uuid         NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  score_cultura       numeric(4,2),
  score_entregas      numeric(4,2),
  score_desenvolvimento numeric(4,2),
  score_final         numeric(4,2),
  -- 9Box: 1=baixo, 2=médio, 3=alto
  nine_box_x          integer      CHECK (nine_box_x BETWEEN 1 AND 3),
  nine_box_y          integer      CHECK (nine_box_y BETWEEN 1 AND 3),
  nine_box_quadrant   text,
  calibrated          boolean      NOT NULL DEFAULT false,
  calibration_note    text,
  computed_at         timestamptz  DEFAULT now(),
  UNIQUE (eval_cycle_id, user_id)
);
ALTER TABLE public.consolidated_scores ENABLE ROW LEVEL SECURITY;
