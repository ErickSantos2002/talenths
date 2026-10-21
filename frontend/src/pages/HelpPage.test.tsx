import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { Guide } from "@/help/guides";
import HelpPage from "./HelpPage";

const tourMock = vi.hoisted(() => ({ value: {} as Record<string, unknown> }));
vi.mock("@/help/TourProvider", () => ({ useTour: () => tourMock.value }));
vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));

const guidesMock = vi.hoisted(() => ({
  value: { guides: [] as unknown[] | undefined, isLoading: false, isError: false, refetch: () => {} },
}));
vi.mock("@/help/guides", async (orig) => ({
  ...(await orig<typeof import("@/help/guides")>()),
  useGuides: () => guidesMock.value,
}));
const authMock = vi.hoisted(() => ({ value: { roles: ["user"], profile: {} } as Record<string, unknown> }));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => authMock.value }));

function guide(over: Partial<Guide>): Guide {
  return {
    module: "meu-espaco", slug: "guia", title: "Guia", roles: ["user", "manager", "master_admin"],
    screens: [], order: 1, body: "", searchText: "", ...over,
  } as Guide;
}
const GUIDES = [
  guide({ module: "primeiros-passos", slug: "tour", title: "O tour", searchText: "o tour" }),
  guide({ module: "desempenho", slug: "minha-avaliacao", title: "Minha Avaliação", searchText: "minha avaliacao" }),
  guide({ module: "desempenho", slug: "meus-testes", title: "Meus Testes", order: 2, searchText: "meus testes" }),
  guide({ module: "administracao", slug: "videos-do-rh", title: "Vídeos do RH", roles: ["manager"], searchText: "videos do rh" }),
];

function renderAt(url = "/ajuda") {
  return render(
    <MemoryRouter initialEntries={[url]}>
      <HelpPage />
    </MemoryRouter>,
  );
}

const WELCOME = { id: "welcome-collaborator", version: 1, steps: [{}, {}, {}, {}] };
const BUTTON = { name: "Fazer o tour de boas-vindas" };
const SEARCH = "Buscar na ajuda";

function setTour(over: Record<string, unknown> = {}) {
  tourMock.value = {
    welcome: WELCOME, progress: null, loaded: true, startWelcome: vi.fn(), ...over,
  };
}

beforeEach(() => {
  setTour();
  guidesMock.value = { guides: GUIDES, isLoading: false, isError: false, refetch: () => {} };
  authMock.value = { roles: ["user"], profile: {} };
});
afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe("HelpPage", () => {
  it("disables the tour button and hides the badge while not loaded", () => {
    setTour({ loaded: false });
    renderAt();
    const button = screen.getByRole("button", BUTTON) as HTMLButtonElement;
    expect(button.disabled).toBe(true);
    fireEvent.click(button);
    expect(tourMock.value.startWelcome as ReturnType<typeof vi.fn>).not.toHaveBeenCalled();
    expect(screen.queryByText("Você ainda não fez")).toBeNull();
  });

  it("enables the button and starts the welcome tour once loaded", () => {
    renderAt();
    const button = screen.getByRole("button", BUTTON) as HTMLButtonElement;
    expect(button.disabled).toBe(false);
    expect(screen.getByText("Você ainda não fez")).toBeTruthy();
    fireEvent.click(button);
    expect(tourMock.value.startWelcome as ReturnType<typeof vi.fn>).toHaveBeenCalledTimes(1);
  });

  it("keeps the tour button marked for the tour", () => {
    renderAt();
    expect(screen.getByRole("button", BUTTON).getAttribute("data-tour")).toBe("help-start-tour");
  });

  it("lists module cards in MODULES order and hides modules without visible guides", () => {
    renderAt();
    const titles = screen.getAllByRole("heading", { level: 2 }).map((h) => h.textContent);
    expect(titles).toEqual(["Primeiros passos", "Desempenho"]);
    expect(screen.queryByText("Administração")).toBeNull();
    expect(screen.queryByText("Vídeos do RH")).toBeNull();
    expect(screen.getByRole("link", { name: "Meus Testes" }).getAttribute("href")).toBe("/ajuda/desempenho/meus-testes");
  });

  it("shows the Administração card to a manager", () => {
    authMock.value = { roles: ["manager"], profile: {} };
    renderAt();
    expect(screen.getByText("Administração")).toBeTruthy();
  });

  it("searches accent-insensitively and announces the count politely", () => {
    renderAt();
    fireEvent.change(screen.getByLabelText(SEARCH), { target: { value: "avaliacao" } });
    expect(screen.getByRole("link", { name: /Minha Avaliação/ })).toBeTruthy();
    expect(screen.getByText("1 guia encontrado").closest("[aria-live]")?.getAttribute("aria-live")).toBe("polite");
    expect(screen.queryByText("Meus Testes")).toBeNull();
  });

  it("says nothing was found and the link clears the search", () => {
    renderAt();
    fireEvent.change(screen.getByLabelText(SEARCH), { target: { value: "zzzz" } });
    expect(screen.getByText("Nenhum guia encontrado")).toBeTruthy();
    fireEvent.click(screen.getByRole("link", { name: "Ver todos os guias" }));
    expect((screen.getByLabelText(SEARCH) as HTMLInputElement).value).toBe("");
    expect(screen.getByText("Meus Testes")).toBeTruthy();
  });

  it("has no count for an empty query", () => {
    renderAt();
    expect(screen.queryByText(/guias? encontrados?/)).toBeNull();
    expect(screen.queryByText(/Nenhum guia/)).toBeNull();
  });

  it("filters from ?busca= in the initial URL", () => {
    renderAt("/ajuda?busca=testes");
    expect((screen.getByLabelText(SEARCH) as HTMLInputElement).value).toBe("testes");
    expect(screen.getByText("1 guia encontrado")).toBeTruthy();
  });

  it("shows a skeleton while loading and a reload on error", () => {
    guidesMock.value = { guides: undefined, isLoading: true, isError: false, refetch: () => {} };
    const { container } = renderAt();
    expect(container.querySelector(".animate-pulse")).toBeTruthy();
    cleanup();
    const reload = vi.fn();
    vi.stubGlobal("location", { ...window.location, reload });
    guidesMock.value = { guides: undefined, isLoading: false, isError: true, refetch: () => {} };
    renderAt();
    expect(screen.getByText(/Se o TalentHS foi atualizado, recarregue a página/)).toBeTruthy();
    fireEvent.click(screen.getByRole("button", { name: "Recarregar a página" }));
    expect(reload).toHaveBeenCalled();
  });
});
