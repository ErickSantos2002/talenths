
-- Table: test_invitations
CREATE TABLE public.test_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id),
  department_id uuid REFERENCES public.departments(id),
  invited_by uuid NOT NULL,
  token text NOT NULL UNIQUE DEFAULT gen_random_uuid()::text,
  expires_at timestamptz,
  max_uses int,
  used_count int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.test_invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage invitations"
  ON public.test_invitations FOR ALL
  USING (is_master_admin() OR is_company_admin(company_id));

CREATE POLICY "Leaders can create invitations"
  ON public.test_invitations FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE user_id = auth.uid() AND company_id = test_invitations.company_id
    )
    AND public.has_role(auth.uid(), 'leader')
  );

CREATE POLICY "Leaders can view own invitations"
  ON public.test_invitations FOR SELECT
  USING (invited_by = auth.uid() OR is_master_admin() OR is_company_admin(company_id));

-- Anyone can read invitations by token (for the public invite page)
CREATE POLICY "Anyone can read invitation by token"
  ON public.test_invitations FOR SELECT
  USING (true);

-- Table: user_managers
CREATE TABLE public.user_managers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  manager_id uuid NOT NULL,
  is_primary boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, manager_id)
);

ALTER TABLE public.user_managers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage user_managers"
  ON public.user_managers FOR ALL
  USING (is_master_admin() OR is_company_admin(
    (SELECT company_id FROM public.profiles WHERE profiles.user_id = user_managers.user_id LIMIT 1)
  ));

CREATE POLICY "Leaders can view subordinates"
  ON public.user_managers FOR SELECT
  USING (manager_id = auth.uid());

CREATE POLICY "Users can view own manager"
  ON public.user_managers FOR SELECT
  USING (user_id = auth.uid());
