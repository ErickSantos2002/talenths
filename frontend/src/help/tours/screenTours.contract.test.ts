import { describe, expect, it } from "vitest";

import { parseGuide } from "../guideParser";
import { RAW_GUIDES } from "../guidesBundle";
import { canOpen, SCREENS } from "../screens";
import { ANCHORS } from "./anchors";
import { SCREEN_TOURS } from "./screenTours";
import { WELCOME_TOURS } from "./welcome";

const guides = Object.entries(RAW_GUIDES).map(([path, raw]) => ({ path, guide: parseGuide(path, raw) }));
const SCREEN_PATHS = new Set(SCREENS.map((s) => s.path));

describe("screen tours contract", () => {
  it("there are screen tours to check", () => {
    expect(SCREEN_TOURS.length).toBeGreaterThan(0);
  });

  it("ids are valid, unique and distinct from the welcome tours", () => {
    const ids = SCREEN_TOURS.map((t) => t.id);
    const welcome = new Set(Object.values(WELCOME_TOURS).map((t) => t.id));
    for (const t of SCREEN_TOURS) {
      expect(t.id).toMatch(/^[a-z0-9-]{1,64}$/);
      expect(t.id).toMatch(/^tela-/);
      expect(welcome.has(t.id), t.id).toBe(false);
      expect(t.version).toBeGreaterThanOrEqual(1);
      expect(t.version).toBeLessThanOrEqual(999);
    }
    expect(new Set(ids).size).toBe(ids.length);
  });

  it("screen is in SCREENS and every role can open it", () => {
    for (const t of SCREEN_TOURS) {
      expect(SCREEN_PATHS.has(t.screen), `${t.id}: ${t.screen}`).toBe(true);
      expect(t.roles.length, t.id).toBeGreaterThan(0);
      for (const r of t.roles) {
        expect(canOpen(t.screen, { roles: [r], timeclockEnabled: true }), `${t.id}: ${r}`).toBe(true);
      }
    }
  });

  it("at most one screen tour per screen and role", () => {
    const seen = new Set<string>();
    for (const t of SCREEN_TOURS) {
      for (const r of t.roles) {
        const key = `${t.screen} ${r}`;
        expect(seen.has(key), key).toBe(false);
        seen.add(key);
      }
    }
  });

  it("every step points to an existing data-tour, never navigates and has a plain short text", () => {
    for (const t of SCREEN_TOURS) {
      expect(t.steps.length, t.id).toBeGreaterThanOrEqual(3);
      expect(t.steps.length, t.id).toBeLessThanOrEqual(6);
      const elements = t.steps.map((s) => s.element);
      expect(new Set(elements).size, `${t.id}: elemento repetido`).toBe(elements.length);
      for (const step of t.steps) {
        const where = `${t.id}: ${step.title}`;
        expect("route" in step, where).toBe(false);
        expect("interact" in step, where).toBe(false);
        expect(step.element, where).toBeTruthy();
        expect(ANCHORS.has(step.element!), `${t.id}: ${step.element}`).toBe(true);
        expect(`${step.title}${step.text}`, where).not.toContain("<");
        const sentences = step.text.match(/[.!?](\s|$)/g) ?? [];
        expect(sentences.length, step.text).toBeGreaterThanOrEqual(1);
        expect(sentences.length, step.text).toBeLessThanOrEqual(2);
        expect(step.text).not.toMatch(/onboarding|treinamento/i);
      }
    }
  });

  it("every tour is linked by a guide of its screen", () => {
    for (const t of SCREEN_TOURS) {
      const linking = guides.filter(({ guide }) => guide.tour === t.id && guide.screens.includes(t.screen));
      expect(linking.map((g) => g.path), t.id).not.toEqual([]);
    }
  });

  it("every tour: in a guide points to a screen tour", () => {
    const ids = new Set(SCREEN_TOURS.map((t) => t.id));
    const unknown = guides.filter(({ guide }) => guide.tour && !ids.has(guide.tour)).map((g) => `${g.path}: ${g.guide.tour}`);
    expect(unknown).toEqual([]);
  });

  it("the six dense screens have their tour", () => {
    expect(SCREEN_TOURS.map((t) => [t.id, t.screen])).toEqual([
      ["tela-minha-avaliacao", "/minha-avaliacao"],
      ["tela-meu-pdi", "/meu-pdi"],
      ["tela-video", "/videos/:id"],
      ["tela-admin-videos", "/admin/videos"],
      ["tela-admin-avaliacao", "/admin/avaliacao"],
      ["tela-admin-9box", "/admin/9box"],
    ]);
  });
});
