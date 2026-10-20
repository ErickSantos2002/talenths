import { describe, it, expect } from "vitest";
import { acceptTimeUpdate, clampSeek, nextMaxWatched } from "./videoPlayback";

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

describe("acceptTimeUpdate", () => {
  it("credita avanço normal", () => {
    expect(acceptTimeUpdate(11, 10, false)).toEqual({ max: 11, snapTo: null });
    expect(acceptTimeUpdate(5, 10, false)).toEqual({ max: 10, snapTo: null });
  });
  it("salto sem seeking volta ao máximo", () => {
    expect(acceptTimeUpdate(50, 10, false)).toEqual({ max: 10, snapTo: 10 });
  });
  it("ignora durante seeking", () => {
    expect(acceptTimeUpdate(11, 10, true)).toEqual({ max: 10, snapTo: null });
    expect(acceptTimeUpdate(50, 10, true)).toEqual({ max: 10, snapTo: null });
  });
});
