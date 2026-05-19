import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { onboarding as onboardingApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { useToast } from "@/hooks/use-toast";
import { ClipboardCheck, CheckCircle2, Circle, CalendarDays, PartyPopper } from "lucide-react";
import { cn } from "@/lib/utils";

export default function MyOnboardingPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: checklist, isLoading } = useQuery({
    queryKey: ["onboarding-my"],
    queryFn: onboardingApi.my,
  });

  const completeMutation = useMutation({
    mutationFn: onboardingApi.completeTask,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["onboarding-my"] }),
    onError: () => toast({ title: "Erro ao atualizar tarefa", variant: "destructive" }),
  });

  if (isLoading) {
    return (
      <AdminLayout>
        <p className="text-sm text-muted-foreground">Carregando...</p>
      </AdminLayout>
    );
  }

  if (!checklist) {
    return (
      <AdminLayout>
        <div className="space-y-4">
          <div className="flex items-center gap-3">
            <ClipboardCheck className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold">Meu Onboarding</h1>
          </div>
          <div className="rounded-xl border border-dashed p-16 text-center">
            <ClipboardCheck className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum checklist de onboarding atribuído.</p>
            <p className="text-sm text-muted-foreground mt-1">Seu gestor irá configurar seu processo de integração.</p>
          </div>
        </div>
      </AdminLayout>
    );
  }

  const myTasks = checklist.tasks.filter(t => t.responsible_role === "user");
  const hrTasks = checklist.tasks.filter(t => t.responsible_role === "manager");
  const isComplete = checklist.progress === 100;

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <ClipboardCheck className="h-6 w-6" /> Meu Onboarding
          </h1>
          {checklist.template_name && (
            <p className="text-muted-foreground text-sm mt-1">{checklist.template_name}</p>
          )}
        </div>

        {isComplete ? (
          <div className="rounded-xl border border-emerald-300 bg-emerald-50 dark:bg-emerald-950/20 p-6 text-center">
            <PartyPopper className="mx-auto h-10 w-10 text-emerald-500 mb-2" />
            <p className="font-semibold text-emerald-700 dark:text-emerald-400">Onboarding concluído!</p>
            <p className="text-sm text-muted-foreground mt-1">Parabéns pela integração completa.</p>
          </div>
        ) : (
          <Card>
            <CardContent className="pt-6 space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">{checklist.tasks_done} de {checklist.tasks_total} tarefas concluídas</span>
                <span className="font-semibold">{checklist.progress}%</span>
              </div>
              <Progress value={checklist.progress} className="h-2" />
            </CardContent>
          </Card>
        )}

        {myTasks.length > 0 && (
          <div className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
              Suas tarefas
            </h2>
            <div className="space-y-2">
              {myTasks.map(task => (
                <div key={task.id} className={cn(
                  "flex items-start gap-3 rounded-xl border bg-card px-4 py-3",
                  task.completed_at && "opacity-60"
                )}>
                  <button
                    className="mt-0.5 shrink-0 hover:opacity-70 transition-opacity"
                    onClick={() => completeMutation.mutate(task.id)}
                    title="Clique para marcar/desmarcar"
                  >
                    {task.completed_at
                      ? <CheckCircle2 className="h-5 w-5 text-emerald-500" />
                      : <Circle className="h-5 w-5 text-muted-foreground" />}
                  </button>
                  <div className="flex-1 min-w-0">
                    <p className={cn("text-sm font-medium", task.completed_at && "line-through")}>
                      {task.title}
                    </p>
                    {task.description && (
                      <p className="text-xs text-muted-foreground mt-0.5">{task.description}</p>
                    )}
                  </div>
                  {task.due_date && (
                    <span className="flex items-center gap-1 text-xs text-muted-foreground shrink-0">
                      <CalendarDays className="h-3 w-3" />
                      {new Date(task.due_date + "T12:00:00").toLocaleDateString("pt-BR")}
                    </span>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {hrTasks.length > 0 && (
          <div className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
              Tarefas do RH
            </h2>
            <div className="space-y-2">
              {hrTasks.map(task => (
                <div key={task.id} className={cn(
                  "flex items-start gap-3 rounded-xl border bg-muted/40 px-4 py-3",
                  task.completed_at && "opacity-60"
                )}>
                  {task.completed_at
                    ? <CheckCircle2 className="h-5 w-5 text-emerald-500 mt-0.5 shrink-0" />
                    : <Circle className="h-5 w-5 text-muted-foreground mt-0.5 shrink-0" />}
                  <div className="flex-1 min-w-0">
                    <p className={cn("text-sm font-medium", task.completed_at && "line-through text-muted-foreground")}>
                      {task.title}
                    </p>
                    {task.description && (
                      <p className="text-xs text-muted-foreground mt-0.5">{task.description}</p>
                    )}
                  </div>
                  <Badge variant="secondary" className="text-[10px] h-4 px-1.5 shrink-0">RH</Badge>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
