-- Ponto Eletrônico — solicitações: registro manual (pendente) e ajuste de horário.
-- Nada é descartado: pontos rejeitados ficam marcados e ajustes guardam histórico completo.

-- Status e auditoria nas batidas
ALTER TABLE public.timeclock_punches
    ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'valid' CHECK (status IN ('valid', 'pending', 'rejected')),
    ADD COLUMN IF NOT EXISTS reason text,
    ADD COLUMN IF NOT EXISTS reviewed_by uuid,
    ADD COLUMN IF NOT EXISTS reviewed_at timestamptz;

-- source passa a aceitar 'self_manual' (registro manual feito pelo próprio colaborador)
ALTER TABLE public.timeclock_punches DROP CONSTRAINT IF EXISTS timeclock_punches_source_check;
ALTER TABLE public.timeclock_punches
    ADD CONSTRAINT timeclock_punches_source_check CHECK (source IN ('self', 'manual', 'self_manual'));

-- Solicitações de ajuste de horário de uma batida existente
CREATE TABLE IF NOT EXISTS public.timeclock_adjustment_requests (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    punch_id uuid NOT NULL REFERENCES public.timeclock_punches(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    previous_punched_at timestamptz NOT NULL,
    requested_punched_at timestamptz NOT NULL,
    reason text NOT NULL,
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reviewed_by uuid,
    reviewed_at timestamptz,
    review_note text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tc_adj_company_status ON public.timeclock_adjustment_requests(company_id, status);
CREATE INDEX IF NOT EXISTS idx_tc_adj_punch ON public.timeclock_adjustment_requests(punch_id);
