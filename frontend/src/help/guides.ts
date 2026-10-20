import { useQuery } from "@tanstack/react-query";
import { parse } from "yaml";
import { z } from "zod";

import { SCREENS, canOpen, matchScreen, type AppRole, type Screen, type ScreenContext } from "./screens";

export const MODULES = [
  { id: "primeiros-passos", name: "Primeiros passos" },
  { id: "meu-espaco", name: "Meu Espaço" },
  { id: "desempenho", name: "Desempenho" },
  { id: "desenvolvimento", name: "Desenvolvimento" },
  { id: "comunicacao", name: "Comunicação" },
  { id: "rh", name: "RH" },
  { id: "administracao", name: "Administração" },
] as const;

export type ModuleId = (typeof MODULES)[number]["id"];

export interface Guide {
  module: ModuleId;
  /** File name without `.md`. */
  slug: string;
  title: string;
  roles: AppRole[];
  /** react-router patterns from SCREENS where the "?" opens this guide. */
  screens: string[];
  order: number;
  /** Markdown without the front matter. */
  body: string;
  /** Normalized title + plain body text, for search. */
  searchText: string;
}

const MODULE_IDS = MODULES.map((m) => m.id) as [ModuleId, ...ModuleId[]];
const SCREEN_PATHS = new Set(SCREENS.map((s) => s.path));

const frontMatterSchema = z
  .object({
    titulo: z.string().min(1),
    modulo: z.enum(MODULE_IDS),
    papeis: z.array(z.enum(["master_admin", "manager", "user"])).min(1),
    telas: z.array(z.string().refine((p) => SCREEN_PATHS.has(p), "tela fora de SCREENS")),
    ordem: z.number().int(),
  })
  .strict();

/** Lowercase, no diacritics: "Avaliação" -> "avaliacao". */
export function normalize(text: string): string {
  return text.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
}

function plainText(md: string): string {
  return md
    .replace(/!\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/[#*>|`_]/g, " ");
}

/** `path` is only used to locate the folder (module) and to report errors. */
export function parseGuide(path: string, raw: string): Guide {
  const fail = (why: string): never => {
    throw new Error(`${path}: ${why}`);
  };
  const location = /(?:^|\/)guides\/([a-z0-9-]+)\/([a-z0-9-]+)\.md$/.exec(path);
  if (!location) return fail("fora de guides/<modulo>/<guia>.md");
  const [, folder, slug] = location;

  const text = raw.replace(/\r\n/g, "\n");
  const block = /^---\n([\s\S]*?)\n---\n?/.exec(text);
  if (!block) return fail("sem front matter");

  let data: unknown;
  try {
    data = parse(block[1]);
  } catch (e) {
    return fail(`YAML inválido (${(e as Error).message})`);
  }
  const result = frontMatterSchema.safeParse(data);
  if (!result.success) {
    return fail(`front matter inválido (${result.error.issues.map((i) => `${i.path.join(".")}: ${i.message}`).join("; ")})`);
  }
  const fm = result.data;
  if (fm.modulo !== folder) return fail(`modulo "${fm.modulo}" difere da pasta "${folder}"`);

  const body = text.slice(block[0].length);
  return {
    module: fm.modulo,
    slug,
    title: fm.titulo,
    roles: fm.papeis,
    screens: fm.telas,
    order: fm.ordem,
    body,
    searchText: normalize(`${fm.titulo}\n${plainText(body)}`),
  };
}

const moduleIndex = (id: ModuleId) => MODULES.findIndex((m) => m.id === id);

function sortGuides(guides: Guide[]): Guide[] {
  return [...guides].sort(
    (a, b) =>
      moduleIndex(a.module) - moduleIndex(b.module) ||
      a.order - b.order ||
      a.title.localeCompare(b.title, "pt-BR"),
  );
}

/** Visible when the role is in `roles` and the person can open every screen. */
export function guidesFor(all: Guide[], ctx: ScreenContext): Guide[] {
  return sortGuides(
    all.filter((g) => g.roles.some((r) => ctx.roles.includes(r)) && g.screens.every((s) => canOpen(s, ctx))),
  );
}

/** Accent/case-insensitive; every term must appear; title hits come first. */
export function searchGuides(visible: Guide[], query: string): Guide[] {
  const terms = normalize(query).split(/\s+/).filter(Boolean);
  if (!terms.length) return [];
  const hits = sortGuides(visible.filter((g) => terms.every((t) => g.searchText.includes(t))));
  const inTitle = (g: Guide) => terms.every((t) => normalize(g.title).includes(t));
  return [...hits.filter(inTitle), ...hits.filter((g) => !inTitle(g))];
}

// Hidden screens (no section) inherit the module from the route prefix.
const HIDDEN_PREFIX_MODULE: Record<string, ModuleId> = {
  "meus-testes": "desempenho",
  videos: "comunicacao",
};

const SECTION_MODULE: Record<string, ModuleId> = {
  menu: "primeiros-passos",
  "meu-espaco": "meu-espaco",
  "desempenho-pessoal": "desempenho",
  "desenvolvimento-pessoal": "desenvolvimento",
  "comunicacao-pessoal": "comunicacao",
  "rh-pessoal": "rh",
};

function moduleOfScreen(screen: Screen): ModuleId | null {
  if (screen.path.startsWith("/admin/")) return "administracao";
  if (screen.section) return SECTION_MODULE[screen.section] ?? null;
  return HIDDEN_PREFIX_MODULE[screen.path.split("/")[1]] ?? null;
}

export function guidesForPath(
  visible: Guide[],
  pathname: string,
): { main: Guide | null; others: Guide[]; origin: "screen" | "module" | "first-steps" } {
  const screen = matchScreen(pathname);
  if (screen) {
    // Fewest roles first = the guide written most specifically for this reader.
    const onScreen = visible
      .filter((g) => g.screens.includes(screen.path))
      .sort((a, b) => a.roles.length - b.roles.length || a.order - b.order || moduleIndex(a.module) - moduleIndex(b.module));
    if (onScreen.length) return { main: onScreen[0], others: onScreen.slice(1), origin: "screen" };

    const module = moduleOfScreen(screen);
    const inModule = module ? sortGuides(visible.filter((g) => g.module === module)) : [];
    if (inModule.length) return { main: null, others: inModule, origin: "module" };
  }
  return {
    main: null,
    others: sortGuides(visible.filter((g) => g.module === "primeiros-passos")),
    origin: "first-steps",
  };
}

export function findGuide(visible: Guide[], module: string, slug: string): Guide | null {
  return visible.find((g) => g.module === module && g.slug === slug) ?? null;
}

async function loadGuides(): Promise<Guide[]> {
  const { RAW_GUIDES } = await import("./guidesBundle");
  return Object.entries(RAW_GUIDES).map(([path, raw]) => parseGuide(path, raw));
}

export function useGuides(enabled: boolean): { guides: Guide[] | undefined; isLoading: boolean; isError: boolean } {
  const query = useQuery({
    queryKey: ["help-guides"],
    queryFn: loadGuides,
    enabled,
    staleTime: Infinity,
    gcTime: Infinity,
  });
  return { guides: query.data, isLoading: query.isLoading, isError: query.isError };
}
