
-- Create profile_comparisons table
CREATE TABLE public.profile_comparisons (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user1_id UUID NOT NULL,
  user2_id UUID NOT NULL,
  compatibility_score INTEGER,
  ai_analysis JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.profile_comparisons ENABLE ROW LEVEL SECURITY;

-- Master admins can do everything
CREATE POLICY "Master admins can read all comparisons"
ON public.profile_comparisons FOR SELECT
USING (public.is_master_admin());

CREATE POLICY "Master admins can insert comparisons"
ON public.profile_comparisons FOR INSERT
WITH CHECK (public.is_master_admin());

-- Company admins can read/insert comparisons for users in their company
CREATE POLICY "Company admins can read company comparisons"
ON public.profile_comparisons FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.profiles p1, public.profiles p2
    WHERE p1.user_id = profile_comparisons.user1_id
      AND p2.user_id = profile_comparisons.user2_id
      AND p1.company_id IS NOT NULL
      AND p1.company_id = p2.company_id
      AND public.is_company_admin(p1.company_id)
  )
);

CREATE POLICY "Company admins can insert company comparisons"
ON public.profile_comparisons FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles p1, public.profiles p2
    WHERE p1.user_id = profile_comparisons.user1_id
      AND p2.user_id = profile_comparisons.user2_id
      AND p1.company_id IS NOT NULL
      AND p1.company_id = p2.company_id
      AND public.is_company_admin(p1.company_id)
  )
);
