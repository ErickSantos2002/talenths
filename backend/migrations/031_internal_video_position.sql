-- 031_internal_video_position.sql — ordem dos vídeos internos definida pelo RH
ALTER TABLE public.internal_videos ADD COLUMN IF NOT EXISTS position int;

-- Os vídeos que já existem começam na ordem em que apareciam: o mais novo primeiro.
UPDATE public.internal_videos v
SET position = o.rn
FROM (
  SELECT id, row_number() OVER (PARTITION BY company_id ORDER BY created_at DESC) AS rn
  FROM public.internal_videos
) o
WHERE o.id = v.id AND v.position IS NULL;

ALTER TABLE public.internal_videos ALTER COLUMN position SET NOT NULL;
CREATE INDEX IF NOT EXISTS idx_internal_videos_company_position
  ON public.internal_videos(company_id, position);

-- Vídeo novo entra no fim da lista da empresa, venha de onde vier o INSERT.
CREATE OR REPLACE FUNCTION public.internal_video_default_position()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.position IS NULL THEN
    SELECT COALESCE(max(position), 0) + 1 INTO NEW.position
    FROM public.internal_videos WHERE company_id = NEW.company_id;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_internal_video_default_position ON public.internal_videos;
CREATE TRIGGER trg_internal_video_default_position
  BEFORE INSERT ON public.internal_videos
  FOR EACH ROW EXECUTE FUNCTION public.internal_video_default_position();
