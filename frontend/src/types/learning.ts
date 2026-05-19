export interface CourseCatalogItem {
  id: string;
  title: string;
  area: string;
  description?: string;
  duration_hours: number;
  created_at?: string;
}

export interface EmployeeCourse {
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
