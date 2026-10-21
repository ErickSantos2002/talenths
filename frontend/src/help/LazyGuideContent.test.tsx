import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";

vi.mock("./GuideContent", () => {
  throw new Error("Failed to fetch dynamically imported module");
});

import { LazyGuideContent } from "./LazyGuideContent";

afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe("LazyGuideContent", () => {
  it("offers to reload the page when the chunk fails to import", async () => {
    vi.spyOn(console, "error").mockImplementation(() => {});
    const reload = vi.fn();
    vi.stubGlobal("location", { ...window.location, reload });
    render(<LazyGuideContent body="x" />);
    expect(await screen.findByText(/Se o TalentHS foi atualizado, recarregue a página/)).toBeTruthy();
    fireEvent.click(screen.getByRole("button", { name: "Recarregar a página" }));
    expect(reload).toHaveBeenCalled();
  });
});
