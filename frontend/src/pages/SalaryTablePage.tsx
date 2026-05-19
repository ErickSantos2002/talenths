import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { salary as salaryApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
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
import { useToast } from "@/hooks/use-toast";
import type { SalaryReference, SalaryTableEntry, SalaryPositioning, SalaryBand } from "@/types/salary";
import { DollarSign, Pencil, Plus, Trash2 } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Currency input ────────────────────────────────────────────────────────────

function parseCurrencyToCents(display: string): string {
  return display.replace(/\D/g, "");
}

function formatCentsToDisplay(cents: string): string {
  const n = parseInt(cents || "0", 10);
  return (n / 100).toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function CurrencyInput({
  value,
  onChange,
  placeholder = "0,00",
  className,
}: {
  value: string;
  onChange: (raw: string) => void;
  placeholder?: string;
  className?: string;
}) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const cents = parseCurrencyToCents(e.target.value);
    onChange(cents ? String(parseInt(cents, 10) / 100) : "");
  };

  const displayValue = value ? formatCentsToDisplay(String(Math.round(parseFloat(value) * 100))) : "";

  return (
    <div className={cn("relative", className)}>
      <span className="absolute left-2 top-1/2 -translate-y-1/2 text-xs text-muted-foreground select-none">R$</span>
      <Input
        className="pl-8 text-right text-sm h-8"
        value={displayValue}
        onChange={handleChange}
        placeholder={placeholder}
        inputMode="numeric"
      />
    </div>
  );
}

// ── Band badge ────────────────────────────────────────────────────────────────

const BAND_LABELS: Record<SalaryBand, string> = {
  abaixo_minimo: "Abaixo do mín.",
  band_90: "Faixa 90",
  mediana: "Mediana",
  band_105: "Faixa 105",
  maximo_ou_acima: "Acima do máx.",
};

const BAND_COLORS: Record<SalaryBand, string> = {
  abaixo_minimo: "bg-red-100 text-red-700 border-red-200",
  band_90: "bg-yellow-100 text-yellow-700 border-yellow-200",
  mediana: "bg-green-100 text-green-700 border-green-200",
  band_105: "bg-blue-100 text-blue-700 border-blue-200",
  maximo_ou_acima: "bg-purple-100 text-purple-700 border-purple-200",
};

function BandBadge({ band }: { band?: SalaryBand }) {
  if (!band) return <Badge variant="outline" className="text-xs text-muted-foreground">Sem dados</Badge>;
  return (
    <Badge className={cn("text-xs border", BAND_COLORS[band])}>
      {BAND_LABELS[band]}
    </Badge>
  );
}

// ── Positions ─────────────────────────────────────────────────────────────────

const POSITIONS = [
  { job_family: "Diretor", seniority: "" },
  { job_family: "Gerente", seniority: "Sênior" },
  { job_family: "Gerente", seniority: "Pleno" },
  { job_family: "Gerente", seniority: "Júnior" },
  { job_family: "Coordenador", seniority: "Sênior" },
  { job_family: "Coordenador", seniority: "Pleno" },
  { job_family: "Coordenador", seniority: "Júnior" },
  { job_family: "Analista", seniority: "Sênior" },
  { job_family: "Analista", seniority: "Pleno" },
  { job_family: "Analista", seniority: "Júnior" },
];

function positionLabel(p: { job_family: string; seniority: string }): string {
  return p.seniority ? `${p.job_family} ${p.seniority}` : p.job_family;
}

function positionKey(p: { job_family: string; seniority: string }): string {
  return `${p.job_family}|${p.seniority}`;
}

// ── Types for grid state ──────────────────────────────────────────────────────

type BandKey = "band_90" | "band_95" | "band_100" | "band_105" | "band_110";

type GridRow = Record<BandKey, string>;

function entryToRow(e: SalaryTableEntry): GridRow {
  return {
    band_90: String(e.band_90),
    band_95: String(e.band_95),
    band_100: String(e.band_100),
    band_105: String(e.band_105),
    band_110: String(e.band_110),
  };
}

function emptyRow(): GridRow {
  return { band_90: "", band_95: "", band_100: "", band_105: "", band_110: "" };
}

// ── Create reference dialog ───────────────────────────────────────────────────

