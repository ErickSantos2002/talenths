export interface AbsenceType {
  id: string;
  name: string;
  color: string;
  requires_approval: boolean;
  created_at: string;
  updated_at?: string | null;
}

export interface AbsenceRequest {
  id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  type_id: string;
  type_name?: string;
  type_color?: string;
  start_date: string;
  end_date: string;
  start_time?: string | null;
  end_time?: string | null;
  days: number;
  reason?: string;
  status: "pending" | "approved" | "rejected";
  review_note?: string;
  reviewed_at?: string;
  reviewer_name?: string | null;
  auto_approved: boolean;
  created_at: string;
  updated_at?: string | null;
}

export interface AbsenceHistoryPage {
  total: number;
  page: number;
  limit: number;
  pages: number;
  items: AbsenceRequest[];
}
