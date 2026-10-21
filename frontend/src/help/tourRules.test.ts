import { describe, expect, it } from "vitest";
import { asTour, audienceOf, mustTakeTour, resumeStep, screenTourFor, tourStatus, whatsNew } from "./tourRules";
import type { ScreenTour, Tour } from "./tours/types";
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

describe("mustTakeTour", () => {
  it("true sem progresso", () => expect(mustTakeTour(null)).toBe(true));
  it("true enquanto não concluiu, mesmo dispensado ou com recusas", () => {
    expect(mustTakeTour(prog({ started_at: "2026-10-02T10:00:00", step: 3 }))).toBe(true);
    expect(mustTakeTour(prog({ dismissed_at: "2026-10-02T10:00:00", invites_declined: 3 }))).toBe(true);
  });
  it("false depois de concluído", () =>
    expect(mustTakeTour(prog({ completed_at: "2026-10-02T10:00:00" }))).toBe(false));
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

describe("whatsNew", () => {
  const t2: Tour = {
    id: "welcome",
    version: 2,
    steps: [
      { route: "/", title: "old", text: "x" },
      { route: "/", title: "new", text: "x", since: 2 },
    ],
  };
  it("null sem progresso, sem conclusão ou já na versão", () => {
    expect(whatsNew(t2, null)).toBeNull();
    expect(whatsNew(t2, prog({ version: 1, completed_at: null }))).toBeNull();
    expect(whatsNew(t2, prog({ version: 2, completed_at: "2026-10-02T10:00:00" }))).toBeNull();
    expect(whatsNew(t2, prog({ version: 3, completed_at: "2026-10-02T10:00:00" }))).toBeNull();
  });
  it("devolve só os passos novos desde a versão concluída", () => {
    const r = whatsNew(t2, prog({ version: 1, completed_at: "2026-10-02T10:00:00" }));
    expect(r).toEqual({ id: "welcome", version: 2, steps: [t2.steps[1]] });
  });
  it("null se a versão subiu sem passo novo", () => {
    const t: Tour = { ...t2, steps: [t2.steps[0]] };
    expect(whatsNew(t, prog({ version: 1, completed_at: "2026-10-02T10:00:00" }))).toBeNull();
  });
});

describe("screenTourFor", () => {
  const st = (screen: string, roles: ScreenTour["roles"]): ScreenTour => ({
    id: `tela-${screen}`,
    version: 1,
    screen,
    roles,
    steps: [{ title: "a", text: "b" }],
  });
  const tours = [st("/admin/colaboradores", ["manager", "master_admin"]), st("/dashboard", ["user", "manager"])];
  it("acha pela tela exata e por papel em comum", () => {
    expect(screenTourFor(tours, "/dashboard", ["user"])?.id).toBe("tela-/dashboard");
    expect(screenTourFor(tours, "/admin/colaboradores", ["user", "master_admin"])?.id).toBe("tela-/admin/colaboradores");
  });
  it("null para tela nula, outro papel ou tela sem tour", () => {
    expect(screenTourFor(tours, null, ["user"])).toBeNull();
    expect(screenTourFor(tours, "/admin/colaboradores", ["user"])).toBeNull();
    expect(screenTourFor(tours, "/meu-perfil", ["user"])).toBeNull();
  });
});

describe("asTour", () => {
  it("vira Tour sem rota", () => {
    const s: ScreenTour = { id: "x", version: 3, screen: "/a", roles: ["user"], steps: [{ title: "a", text: "b" }] };
    expect(asTour(s)).toEqual({ id: "x", version: 3, steps: [{ title: "a", text: "b" }] });
  });
});
