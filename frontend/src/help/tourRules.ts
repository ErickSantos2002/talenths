import { format } from "date-fns";
import type { TourProgress } from "@/lib/api";
import type { AppRole } from "./screens";
import type { Audience, ScreenTour, Tour } from "./tours/types";

export function audienceOf(roles: AppRole[]): Audience {
  return roles.includes("manager") || roles.includes("master_admin") ? "manager" : "collaborator";
}

export function resumeStep(progress: TourProgress | null, t: Tour | null): number | null {
  if (!progress || !t) return null;
  if (progress.completed_at || !progress.started_at) return null;
  if (progress.version !== t.version) return null;
  if (progress.step === 0 || progress.step >= t.steps.length) return null;
  return progress.step;
}

// The welcome tour is mandatory: only finishing it releases the person.
export function mustTakeTour(progress: TourProgress | null): boolean {
  return !progress?.completed_at;
}

export function tourStatus(
  progress: TourProgress | null,
  t: Tour,
): { kind: "done"; date: string } | { kind: "stopped"; step: number; total: number } | { kind: "not-started" } {
  if (!progress || !progress.started_at) return { kind: "not-started" };
  if (progress.completed_at) return { kind: "done", date: format(new Date(progress.completed_at), "dd/MM/yyyy") };
  return { kind: "stopped", step: progress.step + 1, total: t.steps.length };
}

// Only the steps added after the version the person completed; null when the
// welcome tour was not finished or nothing new was added.
export function whatsNew(t: Tour, progress: TourProgress | null): Tour | null {
  if (!progress?.completed_at || progress.version >= t.version) return null;
  const steps = t.steps.filter((s) => (s.since ?? 1) > progress.version);
  return steps.length > 0 ? { id: t.id, version: t.version, steps } : null;
}

export function screenTourFor(tours: ScreenTour[], screenPath: string | null, roles: AppRole[]): ScreenTour | null {
  if (!screenPath) return null;
  return tours.find((s) => s.screen === screenPath && s.roles.some((r) => roles.includes(r))) ?? null;
}

export function asTour(s: ScreenTour): Tour {
  return { id: s.id, version: s.version, steps: s.steps };
}
