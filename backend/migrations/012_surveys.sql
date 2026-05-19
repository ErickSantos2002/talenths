-- Fase 5.2: Pesquisa de Engajamento

CREATE TABLE IF NOT EXISTS public.engagement_surveys (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    anonymous boolean NOT NULL DEFAULT true,
    status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'closed')),
    starts_at date,
    ends_at date,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.survey_questions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id uuid NOT NULL REFERENCES public.engagement_surveys(id) ON DELETE CASCADE,
    text text NOT NULL,
    type text NOT NULL DEFAULT 'scale' CHECK (type IN ('scale', 'text', 'choice')),
    options jsonb,
    position integer NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.survey_responses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id uuid NOT NULL REFERENCES public.engagement_surveys(id) ON DELETE CASCADE,
    user_id uuid NOT NULL,
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    submitted_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (survey_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.survey_answers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    response_id uuid NOT NULL REFERENCES public.survey_responses(id) ON DELETE CASCADE,
    question_id uuid NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
    scale_value integer CHECK (scale_value BETWEEN 1 AND 5),
    text_value text,
    choice_value text
);

CREATE INDEX IF NOT EXISTS idx_survey_questions_survey ON public.survey_questions(survey_id);
CREATE INDEX IF NOT EXISTS idx_survey_responses_survey ON public.survey_responses(survey_id);
CREATE INDEX IF NOT EXISTS idx_survey_answers_response ON public.survey_answers(response_id);
