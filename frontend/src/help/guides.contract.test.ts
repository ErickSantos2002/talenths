import { existsSync } from "node:fs";
import { join, resolve } from "node:path";
import { describe, expect, it } from "vitest";

import { CAPTURES } from "../../scripts/captures.config";
import { parseGuide } from "./guideParser";
import { RAW_GUIDES } from "./guidesBundle";
import { SCREENS } from "./screens";

const CAPTURES_DIR = resolve(__dirname, "../../public/capturas");
const CAPTURE_NAMES = new Set(CAPTURES.map((c) => c.name));

const entries = Object.entries(RAW_GUIDES);
const parseErrors: string[] = [];
const guides = entries.flatMap(([path, raw]) => {
  try {
    return [{ path, guide: parseGuide(path, raw) }];
  } catch (e) {
    parseErrors.push((e as Error).message);
    return [];
  }
});

// Every menu screen must have a guide. Admin screens come in Task 7, which
// drops the /admin/ exclusion.
const COVERED_SCREENS = SCREENS.filter((s) => s.menu && !s.path.startsWith("/admin/")).map((s) => s.path);

// Captures no guide cites yet: the manager welcome-tour screens, kept for the
// admin guides (Task 7).
const NOT_IN_GUIDES = new Set(["admin-videos", "admin-relatorios"]);

const REQUIRED_SECTIONS = ["## Para que serve", "## Passo a passo", "## Dúvidas comuns"];

/** Every `[text](href)` and `![alt](src)` in the body, outside code. */
function links(body: string): { image: boolean; text: string; href: string }[] {
  return [...body.matchAll(/(!?)\[([^\]]*)\]\(([^)\s]+)[^)]*\)/g)].map((m) => ({
    image: m[1] === "!",
    text: m[2],
    href: m[3],
  }));
}

const routeOk = (href: string) => {
  const path = href.split(/[?#]/)[0];
  if (SCREENS.some((s) => s.path === path && !s.path.includes(":"))) return true;
  const guide = /^\/ajuda\/([a-z0-9-]+)\/([a-z0-9-]+)$/.exec(path);
  return !!guide && guides.some(({ guide: g }) => g.module === guide[1] && g.slug === guide[2]);
};

describe("guides contract", () => {
  it("there are guides to check", () => {
    expect(entries.length).toBeGreaterThan(0);
  });

  it("every guide parses", () => {
    expect(parseErrors).toEqual([]);
  });

  it.each(COVERED_SCREENS)("%s has at least one guide that cites it in telas", (path) => {
    expect(guides.filter(({ guide }) => guide.screens.includes(path)).map(({ path: p }) => p)).not.toEqual([]);
  });

  it.each(entries.map(([p]) => p))("%s has the required sections", (path) => {
    const parsed = guides.find((g) => g.path === path);
    if (!parsed) return; // reported by "every guide parses"
    const { guide } = parsed;
    for (const section of REQUIRED_SECTIONS) {
      expect(guide.body.split("\n"), `${path} sem "${section}"`).toContain(section);
    }
  });

  it("no guide says treinamento", () => {
    const offenders = guides.filter(({ guide }) => /treinamento/i.test(`${guide.title}\n${guide.body}`)).map((g) => g.path);
    expect(offenders).toEqual([]);
  });

  it("every cited image has alt text, is /capturas/<name>.webp, listed in CAPTURES and generated", () => {
    const problems: string[] = [];
    for (const { path, guide } of guides) {
      for (const { href, text } of links(guide.body).filter((l) => l.image)) {
        const m = /^\/capturas\/([a-z0-9-]+)\.webp$/.exec(href);
        // GuideContent only renders a capture with a non-empty alt.
        if (!text.trim()) problems.push(`${path}: imagem sem texto alternativo (${href})`);
        if (!m) problems.push(`${path}: imagem fora de /capturas/<nome>.webp (${href})`);
        else if (!CAPTURE_NAMES.has(m[1])) problems.push(`${path}: ${m[1]} fora de CAPTURES`);
        else if (!existsSync(join(CAPTURES_DIR, `${m[1]}.webp`))) problems.push(`${path}: ${m[1]}.webp não gerada`);
      }
    }
    expect(problems).toEqual([]);
  });

  it("every internal link points to a screen of SCREENS or an existing guide", () => {
    const problems: string[] = [];
    for (const { path, guide } of guides) {
      for (const { href } of links(guide.body).filter((l) => !l.image && l.href.startsWith("/"))) {
        if (!routeOk(href)) problems.push(`${path}: ${href}`);
      }
    }
    expect(problems).toEqual([]);
  });

  it("every capture is cited by some guide (except the listed tour-only ones)", () => {
    const cited = new Set(
      guides.flatMap(({ guide }) =>
        links(guide.body)
          .filter((l) => l.image)
          .map((l) => /^\/capturas\/([a-z0-9-]+)\.webp$/.exec(l.href)?.[1])
          .filter(Boolean),
      ),
    );
    const orphans = CAPTURES.map((c) => c.name).filter((n) => !cited.has(n) && !NOT_IN_GUIDES.has(n));
    expect(orphans).toEqual([]);
    const stale = [...NOT_IN_GUIDES].filter((n) => cited.has(n) || !CAPTURE_NAMES.has(n));
    expect(stale, "NOT_IN_GUIDES lista captura já citada ou inexistente").toEqual([]);
  });
});
