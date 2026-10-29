import { describe, expect, it } from "vitest";
import { canManageStatus, reasonLabel, TERMINATION_REASONS } from "./termination";

describe("canManageStatus", () => {
  it("gerente desliga colaborador e gerente", () => {
    expect(canManageStatus(["manager"], ["user"], false)).toBe(true);
    expect(canManageStatus(["manager"], ["manager"], false)).toBe(true);
  });

  it("só administrador desliga administrador", () => {
    expect(canManageStatus(["manager"], ["master_admin"], false)).toBe(false);
    expect(canManageStatus(["master_admin"], ["master_admin"], false)).toBe(true);
  });

  it("ninguém desliga a si mesmo", () => {
    expect(canManageStatus(["master_admin"], ["master_admin"], true)).toBe(false);
    expect(canManageStatus(["manager"], ["manager"], true)).toBe(false);
  });

  it("colaborador comum não desliga ninguém", () => {
    expect(canManageStatus(["user"], ["user"], false)).toBe(false);
  });
});

describe("motivos", () => {
  it("tem os seis motivos com rótulo em português", () => {
    expect(TERMINATION_REASONS.map((r) => r.value)).toEqual([
      "resignation",
      "dismissal_without_cause",
      "dismissal_with_cause",
      "contract_end",
      "mutual_agreement",
      "other",
    ]);
    expect(reasonLabel("contract_end")).toBe("Fim de contrato ou de experiência");
    expect(reasonLabel("desconhecido")).toBe("");
  });
});
