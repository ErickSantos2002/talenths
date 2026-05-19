-- Fase 5.1: Onboarding Digital

CREATE TABLE IF NOT EXISTS public.onboarding_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    name text NOT NULL,
    description text,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.onboarding_template_tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    template_id uuid NOT NULL REFERENCES public.onboarding_templates(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    responsible_role text NOT NULL DEFAULT 'user' CHECK (responsible_role IN ('user', 'manager')),
    due_days integer NOT NULL DEFAULT 7,
    position integer NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.onboarding_checklists (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    template_id uuid REFERENCES public.onboarding_templates(id) ON DELETE SET NULL,
    template_name text,
    started_at date NOT NULL DEFAULT CURRENT_DATE,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (company_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.onboarding_checklist_tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    checklist_id uuid NOT NULL REFERENCES public.onboarding_checklists(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    responsible_role text NOT NULL DEFAULT 'user',
    due_date date,
    position integer NOT NULL DEFAULT 0,
    completed_at timestamptz,
    completed_by uuid
);

CREATE INDEX IF NOT EXISTS idx_onboarding_checklists_company ON public.onboarding_checklists(company_id);
CREATE INDEX IF NOT EXISTS idx_onboarding_checklist_tasks_checklist ON public.onboarding_checklist_tasks(checklist_id);
