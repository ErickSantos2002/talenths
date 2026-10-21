// Only loaded through `import()` in guides.ts, so the YAML parser stays out of the main bundle.
import { parse } from "yaml";
import { z } from "zod";

import { MODULES, normalize, type Guide, type ModuleId } from "./guides";
import { SCREENS } from "./screens";

const MODULE_IDS = MODULES.map((m) => m.id) as [ModuleId, ...ModuleId[]];
const SCREEN_PATHS = new Set(SCREENS.map((s) => s.path));

const frontMatterSchema = z
  .object({
    titulo: z.string().min(1),
    modulo: z.enum(MODULE_IDS),
    papeis: z.array(z.enum(["master_admin", "manager", "user"])).min(1),
    telas: z.array(z.string().refine((p) => SCREEN_PATHS.has(p), "tela fora de SCREENS")),
    ordem: z.number().int(),
    // Id of the screen tour that "Mostrar nesta tela" starts from this guide.
    tour: z.string().regex(/^[a-z0-9-]{1,64}$/).optional(),
  })
  .strict();

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
    tour: fm.tour,
    body,
    searchText: normalize(`${fm.titulo}\n${plainText(body)}`),
  };
}

