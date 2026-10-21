import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { renderHook, waitFor } from "@testing-library/react";
import { createElement, type ReactNode } from "react";
import { describe, it, expect, vi } from "vitest";
import {
  MODULES, findGuide, guidesFor, guidesForPath, normalize, searchGuides, useGuides, type Guide,
} from "./guides";
import { parseGuide } from "./guideParser";

const parserFlag = vi.hoisted(() => ({ failNext: false }));
vi.mock("./guideParser", async (orig) => {
  const real = await orig<typeof import("./guideParser")>();
  return {
    ...real,
    parseGuide: (path: string, raw: string) => {
      if (parserFlag.failNext) {
        parserFlag.failNext = false;
        throw new Error("falha simulada");
      }
      return real.parseGuide(path, raw);
    },
  };
});
import type { ScreenContext } from "./screens";

const P = "/src/help/guides/primeiros-passos/exemplo.md";

function raw(fields: Record<string, string>, body = "## Para que serve\n\nTexto.\n") {
  const base = {
    titulo: "Exemplo", modulo: "primeiros-passos", papeis: "[user]", telas: "[]", ordem: "1", ...fields,
  };
  return `---\n${Object.entries(base).map(([k, v]) => `${k}: ${v}`).join("\n")}\n---\n${body}`;
}

function guide(over: Partial<Guide> & { slug: string }): Guide {
  const title = over.title ?? over.slug;
  return {
    module: "primeiros-passos", title, roles: ["user", "manager", "master_admin"], screens: [], order: 1,
    body: "", searchText: normalize(title), ...over,
  };
}

const user: ScreenContext = { roles: ["user"], timeclockEnabled: false };
const manager: ScreenContext = { roles: ["manager"], timeclockEnabled: false };
const master: ScreenContext = { roles: ["master_admin"], timeclockEnabled: false };

describe("parseGuide", () => {
  it("accepts valid front matter and strips the YAML block from the body", () => {
    const g = parseGuide(P, raw({ titulo: "Minha Avaliação", telas: "[/minha-avaliacao]", papeis: "[user, manager]", ordem: "3" }));
    expect(g).toMatchObject({
      module: "primeiros-passos", slug: "exemplo", title: "Minha Avaliação",
      roles: ["user", "manager"], screens: ["/minha-avaliacao"], order: 3,
    });
    expect(g.body).toBe("## Para que serve\n\nTexto.\n");
    expect(g.searchText).toContain("minha avaliacao");
    expect(g.searchText).toContain("para que serve");
    expect(g.tour).toBeUndefined();
  });

  it("reads the optional screen tour id", () => {
    expect(parseGuide(P, raw({ tour: "tela-exemplo" })).tour).toBe("tela-exemplo");
  });

  it.each([
    ["unknown module", raw({ modulo: "inexistente" })],
    ["unknown role", raw({ papeis: "[user, chefe]" })],
    ["screen outside SCREENS", raw({ telas: "[/nao-existe]" })],
    ["module different from folder", raw({ modulo: "rh" })],
    ["no front matter", "## Só corpo\n"],
    ["tour id outside kebab-case", raw({ tour: "Tela_X" })],
    ["unknown field", raw({ extra: "x" })],
  ])("rejects %s with the path in the message", (_n, text) => {
    expect(() => parseGuide(P, text)).toThrow(P);
  });
});

describe("normalize", () => {
  it("strips diacritics and lowercases", () => {
    expect(normalize("Avaliação Ÿ")).toBe("avaliacao y");
  });
});

describe("MODULES", () => {
  it("keeps the agreed order", () => {
    expect(MODULES.map((m) => m.id)).toEqual([
      "primeiros-passos", "meu-espaco", "desempenho", "desenvolvimento", "comunicacao", "rh", "administracao",
    ]);
  });
});

describe("searchGuides", () => {
  const a = guide({ slug: "a", title: "Minha Avaliação", searchText: normalize("Minha Avaliação") });
  const b = guide({ slug: "b", title: "Outro", searchText: normalize("Outro\nfala da avaliacao e do ciclo"), order: 0 });
  const c = guide({ slug: "c", title: "Ciclo", searchText: normalize("Ciclo\nsem relação") });

  it("matches without accents or case", () => {
    expect(searchGuides([a, c], "AVALIACAO").map((g) => g.slug)).toEqual(["a"]);
  });
  it("requires every term", () => {
    expect(searchGuides([a, b, c], "avaliacao ciclo").map((g) => g.slug)).toEqual(["b"]);
  });
  it("puts title hits before body-only hits", () => {
    expect(searchGuides([b, a], "avaliacao").map((g) => g.slug)).toEqual(["a", "b"]);
  });
  it("returns [] for an empty query", () => {
    expect(searchGuides([a], "")).toEqual([]);
    expect(searchGuides([a], "   ")).toEqual([]);
  });
});

