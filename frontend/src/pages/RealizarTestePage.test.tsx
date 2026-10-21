import { cleanup, render, screen, waitFor } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import RealizarTestePage from "./RealizarTestePage";

const api = vi.hoisted(() => ({ getForTaking: vi.fn(), start: vi.fn(), respond: vi.fn(), submit: vi.fn() }));
vi.mock("@/lib/api", () => ({ customTests: api }));
const toast = vi.hoisted(() => vi.fn());
vi.mock("@/hooks/use-toast", () => ({ useToast: () => ({ toast }) }));
vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));

const TEST = {
  id: "t1", title: "Normas internas", description: null, instructions: null, time_limit_min: null,
  max_attempts: null, scoring_mode: "auto",
  questions: [{
    id: "q1", order_index: 0, question_type: "single_choice", text: "Qual o horário?", is_required: true,
    points: 1, scale_min: null, scale_max: null, scale_labels: null,
    options: [{ id: "o1", order_index: 0, text: "8h" }],
  }],
};

function renderAt(url: string) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter initialEntries={[url]}>
        <Routes>
          <Route path="/meus-testes/:testId/realizar" element={<RealizarTestePage />} />
          <Route path="/meus-testes" element={<p>Lista de testes</p>} />
        </Routes>
      </MemoryRouter>
    </QueryClientProvider>,
  );
}

beforeEach(() => {
  Object.values(api).forEach((fn) => fn.mockReset());
  toast.mockReset();
});
afterEach(cleanup);

describe("RealizarTestePage", () => {
  it("shows the first question once the test loads", async () => {
    api.getForTaking.mockResolvedValue(TEST);
    api.start.mockResolvedValue({ id: "a1" });
    renderAt("/meus-testes/t1/realizar");
    expect(await screen.findByText("Qual o horário?")).toBeTruthy();
    expect(api.getForTaking).toHaveBeenCalledWith("t1");
  });

  it("goes back with an error when resuming a test that is no longer available", async () => {
    api.getForTaking.mockRejectedValue(new Error("Teste não encontrado"));
    renderAt("/meus-testes/t1/realizar?attempt=a1");
    expect(await screen.findByText("Lista de testes")).toBeTruthy();
    expect(toast).toHaveBeenCalledWith(expect.objectContaining({
      title: "Erro ao iniciar teste", description: "Teste não encontrado", variant: "destructive",
    }));
  });

  it("warns only once when both start and loading fail", async () => {
    api.getForTaking.mockRejectedValue(new Error("Teste não encontrado"));
    api.start.mockRejectedValue(new Error("Teste não encontrado"));
    renderAt("/meus-testes/t1/realizar");
    expect(await screen.findByText("Lista de testes")).toBeTruthy();
    await waitFor(() => expect(api.start).toHaveBeenCalled());
    await new Promise((r) => setTimeout(r, 20));
    expect(toast).toHaveBeenCalledTimes(1);
  });
});
