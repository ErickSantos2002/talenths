-- Trilhas de Carreira
CREATE TABLE IF NOT EXISTS public.career_tracks (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name        text        NOT NULL,
  description text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  created_by  uuid
);
ALTER TABLE public.career_tracks ENABLE ROW LEVEL SECURITY;

-- Níveis de cada trilha (ordenados por position)
CREATE TABLE IF NOT EXISTS public.career_levels (
  id                       uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  track_id                 uuid        NOT NULL REFERENCES public.career_tracks(id) ON DELETE CASCADE,
  name                     text        NOT NULL,
  position                 integer     NOT NULL,
  description              text,
  -- Critérios de promoção (todos opcionais)
  min_score_final          numeric(4,2),
  required_9box_quadrants  text[],
  min_months_in_level      integer,
  UNIQUE (track_id, position)
);
ALTER TABLE public.career_levels ENABLE ROW LEVEL SECURITY;

-- Posição atual de cada colaborador (uma por pessoa)
CREATE TABLE IF NOT EXISTS public.employee_career (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid        NOT NULL,
  company_id  uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  track_id    uuid        NOT NULL REFERENCES public.career_tracks(id),
  level_id    uuid        NOT NULL REFERENCES public.career_levels(id),
  started_at  date        NOT NULL DEFAULT CURRENT_DATE,
  promoted_by uuid,
  notes       text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, company_id)
);
ALTER TABLE public.employee_career ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_employee_career_user ON public.employee_career(user_id);
