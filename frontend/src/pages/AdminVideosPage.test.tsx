import { cleanup, fireEvent, render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { AdminVideo } from "@/lib/api";
import AdminVideosPage from "./AdminVideosPage";

vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));
vi.mock("@/components/videos/VideoDetailDialog", () => ({ VideoDetailDialog: () => null }));
vi.mock("@/components/videos/VideoFormDialog", () => ({ VideoFormDialog: () => null }));

const apiMock = vi.hoisted(() => ({ listAdmin: vi.fn(), move: vi.fn() }));
vi.mock("@/lib/api", async (orig) => ({
  ...(await orig<typeof import("@/lib/api")>()),
  videos: { listAdmin: apiMock.listAdmin, move: apiMock.move },
}));

function video(over: Partial<AdminVideo>): AdminVideo {
  return {
    id: "v", title: "Vídeo", duration_seconds: 90, due_days: null, archived_at: null,
    created_at: "2026-10-01T10:00:00Z", required_count: 28, completed_count: 0, overdue_count: 0,
    order: 1, ...over,
  };
}

function renderPage() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <AdminVideosPage />
    </QueryClientProvider>,
  );
}

beforeEach(() => {
  apiMock.listAdmin.mockResolvedValue([
    video({ id: "a", title: "Missão", order: 1 }),
    video({ id: "b", title: "Cultura", order: 2 }),
    video({ id: "x", title: "Antigo", order: null, archived_at: "2026-09-01T10:00:00Z" }),
  ]);
  apiMock.move.mockResolvedValue(undefined);
});
afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

describe("AdminVideosPage order", () => {
  it("moves a video with the arrows and disables them at the edges", async () => {
    renderPage();
    const downFirst = await screen.findByRole("button", { name: "Descer Missão" });
    expect((screen.getByRole("button", { name: "Subir Missão" }) as HTMLButtonElement).disabled).toBe(true);
    expect((screen.getByRole("button", { name: "Descer Cultura" }) as HTMLButtonElement).disabled).toBe(true);

    fireEvent.click(downFirst);
    await waitFor(() => expect(apiMock.move).toHaveBeenCalledWith("a", "down"));
    await waitFor(() => expect(apiMock.listAdmin).toHaveBeenCalledTimes(2));
  });

  it("shows no number and no arrows for an archived video", async () => {
    renderPage();
    await screen.findByText("Antigo");
    expect(screen.queryByRole("button", { name: "Subir Antigo" })).toBeNull();
    expect(screen.queryByRole("button", { name: "Descer Antigo" })).toBeNull();
  });
});
