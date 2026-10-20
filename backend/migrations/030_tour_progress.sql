-- 030_tour_progress.sql — progresso de cada pessoa nos tours guiados (boas-vindas e afins)
CREATE TABLE IF NOT EXISTS public.tour_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_id uuid REFERENCES public.companies(id) ON DELETE CASCADE,  -- nulo: perfil sem empresa
  tour text NOT NULL,
  version smallint NOT NULL,
  step smallint NOT NULL DEFAULT 0,
  started_at timestamptz,
  completed_at timestamptz,
  dismissed_at timestamptz,
  invites_declined smallint NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT tour_progress_tour_format CHECK (tour ~ '^[a-z0-9-]{1,64}$'),
  CONSTRAINT tour_progress_version_range CHECK (version BETWEEN 1 AND 999),
  CONSTRAINT tour_progress_step_range CHECK (step BETWEEN 0 AND 999),
  CONSTRAINT tour_progress_invites_declined_nonneg CHECK (invites_declined >= 0),
  CONSTRAINT tour_progress_user_tour_key UNIQUE (user_id, tour)
);
CREATE INDEX IF NOT EXISTS idx_tour_progress_user ON public.tour_progress(user_id);
