import { describe, it, expect } from "vitest";
import { clampSeek, nextMaxWatched } from "./videoPlayback";

describe("clampSeek", () => {
  it("puxa de volta avanço além do assistido", () => {
    expect(clampSeek(100, 40, false)).toBe(40);
    expect(clampSeek(20, 40, false)).toBe(20);
  });
  it("não limita quando já concluído", () => {
    expect(clampSeek(100, 40, true)).toBe(100);
  });
});

describe("nextMaxWatched", () => {
  it("só avança", () => {
    expect(nextMaxWatched(10, 15)).toBe(15);
    expect(nextMaxWatched(10, 5)).toBe(10);
  });
});
