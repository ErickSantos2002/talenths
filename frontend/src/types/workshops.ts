export type WorkshopStatus = "draft" | "open" | "closed" | "done";
export type RegistrationStatus = "registered" | "attended" | "absent";

export interface Workshop {
  id: string;
  title: string;
  area: string;
  description?: string;
  location?: string;
  starts_at: string;
  ends_at: string;
  max_seats?: number;
  seats_taken: number;
  status: WorkshopStatus;
  created_at?: string;
  user_registration_status?: RegistrationStatus | null;
}

export interface WorkshopRegistration {
  id: string;
  workshop_id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  status: RegistrationStatus;
  registered_at?: string;
}

export const WORKSHOP_STATUS_LABELS: Record<WorkshopStatus, string> = {
  draft: "Rascunho",
  open: "Inscrições abertas",
  closed: "Inscrições encerradas",
  done: "Realizado",
};

export const WORKSHOP_STATUS_COLORS: Record<WorkshopStatus, string> = {
  draft: "text-muted-foreground",
  open: "text-emerald-400",
  closed: "text-amber-400",
  done: "text-blue-400",
};
