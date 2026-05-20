ALTER TABLE public.companies
  ADD COLUMN IF NOT EXISTS presentation_mission  TEXT,
  ADD COLUMN IF NOT EXISTS presentation_vision   TEXT,
  ADD COLUMN IF NOT EXISTS presentation_history  TEXT,
  ADD COLUMN IF NOT EXISTS presentation_values   JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS presentation_cover_url TEXT;
