-- Fase 4.2: Programa de Desenvolvimento — Workshops

CREATE TABLE IF NOT EXISTS public.workshops (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    title text NOT NULL,
    area text NOT NULL,
    description text,
    location text,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    max_seats integer,
    status text NOT NULL DEFAULT 'open' CHECK (status IN ('draft', 'open', 'closed', 'done')),
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.workshop_registrations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    workshop_id uuid NOT NULL REFERENCES public.workshops(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    status text NOT NULL DEFAULT 'registered' CHECK (status IN ('registered', 'attended', 'absent')),
    registered_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (workshop_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_workshops_company ON public.workshops(company_id);
CREATE INDEX IF NOT EXISTS idx_workshop_reg_workshop ON public.workshop_registrations(workshop_id);
CREATE INDEX IF NOT EXISTS idx_workshop_reg_user ON public.workshop_registrations(user_id);
