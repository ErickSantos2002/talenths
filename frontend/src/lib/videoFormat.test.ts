import { describe, expect, it } from "vitest";
import { formatDuration, formatDueDays, isEmptyAudience, toggleId } from "./videoFormat";

describe("videoFormat", () => {
  it("formats durations as mm:ss and h:mm:ss", () => {
    expect(formatDuration(0)).toBe("00:00");
    expect(formatDuration(65)).toBe("01:05");
    expect(formatDuration(3600)).toBe("1:00:00");
    expect(formatDuration(3725.4)).toBe("1:02:05");
  });

  it("formats the deadline", () => {
    expect(formatDueDays(null)).toBe("Sem prazo");
    expect(formatDueDays(1)).toBe("1 dia");
    expect(formatDueDays(7)).toBe("7 dias");
  });

  it("toggles ids immutably", () => {
    const a = ["x"];
    expect(toggleId(a, "y")).toEqual(["x", "y"]);
    expect(toggleId(a, "x")).toEqual([]);
    expect(a).toEqual(["x"]);
  });

  it("detects an empty audience", () => {
    expect(isEmptyAudience({ all: false, department_ids: [], user_ids: [] })).toBe(true);
    expect(isEmptyAudience({ all: true, department_ids: [], user_ids: [] })).toBe(false);
    expect(isEmptyAudience({ all: false, department_ids: [], user_ids: ["u"] })).toBe(false);
  });
});
