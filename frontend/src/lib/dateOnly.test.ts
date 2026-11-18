import { describe, expect, it } from "vitest";
import { formatDateOnly } from "./dateOnly";

describe("formatDateOnly", () => {
  it("mantém o dia da data pura", () => {
    expect(formatDateOnly("2026-11-01")).toBe("01/11/2026");
  });
  it("vazio para nulo", () => {
    expect(formatDateOnly(null)).toBe("");
  });
});
