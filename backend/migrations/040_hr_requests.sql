-- Ausências vira Solicitações ao RH: além do pedido de saída, o colaborador pede para
-- "pagar hora" (combinar a hora extra que compensa horas devidas). Os dois seguem o mesmo
-- fluxo de aprovação, então ficam na mesma tabela e o tipo diz a categoria. O saldo de
-- horas não mora aqui: o banco de horas é do sistema de ponto.

ALTER TABLE public.absence_types RENAME TO hr_request_types;
ALTER TABLE public.absence_requests RENAME TO hr_requests;

ALTER INDEX IF EXISTS public.idx_absence_requests_company RENAME TO idx_hr_requests_company;
ALTER INDEX IF EXISTS public.idx_absence_requests_user RENAME TO idx_hr_requests_user;
ALTER INDEX IF EXISTS public.idx_absence_requests_dates RENAME TO idx_hr_requests_dates;

ALTER TABLE public.hr_request_types RENAME CONSTRAINT absence_types_pkey TO hr_request_types_pkey;
ALTER TABLE public.hr_request_types RENAME CONSTRAINT absence_types_company_id_fkey TO hr_request_types_company_id_fkey;
ALTER TABLE public.hr_requests RENAME CONSTRAINT absence_requests_pkey TO hr_requests_pkey;
ALTER TABLE public.hr_requests RENAME CONSTRAINT absence_requests_company_id_fkey TO hr_requests_company_id_fkey;
ALTER TABLE public.hr_requests RENAME CONSTRAINT absence_requests_type_id_fkey TO hr_requests_type_id_fkey;
ALTER TABLE public.hr_requests RENAME CONSTRAINT absence_requests_status_check TO hr_requests_status_check;

ALTER TABLE public.hr_request_types
    ADD COLUMN IF NOT EXISTS category text NOT NULL DEFAULT 'saida'
        CHECK (category IN ('saida', 'pagar_hora'));

-- seed
INSERT INTO public.hr_request_types (company_id, name, color, requires_approval, category)
SELECT c.company_id, 'Pagar hora', '#10b981', true, 'pagar_hora'
  FROM (SELECT DISTINCT company_id FROM public.hr_request_types) c
 WHERE NOT EXISTS (
       SELECT 1 FROM public.hr_request_types t WHERE t.company_id = c.company_id AND t.name = 'Pagar hora');
