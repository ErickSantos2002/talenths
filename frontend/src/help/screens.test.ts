import { describe, it, expect } from "vitest";
import appSource from "@/App.tsx?raw";
import { SCREENS, canOpen, menuSections, screenName, type ScreenContext } from "./screens";

const user: ScreenContext = { roles: ["user"], timeclockEnabled: false };
const manager: ScreenContext = { roles: ["manager"], timeclockEnabled: false };
const master: ScreenContext = { roles: ["master_admin"], timeclockEnabled: false };

const titles = (group: "main" | "company" | "personal", ctx: ScreenContext, sectionKey?: string) =>
  menuSections(group, ctx)
    .filter((s) => !sectionKey || s.section.key === sectionKey)
    .flatMap((s) => s.items.map((i) => i.menu!.title));

describe("screens", () => {
  it("user does not see company group", () => {
    expect(menuSections("company", user)).toEqual([]);
  });

  it("Logs only for master_admin", () => {
    expect(titles("company", master, "sistema")).toContain("Logs");
    expect(titles("company", manager, "sistema")).not.toContain("Logs");
  });

  it("Meu Ponto only with timeclock", () => {
    expect(titles("personal", user, "rh-pessoal")).not.toContain("Meu Ponto");
    expect(titles("personal", { ...user, timeclockEnabled: true }, "rh-pessoal")).toContain("Meu Ponto");
  });

  it("Ajuda is in main for everyone", () => {
    for (const ctx of [user, manager, master]) {
      expect(titles("main", ctx)).toEqual(["Apresentação", "Dashboard", "Ajuda"]);
    }
    expect(SCREENS.find((s) => s.path === "/ajuda")?.menu?.tour).toBe("menu-help");
  });

  it("menu order matches today", () => {
    expect(titles("personal", user)).toEqual([
      "Meu Perfil", "Nossa Cultura", "Regras Internas", "Calendário",
      "Minha Avaliação", "Meus Testes",
      "Minha Trilha", "Meu PDI", "Minha Universidade", "Workshops",
      "Comunicados", "Pesquisas", "Feedbacks", "Documentos", "Vídeos", "Bingo",
      "Minhas Ausências", "Meus Benefícios", "Meu Onboarding",
    ]);
  });

  it("tour anchors follow the URL", () => {
    expect(SCREENS.find((s) => s.path === "/meus-videos")?.menu?.tour).toBe("menu-meus-videos");
    expect(SCREENS.find((s) => s.path === "/admin/videos")?.menu?.tour).toBe("menu-admin-videos");
  });

  it("screenName resolves names", () => {
    expect(screenName("/meus-videos")).toBe("Vídeos");
    expect(screenName("/videos/:id")).toBe(SCREENS.find((s) => s.path === "/videos/:id")!.name);
  });

  it("every protected route in App.tsx is in SCREENS", () => {
    const routes = [...appSource.matchAll(/path="([^"]+)"\s+element=\{\s*<ProtectedRoute/g)].map((m) => m[1]);
    expect(routes.length).toBeGreaterThan(40);
    const known = SCREENS.map((s) => s.path);
    expect(routes.filter((r) => !known.includes(r))).toEqual([]);
    expect(known.filter((p) => p !== "/ajuda" && !routes.includes(p))).toEqual([]);
  });

  it("canOpen respects roles and requires", () => {
    expect(canOpen("/admin/colaboradores", user)).toBe(false);
    expect(canOpen("/admin/colaboradores", manager)).toBe(true);
    expect(canOpen("/admin/logs", manager)).toBe(false);
    expect(canOpen("/admin/logs", master)).toBe(true);
    expect(canOpen("/meu-ponto", user)).toBe(false);
    expect(canOpen("/meu-ponto", { ...user, timeclockEnabled: true })).toBe(true);
    expect(canOpen("/inexistente", master)).toBe(false);
  });
});
