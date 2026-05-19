import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { benefits as benefitsApi } from "@/lib/api";
import { collaborators as collaboratorsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { useToast } from "@/hooks/use-toast";
import type { BenefitCatalogItem, BenefitCategory, BenefitValueType, EmployeeBenefit } from "@/types/benefits";
import { Gift, Users, BookOpen, LayoutDashboard, Trash2, Pencil } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Category helpers ──────────────────────────────────────────────────────────

const CATEGORY_LABELS: Record<BenefitCategory, string> = {
  saude: "Saúde",
  alimentacao: "Alimentação",
  transporte: "Transporte",
  financeiro: "Financeiro",
  educacao: "Educação",
  bem_estar: "Bem-estar",
  outro: "Outro",
};

const CATEGORY_COLORS: Record<BenefitCategory, string> = {
  saude: "bg-blue-100 text-blue-700",
  alimentacao: "bg-orange-100 text-orange-700",
  transporte: "bg-green-100 text-green-700",
  financeiro: "bg-purple-100 text-purple-700",
  educacao: "bg-indigo-100 text-indigo-700",
  bem_estar: "bg-pink-100 text-pink-700",
  outro: "bg-gray-100 text-gray-700",
};

function CategoryBadge({ category }: { category: BenefitCategory }) {
  return (
    <Badge className={cn("text-xs border-0", CATEGORY_COLORS[category])}>
      {CATEGORY_LABELS[category]}
    </Badge>
  );
}

function formatValue(valueType: BenefitValueType, value?: number): string {
  if (!value) return valueType === "info" ? "Incluso" : "—";
  if (valueType === "percentage") return `${value}%`;
  if (valueType === "fixed" || valueType === "variable")
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
  return "Incluso";
}

// ── Overview Tab ──────────────────────────────────────────────────────────────

function OverviewTab() {
  const { data: summary = [], isLoading } = useQuery({
    queryKey: ["benefits-summary"],
    queryFn: benefitsApi.summary,
  });

  const { data: team = [] } = useQuery({
    queryKey: ["benefits-team"],
    queryFn: benefitsApi.team,
  });

  const totalActive = summary.reduce((acc, s) => acc + Number(s.employee_count), 0);
  const employeesWithBenefits = new Set(team.map((t) => t.user_id)).size;

  if (isLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-3 gap-4">
        <Card>
          <CardContent className="p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide">Benefícios no catálogo</p>
            <p className="text-3xl font-bold mt-1">{summary.length}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide">Atribuições ativas</p>
            <p className="text-3xl font-bold mt-1">{totalActive}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide">Colaboradores contemplados</p>
            <p className="text-3xl font-bold mt-1">{employeesWithBenefits}</p>
          </CardContent>
        </Card>
      </div>

      <div className="space-y-2">
        <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
          Benefícios por adesão
        </h2>
        {summary.map((s) => (
          <div key={s.benefit_id} className="flex items-center gap-3 rounded-lg border p-3">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <span className="text-sm font-medium">{s.benefit_name}</span>
                <CategoryBadge category={s.benefit_category} />
              </div>
            </div>
            <span className="text-sm font-semibold shrink-0">
              {s.employee_count} colaborador{s.employee_count !== 1 ? "es" : ""}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── Assign Dialog ─────────────────────────────────────────────────────────────

function AssignDialog({
  targetUserId,
  targetUserName,
  catalog,
  onClose,
}: {
  targetUserId: string;
  targetUserName: string;
  catalog: BenefitCatalogItem[];
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [benefitId, setBenefitId] = useState("");
  const [valueOverride, setValueOverride] = useState("");
  const [startDate, setStartDate] = useState(new Date().toISOString().split("T")[0]);
  const [notes, setNotes] = useState("");

  const selectedBenefit = catalog.find((c) => c.id === benefitId);
  const showValue = selectedBenefit && selectedBenefit.value_type !== "info";

  const mutation = useMutation({
    mutationFn: () =>
      benefitsApi.assign({
        user_id: targetUserId,
        benefit_id: benefitId,
        start_date: startDate,
        value_override: valueOverride ? parseFloat(valueOverride) : undefined,
        notes: notes || undefined,
      }),
    onSuccess: () => {
      toast({ title: "Benefício atribuído!" });
      queryClient.invalidateQueries({ queryKey: ["benefits-team"] });
      queryClient.invalidateQueries({ queryKey: ["benefits-summary"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao atribuir", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Atribuir benefício — {targetUserName}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>Benefício</Label>
            <Select value={benefitId} onValueChange={setBenefitId}>
              <SelectTrigger>
                <SelectValue placeholder="Selecione..." />
              </SelectTrigger>
              <SelectContent>
                {catalog.filter((c) => c.active).map((c) => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {showValue && (
            <div className="space-y-1">
              <Label>
                Valor{" "}
                <span className="text-muted-foreground text-xs">
                  (opcional — sobrescreve o valor do catálogo)
                </span>
              </Label>
              <Input
                type="number"
                min="0"
                step="0.01"
                value={valueOverride}
                onChange={(e) => setValueOverride(e.target.value)}
                placeholder={selectedBenefit?.value?.toString() ?? ""}
              />
            </div>
          )}

          <div className="space-y-1">
            <Label>Data de início</Label>
            <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
          </div>

          <div className="space-y-1">
            <Label>Observações (opcional)</Label>
            <Textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Notas sobre a atribuição..."
              rows={2}
              className="resize-none"
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!benefitId || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Atribuir"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Collaborators Tab ─────────────────────────────────────────────────────────

function CollaboratorsTab({ catalog }: { catalog: BenefitCatalogItem[] }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [search, setSearch] = useState("");
  const [assigning, setAssigning] = useState<{ userId: string; name: string } | null>(null);

  const { data: team = [], isLoading } = useQuery({
    queryKey: ["benefits-team"],
    queryFn: benefitsApi.team,
  });

  const deleteMutation = useMutation({
    mutationFn: benefitsApi.deleteAssignment,
    onSuccess: () => {
      toast({ title: "Benefício removido." });
      queryClient.invalidateQueries({ queryKey: ["benefits-team"] });
      queryClient.invalidateQueries({ queryKey: ["benefits-summary"] });
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  // group assignments by user
  const byUser = team.reduce<Record<string, { name: string; department?: string; benefits: EmployeeBenefit[] }>>((acc, b) => {
    if (!acc[b.user_id]) acc[b.user_id] = { name: b.user_name ?? b.user_id, department: b.department ?? undefined, benefits: [] };
    acc[b.user_id].benefits.push(b);
    return acc;
  }, {});

  const filtered = Object.entries(byUser).filter(([, u]) =>
    u.name.toLowerCase().includes(search.toLowerCase()) ||
    (u.department ?? "").toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-4">
      {assigning && (
        <AssignDialog
          targetUserId={assigning.userId}
          targetUserName={assigning.name}
          catalog={catalog}
          onClose={() => setAssigning(null)}
        />
      )}

      <Input
        placeholder="Buscar colaborador ou departamento..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="max-w-sm"
      />

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : filtered.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <Users className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground text-sm">Nenhum colaborador com benefícios ainda.</p>
          <p className="text-xs text-muted-foreground mt-1">Use o botão "Atribuir" em cada colaborador para adicionar benefícios.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map(([userId, user]) => (
            <Card key={userId}>
              <CardContent className="p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-semibold text-sm">{user.name}</p>
                    {user.department && (
                      <p className="text-xs text-muted-foreground">{user.department}</p>
                    )}
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => setAssigning({ userId, name: user.name })}
                  >
                    + Atribuir
                  </Button>
                </div>
                <div className="flex flex-wrap gap-2">
                  {user.benefits.map((b) => (
                    <div
                      key={b.id}
                      className="flex items-center gap-1.5 rounded-full border bg-muted/40 px-3 py-1 text-xs"
                    >
                      <span>{b.benefit_name}</span>
                      {b.value !== undefined && (
                        <span className="text-muted-foreground">
                          · {formatValue(b.value_type ?? "info", b.value)}
                        </span>
                      )}
                      <button
                        onClick={() => {
                          if (confirm(`Remover "${b.benefit_name}" de ${user.name}?`))
                            deleteMutation.mutate(b.id);
                        }}
                        className="ml-1 text-muted-foreground hover:text-destructive transition-colors"
                      >
                        ×
                      </button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}

// ── Catalog Dialog ────────────────────────────────────────────────────────────

function CatalogDialog({
  item,
  onClose,
}: {
  item?: BenefitCatalogItem;
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [name, setName] = useState(item?.name ?? "");
  const [category, setCategory] = useState<BenefitCategory>(item?.category ?? "outro");
  const [description, setDescription] = useState(item?.description ?? "");
  const [provider, setProvider] = useState(item?.provider ?? "");
  const [valueType, setValueType] = useState<BenefitValueType>(item?.value_type ?? "info");
  const [value, setValue] = useState(item?.value?.toString() ?? "");
  const [active, setActive] = useState(item?.active ?? true);

  const mutation = useMutation({
    mutationFn: () => {
      const data = {
        name,
        category,
        description: description || undefined,
        provider: provider || undefined,
        value_type: valueType,
        value: value ? parseFloat(value) : undefined,
        active,
      };
      return item
        ? benefitsApi.updateCatalogItem(item.id, data)
        : benefitsApi.createCatalogItem(data);
    },
    onSuccess: () => {
      toast({ title: item ? "Benefício atualizado!" : "Benefício criado!" });
      queryClient.invalidateQueries({ queryKey: ["benefits-catalog"] });
      queryClient.invalidateQueries({ queryKey: ["benefits-summary"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const showValue = valueType !== "info";

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{item ? "Editar benefício" : "Novo benefício"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>Nome</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Ex: Plano de Saúde" />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Categoria</Label>
              <Select value={category} onValueChange={(v) => setCategory(v as BenefitCategory)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {(Object.entries(CATEGORY_LABELS) as [BenefitCategory, string][]).map(([val, label]) => (
                    <SelectItem key={val} value={val}>{label}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-1">
              <Label>Tipo de valor</Label>
              <Select value={valueType} onValueChange={(v) => setValueType(v as BenefitValueType)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="fixed">Fixo (R$)</SelectItem>
                  <SelectItem value="variable">Variável (R$)</SelectItem>
                  <SelectItem value="percentage">Percentual (%)</SelectItem>
                  <SelectItem value="info">Informativo</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {showValue && (
            <div className="space-y-1">
              <Label>Valor padrão {valueType === "percentage" ? "(%)" : "(R$)"}</Label>
              <Input
                type="number"
                min="0"
                step="0.01"
                value={value}
                onChange={(e) => setValue(e.target.value)}
                placeholder="0,00"
              />
            </div>
          )}

          <div className="space-y-1">
            <Label>Fornecedor / operadora (opcional)</Label>
            <Input value={provider} onChange={(e) => setProvider(e.target.value)} placeholder="Ex: Unimed, Ticket, Flash" />
          </div>

          <div className="space-y-1">
            <Label>Descrição (opcional)</Label>
            <Textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Detalhes do benefício..."
              rows={2}
              className="resize-none"
            />
          </div>

          <div className="flex items-center gap-3">
            <Switch checked={active} onCheckedChange={setActive} id="active" />
            <Label htmlFor="active">Benefício ativo</Label>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!name.trim() || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Catalog Tab ───────────────────────────────────────────────────────────────

function CatalogTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dialog, setDialog] = useState<{ open: boolean; item?: BenefitCatalogItem }>({ open: false });

  const { data: catalog = [], isLoading } = useQuery({
    queryKey: ["benefits-catalog"],
    queryFn: benefitsApi.catalog,
  });

  const deleteMutation = useMutation({
    mutationFn: benefitsApi.deleteCatalogItem,
    onSuccess: () => {
      toast({ title: "Benefício removido do catálogo." });
      queryClient.invalidateQueries({ queryKey: ["benefits-catalog"] });
      queryClient.invalidateQueries({ queryKey: ["benefits-summary"] });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao remover", description: e.message, variant: "destructive" }),
  });

  return (
    <div className="space-y-4">
      {dialog.open && (
        <CatalogDialog item={dialog.item} onClose={() => setDialog({ open: false })} />
      )}

      <div className="flex justify-end">
        <Button onClick={() => setDialog({ open: true })}>+ Novo benefício</Button>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : (
        <div className="space-y-2">
          {catalog.map((b) => (
            <div key={b.id} className={cn("flex items-center gap-3 rounded-lg border p-3", !b.active && "opacity-50")}>
              <div className="flex-1 min-w-0 space-y-0.5">
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="text-sm font-medium">{b.name}</span>
                  <CategoryBadge category={b.category} />
                  {!b.active && <Badge variant="outline" className="text-xs">Inativo</Badge>}
                </div>
                <p className="text-xs text-muted-foreground">
                  {b.provider && <>{b.provider} · </>}
                  {formatValue(b.value_type, b.value ?? undefined)}
                </p>
              </div>
              <div className="flex gap-1 shrink-0">
                <Button variant="ghost" size="icon" className="h-8 w-8" onClick={() => setDialog({ open: true, item: b })}>
                  <Pencil className="h-4 w-4" />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  className="h-8 w-8 text-destructive hover:text-destructive"
                  onClick={() => {
                    if (confirm(`Remover "${b.name}" do catálogo?`)) deleteMutation.mutate(b.id);
                  }}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function BenefitsAdminPage() {
  const { data: catalog = [] } = useQuery({
    queryKey: ["benefits-catalog"],
    queryFn: benefitsApi.catalog,
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <Gift className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Benefícios</h1>
        </div>

        <Tabs defaultValue="overview">
          <TabsList>
            <TabsTrigger value="overview">
              <LayoutDashboard className="h-4 w-4 mr-2" />
              Visão Geral
            </TabsTrigger>
            <TabsTrigger value="collaborators">
              <Users className="h-4 w-4 mr-2" />
              Colaboradores
            </TabsTrigger>
            <TabsTrigger value="catalog">
              <BookOpen className="h-4 w-4 mr-2" />
              Catálogo
            </TabsTrigger>
          </TabsList>

          <TabsContent value="overview" className="mt-6">
            <OverviewTab />
          </TabsContent>

          <TabsContent value="collaborators" className="mt-6">
            <CollaboratorsTab catalog={catalog} />
          </TabsContent>

          <TabsContent value="catalog" className="mt-6">
            <CatalogTab />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
