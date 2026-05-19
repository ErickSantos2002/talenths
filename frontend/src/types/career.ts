export interface CareerLevel {
  id: string;
  name: string;
  position: number;
  description?: string;
  min_score_final?: number | null;
  required_9box_quadrants?: string[] | null;
  min_months_in_level?: number | null;
}

export interface CareerTrack {
  id: string;
  name: string;
  description?: string;
  levels: CareerLevel[];
}

export interface TeamCareerEntry {
  user_id: string;
  name: string;
  email: string;
  department?: string;
  career_id?: string;
  track_id?: string;
  track_name?: string;
  level_id?: string;
  level_name?: string;
  level_position?: number;
  started_at?: string;
  months_in_level?: number;
  score_final?: number | null;
  nine_box_quadrant?: string;
  eligible_for_next: boolean;
}

export interface MyCareer {
  track_id: string;
  track_name: string;
  track_description?: string;
  level_id: string;
  level_name: string;
  level_position: number;
  level_description?: string;
  started_at?: string;
  months_in_level?: number;
  notes?: string;
  score_final?: number | null;
  nine_box_quadrant?: string;
  next_level?: CareerLevel | null;
  eligible_for_next: boolean;
}
