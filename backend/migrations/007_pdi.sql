-- Plano de Desenvolvimento Individual
CREATE TABLE IF NOT EXISTS public.pdi_plans (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id      uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id         uuid        NOT NULL,
  eval_cycle_id   uuid        REFERENCES public.evaluation_cycles(id) ON DELETE SET NULL,
  title           text        NOT NULL,
  description     text,
  status          text        NOT NULL DEFAULT 'active'
    CHECK (status IN ('active', 'closed')),
  created_by      uuid,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.pdi_plans ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_pdi_plans_user ON public.pdi_plans(user_id, company_id);

-- Ações do PDI
CREATE TABLE IF NOT EXISTS public.pdi_actions (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id      uuid        NOT NULL REFERENCES public.pdi_plans(id) ON DELETE CASCADE,
  title        text        NOT NULL,
  description  text,
  how          text,
  due_date     date,
  status       text        NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'in_progress', 'done')),
  completed_at timestamptz,
  updated_by   uuid,
  updated_at   timestamptz NOT NULL DEFAULT now(),
  created_at   timestamptz NOT NULL DEFAULT now(),
  position     integer     NOT NULL DEFAULT 0
);
ALTER TABLE public.pdi_actions ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_pdi_actions_plan ON public.pdi_actions(plan_id);