function CreateReferenceDialog({
  open,
  onClose,
  onCreated,
}: {
  open: boolean;
  onClose: () => void;
  onCreated: (ref: SalaryReference) => void;
}) {
  const { toast } = useToast();
  const [form, setForm] = useState({ name: "", market: "", region: "", reference_year: String(new Date().getFullYear()) });

  const mutation = useMutation({
    mutationFn: () => salaryApi.createReference(form),
    onSuccess: (ref) => {
      toast({ title: "Referência criada" });
      onCreated(ref);
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const set = (k: keyof typeof form, v: string) => setForm((f) => ({ ...f, [k]: v }));

  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Nova referência de mercado</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div>
            <Label>Nome</Label>
            <Input value={form.name} onChange={(e) => set("name", e.target.value)} placeholder="Ex: Pesquisa Salarial 2026" />
          </div>
          <div>
            <Label>Mercado</Label>
            <Input value={form.market} onChange={(e) => set("market", e.target.value)} placeholder="Ex: Tecnologia / Saúde e Segurança" />
          </div>
          <div>
            <Label>Região</Label>
            <Input value={form.region} onChange={(e) => set("region", e.target.value)} placeholder="Ex: São Paulo" />
          </div>
          <div>
            <Label>Ano de referência</Label>
            <Input value={form.reference_year} onChange={(e) => set("reference_year", e.target.value)} inputMode="numeric" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={mutation.isPending || !form.name || !form.market || !form.region}>
            Criar
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Salary table tab ──────────────────────────────────────────────────────────

const BANDS: { key: BandKey; label: string }[] = [
  { key: "band_90", label: "P90" },
  { key: "band_95", label: "P95" },
  { key: "band_100", label: "Mediana" },
  { key: "band_105", label: "P105" },
  { key: "band_110", label: "P110" },
];

function SalaryTableTab() {
  const qc = useQueryClient();
  const { toast } = useToast();

  const { data: references = [], isLoading: refsLoading } = useQuery({
    queryKey: ["salary-references"],
    queryFn: salaryApi.references,
  });

  const [selectedRefId, setSelectedRefId] = useState<string>("");
  const [showCreate, setShowCreate] = useState(false);
  const [grid, setGrid] = useState<Record<string, GridRow>>({});
  const [gridLoaded, setGridLoaded] = useState<string>("");

  const { isLoading: entriesLoading } = useQuery({
    queryKey: ["salary-table", selectedRefId],
    queryFn: () => salaryApi.table(selectedRefId),
    enabled: !!selectedRefId,
    onSuccess: (entries: SalaryTableEntry[]) => {
      const next: Record<string, GridRow> = {};
      for (const pos of POSITIONS) {
        const key = positionKey(pos);
        const found = entries.find((e) => e.job_family === pos.job_family && e.seniority === pos.seniority);
        next[key] = found ? entryToRow(found) : emptyRow();
      }
      setGrid(next);
      setGridLoaded(selectedRefId);
    },
  });

  const saveMutation = useMutation({
    mutationFn: () => {
      const entries = POSITIONS.map((pos) => {
        const row = grid[positionKey(pos)] ?? emptyRow();
        return {
          job_family: pos.job_family,
          seniority: pos.seniority,
          band_90: parseFloat(row.band_90 || "0"),
          band_95: parseFloat(row.band_95 || "0"),
          band_100: parseFloat(row.band_100 || "0"),
          band_105: parseFloat(row.band_105 || "0"),
          band_110: parseFloat(row.band_110 || "0"),
        };
      });

      for (const e of entries) {
        if (e.band_100 === 0) continue;
        if (!(e.band_90 < e.band_95 && e.band_95 < e.band_100 && e.band_100 < e.band_105 && e.band_105 < e.band_110)) {
          throw new Error(`Bandas inválidas para ${e.job_family} ${e.seniority}: devem ser crescentes (P90 < P95 < Mediana < P105 < P110)`);
        }
      }

      return salaryApi.upsertTable({ reference_id: selectedRefId, entries });
    },
    onSuccess: () => {
      toast({ title: "Tabela salva com sucesso" });
      qc.invalidateQueries({ queryKey: ["salary-table", selectedRefId] });
      qc.invalidateQueries({ queryKey: ["salary-positioning"] });
    },
    onError: (e: Error) => toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  const deleteRefMutation = useMutation({
    mutationFn: (id: string) => salaryApi.deleteReference(id),
    onSuccess: () => {
      toast({ title: "Referência excluída" });
      setSelectedRefId("");
      qc.invalidateQueries({ queryKey: ["salary-references"] });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const setCell = (posKey: string, band: BandKey, value: string) => {
    setGrid((prev) => ({
      ...prev,
      [posKey]: { ...(prev[posKey] ?? emptyRow()), [band]: value },
    }));
  };

  const activeRef = references.find((r) => r.id === selectedRefId);

  if (refsLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-3 flex-wrap">
        <Select value={selectedRefId} onValueChange={setSelectedRefId}>
          <SelectTrigger className="w-72">
            <SelectValue placeholder="Selecione uma referência de mercado" />
          </SelectTrigger>
          <SelectContent>
            {references.map((r) => (
              <SelectItem key={r.id} value={r.id}>
                {r.name} ({r.reference_year})
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Button variant="outline" size="sm" onClick={() => setShowCreate(true)}>
          <Plus className="w-4 h-4 mr-1" />
          Nova referência
        </Button>
        {activeRef && (
          <Button
            variant="ghost"
            size="sm"
            className="text-destructive hover:text-destructive"
            onClick={() => {
              if (confirm(`Excluir "${activeRef.name}"? Todos os dados desta tabela serão removidos.`)) {
                deleteRefMutation.mutate(activeRef.id);
              }
            }}
          >
            <Trash2 className="w-4 h-4 mr-1" />
            Excluir referência
          </Button>
        )}
      </div>

      {activeRef && (
        <p className="text-sm text-muted-foreground">
          {activeRef.market} · {activeRef.region} · {activeRef.reference_year}
        </p>
      )}

      {!selectedRefId && (
        <Card>
          <CardContent className="py-12 text-center text-muted-foreground">
            <DollarSign className="w-10 h-10 mx-auto mb-3 opacity-30" />
            <p>Selecione ou crie uma referência de mercado para editar a tabela salarial.</p>
          </CardContent>
        </Card>
      )}

      {selectedRefId && (entriesLoading && gridLoaded !== selectedRefId) && (
        <p className="text-sm text-muted-foreground">Carregando tabela...</p>
      )}

      {selectedRefId && (!entriesLoading || gridLoaded === selectedRefId) && (
        <>
          <div className="overflow-x-auto rounded-md border">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-muted/50 border-b">
                  <th className="sticky left-0 bg-muted/50 z-10 text-left px-4 py-2 font-medium min-w-44">Cargo</th>
                  {BANDS.map((b) => (
                    <th key={b.key} className="text-center px-3 py-2 font-medium min-w-36">{b.label}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {POSITIONS.map((pos, i) => {
                  const key = positionKey(pos);
                  const row = grid[key] ?? emptyRow();
                  return (
                    <tr key={key} className={cn("border-b last:border-0", i % 2 === 0 ? "" : "bg-muted/20")}>
                      <td className="sticky left-0 bg-background z-10 px-4 py-2 font-medium border-r">
                        {positionLabel(pos)}
                      </td>
                      {BANDS.map((b) => (
                        <td key={b.key} className="px-2 py-1">
                          <CurrencyInput
                            value={row[b.key]}
                            onChange={(v) => setCell(key, b.key, v)}
                          />
                        </td>
                      ))}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="flex justify-end">
            <Button onClick={() => saveMutation.mutate()} disabled={saveMutation.isPending}>
              {saveMutation.isPending ? "Salvando..." : "Salvar tabela"}
            </Button>
          </div>
        </>
      )}

      <CreateReferenceDialog
        open={showCreate}
        onClose={() => setShowCreate(false)}
        onCreated={(ref) => {
          qc.invalidateQueries({ queryKey: ["salary-references"] });
          setSelectedRefId(ref.id);
        }}
      />
    </div>
  );
}

// ── Edit employee dialog ──────────────────────────────────────────────────────

const JOB_FAMILIES = ["Diretor", "Gerente", "Coordenador", "Analista"];
const SENIORITIES = ["__none__", "Sênior", "Pleno", "Júnior"];

function EditEmployeeDialog({
  employee,
  onClose,
}: {
  employee: SalaryPositioning;
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const [salary, setSalary] = useState(employee.current_salary != null ? String(employee.current_salary) : "");
  const [jobFamily, setJobFamily] = useState(employee.job_family || "__none__");
  const [seniority, setSeniority] = useState(employee.seniority || "__none__");

  const mutation = useMutation({
    mutationFn: () =>
      salaryApi.updateEmployee(employee.user_id, {
        current_salary: salary ? parseFloat(salary) : null,
        job_family: jobFamily === "__none__" ? null : jobFamily || null,
        seniority: seniority === "__none__" ? null : seniority || null,
      }),
    onSuccess: () => {
      toast({ title: "Dados atualizados" });
      qc.invalidateQueries({ queryKey: ["salary-positioning"] });
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={(o) => !o && onClose()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Editar dados salariais — {employee.name}</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div>
            <Label>Salário atual</Label>
            <CurrencyInput value={salary} onChange={setSalary} className="mt-1" />
          </div>
          <div>
            <Label>Família de cargo</Label>
            <Select value={jobFamily} onValueChange={setJobFamily}>
              <SelectTrigger className="mt-1">
                <SelectValue placeholder="Selecione" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">—</SelectItem>
                {JOB_FAMILIES.map((f) => (
                  <SelectItem key={f} value={f}>{f}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Senioridade</Label>
            <Select value={seniority} onValueChange={setSeniority}>
              <SelectTrigger className="mt-1">
                <SelectValue placeholder="Selecione" />
              </SelectTrigger>
              <SelectContent>
                {SENIORITIES.map((s) => (
                  <SelectItem key={s} value={s}>{s === "__none__" ? "—" : s}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={mutation.isPending}>
            Salvar
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Positioning tab ───────────────────────────────────────────────────────────

function formatBRL(value?: number): string {
  if (value == null) return "—";
  return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

function PositioningTab() {
  const { data: refs = [] } = useQuery({
    queryKey: ["salary-references"],
    queryFn: salaryApi.references,
  });

  const { data: employees = [], isLoading } = useQuery({
    queryKey: ["salary-positioning"],
    queryFn: salaryApi.positioning,
  });

  const [editing, setEditing] = useState<SalaryPositioning | null>(null);

  const hasActiveRef = refs.some((r) => r.is_active);

  if (isLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

  if (!hasActiveRef && employees.length === 0) {
    return (
      <Card>
        <CardContent className="py-12 text-center text-muted-foreground">
          <DollarSign className="w-10 h-10 mx-auto mb-3 opacity-30" />
          <p>Nenhuma referência de mercado encontrada.</p>
          <p className="text-sm mt-1">Crie uma referência na aba <strong>Tabela Salarial</strong> para começar.</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Posicionamento salarial da equipe</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b bg-muted/50">
                  <th className="text-left px-4 py-2 font-medium">Colaborador</th>
                  <th className="text-left px-4 py-2 font-medium">Departamento</th>
                  <th className="text-left px-4 py-2 font-medium">Cargo</th>
                  <th className="text-right px-4 py-2 font-medium">Salário atual</th>
                  <th className="text-right px-4 py-2 font-medium">Mediana ref.</th>
                  <th className="text-right px-4 py-2 font-medium">% da mediana</th>
                  <th className="text-right px-4 py-2 font-medium">Desvio</th>
                  <th className="text-center px-4 py-2 font-medium">Faixa</th>
                  <th className="px-4 py-2" />
                </tr>
              </thead>
              <tbody>
                {employees.map((emp) => (
                  <tr key={emp.user_id} className="border-b last:border-0 hover:bg-muted/20">
                    <td className="px-4 py-2 font-medium">{emp.name}</td>
                    <td className="px-4 py-2 text-muted-foreground">{emp.department ?? "—"}</td>
                    <td className="px-4 py-2 text-muted-foreground">
                      {emp.job_family
                        ? emp.seniority
                          ? `${emp.job_family} ${emp.seniority}`
                          : emp.job_family
                        : "—"}
                    </td>
                    <td className="px-4 py-2 text-right">{formatBRL(emp.current_salary)}</td>
                    <td className="px-4 py-2 text-right text-muted-foreground">{formatBRL(emp.band_100)}</td>
                    <td className="px-4 py-2 text-right">
                      {emp.pct_of_median != null ? `${emp.pct_of_median}%` : "—"}
                    </td>
                    <td className={cn("px-4 py-2 text-right", emp.deviation != null && emp.deviation < 0 ? "text-red-600" : "text-green-600")}>
                      {emp.deviation != null ? formatBRL(emp.deviation) : "—"}
                    </td>
                    <td className="px-4 py-2 text-center">
                      <BandBadge band={emp.band} />
                    </td>
                    <td className="px-4 py-2">
                      <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => setEditing(emp)}>
                        <Pencil className="w-3.5 h-3.5" />
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {editing && (
        <EditEmployeeDialog employee={editing} onClose={() => setEditing(null)} />
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function SalaryTablePage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <DollarSign className="w-6 h-6 text-muted-foreground" />
          <div>
            <h1 className="text-2xl font-bold">Tabela Salarial</h1>
            <p className="text-sm text-muted-foreground">Gerencie referências de mercado e posicionamento salarial da equipe</p>
          </div>
        </div>

        <Tabs defaultValue="tabela">
          <TabsList>
            <TabsTrigger value="tabela">Tabela Salarial</TabsTrigger>
            <TabsTrigger value="posicionamento">Posicionamento</TabsTrigger>
          </TabsList>
          <TabsContent value="tabela" className="mt-4">
            <SalaryTableTab />
          </TabsContent>
          <TabsContent value="posicionamento" className="mt-4">
            <PositioningTab />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
