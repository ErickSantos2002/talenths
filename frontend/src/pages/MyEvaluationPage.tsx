import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { ClipboardCheck, ChevronDown, CheckCircle2, Clock, User } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { evaluations as evalApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { EVAL_STATUS_LABELS, type EvalCycle, type MyTeamMember } from "@/types/evaluations";
import { EvaluationForm } from "@/components/evaluations/EvaluationForm";
import { formatDateOnly } from "@/lib/dateOnly";

function closedMessage(cycle: EvalCycle | undefined): string {
  if (cycle?.status === "draft") {
    return cycle.eval_start
      ? `A autoavaliação abre em ${formatDateOnly(cycle.eval_start)}.`
      : "O ciclo de avaliação ainda não foi aberto.";
  }
  return cycle?.eval_end
    ? `O período de autoavaliação terminou em ${formatDateOnly(cycle.eval_end)}.`
    : "O período de avaliação já encerrou.";
}

export default function MyEvaluationPage() {
  const { user } = useAuth();
  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);
  const [evaluating, setEvaluating] = useState<MyTeamMember | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["eval-cycles"],
    queryFn: evalApi.listCycles,
  });

  const { data: myEval, isLoading: evalLoading } = useQuery({
    queryKey: ["my-evaluation", selectedCycleId],
    queryFn: () => evalApi.myEvaluation(selectedCycleId!),
    enabled: !!selectedCycleId,
  });

  const { data: myTeam } = useQuery({
    queryKey: ["my-team-evaluations", selectedCycleId],
    queryFn: () => evalApi.myTeam(selectedCycleId!),
    enabled: !!selectedCycleId,
  });

  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const first = cycles.find(c => c.status === "evaluation")
      ?? cycles.find(c => c.status === "calibration")
      ?? cycles[0];
    if (first) setSelectedCycleId(first.id);
  }, [cycles, selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);
  const userId = user?.id ?? "";

  const isEvaluationOpen = selectedCycle?.status === "evaluation";
  const canManagerEvaluate = isEvaluationOpen || selectedCycle?.status === "calibration";
  const pendingTeam = myTeam?.filter(m => !m.manager_submitted).length ?? 0;

  const selfSection = selectedCycleId && (
    evalLoading ? (
      <div className="space-y-4">
        {[1, 2, 3].map(i => <Skeleton key={i} className="h-24 w-full" />)}
      </div>
    ) : myEval?.submitted ? (
      <div className="space-y-6">
        <div className="rounded-xl border bg-emerald-500/5 border-emerald-500/20 p-6 flex items-center gap-4" data-tour="my-evaluation-sent">
          <CheckCircle2 className="h-8 w-8 text-emerald-500 shrink-0" />
          <div>
            <p className="font-semibold text-emerald-700 dark:text-emerald-400">Autoavaliação enviada!</p>
            <p className="text-sm text-muted-foreground">
              Enviada em {myEval.submitted_at ? new Date(myEval.submitted_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" }) : "—"}
            </p>
          </div>
        </div>

        {isEvaluationOpen && (
          <div data-tour="my-evaluation-form">
            <p className="text-sm text-muted-foreground mb-4">
              Você pode atualizar sua avaliação enquanto o ciclo estiver aberto
              {selectedCycle?.eval_end ? `, até ${formatDateOnly(selectedCycle.eval_end)}` : ""}.
            </p>
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
      <div data-tour="my-evaluation-form" className="space-y-4">
        {selectedCycle?.eval_end && (
          <p className="text-sm text-muted-foreground">
            Sua autoavaliação fica aberta até <strong>{formatDateOnly(selectedCycle.eval_end)}</strong>.
          </p>
        )}
        <EvaluationForm
          cycleId={selectedCycleId}
          evaluatedUserId={userId}
          evalType="self"
        />
      </div>
    ) : (
      <div className="rounded-xl border border-dashed p-12 text-center">
        <ClipboardCheck className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
        <p className="text-muted-foreground">{closedMessage(selectedCycle)}</p>
      </div>
    )
  );

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3" data-tour="my-evaluation">
          <div className="flex items-center gap-3" data-tour="my-evaluation-title">
            <ClipboardCheck className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Minha Avaliação</h1>
          </div>

          {cyclesLoading ? (
            <Skeleton className="h-9 w-52" />
          ) : cycles && cycles.length > 0 ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" className="gap-2" data-tour="my-evaluation-cycle">
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

        {selectedCycleId && (myTeam && myTeam.length > 0 ? (
          <Tabs defaultValue="self">
            <TabsList>
              <TabsTrigger value="self">Autoavaliação</TabsTrigger>
              <TabsTrigger value="team" data-tour="my-evaluation-team">
                Avaliar minha equipe
                {canManagerEvaluate && pendingTeam > 0 && (
                  <Badge className="ml-2 h-4 px-1.5 text-[10px]">{pendingTeam}</Badge>
                )}
              </TabsTrigger>
            </TabsList>
            <TabsContent value="self" className="mt-6">{selfSection}</TabsContent>
            <TabsContent value="team" className="mt-6 space-y-4">
              <p className="text-sm text-muted-foreground">
                Você é o gestor responsável por estas pessoas. A sua nota vale 90% da nota final de cada uma.
                {!canManagerEvaluate && " A avaliação do gestor fica aberta nas etapas de Avaliação e Calibragem."}
              </p>
              <ul className="divide-y rounded-xl border">
                {myTeam.map(m => (
                  <li key={m.user_id} className="flex flex-wrap items-center gap-3 px-4 py-3">
                    <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                      <User className="h-4 w-4 text-primary" aria-hidden />
                    </div>
                    <div className="flex-1 min-w-[160px]">
                      <p className="font-medium leading-snug">{m.name}</p>
                      <p className="text-xs text-muted-foreground">{m.department ?? m.email}</p>
                    </div>
                    <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
                      {m.self_submitted
                        ? <><CheckCircle2 className="h-3.5 w-3.5 text-emerald-500" aria-hidden /> Autoavaliação feita</>
                        : <><Clock className="h-3.5 w-3.5" aria-hidden /> Autoavaliação pendente</>}
                    </span>
                    {m.manager_submitted ? (
                      <Badge variant="outline" className="text-xs border-emerald-500/40 text-emerald-600 dark:text-emerald-400">
                        Avaliado
                      </Badge>
                    ) : (
                      <Badge variant="outline" className="text-xs">Pendente</Badge>
                    )}
                    {canManagerEvaluate && (
                      <Button size="sm" variant={m.manager_submitted ? "ghost" : "default"} onClick={() => setEvaluating(m)}>
                        {m.manager_submitted ? "Rever" : "Avaliar"}
                      </Button>
                    )}
                  </li>
                ))}
              </ul>
            </TabsContent>
          </Tabs>
        ) : selfSection)}
      </div>

      <Dialog open={!!evaluating} onOpenChange={(open) => !open && setEvaluating(null)}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Avaliar — {evaluating?.name}</DialogTitle>
            <DialogDescription>Avaliação do gestor: dê de 1 a 5 estrelas para cada comportamento.</DialogDescription>
          </DialogHeader>
          {evaluating && selectedCycleId && (
            <EvaluationForm
              key={evaluating.user_id}
              cycleId={selectedCycleId}
              evaluatedUserId={evaluating.user_id}
              evalType="manager"
              evaluatedName={evaluating.name}
              existingScores={evaluating.scores}
              onSuccess={() => setEvaluating(null)}
            />
          )}
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
