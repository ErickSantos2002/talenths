import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { goals as goalsApi, collaborators as collaboratorsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { MONTHS, type GoalDetail } from "@/types/goals";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { HelpTip } from "@/components/HelpTip";
import { Combobox } from "@/components/Combobox";

const goalSchema = z.object({
  department_id: z.string().min(1, "Obrigatório"),
  responsible_user_id: z.string().optional(),
  title: z.string().min(1, "Obrigatório"),
  objective: z.enum(["increase", "decrease"]),
  calculation_type: z.enum(["sum", "subtraction", "average", "repeat"]),
  result_type: z.enum(["currency", "percentage", "value"]),
  weight: z.coerce.number().min(0).max(100),
  target_value: z.coerce.number().min(0),
  curve_v80: z.coerce.number().optional(),
  curve_v100: z.coerce.number().optional(),
  curve_v120: z.coerce.number().optional(),
});

type FormData = z.infer<typeof goalSchema>;

interface Dept { id: string; name: string; }

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  cycleId: string;
  departments: Dept[];
  defaultDepartmentId?: string;
  goalToEdit?: GoalDetail;
}

function plansToArray(goal?: GoalDetail): number[] {
  const arr = Array(12).fill(0);
  goal?.plans.forEach(p => { if (p.month >= 1 && p.month <= 12) arr[p.month - 1] = p.planned_value; });
  return arr;
}

