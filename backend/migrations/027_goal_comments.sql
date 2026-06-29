-- Metas: comentários no histórico da meta, com anexos (PDF/Excel/imagem).

CREATE TABLE IF NOT EXISTS public.goal_comments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    goal_id uuid NOT NULL REFERENCES public.goals(id) ON DELETE CASCADE,
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    author_id uuid,
    body text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.goal_comment_attachments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    comment_id uuid NOT NULL REFERENCES public.goal_comments(id) ON DELETE CASCADE,
    original_name text NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    mime_type text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_goal_comments_goal ON public.goal_comments(goal_id);
CREATE INDEX IF NOT EXISTS idx_goal_comment_attachments_comment ON public.goal_comment_attachments(comment_id);
