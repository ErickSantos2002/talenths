import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { act, cleanup, fireEvent, render } from "@testing-library/react";
import { toast } from "sonner";
import { MemoryRouter, useNavigate } from "react-router-dom";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { TourProvider, useTour } from "./TourProvider";
import type { ScreenTour, Tour } from "./tours/types";

const engineMock = vi.hoisted(() => ({ start: vi.fn(), stop: vi.fn() }));
vi.mock("./tourEngine", async (orig) => ({
  ...(await orig<typeof import("./tourEngine")>()),
  TourEngine: class {
    active = false;
    start(t: unknown, from: number) { this.active = true; engineMock.start(t, from); }
    stop() { this.active = false; engineMock.stop(); }
  },
}));
const apiMock = vi.hoisted(() => ({
  list: vi.fn(), complete: vi.fn(), advance: vi.fn(),
}));
vi.mock("@/lib/api", () => ({ tour: apiMock }));
vi.mock("@/contexts/AuthContext", () => ({ useAuth: () => ({ user: { id: "u1" }, roles: ["user"] }) }));
vi.mock("sonner", () => ({ toast: Object.assign(vi.fn(), { error: vi.fn(), dismiss: vi.fn() }) }));

let ctx: ReturnType<typeof useTour>;
function Probe() {
  ctx = useTour();
  const navigate = useNavigate();
  return <button onClick={() => navigate("/comunicados")}>ir</button>;
}

function mount() {
  const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  const spy = vi.spyOn(qc, "invalidateQueries");
  const utils = render(
    <QueryClientProvider client={qc}>
      <MemoryRouter initialEntries={["/meus-videos"]}>
        <TourProvider><Probe /></TourProvider>
      </MemoryRouter>
    </QueryClientProvider>,
  );
  return { ...utils, spy };
}

const step = (element: string) => ({ element, title: "t", text: "x" });
const screenTour = (...els: string[]): ScreenTour => ({
  id: "tela:videos", version: 1, screen: "/meus-videos", roles: ["user"], steps: els.map(step),
});
const welcomeCut: Tour = {
  id: "boas-vindas", version: 3, steps: [{ route: "/dashboard", title: "t", text: "x" }],
};

beforeEach(() => {
  vi.clearAllMocks();
  apiMock.list.mockResolvedValue([]);
  apiMock.complete.mockResolvedValue({});
  apiMock.advance.mockResolvedValue({});
});
afterEach(() => {
  cleanup();
  document.body.innerHTML = "";
});

function present(name: string) {
  const el = document.createElement("div");
  el.setAttribute("data-tour", name);
  // jsdom has no layout: fake one box so the element counts as visible.
  el.getClientRects = () => [{}] as unknown as DOMRectList;
  document.body.appendChild(el);
}

describe("TourProvider", () => {
  it("dismissWhatsNew completes the cut once and reloads progress", async () => {
    const { spy } = mount();
    await act(async () => ctx.dismissWhatsNew(welcomeCut));
    expect(apiMock.complete).toHaveBeenCalledTimes(1);
    expect(apiMock.complete).toHaveBeenCalledWith("boas-vindas", 3);
    expect(spy).toHaveBeenCalled();
    expect(engineMock.start).not.toHaveBeenCalled();
  });

  it("showScreenTour with nothing present only toasts", () => {
    mount();
    act(() => ctx.showScreenTour(screenTour("ausente")));
    expect(engineMock.start).not.toHaveBeenCalled();
    expect(toast).toHaveBeenCalledWith("Nada para mostrar nesta tela agora.");
  });

  it("showScreenTour starts with the present steps only", () => {
    present("aqui");
    mount();
    act(() => ctx.showScreenTour(screenTour("aqui", "ausente")));
    expect(engineMock.start).toHaveBeenCalledTimes(1);
    const [t, from] = engineMock.start.mock.calls[0];
    expect(t.steps.map((s: { element: string }) => s.element)).toEqual(["aqui"]);
    expect(from).toBe(0);
    expect(ctx.active).toBe(true);
  });

  it("viewWhatsNew of a screen cut with nothing present completes without running", async () => {
    mount();
    const cut: Tour = { id: "tela:videos", version: 2, steps: [step("ausente")] };
    await act(async () => ctx.viewWhatsNew(cut));
    expect(engineMock.start).not.toHaveBeenCalled();
    expect(apiMock.complete).toHaveBeenCalledWith("tela:videos", 2);
  });

  it("viewWhatsNew of a welcome cut starts it from 0", () => {
    mount();
    act(() => ctx.viewWhatsNew(welcomeCut));
    expect(engineMock.start).toHaveBeenCalledWith(welcomeCut, 0);
  });

  it("stops a screen tour when the pathname changes", () => {
    present("aqui");
    const { getByText } = mount();
    act(() => ctx.showScreenTour(screenTour("aqui")));
    expect(ctx.active).toBe(true);
    fireEvent.click(getByText("ir"));
    expect(engineMock.stop).toHaveBeenCalled();
    expect(ctx.active).toBe(false);
  });

  it("keeps the welcome tour running when the pathname changes", () => {
    const { getByText } = mount();
    act(() => ctx.viewWhatsNew(welcomeCut));
    engineMock.stop.mockClear();
    fireEvent.click(getByText("ir"));
    expect(engineMock.stop).not.toHaveBeenCalled();
    expect(ctx.active).toBe(true);
  });
});
