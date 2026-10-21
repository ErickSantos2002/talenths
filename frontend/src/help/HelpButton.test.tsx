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
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => ({ roles: roleMock.roles, profile: {} }) }));
const tourMock = vi.hoisted(() => ({
  active: false,
  welcome: null as unknown,
  progress: null as unknown,
  progressAll: [] as unknown[],
  showScreenTour: vi.fn(),
  viewWhatsNew: vi.fn(),
  dismissWhatsNew: vi.fn(),
}));
vi.mock("@/help/TourProvider", () => ({ useTour: () => tourMock }));
const roleMock = vi.hoisted(() => ({ roles: ["user"] }));
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
  tourMock.welcome = null;
  tourMock.progress = null;
  tourMock.progressAll = [];
  roleMock.roles = ["user"];
  tourMock.showScreenTour.mockClear();
  tourMock.viewWhatsNew.mockClear();
  tourMock.dismissWhatsNew.mockClear();
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

  it("closes when a panel link points to the page already open", () => {
    render(tree("/ajuda"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    fireEvent.click(screen.getByRole("link", { name: "Abrir a central de ajuda" }));
    expect(screen.queryByRole("dialog")).toBeNull();
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    fireEvent.click(screen.getByRole("link", { name: "Como começar" }));
    expect(screen.queryByRole("dialog")).toBeNull();
  });

  it("closes when a guide link points to the guide's own page", () => {
    render(tree("/ajuda/primeiros-passos/como-comecar"));
    fireEvent.click(screen.getByRole("button", { name: "Ajuda desta tela" }));
    fireEvent.click(screen.getByRole("link", { name: "Como começar" }));
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

  describe("what's new and screen tour", () => {
    const WELCOME = {
      id: "boas-vindas-colaborador",
      version: 2,
      steps: [
        { target: "a", title: "A", body: "a" },
        { target: "b", title: "B", body: "b", since: 2 },
      ],
    };
    const done = (version: number) => ({ tour: WELCOME.id, version, step: 0, started_at: "2026-01-01", completed_at: "2026-01-02" });
    function setWelcome(version: number) {
      tourMock.welcome = WELCOME;
      tourMock.progress = done(version);
      tourMock.progressAll = [done(version)];
    }

    it("shows the dot and the block when the welcome tour has new steps", () => {
      setWelcome(1);
      render(tree("/dashboard"));
      expect(screen.getByText("(há novidades)")).toBeTruthy();
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      expect(screen.getByText("O que mudou")).toBeTruthy();
      expect(screen.getByText("O tour de boas-vindas ganhou 1 passo novo.")).toBeTruthy();
      fireEvent.click(screen.getByRole("button", { name: "Ver o que mudou" }));
      expect(tourMock.viewWhatsNew).toHaveBeenCalledTimes(1);
      expect((tourMock.viewWhatsNew.mock.calls[0][0] as { steps: unknown[] }).steps).toHaveLength(1);
      expect(screen.queryByRole("dialog")).toBeNull();
    });

    it("dismisses the what's new block", () => {
      setWelcome(1);
      render(tree("/dashboard"));
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      fireEvent.click(screen.getByRole("button", { name: "Dispensar" }));
      expect(tourMock.dismissWhatsNew).toHaveBeenCalledTimes(1);
      expect(screen.queryByRole("dialog")).toBeNull();
    });

    it("shows nothing when completed on the current version", () => {
      setWelcome(2);
      render(tree("/dashboard"));
      expect(screen.queryByText("(há novidades)")).toBeNull();
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      expect(screen.queryByText("O que mudou")).toBeNull();
    });

    it("offers the screen tour on /meu-pdi for a collaborator", () => {
      render(tree("/meu-pdi"));
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      fireEvent.click(screen.getByRole("button", { name: "Mostrar nesta tela" }));
      expect((tourMock.showScreenTour.mock.calls[0][0] as { id: string }).id).toBe("tela-meu-pdi");
      expect(screen.queryByRole("dialog")).toBeNull();
    });

    it("does not offer a screen tour on /dashboard", () => {
      render(tree("/dashboard"));
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      expect(screen.queryByRole("button", { name: "Mostrar nesta tela" })).toBeNull();
    });

    it("does not offer an admin screen tour to a collaborator", () => {
      render(tree("/admin/videos"));
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      expect(screen.queryByRole("button", { name: "Mostrar nesta tela" })).toBeNull();
    });

    it("does not offer the video tour on /meus-videos", () => {
      render(tree("/meus-videos"));
      fireEvent.click(screen.getByRole("button", { name: /Ajuda desta tela/ }));
      expect(screen.queryByRole("button", { name: "Mostrar nesta tela" })).toBeNull();
    });
  });
});
