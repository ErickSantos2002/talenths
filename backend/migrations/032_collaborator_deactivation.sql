-- 032_collaborator_deactivation.sql — desligamento de colaboradores pelo RH
-- Ativo = profiles.deactivated_at IS NULL. Cada desligamento vira um registro próprio, para
-- que uma recontratação não apague o desligamento anterior.
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS deactivated_at timestamptz;
CREATE INDEX IF NOT EXISTS idx_profiles_company_active
  ON public.profiles(company_id) WHERE deactivated_at IS NULL;

CREATE TABLE IF NOT EXISTS public.collaborator_terminations (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id        uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  company_id        uuid NOT NULL REFERENCES public.companies(id),
  termination_date  date NOT NULL,
  reason            text NOT NULL CHECK (reason IN (
                      'resignation', 'dismissal_without_cause', 'dismissal_with_cause',
                      'contract_end', 'mutual_agreement', 'other')),
  note              text,
  deactivated_at    timestamptz NOT NULL DEFAULT now(),
  -- SET NULL para que a exclusão definitiva de quem desligou continue possível;
  -- o nome de quem fez fica no log de auditoria.
  deactivated_by    uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reactivated_at    timestamptz,
  reactivated_by    uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  CHECK (reason <> 'other' OR coalesce(btrim(note), '') <> '')
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_collaborator_terminations_open
  ON public.collaborator_terminations(profile_id) WHERE reactivated_at IS NULL;

-- Regras de vídeo (029) não atribuem a desligados.
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
  JOIN public.profiles p ON p.company_id = v_company AND p.deactivated_at IS NULL
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

-- Reativar também dispara: quem volta recebe os vídeos publicados enquanto esteve fora.
CREATE OR REPLACE FUNCTION public.internal_videos_on_profile_change()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  v_video uuid;
BEGIN
  IF NEW.company_id IS NULL OR NEW.deactivated_at IS NOT NULL THEN
    RETURN NEW;
  END IF;
  IF TG_OP = 'UPDATE'
     AND NEW.company_id IS NOT DISTINCT FROM OLD.company_id
     AND NEW.department_id IS NOT DISTINCT FROM OLD.department_id
     AND OLD.deactivated_at IS NULL THEN
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
  AFTER INSERT OR UPDATE OF company_id, department_id, deactivated_at ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.internal_videos_on_profile_change();
