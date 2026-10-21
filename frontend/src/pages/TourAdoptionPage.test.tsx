import { cleanup, fireEvent, render, screen, waitFor, within } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { afterEach, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import type { TourAdoptionRow } from "@/lib/api";
import TourAdoptionPage from "./TourAdoptionPage";

vi.mock("@/components/AdminLayout", () => ({
  AdminLayout: ({ children }: { children: React.ReactNode }) => <div>{children}</div>,
}));

const apiMock = vi.hoisted(() => ({ adoption: vi.fn() }));
vi.mock("@/lib/api", async (orig) => ({
  ...(await orig<typeof import("@/lib/api")>()),
  tour: { adoption: apiMock.adoption },
}));

function row(over: Partial<TourAdoptionRow>): TourAdoptionRow {
  return {
    user_id: "u", name: "Pessoa", email: "p@x.com", department_id: "d1", department: "Comercial",
    audience: "collaborator", tour: "boas-vindas-colaborador", version: null, step: null,
    started_at: null, completed_at: null, status: "not_started", ...over,
  };
}

const ROWS = [
  row({ user_id: "1", name: "Ana Ribeiro", status: "completed", completed_at: "2026-10-05T15:00:00Z" }),
  row({ user_id: "2", name: "Bruno Carvalho", department: "Operações", status: "in_progress", step: 3 }),
  row({ user_id: "3", name: "Igor Almeida", status: "not_started" }),
];

function renderPage() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <TourAdoptionPage />
    </QueryClientProvider>,
  );
}

function card(label: string) {
  return screen.getByTestId(`total-${label}`);
}

beforeAll(() => {
  // Radix Select needs these in jsdom.
  Element.prototype.scrollIntoView = vi.fn();
  Element.prototype.hasPointerCapture = vi.fn(() => false);
  Element.prototype.releasePointerCapture = vi.fn();
});
beforeEach(() => apiMock.adoption.mockReset());
afterEach(cleanup);

describe("TourAdoptionPage", () => {
  it("renders the rows, the totals and the header anchor", async () => {
    apiMock.adoption.mockResolvedValue(ROWS);
    const { container } = renderPage();
    expect(await screen.findByText("Ana Ribeiro")).toBeInTheDocument();
    expect(screen.getByText("Bruno Carvalho")).toBeInTheDocument();
    expect(screen.getByText("Igor Almeida")).toBeInTheDocument();
    expect(screen.getByText(/^Passo 4 de \d+$/)).toBeInTheDocument();
    expect(screen.getByText("05/10/2026")).toBeInTheDocument();
    expect(container.querySelector('[data-tour="admin-tour-adoption"]')).toHaveTextContent("Adoção do tour");
    expect(card("total")).toHaveTextContent("3");
    expect(card("completed")).toHaveTextContent("1");
  });

  it("filtering by status shrinks the table and keeps the totals", async () => {
    apiMock.adoption.mockResolvedValue(ROWS);
    renderPage();
    await screen.findByText("Ana Ribeiro");
    const trigger = screen.getByRole("combobox", { name: "Situação" });
    fireEvent.keyDown(trigger, { key: "Enter" });
    const option = await screen.findByRole("option", { name: "Concluído" });
    fireEvent.keyDown(option, { key: "Enter" });
    await waitFor(() => expect(screen.queryByText("Bruno Carvalho")).not.toBeInTheDocument());
    const table = screen.getByRole("table");
    expect(within(table).getByText("Ana Ribeiro")).toBeInTheDocument();
    expect(within(table).queryByText("Igor Almeida")).not.toBeInTheDocument();
    expect(card("total")).toHaveTextContent("3");
    expect(card("in_progress")).toHaveTextContent("1");
  });

  it("shows an empty message when nothing matches", async () => {
    apiMock.adoption.mockResolvedValue([]);
    renderPage();
    expect(await screen.findByText("Ninguém nesta seleção.")).toBeInTheDocument();
  });

  it("on error offers to try again", async () => {
    apiMock.adoption.mockRejectedValueOnce(new Error("falhou")).mockResolvedValueOnce(ROWS);
    renderPage();
    const retry = await screen.findByRole("button", { name: "Tentar de novo" });
    fireEvent.click(retry);
    expect(await screen.findByText("Ana Ribeiro")).toBeInTheDocument();
  });
});
