-- =============================================================================
-- TalentHS — Schema inicial para PostgreSQL puro
-- Adaptado das migrations do Supabase original
-- =============================================================================

-- ─── 0. AUTH SCHEMA (substitui o Supabase Auth) ──────────────────────────────

CREATE SCHEMA IF NOT EXISTS auth;

-- Tabela de usuários (equivalente ao auth.users do Supabase)
CREATE TABLE IF NOT EXISTS auth.users (
  id                   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  email                TEXT        UNIQUE NOT NULL,
  encrypted_password   TEXT,
  email_confirmed_at   TIMESTAMPTZ,
  raw_user_meta_data   JSONB       NOT NULL DEFAULT '{}',
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- auth.uid() lê a variável de sessão definida pelo backend em cada request
-- O backend deve executar: SET LOCAL app.current_user_id = '<uuid>';
CREATE OR REPLACE FUNCTION auth.uid()
RETURNS uuid
LANGUAGE sql STABLE
AS $$
  SELECT nullif(current_setting('app.current_user_id', true), '')::uuid;
$$;

-- Role 'authenticated' usada nas políticas RLS (equivalente ao Supabase)
DO $$ BEGIN
  CREATE ROLE authenticated;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

GRANT USAGE ON SCHEMA public TO authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES    TO authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;

-- ─── 1. MIGRATION: tipos e tabelas base ───────────────────────────────────────

CREATE TYPE public.app_role AS ENUM ('master_admin', 'company_admin', 'leader', 'user');

CREATE TABLE public.companies (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT        NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.departments (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID        NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name       TEXT        NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.profiles (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID        NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email         TEXT        NOT NULL,
  name          TEXT        NOT NULL,
  cpf           TEXT        UNIQUE,
  company_id    UUID        REFERENCES public.companies(id) ON DELETE SET NULL,
  department_id UUID        REFERENCES public.departments(id) ON DELETE SET NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.user_roles (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role       app_role    NOT NULL DEFAULT 'user',
  company_id UUID        REFERENCES public.companies(id) ON DELETE CASCADE,
  UNIQUE (user_id, role)
);
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Funções helper (SECURITY DEFINER para evitar recursão RLS)
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

CREATE OR REPLACE FUNCTION public.is_master_admin()
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT public.has_role(auth.uid(), 'master_admin')
$$;

CREATE OR REPLACE FUNCTION public.is_company_admin(_company_id UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid()
      AND role = 'company_admin'
      AND company_id = _company_id
  )
$$;

CREATE OR REPLACE FUNCTION public.is_member(_company_id UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE user_id = auth.uid()
      AND company_id = _company_id
  )
$$;

CREATE OR REPLACE FUNCTION public.get_user_company_id()
RETURNS UUID LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT company_id FROM public.profiles WHERE user_id = auth.uid() LIMIT 1
$$;

-- Políticas RLS — companies
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

-- Políticas RLS — departments
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

-- Políticas RLS — profiles
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

-- Políticas RLS — user_roles
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

-- Trigger: cria perfil automaticamente ao inserir em auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.email)
  );
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'user');
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── 2. MIGRATION: scenario_blocks, test_responses, test_results ──────────────

CREATE TABLE public.scenario_blocks (
  id              UUID    NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  block_number    INTEGER NOT NULL UNIQUE,
  scenario        TEXT    NOT NULL,
  option_a        TEXT    NOT NULL,
  option_b        TEXT    NOT NULL,
  option_c        TEXT    NOT NULL,
  option_d        TEXT    NOT NULL,
  weights_a       JSONB   NOT NULL DEFAULT '{}',
  weights_b       JSONB   NOT NULL DEFAULT '{}',
  weights_c       JSONB   NOT NULL DEFAULT '{}',
  weights_d       JSONB   NOT NULL DEFAULT '{}',
  ocean_weights_a JSONB   NOT NULL DEFAULT '{}',
  ocean_weights_b JSONB   NOT NULL DEFAULT '{}',
  ocean_weights_c JSONB   NOT NULL DEFAULT '{}',
  ocean_weights_d JSONB   NOT NULL DEFAULT '{}'
);
ALTER TABLE public.scenario_blocks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read scenario blocks"
  ON public.scenario_blocks FOR SELECT USING (true);

CREATE TABLE public.test_responses (
  id           UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      UUID                     NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  block_number INTEGER                  NOT NULL,
  most_option  TEXT                     NOT NULL,
  least_option TEXT                     NOT NULL,
  created_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, block_number)
);
ALTER TABLE public.test_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own responses"
  ON public.test_responses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own responses"
  ON public.test_responses FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own responses"
  ON public.test_responses FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own responses"
  ON public.test_responses FOR DELETE USING (auth.uid() = user_id);

