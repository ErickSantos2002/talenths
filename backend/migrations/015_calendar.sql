-- Fase 5.6: Calendário Interno

CREATE TABLE IF NOT EXISTS public.calendar_events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    event_type text NOT NULL DEFAULT 'event' CHECK (event_type IN ('event', 'holiday', 'deadline', 'meeting', 'training')),
    color text NOT NULL DEFAULT '#6366f1',
    start_date date NOT NULL,
    end_date date NOT NULL,
    all_day boolean NOT NULL DEFAULT true,
    created_by uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_calendar_events_company ON public.calendar_events(company_id);
CREATE INDEX IF NOT EXISTS idx_calendar_events_dates ON public.calendar_events(start_date, end_date);
