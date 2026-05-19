import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { ClipboardCheck, ChevronDown, CheckCircle2 } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { evaluations as evalApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { EVAL_STATUS_LABELS } from "@/types/evaluations";
import { EvaluationForm } from "@/components/evaluations/EvaluationForm";

export default function MyEvaluationPage() {
  const { user } = useAuth();
  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["eval-cycles"],
    queryFn: evalApi.listCycles,
  });

  const { data: myEval, isLoading: evalLoading } = useQuery({
    queryKey: ["my-evaluation", selectedCycleId],
    queryFn: () => evalApi.myEvaluation(selectedCycleId!),
    enabled: !!selectedCycleId,
  });

  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const active = cycles.find(c => c.status === "evaluation");
    const first = active ?? cycles[0];
    if (first) setSelectedCycleId(first.id);
  }, [cycles, selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);
  const userId = user?.id ?? "";

  const isEvaluationOpen = selectedCycle?.status === "evaluation";

  return (
    <AdminLayout>
      <div className="space-y-6 max-w-3xl">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <ClipboardCheck className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Minha Avaliação</h1>
          </div>

          {cyclesLoading ? (
            <Skeleton className="h-9 w-52" />
          ) : cycles && cycles.length > 0 ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" className="gap-2">
                  <span className="max-w-[200px] truncate">{selectedCycle?.name ?? "Selecionar ciclo"}</span>
                  {selectedCycle && (
                    <Badge variant={selectedCycle.status === "evaluation" ? "default" : "secondary"} className="text-[10px] h-4 px-1.5">
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
        </div>

        {!cyclesLoading && (!cycles || cycles.length === 0) && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <ClipboardCheck className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum ciclo de avaliação disponível no momento.</p>
          </div>
        )}

        {selectedCycleId && (
          <>
            {evalLoading ? (
              <div className="space-y-4">
                {[1, 2, 3].map(i => <Skeleton key={i} className="h-24 w-full" />)}
              </div>
            ) : myEval?.submitted ? (
              <div className="space-y-6">
                <div className="rounded-xl border bg-emerald-500/5 border-emerald-500/20 p-6 flex items-center gap-4">
                  <CheckCircle2 className="h-8 w-8 text-emerald-500 shrink-0" />
                  <div>
                    <p className="font-semibold text-emerald-700 dark:text-emerald-400">Autoavaliação enviada!</p>
                    <p className="text-sm text-muted-foreground">
                      Enviada em {myEval.submitted_at ? new Date(myEval.submitted_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" }) : "—"}
                    </p>
                  </div>
                </div>

                {isEvaluationOpen && (
                  <div>
                    <p className="text-sm text-muted-foreground mb-4">Você pode atualizar sua avaliação enquanto o ciclo estiver aberto.</p>
                    <EvaluationForm
                      cycleId={selectedCycleId}
                      evaluatedUserId={userId}
                      evalType="self"
                      existingScores={myEval.scores}
                    />
                  </div>
                )}
              </div>
            ) : isEvaluationOpen ? (
              <EvaluationForm
                cycleId={selectedCycleId}
                evaluatedUserId={userId}
                evalType="self"
              />
            ) : (
              <div className="rounded-xl border border-dashed p-12 text-center">
                <ClipboardCheck className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground">
                  {selectedCycle?.status === "draft"
                    ? "O ciclo de avaliação ainda não foi aberto."
                    : "O período de avaliação já encerrou."}
                </p>
              </div>
            )}
          </>
        )}
      </div>
    </AdminLayout>
  );
}
