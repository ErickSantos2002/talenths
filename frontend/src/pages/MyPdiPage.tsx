import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { pdi as pdiApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { useToast } from "@/hooks/use-toast";
import type { PdiPlan, PdiAction, ActionStatus } from "@/types/pdi";
import { ACTION_STATUS_LABELS, ACTION_STATUS_COLORS } from "@/types/pdi";
import {
  CheckCircle2,
  Clock,
  Circle,
  BookOpen,
  ChevronDown,
  ChevronRight,
  CalendarDays,
} from "lucide-react";
import { cn } from "@/lib/utils";

const STATUS_CYCLE: ActionStatus[] = ["pending", "in_progress", "done"];

function nextStatus(current: ActionStatus): ActionStatus {
  const idx = STATUS_CYCLE.indexOf(current);
  return STATUS_CYCLE[(idx + 1) % STATUS_CYCLE.length];
}

function StatusIcon({ status }: { status: ActionStatus }) {
  if (status === "done") return <CheckCircle2 className="h-5 w-5 text-emerald-500 shrink-0" />;
  if (status === "in_progress") return <Clock className="h-5 w-5 text-amber-500 shrink-0" />;
  return <Circle className="h-5 w-5 text-muted-foreground shrink-0" />;
}

function ActionRow({ action, onCycleStatus }: { action: PdiAction; onCycleStatus: (id: string, status: ActionStatus) => void }) {
  return (
    <div className="flex items-start gap-3 py-2.5 border-b last:border-0">
      <button
        className="mt-0.5 cursor-pointer hover:opacity-70 transition-opacity"
        onClick={() => onCycleStatus(action.id, nextStatus(action.status))}
        title="Clique para avançar o status"
      >
        <StatusIcon status={action.status} />
      </button>
      <div className="flex-1 min-w-0">
        <p className={cn("text-sm font-medium", action.status === "done" && "line-through text-muted-foreground")}>
          {action.title}
        </p>
        {action.description && (
          <p className="text-xs text-muted-foreground mt-0.5">{action.description}</p>
        )}
        {action.how && (
          <p className="text-xs text-muted-foreground mt-0.5 italic">Como: {action.how}</p>
        )}
      </div>
      <div className="flex flex-col items-end gap-1 shrink-0">
        <span className={cn("text-xs font-medium", ACTION_STATUS_COLORS[action.status])}>
          {ACTION_STATUS_LABELS[action.status]}
        </span>
        {action.due_date && (
          <span className="flex items-center gap-1 text-xs text-muted-foreground">
            <CalendarDays className="h-3 w-3" />
            {new Date(action.due_date).toLocaleDateString("pt-BR")}
          </span>
        )}
      </div>
    </div>
  );
}

function PlanCard({ plan, onCycleStatus }: { plan: PdiPlan; onCycleStatus: (id: string, status: ActionStatus) => void }) {
  const [open, setOpen] = useState(true);

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 flex-wrap">
              <CardTitle className="text-base">{plan.title}</CardTitle>
              <Badge variant={plan.status === "active" ? "default" : "secondary"}>
                {plan.status === "active" ? "Ativo" : "Encerrado"}
              </Badge>
              {plan.eval_cycle_name && (
                <Badge variant="outline" className="text-xs">{plan.eval_cycle_name}</Badge>
              )}
            </div>
            {plan.description && (
              <p className="text-sm text-muted-foreground mt-1">{plan.description}</p>
            )}
          </div>
          <Button variant="ghost" size="icon" onClick={() => setOpen(!open)} className="shrink-0">
            {open ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
          </Button>
        </div>

        <div className="mt-3 space-y-1">
          <div className="flex items-center justify-between text-xs text-muted-foreground">
            <span>{plan.actions_done} de {plan.actions_total} ações concluídas</span>
            <span>{plan.progress}%</span>
          </div>
          <Progress value={plan.progress} className="h-1.5" />
        </div>
      </CardHeader>

      {open && plan.actions.length > 0 && (
        <CardContent className="pt-0">
          <div>
            {plan.actions.map((action) => (
              <ActionRow key={action.id} action={action} onCycleStatus={onCycleStatus} />
            ))}
          </div>
        </CardContent>
      )}

      {open && plan.actions.length === 0 && (
        <CardContent className="pt-0">
          <p className="text-sm text-muted-foreground text-center py-4">Nenhuma ação neste plano.</p>
        </CardContent>
      )}
    </Card>
  );
}

export default function MyPdiPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: plans = [], isLoading } = useQuery({
    queryKey: ["pdi-my"],
    queryFn: () => pdiApi.my(),
  });

  const updateAction = useMutation({
    mutationFn: ({ actionId, data }: { actionId: string; data: object }) =>
      pdiApi.updateAction(actionId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["pdi-my"] });
    },
    onError: () => toast({ title: "Erro ao atualizar ação", variant: "destructive" }),
  });

  function handleCycleStatus(actionId: string, newStatus: ActionStatus) {
    updateAction.mutate({ actionId, data: { status: newStatus } });
  }

  const total = plans.length;
  const active = plans.filter((p) => p.status === "active").length;
  const avgProgress = total > 0 ? Math.round(plans.reduce((s, p) => s + p.progress, 0) / total) : 0;

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <BookOpen className="h-6 w-6 text-primary" />
          <div>
            <h1 className="text-2xl font-bold">Meu PDI</h1>
            <p className="text-sm text-muted-foreground">Acompanhe seu Plano de Desenvolvimento Individual</p>
          </div>
        </div>

        {!isLoading && total > 0 && (
          <div className="grid grid-cols-3 gap-4">
            <Card className="hover:shadow-md hover:border-primary/20 transition-all">
              <CardContent className="p-5">
                <div className="flex items-center justify-between mb-3">
                  <p className="text-sm text-muted-foreground font-medium">Planos</p>
                  <div className="rounded-lg p-2 bg-primary/10">
                    <BookOpen className="h-4 w-4 text-primary" />
                  </div>
                </div>
                <p className="text-3xl font-bold tracking-tight">{total}</p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md hover:border-emerald-500/20 transition-all">
              <CardContent className="p-5">
                <div className="flex items-center justify-between mb-3">
                  <p className="text-sm text-muted-foreground font-medium">Ativos</p>
                  <div className="rounded-lg p-2 bg-emerald-500/10">
                    <CheckCircle2 className="h-4 w-4 text-emerald-400" />
                  </div>
                </div>
                <p className="text-3xl font-bold tracking-tight text-emerald-400">{active}</p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md hover:border-blue-500/20 transition-all">
              <CardContent className="p-5">
                <div className="flex items-center justify-between mb-3">
                  <p className="text-sm text-muted-foreground font-medium">Progresso médio</p>
                  <div className="rounded-lg p-2 bg-blue-500/10">
                    <Clock className="h-4 w-4 text-blue-400" />
                  </div>
                </div>
                <p className="text-3xl font-bold tracking-tight text-primary">{avgProgress}%</p>
              </CardContent>
            </Card>
          </div>
        )}

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : plans.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <BookOpen className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum PDI atribuído ainda.</p>
            <p className="text-sm text-muted-foreground mt-1">Seu gestor irá criar um plano de desenvolvimento para você.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {plans.map((plan) => (
              <PlanCard key={plan.id} plan={plan} onCycleStatus={handleCycleStatus} />
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
