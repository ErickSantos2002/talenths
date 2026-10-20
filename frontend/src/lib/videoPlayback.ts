export function clampSeek(target: number, maxWatched: number, completed: boolean): number {
  return completed ? target : Math.min(target, maxWatched);
}

export function nextMaxWatched(prev: number, current: number): number {
  return Math.max(prev, current);
}

// Natural playback advances well under this between timeupdate events; a bigger jump is a skip.
export const TIMEUPDATE_WINDOW_S = 2;

// Decides what a timeupdate means. Positions reached by a user seek are never credited
// (the seeking handler clamps them to max, so a seek can't ratchet the max forward).
export function acceptTimeUpdate(
  current: number,
  max: number,
  seeking: boolean,
): { max: number; snapTo: number | null } {
  if (seeking) return { max, snapTo: null };
  if (current > max + TIMEUPDATE_WINDOW_S) return { max, snapTo: max };
  return { max: nextMaxWatched(max, current), snapTo: null };
}