CREATE TABLE public.test_results (
  id           UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      UUID                     NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  disc_natural JSONB                    NOT NULL DEFAULT '{}',
  disc_adapted JSONB                    NOT NULL DEFAULT '{}',
  big_five     JSONB                    NOT NULL DEFAULT '{}',
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.test_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own results"
  ON public.test_results FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own results"
  ON public.test_results FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Company admins can read company results"
  ON public.test_results FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.user_id = test_results.user_id
        AND (public.is_master_admin() OR public.is_company_admin(p.company_id))
    )
  );

-- Seed: 12 cenários do teste
INSERT INTO public.scenario_blocks (block_number, scenario, option_a, option_b, option_c, option_d, weights_a, weights_b, weights_c, weights_d, ocean_weights_a, ocean_weights_b, ocean_weights_c, ocean_weights_d) VALUES
(1,'Você está em uma reunião de equipe e surge um problema urgente que precisa ser resolvido imediatamente. Como você reage?','Assumo a liderança e proponho uma solução imediata','Converso com todos para entender diferentes perspectivas antes de agir','Analiso calmamente os dados disponíveis antes de sugerir algo','Verifico os procedimentos estabelecidos para esse tipo de situação','{"D":3,"I":1,"S":0,"C":0}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":0,"C":3}','{"O":2,"C":1,"E":2,"A":0,"N":0}','{"O":2,"C":0,"E":3,"A":2,"N":0}','{"O":1,"C":3,"E":0,"A":1,"N":0}','{"O":0,"C":3,"E":0,"A":0,"N":1}'),
(2,'Você recebe um feedback negativo sobre um projeto que você liderou. Como você reage?','Defendo meu ponto de vista com argumentos sólidos','Agradeço o feedback e peço mais detalhes para entender melhor','Reflito internamente sobre o feedback antes de responder','Analiso os dados do projeto para entender o que deu errado','{"D":3,"I":0,"S":0,"C":1}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":0,"C":3}','{"O":1,"C":0,"E":2,"A":0,"N":2}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":2,"C":2,"E":0,"A":2,"N":1}','{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(3,'Você recebe um novo projeto desafiador com prazo curto. Como você reage?','Aceito o desafio com entusiasmo e começo imediatamente','Mobilizo a equipe para dividir as tarefas e trabalharmos juntos','Planejo as etapas com calma para garantir qualidade','Estudo os requisitos detalhadamente antes de começar','{"D":3,"I":1,"S":0,"C":0}','{"D":1,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":1,"C":3}','{"O":3,"C":1,"E":2,"A":0,"N":0}','{"O":2,"C":1,"E":3,"A":2,"N":0}','{"O":1,"C":3,"E":0,"A":1,"N":1}','{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(4,'Dois colegas da equipe discordam sobre a melhor abordagem para um problema. Como você age?','Tomo a decisão final baseado na minha experiência','Facilito uma conversa para que cheguem a um consenso','Espero os ânimos acalmarem antes de intervir','Analiso os prós e contras de cada abordagem objetivamente','{"D":3,"I":0,"S":0,"C":1}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":1,"S":3,"C":0}','{"D":0,"I":0,"S":0,"C":3}','{"O":1,"C":2,"E":2,"A":0,"N":0}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":1,"C":1,"E":0,"A":3,"N":1}','{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(5,'A empresa muda um processo que você dominava completamente. Como você reage?','Proponho melhorias no novo processo baseado na minha experiência','Ajudo os colegas a se adaptarem ao novo processo','Me adapto gradualmente, mantendo meu ritmo de trabalho','Estudo o novo processo a fundo antes de implementá-lo','{"D":3,"I":1,"S":0,"C":0}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":0,"C":3}','{"O":3,"C":1,"E":2,"A":0,"N":1}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":0,"C":2,"E":0,"A":2,"N":1}','{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(6,'Você precisa apresentar um projeto importante para a diretoria. Como você se prepara?','Foco nos resultados e impacto, apresento com confiança e assertividade','Preparo uma apresentação envolvente com histórias e exemplos práticos','Organizo os dados de forma clara e estruturada, apresento com calma','Reviso todos os detalhes técnicos e me preparo para perguntas difíceis','{"D":3,"I":1,"S":0,"C":0}','{"D":1,"I":3,"S":0,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":0,"C":3}','{"O":2,"C":2,"E":3,"A":0,"N":0}','{"O":3,"C":1,"E":3,"A":1,"N":0}','{"O":1,"C":3,"E":0,"A":1,"N":1}','{"O":1,"C":3,"E":0,"A":0,"N":1}'),
(7,'O prazo de um projeto foi antecipado inesperadamente. Como você reage?','Reorganizo as prioridades rapidamente e foco no essencial','Converso com os stakeholders para negociar o escopo','Mantenho meu ritmo de trabalho para garantir qualidade','Reviso o escopo detalhadamente para garantir que nada seja esquecido','{"D":3,"I":0,"S":0,"C":1}','{"D":1,"I":3,"S":0,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":1,"C":3}','{"O":2,"C":2,"E":2,"A":0,"N":1}','{"O":2,"C":1,"E":3,"A":2,"N":0}','{"O":0,"C":3,"E":0,"A":1,"N":2}','{"O":1,"C":3,"E":0,"A":0,"N":1}'),
(8,'Sua proposta de melhoria foi rejeitada pela liderança. Como você reage?','Insisto com novos argumentos e dados que comprovem meu ponto','Busco aliados que possam apoiar minha proposta','Aceito a decisão e sigo em frente sem ressentimentos','Analiso os motivos da rejeição para entender o que faltou','{"D":3,"I":0,"S":0,"C":1}','{"D":1,"I":3,"S":0,"C":0}','{"D":0,"I":1,"S":3,"C":0}','{"D":0,"I":0,"S":1,"C":3}','{"O":2,"C":1,"E":2,"A":0,"N":1}','{"O":2,"C":1,"E":3,"A":1,"N":0}','{"O":0,"C":1,"E":0,"A":3,"N":0}','{"O":2,"C":3,"E":0,"A":1,"N":0}'),
(9,'Um novo membro entra na equipe. Como você age?','Delego tarefas imediatamente para integrá-lo ao trabalho','Apresento a pessoa para todos e organizo um almoço de boas-vindas','Dou tempo para a pessoa se adaptar antes de cobrar resultados','Explico detalhadamente os processos e padrões da equipe','{"D":3,"I":1,"S":0,"C":0}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":1,"S":3,"C":0}','{"D":0,"I":0,"S":0,"C":3}','{"O":1,"C":2,"E":2,"A":0,"N":0}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":1,"C":1,"E":0,"A":3,"N":0}','{"O":1,"C":3,"E":0,"A":1,"N":0}'),
(10,'Você identifica um erro crítico em um projeto quase finalizado. Como você age?','Comunico imediatamente e proponho uma solução rápida','Reúno a equipe para discutir a melhor forma de corrigir','Corrijo o erro com calma para não comprometer a qualidade','Analiso o impacto do erro antes de decidir como proceder','{"D":3,"I":1,"S":0,"C":0}','{"D":1,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":1,"C":3}','{"O":1,"C":2,"E":2,"A":0,"N":1}','{"O":2,"C":1,"E":3,"A":2,"N":0}','{"O":1,"C":3,"E":0,"A":1,"N":1}','{"O":2,"C":3,"E":0,"A":0,"N":0}'),
(11,'Você precisa escolher entre dois projetos igualmente importantes. Como decide?','Escolho o que traz maior impacto e resultados mais rápidos','Consulto a equipe para entender qual é a prioridade coletiva','Analiso calmamente os prós e contras de cada um','Avalio objetivamente os critérios técnicos e recursos disponíveis','{"D":3,"I":0,"S":0,"C":1}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":0,"S":3,"C":1}','{"D":0,"I":0,"S":0,"C":3}','{"O":2,"C":2,"E":2,"A":0,"N":0}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":1,"C":3,"E":0,"A":2,"N":1}','{"O":1,"C":3,"E":0,"A":0,"N":0}'),
(12,'A equipe está desmotivada após um resultado ruim. Como você age?','Reforço as metas e cobro mais foco e disciplina','Organizo uma atividade para elevar o ânimo da equipe','Dou espaço para que todos processem o resultado no seu tempo','Analiso o que deu errado e apresento um plano de ação detalhado','{"D":3,"I":0,"S":0,"C":1}','{"D":0,"I":3,"S":1,"C":0}','{"D":0,"I":1,"S":3,"C":0}','{"D":1,"I":0,"S":0,"C":3}','{"O":1,"C":3,"E":2,"A":0,"N":0}','{"O":2,"C":1,"E":3,"A":3,"N":0}','{"O":1,"C":1,"E":0,"A":3,"N":1}','{"O":1,"C":3,"E":0,"A":1,"N":0}');

