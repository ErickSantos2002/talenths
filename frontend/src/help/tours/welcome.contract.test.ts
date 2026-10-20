import { describe, expect, it } from "vitest";
import { canOpen, SCREENS } from "../screens";
import { WELCOME_TOURS } from "./welcome";

const sources = import.meta.glob("/src/**/*.tsx", {
  query: "?raw",
  import: "default",
  eager: true,
}) as Record<string, string>;

const anchors = new Set<string>();
for (const [file, code] of Object.entries(sources)) {
  if (/\.test\.tsx$/.test(file)) continue;
  for (const m of code.matchAll(/data-tour="([^"{}]+)"/g)) anchors.add(m[1]);
}
for (const s of SCREENS) if (s.menu) anchors.add(s.menu.tour);

const tours = Object.entries(WELCOME_TOURS);

describe("welcome tours contract", () => {
  it("every element exists as data-tour", () => {
    for (const [key, tour] of tours) {
      for (const step of tour.steps) {
        if (step.element) {
          expect(anchors.has(step.element), `${key}: ${step.element}`).toBe(true);
        }
      }
    }
  });

  it("every route is openable by the audience", () => {
    const ctx = {
      collaborator: { roles: ["user" as const], timeclockEnabled: false },
      manager: { roles: ["manager" as const], timeclockEnabled: false },
    };
    for (const [key, tour] of tours) {
      for (const step of tour.steps) {
        expect(canOpen(step.route, ctx[key as keyof typeof ctx]), `${key}: ${step.route}`).toBe(true);
      }
    }
  });

  it("ids and versions are valid", () => {
    const ids = tours.map(([, t]) => t.id);
    for (const [, t] of tours) {
      expect(t.id).toMatch(/^[a-z0-9-]{1,64}$/);
      expect(t.version).toBeGreaterThanOrEqual(1);
      expect(t.version).toBeLessThanOrEqual(999);
    }
    expect(new Set(ids).size).toBe(ids.length);
  });

  it("manager tour starts with the collaborator steps and ends at /ajuda", () => {
    const c = WELCOME_TOURS.collaborator.steps;
    const m = WELCOME_TOURS.manager.steps;
    expect(m.length).toBeGreaterThan(c.length);
    const head = c.slice(0, -1);
    expect(m.slice(0, head.length)).toEqual(head);
    expect(c[c.length - 1].route).toBe("/ajuda");
    expect(m[m.length - 1]).toEqual(c[c.length - 1]);
  });

  it("texts are short", () => {
    for (const [, t] of tours) {
      for (const step of t.steps) {
        const sentences = step.text.match(/[.!?](\s|$)/g) ?? [];
        expect(sentences.length, step.text).toBeLessThanOrEqual(2);
        expect(step.text).not.toMatch(/onboarding|treinamento/i);
      }
    }
  });
});
