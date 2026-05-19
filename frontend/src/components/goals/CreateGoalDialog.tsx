import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { goals as goalsApi, collaborators as collaboratorsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { MONTHS } from "@/types/goals";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";

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
}

export function CreateGoalDialog({ open, onOpenChange, cycleId, departments, defaultDepartmentId }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [step, setStep] = useState<1 | 2>(1);
  const [plans, setPlans] = useState<number[]>(Array(12).fill(0));

  const { data: colabs } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaboratorsApi.list(),
  });

  const { register, handleSubmit, watch, setValue, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(goalSchema),
    defaultValues: {
      department_id: defaultDepartmentId ?? "",
      objective: "increase",
      calculation_type: "sum",
      result_type: "value",
      weight: 0,
      target_value: 0,
    },
  });

  const targetValue = watch("target_value");

  const distributeEqually = () => {
    const val = parseFloat(String(targetValue)) || 0;
    setPlans(Array(12).fill(parseFloat((val / 12).toFixed(4))));
  };

  const mutation = useMutation({
    mutationFn: async (data: FormData) => {
      const goal = await goalsApi.create({ ...data, cycle_id: cycleId });
      const nonZeroPlans = plans.map((v, i) => ({ month: i + 1, planned_value: v })).filter(p => p.planned_value > 0);
      if (nonZeroPlans.length > 0) {
        await goalsApi.updatePlans(goal.id, plans.map((v, i) => ({ month: i + 1, planned_value: v })));
      }
      return goal;
    },
    onSuccess: (goal) => {
      queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
      if (goal.weight_warning) {
        toast({ title: "Meta criada", description: "Atenção: o total de pesos deste departamento não soma 100%." });
      } else {
        toast({ title: "Meta criada com sucesso" });
      }
      reset();
      setPlans(Array(12).fill(0));
      setStep(1);
      onOpenChange(false);
    },
    onError: (err: Error) => toast({ title: "Erro ao criar meta", description: err.message, variant: "destructive" }),
  });

  const handleClose = (open: boolean) => {
    if (!open) {
      reset();
      setPlans(Array(12).fill(0));
      setStep(1);
    }
    onOpenChange(open);
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <div className="flex items-center gap-3">
            <DialogTitle>Nova Meta</DialogTitle>
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
                <Select
                  defaultValue={defaultDepartmentId}
                  onValueChange={(v) => setValue("department_id", v)}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar..." />
                  </SelectTrigger>
                  <SelectContent>
                    {departments.map(d => (
                      <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {errors.department_id && <p className="text-xs text-destructive">{errors.department_id.message}</p>}
              </div>

              <div className="space-y-1.5">
                <Label>Responsável (opcional)</Label>
                <Select onValueChange={(v) => setValue("responsible_user_id", v === "__none__" ? undefined : v)}>
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar..." />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="__none__">Nenhum</SelectItem>
                    {(colabs ?? []).map((c: Record<string, unknown>) => (
                      <SelectItem key={c.user_id as string} value={c.user_id as string}>
                        {c.name as string}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="grid grid-cols-3 gap-3">
              <div className="space-y-1.5">
                <Label>Objetivo</Label>
                <Select defaultValue="increase" onValueChange={(v) => setValue("objective", v as FormData["objective"])}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="increase">Aumentar</SelectItem>
                    <SelectItem value="decrease">Diminuir</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label>Cálculo acumulado</Label>
                <Select defaultValue="sum" onValueChange={(v) => setValue("calculation_type", v as FormData["calculation_type"])}>
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
                <Select defaultValue="value" onValueChange={(v) => setValue("result_type", v as FormData["result_type"])}>
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
                <Label>Peso no departamento (%)</Label>
                <Input type="number" step="0.01" {...register("weight")} placeholder="Ex: 25" />
                {errors.weight && <p className="text-xs text-destructive">{errors.weight.message}</p>}
              </div>
              <div className="space-y-1.5">
                <Label>Valor alvo total (anual)</Label>
                <Input type="number" step="any" {...register("target_value")} placeholder="Ex: 120" />
                {errors.target_value && <p className="text-xs text-destructive">{errors.target_value.message}</p>}
              </div>
            </div>

            <div className="space-y-1.5">
              <Label>Curva de nota (opcional)</Label>
              <div className="grid grid-cols-3 gap-3">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 80%</p>
                  <Input type="number" step="any" {...register("curve_v80")} placeholder="—" />
                </div>
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 100%</p>
                  <Input type="number" step="any" {...register("curve_v100")} placeholder="—" />
                </div>
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Valor a 120%</p>
                  <Input type="number" step="any" {...register("curve_v120")} placeholder="—" />
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
                {mutation.isPending ? "Criando..." : "Criar Meta"}
              </Button>
            </DialogFooter>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
