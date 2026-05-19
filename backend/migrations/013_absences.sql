-- Fase 5.3: Férias, Afastamentos e Ausências

CREATE TABLE IF NOT EXISTS public.absence_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    name text NOT NULL,
    color text NOT NULL DEFAULT '#6366f1',
    requires_approval boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Seed tipos padrão via trigger ou direto no migrate
-- (feito via código no router ao criar empresa, ou pré-populado abaixo)

CREATE TABLE IF NOT EXISTS public.absence_requests (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    type_id uuid NOT NULL REFERENCES public.absence_types(id) ON DELETE RESTRICT,
    start_date date NOT NULL,
    end_date date NOT NULL,
    days integer NOT NULL,
    reason text,
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reviewed_by uuid,
    reviewed_at timestamptz,
    review_note text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_absence_requests_company ON public.absence_requests(company_id);
CREATE INDEX IF NOT EXISTS idx_absence_requests_user ON public.absence_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_absence_requests_dates ON public.absence_requests(start_date, end_date);
