CREATE TABLE public.salary_market_references (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id    UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  market        TEXT NOT NULL,
  region        TEXT NOT NULL,
  reference_year INT NOT NULL,
  is_active     BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.salary_table_entries (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_id    UUID NOT NULL REFERENCES public.salary_market_references(id) ON DELETE CASCADE,
  company_id      UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  job_family      TEXT NOT NULL,
  seniority       TEXT NOT NULL,
  band_90         NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_95         NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_100        NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_105        NUMERIC(12, 2) NOT NULL DEFAULT 0,
  band_110        NUMERIC(12, 2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (reference_id, job_family, seniority)
);

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS current_salary NUMERIC(12, 2),
  ADD COLUMN IF NOT EXISTS job_family TEXT,
  ADD COLUMN IF NOT EXISTS seniority TEXT;

CREATE INDEX idx_salary_entries_company   ON public.salary_table_entries(company_id);
CREATE INDEX idx_salary_entries_reference ON public.salary_table_entries(reference_id);
CREATE INDEX idx_salary_refs_company      ON public.salary_market_references(company_id);
