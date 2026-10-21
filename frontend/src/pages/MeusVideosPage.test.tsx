import { cleanup, render, screen } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { MemoryRouter } from "react-router-dom";
import { afterEach, describe, expect, it, vi } from "vitest";
import type { MyVideo } from "@/lib/api";
import MeusVideosPage from "./MeusVideosPage";

vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));

const apiMock = vi.hoisted(() => ({ listMine: vi.fn() }));
vi.mock("@/lib/api", async (orig) => ({
  ...(await orig<typeof import("@/lib/api")>()),
  videos: { listMine: apiMock.listMine },
}));

function video(over: Partial<MyVideo>): MyVideo {
  return {
    id: "v", title: "Vídeo", description: null, duration_seconds: 90, status: "pendente",
    progress_pct: 0, due_at: null, completed_at: null, order: 1, ...over,
  };
}

function renderPage() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter>
        <MeusVideosPage />
      </MemoryRouter>
    </QueryClientProvider>,
  );
}

afterEach(cleanup);

describe("MeusVideosPage", () => {
  it("keeps the RH order and shows the RH number on required videos only", async () => {
    apiMock.listMine.mockResolvedValue({
      required: [
        video({ id: "a", title: "Missão", order: 1, status: "concluido", completed_at: "2026-10-01T10:00:00Z" }),
        video({ id: "c", title: "Responsabilidade", order: 3, status: "atrasado" }),
      ],
      library: [video({ id: "b", title: "Extra", order: 2 })],
    });
    renderPage();

    const titles = (await screen.findAllByTestId("my-video-title")).map((el) => el.textContent);
    expect(titles).toEqual(["Missão", "Responsabilidade", "Extra"]);
    expect(screen.getByText("1º")).toBeTruthy();
    expect(screen.getByText("3º")).toBeTruthy();
    expect(screen.queryByText("2º")).toBeNull();
  });
});
