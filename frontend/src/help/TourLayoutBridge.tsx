import { useLayoutEffect, useRef } from "react";

import { useSidebar } from "@/components/ui/sidebar";
import { sidebarTarget, type LayoutHooks } from "./sidebarTarget";
import { useTourLayout } from "./TourProvider";

// The sidebar width transition (duration-200 in ui/sidebar), with slack: the
// tour measures the item after the menu finished opening.
const SIDEBAR_TRANSITION_MS = 320;

function twoFrames(): Promise<void> {
  return new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(() => resolve())));
}

// Rendered inside each AdminLayout's SidebarProvider: gives the tour access to
// the sidebar of the page that is mounted right now.
export function TourLayoutBridge() {
  const { registerLayout, unregisterLayout, expandedByTour } = useTourLayout();
  const sidebar = useSidebar();
  // The tour asks between frames; a ref does not wait for a render.
  const sidebarRef = useRef(sidebar);
  sidebarRef.current = sidebar;

  useLayoutEffect(() => {
    const hooks: LayoutHooks = {
      async prepare(element) {
        const s = sidebarRef.current;
        const decision = sidebarTarget(element, { isMobile: s.isMobile, collapsed: s.state === "collapsed" });
        if (decision.closeMobile && s.openMobile) {
          s.setOpenMobile(false);
          await twoFrames();
        }
        if (decision.expand) {
          expandedByTour.current = true;
          s.setOpen(true);
          await new Promise((r) => setTimeout(r, SIDEBAR_TRANSITION_MS));
        }
        return decision.target;
      },
      restore() {
        if (!expandedByTour.current) return;
        expandedByTour.current = false;
        // setOpen also writes the cookie the next AdminLayout reads.
        sidebarRef.current.setOpen(false);
      },
    };
    registerLayout(hooks);
    return () => unregisterLayout(hooks);
  }, [registerLayout, unregisterLayout, expandedByTour]);

  return null;
}
