import { describe, expect, it } from "vitest";
import { MAX_INVITE_DECLINES, audienceOf, resumeStep, shouldInvite, tourStatus } from "./tourRules";
import type { Tour } from "./tours/types";
import type { TourProgress } from "@/lib/api";

const tour: Tour = {
  id: "welcome",
  version: 2,
  steps: Array.from({ length: 9 }, (_, i) => ({ route: "/", title: `t${i}`, text: "x" })),
};

const prog = (o: Partial<TourProgress> = {}): TourProgress => ({
  tour: "welcome",
  version: 2,
  step: 3,
  started_at: "2026-10-01T10:00:00",
  completed_at: null,
  dismissed_at: null,
  invites_declined: 0,
  ...o,
});

describe("resumeStep", () => {
  it("null sem progresso ou sem tour", () => {
    expect(resumeStep(null, tour)).toBeNull();
    expect(resumeStep(prog(), null)).toBeNull();
  });
  it("null se concluído", () => {
    expect(resumeStep(prog({ completed_at: "2026-10-02T10:00:00" }), tour)).toBeNull();
  });
  it("null se nunca iniciado", () => {
    expect(resumeStep(prog({ started_at: null }), tour)).toBeNull();
  });
  it("null se versão diferente", () => {
    expect(resumeStep(prog({ version: 1 }), tour)).toBeNull();
  });
  it("null se passo 0 ou além do fim", () => {
    expect(resumeStep(prog({ step: 0 }), tour)).toBeNull();
    expect(resumeStep(prog({ step: 9 }), tour)).toBeNull();
  });
  it("retorna o passo onde parou", () => {
    expect(resumeStep(prog(), tour)).toBe(3);
  });
});

describe("shouldInvite", () => {
  it("true sem progresso", () => expect(shouldInvite(null)).toBe(true));
  it("false se concluído, dispensado ou recusas no limite", () => {
    expect(shouldInvite(prog({ completed_at: "2026-10-02T10:00:00" }))).toBe(false);
    expect(shouldInvite(prog({ dismissed_at: "2026-10-02T10:00:00" }))).toBe(false);
    expect(shouldInvite(prog({ invites_declined: MAX_INVITE_DECLINES }))).toBe(false);
  });
  it("true com 2 recusas", () => expect(shouldInvite(prog({ invites_declined: 2 }))).toBe(true));
});

describe("audienceOf", () => {
  it("mapeia papéis", () => {
    expect(audienceOf(["user"])).toBe("collaborator");
    expect(audienceOf(["manager"])).toBe("manager");
    expect(audienceOf(["master_admin", "user"])).toBe("manager");
  });
});

describe("tourStatus", () => {
  it("concluído com data dd/MM/yyyy", () => {
    expect(tourStatus(prog({ completed_at: "2026-10-15T12:00:00" }), tour)).toEqual({ kind: "done", date: "15/10/2026" });
  });
  it("parado no passo exibido a partir de 1", () => {
    expect(tourStatus(prog({ step: 4 }), tour)).toEqual({ kind: "stopped", step: 5, total: 9 });
  });
  it("não iniciado", () => {
    expect(tourStatus(null, tour)).toEqual({ kind: "not-started" });
  });
});
