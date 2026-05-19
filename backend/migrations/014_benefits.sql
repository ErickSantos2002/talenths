-- Fase 5.4: Benefícios por Colaborador

CREATE TABLE IF NOT EXISTS public.benefit_catalog (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    name text NOT NULL,
    category text NOT NULL CHECK (category IN ('saude', 'alimentacao', 'transporte', 'financeiro', 'educacao', 'bem_estar', 'outro')),
    description text,
    provider text,
    value_type text NOT NULL DEFAULT 'info' CHECK (value_type IN ('fixed', 'variable', 'percentage', 'info')),
    value numeric(12,2),
    active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.employee_benefits (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    benefit_id uuid NOT NULL REFERENCES public.benefit_catalog(id) ON DELETE RESTRICT,
    value_override numeric(12,2),
    start_date date NOT NULL DEFAULT CURRENT_DATE,
    end_date date,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_benefit_catalog_company ON public.benefit_catalog(company_id);
CREATE INDEX IF NOT EXISTS idx_employee_benefits_company ON public.employee_benefits(company_id);
CREATE INDEX IF NOT EXISTS idx_employee_benefits_user ON public.employee_benefits(user_id);
