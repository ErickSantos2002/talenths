CREATE POLICY "Users can view own comparisons"
  ON public.profile_comparisons
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user1_id OR auth.uid() = user2_id);