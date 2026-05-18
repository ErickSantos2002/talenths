
-- Add new columns to test_results
ALTER TABLE public.test_results
  ADD COLUMN IF NOT EXISTS iem INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS share_token TEXT UNIQUE DEFAULT gen_random_uuid()::text,
  ADD COLUMN IF NOT EXISTS ai_analysis JSONB DEFAULT '{}';

-- Allow public read of shared results via share_token
CREATE POLICY "Anyone can read shared results by token"
  ON public.test_results FOR SELECT
  USING (share_token IS NOT NULL);
