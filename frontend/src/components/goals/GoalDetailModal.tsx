import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { MONTHS, CALC_TYPE_LABELS, RESULT_TYPE_LABELS, formatGoalValue, type MonthlyActual, type MonthlyPlan } from "@/types/goals";
import { UpdateActualDialog } from "./UpdateActualDialog";
import { CreateGoalDialog } from "./CreateGoalDialog";
import { GoalComments } from "./GoalComments";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { HelpTip } from "@/components/HelpTip";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Skeleton } from "@/components/ui/skeleton";
import { Lock, LockOpen, Pencil, Trash2, History } from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";

interface Dept { id: string; name: string; }

interface Props {
  goalId: string;
  cycleId: string;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  canEdit: boolean;
  departments: Dept[];
}

interface MonthRow {
  month: number;
  label: string;
  planned: number;
  actual: number | null;
  deviation: number | null;
  cumPlan: number;
  cumActual: number | null;
  cumDeviation: number | null;
  isClosed: boolean;
  comment: string | null;
}

function computeMonthlyRows(
  plans: MonthlyPlan[],
  actuals: MonthlyActual[],
  calculationType: string
): MonthRow[] {
  const plansMap = Object.fromEntries(plans.map(p => [p.month, p.planned_value]));
  const actualsMap = Object.fromEntries(actuals.map(a => [a.month, a]));
  const setActualValues: number[] = [];
  const setPlannedValues: number[] = []; // planejado dos meses que já têm realizado
  let runningSumPlan = 0;
  const avg = (arr: number[]) => arr.reduce((a, b) => a + b, 0) / arr.length;
  const sum = (arr: number[]) => arr.reduce((a, b) => a + b, 0);

  return MONTHS.map((label, idx) => {
    const month = idx + 1;
    const planned = plansMap[month] ?? 0;
    const entry = actualsMap[month] as MonthlyActual | undefined;
    const actual = entry?.actual_value ?? null;

    runningSumPlan += planned;
    if (actual !== null) {
      setActualValues.push(actual);
      setPlannedValues.push(planned);
    }

    // Acumulado respeita o tipo de cálculo (tanto realizado quanto planejado).
    // O realizado acumulado só é exibido nos meses que têm valor realizado próprio;
    // meses sem realizado mostram "—" (não carregam o valor do mês anterior).
    let cumActual: number | null = null;
    let cumPlan: number;
    switch (calculationType) {
      case "average":
        cumActual = actual !== null ? avg(setActualValues) : null;
        cumPlan = setPlannedValues.length ? avg(setPlannedValues) : planned;
        break;
      case "repeat":
        cumActual = actual !== null ? setActualValues[setActualValues.length - 1] : null;
        cumPlan = setPlannedValues.length ? setPlannedValues[setPlannedValues.length - 1] : planned;
        break;
      case "sum":
      case "subtraction":
      default:
        cumActual = actual !== null ? sum(setActualValues) : null;
        cumPlan = runningSumPlan;
    }

    return {
      month,
      label,
      planned,
      actual,
      deviation: actual !== null ? actual - planned : null,
      cumPlan,
      cumActual,
      cumDeviation: cumActual !== null ? cumActual - cumPlan : null,
      isClosed: entry?.is_closed ?? false,
      comment: entry?.comment ?? null,
    };
  });
}

