export type PunchKind = "in" | "out";
export type PunchSource = "self" | "manual";

export interface Punch {
  id: string;
  user_id: string;
  punched_at: string; // ISO datetime (UTC)
  work_date: string; // YYYY-MM-DD
  kind: PunchKind;
  source: PunchSource;
  latitude: number | null;
  longitude: number | null;
  note: string | null;
}

export interface DaySummary {
  work_date: string;
  expected_minutes: number;
  worked_minutes: number;
  open: boolean; // jornada em aberto (entrada sem saída)
  odd: boolean; // batida ímpar em dia passado (precisa correção)
  punches: Punch[];
}

export interface TodayStatus extends DaySummary {
  enabled: boolean;
  next_action: PunchKind;
}

export interface TeamDayPerson {
  user_id: string;
  user_name: string;
  department: string | null;
  expected_minutes: number;
  worked_minutes: number;
  open: boolean;
  status: "working" | "done" | "none";
  punches: Punch[];
}

export interface TeamDayResponse {
  mode: "day";
  work_date: string;
  people: TeamDayPerson[];
}

export interface TeamUserResponse {
  mode: "user";
  days: DaySummary[];
}

/** Converte minutos em "8h30". */
export function formatMinutes(min: number): string {
  const h = Math.floor(min / 60);
  const m = min % 60;
  return m === 0 ? `${h}h` : `${h}h${String(m).padStart(2, "0")}`;
}

/** Formata o horário (HH:MM) de um punched_at ISO no fuso do navegador. */
export function formatPunchTime(iso: string): string {
  return new Date(iso).toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" });
}
