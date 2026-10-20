import { useQuery } from "@tanstack/react-query";
import { Link } from "react-router-dom";
import { ArrowRight, Video } from "lucide-react";
import { videos } from "@/lib/api";
import { Card, CardContent } from "@/components/ui/card";

export function PendingVideosCard() {
  const { data } = useQuery({ queryKey: ["my-videos"], queryFn: () => videos.listMine() });
  const pending = (data?.required ?? []).filter((v) => v.status !== "concluido");
  if (pending.length === 0) return null;
  const overdue = pending.filter((v) => v.status === "atrasado").length;

  return (
    <Link to="/meus-videos">
      <Card className="group transition-all hover:shadow-md hover:border-primary/30 cursor-pointer">
        <CardContent className="p-5 flex items-center gap-4">
          <div className="rounded-lg p-2.5 shrink-0 bg-primary/10 text-primary">
            <Video className="h-5 w-5" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-sm">Vídeos pendentes</p>
            <p className="text-xs text-muted-foreground mt-0.5">
              Você tem {pending.length} {pending.length === 1 ? "vídeo obrigatório" : "vídeos obrigatórios"} para assistir
              {overdue > 0 && <span className="text-destructive"> ({overdue} em atraso)</span>}.
            </p>
          </div>
          <ArrowRight className="h-4 w-4 text-muted-foreground/40 shrink-0 transition-transform group-hover:translate-x-1 group-hover:text-primary" />
        </CardContent>
      </Card>
    </Link>
  );
}
