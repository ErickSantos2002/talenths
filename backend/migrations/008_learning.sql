-- Fase 4: Universidade Corporativa

CREATE TABLE IF NOT EXISTS public.course_catalog (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    title text NOT NULL,
    area text NOT NULL,
    description text,
    duration_hours numeric(6,1) NOT NULL DEFAULT 0,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.employee_courses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    catalog_id uuid REFERENCES public.course_catalog(id) ON DELETE SET NULL,
    course_title text NOT NULL,
    area text NOT NULL,
    hours numeric(6,1) NOT NULL DEFAULT 0,
    completed_at date NOT NULL,
    source text NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'csv')),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_employee_courses_user ON public.employee_courses(user_id);
CREATE INDEX IF NOT EXISTS idx_employee_courses_company ON public.employee_courses(company_id);
