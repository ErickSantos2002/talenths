import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { Grid3X3, ChevronDown, RefreshCw, Star, Crown } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Tooltip, TooltipContent, TooltipTrigger,
} from "@/components/ui/tooltip";
import { evaluations as evalApi } from "@/lib/api";
import { EVAL_STATUS_LABELS, NINE_BOX_QUADRANTS, type NineBoxEntry } from "@/types/evaluations";
import { cn } from "@/lib/utils";

// 9Box grid layout: y=3 (top) → y=1 (bottom), x=1 (left) → x=3 (right)
const GRID_DEF = [
  // [y, x, label, color]
  [3, 1, "Alta Competência",        "bg-sky-500/10 border-sky-500/20 text-sky-700 dark:text-sky-400"],
  [3, 2, "Forte Talento",           "bg-emerald-500/10 border-emerald-500/20 text-emerald-700 dark:text-emerald-400"],
  [3, 3, "Super Talento",           "bg-emerald-600/15 border-emerald-600/30 text-emerald-800 dark:text-emerald-300"],
  [2, 1, "Competência Consistente", "bg-amber-500/10 border-amber-500/20 text-amber-700 dark:text-amber-400"],
  [2, 2, "Essenciais",              "bg-amber-500/10 border-amber-500/20 text-amber-700 dark:text-amber-400"],
  [2, 3, "Futuro Talento",          "bg-sky-500/10 border-sky-500/20 text-sky-700 dark:text-sky-400"],
  [1, 1, "Insuficiente",            "bg-red-500/10 border-red-500/20 text-red-700 dark:text-red-400"],
  [1, 2, "Contribuidor",            "bg-orange-500/10 border-orange-500/20 text-orange-700 dark:text-orange-400"],
  [1, 3, "Alcança Resultados",      "bg-amber-500/10 border-amber-500/20 text-amber-700 dark:text-amber-400"],
] as const;

function NineBoxCell({
  quadrantName,
  colorClass,
  members,
}: {
  quadrantName: string;
  colorClass: string;
  members: NineBoxEntry[];
}) {
  const eligible = NINE_BOX_QUADRANTS[quadrantName]?.eligible;

  return (
    <div className={cn("rounded-lg border p-3 min-h-[120px] flex flex-col gap-2", colorClass)}>
      <div className="flex items-center justify-between gap-1">
        <span className="text-[11px] font-semibold leading-tight">{quadrantName}</span>
        <div className="flex items-center gap-1 shrink-0">
          {eligible && <Crown className="h-3 w-3 text-amber-500" title="Elegível para Trilha" />}
          <span className="text-[10px] opacity-70">{members.length}</span>
        </div>
      </div>
      <div className="flex flex-wrap gap-1 flex-1 content-start">
        {members.map(m => (
          <Tooltip key={m.user_id}>
            <TooltipTrigger asChild>
              <div className={cn(
                "inline-flex items-center gap-1 rounded-full bg-background/80 border px-2 py-0.5 text-[10px] font-medium cursor-default shadow-sm",
                m.calibrated && "border-amber-400/50"
              )}>
                {m.calibrated && <Star className="h-2.5 w-2.5 text-amber-400 fill-amber-400 shrink-0" />}
                <span className="max-w-[80px] truncate">{m.name.split(" ")[0]}</span>
              </div>
            </TooltipTrigger>
            <TooltipContent side="top" className="text-xs max-w-[200px]">
              <div className="space-y-0.5">
                <p className="font-semibold">{m.name}</p>
                {m.department && <p className="text-muted-foreground">{m.department}</p>}
                {m.score_final !== null && <p>Nota: {m.score_final.toFixed(2)}</p>}
                {m.calibrated && <p className="text-amber-400">Calibrado manualmente</p>}
              </div>
            </TooltipContent>
          </Tooltip>
        ))}
      </div>
    </div>
  );
}

