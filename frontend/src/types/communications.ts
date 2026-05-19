export type AnnouncementStatus = "draft" | "published";

export interface Announcement {
  id: string;
  title: string;
  content: string;
  category: string;
  status: AnnouncementStatus;
  published_at?: string;
  created_at?: string;
  updated_at?: string;
}

export interface BirthdayEntry {
  user_id: string;
  name: string;
  email: string;
  department?: string;
  birth_date: string;
  day: number;
  is_today: boolean;
}

export interface MilestoneEntry {
  user_id: string;
  name: string;
  email: string;
  department?: string;
  hire_date: string;
  years: number;
  day: number;
  is_today: boolean;
}

export const ANNOUNCEMENT_CATEGORIES = [
  "Geral", "RH", "Benefícios", "Evento", "Urgente", "Reconhecimento",
];
