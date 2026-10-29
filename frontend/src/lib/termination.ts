import type { AppRole } from "@/help/screens";

export type TerminationReason =
  | "resignation"
  | "dismissal_without_cause"
  | "dismissal_with_cause"
  | "contract_end"
  | "mutual_agreement"
  | "other";

export const TERMINATION_REASONS: { value: TerminationReason; label: string }[] = [
  { value: "resignation", label: "Pedido de demissão" },
  { value: "dismissal_without_cause", label: "Demissão sem justa causa" },
  { value: "dismissal_with_cause", label: "Demissão por justa causa" },
  { value: "contract_end", label: "Fim de contrato ou de experiência" },
  { value: "mutual_agreement", label: "Acordo entre as partes" },
  { value: "other", label: "Outro" },
];

export function reasonLabel(value: string): string {
  return TERMINATION_REASONS.find((r) => r.value === value)?.label ?? "";
}

// Mesma regra do backend: gerente mexe em colaborador e gerente; administrador só por
// administrador; ninguém em si mesmo.
export function canManageStatus(actorRoles: AppRole[], targetRoles: AppRole[], isSelf: boolean): boolean {
  if (isSelf) return false;
  if (actorRoles.includes("master_admin")) return true;
  if (!actorRoles.includes("manager")) return false;
  return !targetRoles.includes("master_admin");
}
