import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { partRanges, uploadVideoFile } from "./videoUpload";

const MP4_ERROR = "O arquivo enviado não é um MP4 válido.";
const SIZE_ERROR = "O arquivo excede o limite de 2 GB.";

class FakeXHR {
  static instances: FakeXHR[] = [];
  static plan: (xhr: FakeXHR) => number | "hang" = () => 204;
  method = "";
  url = "";
  headers: Record<string, string> = {};
  status = 0;
  responseText = "";
  body: Blob | null = null;
  aborted = false;
  upload: { onprogress: ((e: { loaded: number; lengthComputable: boolean }) => void) | null } = { onprogress: null };
  onload: (() => void) | null = null;
  onerror: (() => void) | null = null;
  onabort: (() => void) | null = null;
  open(method: string, url: string) { this.method = method; this.url = url; }
  setRequestHeader(k: string, v: string) { this.headers[k] = v; }
  send(body: Blob) {
    this.body = body;
    FakeXHR.instances.push(this);
    queueMicrotask(() => {
      const result = FakeXHR.plan(this);
      if (result === "hang" || this.aborted) return;
      this.upload.onprogress?.({ loaded: body.size, lengthComputable: true });
      this.status = result;
      this.onload?.();
    });
  }
  abort() { this.aborted = true; this.onabort?.(); }
}

function fileOf(size: number, type = "video/mp4"): File {
  return new File([new Uint8Array(size)], "v.mp4", { type });
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });
}

let fetchMock: ReturnType<typeof vi.fn>;

beforeEach(() => {
  FakeXHR.instances = [];
  FakeXHR.plan = () => 204;
  vi.stubGlobal("XMLHttpRequest", FakeXHR);
  fetchMock = vi.fn(async (url: string, init?: RequestInit) => {
    if (url.endsWith("/videos/uploads") && init?.method === "POST") {
      const { total_size } = JSON.parse(init.body as string);
      return json({ upload_id: "u-1", part_size: 4, parts: Math.ceil(total_size / 4) }, 201);
    }
    if (url.endsWith("/complete")) return json({ upload_id: "u-1", duration_seconds: 12.5, file_size: 10 });
    return new Response(null, { status: 204 });
  });
  vi.stubGlobal("fetch", fetchMock);
  localStorage.setItem("talenths_token", "tok");
});

afterEach(() => {
  vi.useRealTimers();
  vi.restoreAllMocks();
  vi.unstubAllGlobals();
  localStorage.clear();
});

describe("partRanges", () => {
  it("divide e a última parte leva o resto", () => {
    expect(partRanges(10, 4)).toEqual([[0, 4], [4, 8], [8, 10]]);
  });
  it("tamanho múltiplo exato não gera parte vazia", () => {
    expect(partRanges(8, 4)).toEqual([[0, 4], [4, 8]]);
  });
});

