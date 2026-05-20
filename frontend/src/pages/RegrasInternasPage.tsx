import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { companies } from "@/lib/api";
import type { InternalRule } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Pencil, Check, X, Plus, Trash2, ScrollText } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

export default function RegrasInternasPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");

  const { data, isLoading } = useQuery({
    queryKey: ["internal-rules"],
    queryFn: companies.getInternalRules,
  });

  const [editing, setEditing] = useState(false);
  const [rules, setRules] = useState<InternalRule[]>([]);

  const startEdit = () => {
    setRules(data?.rules ?? []);
    setEditing(true);
  };

  const cancelEdit = () => setEditing(false);

  const mut = useMutation({
    mutationFn: () => companies.updateInternalRules(rules),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["internal-rules"] });
      setEditing(false);
      toast({ title: "Regras atualizadas" });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  const addRule = () => setRules((r) => [...r, { title: "", content: "" }]);
  const removeRule = (i: number) => setRules((r) => r.filter((_, idx) => idx !== i));
  const updateRule = (i: number, field: keyof InternalRule, val: string) =>
    setRules((r) => r.map((item, idx) => (idx === i ? { ...item, [field]: val } : item)));

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="p-6 max-w-3xl mx-auto space-y-4">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-32 w-full" />
        </div>
      </AdminLayout>
    );
  }

  const currentRules = data?.rules ?? [];

  return (
    <AdminLayout>
      <div className="p-6 max-w-3xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
              <ScrollText className="h-5 w-5 text-primary" />
            </div>
            <div>
              <h1 className="text-xl font-bold">Regras Internas</h1>
              <p className="text-sm text-muted-foreground">
                Normas e diretrizes da empresa
              </p>
            </div>
          </div>

          {isAdmin && !editing && (
            <Button variant="outline" size="sm" onClick={startEdit}>
              <Pencil className="h-4 w-4 mr-2" /> Editar
            </Button>
          )}
          {editing && (
            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={cancelEdit}>
                <X className="h-4 w-4 mr-1" /> Cancelar
              </Button>
              <Button size="sm" onClick={() => mut.mutate()} disabled={mut.isPending}>
                <Check className="h-4 w-4 mr-1" /> Salvar
              </Button>
            </div>
          )}
        </div>

        {/* Conteúdo */}
        {editing ? (
          <div className="space-y-4">
            {rules.length === 0 && (
              <p className="text-sm text-muted-foreground italic text-center py-8">
                Nenhuma regra adicionada. Clique em "Adicionar seção".
              </p>
            )}
            {rules.map((rule, i) => (
              <Card key={i}>
                <CardContent className="p-4 space-y-3">
                  <div className="flex gap-2 items-center">
                    <Input
                      placeholder="Título da seção (ex: Horário de Trabalho)"
                      value={rule.title}
                      onChange={(e) => updateRule(i, "title", e.target.value)}
                      className="flex-1"
                    />
                    <Button
                      variant="ghost"
                      size="icon"
                      className="text-destructive hover:bg-destructive/10 shrink-0"
                      onClick={() => removeRule(i)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                  <Textarea
                    rows={5}
                    placeholder="Descreva as regras desta seção..."
                    value={rule.content}
                    onChange={(e) => updateRule(i, "content", e.target.value)}
                  />
                </CardContent>
              </Card>
            ))}
            <Button variant="outline" className="w-full" onClick={addRule}>
              <Plus className="h-4 w-4 mr-2" /> Adicionar seção
            </Button>
          </div>
        ) : currentRules.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <ScrollText className="h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-sm text-muted-foreground">
              Nenhuma regra cadastrada ainda.
            </p>
            {isAdmin && (
              <Button variant="outline" size="sm" className="mt-4" onClick={startEdit}>
                <Plus className="h-4 w-4 mr-2" /> Adicionar regras
              </Button>
            )}
          </div>
        ) : (
          <div className="space-y-4">
            {currentRules.map((rule, i) => (
              <Card key={i}>
                <CardHeader className="pb-2">
                  <CardTitle className="text-base flex items-center gap-2">
                    <span className="flex h-6 w-6 items-center justify-center rounded-full bg-primary/10 text-xs font-bold text-primary">
                      {i + 1}
                    </span>
                    {rule.title}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap text-muted-foreground">
                    {rule.content}
                  </p>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
