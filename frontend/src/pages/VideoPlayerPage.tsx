import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Link, useParams } from "react-router-dom";
import { ArrowLeft, CheckCircle2 } from "lucide-react";
import { videos } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { VideoStatusBadge } from "@/components/videos/VideoStatusBadge";
import { Card, CardContent } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { acceptTimeUpdate, clampSeek, nextMaxWatched } from "@/lib/videoPlayback";
import { createProgressReporter } from "@/lib/videoProgressReporter";
import { formatDateTime, formatDuration } from "@/lib/videoFormat";

const REPORT_INTERVAL_MS = 10_000;
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
// Float noise only: a seek must not credit anything beyond what was watched.
const SEEK_TOLERANCE_S = 0.05;

export default function VideoPlayerPage() {
  const { id = "" } = useParams();
  if (!UUID_RE.test(id)) {
    return (
      <AdminLayout>
        <Alert variant="destructive">
          <AlertDescription>Vídeo não encontrado ou indisponível.</AlertDescription>
        </Alert>
      </AdminLayout>
    );
  }
  return <VideoPlayer key={id} id={id} />;
}

function VideoPlayer({ id }: { id: string }) {
  const queryClient = useQueryClient();
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const maxRef = useRef(0);
  const completedRef = useRef(false);
  const resumeRef = useRef<{ time: number; playing: boolean } | null>(null);
  const lastRecoveryRef = useRef(0);
  const [src, setSrc] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [shownMax, setShownMax] = useState(0);

  const { data: video, isLoading, error } = useQuery({
    queryKey: ["video", id],
    queryFn: () => videos.get(id),
    refetchOnWindowFocus: false,
    retry: false,
  });

  const fetchSrc = useCallback(
    async (keepPosition: boolean) => {
      const el = videoRef.current;
      if (keepPosition && el) resumeRef.current = { time: el.currentTime, playing: !el.paused };
      try {
        setSrc(await videos.streamUrl(id));
      } catch {
        setNotice("Não foi possível abrir o vídeo.");
      }
    },
    [id],
  );

  useEffect(() => {
    void fetchSrc(false);
  }, [fetchSrc]);

  const reporter = useMemo(
    () =>
      createProgressReporter({
        getMax: () => maxRef.current,
        isCompleted: () => completedRef.current,
        send: (pos) => videos.reportProgress(id, pos),
        sendOnExit: (pos) => videos.reportProgressKeepalive(id, pos),
        onAccepted: ({ max_watched_s, completed }) => {
          setNotice(null);
          setShownMax((prev) => nextMaxWatched(prev, max_watched_s));
          if (completed) {
            completedRef.current = true;
            void queryClient.invalidateQueries({ queryKey: ["video", id] });
            void queryClient.invalidateQueries({ queryKey: ["my-videos"] });
          }
        },
        onRejected: (serverMax) => {
          maxRef.current = serverMax;
          setShownMax(serverMax);
          if (videoRef.current) videoRef.current.currentTime = serverMax;
          setNotice("Você não pode avançar além do ponto já assistido.");
        },
        onError: () => setNotice("Falha ao registrar o progresso. Tentaremos novamente."),
      }),
    [id, queryClient],
  );

  useEffect(() => {
    if (!video) return;
    maxRef.current = nextMaxWatched(maxRef.current, video.max_watched_s);
    completedRef.current = video.completed_at != null;
    reporter.resetLastSent(video.max_watched_s);
    setShownMax(maxRef.current);
  }, [video, reporter]);

  useEffect(() => {
    const timer = window.setInterval(() => {
      if (videoRef.current && !videoRef.current.paused) void reporter.flush();
    }, REPORT_INTERVAL_MS);
    const onVisibility = () => {
      if (document.visibilityState !== "hidden") return;
      void reporter.flush(true);
      // Chrome throttles timers in hidden silent tabs: timeupdate jumps far enough to be
      // treated as a skip and snapped back, over and over. The user resumes by hand.
      if (!completedRef.current) videoRef.current?.pause();
    };
    const onPageHide = () => void reporter.flush(true);
    document.addEventListener("visibilitychange", onVisibility);
    window.addEventListener("pagehide", onPageHide);
    return () => {
      window.clearInterval(timer);
      document.removeEventListener("visibilitychange", onVisibility);
      window.removeEventListener("pagehide", onPageHide);
      reporter.dispose();
      void reporter.flush(true);
    };
  }, [reporter]);

  const completedAt = video?.completed_at ?? null;
  const duration = video?.duration_seconds ?? 0;
  const pct = completedAt ? 100 : duration > 0 ? Math.min(100, (shownMax / duration) * 100) : 0;

  return (
    <AdminLayout>
      <div className="space-y-4 max-w-4xl">
        <Link to="/meus-videos" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-4 w-4" /> Vídeos
        </Link>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}
        {error && (
          <Alert variant="destructive">
            <AlertDescription>Vídeo não encontrado ou indisponível.</AlertDescription>
          </Alert>
        )}

        {video && (
          <Card>
            <CardContent className="p-5 space-y-4">
              <div className="space-y-1">
                <div className="flex items-center gap-2 flex-wrap">
                  <h1 className="text-2xl font-bold tracking-tight">{video.title}</h1>
                  <VideoStatusBadge status={video.status} />
                </div>
                {video.description && <p className="text-sm text-muted-foreground whitespace-pre-line">{video.description}</p>}
              </div>

              {src ? (
                <video
                  ref={videoRef}
                  className="w-full rounded border bg-black"
                  src={src}
                  controls
                  preload="metadata"
                  controlsList="nodownload noplaybackrate"
                  disablePictureInPicture
                  onLoadedMetadata={(e) => {
                    const el = e.currentTarget;
                    if (resumeRef.current) {
                      el.currentTime = resumeRef.current.time;
                      if (resumeRef.current.playing) el.play().catch(() => undefined);
                      resumeRef.current = null;
                    } else if (!completedRef.current && maxRef.current > 0) {
                      el.currentTime = Math.min(maxRef.current, el.duration || maxRef.current);
                    }
                  }}
                  onTimeUpdate={(e) => {
                    const el = e.currentTarget;
                    if (completedRef.current) return;
                    const { max, snapTo } = acceptTimeUpdate(el.currentTime, maxRef.current, el.seeking);
                    maxRef.current = max;
                    if (snapTo !== null) el.currentTime = snapTo;
                  }}
                  onSeeking={(e) => {
                    const el = e.currentTarget;
                    if (completedRef.current || el.currentTime <= maxRef.current + SEEK_TOLERANCE_S) return;
                    el.currentTime = clampSeek(el.currentTime, maxRef.current, false);
                  }}
                  onRateChange={(e) => {
                    const el = e.currentTarget;
                    if (!completedRef.current && el.playbackRate !== 1) el.playbackRate = 1;
                  }}
                  onPause={() => void reporter.flush()}
                  onEnded={() => void reporter.flush()}
                  onError={() => {
                    // Expired link: get a new one keeping the position. A second error right after
                    // means the browser really cannot play this file.
                    const now = Date.now();
                    if (now - lastRecoveryRef.current < 30_000) {
                      setNotice("O navegador não conseguiu tocar este vídeo.");
                      return;
                    }
                    lastRecoveryRef.current = now;
                    void fetchSrc(true);
                  }}
                />
              ) : (
                !notice && <p className="text-sm text-muted-foreground">Preparando vídeo...</p>
              )}

              <div className="space-y-2">
                <Progress value={pct} className="h-2 max-w-sm" aria-label="Progresso assistido" />
                {completedAt ? (
                  <p className="flex items-center gap-1.5 text-sm text-emerald-600">
                    <CheckCircle2 className="h-4 w-4" /> Vídeo concluído em {formatDateTime(completedAt)}
                  </p>
                ) : (
                  <>
                    <p className="text-sm text-muted-foreground">
                      Assistido: {formatDuration(shownMax)} de {formatDuration(duration)}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      Dá para pausar e voltar; avançar além do ponto já assistido, não. O ponto fica salvo e
                      você retoma de onde parou.
                    </p>
                  </>
                )}
              </div>

              {notice && (
                <Alert>
                  <AlertDescription>{notice}</AlertDescription>
                </Alert>
              )}
            </CardContent>
          </Card>
        )}
      </div>
    </AdminLayout>
  );
}
