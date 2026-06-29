import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import type { Cycle } from "@/types/goals";

const schema = z.object({
  name: z.string().min(1, "Obrigatório"),
  start_date: z.string().min(1, "Obrigatório"),
  end_date: z.string().min(1, "Obrigatório"),
  min_curve_value: z.coerce.number().min(0).max(1),
  max_progress_value: z.coerce.number().min(1).max(2),
  status: z.enum(["draft", "active", "closed"]),
}).refine(d => d.end_date > d.start_date, {
  message: "Data final deve ser após a data inicial",
  path: ["end_date"],
});

type FormData = z.infer<typeof schema>;

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated?: (id: string) => void;
  cycle?: Cycle;
}

export function CreateCycleDialog({ open, onOpenChange, onCreated, cycle }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isEdit = !!cycle;

  const { register, handleSubmit, reset, setValue, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: cycle
      ? {
          name: cycle.name,
          start_date: cycle.start_date?.slice(0, 10) ?? "",
          end_date: cycle.end_date?.slice(0, 10) ?? "",
          min_curve_value: cycle.min_curve_value,
          max_progress_value: cycle.max_progress_value,
          status: cycle.status,
        }
      : {
          name: "",
          start_date: "",
          end_date: "",
          min_curve_value: 0.80,
          max_progress_value: 1.20,
          status: "active",
        },
  });

  const mutation = useMutation({
    mutationFn: (data: FormData) =>
      isEdit ? goalsApi.updateCycle(cycle!.id, data) : goalsApi.createCycle(data),
    onSuccess: (saved) => {
      queryClient.invalidateQueries({ queryKey: ["goal-cycles"] });
      toast({ title: isEdit ? "Ciclo atualizado" : "Ciclo criado com sucesso" });
      reset();
      onOpenChange(false);
      onCreated?.(saved.id);
    },
    onError: (err: Error) => toast({ title: isEdit ? "Erro ao atualizar ciclo" : "Erro ao criar ciclo", description: err.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>{isEdit ? "Editar Ciclo" : "Novo Ciclo de Metas"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit((d) => mutation.mutate(d))} className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Nome do ciclo</Label>
            <Input {...register("name")} placeholder="Ex: 2026 | Jan a Dez" />
            {errors.name && <p className="text-xs text-destructive">{errors.name.message}</p>}
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Data inicial</Label>
              <Input type="date" {...register("start_date")} />
              {errors.start_date && <p className="text-xs text-destructive">{errors.start_date.message}</p>}
            </div>
            <div className="space-y-1.5">
              <Label>Data final</Label>
              <Input type="date" {...register("end_date")} />
              {errors.end_date && <p className="text-xs text-destructive">{errors.end_date.message}</p>}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Curva mínima</Label>
              <Input type="number" step="0.01" {...register("min_curve_value")} placeholder="0.80" />
              <p className="text-xs text-muted-foreground">Ex: 0.80 = 80%</p>
            </div>
            <div className="space-y-1.5">
              <Label>Teto de progresso</Label>
              <Input type="number" step="0.01" {...register("max_progress_value")} placeholder="1.20" />
              <p className="text-xs text-muted-foreground">Ex: 1.20 = 120%</p>
            </div>
          </div>

          <div className="space-y-1.5">
            <Label>Status</Label>
            <Select defaultValue={cycle?.status ?? "active"} onValueChange={(v) => setValue("status", v as FormData["status"])}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="draft">Rascunho</SelectItem>
                <SelectItem value="active">Ativo</SelectItem>
                <SelectItem value="closed">Encerrado</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <DialogFooter>
            <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>
              Cancelar
            </Button>
            <Button type="submit" disabled={mutation.isPending}>
              {mutation.isPending ? "Salvando..." : isEdit ? "Salvar" : "Criar Ciclo"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
