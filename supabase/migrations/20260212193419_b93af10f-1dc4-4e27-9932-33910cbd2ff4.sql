
-- Create app_role enum
CREATE TYPE public.app_role AS ENUM ('master_admin', 'company_admin', 'leader', 'user');

-- Companies table
CREATE TABLE public.companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

-- Departments table
CREATE TABLE public.departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

-- Profiles table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  cpf TEXT UNIQUE,
  company_id UUID REFERENCES public.companies(id) ON DELETE SET NULL,
  department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- User roles table (separate from profiles per security requirements)
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role app_role NOT NULL DEFAULT 'user',
  company_id UUID REFERENCES public.companies(id) ON DELETE CASCADE,
  UNIQUE (user_id, role)
);
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Helper function: has_role (SECURITY DEFINER to avoid RLS recursion)
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- Helper function: is_master_admin
CREATE OR REPLACE FUNCTION public.is_master_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.has_role(auth.uid(), 'master_admin')
$$;

-- Helper function: is_company_admin for a specific company
CREATE OR REPLACE FUNCTION public.is_company_admin(_company_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid()
      AND role = 'company_admin'
      AND company_id = _company_id
  )
$$;

-- Helper function: is_member of a company
CREATE OR REPLACE FUNCTION public.is_member(_company_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE user_id = auth.uid()
      AND company_id = _company_id
  )
$$;

-- Helper function: get user company_id
CREATE OR REPLACE FUNCTION public.get_user_company_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT company_id FROM public.profiles WHERE user_id = auth.uid() LIMIT 1
$$;

-- RLS Policies for companies
CREATE POLICY "Members can view their company"
  ON public.companies FOR SELECT TO authenticated
  USING (public.is_master_admin() OR public.is_member(id));

CREATE POLICY "Master admins can insert companies"
  ON public.companies FOR INSERT TO authenticated
  WITH CHECK (public.is_master_admin());

CREATE POLICY "Master admins can update companies"
  ON public.companies FOR UPDATE TO authenticated
  USING (public.is_master_admin());

CREATE POLICY "Master admins can delete companies"
  ON public.companies FOR DELETE TO authenticated
  USING (public.is_master_admin());

-- RLS Policies for departments
CREATE POLICY "Members can view departments"
  ON public.departments FOR SELECT TO authenticated
  USING (public.is_master_admin() OR public.is_member(company_id));

CREATE POLICY "Company admins can insert departments"
  ON public.departments FOR INSERT TO authenticated
  WITH CHECK (public.is_master_admin() OR public.is_company_admin(company_id));

CREATE POLICY "Company admins can update departments"
  ON public.departments FOR UPDATE TO authenticated
  USING (public.is_master_admin() OR public.is_company_admin(company_id));

CREATE POLICY "Company admins can delete departments"
  ON public.departments FOR DELETE TO authenticated
  USING (public.is_master_admin() OR public.is_company_admin(company_id));

-- RLS Policies for profiles
CREATE POLICY "Users can view own profile or company members"
  ON public.profiles FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR public.is_master_admin() OR public.is_member(company_id));

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_master_admin() OR public.is_company_admin(company_id));

CREATE POLICY "Master admins can delete profiles"
  ON public.profiles FOR DELETE TO authenticated
  USING (public.is_master_admin());

-- RLS Policies for user_roles
CREATE POLICY "Users can view own roles or master admin"
  ON public.user_roles FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR public.is_master_admin() OR public.is_company_admin(company_id));

CREATE POLICY "Admins can insert roles"
  ON public.user_roles FOR INSERT TO authenticated
  WITH CHECK (public.is_master_admin() OR (public.is_company_admin(company_id) AND role != 'master_admin'));

CREATE POLICY "Admins can update roles"
  ON public.user_roles FOR UPDATE TO authenticated
  USING (public.is_master_admin() OR (public.is_company_admin(company_id) AND role != 'master_admin'));

CREATE POLICY "Master admins can delete roles"
  ON public.user_roles FOR DELETE TO authenticated
  USING (public.is_master_admin());

-- Trigger to auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.email)
  );
  -- Default role
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'user');
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
