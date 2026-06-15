-- Fase 6: Ponto Eletrônico (controle interno)
-- Batidas livres alternadas (1ª entrada, 2ª saída, ...), jornada configurável por colaborador.

-- Config por colaborador
ALTER TABLE public.profiles
    ADD COLUMN IF NOT EXISTS timeclock_enabled boolean NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS daily_work_hours numeric(4,2) NOT NULL DEFAULT 8.5;

-- Registros de ponto
CREATE TABLE IF NOT EXISTS public.timeclock_punches (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    punched_at timestamptz NOT NULL DEFAULT now(),
    work_date date NOT NULL,
    kind text NOT NULL CHECK (kind IN ('in', 'out')),
    source text NOT NULL DEFAULT 'self' CHECK (source IN ('self', 'manual')),
    latitude numeric(9, 6),
    longitude numeric(9, 6),
    note text,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_timeclock_punches_company ON public.timeclock_punches(company_id);
CREATE INDEX IF NOT EXISTS idx_timeclock_punches_user_date ON public.timeclock_punches(user_id, work_date);
