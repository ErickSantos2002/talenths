import { describe, expect, it, vi } from "vitest";
import { MOBILE_MENU_TEXT, prepareSafely, restoreSidebar, sidebarTarget, type LayoutHooks } from "./sidebarTarget";

describe("sidebarTarget", () => {
  it("points menu steps to the mobile button on the phone", () => {
    for (const element of ["menu", "menu-company"]) {
      expect(sidebarTarget(element, { isMobile: true, collapsed: false })).toEqual({
        target: { element: "menu-mobile", extraText: MOBILE_MENU_TEXT },
        expand: false,
        closeMobile: true,
      });
    }
  });

  it("expands the collapsed sidebar on the computer for menu steps", () => {
    expect(sidebarTarget("menu-help", { isMobile: false, collapsed: true })).toEqual({
      target: { element: "menu-help" },
      expand: true,
      closeMobile: false,
    });
    expect(sidebarTarget("menu", { isMobile: false, collapsed: false }).expand).toBe(false);
  });

  it("keeps other elements unchanged and closes the mobile drawer", () => {
    expect(sidebarTarget("notifications", { isMobile: true, collapsed: true })).toEqual({
      target: { element: "notifications" },
      expand: false,
      closeMobile: true,
    });
  });

  it("an undefined element (centered popover) neither expands nor changes target", () => {
    const r = sidebarTarget(undefined, { isMobile: false, collapsed: true });
    expect(r.expand).toBe(false);
    expect(r.target).toEqual({});
  });
});

describe("prepareSafely", () => {
  it("returns the element unchanged when no layout is registered", async () => {
    expect(await prepareSafely(null, "dashboard-header")).toEqual({ element: "dashboard-header" });
    expect(await prepareSafely(null, undefined)).toEqual({});
  });

  it("never rejects: a failing layout falls back to the element", async () => {
    const hooks: LayoutHooks = { prepare: () => Promise.reject(new Error("x")), restore: () => {} };
    await expect(prepareSafely(hooks, "menu")).resolves.toEqual({ element: "menu" });
    const throwing: LayoutHooks = {
      prepare: () => {
        throw new Error("sync");
      },
      restore: () => {},
    };
    await expect(prepareSafely(throwing, undefined)).resolves.toEqual({});
  });

  it("uses the layout's answer when it succeeds", async () => {
    const hooks: LayoutHooks = { prepare: async () => ({ element: "menu-mobile", extraText: "t" }), restore: () => {} };
    expect(await prepareSafely(hooks, "menu")).toEqual({ element: "menu-mobile", extraText: "t" });
  });
});

describe("restoreSidebar", () => {
  const noop: LayoutHooks["prepare"] = async () => ({});

  it("hands the restore to the mounted layout", () => {
    const restore = vi.fn();
    const writeCookie = vi.fn();
    restoreSidebar({ prepare: noop, restore }, { current: true }, writeCookie);
    expect(restore).toHaveBeenCalledOnce();
    expect(writeCookie).not.toHaveBeenCalled();
  });

  // Logout mid-tour: /login has no sidebar, so the layout is already gone
  // when the tour closes; the next login must not find the menu expanded.
  it("with no layout mounted, writes the collapsed cookie if the tour expanded the menu", () => {
    const expandedByTour = { current: true };
    const writeCookie = vi.fn();
    restoreSidebar(null, expandedByTour, writeCookie);
    expect(writeCookie).toHaveBeenCalledOnce();
    expect(expandedByTour.current).toBe(false);
    restoreSidebar(null, expandedByTour, writeCookie);
    expect(writeCookie).toHaveBeenCalledOnce();
  });

  it("with no layout mounted, leaves the cookie alone if the tour did not expand the menu", () => {
    const writeCookie = vi.fn();
    restoreSidebar(null, { current: false }, writeCookie);
    expect(writeCookie).not.toHaveBeenCalled();
  });

  it("the default writer stores the collapsed state in the sidebar cookie", () => {
    document.cookie = "sidebar:state=true; path=/";
    restoreSidebar(null, { current: true });
    expect(document.cookie).toContain("sidebar:state=false");
  });
});
