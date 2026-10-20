import { useQuery } from "@tanstack/react-query";
import { Link } from "react-router-dom";
import { Video, Play } from "lucide-react";
import { videos } from "@/lib/api";
import type { MyVideo } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { VideoStatusBadge } from "@/components/videos/VideoStatusBadge";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { formatDate, formatDateTime, formatDuration } from "@/lib/videoFormat";

// Overdue first, then pending/in progress, completed last.
const ORDER: Record<MyVideo["status"], number> = { atrasado: 0, em_andamento: 1, pendente: 2, concluido: 3 };

function VideoCard({ video, optional }: { video: MyVideo; optional: boolean }) {
  // Nothing is owed on an optional video: "Pendente" there would read as an obligation.
  const showStatus = !(optional && video.status === "pendente");
  return (
    <Card className="hover:shadow-md hover:border-primary/20 transition-all">
      <CardContent className="p-4 flex items-start justify-between gap-4">
        <div className="flex-1 space-y-2 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <Video className="h-4 w-4 shrink-0 text-muted-foreground" />
            <span className="font-medium">{video.title}</span>
            {showStatus && <VideoStatusBadge status={video.status} />}
          </div>
          {video.description && <p className="text-sm text-muted-foreground line-clamp-2">{video.description}</p>}
          <p className="text-xs text-muted-foreground">
            {formatDuration(video.duration_seconds)}
            {video.due_at && video.status !== "concluido" && <> · Prazo: {formatDate(video.due_at)}</>}
            {video.completed_at && <> · Concluído em {formatDateTime(video.completed_at)}</>}
          </p>
          {video.status !== "concluido" && video.progress_pct > 0 && (
            <Progress value={video.progress_pct} className="h-1.5 max-w-xs" aria-label="Progresso assistido" />
          )}
        </div>
        <Button asChild variant="outline" size="sm" className="shrink-0">
          <Link to={`/videos/${video.id}`}>
            <Play className="h-4 w-4 mr-1" />
            {video.status === "concluido" ? "Rever" : video.progress_pct > 0 ? "Continuar" : "Assistir"}
          </Link>
        </Button>
      </CardContent>
    </Card>
  );
}

function Section({
  title,
  items,
  empty,
  optional = false,
}: {
  title: string;
  items: MyVideo[];
  empty: string;
  optional?: boolean;
}) {
  return (
    <section className="space-y-3">
      <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-widest">{title}</h2>
      {items.length === 0 ? (
        <p className="text-sm text-muted-foreground">{empty}</p>
      ) : (
        <div className="space-y-3">
          {items.map((v) => (
            <VideoCard key={v.id} video={v} optional={optional} />
          ))}
        </div>
      )}
    </section>
  );
}

export default function MeusVideosPage() {
  const { data, isLoading } = useQuery({ queryKey: ["my-videos"], queryFn: () => videos.listMine() });
  const required = [...(data?.required ?? [])].sort((a, b) => ORDER[a.status] - ORDER[b.status]);
  const library = data?.library ?? [];

  return (
    <AdminLayout>
      <div className="space-y-8" data-tour="my-videos">
        <div className="flex items-center gap-3">
          <Video className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Vídeos</h1>
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}

        {!isLoading && required.length === 0 && library.length === 0 && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <Video className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum vídeo disponível para você.</p>
          </div>
        )}

        {!isLoading && (required.length > 0 || library.length > 0) && (
          <>
            <Section title="Obrigatórios" items={required} empty="Nenhum vídeo obrigatório." />
            <Section title="Biblioteca" items={library} empty="Nenhum outro vídeo na biblioteca." optional />
          </>
        )}
      </div>
    </AdminLayout>
  );
}
