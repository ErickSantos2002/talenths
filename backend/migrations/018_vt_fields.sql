ALTER TABLE public.employee_benefits
    ADD COLUMN IF NOT EXISTS ticket_price numeric(12,2),
    ADD COLUMN IF NOT EXISTS tickets_per_day integer;
