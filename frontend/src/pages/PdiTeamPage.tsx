import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  BookOpen, Plus, ChevronDown, ChevronRight, User, Trash2,
  CheckCircle2, Clock, Loader2, Pencil, X,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Progress } from "@/components/ui/progress";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { pdi as pdiApi, evaluations as evalApi } from "@/lib/api";
import { collaborators as collabApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import type { PdiPlan, PdiAction, ActionStatus } from "@/types/pdi";
import { ACTION_STATUS_LABELS, ACTION_STATUS_COLORS } from "@/types/pdi";
import { cn } from "@/lib/utils";

export default function PdiTeamPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [expanded, setExpanded] = useState<Record<string, boolean>>({});
  const [createPlanOpen, setCreatePlanOpen] = useState(false);
  const [editingPlan, setEditingPlan] = useState<PdiPlan | null>(null);
  const [addActionPlanId, setAddActionPlanId] = useState<string | null>(null);

  const { data: plans, isLoading } = useQuery({
    queryKey: ["pdi-team"],
    queryFn: pdiApi.team,
  });

  const deletePlanMutation = useMutation({
    mutationFn: pdiApi.deletePlan,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["pdi-team"] });
      toast({ title: "Plano removido" });
    },
  });

  const updateActionMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: object }) => pdiApi.updateAction(id, data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["pdi-team"] }),
  });

  const deleteActionMutation = useMutation({
    mutationFn: pdiApi.deleteAction,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["pdi-team"] }),
  });

  const toggleExpand = (id: string) => setExpanded(prev => ({ ...prev, [id]: !prev[id] }));

  const totalPlans = plans?.length ?? 0;
  const activePlans = plans?.filter(p => p.status === "active").length ?? 0;
  const avgProgress = plans && plans.length > 0
    ? Math.round(plans.reduce((s, p) => s + p.progress, 0) / plans.length)
    : 0;

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <BookOpen className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">PDI da Equipe</h1>
          </div>
          <Button size="sm" onClick={() => setCreatePlanOpen(true)}>
            <Plus className="h-4 w-4 mr-1" /> Novo PDI
          </Button>
        </div>

        {/* Summary */}
        {plans && (
          <div className="grid grid-cols-3 gap-4">
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Total de planos</p>
              <p className="text-2xl font-bold mt-1">{totalPlans}</p>
            </div>
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Planos ativos</p>
              <p className="text-2xl font-bold mt-1 text-primary">{activePlans}</p>
            </div>
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Progresso médio</p>
              <p className="text-2xl font-bold mt-1 text-emerald-500">{avgProgress}%</p>
            </div>
          </div>
        )}

        {/* Plans list */}
        {isLoading ? (
          <div className="space-y-3">
            {[1, 2, 3].map(i => <Skeleton key={i} className="h-20 w-full rounded-xl" />)}
          </div>
        ) : !plans || plans.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <BookOpen className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum PDI criado ainda.</p>
            <Button onClick={() => setCreatePlanOpen(true)}>
              <Plus className="h-4 w-4 mr-2" /> Criar primeiro PDI
            </Button>
          </div>
        ) : (
          <div className="space-y-3">
            {plans.map(plan => (
              <div key={plan.id} className="rounded-xl border bg-card overflow-hidden">
                {/* Plan header */}
                <div className="px-4 py-3">
                  <div className="flex items-start gap-3">
                    <button onClick={() => toggleExpand(plan.id)} className="mt-0.5 shrink-0">
                      {expanded[plan.id]
                        ? <ChevronDown className="h-4 w-4 text-muted-foreground" />
                        : <ChevronRight className="h-4 w-4 text-muted-foreground" />}
                    </button>
                    <div className="flex-1 min-w-0" onClick={() => toggleExpand(plan.id)} style={{ cursor: "pointer" }}>
                      <div className="flex flex-wrap items-center gap-2 mb-1">
                        <div className="flex items-center gap-1.5">
                          <User className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                          <span className="font-semibold text-sm">{plan.user_name}</span>
                        </div>
                        {plan.department && <span className="text-xs text-muted-foreground">· {plan.department}</span>}
                        <Badge variant={plan.status === "active" ? "default" : "secondary"} className="text-[10px] h-4 px-1.5">
                          {plan.status === "active" ? "Ativo" : "Encerrado"}
                        </Badge>
                        {plan.eval_cycle_name && (
                          <Badge variant="outline" className="text-[10px] h-4 px-1.5">{plan.eval_cycle_name}</Badge>
                        )}
                      </div>
                      <p className="text-sm font-medium">{plan.title}</p>
                      {plan.description && <p className="text-xs text-muted-foreground mt-0.5 truncate">{plan.description}</p>}
                      <div className="flex items-center gap-3 mt-2">
                        <Progress value={plan.progress} className="h-1.5 flex-1" />
                        <span className="text-xs text-muted-foreground shrink-0">
                          {plan.actions_done}/{plan.actions_total} · {plan.progress}%
                        </span>
                      </div>
                    </div>
                    <div className="flex items-center gap-1 shrink-0">
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setEditingPlan(plan)}>
                        <Pencil className="h-3.5 w-3.5" />
                      </Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive"
                        onClick={() => deletePlanMutation.mutate(plan.id)}>
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                </div>

                {/* Actions */}
                {expanded[plan.id] && (
                  <div className="border-t bg-muted/20 px-4 py-3 space-y-2">
                    {plan.actions.length === 0 && (
                      <p className="text-xs text-muted-foreground py-1">Nenhuma ação ainda.</p>
                    )}
                    {plan.actions.map(action => (
                      <ActionRow
                        key={action.id}
                        action={action}
                        onStatusChange={(status) => updateActionMutation.mutate({ id: action.id, data: { ...action, status } })}
                        onDelete={() => deleteActionMutation.mutate(action.id)}
                        onEdit={(data) => updateActionMutation.mutate({ id: action.id, data })}
                      />
                    ))}
                    <Button size="sm" variant="outline" className="h-7 text-xs mt-1"
                      onClick={() => setAddActionPlanId(plan.id)}>
                      <Plus className="h-3 w-3 mr-1" /> Adicionar Ação
                    </Button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      <CreatePlanDialog
        open={createPlanOpen}
        onOpenChange={setCreatePlanOpen}
        onSaved={() => queryClient.invalidateQueries({ queryKey: ["pdi-team"] })}
      />

      {editingPlan && (
        <EditPlanDialog
          open={!!editingPlan}
          plan={editingPlan}
          onOpenChange={(open) => !open && setEditingPlan(null)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["pdi-team"] })}
        />
      )}

      {addActionPlanId && (
        <AddActionDialog
          open={!!addActionPlanId}
          planId={addActionPlanId}
          onOpenChange={(open) => !open && setAddActionPlanId(null)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["pdi-team"] })}
        />
      )}
    </AdminLayout>
  );
}

