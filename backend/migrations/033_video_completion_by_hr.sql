-- 033_video_completion_by_hr.sql — RH registra que a pessoa já viu o vídeo antes do sistema
-- Registrado pelo RH = completed_by preenchido. Quem assistiu pelo sistema fica com ele nulo.
ALTER TABLE public.internal_video_viewers
  ADD COLUMN IF NOT EXISTS completed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS completed_registered_at timestamptz;

ALTER TABLE public.internal_video_viewers
  DROP CONSTRAINT IF EXISTS internal_video_viewers_registered_completed;
ALTER TABLE public.internal_video_viewers
  ADD CONSTRAINT internal_video_viewers_registered_completed
  CHECK (completed_by IS NULL OR completed_at IS NOT NULL);
