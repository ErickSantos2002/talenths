// Port of DocsHS's MotorDoTour. driver.js only draws the highlight and the
// popover; the walk is ours, one step at a time via `highlight`, because the
// native `steps` mode neither navigates through react-router nor waits for the
// new screen to load. Every guard below fixed a bug seen on screen in DocsHS.

import { driver, type Driver } from "driver.js";
import "driver.js/dist/driver.css";
import "./tour.css";

import type { Tour, TourStep } from "./tours/types";

export const ELEMENT_WAIT_MS = 3000;
export const SHORT_WAIT_MS = 400;

export interface PreparedTarget {
  element?: string;
  extraText?: string;
}

export interface EngineCallbacks {
  navigate: (route: string) => void;
  screenName: (route: string) => string;
  onShow: (step: number) => void;
  onComplete: () => void;
  onClose: (step: number) => void;
  prepare?: (element: string | undefined) => Promise<PreparedTarget>;
}

function twoFrames(): Promise<void> {
  return new Promise((resolve) => requestAnimationFrame(() => requestAnimationFrame(() => resolve())));
}

// driver.js writes title and description with innerHTML: escape everything
// first, only then turn `**x**` into <strong>, so no text becomes markup.
export function safeText(text: string): string {
  const escaped = text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
  return escaped.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
}

function selector(element: string): string {
  return `[data-tour="${CSS.escape(element)}"]`;
}

// The first VISIBLE match: on mobile the menu exists twice (the CSS-hidden
// sidebar and the drawer), and the first in the document is the hidden one.
function findVisible(element: string): Element | null {
  for (const el of document.querySelectorAll(selector(element))) {
    if (el.getClientRects().length > 0) return el;
  }
  return null;
}

function waitForElement(element: string, ms: number, cancelled: () => boolean): Promise<Element | null> {
  return new Promise((resolve) => {
    const found = findVisible(element);
    if (found) {
      resolve(found);
      return;
    }
    const timer = window.setTimeout(() => finish(null), ms);
    const observer = new MutationObserver(() => {
      if (cancelled()) finish(null);
      const el = findVisible(element);
      if (el) finish(el);
    });
    function finish(value: Element | null) {
      observer.disconnect();
      window.clearTimeout(timer);
      resolve(value);
    }
    observer.observe(document.body, { childList: true, subtree: true, attributes: true });
  });
}

export class TourEngine {
  private drv: Driver | null = null;
  private tour: Tour | null = null;
  private current = 0;
  // Each new step invalidates the previous wait (fast "Next" clicks while the
  // screen is loading).
  private generation = 0;
  private waiting = false;
  private keyboard = (e: KeyboardEvent) => {
    // driver.js handles Esc in `highlight` mode but not the arrows. Arrows
    // inside a field belong to the field.
    const target = e.target as HTMLElement | null;
    if (target && (target.isContentEditable || ["INPUT", "TEXTAREA", "SELECT"].includes(target.tagName))) return;
    if (e.key === "ArrowRight") this.next();
    else if (e.key === "ArrowLeft") this.previous();
  };

  constructor(private cb: EngineCallbacks) {}

  get active(): boolean {
    return this.tour !== null;
  }

  start(t: Tour, from = 0): void {
    this.stop();
    this.tour = t;
    this.drv = driver({
      animate: true,
      smoothScroll: true,
      allowClose: true,
      // A stray click outside the popover must not lose the tour.
      overlayClickBehavior: () => {},
      overlayColor: "rgb(0 0 0)",
      overlayOpacity: 0.55,
      stagePadding: 6,
      stageRadius: 8,
      popoverClass: "talenths-tour",
      // X and Esc land here (our own `destroy` does not go through this hook).
      onDestroyStarted: () => this.close(),
    });
    window.addEventListener("keydown", this.keyboard);
    void this.show(Math.min(Math.max(from, 0), t.steps.length - 1));
  }

  stop(): void {
    this.generation++;
    this.waiting = false;
    window.removeEventListener("keydown", this.keyboard);
    this.drv?.destroy();
    this.drv = null;
    this.tour = null;
  }

  private close() {
    const step = this.current;
    this.stop();
    this.cb.onClose(step);
  }

  private previous() {
    if (this.waiting || this.current === 0) return;
    void this.show(this.current - 1);
  }

  private next() {
    if (!this.tour || this.waiting) return;
    if (this.current >= this.tour.steps.length - 1) {
      this.stop();
      this.cb.onComplete();
    } else {
      void this.show(this.current + 1);
    }
  }

  private async show(index: number) {
    const tour = this.tour;
    const drv = this.drv;
    if (!tour || !drv) return;
    const generation = ++this.generation;
    const valid = () => generation === this.generation && this.drv === drv;
    this.current = index;
    const step = tour.steps[index];
    const startedAt = performance.now();
    // Until the new step shows, Next/Previous are ignored: an extra click
    // during the wait would skip a step.
    this.waiting = true;

    if (window.location.pathname !== step.route) {
      drv.highlight({
        popover: {
          title: safeText(`Abrindo ${this.cb.screenName(step.route)}…`),
          description: "",
          showButtons: ["close"],
          popoverClass: "talenths-tour talenths-tour-opening",
        },
      });
      this.cb.navigate(step.route);
      // The menu is on every screen: without waiting for the new screen to
      // mount, the menu item found would be the old screen's, which React
      // unmounts right after (the popover would jump to the center).
      await twoFrames();
      if (!valid()) return;
    }

    const prepared: PreparedTarget = this.cb.prepare
      ? await this.cb.prepare(step.element)
      : { element: step.element };
    if (!valid()) return;
    const element = prepared.element;

    // A short silent wait (the screen just opened may still be loading);
    // then the popover shows — centered if the element is missing — and the
    // wait continues up to ELEMENT_WAIT_MS.
    let el = element ? await waitForElement(element, SHORT_WAIT_MS, () => !valid()) : null;
    if (!valid()) return;
    this.waiting = false;
    this.render(drv, tour, index, step, prepared.extraText, el);
    this.cb.onShow(index);
    if (el || !element) return;
    const remaining = ELEMENT_WAIT_MS - (performance.now() - startedAt);
    el = remaining > 0 ? await waitForElement(element, remaining, () => !valid()) : null;
    if (el && valid()) this.render(drv, tour, index, step, prepared.extraText, el);
  }

  private render(drv: Driver, tour: Tour, index: number, step: TourStep, extraText: string | undefined, el: Element | null) {
    const isLast = index === tour.steps.length - 1;
    drv.highlight({
      element: el ?? undefined,
      disableActiveInteraction: !step.interact,
      popover: {
        title: safeText(step.title),
        description: this.description(tour, index, step, extraText),
        showButtons: ["previous", "next", "close"],
        disableButtons: index === 0 ? ["previous"] : [],
        showProgress: true,
        progressText: `${index + 1} de ${tour.steps.length}`,
        prevBtnText: "← Anterior",
        nextBtnText: isLast ? "Concluir" : "Próximo →",
        onNextClick: () => this.next(),
        onPrevClick: () => this.previous(),
        onCloseClick: () => this.close(),
      },
    });
  }

  private description(tour: Tour, index: number, step: TourStep, extraText: string | undefined): string {
    const following = tour.steps[index + 1];
    const paragraphs = [step.text];
    if (following && following.route !== step.route) {
      paragraphs.push(`Vamos para **${this.cb.screenName(following.route)}**.`);
    }
    if (extraText) paragraphs.push(extraText);
    return safeText(paragraphs.join("\n\n"))
      .split("\n\n")
      .map((p) => `<p>${p}</p>`)
      .join("");
  }
}
