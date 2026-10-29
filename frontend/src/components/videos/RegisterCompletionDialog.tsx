import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { collaborators, videos } from "@/lib/api";
import { Combobox } from "@/components/Combobox";
import { Button } from "@/components/ui/button";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";

type Props = {
  videoId: string;
  open: boolean;
  // Pessoa já escolhida quando o RH vem pelo atalho de uma linha pendente.
  initialUserId?: string | null;
  // Quem já concluiu não pode ser registrado de novo.
  completedUserIds: string[];
  onOpenChange: (open: boolean) => void;
};

function todayISO(): string {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
}

export function RegisterCompletionDialog({ videoId, open, initialUserId, completedUserIds, onOpenChange }: Props) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const [userId, setUserId] = useState<string | undefined>();
  const [date, setDate] = useState(todayISO());

  useEffect(() => {
    if (open) {
      setUserId(initialUserId ?? undefined);
      setDate(todayISO());
    }
  }, [open, initialUserId]);

  const { data: people = [] } = useQuery({
    queryKey: ["collaborators", "active"],
    queryFn: () => collaborators.list(undefined, "active"),
    enabled: open,
  });
  const options = (people as Record<string, unknown>[])
    .filter((p) => !completedUserIds.includes(p.user_id as string))
    .map((p) => ({ value: p.user_id as string, label: p.name as string }))
    .sort((a, b) => a.label.localeCompare(b.label));

  const today = todayISO();
  const mutation = useMutation({
    mutationFn: () => videos.registerCompletion(videoId, userId!, date),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-videos"] });
      qc.invalidateQueries({ queryKey: ["admin-video", videoId] });
      toast({ title: "Conclusão registrada" });
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro ao registrar", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Registrar conclusão</DialogTitle>
          <DialogDescription>
            Para quem já assistiu a este vídeo antes do sistema. A pessoa fica como concluída na data
            informada, com a marca Registrado pelo RH.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-4">
          <div className="space-y-2">
            <Label>Colaborador</Label>
            <Combobox
              options={options}
              value={userId}
              onChange={setUserId}
              placeholder="Selecione um colaborador"
              searchPlaceholder="Buscar pessoa..."
              emptyText="Todos já concluíram."
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="completion-date">Data da conclusão</Label>
            <Input
              id="completion-date"
              type="date"
              value={date}
              max={today}
              onChange={(e) => setDate(e.target.value)}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={mutation.isPending}>
            Cancelar
          </Button>
          <Button
            onClick={() => mutation.mutate()}
            disabled={!userId || !date || date > today || mutation.isPending}
          >
            {mutation.isPending ? "Registrando..." : "Registrar conclusão"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
