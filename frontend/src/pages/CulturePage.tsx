import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Pencil, Trash2, Plus, X, Check, HeartHandshake } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { culture as cultureApi } from "@/lib/api";

interface CultureValue {
  id: string;
  title: string;
  description: string | null;
  position: number;
}

interface CultureData {
  purpose: string | null;
  manifesto: string | null;
  updated_at: string | null;
  values: CultureValue[];
}

export default function CulturePage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const canEdit = hasRole("master_admin") || hasRole("manager");

  const [editingPurpose, setEditingPurpose] = useState(false);
  const [editingManifesto, setEditingManifesto] = useState(false);
  const [purposeDraft, setPurposeDraft] = useState("");
  const [manifestoDraft, setManifestoDraft] = useState("");

  const [valueDialog, setValueDialog] = useState<{ open: boolean; editing: CultureValue | null }>({ open: false, editing: null });
  const [valueTitle, setValueTitle] = useState("");
  const [valueDescription, setValueDescription] = useState("");

  const [deleteTarget, setDeleteTarget] = useState<string | null>(null);

  const { data, isLoading } = useQuery<CultureData>({
    queryKey: ["culture"],
    queryFn: () => cultureApi.get(),
  });

  const updateCultureMutation = useMutation({
    mutationFn: (payload: { purpose?: string; manifesto?: string }) => cultureApi.update(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Salvo com sucesso" });
    },
    onError: (err: Error) => toast({ title: "Erro ao salvar", description: err.message, variant: "destructive" }),
  });

  const createValueMutation = useMutation({
    mutationFn: (payload: { title: string; description?: string }) => cultureApi.createValue(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor criado" });
      setValueDialog({ open: false, editing: null });
    },
    onError: (err: Error) => toast({ title: "Erro ao criar valor", description: err.message, variant: "destructive" }),
  });

  const updateValueMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: { title?: string; description?: string } }) =>
      cultureApi.updateValue(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor atualizado" });
      setValueDialog({ open: false, editing: null });
    },
    onError: (err: Error) => toast({ title: "Erro ao atualizar valor", description: err.message, variant: "destructive" }),
  });

  const deleteValueMutation = useMutation({
    mutationFn: (id: string) => cultureApi.deleteValue(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor removido" });
      setDeleteTarget(null);
    },
    onError: (err: Error) => toast({ title: "Erro ao remover valor", description: err.message, variant: "destructive" }),
  });

  const startEditPurpose = () => {
    setPurposeDraft(data?.purpose ?? "");
    setEditingPurpose(true);
  };

  const savePurpose = () => {
    updateCultureMutation.mutate({ purpose: purposeDraft });
    setEditingPurpose(false);
  };

  const startEditManifesto = () => {
    setManifestoDraft(data?.manifesto ?? "");
    setEditingManifesto(true);
  };

  const saveManifesto = () => {
    updateCultureMutation.mutate({ manifesto: manifestoDraft });
    setEditingManifesto(false);
  };

  const openCreateValue = () => {
    setValueTitle("");
    setValueDescription("");
    setValueDialog({ open: true, editing: null });
  };

  const openEditValue = (v: CultureValue) => {
    setValueTitle(v.title);
    setValueDescription(v.description ?? "");
    setValueDialog({ open: true, editing: v });
  };

  const submitValueDialog = () => {
    if (!valueTitle.trim()) return;
    if (valueDialog.editing) {
      updateValueMutation.mutate({
        id: valueDialog.editing.id,
        data: { title: valueTitle.trim(), description: valueDescription.trim() || undefined },
      });
    } else {
      createValueMutation.mutate({
        title: valueTitle.trim(),
        description: valueDescription.trim() || undefined,
      });
    }
  };

  const isSavingValue = createValueMutation.isPending || updateValueMutation.isPending;

  return (
    <AdminLayout>
      <div className="space-y-10 pb-16">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <HeartHandshake className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Nossa Cultura — Health Safety</h1>
          </div>
        </div>

        {/* Purpose */}
        <section className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-muted-foreground uppercase tracking-wider">Propósito</h2>
            {canEdit && !editingPurpose && (
              <Button variant="ghost" size="sm" onClick={startEditPurpose}>
                <Pencil className="h-4 w-4 mr-2" />
                Editar
              </Button>
            )}
          </div>

          {isLoading ? (
            <Skeleton className="h-20 w-full" />
          ) : editingPurpose ? (
            <div className="space-y-3">
              <Textarea
                value={purposeDraft}
                onChange={(e) => setPurposeDraft(e.target.value)}
                rows={4}
                placeholder="Descreva o propósito da empresa..."
                className="text-lg resize-none"
              />
              <div className="flex gap-2">
                <Button size="sm" onClick={savePurpose} disabled={updateCultureMutation.isPending}>
                  <Check className="h-4 w-4 mr-2" />
                  Salvar
                </Button>
                <Button size="sm" variant="ghost" onClick={() => setEditingPurpose(false)}>
                  <X className="h-4 w-4 mr-2" />
                  Cancelar
                </Button>
              </div>
            </div>
          ) : (
            <div className="rounded-xl bg-primary/5 border border-primary/10 p-8">
              {data?.purpose ? (
                <p className="text-2xl font-medium leading-relaxed text-foreground">{data.purpose}</p>
              ) : (
                <p className="text-lg text-muted-foreground italic">Em breve</p>
              )}
            </div>
          )}
        </section>

        {/* Manifesto */}
        <section className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-muted-foreground uppercase tracking-wider">Manifesto</h2>
            {canEdit && !editingManifesto && (
              <Button variant="ghost" size="sm" onClick={startEditManifesto}>
                <Pencil className="h-4 w-4 mr-2" />
                Editar
              </Button>
            )}
          </div>

          {isLoading ? (
            <Skeleton className="h-32 w-full" />
          ) : editingManifesto ? (
            <div className="space-y-3">
              <Textarea
                value={manifestoDraft}
                onChange={(e) => setManifestoDraft(e.target.value)}
                rows={6}
                placeholder="Escreva o manifesto da empresa..."
                className="resize-none"
              />
              <div className="flex gap-2">
                <Button size="sm" onClick={saveManifesto} disabled={updateCultureMutation.isPending}>
                  <Check className="h-4 w-4 mr-2" />
                  Salvar
                </Button>
                <Button size="sm" variant="ghost" onClick={() => setEditingManifesto(false)}>
                  <X className="h-4 w-4 mr-2" />
                  Cancelar
                </Button>
              </div>
            </div>
          ) : (
            <div className="rounded-xl border bg-muted/30 p-8">
              {data?.manifesto ? (
                <blockquote className="border-l-4 border-primary pl-6 italic text-base leading-relaxed text-foreground whitespace-pre-wrap">
                  {data.manifesto}
                </blockquote>
              ) : (
                <p className="text-base text-muted-foreground italic">Em breve</p>
              )}
            </div>
          )}
        </section>

        {/* Values */}
        <section className="space-y-6">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-muted-foreground uppercase tracking-wider">Nossos Valores</h2>
            {canEdit && (
              <Button size="sm" onClick={openCreateValue}>
                <Plus className="h-4 w-4 mr-2" />
                Adicionar Valor
              </Button>
            )}
          </div>

          {isLoading ? (
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-36" />
              ))}
            </div>
          ) : data?.values && data.values.length > 0 ? (
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {data.values.map((v) => (
                <Card key={v.id} className="group relative hover:shadow-md transition-shadow">
                  <CardHeader className="pb-2">
                    <div className="flex items-start justify-between gap-2">
                      <CardTitle className="text-base font-semibold leading-snug">{v.title}</CardTitle>
                      {canEdit && (
                        <div className="flex shrink-0 gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                          <Button
                            variant="ghost"
                            size="icon"
                            className="h-7 w-7"
                            onClick={() => openEditValue(v)}
                          >
                            <Pencil className="h-3.5 w-3.5" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="icon"
                            className="h-7 w-7 text-destructive hover:text-destructive hover:bg-destructive/10"
                            onClick={() => setDeleteTarget(v.id)}
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </div>
                      )}
                    </div>
                  </CardHeader>
                  {v.description && (
                    <CardContent>
                      <p className="text-sm text-muted-foreground leading-relaxed">{v.description}</p>
                    </CardContent>
                  )}
                </Card>
              ))}
            </div>
          ) : (
            <div className="rounded-xl border border-dashed p-12 text-center">
              <HeartHandshake className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
              <p className="text-muted-foreground">Nenhum valor cadastrado ainda.</p>
              {canEdit && (
                <Button variant="outline" size="sm" className="mt-4" onClick={openCreateValue}>
                  <Plus className="h-4 w-4 mr-2" />
                  Adicionar primeiro valor
                </Button>
              )}
            </div>
          )}
        </section>
      </div>

      <Dialog
        open={valueDialog.open}
        onOpenChange={(open) => !open && setValueDialog({ open: false, editing: null })}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{valueDialog.editing ? "Editar Valor" : "Novo Valor"}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <label className="text-sm font-medium">Título</label>
              <Input
                value={valueTitle}
                onChange={(e) => setValueTitle(e.target.value)}
                placeholder="Ex: Integridade"
              />
            </div>
            <div className="space-y-1.5">
              <label className="text-sm font-medium">Descrição</label>
              <Textarea
                value={valueDescription}
                onChange={(e) => setValueDescription(e.target.value)}
                placeholder="Descreva o que esse valor significa para a empresa..."
                rows={3}
                className="resize-none"
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="ghost" onClick={() => setValueDialog({ open: false, editing: null })}>
              Cancelar
            </Button>
            <Button onClick={submitValueDialog} disabled={!valueTitle.trim() || isSavingValue}>
              {valueDialog.editing ? "Salvar" : "Criar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Remover valor</AlertDialogTitle>
            <AlertDialogDescription>
              Tem certeza que deseja remover este valor? Essa ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => deleteTarget && deleteValueMutation.mutate(deleteTarget)}
              disabled={deleteValueMutation.isPending}
            >
              Remover
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
}
