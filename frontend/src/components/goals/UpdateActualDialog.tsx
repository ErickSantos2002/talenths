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
  resultType: string;
}

export function UpdateActualDialog({ open, onOpenChange, goalId, cycleId, month, currentValue, resultType }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [value, setValue] = useState(currentValue?.toString() ?? "");
  const [comment, setComment] = useState("");

  const mutation = useMutation({
    mutationFn: () => goalsApi.updateActual(goalId, month, {
      actual_value: parseFloat(value),
      comment: comment.trim() || undefined,
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goal-detail", goalId] });
      queryClient.invalidateQueries({ queryKey: ["goals-overview", cycleId] });
      toast({ title: "Realizado atualizado" });
      onOpenChange(false);
    },
    onError: (err: Error) => toast({ title: "Erro ao atualizar", description: err.message, variant: "destructive" }),
  });

  const isValid = value !== "" && !isNaN(parseFloat(value));

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-sm">
        <DialogHeader>
          <DialogTitle>Atualizar {MONTHS[month - 1]}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          {currentValue !== null && (
            <p className="text-sm text-muted-foreground">
              Valor atual: <span className="font-medium text-foreground">{formatGoalValue(currentValue, resultType)}</span>
            </p>
          )}
          <div className="space-y-1.5">
            <Label>Valor realizado</Label>
            <Input
              type="number"
              step="any"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              placeholder="Ex: 12.5"
              autoFocus
            />
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
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!isValid || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
