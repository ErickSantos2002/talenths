-- O colaborador passa a editar o próprio pedido pendente; o RH vê que ele mudou desde a criação.
ALTER TABLE public.absence_requests ADD COLUMN IF NOT EXISTS updated_at timestamptz;