export default function NineBoxPage() {
  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["eval-cycles"],
    queryFn: evalApi.listCycles,
  });

  const { data: nineBoxData, isLoading: boxLoading, refetch } = useQuery({
    queryKey: ["9box", selectedCycleId],
    queryFn: () => evalApi.nineBox(selectedCycleId!),
    enabled: !!selectedCycleId,
  });

  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const active = cycles.find(c => ["evaluation", "calibration", "feedback"].includes(c.status)) ?? cycles[0];
    if (active) setSelectedCycleId(active.id);
  }, [cycles, selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);
  const grid = nineBoxData?.grid ?? {};

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <Grid3X3 className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Mapa de Talentos — 9Box</h1>
          </div>

          <div className="flex items-center gap-2">
            {cyclesLoading ? (
              <Skeleton className="h-9 w-52" />
            ) : cycles && cycles.length > 0 ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" className="gap-2">
                    <span className="max-w-[180px] truncate">{selectedCycle?.name ?? "Selecionar"}</span>
                    {selectedCycle && (
                      <Badge variant="secondary" className="text-[10px] h-4 px-1.5">
                        {EVAL_STATUS_LABELS[selectedCycle.status]}
                      </Badge>
                    )}
                    <ChevronDown className="h-4 w-4 text-muted-foreground" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="min-w-[220px]">
                  {cycles.map(c => (
                    <DropdownMenuItem key={c.id} onClick={() => setSelectedCycleId(c.id)} className="flex items-center justify-between gap-2">
                      <span>{c.name}</span>
                      <Badge variant={c.status === "evaluation" ? "default" : "outline"} className="text-[10px] h-4 px-1.5">
                        {EVAL_STATUS_LABELS[c.status]}
                      </Badge>
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
            ) : null}

            <Button size="sm" variant="outline" onClick={() => refetch()} disabled={boxLoading}>
              <RefreshCw className={cn("h-4 w-4 mr-1", boxLoading && "animate-spin")} /> Atualizar
            </Button>
          </div>
        </div>

        {/* Legend */}
        <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
          <div className="flex items-center gap-1.5">
            <div className="h-3 w-3 rounded-sm bg-emerald-500/20 border border-emerald-500/40" />
            <span>Elegível para Trilha de Carreira</span>
          </div>
          <div className="flex items-center gap-1.5">
            <Star className="h-3 w-3 text-amber-400 fill-amber-400" />
            <span>Calibrado manualmente</span>
          </div>
          <div className="flex items-center gap-1.5">
            <Crown className="h-3 w-3 text-amber-500" />
            <span>Quadrante elegível</span>
          </div>
        </div>

        {!selectedCycleId || (!boxLoading && nineBoxData?.total === 0) ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <Grid3X3 className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-2">
              {!selectedCycleId ? "Selecione um ciclo de avaliação." : "Nenhuma nota consolidada encontrada."}
            </p>
            {selectedCycleId && (
              <p className="text-sm text-muted-foreground">Acesse <strong>Avaliação de Desempenho</strong> e clique em <strong>Calcular Notas</strong> primeiro.</p>
            )}
          </div>
        ) : boxLoading ? (
          <div className="grid grid-cols-3 gap-3">
            {Array.from({ length: 9 }).map((_, i) => <Skeleton key={i} className="h-32 rounded-xl" />)}
          </div>
        ) : (
          <div className="space-y-2">
            {/* Y-axis label */}
            <div className="flex gap-2">
              <div className="w-8 flex items-center justify-center">
                <span className="text-xs text-muted-foreground -rotate-90 whitespace-nowrap">Avaliação →</span>
              </div>
              <div className="flex-1 space-y-2">
                {/* Rows: y=3, y=2, y=1 */}
                {[3, 2, 1].map(y => (
                  <div key={y} className="grid grid-cols-3 gap-2">
                    {GRID_DEF.filter(([gy]) => gy === y).map(([, x, label, color]) => {
                      const key = `${y}-${x}`;
                      const members = grid[key] ?? [];
                      return (
                        <NineBoxCell
                          key={key}
                          quadrantName={label}
                          colorClass={color}
                          members={members}
                        />
                      );
                    })}
                  </div>
                ))}
              </div>
            </div>

            {/* X-axis label */}
            <div className="flex gap-2">
              <div className="w-8" />
              <div className="flex-1 flex justify-around pt-1">
                {["Baixo (0–90%)", "Médio (91–105%)", "Alto (106%+)"].map(label => (
                  <span key={label} className="text-[10px] text-muted-foreground">{label}</span>
                ))}
              </div>
            </div>
            <div className="flex gap-2">
              <div className="w-8" />
              <div className="flex-1 text-center">
                <span className="text-xs text-muted-foreground">← Progresso de Metas →</span>
              </div>
            </div>

            {/* Total */}
            <p className="text-sm text-muted-foreground text-right">
              {nineBoxData?.total} colaborador(es) no mapa
            </p>
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
