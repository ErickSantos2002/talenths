import { describe, it, expect, vi } from "vitest";
import { createProgressReporter } from "./videoProgressReporter";
import { ProgressRejected } from "./api";

function setup(overrides: Partial<Parameters<typeof createProgressReporter>[0]> = {}) {
  const state = { max: 12, completed: false };
  const deps = {
    getMax: () => state.max,
    isCompleted: () => state.completed,
    send: vi.fn().mockResolvedValue({ max_watched_s: 12, completed: false }),
    sendOnExit: vi.fn(),
    onAccepted: vi.fn(),
    onRejected: vi.fn(),
    onError: vi.fn(),
    ...overrides,
  };
  return { state, deps, reporter: createProgressReporter(deps) };
}

describe("createProgressReporter", () => {
  it("envia o máximo e não repete a mesma posição", async () => {
    const { deps, reporter, state } = setup();
    await reporter.flush();
    await reporter.flush();
    expect(deps.send).toHaveBeenCalledTimes(1);
    expect(deps.send).toHaveBeenCalledWith(12);
    state.max = 20;
    await reporter.flush();
    expect(deps.send).toHaveBeenCalledTimes(2);
  });

  it("não envia quando concluído", async () => {
    const { deps, reporter, state } = setup();
    state.completed = true;
    await reporter.flush();
    await reporter.flush(true);
    expect(deps.send).not.toHaveBeenCalled();
    expect(deps.sendOnExit).not.toHaveBeenCalled();
  });

  it("na saída usa o envio keepalive", async () => {
    const { deps, reporter } = setup();
    await reporter.flush(true);
    expect(deps.sendOnExit).toHaveBeenCalledWith(12);
    expect(deps.send).not.toHaveBeenCalled();
  });

  it("recusa do servidor devolve o máximo dele", async () => {
    const { deps, reporter } = setup({ send: vi.fn().mockRejectedValue(new ProgressRejected(5)) });
    await reporter.flush();
    expect(deps.onRejected).toHaveBeenCalledWith(5);
  });

  it("erro de rede permite nova tentativa da mesma posição", async () => {
    const send = vi.fn().mockRejectedValueOnce(new Error("rede")).mockResolvedValue({ max_watched_s: 12, completed: false });
    const { deps, reporter } = setup({ send });
    await reporter.flush();
    expect(deps.onError).toHaveBeenCalled();
    await reporter.flush();
    expect(send).toHaveBeenCalledTimes(2);
  });

  it("repassa o resultado aceito", async () => {
    const { deps, reporter } = setup();
    await reporter.flush();
    expect(deps.onAccepted).toHaveBeenCalledWith({ max_watched_s: 12, completed: false });
  });
});
