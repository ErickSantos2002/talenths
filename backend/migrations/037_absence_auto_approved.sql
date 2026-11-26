-- Pedido de ausência de tipo sem aprovação entrava como 'approved' sem registro de
-- quando nem de como foi decidido; o RH não distinguia da aprovação de um gestor.
ALTER TABLE public.absence_requests
    ADD COLUMN IF NOT EXISTS auto_approved boolean NOT NULL DEFAULT false;

-- Só o caminho automático grava 'approved' sem reviewed_by (reviewed_by não tem FK).
UPDATE public.absence_requests
   SET auto_approved = true, reviewed_at = created_at
 WHERE status = 'approved' AND reviewed_by IS NULL;
