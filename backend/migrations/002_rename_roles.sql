-- Migration 002: Renomear papéis para modelo single-tenant
-- company_admin → manager, remover leader
-- Novo modelo: master_admin | manager | user

-- ─── Passo 1: adicionar 'manager' ao enum (roda fora de transação) ───────────
-- (executado separadamente pelo runner antes desta linha)

-- ─── Passo 2: migrar dados ANTES de alterar o tipo ───────────────────────────
UPDATE public.user_roles SET role = 'manager' WHERE role = 'company_admin';
DELETE FROM public.user_roles WHERE role = 'leader';

-- ─── Passo 3: dropar TODAS as policies que dependem da coluna role ────────────
DROP POLICY IF EXISTS "Users can view own roles or master admin"     ON public.user_roles;
DROP POLICY IF EXISTS "Admins can insert roles"                      ON public.user_roles;
DROP POLICY IF EXISTS "Admins can update roles"                      ON public.user_roles;
DROP POLICY IF EXISTS "Master admins can delete roles"               ON public.user_roles;

-- Dropar policies de outras tabelas que usam funções helper (CASCADE vai cuidar)
DROP POLICY IF EXISTS "Company admins can insert departments"        ON public.departments;
DROP POLICY IF EXISTS "Company admins can update departments"        ON public.departments;
DROP POLICY IF EXISTS "Company admins can delete departments"        ON public.departments;
DROP POLICY IF EXISTS "Users can update own profile"                 ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all company results"          ON public.test_results;
DROP POLICY IF EXISTS "Leaders can view subordinate results"         ON public.test_results;
DROP POLICY IF EXISTS "Admins can view comparisons"                  ON public.profile_comparisons;
DROP POLICY IF EXISTS "Admins can create comparisons"                ON public.profile_comparisons;
DROP POLICY IF EXISTS "Admins can manage invitations"                ON public.test_invitations;
DROP POLICY IF EXISTS "Leaders can create invitations"               ON public.test_invitations;
DROP POLICY IF EXISTS "Leaders can view own invitations"             ON public.test_invitations;
DROP POLICY IF EXISTS "Admins can manage user_managers"              ON public.user_managers;

-- ─── Passo 4: alterar coluna para text (sem dependências de policy) ──────────
ALTER TABLE public.user_roles ALTER COLUMN role TYPE text;

-- ─── Passo 5: dropar funções e tipo antigo ───────────────────────────────────
DROP FUNCTION IF EXISTS public.has_role(UUID, public.app_role) CASCADE;
DROP FUNCTION IF EXISTS public.is_company_admin(UUID) CASCADE;
DROP FUNCTION IF EXISTS public.is_master_admin() CASCADE;
DROP TYPE IF EXISTS public.app_role CASCADE;

-- ─── Passo 6: criar novo enum limpo ─────────────────────────────────────────
CREATE TYPE public.app_role AS ENUM ('master_admin', 'manager', 'user');

-- ─── Passo 7: restaurar coluna com novo tipo ─────────────────────────────────
ALTER TABLE public.user_roles
  ALTER COLUMN role TYPE public.app_role USING role::public.app_role,
  ALTER COLUMN role SET DEFAULT 'user';

-- ─── Passo 8: recriar funções helper ─────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.is_master_admin()
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid() AND role = 'master_admin'
  )
$$;

CREATE OR REPLACE FUNCTION public.is_manager(_company_id UUID DEFAULT NULL)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid()
      AND role = 'manager'
      AND (_company_id IS NULL OR company_id = _company_id)
  )
$$;

CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role public.app_role)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- ─── Passo 9: recriar todas as policies ─────────────────────────────────────

-- departments
CREATE POLICY "Managers can insert departments"
  ON public.departments FOR INSERT TO authenticated
  WITH CHECK (public.is_master_admin() OR public.is_manager(company_id));

CREATE POLICY "Managers can update departments"
  ON public.departments FOR UPDATE TO authenticated
  USING (public.is_master_admin() OR public.is_manager(company_id));

CREATE POLICY "Managers can delete departments"
  ON public.departments FOR DELETE TO authenticated
  USING (public.is_master_admin() OR public.is_manager(company_id));

-- profiles
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_master_admin() OR public.is_manager(company_id));

-- user_roles
CREATE POLICY "Users can view own roles or master admin"
  ON public.user_roles FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR public.is_master_admin() OR public.is_manager(company_id));

CREATE POLICY "Admins can insert roles"
  ON public.user_roles FOR INSERT TO authenticated
  WITH CHECK (public.is_master_admin() OR (public.is_manager(company_id) AND role != 'master_admin'));

CREATE POLICY "Admins can update roles"
  ON public.user_roles FOR UPDATE TO authenticated
  USING (public.is_master_admin() OR (public.is_manager(company_id) AND role != 'master_admin'));

CREATE POLICY "Master admins can delete roles"
  ON public.user_roles FOR DELETE TO authenticated
  USING (public.is_master_admin());

-- test_results
CREATE POLICY "Admins can view all company results"
  ON public.test_results FOR SELECT TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.user_id = test_results.user_id
        AND (public.is_master_admin() OR public.is_manager(p.company_id))
    )
  );

-- profile_comparisons
CREATE POLICY "Admins can view comparisons"
  ON public.profile_comparisons FOR SELECT TO authenticated
  USING (
    user1_id = auth.uid() OR user2_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.profiles p1
      WHERE p1.user_id = profile_comparisons.user1_id
        AND p1.company_id IS NOT NULL
        AND public.is_manager(p1.company_id)
    )
  );

CREATE POLICY "Admins can create comparisons"
  ON public.profile_comparisons FOR INSERT TO authenticated
  WITH CHECK (
    user1_id = auth.uid() OR user2_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.profiles p1
      WHERE p1.user_id = profile_comparisons.user1_id
        AND p1.company_id IS NOT NULL
        AND public.is_manager(p1.company_id)
    )
  );

-- test_invitations
CREATE POLICY "Admins can manage invitations"
  ON public.test_invitations FOR ALL
  USING (public.is_master_admin() OR public.is_manager(company_id));

CREATE POLICY "Managers can view own invitations"
  ON public.test_invitations FOR SELECT
  USING (invited_by = auth.uid() OR public.is_master_admin() OR public.is_manager(company_id));

-- user_managers
CREATE POLICY "Admins can manage user_managers"
  ON public.user_managers FOR ALL
  USING (public.is_master_admin() OR public.is_manager(
    (SELECT company_id FROM public.profiles WHERE profiles.user_id = user_managers.user_id LIMIT 1)
  ));
