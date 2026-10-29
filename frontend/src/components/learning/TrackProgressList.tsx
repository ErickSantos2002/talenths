import { Progress } from "@/components/ui/progress";
import type { TrackProgress } from "@/types/learning";

function formatDate(iso: string | null) {
  return iso ? new Date(iso).toLocaleDateString("pt-BR") : "—";
}

export function TrackProgressList({ tracks }: { tracks: TrackProgress[] }) {
  return (
    <div className="divide-y">
      {tracks.map((t) => (
        <div key={t.id} className="space-y-1.5 px-4 py-2.5">
          <div className="flex items-center justify-between gap-3">
            <p className="truncate text-sm font-medium">{t.track_name}</p>
            <span className="shrink-0 text-xs font-medium text-primary">{Math.round(t.progress_pct)}%</span>
          </div>
          <Progress value={t.progress_pct} className="h-1.5" aria-label={`Progresso na trilha ${t.track_name}`} />
          <p className="text-xs text-muted-foreground">
            Iniciada em {formatDate(t.started_at)} · Atualizado em {formatDate(t.imported_at)}
            {t.courses.length > 0 && ` · ${t.courses.length} curso${t.courses.length !== 1 ? "s" : ""}`}
          </p>
          {t.courses.length > 0 && (
            <p className="text-xs text-muted-foreground">{t.courses.join(" · ")}</p>
          )}
        </div>
      ))}
    </div>
  );
}
