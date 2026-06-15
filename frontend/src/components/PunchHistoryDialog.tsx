import { useQuery } from "@tanstack/react-query";
import { ArrowRight } from "lucide-react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { timeclock as timeclockApi } from "@/lib/api";

const fmt = (iso: string) =>
  new Date(iso).toLocaleString("pt-BR", { day: "2-digit", month: "2-digit", year: "2-digit", hour: "2-digit", minute: "2-digit" });

const STATUS = {
  pending: { label: "Pendente", cls: "bg-amber-500/15 text-amber-600 dark:text-amber-400" },
  approved: { label: "Aprovado", cls: "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400" },
  rejected: { label: "Negado", cls: "bg-destructive/15 text-destructive" },
};

export function PunchHistoryDialog({ punchId, onClose }: { punchId: string; onClose: () => void }) {
  const { data = [], isLoading } = useQuery({
    queryKey: ["punch-history", punchId],
    queryFn: () => timeclockApi.punchHistory(punchId),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Histórico de ajustes</DialogTitle></DialogHeader>
        {isLoading ? (
          <Skeleton className="h-24 w-full" />
        ) : data.length === 0 ? (
          <p className="text-sm text-muted-foreground py-4">Nenhum ajuste registrado para esta batida.</p>
        ) : (
          <div className="space-y-3 py-1">
            {data.map((h) => {
              const st = STATUS[h.status];
              return (
                <div key={h.id} className="rounded-lg border bg-card p-3 space-y-1.5 text-sm">
                  <div className="flex items-center justify-between gap-2">
                    <span className="inline-flex items-center gap-1.5 tabular-nums">
                      <span className="text-muted-foreground line-through">{fmt(h.previous_punched_at)}</span>
                      <ArrowRight className="h-3.5 w-3.5 text-muted-foreground" />
                      <span className="font-medium">{fmt(h.requested_punched_at)}</span>
                    </span>
                    <Badge className={`${st.cls} hover:${st.cls}`}>{st.label}</Badge>
                  </div>
                  {h.reason && <p className="text-xs text-muted-foreground italic">Motivo: {h.reason}</p>}
                  <p className="text-[11px] text-muted-foreground/70">
                    Solicitado por {h.requester_name ?? "—"} em {fmt(h.created_at)}
                    {h.reviewed_at && h.status !== "pending" && (
                      <> · {h.status === "approved" ? "aprovado" : "negado"} por {h.reviewer_name ?? "—"} em {fmt(h.reviewed_at)}</>
                    )}
                  </p>
                </div>
              );
            })}
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
