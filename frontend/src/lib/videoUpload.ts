import { BASE_URL, getToken, videos } from "./api";

const MAX_FILE_SIZE = 2 * 1024 ** 3;
const PARALLEL_PARTS = 3;
const MAX_ATTEMPTS = 3;
const RETRY_DELAY_MS = 500;

const NOT_MP4 = "O arquivo enviado não é um MP4 válido.";
const TOO_BIG = "O arquivo excede o limite de 2 GB.";

export function partRanges(size: number, partSize: number): Array<[number, number]> {
  if (!(partSize > 0)) throw new Error("Tamanho de parte inválido.");
  const ranges: Array<[number, number]> = [];
  for (let start = 0; start < size; start += partSize) {
    ranges.push([start, Math.min(start + partSize, size)]);
  }
  return ranges;
}

class PartError extends Error {
  constructor(message: string, public retryable: boolean) {
    super(message);
  }
}

function abortError() {
  return new DOMException("Envio cancelado.", "AbortError");
}

function backoff(ms: number, signal: AbortSignal): Promise<void> {
  return new Promise((resolve, reject) => {
    if (signal.aborted) return reject(abortError());
    const onAbort = () => {
      clearTimeout(timer);
      reject(abortError());
    };
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", onAbort);
      resolve();
    }, ms);
    signal.addEventListener("abort", onAbort, { once: true });
  });
}

function putPart(
  uploadId: string,
  index: number,
  blob: Blob,
  signal: AbortSignal,
  onLoaded: (loaded: number) => void,
): Promise<void> {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    const onAbort = () => xhr.abort();
    const done = () => signal.removeEventListener("abort", onAbort);
    xhr.open("PUT", `${BASE_URL}/videos/uploads/${uploadId}/parts/${index}`);
    const token = getToken();
    if (token) xhr.setRequestHeader("Authorization", `Bearer ${token}`);
    xhr.setRequestHeader("Content-Type", "application/octet-stream");
    xhr.upload.onprogress = (e) => onLoaded(e.loaded);
    xhr.onload = () => {
      done();
      if (xhr.status >= 200 && xhr.status < 300) return resolve();
      let detail = `HTTP ${xhr.status}`;
      try {
        detail = JSON.parse(xhr.responseText).detail ?? detail;
      } catch { /* corpo sem JSON */ }
      // Só 5xx é tratado como transitório; 4xx (incluindo 401 e 413) falha na hora.
      reject(new PartError(detail, xhr.status >= 500));
    };
    xhr.onerror = () => {
      done();
      reject(new PartError("Falha de conexão no envio do vídeo.", true));
    };
    xhr.onabort = () => {
      done();
      reject(abortError());
    };
    if (signal.aborted) return reject(abortError());
    signal.addEventListener("abort", onAbort, { once: true });
    xhr.send(blob);
  });
}

export async function uploadVideoFile(
  file: File,
  opts: { onProgress: (pct: number) => void; signal: AbortSignal },
): Promise<{ upload_id: string; duration_seconds: number }> {
  // Alguns navegadores/SO entregam type vazio para .mp4; o servidor valida os bytes de qualquer forma.
  const looksMp4 = file.type === "video/mp4" || (file.type === "" && /\.mp4$/i.test(file.name ?? ""));
  if (!looksMp4) throw new Error(NOT_MP4);
  if (file.size > MAX_FILE_SIZE) throw new Error(TOO_BIG);

  const { onProgress } = opts;
  const internal = new AbortController();
  const signal = internal.signal;
  const relay = () => internal.abort();
  if (opts.signal.aborted) relay();
  else opts.signal.addEventListener("abort", relay, { once: true });
  const { upload_id, part_size } = await videos.start(file.size);
  const ranges = partRanges(file.size, part_size);
  const confirmed = new Array<number>(ranges.length).fill(0);
  const inFlight = new Array<number>(ranges.length).fill(0);
  const report = () => {
    const sum = confirmed.reduce((a, b) => a + b, 0) + inFlight.reduce((a, b) => a + b, 0);
    onProgress(Math.min(100, Math.floor((sum / file.size) * 100)));
  };

  const sendPart = async (i: number) => {
    const [start, end] = ranges[i];
    for (let attempt = 1; ; attempt++) {
      try {
        await putPart(upload_id, i, file.slice(start, end), signal, (loaded) => {
          inFlight[i] = loaded;
          report();
        });
        inFlight[i] = 0;
        confirmed[i] = end - start;
        report();
        return;
      } catch (e) {
        inFlight[i] = 0;
        if (signal.aborted || !(e instanceof PartError) || !e.retryable || attempt >= MAX_ATTEMPTS) throw e;
        await backoff(RETRY_DELAY_MS * attempt, signal);
      }
    }
  };

  let next = 0;
  const workers = Array.from({ length: Math.min(PARALLEL_PARTS, ranges.length) }, async () => {
    try {
      while (next < ranges.length) {
        if (signal.aborted) throw abortError();
        await sendPart(next++);
      }
    } catch (e) {
      // Interrompe os irmãos: nenhuma parte nova começa e os XHRs em andamento são abortados.
      internal.abort();
      throw e;
    }
  });
  try {
    const results = await Promise.allSettled(workers);
    const failed = results.find((r): r is PromiseRejectedResult => r.status === "rejected");
    if (failed) throw failed.reason;
    if (signal.aborted) throw abortError();
    const done = await videos.complete(upload_id);
    onProgress(100);
    return { upload_id: done.upload_id, duration_seconds: done.duration_seconds };
  } catch (e) {
    // Todos os workers já terminaram: o DELETE não corre contra uma parte ainda gravando.
    await videos.cancel(upload_id).catch(() => undefined);
    throw e;
  } finally {
    opts.signal.removeEventListener("abort", relay);
  }
}
