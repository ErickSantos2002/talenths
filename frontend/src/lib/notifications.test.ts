import { describe, expect, it } from "vitest";
import { countUnread, formatBadge, unreadIds, sortNewestFirst, notificationRoute } from "./notifications";

const n = (id: string, created_at: string, read = false, type = "info") => ({
  id,
  title: id,
  message: null,
  read,
  created_at,
  type,
});

describe("notifications", () => {
  it("routes video notifications to the user's videos page", () => {
    expect(notificationRoute("video")).toBe("/meus-videos");
    expect(notificationRoute("info")).toBeNull();
  });

  it("sorts newest first without dropping items", () => {
    const list = [n("a", "2026-01-01"), n("c", "2026-03-01"), n("b", "2026-02-01")];
    expect(sortNewestFirst(list).map((x) => x.id)).toEqual(["c", "b", "a"]);
  });

  it("lists unread ids across the whole list", () => {
    const list = Array.from({ length: 8 }, (_, i) => n(`n${i}`, "2026-01-01"));
    expect(unreadIds(list)).toHaveLength(8);
    expect(countUnread(list)).toBe(8);
  });

  it("caps the badge at 99+", () => {
    expect(formatBadge(7)).toBe("7");
    expect(formatBadge(99)).toBe("99");
    expect(formatBadge(100)).toBe("99+");
  });

  it("counts unread notifications", () => {
    expect(countUnread([n("a", "2026-01-01"), n("b", "2026-01-02", true)])).toBe(1);
  });
});