describe("guidesFor", () => {
  const admin = guide({ slug: "videos", roles: ["manager", "master_admin"], screens: ["/admin/videos"], module: "administracao" });
  const ponto = guide({ slug: "ponto", screens: ["/meu-ponto"], module: "rh" });
  const logs = guide({ slug: "logs", roles: ["manager", "master_admin"], screens: ["/admin/logs"], module: "administracao" });
  const all = [admin, ponto, logs];

  it("hides admin guides from collaborators", () => {
    expect(guidesFor(all, user).map((g) => g.slug)).not.toContain("videos");
  });
  it("shows the time clock guide only when enabled", () => {
    expect(guidesFor(all, user).map((g) => g.slug)).not.toContain("ponto");
    expect(guidesFor(all, { ...user, timeclockEnabled: true }).map((g) => g.slug)).toContain("ponto");
  });
  it("shows logs guide only to master_admin even if listed for manager", () => {
    expect(guidesFor(all, manager).map((g) => g.slug)).not.toContain("logs");
    expect(guidesFor(all, master).map((g) => g.slug)).toContain("logs");
  });
  it("orders by module, order, then title", () => {
    const x = guide({ slug: "x", title: "B", module: "rh", order: 2 });
    const y = guide({ slug: "y", title: "A", module: "rh", order: 2 });
    const z = guide({ slug: "z", title: "Z", module: "primeiros-passos", order: 9 });
    expect(guidesFor([x, y, z], user).map((g) => g.slug)).toEqual(["z", "y", "x"]);
  });
});

describe("guidesForPath and findGuide", () => {
  const generic = guide({ slug: "generic", module: "desempenho", screens: ["/minha-avaliacao"], order: 2 });
  const specific = guide({ slug: "specific", module: "desempenho", screens: ["/minha-avaliacao"], roles: ["user"], order: 5 });
  const modGuide = guide({ slug: "modulo", module: "comunicacao", screens: ["/meus-videos"] });
  const first = guide({ slug: "primeiro", module: "primeiros-passos" });
  const visible = [generic, specific, modGuide, first];

  it("returns screen guides, most specific role first", () => {
    const r = guidesForPath(visible, "/minha-avaliacao");
    expect(r.origin).toBe("screen");
    expect(r.main?.slug).toBe("specific");
    expect(r.others.map((g) => g.slug)).toEqual(["generic"]);
  });
  it("falls back to the module guides for a hidden screen", () => {
    const r = guidesForPath(visible, "/videos/abc");
    expect(r.origin).toBe("module");
    expect(r.main).toBeNull();
    expect(r.others.map((g) => g.slug)).toEqual(["modulo"]);
  });
  it("maps /meus-testes/... to desempenho and /admin/* to administracao", () => {
    expect(guidesForPath(visible, "/meus-testes/1/realizar").others.map((g) => g.slug)).toEqual(["generic", "specific"]);
    const adm = guide({ slug: "adm", module: "administracao", screens: ["/admin/logs"] });
    expect(guidesForPath([adm, first], "/admin/empresa")).toMatchObject({ origin: "module", others: [adm] });
  });
  it("falls back to first steps for unknown routes", () => {
    const r = guidesForPath(visible, "/qualquer-coisa");
    expect(r.origin).toBe("first-steps");
    expect(r.others.map((g) => g.slug)).toEqual(["primeiro"]);
  });
  it("findGuide finds by module and slug", () => {
    expect(findGuide(visible, "desempenho", "generic")).toBe(generic);
    expect(findGuide(visible, "rh", "generic")).toBeNull();
  });
});

describe("bundled guides", () => {
  it("all parse and include the welcome tour guide", async () => {
    const { RAW_GUIDES } = await import("./guidesBundle");
    const guides = Object.entries(RAW_GUIDES).map(([p, t]) => parseGuide(p, t));
    expect(guides.find((g) => g.slug === "o-tour-de-boas-vindas")?.module).toBe("primeiros-passos");
  });
});

describe("useGuides", () => {
  it("exposes refetch that recovers from a failed load", async () => {
    parserFlag.failNext = true;
    const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
    const wrapper = ({ children }: { children: ReactNode }) =>
      createElement(QueryClientProvider, { client }, children);
    const { result } = renderHook(() => useGuides(true), { wrapper });
    await waitFor(() => expect(result.current.isError).toBe(true));
    expect(typeof result.current.refetch).toBe("function");
    result.current.refetch();
    await waitFor(() => expect(result.current.guides?.length).toBeGreaterThan(0));
    expect(result.current.isError).toBe(false);
  });
});
