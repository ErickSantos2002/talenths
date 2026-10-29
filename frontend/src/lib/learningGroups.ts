import type { EmployeeCourse, TrackProgress } from "@/types/learning";

export type LearnerGroup = {
  name: string;
  email: string;
  department?: string | null;
  deactivated: boolean;
  courses: EmployeeCourse[];
  tracks: TrackProgress[];
};

// Quem só tem trilha em andamento (sem curso concluído) também precisa aparecer.
export function groupByUser(courses: EmployeeCourse[], tracks: TrackProgress[] = []) {
  const map: Record<string, LearnerGroup> = {};
  const entry = (userId: string, name: string, email: string, department: string | null | undefined, deactivated: boolean) =>
    (map[userId] ??= { name, email, department, deactivated, courses: [], tracks: [] });
  for (const c of courses) {
    entry(c.user_id, c.user_name ?? c.user_email ?? c.user_id, c.user_email ?? "", c.department, !!c.deactivated_at)
      .courses.push(c);
  }
  for (const t of tracks) {
    entry(t.user_id, t.user_name ?? t.user_id, "", t.department, !!t.deactivated_at).tracks.push(t);
  }
  return Object.entries(map).sort((a, b) => a[1].name.localeCompare(b[1].name));
}
