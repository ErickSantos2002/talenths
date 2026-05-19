import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { evaluations as evalApi, goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { EVAL_STATUS_LABELS } from "@/types/evaluations";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

const schema = z.object({
  name: z.string().min(1, "Obrigatório"),
  management_cycle_id: z.string().optional(),
  status: z.string(),
  eval_start: z.string().optional(),
  eval_end: z.string().optional(),
  calibration_start: z.string().optional(),
  calibration_end: z.string().optional(),
  feedback_start: z.string().optional(),
  feedback_end: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated?: (id: string) => void;
}

export function CreateEvalCycleDialog({ open, onOpenChange, onCreated }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: goalCycles } = useQuery({
    queryKey: ["goal-cycles"],
    queryFn: goalsApi.listCycles,
  });

  const { register, handleSubmit, reset, setValue, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: { name: "", status: "draft" },
  });

  const mutation = useMutation({
    mutationFn: (data: FormData) => evalApi.createCycle({
      name: data.name,
      management_cycle_id: data.management_cycle_id || undefined,
      status: data.status,
      eval_start: data.eval_start || undefined,
      eval_end: data.eval_end || undefined,
      calibration_start: data.calibration_start || undefined,
      calibration_end: data.calibration_end || undefined,
      feedback_start: data.feedback_start || undefined,
      feedback_end: data.feedback_end || undefined,
    } as Parameters<typeof evalApi.createCycle>[0]),
    onSuccess: (cycle) => {
      queryClient.invalidateQueries({ queryKey: ["eval-cycles"] });
      toast({ title: "Ciclo de avaliação criado" });
      reset();
      onOpenChange(false);
      onCreated?.(cycle.id);
    },
    onError: (err: Error) => toast({ title: "Erro ao criar ciclo", description: err.message, variant: "destructive" }),
  });

  const stages = [
    { key: "eval",         label: "Avaliação",   start: "eval_start",         end: "eval_end" },
    { key: "calibration",  label: "Calibragem",  start: "calibration_start",  end: "calibration_end" },
    { key: "feedback",     label: "Feedback",    start: "feedback_start",     end: "feedback_end" },
  ];

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Novo Ciclo de Avaliação</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit((d) => mutation.mutate(d))} className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Nome do ciclo</Label>
            <Input {...register("name")} placeholder="Ex: Avaliação 2026 — 1º Semestre" />
            {errors.name && <p className="text-xs text-destructive">{errors.name.message}</p>}
          </div>

          <div className="space-y-1.5">
            <Label>Vincular ao ciclo de metas (opcional)</Label>
            <Select onValueChange={(v) => setValue("management_cycle_id", v === "__none__" ? undefined : v)}>
              <SelectTrigger><SelectValue placeholder="Nenhum" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="__none__">Nenhum</SelectItem>
                {(goalCycles ?? []).map(c => (
                  <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            <p className="text-xs text-muted-foreground">Usado para calcular o eixo X do 9Box automaticamente.</p>
          </div>

          <div className="space-y-1.5">
            <Label>Status inicial</Label>
            <Select defaultValue="draft" onValueChange={(v) => setValue("status", v)}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                {Object.entries(EVAL_STATUS_LABELS).map(([value, label]) => (
                  <SelectItem key={value} value={value}>{label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-3">
            <Label>Datas das etapas (opcional)</Label>
            {stages.map(s => (
              <div key={s.key} className="grid grid-cols-2 gap-2">
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground">{s.label} — Início</p>
                  <Input type="date" {...register(s.start as keyof FormData)} />
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground">{s.label} — Fim</p>
                  <Input type="date" {...register(s.end as keyof FormData)} />
                </div>
              </div>
            ))}
          </div>

          <DialogFooter>
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
            <Button type="submit" disabled={mutation.isPending}>
              {mutation.isPending ? "Criando..." : "Criar Ciclo"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
