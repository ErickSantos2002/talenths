import type { VideoRules } from "./api";

const pad = (n: number) => String(n).padStart(2, "0");

export function formatDuration(totalSeconds: number): string {
  const s = Math.max(0, Math.round(totalSeconds));
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  const sec = s % 60;
  return h > 0 ? `${h}:${pad(m)}:${pad(sec)}` : `${pad(m)}:${pad(sec)}`;
}

export function formatDueDays(days: number | null): string {
  if (days == null) return "Sem prazo";
  return `${days} ${days === 1 ? "dia" : "dias"}`;
}

export function toggleId(ids: string[], id: string): string[] {
  return ids.includes(id) ? ids.filter((x) => x !== id) : [...ids, id];
}

export function isEmptyAudience(rules: VideoRules): boolean {
  return !rules.all && rules.department_ids.length === 0 && rules.user_ids.length === 0;
}
