import type { PreparedTarget } from "./tourEngine";

export const MOBILE_MENU_TEXT = "No celular, toque no botão **☰** para abrir o menu.";

// "menu-mobile" is the phone's ☰ button, outside the sidebar.
function isMenu(element: string | undefined): boolean {
  return element === "menu" || (!!element && element.startsWith("menu-") && element !== "menu-mobile");
}

// On the phone the menu lives in a drawer that would cover the screen; the
// step points at the ☰ button instead of opening it. On the computer a
// collapsed sidebar hides the item labels, so it expands for the step.
export function sidebarTarget(
  element: string | undefined,
  s: { isMobile: boolean; collapsed: boolean },
): { target: PreparedTarget; expand: boolean; closeMobile: boolean } {
  const target: PreparedTarget = element === undefined ? {} : { element };
  if (!isMenu(element)) return { target, expand: false, closeMobile: true };
  if (s.isMobile) {
    return { target: { element: "menu-mobile", extraText: MOBILE_MENU_TEXT }, expand: false, closeMobile: true };
  }
  return { target, expand: s.collapsed, closeMobile: false };
}

// What the mounted AdminLayout offers the tour (registered by TourLayoutBridge).
export interface LayoutHooks {
  prepare(element: string | undefined): Promise<PreparedTarget>;
  restore(): void;
}

// The engine replaces the step's element with whatever `prepare` returns and
// stalls if it rejects: any failure falls back to the step's own element.
export async function prepareSafely(hooks: LayoutHooks | null, element: string | undefined): Promise<PreparedTarget> {
  const unchanged: PreparedTarget = element === undefined ? {} : { element };
  if (!hooks) return unchanged;
  try {
    return await hooks.prepare(element);
  } catch {
    return unchanged;
  }
}
