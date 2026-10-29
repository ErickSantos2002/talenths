export interface CourseCatalogItem {
  id: string;
  title: string;
  area: string;
  description?: string;
  duration_hours: number;
  created_at?: string;
}

export interface EmployeeCourse {
  deactivated_at?: string | null;
  id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  catalog_id?: string;
  course_title: string;
  area: string;
  hours: number;
  completed_at: string;
  source: "manual" | "csv";
  created_at?: string;
}

export interface TrackProgress {
  id: string;
  user_id: string;
  user_name?: string;
  department?: string | null;
  deactivated_at?: string | null;
  track_name: string;
  group_name: string | null;
  // Texto como a plataforma manda: nomes de curso podem ter vírgula.
  courses: string;
  started_at: string | null;
  finished_at: string | null;
  progress_pct: number;
  score_pct: number | null;
  imported_at: string;
}
