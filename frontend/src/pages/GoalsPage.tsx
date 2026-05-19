import { useState, useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { Target, Plus, TriangleAlert, ChevronDown } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useAuth } from "@/contexts/AuthContext";
import { goals as goalsApi, departments as deptsApi } from "@/lib/api";
import type { DepartmentOverview, Goal } from "@/types/goals";
import { CALC_TYPE_LABELS, RESULT_TYPE_LABELS, formatGoalValue } from "@/types/goals";
import { DonutRing } from "@/components/goals/DonutRing";
import { CreateCycleDialog } from "@/components/goals/CreateCycleDialog";
import { CreateGoalDialog } from "@/components/goals/CreateGoalDialog";
import { GoalDetailModal } from "@/components/goals/GoalDetailModal";

export default function GoalsPage() {
  const { hasRole } = useAuth();
  const canEdit = hasRole("master_admin") || hasRole("manager");

  const [selectedCycleId, setSelectedCycleId] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<string>("");
  const [createCycleOpen, setCreateCycleOpen] = useState(false);
  const [createGoalOpen, setCreateGoalOpen] = useState(false);
  const [createGoalDeptId, setCreateGoalDeptId] = useState<string | undefined>();
  const [selectedGoalId, setSelectedGoalId] = useState<string | null>(null);

  const { data: cycles, isLoading: cyclesLoading } = useQuery({
    queryKey: ["goal-cycles"],
    queryFn: goalsApi.listCycles,
  });

  const { data: overview, isLoading: overviewLoading } = useQuery({
    queryKey: ["goals-overview", selectedCycleId],
    queryFn: () => goalsApi.overview(selectedCycleId!),
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
                      <span>{c.name}</span>
                      <Badge variant={c.status === "active" ? "default" : "outline"} className="text-[10px] h-4 px-1.5">
                        {c.status === "active" ? "Ativo" : c.status === "draft" ? "Rascunho" : "Encerrado"}
                      </Badge>
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
            ) : null}

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
                      {Math.abs(dept.weight_total - 100) > 0.01 && (
                        <span className="ml-1.5 inline-flex items-center justify-center rounded-full bg-amber-500/20 text-amber-600 dark:text-amber-400 text-[10px] font-bold px-1.5 h-4">
                          {dept.weight_total}%
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
                      onNewGoal={() => openCreateGoal(dept.department_id)}
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
        />
      )}
    </AdminLayout>
  );
}

// ── Department Goals Table ────────────────────────────────────────────────────

function DepartmentGoalsTable({
  dept,
  canEdit,
  onGoalClick,
  onNewGoal,
}: {
  dept: DepartmentOverview;
  canEdit: boolean;
  onGoalClick: (id: string) => void;
  onNewGoal: () => void;
}) {
  const weightOk = Math.abs(dept.weight_total - 100) <= 0.01;

  return (
    <div className="space-y-3">
      {/* Weight summary */}
      <div className="flex items-center justify-between text-sm">
        <div className="flex items-center gap-2">
          <span className="text-muted-foreground">Peso total do departamento:</span>
          <span className={`font-semibold ${weightOk ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400"}`}>
            {dept.weight_total}%
          </span>
          {!weightOk && (
            <span className="flex items-center gap-1 text-amber-600 dark:text-amber-400 text-xs">
              <TriangleAlert className="h-3.5 w-3.5" /> Pesos não somam 100%
            </span>
          )}
        </div>
        {canEdit && (
          <Button size="sm" variant="outline" onClick={onNewGoal}>
            <Plus className="h-3.5 w-3.5 mr-1" /> Nova Meta
          </Button>
        )}
      </div>

      {dept.goals.length === 0 ? (
        <div className="rounded-xl border border-dashed p-8 text-center">
          <p className="text-sm text-muted-foreground">Nenhuma meta neste departamento.</p>
        </div>
      ) : (
        <div className="rounded-xl border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-muted-foreground">Meta</th>
                <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden sm:table-cell">Responsável</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground hidden md:table-cell">Cálculo</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground">Peso</th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Mês</th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Acum.</th>
                <th className="text-center px-4 py-3 font-medium text-muted-foreground">Ano</th>
              </tr>
            </thead>
            <tbody>
              {dept.goals.map((goal) => (
                <GoalRow key={goal.id} goal={goal} onClick={() => onGoalClick(goal.id)} />
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function GoalRow({ goal, onClick }: { goal: Goal; onClick: () => void }) {
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
      <td className="px-3 py-3 text-center font-medium">{goal.weight}%</td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_month} label="Mês" objective={goal.objective} />
        </div>
      </td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_cumulative} label="Acum." objective={goal.objective} />
        </div>
      </td>
      <td className="px-4 py-3">
        <div className="flex justify-center">
          <DonutRing value={goal.pct_year} label="Ano" objective={goal.objective} />
        </div>
      </td>
    </tr>
  );
}
