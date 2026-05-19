import { useState, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { learning as learningApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/hooks/use-toast";
import type { CourseCatalogItem, EmployeeCourse } from "@/types/learning";
import { GraduationCap, Plus, Pencil, Trash2, Upload, BookOpen, Users, Clock } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Helpers ───────────────────────────────────────────────────────────────────

function groupByUser(courses: EmployeeCourse[]) {
  const map: Record<string, { name: string; email: string; department?: string; courses: EmployeeCourse[] }> = {};
  for (const c of courses) {
    if (!map[c.user_id]) {
      map[c.user_id] = { name: c.user_name ?? c.user_email ?? c.user_id, email: c.user_email ?? "", department: c.department, courses: [] };
    }
    map[c.user_id].courses.push(c);
  }
  return Object.entries(map).sort((a, b) => a[1].name.localeCompare(b[1].name));
}

function totalHours(courses: EmployeeCourse[]) {
  return courses.reduce((s, c) => s + c.hours, 0);
}

function areaBreakdown(courses: EmployeeCourse[]) {
  const map: Record<string, number> = {};
  for (const c of courses) {
    map[c.area] = (map[c.area] ?? 0) + c.hours;
  }
  return Object.entries(map).sort((a, b) => b[1] - a[1]);
}

const AREA_COLORS = [
  "bg-blue-500/10 text-blue-600",
  "bg-emerald-500/10 text-emerald-600",
  "bg-amber-500/10 text-amber-600",
  "bg-purple-500/10 text-purple-600",
  "bg-rose-500/10 text-rose-600",
  "bg-cyan-500/10 text-cyan-600",
];

// ── Team Tab ──────────────────────────────────────────────────────────────────

function TeamTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [filter, setFilter] = useState("");
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});

  const { data: courses = [], isLoading } = useQuery({
    queryKey: ["learning-team"],
    queryFn: learningApi.team,
  });

  const deleteMutation = useMutation({
    mutationFn: learningApi.deleteEmployeeCourse,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["learning-team"] });
      toast({ title: "Registro removido" });
    },
    onError: () => toast({ title: "Erro ao remover", variant: "destructive" }),
  });

  const grouped = groupByUser(courses);
  const filtered = filter
    ? grouped.filter(([, u]) => u.name.toLowerCase().includes(filter.toLowerCase()) || u.department?.toLowerCase().includes(filter.toLowerCase()))
    : grouped;

  const totalAll = totalHours(courses);
  const areas = areaBreakdown(courses);

  return (
    <div className="space-y-4">
      {/* Summary bar */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        <Card>
          <CardContent className="pt-4 pb-3">
            <p className="text-xs text-muted-foreground">Colaboradores</p>
            <p className="text-2xl font-bold">{grouped.length}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-4 pb-3">
            <p className="text-xs text-muted-foreground">Total de horas</p>
            <p className="text-2xl font-bold">{totalAll.toFixed(0)}h</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-4 pb-3">
            <p className="text-xs text-muted-foreground">Cursos concluídos</p>
            <p className="text-2xl font-bold">{courses.length}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-4 pb-3">
            <p className="text-xs text-muted-foreground">Média por pessoa</p>
            <p className="text-2xl font-bold">
              {grouped.length > 0 ? (totalAll / grouped.length).toFixed(0) : 0}h
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Areas breakdown */}
      {areas.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {areas.map(([area, h], i) => (
            <span key={area} className={cn("rounded-full px-3 py-1 text-xs font-medium", AREA_COLORS[i % AREA_COLORS.length])}>
              {area}: {h.toFixed(0)}h
            </span>
          ))}
        </div>
      )}

      <Input
        placeholder="Filtrar por nome ou departamento..."
        value={filter}
        onChange={e => setFilter(e.target.value)}
        className="max-w-sm"
      />

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : filtered.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <Users className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground">Nenhum curso registrado ainda.</p>
        </div>
      ) : (
        <div className="space-y-2">
          {filtered.map(([uid, user]) => {
            const open = expanded[uid];
            const total = totalHours(user.courses);
            return (
              <div key={uid} className="rounded-xl border bg-card overflow-hidden">
                <button
                  className="w-full flex items-center gap-3 px-4 py-3 text-left hover:bg-muted/30 transition-colors"
                  onClick={() => setExpanded(prev => ({ ...prev, [uid]: !open }))}
                >
                  <div className="flex-1 min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-medium text-sm">{user.name}</span>
                      {user.department && <span className="text-xs text-muted-foreground">· {user.department}</span>}
                    </div>
                    <div className="flex items-center gap-3 mt-1">
                      <span className="text-xs text-muted-foreground">{user.courses.length} curso{user.courses.length !== 1 ? "s" : ""}</span>
                      <span className="flex items-center gap-1 text-xs font-medium text-primary">
                        <Clock className="h-3 w-3" />{total.toFixed(0)}h
                      </span>
                    </div>
                  </div>
                </button>
                {open && (
                  <div className="border-t bg-muted/20 divide-y">
                    {user.courses.map(c => (
                      <div key={c.id} className="flex items-center gap-3 px-4 py-2.5">
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium truncate">{c.course_title}</p>
                          <div className="flex items-center gap-2 mt-0.5">
                            <Badge variant="secondary" className="text-[10px] h-4 px-1.5">{c.area}</Badge>
                            <span className="text-xs text-muted-foreground">{c.hours}h</span>
                            <span className="text-xs text-muted-foreground">
                              {new Date(c.completed_at + "T12:00:00").toLocaleDateString("pt-BR")}
                            </span>
                            {c.source === "csv" && (
                              <Badge variant="outline" className="text-[10px] h-4 px-1.5">CSV</Badge>
                            )}
                          </div>
                        </div>
                        <Button
                          size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive shrink-0"
                          onClick={() => deleteMutation.mutate(c.id)}
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// ── Catalog Tab ───────────────────────────────────────────────────────────────

function CatalogDialog({ item, onOpenChange, onSaved }: {
  item: CourseCatalogItem | null;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState(item?.title ?? "");
  const [area, setArea] = useState(item?.area ?? "");
  const [description, setDescription] = useState(item?.description ?? "");
  const [hours, setHours] = useState(String(item?.duration_hours ?? ""));

  const mutation = useMutation({
    mutationFn: () => {
      const data = { title, area, description: description || undefined, duration_hours: parseFloat(hours) || 0 };
      return item ? learningApi.updateCatalogItem(item.id, data) : learningApi.createCatalogItem(data);
    },
    onSuccess: () => {
      toast({ title: item ? "Curso atualizado" : "Curso adicionado ao catálogo" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>{item ? "Editar Curso" : "Novo Curso no Catálogo"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Liderança Situacional" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Área</Label>
              <Input value={area} onChange={e => setArea(e.target.value)} placeholder="Ex: Liderança" />
            </div>
            <div className="space-y-1.5">
              <Label>Carga horária (h)</Label>
              <Input type="number" min="0" step="0.5" value={hours} onChange={e => setHours(e.target.value)} placeholder="Ex: 8" />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!title || !area || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function CatalogTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dialogItem, setDialogItem] = useState<CourseCatalogItem | null | undefined>(undefined);

  const { data: catalog = [], isLoading } = useQuery({
    queryKey: ["learning-catalog"],
    queryFn: learningApi.catalog,
  });

  const deleteMutation = useMutation({
    mutationFn: learningApi.deleteCatalogItem,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["learning-catalog"] });
      toast({ title: "Curso removido do catálogo" });
    },
  });

  const grouped = catalog.reduce<Record<string, CourseCatalogItem[]>>((acc, item) => {
    (acc[item.area] = acc[item.area] ?? []).push(item);
    return acc;
  }, {});

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button size="sm" onClick={() => setDialogItem(null)}>
          <Plus className="h-4 w-4 mr-1" /> Adicionar curso
        </Button>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : catalog.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <BookOpen className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground mb-3">Catálogo vazio.</p>
          <Button size="sm" onClick={() => setDialogItem(null)}>
            <Plus className="h-4 w-4 mr-1" /> Adicionar primeiro curso
          </Button>
        </div>
      ) : (
        <div className="space-y-4">
          {Object.entries(grouped).sort().map(([area, items], i) => (
            <div key={area}>
              <h3 className={cn("text-xs font-semibold uppercase tracking-wider mb-2 px-1", AREA_COLORS[i % AREA_COLORS.length].split(" ")[1])}>
                {area}
              </h3>
              <div className="space-y-2">
                {items.map(item => (
                  <div key={item.id} className="flex items-center gap-3 rounded-xl border bg-card px-4 py-3">
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium">{item.title}</p>
                      {item.description && (
                        <p className="text-xs text-muted-foreground mt-0.5 truncate">{item.description}</p>
                      )}
                    </div>
                    <span className="text-xs text-muted-foreground shrink-0">{item.duration_hours}h</span>
                    <div className="flex gap-1 shrink-0">
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setDialogItem(item)}>
                        <Pencil className="h-3.5 w-3.5" />
                      </Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive"
                        onClick={() => deleteMutation.mutate(item.id)}>
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {dialogItem !== undefined && (
        <CatalogDialog
          item={dialogItem}
          onOpenChange={open => !open && setDialogItem(undefined)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["learning-catalog"] })}
        />
      )}
    </div>
  );
}

// ── CSV Import ────────────────────────────────────────────────────────────────

function CsvImportSection() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const fileRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{ inserted: number; errors: string[] } | null>(null);

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setLoading(true);
    setResult(null);
    try {
      const res = await learningApi.importCsv(file);
      setResult(res);
      if (res.inserted > 0) {
        queryClient.invalidateQueries({ queryKey: ["learning-team"] });
        toast({ title: `${res.inserted} registro(s) importado(s)` });
      }
    } catch {
      toast({ title: "Erro ao importar CSV", variant: "destructive" });
    } finally {
      setLoading(false);
      if (fileRef.current) fileRef.current.value = "";
    }
  }

  return (
    <div className="rounded-xl border bg-card p-4 space-y-3">
      <div className="flex items-center justify-between">
        <div>
          <p className="font-medium text-sm">Importar cursos via CSV</p>
          <p className="text-xs text-muted-foreground mt-0.5">
            Colunas: <code className="bg-muted px-1 rounded text-[11px]">email, titulo, area, horas, data</code>
          </p>
        </div>
        <Button size="sm" variant="outline" onClick={() => fileRef.current?.click()} disabled={loading}>
          <Upload className="h-4 w-4 mr-1" />
          {loading ? "Importando..." : "Selecionar CSV"}
        </Button>
        <input ref={fileRef} type="file" accept=".csv" className="hidden" onChange={handleFile} />
      </div>

      {result && (
        <div className="space-y-1">
          <p className="text-sm text-emerald-600 font-medium">{result.inserted} registro(s) importado(s)</p>
          {result.errors.length > 0 && (
            <div className="rounded-md bg-destructive/10 p-2 space-y-0.5">
              {result.errors.map((e, i) => (
                <p key={i} className="text-xs text-destructive">{e}</p>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function LearningAdminPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <GraduationCap className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Universidade Corporativa</h1>
        </div>

        <CsvImportSection />

        <Tabs defaultValue="team">
          <TabsList>
            <TabsTrigger value="team">
              <Users className="h-4 w-4 mr-2" /> Progresso da Equipe
            </TabsTrigger>
            <TabsTrigger value="catalog">
              <BookOpen className="h-4 w-4 mr-2" /> Catálogo
            </TabsTrigger>
          </TabsList>

          <TabsContent value="team" className="mt-4">
            <TeamTab />
          </TabsContent>

          <TabsContent value="catalog" className="mt-4">
            <CatalogTab />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
