import { format } from "date-fns";
import type { TourAdoptionRow } from "@/lib/api";
import { WELCOME_TOURS } from "./tours/welcome";

export type AdoptionStatus = "completed" | "in_progress" | "not_started";

export const STATUS_LABEL: Record<AdoptionStatus, string> = {
  completed: "Concluído",
  in_progress: "Em andamento",
  not_started: "Não começou",
};

export const AUDIENCE_LABEL: Record<TourAdoptionRow["audience"], string> = {
  collaborator: "Colaborador",
  manager: "Gestor",
};

// Filter value for people without a department; can't clash with a department name.
export const NO_DEPARTMENT = "__none__";
export const NO_DEPARTMENT_LABEL = "Sem departamento";

function departmentKey(row: TourAdoptionRow): string {
  return row.department ?? NO_DEPARTMENT;
}

/** Departments present in the rows, sorted, with "Sem departamento" last when someone has none. */
export function departmentOptions(rows: TourAdoptionRow[]): { value: string; label: string }[] {
  const names = [...new Set(rows.map((r) => r.department).filter((d): d is string => !!d))]
    .sort((a, b) => a.localeCompare(b, "pt-BR"));
  const options = names.map((name) => ({ value: name, label: name }));
  if (rows.some((r) => !r.department)) options.push({ value: NO_DEPARTMENT, label: NO_DEPARTMENT_LABEL });
  return options;
}

export function filterRows(
  rows: TourAdoptionRow[],
  f: { department: string | "all"; status: AdoptionStatus | "all" },
): TourAdoptionRow[] {
  return rows.filter(
    (r) =>
      (f.department === "all" || departmentKey(r) === f.department) &&
      (f.status === "all" || r.status === f.status),
  );
}

export function totals(
  rows: TourAdoptionRow[],
  department: string | "all",
): Record<AdoptionStatus, number> & { total: number } {
  const out = { total: 0, completed: 0, in_progress: 0, not_started: 0 };
  for (const r of filterRows(rows, { department, status: "all" })) {
    out.total += 1;
    out[r.status] += 1;
  }
  return out;
}

export function stepLabel(row: TourAdoptionRow): string {
  if (row.status !== "in_progress" || row.step == null) return "";
  return `Passo ${row.step + 1} de ${WELCOME_TOURS[row.audience].steps.length}`;
}

export function formatDate(iso: string | null): string {
  return iso ? format(new Date(iso), "dd/MM/yyyy") : "";
}

export function toCsv(rows: TourAdoptionRow[]): string {
  const header = ["Nome", "E-mail", "Departamento", "Tour", "Situação", "Passo", "Concluído em"];
  const lines = rows.map((r) => [
    r.name,
    r.email ?? "",
    r.department ?? NO_DEPARTMENT_LABEL,
    AUDIENCE_LABEL[r.audience],
    STATUS_LABEL[r.status],
    stepLabel(r),
    formatDate(r.completed_at),
  ]);
  const cell = (c: string) => `"${c.replace(/"/g, '""')}"`;
  return "﻿" + [header, ...lines].map((l) => l.map(cell).join(";")).join("\n");
}
