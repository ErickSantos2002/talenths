import { cleanup, render, screen } from "@testing-library/react";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { Guide } from "@/help/guides";
import HelpGuidePage from "./HelpGuidePage";

const guidesMock = vi.hoisted(() => ({
  value: { guides: [] as unknown[] | undefined, isLoading: false, isError: false, refetch: () => {} },
}));
vi.mock("@/help/guides", async (orig) => ({
  ...(await orig<typeof import("@/help/guides")>()),
  useGuides: () => guidesMock.value,
}));
const authMock = vi.hoisted(() => ({ value: { roles: ["user"], profile: {} } as Record<string, unknown> }));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => authMock.value }));
vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));
vi.mock("@/help/GuideContent", () => ({ GuideContent: ({ body }: { body: string }) => <div>{body}</div> }));

function guide(over: Partial<Guide>): Guide {
  return {
    module: "desempenho", slug: "a", title: "A", roles: ["user", "manager", "master_admin"],
    screens: [], order: 1, body: "corpo", searchText: "", ...over,
  } as Guide;
}
const GUIDES = [
  guide({ slug: "minha-avaliacao", title: "Minha Avaliação", body: "Texto da avaliação" }),
  guide({ slug: "meus-testes", title: "Meus Testes", order: 2 }),
  guide({ module: "administracao", slug: "videos-do-rh", title: "Vídeos do RH", roles: ["manager"] }),
];

function renderAt(url: string) {
  return render(
    <MemoryRouter initialEntries={[url]}>
      <Routes>
        <Route path="/ajuda/:module/:slug" element={<HelpGuidePage />} />
      </Routes>
    </MemoryRouter>,
  );
}

beforeEach(() => {
  guidesMock.value = { guides: GUIDES, isLoading: false, isError: false, refetch: () => {} };
  authMock.value = { roles: ["user"], profile: {} };
});
afterEach(cleanup);

describe("HelpGuidePage", () => {
  it("renders the guide, breadcrumb, siblings and document title", () => {
    renderAt("/ajuda/desempenho/minha-avaliacao");
    expect(screen.getByRole("heading", { level: 1, name: "Minha Avaliação" })).toBeTruthy();
    expect(screen.getByText("Texto da avaliação")).toBeTruthy();
    expect(screen.getByRole("link", { name: "Ajuda" }).getAttribute("href")).toBe("/ajuda");
    expect(screen.getByText("Mais sobre Desempenho")).toBeTruthy();
    expect(screen.getByRole("link", { name: "Meus Testes" }).getAttribute("href")).toBe("/ajuda/desempenho/meus-testes");
    expect(document.title).toBe("Minha Avaliação · Ajuda · TalentHS");
  });

  it("does not leak a guide of another role", () => {
    const before = document.title;
    renderAt("/ajuda/administracao/videos-do-rh");
    expect(screen.getByText("Guia não encontrado")).toBeTruthy();
    expect(screen.queryByText("Vídeos do RH")).toBeNull();
    expect(document.title).toBe(before);
    expect(screen.getByRole("link", { name: "Voltar para a Ajuda" }).getAttribute("href")).toBe("/ajuda");
  });

  it("shows not found for an unknown slug", () => {
    renderAt("/ajuda/desempenho/nao-existe");
    expect(screen.getByText("Guia não encontrado")).toBeTruthy();
  });
});
