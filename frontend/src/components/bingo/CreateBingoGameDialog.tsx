import { useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { bingo as bingoApi, collaborators as collaboratorsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCreated?: (id: string) => void;
}

export function CreateBingoGameDialog({ open, onOpenChange, onCreated }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [name, setName] = useState("");
  const [numberPool, setNumberPool] = useState("60");
  const [winnersTarget, setWinnersTarget] = useState("3");
  const [nearThreshold, setNearThreshold] = useState("2");
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [search, setSearch] = useState("");

  const { data: colabs } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaboratorsApi.list(),
    enabled: open,
  });

  const people = useMemo(
    () => (colabs ?? [])
      .map((c: Record<string, unknown>) => ({ user_id: c.user_id as string, name: (c.name as string) ?? "—" }))
      .filter((p) => p.user_id),
    [colabs],
  );
  const filtered = useMemo(
    () => people.filter((p) => p.name.toLowerCase().includes(search.trim().toLowerCase())),
    [people, search],
  );

  const toggle = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
  };

  const reset = () => {
    setName(""); setNumberPool("30"); setWinnersTarget("3"); setNearThreshold("2");
    setSelected(new Set()); setSearch("");
  };

  const winners = parseInt(winnersTarget) || 0;
  const canSubmit = name.trim() !== "" && selected.size >= 1 && winners >= 1 && winners <= selected.size;

  const mutation = useMutation({
    mutationFn: () => bingoApi.createGame({
      name: name.trim(),
      number_pool: parseInt(numberPool),
      winners_target: winners,
      near_threshold: parseInt(nearThreshold),
      participant_user_ids: [...selected],
    }),
    onSuccess: (game) => {
      queryClient.invalidateQueries({ queryKey: ["bingo-games"] });
      toast({ title: "Jogo criado", description: `${selected.size} cartela(s) gerada(s).` });
      reset();
      onOpenChange(false);
      onCreated?.(game.id);
    },
    onError: (err: Error) => toast({ title: "Erro ao criar jogo", description: err.message, variant: "destructive" }),
  });

  const handleClose = (next: boolean) => {
    if (!next) reset();
    onOpenChange(next);
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>Novo jogo de bingo</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Nome do jogo</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Ex: Confraternização 2026" />
          </div>

          <div className="grid grid-cols-3 gap-3">
            <div className="space-y-1.5">
              <Label>Monte de números</Label>
              <Select value={numberPool} onValueChange={setNumberPool}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="30">1 a 30</SelectItem>
                  <SelectItem value="60">1 a 60</SelectItem>
                  <SelectItem value="90">1 a 90</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Ganhadores</Label>
              <Input type="number" min={1} value={winnersTarget} onChange={(e) => setWinnersTarget(e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Avisar quando</Label>
              <Select value={nearThreshold} onValueChange={setNearThreshold}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="1">Faltando 1</SelectItem>
                  <SelectItem value="2">Faltando 1 e 2</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {parseInt(numberPool) === 30 ? (
            <p className="text-xs text-amber-600 dark:text-amber-400">
              ⚠️ Com monte de 30, é comum vários baterem a cartela juntos no fim (mais empates). Prefira <b>60</b> ou <b>90</b> para espalhar os números.
            </p>
          ) : (
            <p className="text-xs text-muted-foreground">
              Montes maiores espalham os números e reduzem a chance de empates no fim.
            </p>
          )}

          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <Label>Participantes</Label>
              <span className="text-xs text-muted-foreground">{selected.size} selecionado(s)</span>
            </div>
            <Input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Buscar pessoa..." />
            <ScrollArea className="h-48 rounded-md border">
              <div className="p-1">
                {filtered.map((p) => (
                  <label key={p.user_id} className="flex items-center gap-2 rounded px-2 py-1.5 text-sm cursor-pointer hover:bg-muted/50">
                    <Checkbox checked={selected.has(p.user_id)} onCheckedChange={() => toggle(p.user_id)} />
                    <span>{p.name}</span>
                  </label>
                ))}
                {filtered.length === 0 && <p className="text-sm text-muted-foreground text-center py-4">Nenhuma pessoa.</p>}
              </div>
            </ScrollArea>
            {winners > selected.size && selected.size > 0 && (
              <p className="text-xs text-destructive">O nº de ganhadores não pode ser maior que o de participantes.</p>
            )}
          </div>
        </div>
        <DialogFooter>
          <Button type="button" variant="ghost" onClick={() => handleClose(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!canSubmit || mutation.isPending}>
            {mutation.isPending ? "Gerando cartelas..." : "Criar jogo"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
