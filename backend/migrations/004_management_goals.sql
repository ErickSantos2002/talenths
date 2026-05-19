-- Ciclos de Gestão
CREATE TABLE IF NOT EXISTS public.management_cycles (
  id                 uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id         uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name               text        NOT NULL,
  start_date         date        NOT NULL,
  end_date           date        NOT NULL,
  min_curve_value    numeric(10,4) NOT NULL DEFAULT 0.80,
  max_progress_value numeric(10,4) NOT NULL DEFAULT 1.20,
  status             text        NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'closed')),
  created_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid
);
ALTER TABLE public.management_cycles ENABLE ROW LEVEL SECURITY;

-- Metas
CREATE TABLE IF NOT EXISTS public.goals (
  id                   uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  cycle_id             uuid        NOT NULL REFERENCES public.management_cycles(id) ON DELETE CASCADE,
  department_id        uuid        NOT NULL REFERENCES public.departments(id) ON DELETE RESTRICT,
  company_id           uuid        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  responsible_user_id  uuid,
  title                text        NOT NULL,
  objective            text        NOT NULL DEFAULT 'increase' CHECK (objective IN ('increase', 'decrease')),
  calculation_type     text        NOT NULL DEFAULT 'sum'      CHECK (calculation_type IN ('sum', 'subtraction', 'average', 'repeat')),
  result_type          text        NOT NULL DEFAULT 'value'    CHECK (result_type IN ('currency', 'percentage', 'value')),
  weight               numeric(5,2)  NOT NULL DEFAULT 0,
  target_value         numeric(15,4) NOT NULL DEFAULT 0,
  curve_v80            numeric(15,4),
  curve_v100           numeric(15,4),
  curve_v120           numeric(15,4),
  position             integer     NOT NULL DEFAULT 0,
  created_at           timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_goals_cycle_dept ON public.goals(cycle_id, department_id);

-- Mensalização (planejado por mês)
CREATE TABLE IF NOT EXISTS public.goal_monthly_plans (
  id            uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id       uuid          NOT NULL REFERENCES public.goals(id) ON DELETE CASCADE,
  month         smallint      NOT NULL CHECK (month BETWEEN 1 AND 12),
  planned_value numeric(15,4) NOT NULL DEFAULT 0,
  UNIQUE (goal_id, month)
);
ALTER TABLE public.goal_monthly_plans ENABLE ROW LEVEL SECURITY;

-- Realizados mensais
CREATE TABLE IF NOT EXISTS public.goal_monthly_actuals (
  id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id      uuid          NOT NULL REFERENCES public.goals(id) ON DELETE CASCADE,
  month        smallint      NOT NULL CHECK (month BETWEEN 1 AND 12),
  actual_value numeric(15,4),
  comment      text,
  is_closed    boolean       NOT NULL DEFAULT false,
  updated_by   uuid,
  updated_at   timestamptz   DEFAULT now(),
  UNIQUE (goal_id, month)
);
ALTER TABLE public.goal_monthly_actuals ENABLE ROW LEVEL SECURITY;

-- Histórico imutável de atualizações
CREATE TABLE IF NOT EXISTS public.goal_update_history (
  id             uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id        uuid          NOT NULL REFERENCES public.goals(id) ON DELETE CASCADE,
  month          smallint      NOT NULL,
  previous_value numeric(15,4),
  new_value      numeric(15,4) NOT NULL,
  comment        text,
  changed_at     timestamptz   NOT NULL DEFAULT now(),
  changed_by     uuid
);
ALTER TABLE public.goal_update_history ENABLE ROW LEVEL SECURITY;
CREATE INDEX IF NOT EXISTS idx_goal_history_goal_month ON public.goal_update_history(goal_id, month, changed_at DESC);
