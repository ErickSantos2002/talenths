import { describe, expect, it } from "vitest";
import { countUnread, latestNotifications, notificationRoute } from "./notifications";

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

  it("sorts newest first and keeps only the latest ones", () => {
    const list = [n("a", "2026-01-01"), n("c", "2026-03-01"), n("b", "2026-02-01")];
    expect(latestNotifications(list, 2).map((x) => x.id)).toEqual(["c", "b"]);
  });

  it("counts unread notifications", () => {
    expect(countUnread([n("a", "2026-01-01"), n("b", "2026-01-02", true)])).toBe(1);
  });
});
