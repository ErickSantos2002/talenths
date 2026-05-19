import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  ClipboardList, Plus, ChevronDown, CheckCircle2, Clock, RefreshCw, User,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { evaluations as evalApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { EVAL_STATUS_LABELS, type EvalCycle } from "@/types/evaluations";
import { EvaluationForm } from "@/components/evaluations/EvaluationForm";
import { CreateEvalCycleDialog } from "@/components/evaluations/CreateEvalCycleDialog";

export default function EvaluationPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [evaluatingUser, setEvaluatingUser] = useState<{ id: string; name: string } | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["eval-cycles"],
    queryFn: evalApi.listCycles,
  });

  const { data: teamStatus, isLoading: teamLoading } = useQuery({
    queryKey: ["team-status", selectedCycleId],
    queryFn: () => evalApi.teamStatus(selectedCycleId!),
    enabled: !!selectedCycleId,
  });

  const consolidateMutation = useMutation({
    mutationFn: () => evalApi.consolidate(selectedCycleId!),
    onSuccess: (d) => {
      queryClient.invalidateQueries({ queryKey: ["team-status", selectedCycleId] });
      toast({ title: `Notas calculadas para ${d.updated} colaborador(es)` });
    },
    onError: (err: Error) => toast({ title: "Erro ao calcular notas", description: err.message, variant: "destructive" }),
  });

  const updateStatusMutation = useMutation({
    mutationFn: (newStatus: string) => evalApi.updateCycle(selectedCycleId!, { status: newStatus as EvalCycle["status"] }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["eval-cycles"] });
      toast({ title: "Status atualizado" });
    },
    onError: (err: Error) => toast({ title: "Erro", description: err.message, variant: "destructive" }),
  });

  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const active = cycles.find(c => c.status === "evaluation") ?? cycles[0];
    if (active) setSelectedCycleId(active.id);
  }, [cycles, selectedCycleId]);

  useEffect(() => {
    if (selectedCycleId) setEvaluatingUser(null);
  }, [selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);

  const selfPct = teamStatus
    ? Math.round((teamStatus.filter(m => m.self_submitted).length / teamStatus.length) * 100)
    : 0;
  const managerPct = teamStatus
    ? Math.round((teamStatus.filter(m => m.manager_submitted).length / teamStatus.length) * 100)
    : 0;

  const statusOrder: EvalCycle["status"][] = ["draft", "evaluation", "calibration", "feedback", "pdi", "closed"];

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <ClipboardList className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Avaliação de Desempenho</h1>
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

            <Button variant="outline" size="sm" onClick={() => setCreateOpen(true)}>
              <Plus className="h-4 w-4 mr-1" /> Novo Ciclo
            </Button>
          </div>
        </div>

        {!cyclesLoading && (!cycles || cycles.length === 0) && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <ClipboardList className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum ciclo de avaliação cadastrado.</p>
            <Button onClick={() => setCreateOpen(true)}><Plus className="h-4 w-4 mr-2" /> Criar primeiro ciclo</Button>
          </div>
        )}

        {selectedCycleId && selectedCycle && (
          <div className="space-y-6">
            {/* Cycle controls */}
            <div className="flex flex-wrap items-center gap-3 rounded-xl border p-4 bg-card">
              <div className="flex items-center gap-2 flex-1">
                <span className="text-sm text-muted-foreground">Etapa atual:</span>
                <Select
                  value={selectedCycle.status}
                  onValueChange={(v) => updateStatusMutation.mutate(v)}
                >
                  <SelectTrigger className="w-40 h-8 text-sm">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {statusOrder.map(s => (
                      <SelectItem key={s} value={s}>{EVAL_STATUS_LABELS[s]}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <Button
                size="sm"
                variant="outline"
                onClick={() => consolidateMutation.mutate()}
                disabled={consolidateMutation.isPending}
              >
                <RefreshCw className={`h-4 w-4 mr-2 ${consolidateMutation.isPending ? "animate-spin" : ""}`} />
                Calcular Notas
              </Button>
            </div>

            {/* Progress summary */}
            {teamStatus && teamStatus.length > 0 && (
              <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
                {[
                  { label: "Colaboradores", value: teamStatus.length, suffix: "" },
                  { label: "Autoavaliação", value: `${selfPct}%`, suffix: `${teamStatus.filter(m => m.self_submitted).length} / ${teamStatus.length}` },
                  { label: "Aval. Gestor", value: `${managerPct}%`, suffix: `${teamStatus.filter(m => m.manager_submitted).length} / ${teamStatus.length}` },
                  { label: "Notas calc.", value: teamStatus.filter(m => m.score_final !== null).length, suffix: "" },
                ].map((stat, i) => (
                  <div key={i} className="rounded-xl border bg-card p-4">
                    <p className="text-xs text-muted-foreground">{stat.label}</p>
                    <p className="text-2xl font-bold text-foreground mt-1">{stat.value}</p>
                    {stat.suffix && <p className="text-xs text-muted-foreground mt-0.5">{stat.suffix}</p>}
                  </div>
                ))}
              </div>
            )}

            {/* Team table */}
            {teamLoading ? (
              <div className="space-y-2">
                {[1, 2, 3, 4].map(i => <Skeleton key={i} className="h-14 w-full" />)}
              </div>
            ) : teamStatus && teamStatus.length > 0 ? (
              <div className="rounded-xl border overflow-hidden">
                <table className="w-full text-sm">
                  <thead className="bg-muted/50">
                    <tr>
                      <th className="text-left px-4 py-3 font-medium text-muted-foreground">Colaborador</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden sm:table-cell">Departamento</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Auto</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Gestor</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Nota Final</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden lg:table-cell">9Box</th>
                      <th className="px-3 py-3" />
                    </tr>
                  </thead>
                  <tbody>
                    {teamStatus.map(member => (
                      <tr key={member.user_id} className="border-t hover:bg-muted/20 transition-colors">
                        <td className="px-4 py-3">
                          <div className="flex items-center gap-2">
                            <div className="h-7 w-7 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                              <User className="h-4 w-4 text-primary" />
                            </div>
                            <div>
                              <p className="font-medium leading-snug">{member.name}</p>
                              <p className="text-xs text-muted-foreground">{member.email}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-3 py-3 text-muted-foreground hidden sm:table-cell">
                          {member.department ?? "—"}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.self_submitted
                            ? <CheckCircle2 className="h-4 w-4 text-emerald-500 mx-auto" />
                            : <Clock className="h-4 w-4 text-muted-foreground/40 mx-auto" />}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.manager_submitted
                            ? <CheckCircle2 className="h-4 w-4 text-emerald-500 mx-auto" />
                            : <Clock className="h-4 w-4 text-muted-foreground/40 mx-auto" />}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.score_final !== null ? (
                            <span className={`font-semibold ${member.score_final >= 4.6 ? "text-emerald-500" : member.score_final >= 3 ? "text-amber-500" : "text-red-500"}`}>
                              {member.score_final.toFixed(2)}
                            </span>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3 hidden lg:table-cell">
                          {member.nine_box_quadrant ? (
                            <Badge variant="outline" className="text-xs">{member.nine_box_quadrant}</Badge>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => setEvaluatingUser({ id: member.user_id, name: member.name })}
                          >
                            Avaliar
                          </Button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : null}
          </div>
        )}
      </div>

      <CreateEvalCycleDialog
        open={createOpen}
        onOpenChange={setCreateOpen}
        onCreated={(id) => setSelectedCycleId(id)}
      />

      <Dialog open={!!evaluatingUser} onOpenChange={(open) => !open && setEvaluatingUser(null)}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Avaliar — {evaluatingUser?.name}</DialogTitle>
          </DialogHeader>
          {evaluatingUser && selectedCycleId && (
            <EvaluationForm
              cycleId={selectedCycleId}
              evaluatedUserId={evaluatingUser.id}
              evalType="manager"
              evaluatedName={evaluatingUser.name}
              onSuccess={() => setEvaluatingUser(null)}
            />
          )}
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
