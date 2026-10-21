import { describe, expect, it } from "vitest";
import type { TourAdoptionRow } from "@/lib/api";
import { WELCOME_TOURS } from "./tours/welcome";
import { NO_DEPARTMENT, STATUS_LABEL, filterRows, stepLabel, toCsv, totals } from "./tourAdoption";

function row(over: Partial<TourAdoptionRow>): TourAdoptionRow {
  return {
    user_id: "u", name: "Pessoa", email: "p@x.com", department_id: "d1", department: "Comercial",
    audience: "collaborator", tour: "boas-vindas-colaborador", version: null, step: null,
    started_at: null, completed_at: null, status: "not_started", ...over,
  };
}

const ROWS = [
  row({ user_id: "1", name: "Ana", department: "Comercial", status: "completed", completed_at: "2026-10-05T15:00:00Z" }),
  row({ user_id: "2", name: "Bruno", department: "Operações", status: "in_progress", step: 3 }),
  row({ user_id: "3", name: "Carla", department: "Comercial", status: "not_started" }),
  row({ user_id: "4", name: "Diego", department_id: null, department: null, status: "completed" }),
];

describe("STATUS_LABEL", () => {
  it("names the three situations", () => {
    expect(STATUS_LABEL).toEqual({
      completed: "Concluído", in_progress: "Em andamento", not_started: "Não começou",
    });
  });
});

describe("filterRows", () => {
  it("combines department and status", () => {
    const out = filterRows(ROWS, { department: "Comercial", status: "completed" });
    expect(out.map((r) => r.name)).toEqual(["Ana"]);
  });

  it("all/all keeps every row", () => {
    expect(filterRows(ROWS, { department: "all", status: "all" })).toHaveLength(4);
  });

  it("filters people without a department", () => {
    const out = filterRows(ROWS, { department: NO_DEPARTMENT, status: "all" });
    expect(out.map((r) => r.name)).toEqual(["Diego"]);
  });
});

describe("totals", () => {
  it("counts by status within the department only", () => {
    expect(totals(ROWS, "Comercial")).toEqual({ total: 2, completed: 1, in_progress: 0, not_started: 1 });
    expect(totals(ROWS, "all")).toEqual({ total: 4, completed: 2, in_progress: 1, not_started: 1 });
  });
});

describe("stepLabel", () => {
  it("is 1-based over the steps of the audience tour", () => {
    const m = WELCOME_TOURS.collaborator.steps.length;
    expect(stepLabel(row({ status: "in_progress", step: 0 }))).toBe(`Passo 1 de ${m}`);
    const g = WELCOME_TOURS.manager.steps.length;
    expect(stepLabel(row({ status: "in_progress", step: 3, audience: "manager" }))).toBe(`Passo 4 de ${g}`);
  });

  it("is empty when not in progress", () => {
    expect(stepLabel(row({ status: "completed", step: 5 }))).toBe("");
    expect(stepLabel(row({ status: "not_started" }))).toBe("");
  });
});

describe("toCsv", () => {
  it("has BOM, semicolons, escaped quotes and dd/mm/aaaa dates", () => {
    const csv = toCsv([
      row({ name: 'Ana "Aninha"', email: "ana@x.com", department: "Comercial", status: "completed",
            completed_at: "2026-10-05T15:00:00Z" }),
      row({ name: "Bruno", email: null, department: null, audience: "manager", status: "in_progress", step: 1 }),
    ]);
    expect(csv.startsWith("﻿")).toBe(true);
    const lines = csv.slice(1).split("\n");
    expect(lines[0]).toBe('"Nome";"E-mail";"Departamento";"Tour";"Situação";"Passo";"Concluído em"');
    expect(lines[1]).toBe('"Ana ""Aninha""";"ana@x.com";"Comercial";"Colaborador";"Concluído";"";"05/10/2026"');
    const g = WELCOME_TOURS.manager.steps.length;
    expect(lines[2]).toBe(`"Bruno";"";"Sem departamento";"Gestor";"Em andamento";"Passo 2 de ${g}";""`);
  });

  it("neutralizes values that a spreadsheet would run as a formula", () => {
    const csv = toCsv([
      row({ name: '=HYPERLINK("x")', email: "@evil", department: "-1+1" }),
      row({ name: "Carla", email: "carla@x.com" }),
    ]);
    const lines = csv.slice(1).split("\n");
    expect(lines[1].startsWith('"\'=HYPERLINK(""x"")";"\'@evil";"\'-1+1";')).toBe(true);
    expect(lines[2].startsWith('"Carla";"carla@x.com";"Comercial";')).toBe(true);
  });
});
