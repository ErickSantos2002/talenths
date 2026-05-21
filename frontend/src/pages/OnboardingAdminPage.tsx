import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { onboarding as onboardingApi, collaborators as collabApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Progress } from "@/components/ui/progress";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/hooks/use-toast";
import type { OnboardingTemplate, OnboardingChecklist } from "@/types/onboarding";
import { ClipboardCheck, Plus, Pencil, Trash2, Users, ChevronDown, ChevronRight, UserPlus, CheckCircle2, Circle, CalendarDays } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Assign Dialog ─────────────────────────────────────────────────────────────

function AssignDialog({ templates, onOpenChange, onSaved }: {
  templates: OnboardingTemplate[];
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [userId, setUserId] = useState("");
  const [templateId, setTemplateId] = useState("none");
  const [startedAt, setStartedAt] = useState(new Date().toISOString().slice(0, 10));

  const { data: colabs = [] } = useQuery({ queryKey: ["collaborators"], queryFn: () => collabApi.list() });

  const mutation = useMutation({
    mutationFn: () => onboardingApi.assign({
      user_id: userId,
      template_id: templateId !== "none" ? templateId : undefined,
      started_at: startedAt,
    }),
    onSuccess: () => {
      toast({ title: "Onboarding atribuído com sucesso" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Atribuir Onboarding</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Colaborador</Label>
            <Select value={userId} onValueChange={setUserId}>
              <SelectTrigger><SelectValue placeholder="Selecionar colaborador..." /></SelectTrigger>
              <SelectContent>
                {(colabs as Record<string, unknown>[]).map(c => (
                  <SelectItem key={c.user_id as string} value={c.user_id as string}>
                    {c.name as string}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Template <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Select value={templateId} onValueChange={setTemplateId}>
              <SelectTrigger><SelectValue placeholder="Sem template" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="none">Sem template</SelectItem>
                {templates.map(t => (
                  <SelectItem key={t.id} value={t.id}>{t.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Data de início</Label>
            <Input type="date" value={startedAt} onChange={e => setStartedAt(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!userId || mutation.isPending}>
            {mutation.isPending ? "Atribuindo..." : "Atribuir"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Template Dialog ───────────────────────────────────────────────────────────

function TemplateDialog({ template, onOpenChange, onSaved }: {
  template: OnboardingTemplate | null;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [name, setName] = useState(template?.name ?? "");
  const [description, setDescription] = useState(template?.description ?? "");

  const mutation = useMutation({
    mutationFn: () => {
      const data = { name, description: description || undefined };
      return template
        ? onboardingApi.updateTemplate(template.id, data)
        : onboardingApi.createTemplate(data);
    },
    onSuccess: () => {
      toast({ title: template ? "Template atualizado" : "Template criado" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>{template ? "Editar Template" : "Novo Template"}</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Nome do template</Label>
            <Input value={name} onChange={e => setName(e.target.value)} placeholder="Ex: Onboarding Geral" />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!name || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Add Task Dialog ───────────────────────────────────────────────────────────

function AddTaskDialog({ templateId, onOpenChange, onSaved }: {
  templateId: string;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [responsibleRole, setResponsibleRole] = useState("user");
  const [dueDays, setDueDays] = useState("7");

  const mutation = useMutation({
    mutationFn: () => onboardingApi.addTemplateTask(templateId, {
      title, description: description || undefined,
      responsible_role: responsibleRole, due_days: parseInt(dueDays) || 7,
    }),
    onSuccess: () => { toast({ title: "Tarefa adicionada" }); onSaved(); onOpenChange(false); },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Nova Tarefa</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Assinar contrato de trabalho" />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Responsável</Label>
              <Select value={responsibleRole} onValueChange={setResponsibleRole}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="user">Colaborador</SelectItem>
                  <SelectItem value="manager">Gestor/RH</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Prazo (dias)</Label>
              <Input type="number" min="1" value={dueDays} onChange={e => setDueDays(e.target.value)} />
            </div>
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

// ── Checklist Card ────────────────────────────────────────────────────────────

function ChecklistCard({ checklist }: { checklist: OnboardingChecklist }) {
  const [open, setOpen] = useState(false);
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const completeMutation = useMutation({
    mutationFn: onboardingApi.completeTask,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["onboarding-team"] }),
    onError: () => toast({ title: "Erro ao atualizar tarefa", variant: "destructive" }),
  });

  const deleteMutation = useMutation({
    mutationFn: onboardingApi.deleteChecklist,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["onboarding-team"] });
      toast({ title: "Checklist removido" });
    },
  });

  return (
    <Card>
      <CardHeader className="pb-2 pt-4 px-4">
        <div className="flex items-start gap-2">
          <button onClick={() => setOpen(!open)} className="mt-0.5 shrink-0">
            {open ? <ChevronDown className="h-4 w-4 text-muted-foreground" /> : <ChevronRight className="h-4 w-4 text-muted-foreground" />}
          </button>
          <div className="flex-1 min-w-0" onClick={() => setOpen(!open)} style={{ cursor: "pointer" }}>
            <div className="flex flex-wrap items-center gap-2 mb-1">
              <CardTitle className="text-sm font-semibold">{checklist.user_name}</CardTitle>
              {checklist.department && <span className="text-xs text-muted-foreground">· {checklist.department}</span>}
              {checklist.template_name && (
                <Badge variant="outline" className="text-[10px] h-4 px-1.5">{checklist.template_name}</Badge>
              )}
            </div>
            <div className="flex items-center gap-3 mt-1">
              <Progress value={checklist.progress} className="h-1.5 flex-1 max-w-xs" />
              <span className="text-xs text-muted-foreground shrink-0">
                {checklist.tasks_done}/{checklist.tasks_total} · {checklist.progress}%
              </span>
            </div>
          </div>
          <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive shrink-0"
            onClick={() => deleteMutation.mutate(checklist.id)}>
            <Trash2 className="h-3.5 w-3.5" />
          </Button>
        </div>
      </CardHeader>
      {open && (
        <CardContent className="px-4 pb-4 pt-0">
          {checklist.tasks.length === 0 ? (
            <p className="text-xs text-muted-foreground">Nenhuma tarefa neste checklist.</p>
          ) : (
            <div className="space-y-1.5">
              {checklist.tasks.map(task => (
                <div key={task.id} className="flex items-start gap-2.5 py-1.5 border-b last:border-0">
                  <button
                    className="mt-0.5 shrink-0 hover:opacity-70 transition-opacity"
                    onClick={() => completeMutation.mutate(task.id)}
                  >
                    {task.completed_at
                      ? <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                      : <Circle className="h-4 w-4 text-muted-foreground" />}
                  </button>
                  <div className="flex-1 min-w-0">
                    <p className={cn("text-sm", task.completed_at && "line-through text-muted-foreground")}>
                      {task.title}
                    </p>
                    {task.description && <p className="text-xs text-muted-foreground mt-0.5">{task.description}</p>}
                  </div>
                  <div className="flex items-center gap-2 shrink-0">
                    <Badge variant="secondary" className="text-[10px] h-4 px-1.5">
                      {task.responsible_role === "manager" ? "RH" : "Colaborador"}
                    </Badge>
                    {task.due_date && (
                      <span className="flex items-center gap-1 text-[10px] text-muted-foreground">
                        <CalendarDays className="h-3 w-3" />
                        {new Date(task.due_date + "T12:00:00").toLocaleDateString("pt-BR")}
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      )}
    </Card>
  );
}

// ── Templates Tab ─────────────────────────────────────────────────────────────

function TemplatesTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [templateDialog, setTemplateDialog] = useState<OnboardingTemplate | null | undefined>(undefined);
  const [addTaskTemplateId, setAddTaskTemplateId] = useState<string | null>(null);

  const { data: templates = [], isLoading } = useQuery({
    queryKey: ["onboarding-templates"],
    queryFn: onboardingApi.listTemplates,
  });

  const deleteTemplateMutation = useMutation({
    mutationFn: onboardingApi.deleteTemplate,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["onboarding-templates"] });
      toast({ title: "Template removido" });
    },
  });

  const deleteTaskMutation = useMutation({
    mutationFn: onboardingApi.deleteTemplateTask,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["onboarding-templates"] }),
  });

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button size="sm" onClick={() => setTemplateDialog(null)}>
          <Plus className="h-4 w-4 mr-1" /> Novo template
        </Button>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : templates.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <ClipboardCheck className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground mb-3">Nenhum template criado ainda.</p>
          <Button size="sm" onClick={() => setTemplateDialog(null)}>
            <Plus className="h-4 w-4 mr-1" /> Criar primeiro template
          </Button>
        </div>
      ) : (
        <div className="space-y-4">
          {templates.map(t => (
            <Card key={t.id}>
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between gap-2">
                  <div>
                    <CardTitle className="text-sm">{t.name}</CardTitle>
                    {t.description && <p className="text-xs text-muted-foreground mt-0.5">{t.description}</p>}
                  </div>
                  <div className="flex gap-1 shrink-0">
                    <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setTemplateDialog(t)}>
                      <Pencil className="h-3.5 w-3.5" />
                    </Button>
                    <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive"
                      onClick={() => deleteTemplateMutation.mutate(t.id)}>
                      <Trash2 className="h-3.5 w-3.5" />
                    </Button>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="pt-0 space-y-1.5">
                {t.tasks.map(task => (
                  <div key={task.id} className="flex items-center gap-2 py-1 border-b last:border-0">
                    <Circle className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                    <span className="flex-1 text-sm min-w-0 truncate">{task.title}</span>
                    <Badge variant="secondary" className="text-[10px] h-4 px-1.5 shrink-0">
                      {task.responsible_role === "manager" ? "RH" : "Colaborador"}
                    </Badge>
                    <span className="text-[10px] text-muted-foreground shrink-0">D+{task.due_days}</span>
                    <button onClick={() => deleteTaskMutation.mutate(task.id)} className="hover:text-destructive shrink-0">
                      <Trash2 className="h-3.5 w-3.5" />
                    </button>
                  </div>
                ))}
                <Button size="sm" variant="ghost" className="h-7 text-xs mt-1 w-full justify-start"
                  onClick={() => setAddTaskTemplateId(t.id)}>
                  <Plus className="h-3 w-3 mr-1" /> Adicionar tarefa
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {templateDialog !== undefined && (
        <TemplateDialog
          template={templateDialog}
          onOpenChange={open => !open && setTemplateDialog(undefined)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["onboarding-templates"] })}
        />
      )}
      {addTaskTemplateId && (
        <AddTaskDialog
          templateId={addTaskTemplateId}
          onOpenChange={open => !open && setAddTaskTemplateId(null)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["onboarding-templates"] })}
        />
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function OnboardingAdminPage() {
  const queryClient = useQueryClient();
  const [assignOpen, setAssignOpen] = useState(false);

  const { data: checklists = [], isLoading } = useQuery({
    queryKey: ["onboarding-team"],
    queryFn: onboardingApi.team,
  });

  const { data: templates = [] } = useQuery({
    queryKey: ["onboarding-templates"],
    queryFn: onboardingApi.listTemplates,
  });

  const total = checklists.length;
  const completed = checklists.filter(c => c.progress === 100).length;
  const avgProgress = total > 0 ? Math.round(checklists.reduce((s, c) => s + c.progress, 0) / total) : 0;

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <ClipboardCheck className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Onboarding Digital</h1>
          </div>
          <Button size="sm" onClick={() => setAssignOpen(true)}>
            <UserPlus className="h-4 w-4 mr-1" /> Atribuir Onboarding
          </Button>
        </div>

        <Tabs defaultValue="team">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger value="team" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2">
              <Users className="h-4 w-4" /> Equipe
            </TabsTrigger>
            <TabsTrigger value="templates" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2">
              <ClipboardCheck className="h-4 w-4" /> Templates
            </TabsTrigger>
          </TabsList>

          <TabsContent value="team" className="mt-4 space-y-4">
            {!isLoading && total > 0 && (
              <div className="grid grid-cols-3 gap-4">
                <Card><CardContent className="pt-4 pb-3 text-center">
                  <p className="text-2xl font-bold">{total}</p>
                  <p className="text-xs text-muted-foreground mt-1">Em onboarding</p>
                </CardContent></Card>
                <Card><CardContent className="pt-4 pb-3 text-center">
                  <p className="text-2xl font-bold text-emerald-500">{completed}</p>
                  <p className="text-xs text-muted-foreground mt-1">Concluídos</p>
                </CardContent></Card>
                <Card><CardContent className="pt-4 pb-3 text-center">
                  <p className="text-2xl font-bold text-primary">{avgProgress}%</p>
                  <p className="text-xs text-muted-foreground mt-1">Progresso médio</p>
                </CardContent></Card>
              </div>
            )}

            {isLoading ? (
              <p className="text-sm text-muted-foreground">Carregando...</p>
            ) : checklists.length === 0 ? (
              <div className="rounded-xl border border-dashed p-12 text-center">
                <Users className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground mb-3">Nenhum onboarding atribuído ainda.</p>
                <Button size="sm" onClick={() => setAssignOpen(true)}>
                  <UserPlus className="h-4 w-4 mr-1" /> Atribuir primeiro
                </Button>
              </div>
            ) : (
              <div className="space-y-3">
                {checklists.map(c => <ChecklistCard key={c.id} checklist={c} />)}
              </div>
            )}
          </TabsContent>

          <TabsContent value="templates" className="mt-4">
            <TemplatesTab />
          </TabsContent>
        </Tabs>

        {assignOpen && (
          <AssignDialog
            templates={templates}
            onOpenChange={setAssignOpen}
            onSaved={() => queryClient.invalidateQueries({ queryKey: ["onboarding-team"] })}
          />
        )}
      </div>
    </AdminLayout>
  );
}