-- ─── 3. MIGRATION: colunas adicionais em test_results ────────────────────────

ALTER TABLE public.test_results
  ADD COLUMN IF NOT EXISTS iem         INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS share_token TEXT    UNIQUE DEFAULT gen_random_uuid()::text,
  ADD COLUMN IF NOT EXISTS ai_analysis JSONB   DEFAULT '{}';

CREATE POLICY "Anyone can read shared results by token"
  ON public.test_results FOR SELECT
  USING (share_token IS NOT NULL);

-- ─── 4. MIGRATION: profile_comparisons ───────────────────────────────────────

CREATE TABLE public.profile_comparisons (
  id                  UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user1_id            UUID                     NOT NULL,
  user2_id            UUID                     NOT NULL,
  compatibility_score INTEGER,
  ai_analysis         JSONB                    DEFAULT '{}'::jsonb,
  created_at          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.profile_comparisons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Master admins can read all comparisons"
  ON public.profile_comparisons FOR SELECT USING (public.is_master_admin());
CREATE POLICY "Master admins can insert comparisons"
  ON public.profile_comparisons FOR INSERT WITH CHECK (public.is_master_admin());
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

-- ─── 5. MIGRATION: hr_conversations e hr_messages ────────────────────────────

CREATE TABLE public.hr_conversations (
  id         UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID                     NOT NULL,
  title      TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.hr_conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own conversations"
  ON public.hr_conversations FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own conversations"
  ON public.hr_conversations FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own conversations"
  ON public.hr_conversations FOR DELETE USING (auth.uid() = user_id);

CREATE TABLE public.hr_messages (
  id              UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID                     NOT NULL REFERENCES public.hr_conversations(id) ON DELETE CASCADE,
  role            TEXT                     NOT NULL,
  content         TEXT                     NOT NULL,
  created_at      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.hr_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own messages"
  ON public.hr_messages FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.hr_conversations WHERE id = hr_messages.conversation_id AND user_id = auth.uid()));
CREATE POLICY "Users can insert own messages"
  ON public.hr_messages FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.hr_conversations WHERE id = hr_messages.conversation_id AND user_id = auth.uid()));
