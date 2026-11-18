import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  ClipboardList, Plus, ChevronDown, CheckCircle2, Clock, RefreshCw, User, Pencil, AlertTriangle,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { evaluations as evalApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { EVAL_STATUS_LABELS, type EvalStatus, type TeamMemberStatus } from "@/types/evaluations";
import { EvaluationForm } from "@/components/evaluations/EvaluationForm";
import { EvalCycleDialog } from "@/components/evaluations/EvalCycleDialog";
import { CycleDates } from "@/components/evaluations/CycleDates";
import { InactiveBadge } from "@/components/InactiveBadge";
import { ShowInactiveSwitch } from "@/components/ShowInactiveSwitch";

const BY_DATES = "__by_dates__";
const STATUS_ORDER: EvalStatus[] = ["draft", "evaluation", "calibration", "feedback", "pdi", "closed"];

export default function EvaluationPage() {
  const { toast } = useToast();
  const { user } = useAuth();
  const queryClient = useQueryClient();

  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);
  const [cycleDialog, setCycleDialog] = useState<"create" | "edit" | null>(null);
  const [evaluating, setEvaluating] = useState<TeamMemberStatus | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["eval-cycles"],
    queryFn: evalApi.listCycles,
  });

  const [showInactive, setShowInactive] = useState(false);
  const { data: teamRows, isLoading: teamLoading } = useQuery({
    queryKey: ["team-status", selectedCycleId, showInactive],
    queryFn: () => evalApi.teamStatus(selectedCycleId!, showInactive),
    enabled: !!selectedCycleId,
  });

  const { data: myTeam } = useQuery({
    queryKey: ["my-team-evaluations", selectedCycleId],
    queryFn: () => evalApi.myTeam(selectedCycleId!),
    enabled: !!evaluating && !!selectedCycleId,
  });

  const consolidateMutation = useMutation({
    mutationFn: () => evalApi.consolidate(selectedCycleId!),
    onSuccess: (d) => {
      queryClient.invalidateQueries({ queryKey: ["team-status", selectedCycleId] });
      toast({
        title: `Notas calculadas para ${d.updated} colaborador(es)`,
        description: d.pending_manager > 0
          ? `${d.pending_manager} ainda sem avaliação do gestor ficaram sem nota.`
          : undefined,
      });
    },
    onError: (err: Error) => toast({ title: "Erro ao calcular notas", description: err.message, variant: "destructive" }),
  });

  const stageMutation = useMutation({
    mutationFn: (value: string) => evalApi.updateCycle(
      selectedCycleId!,
      value === BY_DATES ? { stage_by_dates: true } : { stage_by_dates: false, status: value as EvalStatus },
    ),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["eval-cycles"] });
      toast({ title: "Etapa atualizada" });
    },
    onError: (err: Error) => toast({ title: "Erro ao mudar a etapa", description: err.message, variant: "destructive" }),
  });

  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const active = cycles.find(c => c.status === "evaluation") ?? cycles[0];
    if (active) setSelectedCycleId(active.id);
  }, [cycles, selectedCycleId]);

  useEffect(() => {
    if (selectedCycleId) setEvaluating(null);
  }, [selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);
  const canManagerEvaluate = selectedCycle?.status === "evaluation" || selectedCycle?.status === "calibration";
  const hasEvalDates = !!(selectedCycle?.eval_start && selectedCycle?.eval_end);

  // Indicadores só da equipe atual, mesmo com desligados visíveis na lista.
  const teamStatus = teamRows?.filter(m => !m.deactivated_at);
  const count = (pred: (m: TeamMemberStatus) => boolean) => teamStatus?.filter(pred).length ?? 0;
  const pct = (n: number) => (teamStatus?.length ? Math.round((n / teamStatus.length) * 100) : 0);
  const withoutManager = count(m => !m.manager_user_id || m.manager_deactivated);

  const existingScores = myTeam?.find(m => m.user_id === evaluating?.user_id)?.scores;

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
                  <Button variant="outline" className="gap-2" data-tour="evaluation-cycle">
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

            <Button variant="outline" size="sm" onClick={() => setCycleDialog("create")} data-tour="evaluation-new-cycle">
              <Plus className="h-4 w-4 mr-1" /> Novo Ciclo
            </Button>
          </div>
        </div>

        {!cyclesLoading && (!cycles || cycles.length === 0) && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <ClipboardList className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum ciclo de avaliação cadastrado.</p>
            <Button onClick={() => setCycleDialog("create")}><Plus className="h-4 w-4 mr-2" /> Criar primeiro ciclo</Button>
          </div>
        )}

        {selectedCycleId && selectedCycle && (
          <div className="space-y-6">
            {/* Cycle controls */}
            <div className="rounded-xl border p-4 bg-card space-y-3" data-tour="evaluation-controls">
              <div className="flex flex-wrap items-center gap-3">
                <div className="flex items-center gap-2 flex-1 min-w-[260px]">
                  <span className="text-sm text-muted-foreground">Etapa atual:</span>
                  <Select
                    value={selectedCycle.stage_by_dates ? BY_DATES : selectedCycle.manual_status}
                    onValueChange={(v) => stageMutation.mutate(v)}
                  >
                    <SelectTrigger className="w-60 h-8 text-sm" aria-label="Etapa atual">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {hasEvalDates && (
                        <SelectItem value={BY_DATES}>
                          Pelas datas (hoje: {EVAL_STATUS_LABELS[selectedCycle.status]})
                        </SelectItem>
                      )}
                      {STATUS_ORDER.map(s => (
                        <SelectItem key={s} value={s}>{EVAL_STATUS_LABELS[s]}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <Button size="sm" variant="ghost" onClick={() => setCycleDialog("edit")} data-tour="evaluation-edit-cycle">
                  <Pencil className="h-4 w-4 mr-2" /> Editar ciclo
                </Button>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => consolidateMutation.mutate()}
                  disabled={consolidateMutation.isPending}
                >
                  <RefreshCw className={`h-4 w-4 mr-2 ${consolidateMutation.isPending ? "animate-spin" : ""}`} />
                  Calcular Notas
                </Button>
                <ShowInactiveSwitch checked={showInactive} onCheckedChange={setShowInactive} />
              </div>
              <CycleDates cycle={selectedCycle} />
            </div>

            {withoutManager > 0 && (
              <div className="flex items-start gap-3 rounded-xl border border-amber-500/30 bg-amber-500/5 p-4 text-sm">
                <AlertTriangle className="h-4 w-4 text-amber-500 mt-0.5 shrink-0" />
                <p>
                  {withoutManager === 1 ? "1 colaborador está" : `${withoutManager} colaboradores estão`} sem gestor
                  responsável e não {withoutManager === 1 ? "pode" : "podem"} receber a nota de gestor. Defina o gestor
                  em <Link to="/admin/colaboradores" className="font-medium underline underline-offset-2">Colaboradores</Link>.
                </p>
              </div>
            )}

            {/* Progress summary */}
            {teamStatus && teamStatus.length > 0 && (
              <div className="grid grid-cols-2 gap-4 sm:grid-cols-4" data-tour="evaluation-summary">
                {[
                  { label: "Colaboradores", value: teamStatus.length, suffix: "" },
                  { label: "Autoavaliação", value: `${pct(count(m => m.self_submitted))}%`, suffix: `${count(m => m.self_submitted)} / ${teamStatus.length}` },
                  { label: "Aval. Gestor", value: `${pct(count(m => m.manager_submitted))}%`, suffix: `${count(m => m.manager_submitted)} / ${teamStatus.length}` },
                  { label: "Notas calc.", value: count(m => m.score_final !== null), suffix: "" },
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
            ) : teamRows && teamRows.length > 0 ? (
              <div className="rounded-xl border overflow-x-auto" data-tour="evaluation-table">
                <table className="w-full text-sm">
                  <thead className="bg-muted/50">
                    <tr>
                      <th className="text-left px-4 py-3 font-medium text-muted-foreground">Colaborador</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden md:table-cell">Gestor</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Auto</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Gestor</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground">Nota Final</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden lg:table-cell">9Box</th>
                      <th className="px-3 py-3"><span className="sr-only">Ações</span></th>
                    </tr>
                  </thead>
                  <tbody>
                    {teamRows.map(member => (
                      <tr key={member.user_id} className="border-t hover:bg-muted/20 transition-colors">
                        <td className="px-4 py-3">
                          <div className="flex items-center gap-2">
                            <div className="h-7 w-7 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                              <User className="h-4 w-4 text-primary" />
                            </div>
                            <div>
                              <p className="flex flex-wrap items-center gap-1.5 font-medium leading-snug">
                                {member.name}
                                {member.deactivated_at && <InactiveBadge />}
                              </p>
                              <p className="text-xs text-muted-foreground">{member.department ?? member.email}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-3 py-3 hidden md:table-cell">
                          {member.manager_name ? (
                            <span className="flex flex-wrap items-center gap-1.5">
                              {member.manager_name}
                              {member.manager_deactivated && <InactiveBadge />}
                            </span>
                          ) : (
                            <Badge variant="outline" className="text-xs border-amber-500/40 text-amber-600 dark:text-amber-400">
                              Sem gestor
                            </Badge>
                          )}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.self_submitted
                            ? <CheckCircle2 className="h-4 w-4 text-emerald-500 mx-auto" aria-label="Enviada" />
                            : <Clock className="h-4 w-4 text-muted-foreground/40 mx-auto" aria-label="Pendente" />}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.manager_submitted
                            ? <CheckCircle2 className="h-4 w-4 text-emerald-500 mx-auto" aria-label="Enviada" />
                            : <Clock className="h-4 w-4 text-muted-foreground/40 mx-auto" aria-label="Pendente" />}
                        </td>
                        <td className="px-3 py-3 text-center">
                          {member.score_final !== null ? (
                            <div>
                              <span className={`font-semibold ${member.score_final >= 4.6 ? "text-emerald-500" : member.score_final >= 3 ? "text-amber-500" : "text-red-500"}`}>
                                {member.score_final.toFixed(2)}
                              </span>
                              <p className="text-[11px] text-muted-foreground whitespace-nowrap">
                                Gestor {member.score_manager?.toFixed(1) ?? "—"} · Auto {member.score_self?.toFixed(1) ?? "—"}
                              </p>
                            </div>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3 hidden lg:table-cell">
                          {member.nine_box_quadrant ? (
                            <Badge variant="outline" className="text-xs">{member.nine_box_quadrant}</Badge>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3 text-right">
                          {member.manager_user_id === user?.id && !member.deactivated_at && canManagerEvaluate && (
                            <Button size="sm" variant="ghost" onClick={() => setEvaluating(member)}>
                              Avaliar
                            </Button>
                          )}
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

      <EvalCycleDialog
        open={cycleDialog !== null}
        onOpenChange={(open) => !open && setCycleDialog(null)}
        cycle={cycleDialog === "edit" ? selectedCycle : null}
        onSaved={(id) => setSelectedCycleId(id)}
      />

      <Dialog open={!!evaluating} onOpenChange={(open) => !open && setEvaluating(null)}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Avaliar — {evaluating?.name}</DialogTitle>
            <DialogDescription>Avaliação do gestor: dê de 1 a 5 estrelas para cada comportamento.</DialogDescription>
          </DialogHeader>
          {evaluating && selectedCycleId && myTeam && (
            <EvaluationForm
              key={evaluating.user_id}
              cycleId={selectedCycleId}
              evaluatedUserId={evaluating.user_id}
              evalType="manager"
              evaluatedName={evaluating.name}
              existingScores={existingScores}
              onSuccess={() => setEvaluating(null)}
            />
          )}
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
