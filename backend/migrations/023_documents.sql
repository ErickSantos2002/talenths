CREATE TABLE IF NOT EXISTS public.documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    uploaded_by UUID NOT NULL REFERENCES public.profiles(user_id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    original_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    target_type TEXT NOT NULL CHECK (target_type IN ('general', 'department', 'individual')),
    target_department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
    target_user_id UUID REFERENCES public.profiles(user_id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);