CREATE POLICY "Users can delete own messages"
  ON public.hr_messages FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.hr_conversations WHERE id = hr_messages.conversation_id AND user_id = auth.uid()));

-- ─── 6. MIGRATION: notifications ─────────────────────────────────────────────

CREATE TABLE public.notifications (
  id         UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID                     NOT NULL,
  type       TEXT                     NOT NULL,
  title      TEXT                     NOT NULL,
  message    TEXT,
  read       BOOLEAN                  NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own notifications"
  ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications"
  ON public.notifications FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own notifications"
  ON public.notifications FOR DELETE USING (auth.uid() = user_id);

-- ─── 7. MIGRATION: colunas extras em companies e profiles ────────────────────

ALTER TABLE public.companies ADD COLUMN cnpj   TEXT;
ALTER TABLE public.companies ADD COLUMN status  TEXT NOT NULL DEFAULT 'active';
ALTER TABLE public.companies ADD CONSTRAINT companies_cnpj_unique UNIQUE (cnpj);
ALTER TABLE public.profiles  ADD COLUMN IF NOT EXISTS phone TEXT;

-- ─── 8. MIGRATION: test_invitations e user_managers ──────────────────────────

CREATE TABLE public.test_invitations (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id    UUID        NOT NULL REFERENCES public.companies(id),
  department_id UUID        REFERENCES public.departments(id),
  invited_by    UUID        NOT NULL,
  token         TEXT        NOT NULL UNIQUE DEFAULT gen_random_uuid()::text,
  expires_at    TIMESTAMPTZ,
  max_uses      INT,
  used_count    INT         DEFAULT 0,
  is_active     BOOLEAN     DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE public.test_invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage invitations"
  ON public.test_invitations FOR ALL
  USING (is_master_admin() OR is_company_admin(company_id));
CREATE POLICY "Leaders can create invitations"
  ON public.test_invitations FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE user_id = auth.uid() AND company_id = test_invitations.company_id)
    AND public.has_role(auth.uid(), 'leader')
  );
CREATE POLICY "Leaders can view own invitations"
  ON public.test_invitations FOR SELECT
  USING (invited_by = auth.uid() OR is_master_admin() OR is_company_admin(company_id));
CREATE POLICY "Anyone can read invitation by token"
  ON public.test_invitations FOR SELECT USING (true);

