import { existsSync, readdirSync } from "node:fs";
import { join, resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { CAPTURES } from "../../scripts/captures.config";

const DIR = resolve(__dirname, "../../public/capturas");
const files = readdirSync(DIR).filter((f) => f.endsWith(".webp"));
const names = CAPTURES.map((c) => c.name);

describe("captures contract", () => {
  it("every capture name is kebab-case", () => {
    for (const name of names) expect(name).toMatch(/^[a-z0-9]+(-[a-z0-9]+)*$/);
  });

  it("capture names are unique", () => {
    expect(new Set(names).size).toBe(names.length);
  });

  it("every .webp in public/capturas has its entry in CAPTURES (no orphans)", () => {
    const orphans = files.filter((f) => !names.includes(f.replace(/\.webp$/, "")));
    expect(orphans).toEqual([]);
  });

  it("every capture in CAPTURES has been generated", () => {
    const missing = names.filter((n) => !existsSync(join(DIR, `${n}.webp`)));
    expect(missing).toEqual([]);
  });
});
