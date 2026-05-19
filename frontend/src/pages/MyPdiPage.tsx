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
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <BookOpen className="h-6 w-6" /> Meu PDI
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            Acompanhe seu Plano de Desenvolvimento Individual
          </p>
        </div>

        {!isLoading && total > 0 && (
          <div className="grid grid-cols-3 gap-4">
            <Card>
              <CardContent className="pt-6 text-center">
                <p className="text-3xl font-bold">{total}</p>
                <p className="text-sm text-muted-foreground mt-1">Planos</p>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-6 text-center">
                <p className="text-3xl font-bold text-emerald-500">{active}</p>
                <p className="text-sm text-muted-foreground mt-1">Ativos</p>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-6 text-center">
                <p className="text-3xl font-bold text-primary">{avgProgress}%</p>
                <p className="text-sm text-muted-foreground mt-1">Progresso médio</p>
              </CardContent>
            </Card>
          </div>
        )}

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : plans.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <BookOpen className="h-10 w-10 text-muted-foreground mx-auto mb-3" />
              <p className="text-muted-foreground">Nenhum PDI atribuído ainda.</p>
              <p className="text-sm text-muted-foreground mt-1">
                Seu gestor irá criar um plano de desenvolvimento para você.
              </p>
            </CardContent>
          </Card>
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
