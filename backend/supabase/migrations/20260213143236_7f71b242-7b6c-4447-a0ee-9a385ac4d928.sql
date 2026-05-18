CREATE POLICY "Admins can delete comparisons"
ON public.profile_comparisons
FOR DELETE
USING (
  is_master_admin()
  OR EXISTS (
    SELECT 1 FROM profiles p
    WHERE p.user_id IN (profile_comparisons.user1_id, profile_comparisons.user2_id)
    AND is_company_admin(p.company_id)
  )
);