import { useState, useEffect } from "react";
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
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";

const goalSchema = z.object({
  department_id: z.string().min(1, "Obrigatório"),
  responsible_user_id: z.string().optional(),
  title: z.string().min(1, "Obrigatório"),
  objective: z.enum(["increase", "decrease"]),
  calculation_type: z.enum(["sum", "subtraction", "average", "repeat"]),
  result_type: z.enum(["currency", "percentage", "value"]),
  weight: z.coerce.number().min(0).max(100),
  target_value: z.coerce.number().min(0),
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
  const [distMode, setDistMode] = useState<"custom" | "equal" | "repeat">("custom");

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

  // Preenche os 12 meses conforme o modo de distribuição escolhido.
  // - "equal": divide o alvo igualmente (alvo ÷ 12 em cada mês; a soma fecha o alvo).
  // - "repeat": repete o valor alvo cheio em todos os meses.
  // - "custom": o usuário digita cada mês (não mexe).
  useEffect(() => {
    if (distMode === "custom") return;
    const val = parseFloat(String(targetValue)) || 0;
    if (distMode === "equal") {
      setPlans(Array(12).fill(parseFloat((val / 12).toFixed(4))));
    } else {
      setPlans(Array(12).fill(val));
    }
  }, [distMode, targetValue]);

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
      setDistMode("custom");
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
                <Label>Time</Label>
                <Combobox
                  options={departments.map(d => ({ value: d.id, label: d.name }))}
                  value={watch("department_id") || undefined}
                  onChange={(v) => setValue("department_id", v ?? "")}
                  placeholder="Selecionar..."
                  searchPlaceholder="Buscar time..."
                  emptyText="Nenhum time encontrado."
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
                <Select value={watch("objective")} onValueChange={(v) => setValue("objective", v as FormData["objective"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="increase">Aumentar valor</SelectItem>
                    <SelectItem value="decrease">Diminuir valor</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label className="inline-flex items-center gap-1">
                  Expressão de cálculo
                  <HelpTip>
                    Como os meses se combinam no acumulado do ano:
                    <br /><b>Soma</b> — soma os meses (ex: vendas, chamados).
                    <br /><b>Média</b> — média dos meses (ex: uptime, satisfação).
                    <br /><b>Subtração</b> — soma, para metas de redução.
                    <br /><b>Repetir</b> — usa o último valor lançado (ex: saldo, headcount).
                  </HelpTip>
                </Label>
                <Select value={watch("calculation_type")} onValueChange={(v) => setValue("calculation_type", v as FormData["calculation_type"])}>
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
                <Select value={watch("result_type")} onValueChange={(v) => setValue("result_type", v as FormData["result_type"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="currency">R$</SelectItem>
                    <SelectItem value="percentage">%</SelectItem>
                    <SelectItem value="value">Valor</SelectItem>
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
                  <HelpTip>A meta para o ano inteiro. É a referência do indicador "Do ano" (realizado ÷ alvo).</HelpTip>
                </Label>
                <Input type="number" step="any" {...register("target_value")} placeholder="Ex: 120" />
                {errors.target_value && <p className="text-xs text-destructive">{errors.target_value.message}</p>}
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
            <p className="text-sm text-muted-foreground">
              Distribua o valor alvo pelos meses do ciclo.
            </p>

            <RadioGroup
              value={distMode}
              onValueChange={(v) => setDistMode(v as typeof distMode)}
              className="gap-2"
            >
              <label className="flex items-start gap-2 text-sm cursor-pointer">
                <RadioGroupItem value="equal" className="mt-0.5" />
                <span>
                  Dividir igualmente entre os meses
                  <span className="block text-xs text-muted-foreground">Alvo ÷ 12 em cada mês (a soma fecha o valor alvo).</span>
                </span>
              </label>
              <label className="flex items-start gap-2 text-sm cursor-pointer">
                <RadioGroupItem value="repeat" className="mt-0.5" />
                <span>
                  Repetir o valor alvo em todos os meses
                  <span className="block text-xs text-muted-foreground">O valor alvo cheio em cada mês (ex.: meta de nível como NPS, headcount).</span>
                </span>
              </label>
              <label className="flex items-start gap-2 text-sm cursor-pointer">
                <RadioGroupItem value="custom" className="mt-0.5" />
                <span>
                  Personalizado
                  <span className="block text-xs text-muted-foreground">Você define o valor de cada mês manualmente.</span>
                </span>
              </label>
            </RadioGroup>

            <div className="grid grid-cols-3 gap-3">
              {MONTHS.map((month, i) => (
                <div key={i} className="space-y-1">
                  <Label className="text-xs">{month}</Label>
                  <Input
                    type="number"
                    step="any"
                    value={plans[i]}
                    disabled={distMode !== "custom"}
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
