
CREATE POLICY "Leaders can view subordinate results"
  ON public.test_results
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_managers um
      WHERE um.manager_id = auth.uid()
        AND um.user_id = test_results.user_id
    )
    OR
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.user_id = test_results.user_id
        AND p.department_id = (
          SELECT pp.department_id FROM public.profiles pp WHERE pp.user_id = auth.uid() LIMIT 1
        )
        AND p.department_id IS NOT NULL
        AND public.has_role(auth.uid(), 'leader')
    )
  );
