-- Remove legacy test/AI tables
-- These tables belonged to the old fixed DISC/OCEAN test system and AI chat,
-- which are being replaced by a flexible multi-test module.

DROP TABLE IF EXISTS public.test_responses CASCADE;
DROP TABLE IF EXISTS public.test_results CASCADE;
DROP TABLE IF EXISTS public.scenario_blocks CASCADE;
DROP TABLE IF EXISTS public.profile_comparisons CASCADE;
DROP TABLE IF EXISTS public.hr_messages CASCADE;
DROP TABLE IF EXISTS public.hr_conversations CASCADE;
DROP TABLE IF EXISTS public.test_invitations CASCADE;
