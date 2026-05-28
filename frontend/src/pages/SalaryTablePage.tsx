import { useState, useEffect } from "react";
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
  highlight = false,
}: {
  value: string;
  onChange: (raw: string) => void;
  placeholder?: string;
  className?: string;
  highlight?: boolean;
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
        className={cn("pl-8 text-right text-sm h-8", highlight && "border-destructive focus-visible:ring-destructive")}
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
  abaixo_minimo: "bg-red-500/15 text-red-400 border-red-500/20",
  band_90: "bg-yellow-500/15 text-yellow-400 border-yellow-500/20",
  mediana: "bg-green-500/15 text-green-400 border-green-500/20",
  band_105: "bg-blue-500/15 text-blue-400 border-blue-500/20",
  maximo_ou_acima: "bg-purple-500/15 text-purple-400 border-purple-500/20",
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

type GridPosition = { job_family: string; seniority: string };

const DEFAULT_POSITIONS: GridPosition[] = [
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

function positionKey(p: GridPosition): string {
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

function SalaryTableTab({
  selectedRefId,
  positions,
  tableEntries,
  entriesLoading,
  grid,
  setGrid,
}: {
  selectedRefId: string;
  positions: GridPosition[];
  tableEntries?: SalaryTableEntry[];
  entriesLoading: boolean;
  grid: Record<string, GridRow>;
  setGrid: React.Dispatch<React.SetStateAction<Record<string, GridRow>>>;
}) {
  const qc = useQueryClient();
  const { toast } = useToast();

  const setCell = (posKey: string, band: BandKey, value: string) => {
    setGrid((prev) => ({
      ...prev,
      [posKey]: { ...(prev[posKey] ?? emptyRow()), [band]: value },
    }));
  };

  const incompleteCells = new Set<string>();
  let filledRowCount = 0;
  for (const pos of positions) {
    if (!pos.job_family) continue;
    const key = positionKey(pos);
    const row = grid[key] ?? emptyRow();
    const filled = BANDS.filter((b) => row[b.key] && parseFloat(row[b.key]) > 0);
    if (filled.length === 0) continue;
    filledRowCount++;
    if (filled.length < BANDS.length) {
      for (const b of BANDS) {
        if (!row[b.key] || parseFloat(row[b.key]) <= 0) {
          incompleteCells.add(`${key}|${b.key}`);
        }
      }
    }
  }
  const canSave = filledRowCount > 0 && incompleteCells.size === 0;

  const saveMutation = useMutation({
    mutationFn: () => {
      const entries = positions
        .filter((pos) => pos.job_family.trim())
        .map((pos) => {
          const row = grid[positionKey(pos)] ?? emptyRow();
          return {
            job_family: pos.job_family.trim(),
            seniority: pos.seniority.trim(),
            band_90: parseFloat(row.band_90 || "0"),
            band_95: parseFloat(row.band_95 || "0"),
            band_100: parseFloat(row.band_100 || "0"),
            band_105: parseFloat(row.band_105 || "0"),
            band_110: parseFloat(row.band_110 || "0"),
          };
        })
        .filter((e) => e.band_100 > 0);

      for (const e of entries) {
        if (!(e.band_90 < e.band_95 && e.band_95 < e.band_100 && e.band_100 < e.band_105 && e.band_105 < e.band_110)) {
          throw new Error(`Bandas inválidas para ${e.job_family} ${e.seniority}: devem ser crescentes (P90 < P95 < Mediana < P105 < P110)`);
        }
      }

      return salaryApi.upsertTable({ reference_id: selectedRefId, entries });
    },
    onSuccess: () => {
      toast({ title: "Tabela salva com sucesso" });
      qc.invalidateQueries({ queryKey: ["salary-table", selectedRefId] });
      qc.invalidateQueries({ queryKey: ["salary-positioning"], exact: false });
    },
    onError: (e: Error) => toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  return (
    <div className="space-y-4">
      {!selectedRefId && (
        <Card>
          <CardContent className="py-12 text-center text-muted-foreground">
            <DollarSign className="w-10 h-10 mx-auto mb-3 opacity-30" />
            <p>Selecione ou crie uma referência de mercado para editar a tabela salarial.</p>
          </CardContent>
        </Card>
      )}

      {selectedRefId && entriesLoading && (
        <p className="text-sm text-muted-foreground">Carregando tabela...</p>
      )}

      {selectedRefId && !entriesLoading && (
        <>
          <div className="overflow-x-auto rounded-md border">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-muted/50 border-b">
                  <th className="sticky left-0 bg-muted/50 z-10 text-left px-4 py-2.5 font-semibold text-sm min-w-52">Cargo</th>
                  <th className="text-center px-3 py-2.5 font-semibold text-xs text-yellow-400 min-w-36">P90</th>
                  <th className="text-center px-3 py-2.5 font-semibold text-xs text-yellow-300/80 min-w-36">P95</th>
                  <th className="text-center px-3 py-2.5 font-semibold text-xs text-green-400 min-w-36">Mediana</th>
                  <th className="text-center px-3 py-2.5 font-semibold text-xs text-blue-400 min-w-36">P105</th>
                  <th className="text-center px-3 py-2.5 font-semibold text-xs text-purple-400 min-w-36">P110</th>
                </tr>
              </thead>
              <tbody>
                {positions.map((pos, i) => {
                  const key = positionKey(pos);
                  const row = grid[key] ?? emptyRow();
                  return (
                    <tr key={i} className={cn("border-b last:border-0", i % 2 === 0 ? "" : "bg-muted/20")}>
                      <td className="sticky left-0 bg-background z-10 px-4 py-2 font-medium border-r whitespace-nowrap">
                        {pos.job_family}{pos.seniority ? ` ${pos.seniority}` : ""}
                      </td>
                      {BANDS.map((b) => {
                        const isEmpty = incompleteCells.has(`${key}|${b.key}`);
                        return (
                          <td key={b.key} className="px-2 py-1">
                            <CurrencyInput
                              value={row[b.key]}
                              onChange={(v) => setCell(key, b.key, v)}
                              highlight={isEmpty}
                            />
                          </td>
                        );
                      })}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className="flex items-center justify-end gap-3">
            {incompleteCells.size > 0 && (
              <p className="text-xs text-destructive">Linhas parcialmente preenchidas — complete todas as bandas ou deixe a linha vazia.</p>
            )}
            <Button onClick={() => saveMutation.mutate()} disabled={!canSave || saveMutation.isPending}>
              {saveMutation.isPending ? "Salvando..." : "Salvar tabela"}
            </Button>
          </div>
        </>
      )}

    </div>
  );
}

// ── Cargos tab ────────────────────────────────────────────────────────────────

function CargosTab({
  selectedRefId,
  positions,
  setPositions,
}: {
  selectedRefId: string;
  positions: GridPosition[];
  setPositions: (p: GridPosition[]) => void;
}) {
  const { toast } = useToast();
  const [familyInput, setFamilyInput] = useState("");
  const [seniorityInput, setSeniorityInput] = useState("");

  if (!selectedRefId) return <p className="text-sm text-muted-foreground">Selecione uma referência acima para gerenciar os cargos.</p>;

  const handleAdd = () => {
    const family = familyInput.trim();
    if (!family) return;
    const duplicate = positions.some(
      (p) => p.job_family === family && p.seniority === seniorityInput.trim()
    );
    if (duplicate) {
      toast({ title: "Cargo duplicado", description: "Esse cargo já existe na lista.", variant: "destructive" });
      return;
    }
    setPositions([...positions, { job_family: family, seniority: seniorityInput.trim() }]);
    setFamilyInput("");
    setSeniorityInput("");
  };

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Cargos da tabela</CardTitle>
        </CardHeader>
        <CardContent className="space-y-2">
          {positions.map((pos, index) => (
            <div key={index} className="flex items-center justify-between py-1 border-b last:border-0">
              <span className="text-sm font-medium">
                {`${pos.job_family}${pos.seniority ? ` ${pos.seniority}` : ""}`.trim()}
              </span>
              <button
                onClick={() => setPositions(positions.filter((_, i) => i !== index))}
                className="flex h-6 w-6 items-center justify-center rounded-md bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25 text-sm font-bold"
                title="Remover cargo"
              >
                ×
              </button>
            </div>
          ))}

          <div className="flex items-end gap-2 pt-3">
            <div className="flex-1">
              <Label className="text-xs mb-1 block">Família</Label>
              <Input
                value={familyInput}
                onChange={(e) => setFamilyInput(e.target.value)}
                placeholder="ex: Especialista"
                onKeyDown={(e) => e.key === "Enter" && handleAdd()}
              />
            </div>
            <div className="flex-1">
              <Label className="text-xs mb-1 block">Nível</Label>
              <Input
                value={seniorityInput}
                onChange={(e) => setSeniorityInput(e.target.value)}
                placeholder="ex: Sênior (opcional)"
                onKeyDown={(e) => e.key === "Enter" && handleAdd()}
              />
            </div>
            <Button onClick={handleAdd} disabled={!familyInput.trim()}>
              Adicionar
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

// ── Edit employee dialog ──────────────────────────────────────────────────────

function EditEmployeeDialog({
  employee,
  positions,
  onClose,
}: {
  employee: SalaryPositioning;
  positions: GridPosition[];
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const [salary, setSalary] = useState(employee.current_salary != null ? String(employee.current_salary) : "");
  const [jobFamily, setJobFamily] = useState(employee.job_family || "__none__");
  const [seniority, setSeniority] = useState(employee.seniority || "__none__");

  // Unique families from the active reference's positions, preserving order
  const families = Array.from(new Map(positions.map((p) => [p.job_family, p.job_family])).values());

  // Seniorities available for the selected family
  const senioritiesForFamily = positions
    .filter((p) => p.job_family === jobFamily)
    .map((p) => p.seniority);
  const hasSeniority = senioritiesForFamily.some((s) => s !== "");

  const handleFamilyChange = (v: string) => {
    setJobFamily(v);
    setSeniority("__none__");
  };

  const mutation = useMutation({
    mutationFn: () =>
      salaryApi.updateEmployee(employee.user_id, {
        current_salary: salary ? parseFloat(salary) : null,
        job_family: jobFamily === "__none__" ? null : jobFamily || null,
        seniority: seniority === "__none__" ? null : seniority || null,
      }),
    onSuccess: () => {
      toast({ title: "Dados atualizados" });
      qc.invalidateQueries({ queryKey: ["salary-positioning"], exact: false });
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
            <Select value={jobFamily} onValueChange={handleFamilyChange}>
              <SelectTrigger className="mt-1">
                <SelectValue placeholder="Selecione" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">—</SelectItem>
                {families.map((f) => (
                  <SelectItem key={f} value={f}>{f}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          {hasSeniority && (
            <div>
              <Label>Senioridade</Label>
              <Select value={seniority} onValueChange={setSeniority}>
                <SelectTrigger className="mt-1">
                  <SelectValue placeholder="Selecione" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="__none__">—</SelectItem>
                  {senioritiesForFamily.filter((s) => s !== "").map((s) => (
                    <SelectItem key={s} value={s}>{s}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          )}
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

function PositioningTab({ positions, selectedRefId }: { positions: GridPosition[]; selectedRefId: string }) {
  const { data: employees = [], isLoading } = useQuery({
    queryKey: ["salary-positioning", selectedRefId],
    queryFn: () => salaryApi.positioning(selectedRefId),
    enabled: !!selectedRefId,
  });

  const [editing, setEditing] = useState<SalaryPositioning | null>(null);

  if (!selectedRefId) {
    return (
      <Card>
        <CardContent className="py-12 text-center text-muted-foreground">
          <DollarSign className="w-10 h-10 mx-auto mb-3 opacity-30" />
          <p>Selecione uma referência de mercado acima para ver o posicionamento salarial.</p>
        </CardContent>
      </Card>
    );
  }

  if (isLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

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
                      <button
                        onClick={() => setEditing(emp)}
                        title="Editar"
                        className="flex h-7 w-7 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25"
                      >
                        <Pencil className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {editing && (
        <EditEmployeeDialog employee={editing} positions={positions} onClose={() => setEditing(null)} />
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function SalaryTablePage() {
  const qc = useQueryClient();
  const { toast } = useToast();
  const [selectedRefId, setSelectedRefId] = useState<string>("");
  const [positions, setPositions] = useState<GridPosition[]>(DEFAULT_POSITIONS);
  const [grid, setGrid] = useState<Record<string, GridRow>>({});
  const [loadedRefId, setLoadedRefId] = useState<string>("");
  const [showCreate, setShowCreate] = useState(false);

  const { data: references = [] } = useQuery({
    queryKey: ["salary-references"],
    queryFn: salaryApi.references,
  });

  const { data: tableEntries, isLoading: entriesLoading } = useQuery({
    queryKey: ["salary-table", selectedRefId],
    queryFn: () => salaryApi.table(selectedRefId),
    enabled: !!selectedRefId,
  });

  // Only initialize positions/grid when the selected reference actually changes
  useEffect(() => {
    if (!selectedRefId) {
      setPositions(DEFAULT_POSITIONS);
      setGrid({});
      setLoadedRefId("");
      return;
    }
    if (loadedRefId === selectedRefId) return;
    if (tableEntries === undefined) return; // still loading
    setLoadedRefId(selectedRefId);
    if (tableEntries.length > 0) {
      setPositions(tableEntries.map((e) => ({ job_family: e.job_family, seniority: e.seniority })));
      const next: Record<string, GridRow> = {};
      for (const e of tableEntries) {
        next[positionKey(e)] = entryToRow(e);
      }
      setGrid(next);
    } else {
      setPositions(DEFAULT_POSITIONS);
      setGrid({});
    }
  }, [tableEntries, selectedRefId, loadedRefId]);

  const deleteRefMutation = useMutation({
    mutationFn: (id: string) => salaryApi.deleteReference(id),
    onSuccess: () => {
      toast({ title: "Referência excluída" });
      setSelectedRefId("");
      setLoadedRefId("");
      qc.invalidateQueries({ queryKey: ["salary-references"] });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const activeRef = references.find((r) => r.id === selectedRefId);

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <DollarSign className="w-6 h-6 text-primary" />
          <div>
            <h1 className="text-2xl font-bold">Tabela Salarial</h1>
            <p className="text-sm text-muted-foreground">Gerencie referências de mercado e posicionamento salarial da equipe</p>
          </div>
        </div>

        <div className="flex items-center gap-3 flex-wrap">
          <Select value={selectedRefId} onValueChange={(v) => { setLoadedRefId(""); setSelectedRefId(v); }}>
            <SelectTrigger className="w-72">
              <SelectValue placeholder="Selecione uma referência de mercado" />
            </SelectTrigger>
            <SelectContent>
              {references.map((r) => (
                <SelectItem key={r.id} value={r.id}>{r.name} ({r.reference_year})</SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Button variant="outline" size="sm" onClick={() => setShowCreate(true)}>
            <Plus className="w-4 h-4 mr-1" />Nova referência
          </Button>
          {activeRef && (
            <button
              onClick={() => {
                if (confirm(`Excluir "${activeRef.name}"? Todos os dados serão removidos.`)) deleteRefMutation.mutate(activeRef.id);
              }}
              className="flex items-center gap-1.5 rounded-lg bg-destructive/15 px-3 py-1.5 text-sm text-destructive transition-colors hover:bg-destructive/25"
            >
              <Trash2 className="w-4 h-4" />Excluir referência
            </button>
          )}
        </div>

        {activeRef && (
          <div className="flex items-center gap-2 flex-wrap">
            <span className="inline-flex items-center rounded-md bg-muted px-2.5 py-1 text-xs font-medium text-muted-foreground">{activeRef.market}</span>
            <span className="inline-flex items-center rounded-md bg-muted px-2.5 py-1 text-xs font-medium text-muted-foreground">{activeRef.region}</span>
            <span className="inline-flex items-center rounded-md bg-primary/10 px-2.5 py-1 text-xs font-semibold text-primary">{activeRef.reference_year}</span>
          </div>
        )}
        {!selectedRefId && <p className="text-sm text-muted-foreground">Selecione ou crie uma referência para editar a tabela e os cargos.</p>}

        <CreateReferenceDialog
          open={showCreate}
          onClose={() => setShowCreate(false)}
          onCreated={(ref) => {
            qc.invalidateQueries({ queryKey: ["salary-references"] });
            setLoadedRefId("");
            setSelectedRefId(ref.id);
          }}
        />

        <Tabs defaultValue="tabela">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger value="tabela" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground">
              Tabela Salarial
            </TabsTrigger>
            <TabsTrigger value="posicionamento" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground">
              Posicionamento
            </TabsTrigger>
            <TabsTrigger value="cargos" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground">
              Cargos
            </TabsTrigger>
          </TabsList>
          <TabsContent value="tabela" className="mt-4">
            <SalaryTableTab
              selectedRefId={selectedRefId}
              positions={positions}
              tableEntries={tableEntries}
              entriesLoading={entriesLoading}
              grid={grid}
              setGrid={setGrid}
            />
          </TabsContent>
          <TabsContent value="posicionamento" className="mt-4">
            <PositioningTab positions={positions} selectedRefId={selectedRefId} />
          </TabsContent>
          <TabsContent value="cargos" className="mt-4">
            <CargosTab
              selectedRefId={selectedRefId}
              positions={positions}
              setPositions={setPositions}
            />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
