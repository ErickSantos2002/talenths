CREATE TABLE IF NOT EXISTS public.feedback_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    created_by UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    question TEXT NOT NULL,
    target_type TEXT NOT NULL CHECK (target_type IN ('all', 'department', 'individual')),
    target_department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
    target_user_id UUID REFERENCES public.profiles(user_id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.feedback_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feedback_request_id UUID NOT NULL REFERENCES public.feedback_requests(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE (feedback_request_id, user_id)
);
