import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { Tour } from "./tours/types";

interface FakePopover {
  title?: string;
  description?: string;
  nextBtnText?: string;
  progressText?: string;
  popoverClass?: string;
  onNextClick?: () => void;
  onPrevClick?: () => void;
  onCloseClick?: () => void;
}
interface FakeStep {
  element?: Element;
  popover?: FakePopover;
}

const fake = vi.hoisted(() => ({
  highlights: [] as FakeStep[],
  destroyed: 0,
}));

vi.mock("driver.js", () => ({
  driver: () => ({
    highlight: (step: FakeStep) => fake.highlights.push(step),
    destroy: () => {
      fake.destroyed++;
    },
  }),
}));
vi.mock("driver.js/dist/driver.css", () => ({}));
vi.mock("./tour.css", () => ({}));

import { SHORT_WAIT_MS, TourEngine, safeText, type EngineCallbacks } from "./tourEngine";

const last = () => fake.highlights[fake.highlights.length - 1];
const next = () => last().popover!.onNextClick!();

function addTarget(name: string) {
  const el = document.createElement("div");
  el.setAttribute("data-tour", name);
  el.setAttribute("data-visible", "");
  document.body.appendChild(el);
  return el;
}

function callbacks(over: Partial<EngineCallbacks> = {}): EngineCallbacks {
  return {
    navigate: vi.fn(),
    screenName: (route: string) => (route === "/meus-videos" ? "Vídeos" : "Início"),
    onShow: vi.fn(),
    onComplete: vi.fn(),
    onClose: vi.fn(),
    ...over,
  };
}

const tour = (steps: Tour["steps"]): Tour => ({ id: "welcome", version: 1, steps });

let engine: TourEngine | null = null;

beforeEach(() => {
  vi.useFakeTimers();
  vi.stubGlobal("requestAnimationFrame", (cb: FrameRequestCallback) => setTimeout(() => cb(0), 16));
  vi.spyOn(Element.prototype, "getClientRects").mockImplementation(function (this: Element) {
    return (this.hasAttribute("data-visible") ? [{}] : []) as unknown as DOMRectList;
  });
  vi.spyOn(Element.prototype, "getBoundingClientRect").mockImplementation(function (this: Element) {
    const s = this.hasAttribute("data-visible") ? 10 : 0;
    return { x: 0, y: 0, top: 0, left: 0, right: s, bottom: s, width: s, height: s, toJSON: () => ({}) } as DOMRect;
  });
  fake.highlights = [];
  fake.destroyed = 0;
  document.body.innerHTML = "";
  window.history.pushState({}, "", "/dashboard");
});