describe("uploadVideoFile", () => {
  const opts = () => ({ onProgress: vi.fn(), signal: new AbortController().signal });

  it("recusa não-MP4 sem chamar a API", async () => {
    await expect(uploadVideoFile(fileOf(10, "video/webm"), opts())).rejects.toThrow(MP4_ERROR);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it("recusa arquivo acima de 2 GB sem chamar a API", async () => {
    const big = { type: "video/mp4", size: 2 * 1024 ** 3 + 1 } as File;
    await expect(uploadVideoFile(big, opts())).rejects.toThrow(SIZE_ERROR);
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it("envia as partes com o part_size do servidor e conclui", async () => {
    const o = opts();
    const result = await uploadVideoFile(fileOf(10), o);
    expect(result).toEqual({ upload_id: "u-1", duration_seconds: 12.5 });
    const urls = FakeXHR.instances.map((x) => x.url).sort();
    expect(urls).toHaveLength(3);
    urls.forEach((u, i) => expect(u).toMatch(new RegExp(`/videos/uploads/u-1/parts/${i}$`)));
    const x = FakeXHR.instances[0];
    expect(x.method).toBe("PUT");
    expect(x.headers.Authorization).toBe("Bearer tok");
    expect(x.headers["Content-Type"]).toBe("application/octet-stream");
    expect(o.onProgress).toHaveBeenLastCalledWith(100);
  });

  it("tenta de novo parte que falhou", async () => {
    vi.useFakeTimers({ toFake: ["setTimeout"] });
    let calls = 0;
    FakeXHR.plan = () => (++calls === 1 ? 500 : 204);
    const p = uploadVideoFile(fileOf(10), opts());
    await vi.advanceTimersByTimeAsync(1000);
    await p;
    expect(FakeXHR.instances.length).toBe(4);
  });

  it("desiste após 3 tentativas e cancela o upload", async () => {
    FakeXHR.plan = () => 500;
    vi.useFakeTimers({ toFake: ["setTimeout"] });
    const p = expect(uploadVideoFile(fileOf(3), opts())).rejects.toThrow();
    await vi.advanceTimersByTimeAsync(5000);
    await p;
    expect(FakeXHR.instances.length).toBe(3);
    const del = fetchMock.mock.calls.find(([, i]) => i?.method === "DELETE");
    expect(del?.[0]).toMatch(/\/videos\/uploads\/u-1$/);
  });

  it("não repete parte recusada com 413", async () => {
    FakeXHR.plan = () => 413;
    await expect(uploadVideoFile(fileOf(3), opts())).rejects.toThrow();
    expect(FakeXHR.instances.length).toBe(1);
  });

  it("abort cancela os XHRs em andamento, não inicia novos e chama DELETE", async () => {
    FakeXHR.plan = () => "hang";
    const ac = new AbortController();
    const p = uploadVideoFile(fileOf(20), { onProgress: vi.fn(), signal: ac.signal });
    await vi.waitFor(() => expect(FakeXHR.instances.length).toBe(3));
    ac.abort();
    await expect(p).rejects.toThrow();
    expect(FakeXHR.instances.length).toBe(3);
    expect(FakeXHR.instances.every((x) => x.aborted)).toBe(true);
    const del = fetchMock.mock.calls.find(([, i]) => i?.method === "DELETE");
    expect(del?.[0]).toMatch(/\/videos\/uploads\/u-1$/);
  });

  it("falha permanente numa parte para as outras e só então faz DELETE", async () => {
    const events: string[] = [];
    FakeXHR.plan = (x) => (x.url.endsWith("/parts/0") ? 413 : "hang");
    const origAbort = FakeXHR.prototype.abort;
    vi.spyOn(FakeXHR.prototype, "abort").mockImplementation(function (this: FakeXHR) {
      origAbort.call(this);
      events.push("abort");
    });
    fetchMock.mockImplementation(async (url: string, init?: RequestInit) => {
      if (init?.method === "DELETE") { events.push("delete"); return new Response(null, { status: 204 }); }
      return json({ upload_id: "u-1", part_size: 4, parts: 5 }, 201);
    });
    await expect(uploadVideoFile(fileOf(20), opts())).rejects.toThrow();
    expect(FakeXHR.instances.length).toBe(3);
    expect(FakeXHR.instances.slice(1).every((x) => x.aborted)).toBe(true);
    expect(events.at(-1)).toBe("delete");
  });

  it("falha permanente de um worker tardio reporta o erro do servidor, não o cancelamento", async () => {
    FakeXHR.plan = (x) => {
      if (x.url.endsWith("/parts/2")) {
        x.responseText = JSON.stringify({ detail: "Parte maior que o permitido." });
        return 413;
      }
      return "hang";
    };
    fetchMock.mockImplementation(async (_u: string, init?: RequestInit) =>
      init?.method === "DELETE"
        ? new Response(null, { status: 204 })
        : json({ upload_id: "u-1", part_size: 4, parts: 5 }, 201));
    await expect(uploadVideoFile(fileOf(20), opts())).rejects.toThrow("Parte maior que o permitido.");
  });

  it("aceita type vazio quando o nome termina em .mp4", async () => {
    const f = new File([new Uint8Array(3)], "Video.MP4", { type: "" });
    await expect(uploadVideoFile(f, opts())).resolves.toBeDefined();
  });

  it("partRanges recusa part_size inválido", () => {
    expect(() => partRanges(10, 0)).toThrow();
  });
});