CREATE TABLE public.user_managers (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID        NOT NULL,
  manager_id UUID        NOT NULL,
  is_primary BOOLEAN     DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, manager_id)
);
ALTER TABLE public.user_managers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage user_managers"
  ON public.user_managers FOR ALL
  USING (is_master_admin() OR is_company_admin(
    (SELECT company_id FROM public.profiles WHERE profiles.user_id = user_managers.user_id LIMIT 1)
  ));
CREATE POLICY "Leaders can view subordinates"
  ON public.user_managers FOR SELECT USING (manager_id = auth.uid());
CREATE POLICY "Users can view own manager"
  ON public.user_managers FOR SELECT USING (user_id = auth.uid());

-- ─── 9. MIGRATION: comparison_type, políticas extras ─────────────────────────

ALTER TABLE public.profile_comparisons
  ADD COLUMN comparison_type TEXT NOT NULL DEFAULT 'peer_to_peer';

CREATE POLICY "Users can view own comparisons"
  ON public.profile_comparisons FOR SELECT TO authenticated
  USING (auth.uid() = user1_id OR auth.uid() = user2_id);

CREATE POLICY "Leaders can view subordinate results"
  ON public.test_results FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_managers um
      WHERE um.manager_id = auth.uid() AND um.user_id = test_results.user_id
    )
    OR EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.user_id = test_results.user_id
        AND p.department_id = (SELECT pp.department_id FROM public.profiles pp WHERE pp.user_id = auth.uid() LIMIT 1)
        AND p.department_id IS NOT NULL
        AND public.has_role(auth.uid(), 'leader')
    )
  );

CREATE POLICY "Master admins can read all responses"
  ON public.test_responses FOR SELECT TO authenticated USING (is_master_admin());

CREATE POLICY "Master admins can delete test results"
  ON public.test_results FOR DELETE TO authenticated USING (is_master_admin());
CREATE POLICY "Master admins can delete all responses"
  ON public.test_responses FOR DELETE TO authenticated USING (is_master_admin());

-- ─── 10. MIGRATION: claim_invitation (atômica, evita race condition) ─────────

CREATE OR REPLACE FUNCTION public.claim_invitation(token_param TEXT)
RETURNS SETOF test_invitations LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
BEGIN
  RETURN QUERY
  UPDATE test_invitations
  SET used_count = COALESCE(used_count, 0) + 1
  WHERE token = token_param
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > now())
    AND (max_uses IS NULL OR COALESCE(used_count, 0) < max_uses)
  RETURNING *;
END;
$$;

-- ─── 11. MIGRATION: políticas extras de comparisons e delete_company_cascade ──

CREATE POLICY "Admins can delete comparisons"
  ON public.profile_comparisons FOR DELETE
  USING (
    is_master_admin()
    OR EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.user_id IN (profile_comparisons.user1_id, profile_comparisons.user2_id)
        AND is_company_admin(p.company_id)
    )
  );

ALTER TABLE public.test_invitations ADD COLUMN description TEXT;

CREATE OR REPLACE FUNCTION public.delete_company_cascade(_company_id UUID)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  _user_ids uuid[];
BEGIN
  IF NOT is_master_admin() THEN
    RAISE EXCEPTION 'Permission denied: only master admins can delete companies';
  END IF;

  SELECT array_agg(user_id) INTO _user_ids
  FROM profiles WHERE company_id = _company_id;

  IF _user_ids IS NOT NULL AND array_length(_user_ids, 1) > 0 THEN
    DELETE FROM hr_messages WHERE conversation_id IN (
      SELECT id FROM hr_conversations WHERE user_id = ANY(_user_ids)
    );
    DELETE FROM hr_conversations     WHERE user_id   = ANY(_user_ids);
    DELETE FROM notifications        WHERE user_id   = ANY(_user_ids);
    DELETE FROM profile_comparisons  WHERE user1_id  = ANY(_user_ids) OR user2_id = ANY(_user_ids);
    DELETE FROM test_responses       WHERE user_id   = ANY(_user_ids);
    DELETE FROM test_results         WHERE user_id   = ANY(_user_ids);
    DELETE FROM user_managers        WHERE user_id   = ANY(_user_ids) OR manager_id = ANY(_user_ids);
    DELETE FROM user_roles           WHERE user_id   = ANY(_user_ids);
  END IF;

  DELETE FROM test_invitations WHERE company_id = _company_id;
  DELETE FROM profiles         WHERE company_id = _company_id;
  DELETE FROM departments      WHERE company_id = _company_id;
  DELETE FROM companies        WHERE id         = _company_id;
END;
$$;

-- ─── FIM ─────────────────────────────────────────────────────────────────────
