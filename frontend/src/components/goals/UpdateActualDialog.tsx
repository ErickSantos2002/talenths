import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { MONTHS, formatGoalValue } from "@/types/goals";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  goalId: string;
  cycleId: string;
  month: number;
  currentValue: number | null;
  planned: number;
  resultType: string;
}

export function UpdateActualDialog({ open, onOpenChange, goalId, cycleId, month, currentValue, planned, resultType }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [value, setValue] = useState(currentValue?.toString() ?? "");
  const [comment, setComment] = useState("");

  const invalidate = () => {
    queryClient.invalidateQueries({ queryKey: ["goal-detail", goalId] });
    queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
  };

  const mutation = useMutation({
    mutationFn: () => goalsApi.updateActual(goalId, month, {
      actual_value: parseFloat(value),
      comment: comment.trim() || undefined,
    }),
    onSuccess: () => {
      invalidate();
      toast({ title: "Realizado atualizado" });
      onOpenChange(false);
    },
    onError: (err: Error) => toast({ title: "Erro ao atualizar", description: err.message, variant: "destructive" }),
  });

  const clearMutation = useMutation({
    mutationFn: () => goalsApi.clearActual(goalId, month),
    onSuccess: () => {
      invalidate();
      toast({ title: "Mês limpo" });
      onOpenChange(false);
    },
    onError: (err: Error) => toast({ title: "Erro ao limpar", description: err.message, variant: "destructive" }),
  });

  const isValid = value !== "" && !isNaN(parseFloat(value));
  const busy = mutation.isPending || clearMutation.isPending;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-sm">
        <DialogHeader>
          <DialogTitle>Atualizar {MONTHS[month - 1]}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Valor realizado</Label>
            <div className="flex items-center gap-2">
              <Input
                type="number"
                step="any"
                value={value}
                onChange={(e) => setValue(e.target.value)}
                placeholder="0"
                autoFocus
                className="flex-1"
              />
              <span className="text-sm text-muted-foreground whitespace-nowrap">
                / {formatGoalValue(planned, resultType)}
              </span>
            </div>
            <p className="text-xs text-muted-foreground">Planejado do mês: {formatGoalValue(planned, resultType)}</p>
          </div>
          <div className="space-y-1.5">
            <Label>Comentário (opcional)</Label>
            <Textarea
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="Contexto sobre o resultado..."
              rows={3}
              className="resize-none"
            />
          </div>
        </div>
        <DialogFooter className="flex-row justify-between sm:justify-between">
          {currentValue !== null ? (
            <Button variant="ghost" className="text-destructive hover:text-destructive" onClick={() => clearMutation.mutate()} disabled={busy}>
              Limpar mês
            </Button>
          ) : <span />}
          <div className="flex gap-2">
            <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
            <Button onClick={() => mutation.mutate()} disabled={!isValid || busy}>
              {mutation.isPending ? "Salvando..." : "Salvar"}
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
