import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { evaluations as evalApi, goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { EVAL_STAGES, EVAL_STATUS_LABELS, type EvalCycle, type EvalStatus } from "@/types/evaluations";
import {
  Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

type DateField = (typeof EVAL_STAGES)[number]["start"] | (typeof EVAL_STAGES)[number]["end"];
type Dates = Record<DateField, string>;

const EMPTY_DATES: Dates = {
  eval_start: "", eval_end: "", calibration_start: "", calibration_end: "",
  feedback_start: "", feedback_end: "", pdi_start: "", pdi_end: "",
};

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Com ciclo, o diálogo edita; sem, cria. */
  cycle?: EvalCycle | null;
  onSaved?: (id: string) => void;
}

export function EvalCycleDialog({ open, onOpenChange, cycle, onSaved }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const editing = !!cycle;

  const [name, setName] = useState("");
  const [goalCycleId, setGoalCycleId] = useState("");
  const [byDates, setByDates] = useState(true);
  const [manualStatus, setManualStatus] = useState<EvalStatus>("draft");
  const [dates, setDates] = useState<Dates>(EMPTY_DATES);

  const { data: goalCycles } = useQuery({
    queryKey: ["goal-cycles"],
    queryFn: goalsApi.listCycles,
    enabled: open,
  });

  useEffect(() => {
    if (!open) return;
    setName(cycle?.name ?? "");
    setGoalCycleId(cycle?.management_cycle_id ?? "");
    setByDates(cycle?.stage_by_dates ?? true);
    setManualStatus(cycle?.manual_status ?? "draft");
    setDates(cycle
      ? Object.fromEntries(Object.keys(EMPTY_DATES).map(k => [k, cycle[k as DateField] ?? ""])) as Dates
      : EMPTY_DATES);
  }, [open, cycle]);

  const mutation = useMutation({
    mutationFn: () => {
      const payload = {
        name: name.trim(),
        management_cycle_id: goalCycleId || null,
        stage_by_dates: byDates,
        status: manualStatus,
        ...Object.fromEntries(Object.entries(dates).map(([k, v]) => [k, v || null])),
      };
      return editing ? evalApi.updateCycle(cycle!.id, payload) : evalApi.createCycle(payload);
    },
    onSuccess: (saved) => {
      queryClient.invalidateQueries({ queryKey: ["eval-cycles"] });
      toast({ title: editing ? "Ciclo atualizado" : "Ciclo de avaliação criado" });
      onOpenChange(false);
      onSaved?.(saved.id);
    },
    onError: (err: Error) => toast({
      title: editing ? "Erro ao salvar o ciclo" : "Erro ao criar ciclo",
      description: err.message,
      variant: "destructive",
    }),
  });

  const missingEvalDates = byDates && (!dates.eval_start || !dates.eval_end);
  const canSave = name.trim().length > 0 && !missingEvalDates && !mutation.isPending;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{editing ? "Editar Ciclo" : "Novo Ciclo de Avaliação"}</DialogTitle>
          <DialogDescription>
            A autoavaliação fica aberta para os colaboradores durante a etapa de Avaliação.
          </DialogDescription>
        </DialogHeader>
        <form
          onSubmit={(e) => { e.preventDefault(); if (canSave) mutation.mutate(); }}
          className="space-y-4 py-2"
        >
          <div className="space-y-1.5">
            <Label htmlFor="cycle-name">Nome do ciclo</Label>
            <Input
              id="cycle-name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Ex: Avaliação 2026 — 1º Semestre"
            />
          </div>

          <div className="space-y-1.5">
            <Label>Vincular ao ciclo de metas (opcional)</Label>
            {/* Enquanto a lista não chega, o Radix devolve "" para um valor sem item (ignorado, para
                não perder o vínculo) e não atualiza o rótulo depois (daí remontar com a lista). */}
            <Select
              key={goalCycles ? "loaded" : "loading"}
              value={goalCycleId || "__none__"}
              onValueChange={(v) => { if (v) setGoalCycleId(v === "__none__" ? "" : v); }}
            >
              <SelectTrigger><SelectValue placeholder="Nenhum" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">Nenhum</SelectItem>
                {(goalCycles ?? []).map(c => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            <p className="text-xs text-muted-foreground">Usado para calcular o eixo de metas do 9Box.</p>
          </div>

          <div className="space-y-3">
            <Label>Datas das etapas</Label>
            {EVAL_STAGES.map(s => (
              <div key={s.status} className="grid grid-cols-2 gap-2">
                <div className="space-y-1">
                  <Label htmlFor={`${s.start}`} className="text-xs font-normal text-muted-foreground">
                    {s.label}: início
                  </Label>
                  <Input
                    id={s.start}
                    type="date"
                    value={dates[s.start]}
                    onChange={(e) => setDates(d => ({ ...d, [s.start]: e.target.value }))}
                  />
                </div>
                <div className="space-y-1">
                  <Label htmlFor={`${s.end}`} className="text-xs font-normal text-muted-foreground">
                    {s.label}: fim
                  </Label>
                  <Input
                    id={s.end}
                    type="date"
                    value={dates[s.end]}
                    onChange={(e) => setDates(d => ({ ...d, [s.end]: e.target.value }))}
                  />
                </div>
              </div>
            ))}
          </div>

          <div className="rounded-lg border p-3 space-y-3">
            <div className="flex items-center justify-between gap-3">
              <div>
                <Label htmlFor="cycle-by-dates">Avançar as etapas pelas datas</Label>
                <p className="text-xs text-muted-foreground">
                  O ciclo muda de etapa sozinho em cada data. Desligado, você troca a etapa à mão.
                </p>
              </div>
              <Switch id="cycle-by-dates" checked={byDates} onCheckedChange={setByDates} />
            </div>
            {byDates ? (
              missingEvalDates && (
                <p className="text-xs text-amber-600 dark:text-amber-400">
                  Preencha o início e o fim de Avaliação.
                </p>
              )
            ) : (
              <div className="space-y-1.5">
                <Label>Etapa atual</Label>
                <Select value={manualStatus} onValueChange={(v) => setManualStatus(v as EvalStatus)}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {Object.entries(EVAL_STATUS_LABELS).map(([value, label]) => (
                      <SelectItem key={value} value={value}>{label}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
          </div>

          <DialogFooter>
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
            <Button type="submit" disabled={!canSave}>
              {mutation.isPending ? "Salvando..." : editing ? "Salvar" : "Criar Ciclo"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
