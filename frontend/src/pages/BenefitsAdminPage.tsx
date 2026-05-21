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

// ── Currency input ────────────────────────────────────────────────────────────

function parseCurrency(display: string): string {
  return display.replace(/\D/g, "");
}

function formatCurrency(cents: string): string {
  const n = parseInt(cents || "0", 10);
  return (n / 100).toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function CurrencyInput({
  value,
  onChange,
  placeholder = "0,00",
}: {
  value: string;
  onChange: (raw: string) => void;
  placeholder?: string;
}) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const cents = parseCurrency(e.target.value);
    onChange(cents ? String(parseInt(cents, 10) / 100) : "");
  };

  const displayValue = value ? formatCurrency(String(Math.round(parseFloat(value) * 100))) : "";

  return (
    <div className="relative">
      <span className="absolute left-3 top-1/2 -translate-y-1/2 text-sm text-muted-foreground select-none">R$</span>
      <Input
        className="pl-9"
        value={displayValue}
        onChange={handleChange}
        placeholder={placeholder}
        inputMode="numeric"
      />
    </div>
  );
}

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
  saude: "bg-blue-500/15 text-blue-400 border-blue-500/20",
  alimentacao: "bg-orange-500/15 text-orange-400 border-orange-500/20",
  transporte: "bg-green-500/15 text-green-400 border-green-500/20",
  financeiro: "bg-purple-500/15 text-purple-400 border-purple-500/20",
  educacao: "bg-indigo-500/15 text-indigo-400 border-indigo-500/20",
  bem_estar: "bg-pink-500/15 text-pink-400 border-pink-500/20",
  outro: "bg-muted text-muted-foreground border-border",
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
    <div className="space-y-8">
      <div className="grid grid-cols-3 gap-4">
        <Card className="hover:shadow-md hover:border-primary/20 transition-all">
          <CardContent className="p-5">
            <div className="flex items-center justify-between mb-3">
              <p className="text-sm text-muted-foreground font-medium">No catálogo</p>
              <div className="rounded-lg p-2 bg-primary/10">
                <BookOpen className="h-4 w-4 text-primary" />
              </div>
            </div>
            <p className="text-3xl font-bold tracking-tight">{summary.length}</p>
          </CardContent>
        </Card>
        <Card className="hover:shadow-md hover:border-blue-500/20 transition-all">
          <CardContent className="p-5">
            <div className="flex items-center justify-between mb-3">
              <p className="text-sm text-muted-foreground font-medium">Atribuições ativas</p>
              <div className="rounded-lg p-2 bg-blue-500/10">
                <Gift className="h-4 w-4 text-blue-400" />
              </div>
            </div>
            <p className="text-3xl font-bold tracking-tight">{totalActive}</p>
          </CardContent>
        </Card>
        <Card className="hover:shadow-md hover:border-violet-500/20 transition-all">
          <CardContent className="p-5">
            <div className="flex items-center justify-between mb-3">
              <p className="text-sm text-muted-foreground font-medium">Colaboradores contemplados</p>
              <div className="rounded-lg p-2 bg-violet-500/10">
                <Users className="h-4 w-4 text-violet-400" />
              </div>
            </div>
            <p className="text-3xl font-bold tracking-tight">{employeesWithBenefits}</p>
          </CardContent>
        </Card>
      </div>

      <div className="space-y-3">
        <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">
          Adesão por benefício
        </h2>
        {summary.map((s) => (
          <div key={s.benefit_id} className="flex items-center gap-3 rounded-lg border bg-card px-4 py-3 hover:bg-muted/30 transition-colors">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                <span className="text-sm font-medium">{s.benefit_name}</span>
                <CategoryBadge category={s.benefit_category} />
              </div>
            </div>
            <span className="text-sm font-semibold shrink-0 tabular-nums">
              {s.employee_count} colaborador{s.employee_count !== 1 ? "es" : ""}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── Vale-Transporte calculator ────────────────────────────────────────────────

function countWorkingDays(year: number, month: number): number {
  const days = new Date(year, month + 1, 0).getDate();
  let count = 0;
  for (let d = 1; d <= days; d++) {
    const dow = new Date(year, month, d).getDay();
    if (dow !== 0 && dow !== 6) count++;
  }
  return count;
}

const MONTH_NAMES = [
  "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
  "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
];

function VTCalculator({
  initialPrice,
  initialPerDay,
  onVTChange,
}: {
  initialPrice?: number;
  initialPerDay?: number;
  onVTChange: (vt: { ticket_price: number; tickets_per_day: number } | null) => void;
}) {
  const next = new Date();
  next.setMonth(next.getMonth() + 1);
  const workingDays = countWorkingDays(next.getFullYear(), next.getMonth());

  const [ticketPrice, setTicketPrice] = useState(initialPrice != null ? String(initialPrice) : "");
  const [ticketsPerDay, setTicketsPerDay] = useState(initialPerDay != null ? String(initialPerDay) : "2");

  const price = parseFloat(ticketPrice) || 0;
  const perDay = parseInt(ticketsPerDay) || 0;
  const total = price * perDay * workingDays;

  const notify = (p: number, n: number) => {
    onVTChange(p > 0 && n > 0 ? { ticket_price: p, tickets_per_day: n } : null);
  };

  const handleTicketChange = (val: string) => {
    setTicketPrice(val);
    notify(parseFloat(val) || 0, perDay);
  };

  const handlePerDayChange = (val: string) => {
    const n = val.replace(/\D/g, "");
    setTicketsPerDay(n);
    notify(price, parseInt(n) || 0);
  };

  return (
    <div className="space-y-3 rounded-lg border bg-muted/30 p-4">
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1">
          <Label className="text-xs">Preço da passagem</Label>
          <CurrencyInput value={ticketPrice} onChange={handleTicketChange} />
        </div>
        <div className="space-y-1">
          <Label className="text-xs">Passagens por dia</Label>
          <Input
            value={ticketsPerDay}
            onChange={(e) => handlePerDayChange(e.target.value)}
            inputMode="numeric"
            className="text-center"
          />
        </div>
      </div>

      <div className="flex items-center justify-between text-sm pt-1 border-t">
        <span className="text-muted-foreground">{workingDays} dias úteis em {MONTH_NAMES[next.getMonth()]} × {ticketsPerDay} passagens</span>
        <span className="font-semibold">
          {total > 0
            ? total.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
            : "—"}
        </span>
      </div>
      <p className="text-xs text-muted-foreground">Sempre exibe o valor do próximo mês — recalculado automaticamente.</p>
    </div>
  );
}

// ── Assign Dialog ─────────────────────────────────────────────────────────────

function AssignDialog({
  targetUserId,
  targetUserName,
  catalog,
  existingBenefitIds,
  onClose,
}: {
  targetUserId: string;
  targetUserName: string;
  catalog: BenefitCatalogItem[];
  existingBenefitIds: string[];
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [benefitId, setBenefitId] = useState("");
  const [valueOverride, setValueOverride] = useState("");
  const [vtData, setVtData] = useState<{ ticket_price: number; tickets_per_day: number } | null>(null);

  const availableCatalog = catalog.filter((c) => c.active && !existingBenefitIds.includes(c.id));
  const selectedBenefit = catalog.find((c) => c.id === benefitId);
  const isVT = selectedBenefit?.name.toLowerCase().includes("transporte");
  const showValue = selectedBenefit && selectedBenefit.value_type !== "info" && !isVT;

  const canSubmit = benefitId && (isVT ? vtData !== null : true);

  const mutation = useMutation({
    mutationFn: () =>
      benefitsApi.assign({
        user_id: targetUserId,
        benefit_id: benefitId,
        ...(isVT && vtData
          ? { ticket_price: vtData.ticket_price, tickets_per_day: vtData.tickets_per_day }
          : { value_override: valueOverride ? parseFloat(valueOverride) : undefined }),
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
            <Select value={benefitId} onValueChange={(v) => { setBenefitId(v); setValueOverride(""); setVtData(null); }}>
              <SelectTrigger>
                <SelectValue placeholder={availableCatalog.length === 0 ? "Todos os benefícios já atribuídos" : "Selecione..."} />
              </SelectTrigger>
              <SelectContent>
                {availableCatalog.map((c) => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {availableCatalog.length === 0 && (
              <p className="text-xs text-muted-foreground">Este colaborador já possui todos os benefícios do catálogo.</p>
            )}
          </div>

          {isVT && (
            <VTCalculator onVTChange={setVtData} />
          )}

          {showValue && (
            <div className="space-y-1">
              <Label>
                Valor{" "}
                <span className="text-muted-foreground text-xs">
                  (opcional — sobrescreve o valor do catálogo)
                </span>
              </Label>
              <CurrencyInput value={valueOverride} onChange={setValueOverride} />
            </div>
          )}
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!canSubmit || mutation.isPending || availableCatalog.length === 0}>
            {mutation.isPending ? "Salvando..." : "Atribuir"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Edit Assignment Dialog ─────────────────────────────────────────────────────

function EditAssignmentDialog({
  benefit,
  onClose,
}: {
  benefit: EmployeeBenefit;
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isVT = benefit.benefit_name?.toLowerCase().includes("transporte");

  const [valueOverride, setValueOverride] = useState(
    benefit.value_override != null ? String(benefit.value_override) : ""
  );
  const [vtData, setVtData] = useState<{ ticket_price: number; tickets_per_day: number } | null>(
    benefit.ticket_price && benefit.tickets_per_day
      ? { ticket_price: benefit.ticket_price, tickets_per_day: benefit.tickets_per_day }
      : null
  );

  const canSubmit = isVT ? vtData !== null : true;

  const mutation = useMutation({
    mutationFn: () =>
      benefitsApi.updateAssignment(benefit.id, {
        ...(isVT && vtData
          ? { ticket_price: vtData.ticket_price, tickets_per_day: vtData.tickets_per_day }
          : { value_override: valueOverride ? parseFloat(valueOverride) : undefined }),
      }),
    onSuccess: () => {
      toast({ title: "Benefício atualizado!" });
      queryClient.invalidateQueries({ queryKey: ["benefits-team"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao atualizar", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Editar — {benefit.benefit_name}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          {isVT ? (
            <VTCalculator
              initialPrice={benefit.ticket_price ?? undefined}
              initialPerDay={benefit.tickets_per_day ?? undefined}
              onVTChange={setVtData}
            />
          ) : benefit.value_type !== "info" ? (
            <div className="space-y-1">
              <Label>
                Valor{" "}
                <span className="text-muted-foreground text-xs">
                  (opcional — sobrescreve o valor do catálogo)
                </span>
              </Label>
              <CurrencyInput value={valueOverride} onChange={setValueOverride} />
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">Este benefício é informativo e não possui valor configurável.</p>
          )}
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!canSubmit || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
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
  const [assigning, setAssigning] = useState<{ userId: string; name: string; existingIds: string[] } | null>(null);
  const [editing, setEditing] = useState<EmployeeBenefit | null>(null);

  const { data: team = [], isLoading: loadingTeam } = useQuery({
    queryKey: ["benefits-team"],
    queryFn: benefitsApi.team,
  });

  const { data: allCollabs = [], isLoading: loadingCollabs } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaboratorsApi.list(),
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

  // index benefits by user_id
  const benefitsByUser = team.reduce<Record<string, EmployeeBenefit[]>>((acc, b) => {
    if (!acc[b.user_id]) acc[b.user_id] = [];
    acc[b.user_id].push(b);
    return acc;
  }, {});

  // build full list from all collaborators
  const allUsers = (allCollabs as any[]).map((c) => ({
    userId: c.user_id as string,
    name: (c.name as string) ?? c.user_id,
    department: (c.department_name ?? c.departmentName ?? null) as string | null,
    benefits: benefitsByUser[c.user_id as string] ?? [],
  }));

  const filtered = allUsers.filter((u) =>
    u.name.toLowerCase().includes(search.toLowerCase()) ||
    (u.department ?? "").toLowerCase().includes(search.toLowerCase())
  );

  const isLoading = loadingTeam || loadingCollabs;

  return (
    <div className="space-y-4">
      {assigning && (
        <AssignDialog
          targetUserId={assigning.userId}
          targetUserName={assigning.name}
          catalog={catalog}
          existingBenefitIds={assigning.existingIds}
          onClose={() => setAssigning(null)}
        />
      )}
      {editing && (
        <EditAssignmentDialog benefit={editing} onClose={() => setEditing(null)} />
      )}

      <Input
        placeholder="Buscar colaborador ou departamento..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : filtered.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <Users className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground text-sm">Nenhum colaborador encontrado.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map((user) => (
            <Card key={user.userId}>
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
                    onClick={() => setAssigning({ userId: user.userId, name: user.name, existingIds: user.benefits.map((b) => b.benefit_id) })}
                  >
                    + Atribuir
                  </Button>
                </div>
                {user.benefits.length > 0 ? (
                  <div className="flex flex-wrap gap-2">
                    {user.benefits.map((b) => {
                      const next = new Date();
                      next.setMonth(next.getMonth() + 1);
                      const vtTotal = b.ticket_price && b.tickets_per_day
                        ? b.ticket_price * b.tickets_per_day * countWorkingDays(next.getFullYear(), next.getMonth())
                        : null;
                      const chipColor = b.benefit_category ? CATEGORY_COLORS[b.benefit_category] : "bg-muted/40 text-foreground";
                      return (
                      <div
                        key={b.id}
                        className={cn("flex items-center gap-1.5 rounded-full border px-3 py-1 text-xs", chipColor)}
                      >
                        <span className="font-medium">{b.benefit_name}</span>
                        {vtTotal !== null ? (
                          <span className="opacity-75">
                            · {vtTotal.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })}
                          </span>
                        ) : b.value !== undefined && (
                          <span className="opacity-75">
                            · {formatValue(b.value_type ?? "info", b.value)}
                          </span>
                        )}
                        <button
                          onClick={() => setEditing(b)}
                          className="ml-0.5 opacity-60 hover:opacity-100 transition-opacity"
                          title="Editar"
                        >
                          <Pencil className="h-3 w-3" />
                        </button>
                        <button
                          onClick={() => {
                            if (confirm(`Remover "${b.benefit_name}" de ${user.name}?`))
                              deleteMutation.mutate(b.id);
                          }}
                          className="opacity-60 hover:opacity-100 transition-opacity"
                          title="Remover"
                        >
                          ×
                        </button>
                      </div>
                    );})}
                  </div>
                ) : (
                  <p className="text-xs text-muted-foreground italic">Nenhum benefício atribuído.</p>
                )}
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
              {valueType === "percentage" ? (
                <div className="relative">
                  <Input
                    className="pr-9"
                    value={value}
                    onChange={(e) => setValue(e.target.value.replace(/[^\d.]/g, ""))}
                    placeholder="0"
                    inputMode="decimal"
                  />
                  <span className="absolute right-3 top-1/2 -translate-y-1/2 text-sm text-muted-foreground select-none">%</span>
                </div>
              ) : (
                <CurrencyInput value={value} onChange={setValue} />
              )}
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
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger
              value="overview"
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2"
            >
              <LayoutDashboard className="h-4 w-4" />
              Visão Geral
            </TabsTrigger>
            <TabsTrigger
              value="collaborators"
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2"
            >
              <Users className="h-4 w-4" />
              Colaboradores
            </TabsTrigger>
            <TabsTrigger
              value="catalog"
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2"
            >
              <BookOpen className="h-4 w-4" />
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
