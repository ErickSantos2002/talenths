import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";
import { customTests } from "@/lib/api";
import type { CustomTest } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { ClipboardList, Plus, Pencil, Trash2, Eye, Copy, Users } from "lucide-react";
import { cn } from "@/lib/utils";

const STATUS_LABELS: Record<string, string> = {
  draft: "Rascunho",
  published: "Publicado",
  archived: "Arquivado",
};

const STATUS_COLORS: Record<string, string> = {
  draft: "bg-amber-500/15 text-amber-400 border-amber-500/20",
  published: "bg-emerald-500/15 text-emerald-400 border-emerald-500/20",
  archived: "bg-slate-500/15 text-slate-400 border-slate-500/20",
};

const SCORING_LABELS: Record<string, string> = {
  auto: "Automática",
  manual: "Manual",
  mixed: "Mista",
};

type CreateForm = {
  title: string;
  description: string;
  instructions: string;
  scoring_mode: string;
};

const empty: CreateForm = { title: "", description: "", instructions: "", scoring_mode: "auto" };

export default function AdminTestesPage() {
  const qc = useQueryClient();
  const navigate = useNavigate();
  const { toast } = useToast();
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState<CreateForm>(empty);
  const [deleteTarget, setDeleteTarget] = useState<CustomTest | null>(null);

  const { data: tests = [], isLoading } = useQuery({
    queryKey: ["admin-tests"],
    queryFn: () => customTests.list(),
  });

  const createMut = useMutation({
    mutationFn: (data: CreateForm) => customTests.create(data),
    onSuccess: (test) => {
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      setShowCreate(false);
      setForm(empty);
      toast({ title: "Teste criado" });
      navigate(`/admin/testes/${test.id}/editar`);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const deleteMut = useMutation({
    mutationFn: (id: string) => customTests.delete(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      setDeleteTarget(null);
      toast({ title: "Teste excluído" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const duplicateMut = useMutation({
    mutationFn: (id: string) => customTests.duplicate(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      toast({ title: "Teste duplicado" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <ClipboardList className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-semibold">Testes</h1>
          </div>
          <Button onClick={() => setShowCreate(true)}>
            <Plus className="h-4 w-4 mr-2" /> Novo Teste
          </Button>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : tests.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-muted-foreground">
            <ClipboardList className="h-12 w-12 mb-4 opacity-30" />
            <p className="text-base font-medium">Nenhum teste criado ainda</p>
            <p className="text-sm mt-1">Clique em "Novo Teste" para começar</p>
          </div>
        ) : (
          <div className="space-y-3">
            {tests.map((test) => (
              <Card key={test.id} className="hover:shadow-md hover:border-border/80 transition-all">
                <CardContent className="p-4">
                  <div className="flex items-start gap-4">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-medium">{test.title}</span>
                        <Badge className={cn("text-xs", STATUS_COLORS[test.status])}>
                          {STATUS_LABELS[test.status]}
                        </Badge>
                        <span className="text-xs text-muted-foreground">
                          {SCORING_LABELS[test.scoring_mode]}
                        </span>
                      </div>
                      {test.description && (
                        <p className="text-sm text-muted-foreground mt-1 line-clamp-1">{test.description}</p>
                      )}
                      <div className="flex items-center gap-4 mt-2 text-xs text-muted-foreground">
                        <span>{test.question_count ?? 0} perguntas</span>
                        <span>{test.total_points} pts total</span>
                        {test.attempt_count !== undefined && (
                          <span className="flex items-center gap-1">
                            <Users className="h-3 w-3" /> {test.attempt_count} tentativas
                          </span>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center gap-1.5 shrink-0">
                      {test.status === "draft" && (
                        <button
                          onClick={() => navigate(`/admin/testes/${test.id}/editar`)}
                          title="Editar"
                          className="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25"
                        >
                          <Pencil className="h-3.5 w-3.5" />
                        </button>
                      )}
                      <button
                        onClick={() => navigate(`/admin/testes/${test.id}/tentativas`)}
                        title="Ver tentativas"
                        className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-500/15 text-blue-500 transition-colors hover:bg-blue-500/25"
                      >
                        <Eye className="h-3.5 w-3.5" />
                      </button>
                      <button
                        onClick={() => duplicateMut.mutate(test.id)}
                        title="Duplicar"
                        disabled={duplicateMut.isPending}
                        className="flex h-8 w-8 items-center justify-center rounded-lg bg-muted text-muted-foreground transition-colors hover:bg-muted/80 disabled:opacity-40"
                      >
                        <Copy className="h-3.5 w-3.5" />
                      </button>
                      {test.status === "draft" && (
                        <button
                          onClick={() => setDeleteTarget(test)}
                          title="Excluir"
                          className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>

      {/* Criar Teste */}
      <Dialog open={showCreate} onOpenChange={setShowCreate}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Novo Teste</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <Label>Título *</Label>
              <Input
                value={form.title}
                onChange={(e) => setForm({ ...form, title: e.target.value })}
                placeholder="Ex: Avaliação de Segurança do Trabalho"
              />
            </div>
            <div className="space-y-1.5">
              <Label>Descrição</Label>
              <Textarea
                value={form.description}
                onChange={(e) => setForm({ ...form, description: e.target.value })}
                rows={2}
                placeholder="Breve descrição para o colaborador"
              />
            </div>
            <div className="space-y-1.5">
              <Label>Modo de avaliação</Label>
              <Select value={form.scoring_mode} onValueChange={(v) => setForm({ ...form, scoring_mode: v })}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="auto">Automática — resultado imediato</SelectItem>
                  <SelectItem value="manual">Manual — RH avalia tudo</SelectItem>
                  <SelectItem value="mixed">Mista — automática + revisão de abertas</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setShowCreate(false); setForm(empty); }}>
              Cancelar
            </Button>
            <Button
              onClick={() => createMut.mutate(form)}
              disabled={!form.title.trim() || createMut.isPending}
            >
              Criar e editar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Confirmar exclusão */}
      <Dialog open={!!deleteTarget} onOpenChange={() => setDeleteTarget(null)}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>Excluir teste?</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground">
            O teste <strong>{deleteTarget?.title}</strong> e todas as suas perguntas serão excluídos permanentemente.
          </p>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteTarget(null)}>Cancelar</Button>
            <Button
              variant="destructive"
              onClick={() => deleteTarget && deleteMut.mutate(deleteTarget.id)}
              disabled={deleteMut.isPending}
            >
              Excluir
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
