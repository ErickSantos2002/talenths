export type CalendarEventType = "event" | "holiday" | "deadline" | "meeting" | "training" | "absence" | "birthday";

export interface CalendarEvent {
  id: string;
  title: string;
  description?: string;
  event_type: CalendarEventType;
  color: string;
  start_date: string;
  end_date: string;
  all_day?: boolean;
  created_by?: string;
  created_at?: string;
}

export interface FeedEntry {
  id: string;
  source: "event" | "absence" | "birthday";
  title: string;
  description?: string;
  event_type: CalendarEventType;
  color: string;
  start_date: string;
  end_date: string;
  recurring_monthly?: boolean;
}
