ALTER TABLE public.companies
  ADD COLUMN IF NOT EXISTS internal_rules JSONB DEFAULT '[]'::jsonb;