export function GoalDetailModal({ goalId, cycleId, open, onOpenChange, canEdit, departments }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [updateTarget, setUpdateTarget] = useState<{ month: number; current: number | null; planned: number } | null>(null);
  const [activeTab, setActiveTab] = useState<"table" | "history">("table");
  const [editOpen, setEditOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const { data: detail, isLoading } = useQuery({
    queryKey: ["goal-detail", goalId],
    queryFn: () => goalsApi.get(goalId),
    enabled: open && !!goalId,
  });

  const invalidateAll = () => {
    queryClient.invalidateQueries({ queryKey: ["goal-detail", goalId] });
    queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
  };

  const closeMutation = useMutation({
    mutationFn: (month: number) => goalsApi.closeMonth(goalId, month),
    onSuccess: () => {
      invalidateAll();
      toast({ title: "Mês fechado" });
    },
    onError: (err: Error) => toast({ title: "Erro ao fechar mês", description: err.message, variant: "destructive" }),
  });

  const reopenMutation = useMutation({
    mutationFn: (month: number) => goalsApi.reopenMonth(goalId, month),
    onSuccess: () => {
      invalidateAll();
      toast({ title: "Mês reaberto" });
    },
    onError: (err: Error) => toast({ title: "Erro ao reabrir mês", description: err.message, variant: "destructive" }),
  });

  const deleteMutation = useMutation({
    mutationFn: () => goalsApi.delete(goalId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
      toast({ title: "Meta excluída" });
      setDeleteOpen(false);
      onOpenChange(false);
    },
    onError: (err: Error) => toast({ title: "Erro ao excluir meta", description: err.message, variant: "destructive" }),
  });

  const rows = detail
    ? computeMonthlyRows(detail.plans, detail.actuals, detail.calculation_type)
    : [];

  const chartData = rows.map(r => ({
    month: r.label,
    Planejado: r.planned,
    Realizado: r.actual,
  }));

  const fmt = (v: number | null) => v !== null && detail ? formatGoalValue(v, detail.result_type) : "—";

  // % de atingimento (realizado ÷ meta). Null quando não há realizado ou a meta é zero.
  const attainmentPct = (actual: number | null, planned: number) =>
    actual !== null && planned !== 0 ? Math.round((actual / planned) * 100) : null;

  // Desvio formatado: valor absoluto + (% de atingimento), ex.: "+5 (150%)".
  const fmtDeviation = (deviation: number | null, actual: number | null, planned: number) => {
    if (deviation === null) return "—";
    const pct = attainmentPct(actual, planned);
    const base = (deviation > 0 ? "+" : "") + fmt(deviation);
    return pct !== null ? `${base} (${pct}%)` : base;
  };

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="max-w-5xl max-h-[90vh] flex flex-col">
          <DialogHeader>
            {isLoading ? (
              <Skeleton className="h-6 w-64" />
            ) : detail ? (
              <div className="flex flex-wrap items-center gap-2 pr-8">
                <DialogTitle className="text-lg">{detail.title}</DialogTitle>
                <span className="inline-flex items-center gap-1">
                  <Badge variant="outline">{CALC_TYPE_LABELS[detail.calculation_type]}</Badge>
                  <HelpTip side="bottom">
                    Como o realizado é acumulado no ano:
                    <br /><b>Soma</b> — soma os meses (ex: chamados, vendas).
                    <br /><b>Média</b> — média dos meses (ex: uptime, satisfação).
                    <br /><b>Subtração</b> — soma usada em metas de redução.
                    <br /><b>Repetir</b> — usa o último valor lançado (ex: saldo, headcount).
                  </HelpTip>
                </span>
                <Badge variant="outline">{RESULT_TYPE_LABELS[detail.result_type]}</Badge>
                <span className="inline-flex items-center gap-1">
                  <Badge variant="secondary">Peso: {detail.weight}%</Badge>
                  <HelpTip side="bottom">
                    Quanto esta meta vale dentro do departamento. A soma dos pesos das metas do departamento deve fechar 100%.
                  </HelpTip>
                </span>
                {detail.responsible_name && (
                  <Badge variant="secondary">Resp: {detail.responsible_name}</Badge>
                )}
                {detail.calculation_type === "average" && (
                  <Badge variant="secondary">Média realizada: {formatGoalValue(detail.cum_actual, detail.result_type)}</Badge>
                )}
                {canEdit && (
                  <div className="flex items-center gap-1 ml-auto">
                    <Button variant="outline" size="sm" onClick={() => setEditOpen(true)}>
                      <Pencil className="h-3.5 w-3.5 mr-1" /> Editar
                    </Button>
                    <Button variant="outline" size="sm" className="text-destructive hover:text-destructive" onClick={() => setDeleteOpen(true)}>
                      <Trash2 className="h-3.5 w-3.5 mr-1" /> Excluir
                    </Button>
                  </div>
                )}
              </div>
            ) : null}
          </DialogHeader>

          {/* Tab switcher */}
          <div className="flex gap-1 border-b">
            <button
              onClick={() => setActiveTab("table")}
              className={`px-4 py-2 text-sm font-medium border-b-2 -mb-px transition-colors ${activeTab === "table" ? "border-primary text-primary" : "border-transparent text-muted-foreground hover:text-foreground"}`}
            >
              Progresso Mensal
            </button>
            <button
              onClick={() => setActiveTab("history")}
              className={`px-4 py-2 text-sm font-medium border-b-2 -mb-px transition-colors flex items-center gap-1.5 ${activeTab === "history" ? "border-primary text-primary" : "border-transparent text-muted-foreground hover:text-foreground"}`}
            >
              <History className="h-3.5 w-3.5" />
              Histórico
              {detail?.history && detail.history.length > 0 && (
                <Badge variant="secondary" className="ml-1 h-4 min-w-[1.25rem] text-[10px] px-1">
                  {detail.history.length}
                </Badge>
              )}
            </button>
          </div>

          <ScrollArea className="flex-1 overflow-auto">
            {isLoading ? (
              <div className="p-4 space-y-3">
                {[1, 2, 3].map(i => <Skeleton key={i} className="h-8 w-full" />)}
              </div>
            ) : activeTab === "table" && detail ? (
              <div className="p-1 space-y-6">
                {/* Monthly table */}
                <div className="overflow-x-auto">
                  <table className="w-full text-xs">
                    <thead>
                      <tr className="border-b text-muted-foreground">
                        <th className="text-left py-2 px-2 font-medium">Mês</th>
                        <th className="text-right py-2 px-2 font-medium">Meta pontual</th>
                        <th className="text-right py-2 px-2 font-medium">Realizado pontual</th>
                        <th className="text-right py-2 px-2 font-medium">
                          <span className="inline-flex items-center gap-1">Desvio
                            <HelpTip side="bottom">Diferença entre realizado e planejado no mês. A cor indica se está no caminho certo (considera se a meta é de aumentar ou diminuir).</HelpTip>
                          </span>
                        </th>
                        <th className="text-right py-2 px-2 pl-4 font-medium border-l border-border">
                          <span className="inline-flex items-center gap-1">Meta acumulado
                            <HelpTip side="bottom">Planejado acumulado até o mês, conforme o cálculo da meta: soma dos meses (Soma) ou média (Média).</HelpTip>
                          </span>
                        </th>
                        <th className="text-right py-2 px-2 font-medium">
                          <span className="inline-flex items-center gap-1">Realizado acumulado
                            <HelpTip side="bottom">Realizado acumulado até o mês, conforme o cálculo da meta.</HelpTip>
                          </span>
                        </th>
                        <th className="text-right py-2 px-2 font-medium">
                          <span className="inline-flex items-center gap-1">Desvio
                            <HelpTip side="bottom">Diferença entre o realizado e o planejado acumulados.</HelpTip>
                          </span>
                        </th>
                        {canEdit && <th className="py-2 px-2" />}
                      </tr>
                    </thead>
                    <tbody>
                      {rows.map(row => {
                        const devColor = row.deviation !== null
                          ? (detail.objective === "increase" ? row.deviation >= 0 : row.deviation <= 0)
                            ? "text-emerald-400"
                            : "text-red-500"
                          : "";
                        const cumDevColor = row.cumDeviation !== null
                          ? (detail.objective === "increase" ? row.cumDeviation >= 0 : row.cumDeviation <= 0)
                            ? "text-emerald-400"
                            : "text-red-500"
                          : "";

                        return (
                          <tr key={row.month} className={`border-b hover:bg-muted/30 ${row.isClosed ? "opacity-60" : ""}`}>
                            <td className="py-2 px-2 font-medium">
                              <div className="flex items-center gap-1">
                                {row.label}
                                {row.isClosed && <Lock className="h-3 w-3 text-muted-foreground" />}
                              </div>
                            </td>
                            <td className="text-right py-2 px-2">{fmt(row.planned)}</td>
                            <td className="text-right py-2 px-2 font-medium">{fmt(row.actual)}</td>
                            <td className={`text-right py-2 px-2 ${devColor}`}>
                              {fmtDeviation(row.deviation, row.actual, row.planned)}
                            </td>
                            <td className="text-right py-2 px-2 pl-4 text-muted-foreground border-l border-border">{fmt(row.cumPlan)}</td>
                            <td className="text-right py-2 px-2">{fmt(row.cumActual)}</td>
                            <td className={`text-right py-2 px-2 ${cumDevColor}`}>
                              {fmtDeviation(row.cumDeviation, row.cumActual, row.cumPlan)}
                            </td>
                            {canEdit && (
                              <td className="py-2 px-2">
                                <div className="flex gap-1 justify-end">
                                  {row.isClosed ? (
                                    <Button
                                      variant="ghost"
                                      size="icon"
                                      className="h-6 w-6 text-muted-foreground"
                                      onClick={() => reopenMutation.mutate(row.month)}
                                      disabled={reopenMutation.isPending}
                                      title="Reabrir mês"
                                    >
                                      <LockOpen className="h-3 w-3" />
                                    </Button>
                                  ) : (
                                    <>
                                      <Button
                                        variant="ghost"
                                        size="icon"
                                        className="h-6 w-6"
                                        onClick={() => setUpdateTarget({ month: row.month, current: row.actual, planned: row.planned })}
                                      >
                                        <Pencil className="h-3 w-3" />
                                      </Button>
                                      {row.actual !== null && (
                                        <Button
                                          variant="ghost"
                                          size="icon"
                                          className="h-6 w-6 text-muted-foreground"
                                          onClick={() => closeMutation.mutate(row.month)}
                                          title="Fechar mês"
                                        >
                                          <Lock className="h-3 w-3" />
                                        </Button>
                                      )}
                                    </>
                                  )}
                                </div>
                              </td>
                            )}
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>

                {/* Chart */}
                <div>
                  <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground mb-3">
                    Planejado vs Realizado
                  </p>
                  <ResponsiveContainer width="100%" height={200}>
                    <LineChart data={chartData} margin={{ top: 4, right: 16, left: 0, bottom: 4 }}>
                      <CartesianGrid strokeDasharray="3 3" className="stroke-border" />
                      <XAxis dataKey="month" tick={{ fontSize: 11 }} />
                      <YAxis tick={{ fontSize: 11 }} width={50} />
                      <Tooltip
                        formatter={(value: number) => detail ? formatGoalValue(value, detail.result_type) : value}
                        contentStyle={{
                          fontSize: 12,
                          backgroundColor: "hsl(var(--popover))",
                          border: "1px solid hsl(var(--border))",
                          borderRadius: "0.5rem",
                          color: "hsl(var(--popover-foreground))",
                        }}
                        labelStyle={{ color: "hsl(var(--foreground))", fontWeight: 500 }}
                        itemStyle={{ color: "hsl(var(--popover-foreground))" }}
                        cursor={{ stroke: "hsl(var(--border))" }}
                      />
                      <Legend iconSize={10} wrapperStyle={{ fontSize: 12 }} />
                      <Line type="monotone" dataKey="Planejado" stroke="#94a3b8" strokeWidth={2} dot={false} connectNulls={false} />
                      <Line type="monotone" dataKey="Realizado" stroke="#10b981" strokeWidth={2} dot={{ r: 3 }} connectNulls={false} />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
              </div>
            ) : activeTab === "history" && detail ? (
              <div className="p-3 space-y-5">
                <GoalComments goalId={goalId} canEdit={canEdit} />

                <div className="space-y-2">
                  <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Alterações de valor</p>
                {detail.history.length === 0 ? (
                  <p className="text-sm text-muted-foreground text-center py-4">Nenhuma atualização registrada.</p>
                ) : detail.history.map(h => (
                  <div key={h.id} className="rounded-lg border bg-card p-3 space-y-1">
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex items-center gap-2 text-sm">
                        <Badge variant="outline" className="text-xs">{MONTHS[h.month - 1]}</Badge>
                        <span className="font-medium">{formatGoalValue(h.new_value, detail.result_type)}</span>
                        {h.previous_value !== null && (
                          <span className="text-muted-foreground text-xs">
                            (antes: {formatGoalValue(h.previous_value, detail.result_type)})
                          </span>
                        )}
                      </div>
                      <div className="text-xs text-muted-foreground text-right">
                        <span>{h.changed_by_name ?? "Usuário"}</span>
                        <br />
                        <span>{new Date(h.changed_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}</span>
                      </div>
                    </div>
                    {h.comment && (
                      <p className="text-xs text-muted-foreground italic">{h.comment}</p>
                    )}
                  </div>
                ))}
                </div>
              </div>
            ) : null}
          </ScrollArea>
        </DialogContent>
      </Dialog>

      {updateTarget && detail && (
        <UpdateActualDialog
          open={!!updateTarget}
          onOpenChange={(open) => !open && setUpdateTarget(null)}
          goalId={goalId}
          cycleId={cycleId}
          month={updateTarget.month}
          currentValue={updateTarget.current}
          planned={updateTarget.planned}
          resultType={detail.result_type}
        />
      )}

      {editOpen && detail && (
        <CreateGoalDialog
          key={detail.id}
          open={editOpen}
          onOpenChange={setEditOpen}
          cycleId={cycleId}
          departments={departments}
          goalToEdit={detail}
        />
      )}

      <AlertDialog open={deleteOpen} onOpenChange={setDeleteOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir esta meta?</AlertDialogTitle>
            <AlertDialogDescription>
              {detail ? `"${detail.title}" ` : ""}
              será removida permanentemente, junto com sua mensalização e histórico. Esta ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(e) => { e.preventDefault(); deleteMutation.mutate(); }}
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
