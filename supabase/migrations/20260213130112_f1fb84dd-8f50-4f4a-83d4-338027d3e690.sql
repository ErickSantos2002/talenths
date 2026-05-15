CREATE POLICY "Master admins can read all responses"
  ON public.test_responses
  FOR SELECT
  TO authenticated
  USING (is_master_admin());