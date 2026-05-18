-- Allow master admins to delete test results
CREATE POLICY "Master admins can delete test results"
  ON public.test_results
  FOR DELETE
  TO authenticated
  USING (is_master_admin());

-- Allow master admins to delete test responses
CREATE POLICY "Master admins can delete all responses"
  ON public.test_responses
  FOR DELETE
  TO authenticated
  USING (is_master_admin());
