import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Target, Plus, ChevronDown, Download, Pencil, Trash2, MoreVertical, ArrowUp, ArrowDown } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useAuth } from "@/contexts/AuthContext";
import { goals as goalsApi, departments as deptsApi } from "@/lib/api";
import type { DepartmentOverview, Goal, Cycle } from "@/types/goals";
import { CALC_TYPE_LABELS, RESULT_TYPE_LABELS, MONTHS } from "@/types/goals";
import { DonutRing } from "@/components/goals/DonutRing";
import { HelpTip } from "@/components/HelpTip";
import { CreateCycleDialog } from "@/components/goals/CreateCycleDialog";
import { CreateGoalDialog } from "@/components/goals/CreateGoalDialog";
import { GoalDetailModal } from "@/components/goals/GoalDetailModal";

export default function GoalsPage() {
  const { hasRole } = useAuth();
  const canEdit = hasRole("master_admin") || hasRole("manager");
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<string>("");
  const [createCycleOpen, setCreateCycleOpen] = useState(false);
  const [editingCycle, setEditingCycle] = useState<Cycle | null>(null);
  const [deletingCycle, setDeletingCycle] = useState<Cycle | null>(null);
  const [createGoalOpen, setCreateGoalOpen] = useState(false);
  const [createGoalDeptId, setCreateGoalDeptId] = useState<string | undefined>();
  const [selectedGoalId, setSelectedGoalId] = useState<string | null>(null);
  const [editingGoalId, setEditingGoalId] = useState<string | null>(null);
  const [deletingGoal, setDeletingGoal] = useState<Goal | null>(null);
  const [selectedMonth, setSelectedMonth] = useState<number>(new Date().getMonth() + 1);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["goal-cycles"],
    queryFn: goalsApi.listCycles,
  });

  const { data: overview, isLoading: overviewLoading } = useQuery({
    queryKey: ["goals-overview", selectedCycleId, selectedMonth],
    queryFn: () => goalsApi.overview(selectedCycleId!, selectedMonth),
    enabled: !!selectedCycleId,
  });

  const { data: allDeptsRaw } = useQuery({
    queryKey: ["departments"],
    queryFn: () => deptsApi.list(),
  });

  // Auto-select first active cycle (or first overall)
  useEffect(() => {
    if (!cycles || selectedCycleId) return;
    const active = cycles.find(c => c.status === "active");
    const first = active ?? cycles[0];
    if (first) setSelectedCycleId(first.id);
  }, [cycles, selectedCycleId]);

  // Auto-select first tab when overview loads
  useEffect(() => {
    if (overview && overview.length > 0 && !activeTab) {
      setActiveTab(overview[0].department_id);
    }
  }, [overview, activeTab]);

  // Reset tab when cycle changes
  useEffect(() => {
    setActiveTab("");
  }, [selectedCycleId]);

  const selectedCycle = cycles?.find(c => c.id === selectedCycleId);

  const openCreateGoal = (deptId?: string) => {
    setCreateGoalDeptId(deptId);
    setCreateGoalOpen(true);
  };

  const allDepts = (allDeptsRaw ?? []).map((d: Record<string, unknown>) => ({ id: d.id as string, name: d.name as string }));

  const exportCsv = () => {
    if (!overview || overview.length === 0) return;
    const fmt = (v: number | null) => (v == null ? "" : String(v).replace(".", ","));
    const rows: string[][] = [["Time", "Meta", "Responsável", "Peso (%)", "Mês (%)", "Até o mês (%)", "Do ano (%)"]];
    overview.forEach(dept =>
      dept.goals.forEach(g =>
        rows.push([
          dept.department_name, g.title, g.responsible_name ?? "",
          fmt(g.weight), fmt(g.pct_month), fmt(g.pct_cumulative), fmt(g.pct_year),
        ]),
      ),
    );
    const csv = "﻿" + rows.map(r => r.map(c => `"${c.replace(/"/g, '""')}"`).join(";")).join("\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `metas_${selectedCycle?.name ?? "ciclo"}_${MONTHS[selectedMonth - 1]}.csv`.replace(/[^\w.-]+/g, "_");
    a.click();
    URL.revokeObjectURL(a.href);
  };

  const deleteCycleMutation = useMutation({
    mutationFn: (id: string) => goalsApi.deleteCycle(id),
    onSuccess: (_d, id) => {
      queryClient.invalidateQueries({ queryKey: ["goal-cycles"] });
      toast({ title: "Ciclo excluído" });
      if (selectedCycleId === id) setSelectedCycleId(null);
      setDeletingCycle(null);
    },
    onError: (e: Error) => toast({ title: "Não foi possível excluir", description: e.message, variant: "destructive" }),
  });

  const moveGoalMutation = useMutation({
    mutationFn: ({ id, direction }: { id: string; direction: "up" | "down" }) => goalsApi.move(id, direction),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["goals-overview", selectedCycleId] }),
    onError: (e: Error) => toast({ title: "Não foi possível mover", description: e.message, variant: "destructive" }),
  });

  const deleteGoalMutation = useMutation({
    mutationFn: (id: string) => goalsApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goals-overview", selectedCycleId] });
      toast({ title: "Meta excluída" });
      setDeletingGoal(null);
    },
    onError: (e: Error) => toast({ title: "Erro ao excluir meta", description: e.message, variant: "destructive" }),
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <Target className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Metas</h1>
          </div>

          <div className="flex items-center gap-2">
            {/* Cycle selector */}
            {cyclesLoading ? (
              <Skeleton className="h-9 w-48" />
            ) : cycles && cycles.length > 0 ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" className="gap-2">
                    <span className="max-w-[200px] truncate">{selectedCycle?.name ?? "Selecionar ciclo"}</span>
                    {selectedCycle && (
                      <Badge
                        variant={selectedCycle.status === "active" ? "default" : "secondary"}
                        className="text-[10px] h-4 px-1.5"
                      >
                        {selectedCycle.status === "active" ? "Ativo" : selectedCycle.status === "draft" ? "Rascunho" : "Encerrado"}
                      </Badge>
                    )}
                    <ChevronDown className="h-4 w-4 text-muted-foreground" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="min-w-[220px]">
                  {cycles.map(c => (
                    <DropdownMenuItem
                      key={c.id}
                      onClick={() => setSelectedCycleId(c.id)}
                      className="flex items-center justify-between gap-2"
                    >
                      <span className="flex-1 truncate">{c.name}</span>
                      <Badge variant={c.status === "active" ? "default" : "outline"} className="text-[10px] h-4 px-1.5">
                        {c.status === "active" ? "Ativo" : c.status === "draft" ? "Rascunho" : "Encerrado"}
                      </Badge>
                      {canEdit && (
                        <>
                          <button
                            className="text-muted-foreground hover:text-foreground"
                            onClick={(e) => { e.stopPropagation(); setEditingCycle(c); }}
                            title="Editar ciclo"
                          >
                            <Pencil className="h-3.5 w-3.5" />
                          </button>
                          <button
                            className="text-muted-foreground hover:text-destructive"
                            onClick={(e) => { e.stopPropagation(); setDeletingCycle(c); }}
                            title="Excluir ciclo"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </button>
                        </>
                      )}
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
            ) : null}

            {/* Month selector */}
            {cycles && cycles.length > 0 && (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" className="gap-2">
                    <span>{MONTHS[selectedMonth - 1]}</span>
                    <ChevronDown className="h-4 w-4 text-muted-foreground" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="min-w-[140px]">
                  {MONTHS.map((m, i) => (
                    <DropdownMenuItem key={m} onClick={() => setSelectedMonth(i + 1)}>
                      {m}
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
            )}

            {overview && overview.length > 0 && (
              <Button variant="outline" size="sm" onClick={exportCsv} title="Exportar (CSV)">
                <Download className="h-4 w-4" />
              </Button>
            )}

            {canEdit && (
              <>
                <Button variant="outline" size="sm" onClick={() => setCreateCycleOpen(true)}>
                  <Plus className="h-4 w-4 mr-1" /> Novo Ciclo
                </Button>
                <Button size="sm" onClick={() => openCreateGoal()}>
                  <Plus className="h-4 w-4 mr-1" /> Nova Meta
                </Button>
              </>
            )}
          </div>
        </div>

        {/* No cycles */}
        {!cyclesLoading && (!cycles || cycles.length === 0) && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <Target className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum ciclo de metas cadastrado ainda.</p>
            {canEdit && (
              <Button onClick={() => setCreateCycleOpen(true)}>
                <Plus className="h-4 w-4 mr-2" /> Criar primeiro ciclo
              </Button>
            )}
          </div>
        )}

        {/* Overview */}
        {selectedCycleId && (
          <>
            {overviewLoading ? (
              <div className="space-y-3">
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-64 w-full" />
              </div>
            ) : overview && overview.length > 0 ? (
              <Tabs value={activeTab} onValueChange={setActiveTab}>
                <TabsList className="flex flex-wrap h-auto gap-1 justify-start bg-transparent p-0">
                  {overview.map((dept) => (
                    <TabsTrigger
                      key={dept.department_id}
                      value={dept.department_id}
                      className="data-[state=active]:bg-primary/10 data-[state=active]:text-primary relative"
                    >
                      {dept.department_name}
                      {dept.weight_total > 0 && (
                        <span className="ml-1.5 inline-flex items-center justify-center rounded-full bg-muted text-muted-foreground text-[10px] font-bold px-1.5 h-4">
                          100%
                        </span>
                      )}
                    </TabsTrigger>
                  ))}
                </TabsList>

                {overview.map((dept) => (
                  <TabsContent key={dept.department_id} value={dept.department_id} className="mt-4">
                    <DepartmentGoalsTable
                      dept={dept}
                      canEdit={canEdit}
                      onGoalClick={setSelectedGoalId}
                      onEditGoal={(g) => setEditingGoalId(g.id)}
                      onMoveGoal={(g, dir) => moveGoalMutation.mutate({ id: g.id, direction: dir })}
                      onDeleteGoal={(g) => setDeletingGoal(g)}
                    />
                  </TabsContent>
                ))}
              </Tabs>
            ) : (
              <div className="rounded-xl border border-dashed p-12 text-center">
                <Target className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground mb-4">Nenhuma meta cadastrada neste ciclo.</p>
                {canEdit && (
                  <Button onClick={() => openCreateGoal()}>
                    <Plus className="h-4 w-4 mr-2" /> Adicionar primeira meta
                  </Button>
                )}
              </div>
            )}
          </>
        )}
      </div>

      <CreateCycleDialog
        open={createCycleOpen}
        onOpenChange={setCreateCycleOpen}
        onCreated={(id) => setSelectedCycleId(id)}
      />

      {editingCycle && (
        <CreateCycleDialog
          key={editingCycle.id}
          open={!!editingCycle}
          onOpenChange={(o) => !o && setEditingCycle(null)}
          cycle={editingCycle}
        />
      )}

      <AlertDialog open={!!deletingCycle} onOpenChange={(o) => !o && setDeletingCycle(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir o ciclo "{deletingCycle?.name}"?</AlertDialogTitle>
            <AlertDialogDescription>
              Só é possível excluir um ciclo que não tenha metas. Se houver metas, exclua ou mova-as antes.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(e) => { e.preventDefault(); if (deletingCycle) deleteCycleMutation.mutate(deletingCycle.id); }}
              disabled={deleteCycleMutation.isPending}
            >
              {deleteCycleMutation.isPending ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {selectedCycleId && (
        <CreateGoalDialog
          open={createGoalOpen}
          onOpenChange={setCreateGoalOpen}
          cycleId={selectedCycleId}
          departments={allDepts}
          defaultDepartmentId={createGoalDeptId}
        />
      )}

      {selectedGoalId && selectedCycleId && (
        <GoalDetailModal
          goalId={selectedGoalId}
          cycleId={selectedCycleId}
          open={!!selectedGoalId}
          onOpenChange={(open) => !open && setSelectedGoalId(null)}
          canEdit={canEdit}
          departments={allDepts}
        />
      )}

      {editingGoalId && selectedCycleId && (
        <EditGoalLoader
          goalId={editingGoalId}
          cycleId={selectedCycleId}
          departments={allDepts}
          onClose={() => setEditingGoalId(null)}
        />
      )}

      <AlertDialog open={!!deletingGoal} onOpenChange={(o) => !o && setDeletingGoal(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir esta meta?</AlertDialogTitle>
            <AlertDialogDescription>
              "{deletingGoal?.title}" será removida permanentemente, junto com sua mensalização e histórico. Esta ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(e) => { e.preventDefault(); if (deletingGoal) deleteGoalMutation.mutate(deletingGoal.id); }}
              disabled={deleteGoalMutation.isPending}
            >
              {deleteGoalMutation.isPending ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
}

// ── Department Goals Table ────────────────────────────────────────────────────

function DepartmentGoalsTable({
  dept,
  canEdit,
  onGoalClick,
  onEditGoal,
  onMoveGoal,
  onDeleteGoal,
}: {
  dept: DepartmentOverview;
  canEdit: boolean;
  onGoalClick: (id: string) => void;
  onEditGoal: (g: Goal) => void;
  onMoveGoal: (g: Goal, dir: "up" | "down") => void;
  onDeleteGoal: (g: Goal) => void;
}) {
  // O peso é sempre ponderado para o time somar 100% (o informado por meta fica na coluna Peso).
  const ponderadoTotal = dept.weight_total > 0 ? 100 : 0;

  return (
    <div className="space-y-3">
      {/* Indicadores agregados do time */}
      <div className="flex flex-wrap items-center justify-between gap-4 rounded-xl border bg-muted/20 px-4 py-3">
        <span className="font-semibold">{dept.department_name}</span>
        <div className="flex items-center gap-6">
          <DonutRing value={dept.pct_month} label="Mês" />
          <DonutRing value={dept.pct_cumulative} label="Até o mês" />
          <DonutRing value={dept.pct_year} label="Do ano" />
        </div>
      </div>

      {/* Weight summary */}
      <div className="flex items-center justify-between text-sm">
        <div className="flex items-center gap-2">
          <span className="text-muted-foreground">Peso total do time:</span>
          <span className="font-semibold text-emerald-600 dark:text-emerald-400">
            {ponderadoTotal}%
          </span>
          <span className="text-xs text-muted-foreground">(ponderado)</span>
        </div>
      </div>

      {dept.goals.length === 0 ? (
        <div className="rounded-xl border border-dashed p-8 text-center">
          <p className="text-sm text-muted-foreground">Nenhuma meta neste time.</p>
        </div>
      ) : (
        <div className="rounded-xl border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-muted-foreground">Meta</th>
                <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden sm:table-cell">Responsável</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground hidden md:table-cell">Cálculo</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground">
                  <span className="inline-flex items-center gap-1">Peso
                    <HelpTip side="bottom">
                      Em cima, o <b>peso informado</b> (o que você digitou). Embaixo, o <b>peso ponderado</b> —
                      recalculado para o time somar 100% (peso ÷ soma dos pesos do time).
                    </HelpTip>
                  </span>
                </th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Mês</th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Até o mês</th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Do ano</th>
                {canEdit && <th className="px-2 py-3 w-10" />}
              </tr>
            </thead>
            <tbody>
              {dept.goals.map((goal, i) => (
                <GoalRow
                  key={goal.id}
                  goal={goal}
                  weightTotal={dept.weight_total}
                  onClick={() => onGoalClick(goal.id)}
                  canEdit={canEdit}
                  isFirst={i === 0}
                  isLast={i === dept.goals.length - 1}
                  onEdit={() => onEditGoal(goal)}
                  onMoveUp={() => onMoveGoal(goal, "up")}
                  onMoveDown={() => onMoveGoal(goal, "down")}
                  onDelete={() => onDeleteGoal(goal)}
                />
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function GoalRow({
  goal, weightTotal, onClick, canEdit, isFirst, isLast, onEdit, onMoveUp, onMoveDown, onDelete,
}: {
  goal: Goal;
  weightTotal: number;
  onClick: () => void;
  canEdit: boolean;
  isFirst: boolean;
  isLast: boolean;
  onEdit: () => void;
  onMoveUp: () => void;
  onMoveDown: () => void;
  onDelete: () => void;
}) {
  const ponderado = weightTotal > 0 ? (goal.weight / weightTotal) * 100 : goal.weight;
  return (
    <tr
      className="border-t hover:bg-muted/30 cursor-pointer transition-colors"
      onClick={onClick}
    >
      <td className="px-4 py-3">
        <div className="font-medium leading-snug">{goal.title}</div>
        <div className="text-xs text-muted-foreground mt-0.5">
          {RESULT_TYPE_LABELS[goal.result_type]} · {goal.objective === "increase" ? "↑ Aumentar" : "↓ Diminuir"}
        </div>
      </td>
      <td className="px-3 py-3 text-muted-foreground text-sm hidden sm:table-cell">
        {goal.responsible_name ?? "—"}
      </td>
      <td className="px-3 py-3 text-center hidden md:table-cell">
        <Badge variant="outline" className="text-xs">{CALC_TYPE_LABELS[goal.calculation_type]}</Badge>
      </td>
      <td className="px-3 py-3 text-center">
        <div className="font-medium">{goal.weight}%</div>
        <div className="text-xs text-muted-foreground">
          pond. {ponderado.toLocaleString("pt-BR", { maximumFractionDigits: 1 })}%
        </div>
      </td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_month} label="Mês" objective={goal.objective} />
        </div>
      </td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_cumulative} label="Até o mês" objective={goal.objective} />
        </div>
      </td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_year} label="Do ano" objective={goal.objective} />
        </div>
      </td>
      {canEdit && (
        <td className="px-2 py-3" onClick={(e) => e.stopPropagation()}>
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-8 w-8 text-muted-foreground">
                <MoreVertical className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="min-w-[180px]">
              <DropdownMenuItem onClick={onEdit}>
                <Pencil className="h-3.5 w-3.5 mr-2" /> Editar
              </DropdownMenuItem>
              <DropdownMenuItem onClick={onMoveUp} disabled={isFirst}>
                <ArrowUp className="h-3.5 w-3.5 mr-2" /> Mover para cima
              </DropdownMenuItem>
              <DropdownMenuItem onClick={onMoveDown} disabled={isLast}>
                <ArrowDown className="h-3.5 w-3.5 mr-2" /> Mover para baixo
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem onClick={onDelete} className="text-destructive focus:text-destructive">
                <Trash2 className="h-3.5 w-3.5 mr-2" /> Excluir
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </td>
      )}
    </tr>
  );
}

function EditGoalLoader({
  goalId, cycleId, departments, onClose,
}: {
  goalId: string;
  cycleId: string;
  departments: { id: string; name: string }[];
  onClose: () => void;
}) {
  const { data: detail } = useQuery({
    queryKey: ["goal-detail", goalId],
    queryFn: () => goalsApi.get(goalId),
  });
  if (!detail) return null;
  return (
    <CreateGoalDialog
      key={detail.id}
      open
      onOpenChange={(o) => !o && onClose()}
      cycleId={cycleId}
      departments={departments}
      goalToEdit={detail}
    />
  );
}
