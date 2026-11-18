-- Avaliação de Desempenho (consultoria de RH, nov/2026):
-- 1. Cada colaborador tem um gestor responsável, o único que dá a nota de gestor dele.
-- 2. A etapa do ciclo pode seguir as datas cadastradas em vez de ser trocada à mão.
-- 3. A nota consolidada guarda as duas parcelas da média ponderada (gestor 90%, auto 10%).

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS manager_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_manager_not_self CHECK (manager_user_id IS NULL OR manager_user_id <> user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_manager_user_id ON public.profiles(manager_user_id);

ALTER TABLE public.evaluation_cycles
  ADD COLUMN IF NOT EXISTS stage_by_dates boolean NOT NULL DEFAULT false;
-- Ciclos já criados com período de avaliação passam a seguir as datas: era o que o RH
-- esperava ao cadastrá-las.
UPDATE public.evaluation_cycles SET stage_by_dates = true WHERE eval_start IS NOT NULL AND eval_end IS NOT NULL;

ALTER TABLE public.consolidated_scores
  ADD COLUMN IF NOT EXISTS score_manager numeric(4,2),
  ADD COLUMN IF NOT EXISTS score_self    numeric(4,2);
