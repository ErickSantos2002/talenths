import { describe, expect, it } from "vitest";
import { groupByUser } from "./learningGroups";
import type { EmployeeCourse, TrackProgress } from "@/types/learning";

const course = (user_id: string, user_name: string): EmployeeCourse => ({
  id: `c-${user_id}`, user_id, user_name, course_title: "Excel", area: "TI", hours: 2,
  completed_at: "2026-09-01", source: "csv",
});
const track = (user_id: string, user_name: string, deactivated_at: string | null = null): TrackProgress => ({
  id: `t-${user_id}`, user_id, user_name, department: "Comercial", deactivated_at, track_name: "MARKETING",
  group_name: "MARKETING", courses: "", started_at: null, finished_at: null, progress_pct: 6, score_pct: null,
  imported_at: "2026-10-29T12:00:00Z",
});

describe("groupByUser", () => {
  it("inclui quem só tem trilha em andamento", () => {
    const groups = groupByUser([course("a", "Ana")], [track("l", "Lara")]);
    expect(groups.map(([, u]) => u.name)).toEqual(["Ana", "Lara"]);
    const lara = groups.find(([id]) => id === "l")![1];
    expect(lara.courses).toEqual([]);
    expect(lara.tracks.map((t) => t.track_name)).toEqual(["MARKETING"]);
    expect(lara.department).toBe("Comercial");
  });

  it("junta cursos e trilhas da mesma pessoa", () => {
    const [[, ana]] = groupByUser([course("a", "Ana")], [track("a", "Ana")]);
    expect(ana.tracks).toHaveLength(1);
    expect(ana.courses).toHaveLength(1);
  });

  it("marca desligado vindo da trilha", () => {
    const [[, u]] = groupByUser([], [track("x", "Saiu", "2026-10-01T00:00:00Z")]);
    expect(u.deactivated).toBe(true);
  });
});
