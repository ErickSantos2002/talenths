import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { TourProgress } from "@/lib/api";
import { WelcomeTourModal } from "./WelcomeTourModal";

const tourMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
const authMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
vi.mock("@/help/TourProvider", () => ({ useTour: () => tourMock.value }));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => authMock.value }));

const WELCOME = { id: "boas-vindas-colaborador", version: 1, steps: [{}, {}, {}, {}] };
const TITLE = "Bem-vindo ao TalentHS";

function progress(over: Partial<TourProgress> = {}): TourProgress {
  return {
    tour: WELCOME.id, version: 1, step: 0, started_at: null, completed_at: null,
    dismissed_at: null, invites_declined: 0, ...over,
  };
}

const beginWelcome = vi.fn();

function setTour(over: Record<string, unknown> = {}) {
  tourMock.value = {
    welcome: WELCOME, progress: null, loaded: true, active: false, prompted: false,
    beginWelcome, ...over,
  };
}

beforeEach(() => {
  beginWelcome.mockReset();
  authMock.value = { user: { id: "u1" }, profile: { id: "u1" }, roles: ["user"] };
  setTour();
});
afterEach(cleanup);

describe("WelcomeTourModal", () => {
  it("abre para quem ainda não concluiu, só com o botão Começar o tour", () => {
    render(<WelcomeTourModal />);
    expect(screen.getByText(TITLE)).toBeTruthy();
    expect(screen.getAllByRole("button").map((b) => b.textContent)).toEqual(["Começar o tour"]);
  });

  it("Começar o tour chama beginWelcome", () => {
    render(<WelcomeTourModal />);
    fireEvent.click(screen.getByRole("button", { name: "Começar o tour" }));
    expect(beginWelcome).toHaveBeenCalledTimes(1);
  });

  it("oferece continuar quando parou no meio", () => {
    setTour({ progress: progress({ step: 2, started_at: "2026-10-01T00:00:00Z" }) });
    render(<WelcomeTourModal />);
    fireEvent.click(screen.getByRole("button", { name: "Continuar de onde parou" }));
    expect(beginWelcome).toHaveBeenCalledTimes(1);
  });

  it("Esc não fecha", () => {
    render(<WelcomeTourModal />);
    fireEvent.keyDown(document.activeElement ?? document.body, { key: "Escape" });
    expect(screen.getByText(TITLE)).toBeTruthy();
  });

  it("aparece mesmo para quem dispensou ou recusou antes", () => {
    setTour({ progress: progress({ dismissed_at: "2026-10-01T00:00:00Z", invites_declined: 3 }) });
    render(<WelcomeTourModal />);
    expect(screen.getByText(TITLE)).toBeTruthy();
  });

  it.each([
    ["progresso não carregado", { loaded: false }],
    ["tour em andamento", { active: true }],
    ["já mostrado nesta entrada", { prompted: true }],
    ["tour concluído", { progress: progress({ completed_at: "2026-10-01T00:00:00Z" }) }],
  ])("fechado com %s", (_, over) => {
    setTour(over);
    render(<WelcomeTourModal />);
    expect(screen.queryByText(TITLE)).toBeNull();
  });

  it("fechado até o perfil (e os papéis) carregar", () => {
    authMock.value = { user: { id: "u1" }, profile: null, roles: [] };
    render(<WelcomeTourModal />);
    expect(screen.queryByText(TITLE)).toBeNull();
  });
});
