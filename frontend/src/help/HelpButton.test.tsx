import { cleanup, fireEvent, render, screen } from "@testing-library/react";
import { MemoryRouter, useNavigate } from "react-router-dom";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { Guide } from "@/help/guides";
import { HelpButton } from "./HelpButton";

const guidesMock = vi.hoisted(() => ({
  value: { guides: [] as unknown[] | undefined, isLoading: false, isError: false, refetch: () => {} },
  enabledArgs: [] as boolean[],
}));
vi.mock("@/help/guides", async (orig) => ({
  ...(await orig<typeof import("@/help/guides")>()),
  useGuides: (enabled: boolean) => {
    guidesMock.enabledArgs.push(enabled);
    return guidesMock.value;
  },
}));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => ({ roles: ["user"], profile: {} }) }));
const tourMock = vi.hoisted(() => ({ active: false }));
vi.mock("@/help/TourProvider", () => ({ useTour: () => ({ active: tourMock.active }) }));
vi.mock("@/help/GuideContent", () => ({ GuideContent: ({ body }: { body: string }) => <div>{body}</div> }));

function guide(over: Partial<Guide>): Guide {
  return {
    module: "primeiros-passos", slug: "a", title: "A", roles: ["user", "manager", "master_admin"],
    screens: [], order: 1, body: "corpo", searchText: "", ...over,
  } as Guide;
}
const GUIDES = [
  guide({ module: "comunicacao", slug: "videos", title: "Vídeos", screens: ["/meus-videos"], body: "Texto dos vídeos" }),
  guide({ module: "comunicacao", slug: "comunicados", title: "Comunicados", order: 2 }),
  guide({ slug: "como-comecar", title: "Como começar" }),
];

function Nav({ to }: { to: string }) {
  const navigate = useNavigate();
  return <button onClick={() => navigate(to)}>ir</button>;
}

function tree(url: string) {
  return (
    <MemoryRouter initialEntries={[url]}>
      <HelpButton />
      <Nav to="/comunicados" />
    </MemoryRouter>
  );
}

beforeEach(() => {
  guidesMock.value = { guides: GUIDES, isLoading: false, isError: false, refetch: () => {} };
  guidesMock.enabledArgs = [];
  tourMock.active = false;
});
afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe("HelpButton", () => {
  it("offers to reload the page when the guides fail to load", () => {
    const reload = vi.fn();
    vi.stubGlobal("location", { ...window.location, reload });
    guidesMock.value = { guides: undefined, isLoading: false, isError: true, refetch: () => {} };
    render(tree("/meus-videos"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(screen.getByText(/Se o TalentHS foi atualizado, recarregue a página/)).toBeTruthy();
    fireEvent.click(screen.getByRole("button", { name: "Recarregar a página" }));
    expect(reload).toHaveBeenCalled();
  });

  it("has aria-label and data-tour, and loads guides only when opened", () => {
    render(tree("/meus-videos"));
    const btn = screen.getByRole("button", { name: "Ajuda desta tela" });
    expect(btn.getAttribute("data-tour")).toBe("help-button");
    expect(guidesMock.enabledArgs.every((e) => e === false)).toBe(true);
    fireEvent.click(btn);
    expect(guidesMock.enabledArgs.at(-1)).toBe(true);
  });

  it("shows the screen guide as main", async () => {
    render(tree("/meus-videos"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(await screen.findByText("Texto dos vídeos")).toBeTruthy();
    expect(screen.getByRole("heading", { name: "Vídeos" })).toBeTruthy();
    expect(screen.getByRole("link", { name: "Abrir a central de ajuda" }).getAttribute("href")).toBe("/ajuda");
  });

  it("falls back to the module list on a route without own guide", () => {
    render(tree("/videos/abc"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(screen.getByText("Guias de Comunicação")).toBeTruthy();
    expect(screen.getByRole("link", { name: "Comunicados" }).getAttribute("href")).toBe("/ajuda/comunicacao/comunicados");
  });

  it("falls back to Primeiros passos when no module matches", () => {
    render(tree("/rota-sem-modulo"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(screen.getByText("Primeiros passos")).toBeTruthy();
    expect(screen.getByRole("link", { name: "Como começar" })).toBeTruthy();
  });

  it("closes on route change", () => {
    render(tree("/meus-videos"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(screen.getByRole("dialog")).toBeTruthy();
    fireEvent.click(screen.getByText("ir"));
    expect(screen.queryByRole("dialog")).toBeNull();
  });

  it("closes when the tour becomes active", () => {
    const { rerender } = render(tree("/meus-videos"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    expect(screen.getByRole("dialog")).toBeTruthy();
    tourMock.active = true;
    rerender(tree("/meus-videos"));
    expect(screen.queryByRole("dialog")).toBeNull();
  });
});
