// Test helper: every `data-tour` anchor written in the app's .tsx files, plus
// the menu items (their anchor comes from SCREENS).
import { SCREENS } from "../screens";

const sources = import.meta.glob("/src/**/*.tsx", {
  query: "?raw",
  import: "default",
  eager: true,
}) as Record<string, string>;

export const ANCHORS = new Set<string>();
for (const [file, code] of Object.entries(sources)) {
  if (/\.test\.tsx$/.test(file)) continue;
  for (const m of code.matchAll(/data-tour="([^"{}]+)"/g)) ANCHORS.add(m[1]);
}
for (const s of SCREENS) if (s.menu) ANCHORS.add(s.menu.tour);