afterEach(() => {
  engine?.stop();
  engine = null;
  vi.useRealTimers();
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe("safeText", () => {
  it("safeText escapes html and bolds", () => {
    expect(safeText("<b>a</b> **B**")).toBe("&lt;b&gt;a&lt;/b&gt; <strong>B</strong>");
  });
});

describe("TourEngine", () => {
  it("navigates when step route differs from location", async () => {
    const cb = callbacks();
    engine = new TourEngine(cb);
    engine.start(tour([{ route: "/meus-videos", title: "V", text: "x" }]));
    expect(cb.navigate).toHaveBeenCalledWith("/meus-videos");
    expect(fake.highlights[0].popover!.title).toBe("Abrindo Vídeos…");
    expect(fake.highlights[0].popover!.popoverClass).toContain("talenths-tour-opening");
  });

  it("double next during wait does not skip", async () => {
    const cb = callbacks();
    engine = new TourEngine(cb);
    addTarget("a");
    engine.start(
      tour([
        { route: "/dashboard", element: "a", title: "S0", text: "x" },
        { route: "/dashboard", element: "b", title: "S1", text: "x" },
        { route: "/dashboard", element: "c", title: "S2", text: "x" },
      ]),
    );
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.title).toBe("S0");
    const nextOfStep0 = last().popover!.onNextClick!;
    nextOfStep0();
    nextOfStep0();
    await vi.advanceTimersByTimeAsync(100);
    addTarget("b");
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.title).toBe("S1");
    expect(fake.highlights.filter((h) => h.popover?.title === "S2")).toHaveLength(0);
    expect(cb.onShow).toHaveBeenLastCalledWith(1);
  });

  it("missing element shows centered after 400ms and repositions when it appears", async () => {
    engine = new TourEngine(callbacks());
    engine.start(tour([{ route: "/dashboard", element: "late", title: "L", text: "x" }]));
    await vi.advanceTimersByTimeAsync(SHORT_WAIT_MS - 1);
    expect(fake.highlights).toHaveLength(0);
    await vi.advanceTimersByTimeAsync(1);
    expect(fake.highlights).toHaveLength(1);
    expect(last().element).toBeUndefined();
    await vi.advanceTimersByTimeAsync(1500 - SHORT_WAIT_MS);
    const el = addTarget("late");
    await vi.advanceTimersByTimeAsync(0);
    expect(fake.highlights).toHaveLength(2);
    expect(last().element).toBe(el);
  });

  it("last step label and complete", async () => {
    const cb = callbacks();
    engine = new TourEngine(cb);
    engine.start(
      tour([
        { route: "/dashboard", title: "S0", text: "x" },
        { route: "/dashboard", title: "S1", text: "x" },
      ]),
    );
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.nextBtnText).toBe("Próximo →");
    next();
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.nextBtnText).toBe("Concluir");
    next();
    expect(cb.onComplete).toHaveBeenCalledTimes(1);
    expect(engine.active).toBe(false);
  });

  it("close reports current step", async () => {
    const cb = callbacks();
    engine = new TourEngine(cb);
    engine.start(
      tour([
        { route: "/dashboard", title: "S0", text: "x" },
        { route: "/dashboard", title: "S1", text: "x" },
        { route: "/dashboard", title: "S2", text: "x" },
      ]),
    );
    await vi.advanceTimersByTimeAsync(0);
    next();
    await vi.advanceTimersByTimeAsync(0);
    next();
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.title).toBe("S2");
    last().popover!.onCloseClick!();
    expect(cb.onClose).toHaveBeenCalledWith(2);
    expect(engine.active).toBe(false);
  });

  it('adds "Vamos para" when next step changes route', async () => {
    engine = new TourEngine(callbacks());
    engine.start(
      tour([
        { route: "/dashboard", title: "S0", text: "Olá" },
        { route: "/meus-videos", title: "S1", text: "x" },
      ]),
    );
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.description).toBe("<p>Olá</p><p>Vamos para <strong>Vídeos</strong>.</p>");
  });

  it("appends extraText from prepare and uses prepare().element as target", async () => {
    const mobile = addTarget("menu-mobile");
    const prepare = vi.fn(async () => ({ element: "menu-mobile", extraText: "Toque no **☰**." }));
    engine = new TourEngine(callbacks({ prepare }));
    engine.start(tour([{ route: "/dashboard", element: "menu-videos", title: "M", text: "Menu" }]));
    await vi.advanceTimersByTimeAsync(0);
    expect(prepare).toHaveBeenCalledWith("menu-videos");
    expect(last().element).toBe(mobile);
    expect(last().popover!.description).toBe("<p>Menu</p><p>Toque no <strong>☰</strong>.</p>");
  });

  it('progress text is "N de M"', async () => {
    engine = new TourEngine(callbacks());
    engine.start(
      tour([
        { route: "/dashboard", title: "S0", text: "x" },
        { route: "/dashboard", title: "S1", text: "x" },
        { route: "/dashboard", title: "S2", text: "x" },
      ]),
      1,
    );
    await vi.advanceTimersByTimeAsync(0);
    expect(last().popover!.progressText).toBe("2 de 3");
  });
});
