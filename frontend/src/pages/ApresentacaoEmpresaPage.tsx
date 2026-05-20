import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { companies } from "@/lib/api";
import type { PresentationValue } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Pencil, Check, X, Plus, Trash2, Building2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

function Field({
  label,
  value,
  editing,
  onChange,
  multiline = false,
}: {
  label: string;
  value: string;
  editing: boolean;
  onChange: (v: string) => void;
  multiline?: boolean;
}) {
  if (!editing && !value) return null;
  return (
    <div className="space-y-1">
      <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">{label}</p>
      {editing ? (
        multiline ? (
          <Textarea rows={4} value={value} onChange={(e) => onChange(e.target.value)} />
        ) : (
          <Input value={value} onChange={(e) => onChange(e.target.value)} />
        )
      ) : (
        <p className="text-sm leading-relaxed whitespace-pre-wrap">{value}</p>
      )}
    </div>
  );
}

export default function ApresentacaoEmpresaPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");

  const { data, isLoading } = useQuery({
    queryKey: ["company-presentation"],
    queryFn: companies.getPresentation,
  });

  const [editing, setEditing] = useState(false);
  const [mission, setMission] = useState("");
  const [vision, setVision] = useState("");
  const [history, setHistory] = useState("");
  const [coverUrl, setCoverUrl] = useState("");
  const [values, setValues] = useState<PresentationValue[]>([]);

  const startEdit = () => {
    setMission(data?.presentation_mission ?? "");
    setVision(data?.presentation_vision ?? "");
    setHistory(data?.presentation_history ?? "");
    setCoverUrl(data?.presentation_cover_url ?? "");
    setValues(data?.presentation_values ?? []);
    setEditing(true);
  };

  const cancelEdit = () => setEditing(false);

  const mut = useMutation({
    mutationFn: () =>
      companies.updatePresentation({
        presentation_mission: mission || null,
        presentation_vision: vision || null,
        presentation_history: history || null,
        presentation_cover_url: coverUrl || null,
        presentation_values: values,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["company-presentation"] });
      setEditing(false);
      toast({ title: "Apresentação atualizada" });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  const addValue = () => setValues((v) => [...v, { title: "", description: "" }]);
  const removeValue = (i: number) => setValues((v) => v.filter((_, idx) => idx !== i));
  const updateValue = (i: number, field: keyof PresentationValue, val: string) =>
    setValues((v) => v.map((item, idx) => (idx === i ? { ...item, [field]: val } : item)));

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="p-6 max-w-3xl mx-auto space-y-4">
          <Skeleton className="h-8 w-64" />
          <Skeleton className="h-40 w-full" />
          <Skeleton className="h-40 w-full" />
        </div>
      </AdminLayout>
    );
  }

  const presentation = data!;

  return (
    <AdminLayout>
      <div className="p-6 max-w-3xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
              <Building2 className="h-5 w-5 text-primary" />
            </div>
            <div>
              <h1 className="text-xl font-bold">{presentation.name}</h1>
              {presentation.cnpj && (
                <p className="text-xs text-muted-foreground">CNPJ: {presentation.cnpj}</p>
              )}
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

        {/* Cover */}
        {editing && (
          <div className="space-y-1">
            <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
              URL da imagem de capa
            </p>
            <Input
              placeholder="https://..."
              value={coverUrl}
              onChange={(e) => setCoverUrl(e.target.value)}
            />
          </div>
        )}
        {!editing && presentation.presentation_cover_url && (
          <div className="overflow-hidden rounded-xl border">
            <img
              src={presentation.presentation_cover_url}
              alt="Capa"
              className="w-full h-48 object-cover"
            />
          </div>
        )}

        {/* Missão */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">Missão</CardTitle>
          </CardHeader>
          <CardContent>
            {editing ? (
              <Textarea
                rows={3}
                placeholder="Qual é a missão da empresa?"
                value={mission}
                onChange={(e) => setMission(e.target.value)}
              />
            ) : presentation.presentation_mission ? (
              <p className="text-sm leading-relaxed whitespace-pre-wrap">
                {presentation.presentation_mission}
              </p>
            ) : (
              <p className="text-sm text-muted-foreground italic">Não informado.</p>
            )}
          </CardContent>
        </Card>

        {/* Visão */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">Visão</CardTitle>
          </CardHeader>
          <CardContent>
            {editing ? (
              <Textarea
                rows={3}
                placeholder="Qual é a visão de futuro da empresa?"
                value={vision}
                onChange={(e) => setVision(e.target.value)}
              />
            ) : presentation.presentation_vision ? (
              <p className="text-sm leading-relaxed whitespace-pre-wrap">
                {presentation.presentation_vision}
              </p>
            ) : (
              <p className="text-sm text-muted-foreground italic">Não informado.</p>
            )}
          </CardContent>
        </Card>

        {/* Valores */}
        <Card>
          <CardHeader className="pb-2 flex flex-row items-center justify-between">
            <CardTitle className="text-base">Valores</CardTitle>
            {editing && (
              <Button variant="ghost" size="sm" onClick={addValue}>
                <Plus className="h-4 w-4 mr-1" /> Adicionar
              </Button>
            )}
          </CardHeader>
          <CardContent className="space-y-4">
            {editing ? (
              values.length === 0 ? (
                <p className="text-sm text-muted-foreground italic">
                  Nenhum valor adicionado. Clique em "Adicionar".
                </p>
              ) : (
                values.map((val, i) => (
                  <div key={i} className="flex gap-2 items-start">
                    <div className="flex-1 space-y-2">
                      <Input
                        placeholder="Título (ex: Integridade)"
                        value={val.title}
                        onChange={(e) => updateValue(i, "title", e.target.value)}
                      />
                      <Textarea
                        rows={2}
                        placeholder="Descrição..."
                        value={val.description}
                        onChange={(e) => updateValue(i, "description", e.target.value)}
                      />
                    </div>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="text-destructive hover:bg-destructive/10 mt-1"
                      onClick={() => removeValue(i)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                ))
              )
            ) : presentation.presentation_values?.length ? (
              <div className="grid gap-3 sm:grid-cols-2">
                {presentation.presentation_values.map((val, i) => (
                  <div key={i} className="rounded-lg border bg-muted/30 px-4 py-3">
                    <p className="text-sm font-semibold">{val.title}</p>
                    <p className="text-sm text-muted-foreground mt-0.5">{val.description}</p>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-muted-foreground italic">Não informado.</p>
            )}
          </CardContent>
        </Card>

        {/* História */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">Nossa História</CardTitle>
          </CardHeader>
          <CardContent>
            {editing ? (
              <Textarea
                rows={6}
                placeholder="Conte a história da empresa..."
                value={history}
                onChange={(e) => setHistory(e.target.value)}
              />
            ) : presentation.presentation_history ? (
              <p className="text-sm leading-relaxed whitespace-pre-wrap">
                {presentation.presentation_history}
              </p>
            ) : (
              <p className="text-sm text-muted-foreground italic">Não informado.</p>
            )}
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
}
