-- 034_learning_track_progress.sql — progresso nas trilhas da plataforma de cursos
-- Uma linha por pessoa em cada trilha; a importação do CSV da plataforma atualiza o mesmo registro.
CREATE TABLE IF NOT EXISTS public.learning_track_progress (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id          uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id             uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  external_track_id   text NOT NULL,
  track_name          text NOT NULL,
  group_name          text,
  courses             text[] NOT NULL DEFAULT '{}',
  started_at          timestamptz,
  finished_at         timestamptz,
  progress_pct        numeric(5,2) NOT NULL DEFAULT 0 CHECK (progress_pct BETWEEN 0 AND 100),
  score_pct           numeric(5,2) CHECK (score_pct BETWEEN 0 AND 100),
  imported_at         timestamptz NOT NULL DEFAULT now(),
  imported_by         uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  -- Registro concluído criado quando a trilha terminou; impede criar outro na reimportação.
  employee_course_id  uuid REFERENCES public.employee_courses(id) ON DELETE SET NULL,
  created_at          timestamptz NOT NULL DEFAULT now(),
  UNIQUE (company_id, user_id, external_track_id)
);
CREATE INDEX IF NOT EXISTS idx_learning_track_progress_company ON public.learning_track_progress(company_id);
