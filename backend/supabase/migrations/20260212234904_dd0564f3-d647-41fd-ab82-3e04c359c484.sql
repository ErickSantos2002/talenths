
-- Add cnpj and status columns to companies
ALTER TABLE public.companies ADD COLUMN cnpj text;
ALTER TABLE public.companies ADD COLUMN status text NOT NULL DEFAULT 'active';

-- Add unique constraint on cnpj
ALTER TABLE public.companies ADD CONSTRAINT companies_cnpj_unique UNIQUE (cnpj);
