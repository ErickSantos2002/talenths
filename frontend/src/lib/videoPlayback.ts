export function clampSeek(target: number, maxWatched: number, completed: boolean): number {
  return completed ? target : Math.min(target, maxWatched);
}

export function nextMaxWatched(prev: number, current: number): number {
  return Math.max(prev, current);
}
