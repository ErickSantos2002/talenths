import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { MONTHS, CALC_TYPE_LABELS, RESULT_TYPE_LABELS, formatGoalValue, type MonthlyActual, type MonthlyPlan } from "@/types/goals";
import { UpdateActualDialog } from "./UpdateActualDialog";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Skeleton } from "@/components/ui/skeleton";
import { Lock, Pencil, History } from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";

interface Props {
  goalId: string;
  cycleId: string;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  canEdit: boolean;
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
  let cumPlan = 0;

  return MONTHS.map((label, idx) => {
    const month = idx + 1;
    const planned = plansMap[month] ?? 0;
    const entry = actualsMap[month] as MonthlyActual | undefined;
    const actual = entry?.actual_value ?? null;

    cumPlan += planned;
    if (actual !== null) setActualValues.push(actual);

    let cumActual: number | null = null;
    if (setActualValues.length > 0) {
      switch (calculationType) {
        case "sum":
        case "subtraction":
          cumActual = setActualValues.reduce((a, b) => a + b, 0);
          break;
        case "average":
          cumActual = setActualValues.reduce((a, b) => a + b, 0) / setActualValues.length;
          break;
        case "repeat":
          cumActual = setActualValues[setActualValues.length - 1];
          break;
        default:
          cumActual = setActualValues.reduce((a, b) => a + b, 0);
      }
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

export function GoalDetailModal({ goalId, cycleId, open, onOpenChange, canEdit }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [updateTarget, setUpdateTarget] = useState<{ month: number; current: number | null } | null>(null);
  const [activeTab, setActiveTab] = useState<"table" | "history">("table");

  const { data: detail, isLoading } = useQuery({
    queryKey: ["goal-detail", goalId],
    queryFn: () => goalsApi.get(goalId),
    enabled: open && !!goalId,
  });

  const closeMutation = useMutation({
    mutationFn: (month: number) => goalsApi.closeMonth(goalId, month),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goal-detail", goalId] });
      toast({ title: "Mês fechado" });
    },
    onError: (err: Error) => toast({ title: "Erro ao fechar mês", description: err.message, variant: "destructive" }),
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

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="max-w-5xl max-h-[90vh] flex flex-col">
          <DialogHeader>
            {isLoading ? (
              <Skeleton className="h-6 w-64" />
            ) : detail ? (
              <div className="flex flex-wrap items-center gap-2">
                <DialogTitle className="text-lg">{detail.title}</DialogTitle>
                <Badge variant="outline">{CALC_TYPE_LABELS[detail.calculation_type]}</Badge>
                <Badge variant="outline">{RESULT_TYPE_LABELS[detail.result_type]}</Badge>
                <Badge variant="secondary">Peso: {detail.weight}%</Badge>
                {detail.responsible_name && (
                  <Badge variant="secondary">Resp: {detail.responsible_name}</Badge>
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
                        <th className="text-right py-2 px-2 font-medium">Planejado</th>
                        <th className="text-right py-2 px-2 font-medium">Realizado</th>
                        <th className="text-right py-2 px-2 font-medium">Desvio</th>
                        <th className="text-right py-2 px-2 font-medium">Acum. Plan</th>
                        <th className="text-right py-2 px-2 font-medium">Acum. Real</th>
                        <th className="text-right py-2 px-2 font-medium">Desvio Acum</th>
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
                              {row.deviation !== null ? (row.deviation > 0 ? "+" : "") + fmt(row.deviation) : "—"}
                            </td>
                            <td className="text-right py-2 px-2 text-muted-foreground">{fmt(row.cumPlan)}</td>
                            <td className="text-right py-2 px-2">{fmt(row.cumActual)}</td>
                            <td className={`text-right py-2 px-2 ${cumDevColor}`}>
                              {row.cumDeviation !== null ? (row.cumDeviation > 0 ? "+" : "") + fmt(row.cumDeviation) : "—"}
                            </td>
                            {canEdit && (
                              <td className="py-2 px-2">
                                {!row.isClosed && (
                                  <div className="flex gap-1 justify-end">
                                    <Button
                                      variant="ghost"
                                      size="icon"
                                      className="h-6 w-6"
                                      onClick={() => setUpdateTarget({ month: row.month, current: row.actual })}
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
                                  </div>
                                )}
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
                        contentStyle={{ fontSize: 12 }}
                      />
                      <Legend iconSize={10} wrapperStyle={{ fontSize: 12 }} />
                      <Line type="monotone" dataKey="Planejado" stroke="#94a3b8" strokeWidth={2} dot={false} connectNulls={false} />
                      <Line type="monotone" dataKey="Realizado" stroke="#10b981" strokeWidth={2} dot={{ r: 3 }} connectNulls={false} />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
              </div>
            ) : activeTab === "history" && detail ? (
              <div className="p-3 space-y-2">
                {detail.history.length === 0 ? (
                  <p className="text-sm text-muted-foreground text-center py-8">Nenhuma atualização registrada.</p>
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
          resultType={detail.result_type}
        />
      )}
    </>
  );
}
