// frontend/scripts/captures.ts — `bun run capturas` (`-- --only nome1,nome2` para refazer só algumas).
//
// Fotografa as telas citadas nos guias da Ajuda com dado fictício e grava
// `public/capturas/<name>.webp` (tema claro, 1280×800, WebP 0.82).
//
// Não sobe nada sozinho. Antes, deixe de pé (cada um num terminal):
//
//   # 1. o banco das capturas (uma vez, ou para recriar do zero)
//   bash backend/scripts/captures-db.sh
//
//   # 2. o backend, de backend/, contra esse banco (a porta 8000 é de outro projeto)
//   DATABASE_URL=postgresql://erick:dev123@localhost:5432/talenths_capturas JWT_SECRET=dev-secret \
//   FRONTEND_URL=http://localhost:8091 UPLOADS_DIR=/tmp/talenths-uploads-capturas \
//   .venv/bin/python -m uvicorn app.main:app --port 8011
//
//   (O UPLOADS_DIR do backend tem de ser o mesmo CAPTURES_UPLOADS_DIR da semente —
//   os dois têm padrão /tmp/talenths-uploads-capturas: é lá que a semente grava o
//   MP4 do player da captura `video`.)
//
//   # 3. o frontend, apontado para esse backend
//   VITE_API_URL=http://localhost:8011 bun run --cwd frontend dev -- --port 8091 --strictPort
//
// O script então roda a semente (`backend/scripts/seed_captures.py`, que apaga
// e repovoa o banco), entra com cada conta pela tela de login, abre cada tela
// de `captures.config.ts`, espera a rede ficar ociosa, fotografa e converte o
// PNG em WebP no canvas do próprio Chrome.
//
// Pré-requisitos: Chrome e ffmpeg (com libx264 e drawtext, para o MP4 do player;
// sem ele a semente avisa e a captura `video` sai com o player vazio).
//
// Ambiente (opcional): CAPTURES_DATABASE_URL, CAPTURES_UPLOADS_DIR, TALENTHS_PYTHON (o Python com
// asyncpg e bcrypt — padrão backend/.venv/bin/python), CHROME (padrão
// /usr/bin/google-chrome), CAPTURES_PASSWORD.
//
// Depois de rodar: ABRA E OLHE cada imagem antes de commitar.

import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";

import { chromium, type Browser, type Page } from "playwright-core";

import { ACCOUNTS, CAPTURES, PASSWORD, type Account, type Ids } from "./captures.config";

const FRONTEND = resolve(import.meta.dir, "..");
const BACKEND = resolve(FRONTEND, "..", "backend");
const OUT = join(FRONTEND, "public", "capturas");
const API = "http://localhost:8011";
const APP = "http://localhost:8091";
const WIDTH = 1280;
const HEIGHT = 800;
const DB_URL = process.env.CAPTURES_DATABASE_URL ?? "postgresql://erick:dev123@localhost:5432/talenths_capturas";

function onlyArg(): string[] | undefined {
  const args = process.argv.slice(2);
  const i = args.findIndex((a) => a === "--only" || a.startsWith("--only="));
  if (i < 0) return undefined;
  const value = args[i].includes("=") ? args[i].split("=")[1] : args[i + 1];
  if (!value) throw new Error("--only precisa de nomes: --only dashboard,meus-videos");
  const names = value.split(",").map((s) => s.trim()).filter(Boolean);
  const unknown = names.filter((n) => !CAPTURES.some((c) => c.name === n));
  if (unknown.length) throw new Error(`Captura desconhecida: ${unknown.join(", ")}`);
  return names;
}

async function reachable(url: string): Promise<boolean> {
  try {
    return (await fetch(url, { signal: AbortSignal.timeout(3000) })).ok;
  } catch {
    return false;
  }
}

function seed(): Ids {
  if (!new URL(DB_URL).pathname.includes("capturas")) {
    throw new Error(`Recusado: a semente apaga o banco, e "${DB_URL}" não é um banco de capturas.`);
  }
  const python = process.env.TALENTHS_PYTHON ?? join(BACKEND, ".venv", "bin", "python");
  if (!existsSync(python)) {
    throw new Error(`Python não encontrado em ${python}: defina TALENTHS_PYTHON (a venv do backend).`);
  }
  const r = Bun.spawnSync([python, join(BACKEND, "scripts", "seed_captures.py")], {
    env: { ...process.env, CAPTURES_DATABASE_URL: DB_URL },
    stdout: "pipe",
    stderr: "pipe",
  });
  if (r.exitCode !== 0) throw new Error(`A semente falhou (${r.exitCode}):\n${r.stderr.toString()}`);
  // Avisos da semente (ex.: ffmpeg ausente) não podem sumir num run que "deu certo".
  const warnings = r.stderr.toString().trim();
  if (warnings) console.warn(warnings);
  return JSON.parse(r.stdout.toString().trim().split("\n").at(-1)!) as Ids;
}

