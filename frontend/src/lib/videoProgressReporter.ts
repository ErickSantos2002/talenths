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

// The server ignores an advance reported < 5 s after the previous one. That is usually
// the pause/ended flush, and after `ended` nothing else would report, so a swallowed
// report gets one retry once the window has passed.
const NOOP_RETRY_MS = 5500;

// Sends the furthest watched position, skipping repeats. `exit` uses the keepalive
// path because the page may be gone before a normal request settles.
export function createProgressReporter(deps: ReporterDeps) {
  let lastSent = -1;
  let retryTimer: ReturnType<typeof setTimeout> | undefined;

  function cancelRetry() {
    clearTimeout(retryTimer);
    retryTimer = undefined;
  }

  async function flush(exit = false) {
    await report(exit, false);
  }

  async function report(exit: boolean, isRetry: boolean) {
    if (deps.isCompleted()) return;
    const position = deps.getMax();
    // The retry ignores the dedupe: an exit keepalive may have claimed the position
    // without us knowing whether it counted.
    if (!isRetry && position <= lastSent) return;
    lastSent = position;
    if (exit) {
      deps.sendOnExit(position);
      return;
    }
    cancelRetry();
    try {
      const result = await deps.send(position);
      if (!result.completed && result.max_watched_s < position) {
        lastSent = result.max_watched_s;
        if (!isRetry) retryTimer = setTimeout(() => void report(false, true), NOOP_RETRY_MS);
      }
      deps.onAccepted(result);
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

  return { flush, dispose: cancelRetry, resetLastSent: (v: number) => { lastSent = v; } };
}
