-- Fase: Guardi (assistente do HS.OS) lendo o TalentHS como o dono
-- Requisição feita por token de agente grava o bot que a fez; login normal fica NULL.

ALTER TABLE public.audit_logs ADD COLUMN IF NOT EXISTS via text;
