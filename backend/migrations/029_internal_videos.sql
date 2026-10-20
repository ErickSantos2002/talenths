-- 029_internal_videos.sql — vídeos internos de integração e apresentação da empresa, com atribuição obrigatória
CREATE TABLE IF NOT EXISTS public.internal_videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  file_path text NOT NULL,
  file_size bigint NOT NULL CHECK (file_size > 0),
  duration_seconds numeric NOT NULL CHECK (duration_seconds > 0),
  due_days int CHECK (due_days > 0),          -- nulo = sem prazo
  file_version int NOT NULL DEFAULT 1,
  archived_at timestamptz,                    -- nulo = ativo
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_internal_videos_company ON public.internal_videos(company_id);

CREATE TABLE IF NOT EXISTS public.internal_video_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id uuid NOT NULL REFERENCES public.internal_videos(id) ON DELETE CASCADE,
  target_type text NOT NULL CHECK (target_type IN ('all','department','user')),
  department_id uuid REFERENCES public.departments(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (
    (target_type = 'all'        AND department_id IS NULL     AND user_id IS NULL) OR
    (target_type = 'department' AND department_id IS NOT NULL AND user_id IS NULL) OR
    (target_type = 'user'       AND department_id IS NULL     AND user_id IS NOT NULL)
  )
);
CREATE INDEX IF NOT EXISTS idx_internal_video_rules_video ON public.internal_video_rules(video_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_internal_video_rules_all
  ON public.internal_video_rules(video_id) WHERE target_type = 'all';
CREATE UNIQUE INDEX IF NOT EXISTS uq_internal_video_rules_department
  ON public.internal_video_rules(video_id, department_id) WHERE target_type = 'department';
CREATE UNIQUE INDEX IF NOT EXISTS uq_internal_video_rules_user
  ON public.internal_video_rules(video_id, user_id) WHERE target_type = 'user';

-- Uma linha por (vídeo, pessoa): obrigatoriedade materializada + progresso.
-- user_id vira nulo quando o colaborador é excluído; os snapshots guardam quem era.
CREATE TABLE IF NOT EXISTS public.internal_video_viewers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id uuid NOT NULL REFERENCES public.internal_videos(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  user_name_snapshot text,
  department_name_snapshot text,
  required bool NOT NULL DEFAULT false,
  excluded bool NOT NULL DEFAULT false,
  assigned_at timestamptz NOT NULL DEFAULT now(),
  max_watched_s numeric NOT NULL DEFAULT 0 CHECK (max_watched_s >= 0),
  last_report_at timestamptz,
  completed_at timestamptz,
  UNIQUE (video_id, user_id)
);
CREATE INDEX IF NOT EXISTS idx_internal_video_viewers_user ON public.internal_video_viewers(user_id);

-- Estado do upload em partes no banco (e não em memória) porque o backend roda com 4 workers.
CREATE TABLE IF NOT EXISTS public.internal_video_uploads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  created_by uuid,
  total_size bigint NOT NULL CHECK (total_size > 0),
  parts_received int[] NOT NULL DEFAULT '{}',
  file_path text,
  completed_at timestamptz,
  consumed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_internal_video_uploads_company ON public.internal_video_uploads(company_id);

-- Torna obrigatório para os usuários dados (da empresa do vídeo). Linha voluntária é
-- promovida mantendo o progresso; linha excluded é ignorada. Notifica e retorna só
-- quem passou a ser obrigatório agora.
CREATE OR REPLACE FUNCTION public.internal_video_assign(p_video_id uuid, p_user_ids uuid[])
RETURNS int LANGUAGE plpgsql AS $$
DECLARE
  v_title text;
  v_company uuid;
  v_count int;
BEGIN
  SELECT title, company_id INTO v_title, v_company
  FROM public.internal_videos WHERE id = p_video_id;
  IF NOT FOUND THEN
    RETURN 0;
  END IF;

  WITH targets AS (
    SELECT DISTINCT p.user_id
    FROM public.profiles p
    WHERE p.user_id = ANY(p_user_ids) AND p.company_id = v_company
  ),
  changed AS (
    INSERT INTO public.internal_video_viewers AS w (video_id, user_id, required, assigned_at)
    SELECT p_video_id, t.user_id, true, now() FROM targets t
    ON CONFLICT (video_id, user_id) DO UPDATE
      SET required = true, assigned_at = now()
      WHERE w.required = false AND w.excluded = false
    RETURNING w.user_id
  ),
  notified AS (
    INSERT INTO public.notifications (user_id, type, title, message)
    SELECT c.user_id, 'video', 'Novo vídeo para assistir', v_title FROM changed c
    RETURNING 1
  )
  SELECT count(*) INTO v_count FROM notified;

  RETURN v_count;
END;
$$;

-- Materializa as regras do vídeo (todas, ou só as dadas). Vídeo arquivado não atribui.
CREATE OR REPLACE FUNCTION public.internal_video_apply_rules(p_video_id uuid, p_rule_ids uuid[] DEFAULT NULL)
RETURNS int LANGUAGE plpgsql AS $$
DECLARE
  v_company uuid;
  v_users uuid[];
BEGIN
  SELECT company_id INTO v_company
  FROM public.internal_videos WHERE id = p_video_id AND archived_at IS NULL;
  IF NOT FOUND THEN
    RETURN 0;
  END IF;

  SELECT array_agg(DISTINCT p.user_id) INTO v_users
  FROM public.internal_video_rules r
  JOIN public.profiles p ON p.company_id = v_company
  WHERE r.video_id = p_video_id
    AND (p_rule_ids IS NULL OR r.id = ANY(p_rule_ids))
    AND (r.target_type = 'all'
         OR (r.target_type = 'department' AND p.department_id = r.department_id)
         OR (r.target_type = 'user' AND p.user_id = r.user_id));

  IF v_users IS NULL THEN
    RETURN 0;
  END IF;
  RETURN public.internal_video_assign(p_video_id, v_users);
END;
$$;

-- Novo entrante ou mudança de departamento/empresa recebe os vídeos ativos cujas regras
-- casam. Trigger (e não código no router) porque perfis nascem e mudam por vários
-- caminhos. company_id também dispara: o signup cria o perfil sem empresa e o backend
-- a preenche num UPDATE logo depois.
CREATE OR REPLACE FUNCTION public.internal_videos_on_profile_change()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  v_video uuid;
BEGIN
  IF NEW.company_id IS NULL THEN
    RETURN NEW;
  END IF;
  IF TG_OP = 'UPDATE'
     AND NEW.company_id IS NOT DISTINCT FROM OLD.company_id
     AND NEW.department_id IS NOT DISTINCT FROM OLD.department_id THEN
    RETURN NEW;
  END IF;

  FOR v_video IN
    SELECT DISTINCT v.id
    FROM public.internal_videos v
    JOIN public.internal_video_rules r ON r.video_id = v.id
    WHERE v.company_id = NEW.company_id
      AND v.archived_at IS NULL
      AND (r.target_type = 'all'
           OR (r.target_type = 'department' AND r.department_id = NEW.department_id))
  LOOP
    PERFORM public.internal_video_assign(v_video, ARRAY[NEW.user_id]);
  END LOOP;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_profiles_internal_videos ON public.profiles;
CREATE TRIGGER trg_profiles_internal_videos
  AFTER INSERT OR UPDATE OF company_id, department_id ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.internal_videos_on_profile_change();

-- profiles é apagado antes de auth.users, então o snapshot é gravado antes do SET NULL.
CREATE OR REPLACE FUNCTION public.internal_videos_snapshot_profile()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE public.internal_video_viewers w
  SET user_name_snapshot = OLD.name,
      department_name_snapshot = (SELECT d.name FROM public.departments d WHERE d.id = OLD.department_id)
  WHERE w.user_id = OLD.user_id;
  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_profiles_internal_videos_snapshot ON public.profiles;
CREATE TRIGGER trg_profiles_internal_videos_snapshot
  BEFORE DELETE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.internal_videos_snapshot_profile();