// ── Action Row ────────────────────────────────────────────────────────────────

function ActionRow({ action, onStatusChange, onDelete, onEdit }: {
  action: PdiAction;
  onStatusChange: (s: ActionStatus) => void;
  onDelete: () => void;
  onEdit: (data: object) => void;
}) {
  const [editing, setEditing] = useState(false);
  const [title, setTitle] = useState(action.title);
  const [how, setHow] = useState(action.how ?? "");
  const [dueDate, setDueDate] = useState(action.due_date ?? "");

  const StatusIcon = action.status === "done"
    ? CheckCircle2
    : action.status === "in_progress"
    ? Loader2
    : Clock;

  const nextStatus: Record<ActionStatus, ActionStatus> = {
    pending: "in_progress",
    in_progress: "done",
    done: "pending",
  };

  if (editing) {
    return (
      <div className="rounded-lg border bg-background p-3 space-y-2">
        <Input value={title} onChange={e => setTitle(e.target.value)} className="h-8 text-sm" placeholder="Título da ação" />
        <Input value={how} onChange={e => setHow(e.target.value)} className="h-8 text-sm" placeholder="Como fazer..." />
        <Input type="date" value={dueDate} onChange={e => setDueDate(e.target.value)} className="h-8 text-sm" />
        <div className="flex gap-2">
          <Button size="sm" className="h-7 text-xs" onClick={() => { onEdit({ ...action, title, how, due_date: dueDate || undefined }); setEditing(false); }}>Salvar</Button>
          <Button size="sm" variant="ghost" className="h-7 text-xs" onClick={() => setEditing(false)}>Cancelar</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-start gap-3 rounded-lg border bg-background px-3 py-2.5 group">
      <button onClick={() => onStatusChange(nextStatus[action.status])} className="mt-0.5 shrink-0">
        <StatusIcon className={cn("h-4 w-4", ACTION_STATUS_COLORS[action.status], action.status === "in_progress" && "animate-spin")} />
      </button>
      <div className="flex-1 min-w-0">
        <p className={cn("text-sm font-medium", action.status === "done" && "line-through text-muted-foreground")}>
          {action.title}
        </p>
        {action.how && <p className="text-xs text-muted-foreground mt-0.5">{action.how}</p>}
        <div className="flex items-center gap-2 mt-1">
          <Badge variant="outline" className={cn("text-[10px] h-4 px-1.5", ACTION_STATUS_COLORS[action.status])}>
            {ACTION_STATUS_LABELS[action.status]}
          </Badge>
          {action.due_date && (
            <span className="text-[10px] text-muted-foreground">
              Prazo: {new Date(action.due_date + "T12:00:00").toLocaleDateString("pt-BR")}
            </span>
          )}
        </div>
      </div>
      <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity shrink-0">
        <button onClick={() => setEditing(true)} className="hover:text-primary"><Pencil className="h-3.5 w-3.5" /></button>
        <button onClick={onDelete} className="hover:text-destructive"><X className="h-3.5 w-3.5" /></button>
      </div>
    </div>
  );
}

// ── Create Plan Dialog ────────────────────────────────────────────────────────

function CreatePlanDialog({ open, onOpenChange, onSaved }: {
  open: boolean; onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [userId, setUserId] = useState("");
  const [evalCycleId, setEvalCycleId] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");

  const { data: colabs } = useQuery({ queryKey: ["collaborators"], queryFn: () => collabApi.list() });
  const { data: cycles } = useQuery({ queryKey: ["eval-cycles"], queryFn: evalApi.listCycles });

  const mutation = useMutation({
    mutationFn: () => pdiApi.createPlan({
      user_id: userId,
      eval_cycle_id: evalCycleId && evalCycleId !== "none" ? evalCycleId : undefined,
      title,
      description: description || undefined,
    }),
    onSuccess: () => {
      toast({ title: "PDI criado com sucesso" });
      onSaved();
      onOpenChange(false);
      setUserId(""); setEvalCycleId(""); setTitle(""); setDescription("");
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Novo PDI</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Colaborador</Label>
            <Select value={userId} onValueChange={setUserId}>
              <SelectTrigger><SelectValue placeholder="Selecionar colaborador..." /></SelectTrigger>
              <SelectContent>
                {(colabs ?? []).map((c: Record<string, unknown>) => (
                  <SelectItem key={c.user_id as string} value={c.user_id as string}>
                    {c.name as string}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Ciclo de avaliação <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Select value={evalCycleId} onValueChange={setEvalCycleId}>
              <SelectTrigger><SelectValue placeholder="Nenhum" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="none">Nenhum</SelectItem>
                {(cycles ?? []).map(c => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Título do plano</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Desenvolvimento técnico 2026" />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none"
              placeholder="Contexto e objetivos gerais deste PDI..." />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!userId || !title || mutation.isPending}>
            {mutation.isPending ? "Criando..." : "Criar PDI"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Edit Plan Dialog ──────────────────────────────────────────────────────────

function EditPlanDialog({ open, plan, onOpenChange, onSaved }: {
  open: boolean; plan: PdiPlan; onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState(plan.title);
  const [description, setDescription] = useState(plan.description ?? "");
  const [planStatus, setPlanStatus] = useState(plan.status);

  const mutation = useMutation({
    mutationFn: () => pdiApi.updatePlan(plan.id, { title, description: description || undefined, status: planStatus }),
    onSuccess: () => { toast({ title: "PDI atualizado" }); onSaved(); onOpenChange(false); },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Editar PDI — {plan.user_name}</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição</Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" />
          </div>
          <div className="space-y-1.5">
            <Label>Status</Label>
            <Select value={planStatus} onValueChange={(v) => setPlanStatus(v as "active" | "closed")}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="active">Ativo</SelectItem>
                <SelectItem value="closed">Encerrado</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!title || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Add Action Dialog ─────────────────────────────────────────────────────────

function AddActionDialog({ open, planId, onOpenChange, onSaved }: {
  open: boolean; planId: string; onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState("");
  const [how, setHow] = useState("");
  const [dueDate, setDueDate] = useState("");

  const mutation = useMutation({
    mutationFn: () => pdiApi.addAction(planId, { title, how: how || undefined, due_date: dueDate || undefined }),
    onSuccess: () => {
      toast({ title: "Ação adicionada" });
      onSaved();
      onOpenChange(false);
      setTitle(""); setHow(""); setDueDate("");
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Nova Ação</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>O que fazer</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Concluir curso de liderança" />
          </div>
          <div className="space-y-1.5">
            <Label>Como fazer <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={how} onChange={e => setHow(e.target.value)} rows={2} className="resize-none"
              placeholder="Descreva o caminho, recursos ou método..." />
          </div>
          <div className="space-y-1.5">
            <Label>Prazo <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Input type="date" value={dueDate} onChange={e => setDueDate(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!title || mutation.isPending}>
            {mutation.isPending ? "Adicionando..." : "Adicionar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