/** O backend no ar tem de estar no banco que acabou de ser semeado. */
async function checkBackendUsesSeed() {
  const res = await fetch(`${API}/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email: ACCOUNTS.ana, password: PASSWORD }),
  });
  if (!res.ok) throw new Error(`O backend em ${API} não reconhece as contas da semente: ele está no banco das capturas?`);
}

async function toWebp(converter: Page, png: Buffer): Promise<Buffer> {
  const dataUrl = await converter.evaluate(async (b64) => {
    const img = new Image();
    img.src = `data:image/png;base64,${b64}`;
    await img.decode();
    const canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    canvas.getContext("2d")!.drawImage(img, 0, 0);
    return canvas.toDataURL("image/webp", 0.82);
  }, png.toString("base64"));
  if (!dataUrl.startsWith("data:image/webp")) throw new Error("O Chrome não gerou WebP.");
  return Buffer.from(dataUrl.split(",")[1], "base64");
}

/** Espera a rede ociosa; se não ficar, a foto sai assim mesmo, mas avisa — pode ter skeleton. */
async function waitIdle(page: Page, name: string, timeout: number) {
  try {
    await page.waitForLoadState("networkidle", { timeout });
  } catch {
    console.warn(`  WARN ${name}: a rede não ficou ociosa em ${timeout / 1000}s — confira a imagem.`);
  }
}

async function login(browser: Browser, account: Account): Promise<Page> {
  const context = await browser.newContext({
    viewport: { width: WIDTH, height: HEIGHT },
    deviceScaleFactor: 1,
    colorScheme: "light",
    locale: "pt-BR",
    timezoneId: "America/Sao_Paulo",
  });
  // next-themes lê "theme" do localStorage: claro, independentemente do sistema.
  await context.addInitScript(() => localStorage.setItem("theme", "light"));
  const page = await context.newPage();
  await page.goto(`${APP}/login`);
  await page.locator("#login-email").fill(ACCOUNTS[account]);
  await page.locator("#login-password").fill(PASSWORD);
  await page.locator('button[type="submit"]').click();
  await page.waitForURL((url) => !url.pathname.startsWith("/login"), { timeout: 15000 });
  return page;
}

async function main() {
  const only = onlyArg();
  for (const [name, url] of [["backend", `${API}/health`], ["frontend", `${APP}/login`]]) {
    if (!(await reachable(url))) {
      throw new Error(`O ${name} não respondeu em ${url}. Suba-o com os comandos do topo de scripts/captures.ts.`);
    }
  }
  console.log("Semeando o banco das capturas…");
  const ids = seed();
  await checkBackendUsesSeed();

  const browser = await chromium.launch({ executablePath: process.env.CHROME ?? "/usr/bin/google-chrome" });
  try {
    const converter = await (await browser.newContext()).newPage();
    mkdirSync(OUT, { recursive: true });
    const pages = new Map<Account, Page>();
    for (const capture of CAPTURES) {
      if (only && !only.includes(capture.name)) continue;
      if (!pages.has(capture.account)) pages.set(capture.account, await login(browser, capture.account));
      const page = pages.get(capture.account)!;
      await page.setViewportSize({ width: capture.width ?? WIDTH, height: capture.height ?? HEIGHT });
      await page.goto(`${APP}${capture.route(ids)}`);
      await waitIdle(page, capture.name, 10000);
      if (capture.click) {
        await page.locator(`[data-tour="${capture.click}"]`).first().click();
        await waitIdle(page, capture.name, 5000);
      }
      // Animações de entrada e skeletons terminam.
      await page.waitForTimeout(800);
      const webp = await toWebp(converter, await page.screenshot({ type: "png" }));
      writeFileSync(join(OUT, `${capture.name}.webp`), webp);
      console.log(`  ${capture.name}.webp (${Math.round(webp.length / 1024)} KB)`);
    }
  } finally {
    await browser.close();
  }
  console.log(`Pronto. Abra e olhe cada imagem em ${OUT} antes de commitar.`);
}

try {
  await main();
} catch (error) {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
}