export function CreateGoalDialog({ open, onOpenChange, cycleId, departments, defaultDepartmentId, goalToEdit }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isEdit = !!goalToEdit;

  const [step, setStep] = useState<1 | 2>(1);
  const [plans, setPlans] = useState<number[]>(plansToArray(goalToEdit));

  const { data: colabs } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaboratorsApi.list(),
  });

  const { register, handleSubmit, watch, setValue, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(goalSchema),
    defaultValues: goalToEdit
      ? {
          department_id: goalToEdit.department_id,
          responsible_user_id: goalToEdit.responsible_user_id ?? undefined,
          title: goalToEdit.title,
          objective: goalToEdit.objective,
          calculation_type: goalToEdit.calculation_type,
          result_type: goalToEdit.result_type,
          weight: goalToEdit.weight,
          target_value: goalToEdit.target_value,
          curve_v80: goalToEdit.curve_v80 ?? undefined,
          curve_v100: goalToEdit.curve_v100 ?? undefined,
          curve_v120: goalToEdit.curve_v120 ?? undefined,
        }
      : {
          department_id: defaultDepartmentId ?? "",
          objective: "increase",
          calculation_type: "sum",
          result_type: "value",
          weight: 0,
          target_value: 0,
        },
  });

  const targetValue = watch("target_value");
  const objectiveValue = watch("objective");

  // Valores automáticos da curva (mostrados como placeholder) a partir do valor alvo.
  const curvePlaceholder = (pct: 80 | 100 | 120) => {
    const target = parseFloat(String(targetValue)) || 0;
    if (!target) return "—";
    const factor = pct / 100;
    const v = objectiveValue === "decrease" && pct !== 100 ? target * (2 - factor) : target * factor;
    return v.toLocaleString("pt-BR", { maximumFractionDigits: 2 });
  };

  const distributeEqually = () => {
    const val = parseFloat(String(targetValue)) || 0;
    setPlans(Array(12).fill(parseFloat((val / 12).toFixed(4))));
  };

  const mutation = useMutation({
    mutationFn: async (data: FormData) => {
      const allPlans = plans.map((v, i) => ({ month: i + 1, planned_value: v }));
      if (isEdit && goalToEdit) {
        await goalsApi.update(goalToEdit.id, data);
        await goalsApi.updatePlans(goalToEdit.id, allPlans);
        return { id: goalToEdit.id, weight_warning: false };
      }
      const goal = await goalsApi.create({ ...data, cycle_id: cycleId });
      if (allPlans.some(p => p.planned_value > 0)) {
        await goalsApi.updatePlans(goal.id, allPlans);
      }
      return goal;
    },
    onSuccess: (goal) => {
      queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
      if (isEdit) {
        queryClient.invalidateQueries({ queryKey: ["goal-detail", goal.id] });
        toast({ title: "Meta atualizada" });
      } else if ((goal as { weight_warning?: boolean }).weight_warning) {
        toast({ title: "Meta criada", description: "Atenção: o total de pesos deste departamento não soma 100%." });
      } else {
        toast({ title: "Meta criada com sucesso" });
      }
      handleClose(false);
    },
    onError: (err: Error) =>
      toast({ title: isEdit ? "Erro ao atualizar meta" : "Erro ao criar meta", description: err.message, variant: "destructive" }),
  });

  const handleClose = (next: boolean) => {
    if (!next) {
      reset();
      setPlans(plansToArray(goalToEdit));
      setStep(1);
    }
    onOpenChange(next);
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <div className="flex items-center gap-3">
            <DialogTitle>{isEdit ? "Editar Meta" : "Nova Meta"}</DialogTitle>
            <div className="flex gap-1">
              <Badge variant={step === 1 ? "default" : "outline"} className="cursor-default">1. Configuração</Badge>
              <Badge variant={step === 2 ? "default" : "outline"} className="cursor-default">2. Mensalização</Badge>
            </div>
          </div>
        </DialogHeader>

        {step === 1 && (
          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <Label>Título da meta</Label>
              <Input {...register("title")} placeholder="Ex: Aumentar faturamento" />
              {errors.title && <p className="text-xs text-destructive">{errors.title.message}</p>}
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <Label>Departamento</Label>
                <Combobox
                  options={departments.map(d => ({ value: d.id, label: d.name }))}
                  value={watch("department_id") || undefined}
                  onChange={(v) => setValue("department_id", v ?? "")}
                  placeholder="Selecionar..."
                  searchPlaceholder="Buscar departamento..."
                  emptyText="Nenhum departamento encontrado."
                />
                {errors.department_id && <p className="text-xs text-destructive">{errors.department_id.message}</p>}
              </div>

              <div className="space-y-1.5">
                <Label>Responsável (opcional)</Label>
                <Combobox
                  options={[
                    { value: "__none__", label: "Nenhum" },
                    ...(colabs ?? []).map((c: Record<string, unknown>) => ({
                      value: c.user_id as string,
                      label: c.name as string,
                    })),
                  ]}
                  value={watch("responsible_user_id") ?? "__none__"}
                  onChange={(v) => setValue("responsible_user_id", !v || v === "__none__" ? undefined : v)}
                  placeholder="Selecionar..."
                  searchPlaceholder="Buscar pessoa..."
                  emptyText="Nenhuma pessoa encontrada."
                />
              </div>
            </div>

            <div className="grid grid-cols-3 gap-3">
              <div className="space-y-1.5">
                <Label className="inline-flex items-center gap-1">
                  Objetivo
                  <HelpTip>
                    <b>Aumentar</b> — quanto maior o realizado, melhor (ex: faturamento, chamados atendidos).
                    <br /><b>Diminuir</b> — quanto menor, melhor (ex: custos, turnover, tempo de atendimento).
                  </HelpTip>
                </Label>
                <Select defaultValue={goalToEdit?.objective ?? "increase"} onValueChange={(v) => setValue("objective", v as FormData["objective"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="increase">Aumentar</SelectItem>
                    <SelectItem value="decrease">Diminuir</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label className="inline-flex items-center gap-1">
                  Cálculo acumulado
                  <HelpTip>
                    Como os meses se combinam no acumulado do ano:
                    <br /><b>Soma</b> — soma os meses (ex: vendas, chamados).
                    <br /><b>Média</b> — média dos meses (ex: uptime, satisfação).
                    <br /><b>Subtração</b> — soma, para metas de redução.
                    <br /><b>Repetir</b> — usa o último valor lançado (ex: saldo, headcount).
                  </HelpTip>
                </Label>
                <Select defaultValue={goalToEdit?.calculation_type ?? "sum"} onValueChange={(v) => setValue("calculation_type", v as FormData["calculation_type"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="sum">Soma</SelectItem>
                    <SelectItem value="subtraction">Subtração</SelectItem>
                    <SelectItem value="average">Média</SelectItem>
                    <SelectItem value="repeat">Repetir</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label>Tipo de resultado</Label>
                <Select defaultValue={goalToEdit?.result_type ?? "value"} onValueChange={(v) => setValue("result_type", v as FormData["result_type"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="currency">Moeda (R$)</SelectItem>
                    <SelectItem value="percentage">Percentual (%)</SelectItem>
                    <SelectItem value="value">Valor numérico</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <Label className="inline-flex items-center gap-1">
                  Peso no departamento (%)
                  <HelpTip>Quanto esta meta vale dentro do departamento. A soma dos pesos das metas do departamento deve fechar 100%.</HelpTip>
                </Label>
                <Input type="number" step="0.01" {...register("weight")} placeholder="Ex: 25" />
                {errors.weight && <p className="text-xs text-destructive">{errors.weight.message}</p>}
              </div>
              <div className="space-y-1.5">
                <Label className="inline-flex items-center gap-1">
                  Valor alvo total (anual)
                  <HelpTip>A meta para o ano inteiro. É o ponto de <b>100%</b> da nota de atingimento.</HelpTip>
                </Label>
                <Input type="number" step="any" {...register("target_value")} placeholder="Ex: 120" />
                {errors.target_value && <p className="text-xs text-destructive">{errors.target_value.message}</p>}
              </div>
            </div>

            <div className="space-y-1.5">
              <Label className="inline-flex items-center gap-1">
                Curva de nota (opcional)
                <HelpTip>
                  Régua que converte o realizado em nota. <b>100% = valor alvo</b>.
                  <br />Atingir o "Valor a 120%" dá nota 120 (teto); o "Valor a 80%" dá nota 80 (piso); abaixo disso a nota cai proporcionalmente.
                  <br />Útil quando o piso/teto não são 80%/120% do alvo (ex: uptime, que não passa de 100%).
                </HelpTip>
              </Label>
              <p className="text-xs text-muted-foreground">
                Os valores em cinza são os automáticos (80% / 100% / 120% do valor alvo) — deixe em branco para usá-los. Preencha apenas se quiser sobrescrever. O ponto de 100% é sempre o valor alvo total.
              </p>
              <div className="grid grid-cols-3 gap-3">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 80%</p>
                  <Input type="number" step="any" {...register("curve_v80")} placeholder={curvePlaceholder(80)} />
                </div>
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 100%</p>
                  <Input type="number" step="any" {...register("curve_v100")} placeholder={curvePlaceholder(100)} />
                </div>
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 120%</p>
                  <Input type="number" step="any" {...register("curve_v120")} placeholder={curvePlaceholder(120)} />
                </div>
              </div>
            </div>

            <DialogFooter>
              <Button type="button" variant="ghost" onClick={() => handleClose(false)}>Cancelar</Button>
              <Button type="button" onClick={handleSubmit(() => setStep(2))}>
                Próximo: Mensalização →
              </Button>
            </DialogFooter>
          </div>
        )}

        {step === 2 && (
          <div className="space-y-4 py-2">
            <div className="flex items-center justify-between">
              <p className="text-sm text-muted-foreground">
                Distribua o valor alvo pelos meses do ciclo.
              </p>
              <Button type="button" variant="outline" size="sm" onClick={distributeEqually}>
                Dividir igualmente
              </Button>
            </div>

            <div className="grid grid-cols-3 gap-3">
              {MONTHS.map((month, i) => (
                <div key={i} className="space-y-1">
                  <Label className="text-xs">{month}</Label>
                  <Input
                    type="number"
                    step="any"
                    value={plans[i]}
                    onChange={(e) => {
                      const newPlans = [...plans];
                      newPlans[i] = parseFloat(e.target.value) || 0;
                      setPlans(newPlans);
                    }}
                  />
                </div>
              ))}
            </div>

            <div className="flex items-center justify-between text-sm">
              <span className="text-muted-foreground">Total planejado:</span>
              <span className="font-medium">{plans.reduce((a, b) => a + b, 0).toLocaleString("pt-BR", { maximumFractionDigits: 2 })}</span>
            </div>

            <DialogFooter>
              <Button type="button" variant="ghost" onClick={() => setStep(1)}>← Voltar</Button>
              <Button onClick={handleSubmit((data) => mutation.mutate(data))} disabled={mutation.isPending}>
                {mutation.isPending ? "Salvando..." : isEdit ? "Salvar alterações" : "Criar Meta"}
              </Button>
            </DialogFooter>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
