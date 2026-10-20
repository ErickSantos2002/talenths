import { cleanup, fireEvent, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { TourProgress } from "@/lib/api";
import { TourInvite } from "./TourInvite";

const tourMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
const authMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
vi.mock("@/help/TourProvider", () => ({ useTour: () => tourMock.value }));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => authMock.value }));
vi.mock("sonner", () => ({ toast: { error: vi.fn() } }));

const WELCOME = { id: "welcome-collaborator", version: 1, steps: [{}, {}, {}, {}] };

function progress(over: Partial<TourProgress> = {}): TourProgress {
  return {
    tour: WELCOME.id, version: 1, step: 0, started_at: null, completed_at: null,
    dismissed_at: null, invites_declined: 0, ...over,
  };
}

function setTour(over: Record<string, unknown> = {}) {
  tourMock.value = {
    welcome: WELCOME, progress: null, loaded: true, active: false,
    startWelcome: vi.fn(), declineInvite: vi.fn().mockResolvedValue(undefined),
    dismissInvite: vi.fn().mockResolvedValue(undefined), ...over,
  };
}

beforeEach(() => {
  sessionStorage.clear();
  authMock.value = { user: { id: "u1" }, profile: { id: "u1" }, roles: ["user"], loading: false };
  setTour();
});
afterEach(cleanup);

describe("TourInvite", () => {
  it("hidden while progress not loaded", () => {
    setTour({ loaded: false });
    render(<TourInvite />);
    expect(screen.queryByText("Conheça o TalentHS")).toBeNull();
  });

  it("hidden until the profile (and its roles) is loaded", () => {
    authMock.value = { user: { id: "u1" }, profile: null, roles: [], loading: false };
    render(<TourInvite />);
    expect(screen.queryByText("Conheça o TalentHS")).toBeNull();
  });

  it("shows Começar without progress", () => {
    render(<TourInvite />);
    expect(screen.getByText("Conheça o TalentHS")).toBeTruthy();
    fireEvent.click(screen.getByRole("button", { name: "Começar" }));
    expect((tourMock.value.startWelcome as ReturnType<typeof vi.fn>)).toHaveBeenCalled();
  });

  it("shows Continuar o tour when resumable", () => {
    setTour({ progress: progress({ step: 2, started_at: "2026-10-01T00:00:00Z" }) });
    render(<TourInvite />);
    fireEvent.click(screen.getByRole("button", { name: "Continuar o tour" }));
    expect((tourMock.value.startWelcome as ReturnType<typeof vi.fn>)).toHaveBeenCalled();
  });

  it("Agora não hides and declines", async () => {
    const { unmount } = render(<TourInvite />);
    fireEvent.click(screen.getByRole("button", { name: "Agora não" }));
    expect((tourMock.value.declineInvite as ReturnType<typeof vi.fn>)).toHaveBeenCalled();
    await waitFor(() => expect(screen.queryByText("Conheça o TalentHS")).toBeNull());
    unmount();
    render(<TourInvite />);
    expect(screen.queryByText("Conheça o TalentHS")).toBeNull();
  });

  it("Não mostrar mais calls dismissInvite", () => {
    render(<TourInvite />);
    fireEvent.click(screen.getByRole("button", { name: "Não mostrar mais" }));
    expect((tourMock.value.dismissInvite as ReturnType<typeof vi.fn>)).toHaveBeenCalled();
  });

  it("hidden after 3 declines", () => {
    setTour({ progress: progress({ invites_declined: 3 }) });
    render(<TourInvite />);
    expect(screen.queryByText("Conheça o TalentHS")).toBeNull();
  });

  it("hidden while tour active", () => {
    setTour({ active: true });
    render(<TourInvite />);
    expect(screen.queryByText("Conheça o TalentHS")).toBeNull();
  });
});
