// Progress is saved at every step, in a serial queue: fast clicks must not let
// an older step arrive last. Each send carries its owner; after logout (or a
// different login) a late send would go out with someone else's token, so it
// is dropped. A failure never blocks the next send: at worst, resuming goes
// back a step or two.
export function createProgressQueue(getOwner: () => string | undefined) {
  let tail: Promise<unknown> = Promise.resolve();
  return {
    push(owner: string | undefined, send: () => Promise<unknown>): void {
      tail = tail
        .then(() => (getOwner() === owner ? send() : undefined))
        .catch(() => undefined);
    },
    drain(): Promise<void> {
      return tail.then(() => undefined);
    },
  };
}
