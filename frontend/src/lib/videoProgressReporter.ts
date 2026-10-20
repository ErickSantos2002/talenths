import { ProgressRejected } from "./api";

type ReporterDeps = {
  getMax: () => number;
  isCompleted: () => boolean;
  send: (position: number) => Promise<{ max_watched_s: number; completed: boolean }>;
  sendOnExit: (position: number) => void;
  onAccepted: (result: { max_watched_s: number; completed: boolean }) => void;
  onRejected: (maxWatched: number) => void;
  onError?: (error: unknown) => void;
};

// Sends the furthest watched position, skipping repeats. `exit` uses the keepalive
// path because the page may be gone before a normal request settles.
export function createProgressReporter(deps: ReporterDeps) {
  let lastSent = -1;

  async function flush(exit = false) {
    if (deps.isCompleted()) return;
    const position = deps.getMax();
    if (position <= lastSent) return;
    lastSent = position;
    if (exit) {
      deps.sendOnExit(position);
      return;
    }
    try {
      deps.onAccepted(await deps.send(position));
    } catch (e) {
      if (e instanceof ProgressRejected) {
        lastSent = e.maxWatched;
        deps.onRejected(e.maxWatched);
      } else {
        // Allow a retry of the same position on the next tick.
        lastSent = -1;
        deps.onError?.(e);
      }
    }
  }

  return { flush, resetLastSent: (v: number) => { lastSent = v; } };
}
