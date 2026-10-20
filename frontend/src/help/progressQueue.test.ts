import { describe, expect, it } from "vitest";
import { createProgressQueue } from "./progressQueue";

const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));

describe("createProgressQueue", () => {
  it("sends in push order even when first is slower", async () => {
    const q = createProgressQueue(() => "a");
    const order: number[] = [];
    q.push("a", async () => {
      await delay(30);
      order.push(1);
    });
    q.push("a", async () => {
      await delay(1);
      order.push(2);
    });
    await q.drain();
    expect(order).toEqual([1, 2]);
  });

  it("skips sends whose owner changed", async () => {
    let owner: string | undefined = "a";
    const q = createProgressQueue(() => owner);
    let called = false;
    q.push("b", () => delay(10));
    q.push("a", async () => {
      called = true;
    });
    owner = "b";
    await q.drain();
    expect(called).toBe(false);
  });

  it("a failing send does not block the next", async () => {
    const q = createProgressQueue(() => "a");
    let second = false;
    q.push("a", () => Promise.reject(new Error("rede")));
    q.push("a", async () => {
      second = true;
    });
    await q.drain();
    expect(second).toBe(true);
  });
});
