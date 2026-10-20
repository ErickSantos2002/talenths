import { describe, it, expect, vi, afterEach } from "vitest";
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

  describe("relato aceito sem efeito (no-op do servidor)", () => {
    afterEach(() => {
      vi.useRealTimers();
    });

    function noopThen(second: { max_watched_s: number; completed: boolean }) {
      return vi
        .fn()
        .mockResolvedValueOnce({ max_watched_s: 597, completed: false })
        .mockResolvedValue(second);
    }

    it("flush do ended ignorado: tenta de novo ~5,5 s depois e conclui", async () => {
      vi.useFakeTimers();
      const send = noopThen({ max_watched_s: 600, completed: true });
      const { deps, reporter, state } = setup({ send });
      state.max = 600;
      await reporter.flush();
      expect(send).toHaveBeenCalledTimes(1);
      await vi.advanceTimersByTimeAsync(5400);
      expect(send).toHaveBeenCalledTimes(1);
      await vi.advanceTimersByTimeAsync(200);
      expect(send).toHaveBeenCalledTimes(2);
      expect(send).toHaveBeenLastCalledWith(600);
      expect(deps.onAccepted).toHaveBeenLastCalledWith({ max_watched_s: 600, completed: true });
    });

    it("a nova tentativa sai mesmo se um envio de saída já levou a posição", async () => {
      vi.useFakeTimers();
      const send = noopThen({ max_watched_s: 600, completed: true });
      const { deps, reporter, state } = setup({ send });
      state.max = 600;
      await reporter.flush();
      await reporter.flush(true);
      expect(deps.sendOnExit).toHaveBeenCalledWith(600);
      await vi.advanceTimersByTimeAsync(5500);
      expect(send).toHaveBeenCalledTimes(2);
    });

    it("tenta uma vez só", async () => {
      vi.useFakeTimers();
      const send = vi.fn().mockResolvedValue({ max_watched_s: 597, completed: false });
      const { reporter, state } = setup({ send });
      state.max = 600;
      await reporter.flush();
      await vi.advanceTimersByTimeAsync(30000);
      expect(send).toHaveBeenCalledTimes(2);
    });

    it("não tenta de novo depois do dispose", async () => {
      vi.useFakeTimers();
      const send = noopThen({ max_watched_s: 600, completed: true });
      const { reporter, state } = setup({ send });
      state.max = 600;
      await reporter.flush();
      reporter.dispose();
      await vi.advanceTimersByTimeAsync(10000);
      expect(send).toHaveBeenCalledTimes(1);
    });

    it("um envio novo cancela a tentativa pendente", async () => {
      vi.useFakeTimers();
      const send = vi
        .fn()
        .mockResolvedValueOnce({ max_watched_s: 597, completed: false })
        .mockResolvedValue({ max_watched_s: 610, completed: false });
      const { reporter, state } = setup({ send });
      state.max = 600;
      await reporter.flush();
      await vi.advanceTimersByTimeAsync(3000);
      state.max = 610;
      await reporter.flush();
      await vi.advanceTimersByTimeAsync(10000);
      expect(send).toHaveBeenCalledTimes(2);
      expect(send).toHaveBeenLastCalledWith(610);
    });

    it("não agenda nada quando o servidor aceitou a posição", async () => {
      vi.useFakeTimers();
      const { deps, reporter } = setup();
      await reporter.flush();
      await vi.advanceTimersByTimeAsync(10000);
      expect(deps.send).toHaveBeenCalledTimes(1);
    });
  });
});
