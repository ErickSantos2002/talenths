import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import HelpPage from "./HelpPage";

const tourMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
vi.mock("@/help/TourProvider", () => ({ useTour: () => tourMock.value }));
vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));

const WELCOME = { id: "welcome-collaborator", version: 1, steps: [{}, {}, {}, {}] };
const BUTTON = { name: "Fazer o tour de boas-vindas" };

function setTour(over: Record<string, unknown> = {}) {
  tourMock.value = {
    welcome: WELCOME, progress: null, loaded: true, startWelcome: vi.fn(), ...over,
  };
}

beforeEach(() => setTour());
afterEach(cleanup);

describe("HelpPage", () => {
  it("disables the tour button and hides the badge while not loaded", () => {
    setTour({ loaded: false });
    render(<HelpPage />);
    const button = screen.getByRole("button", BUTTON) as HTMLButtonElement;
    expect(button.disabled).toBe(true);
    fireEvent.click(button);
    expect(tourMock.value.startWelcome as ReturnType<typeof vi.fn>).not.toHaveBeenCalled();
    expect(screen.queryByText("Você ainda não fez")).toBeNull();
  });

  it("enables the button and starts the welcome tour once loaded", () => {
    render(<HelpPage />);
    const button = screen.getByRole("button", BUTTON) as HTMLButtonElement;
    expect(button.disabled).toBe(false);
    expect(screen.getByText("Você ainda não fez")).toBeTruthy();
    fireEvent.click(button);
    expect(tourMock.value.startWelcome as ReturnType<typeof vi.fn>).toHaveBeenCalledTimes(1);
  });
});
