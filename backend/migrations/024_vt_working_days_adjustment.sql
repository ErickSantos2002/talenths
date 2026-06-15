-- Vale-Transporte: ajuste manual de dias úteis no catálogo.
-- Mantém o cálculo automático de dias úteis e soma este delta (pode ser negativo).

ALTER TABLE public.benefit_catalog
    ADD COLUMN IF NOT EXISTS working_days_adjustment integer NOT NULL DEFAULT 0;
