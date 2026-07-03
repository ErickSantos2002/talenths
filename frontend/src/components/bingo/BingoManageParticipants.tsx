import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { UserMinus, Trophy } from "lucide-react";
import { bingo as bingoApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import type { BingoCard } from "@/types/bingo";

interface Props {
  gameId: string;
  cards: BingoCard[];
  winnerCardIds: Set<string>;
  canRemove: boolean;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function BingoManageParticipants({ gameId, cards, winnerCardIds, canRemove, open, onOpenChange }: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [removing, setRemoving] = useState<BingoCard | null>(null);

  const mutation = useMutation({
    mutationFn: (cardId: string) => bingoApi.removeCard(gameId, cardId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bingo-game", gameId] });
      toast({ title: "Participante removido", description: "As outras cartelas continuam as mesmas." });
      setRemoving(null);
    },
    onError: (e: Error) => toast({ title: "Não foi possível remover", description: e.message, variant: "destructive" }),
  });

  const sorted = [...cards].sort((a, b) => (a.user_name ?? "").localeCompare(b.user_name ?? ""));

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Participantes ({cards.length})</DialogTitle>
          </DialogHeader>
          <p className="text-xs text-muted-foreground -mt-1">
            Remover uma pessoa apaga só a cartela dela — as demais continuam idênticas (não precisa reimprimir).
          </p>
          <ScrollArea className="h-72 rounded-md border">
            <div className="p-1">
              {sorted.map((c) => {
                const won = winnerCardIds.has(c.id);
                return (
                  <div key={c.id} className="flex items-center justify-between gap-2 rounded px-2 py-1.5 text-sm hover:bg-muted/40">
                    <span className="flex items-center gap-2">
                      <span>{c.user_name}</span>
                      <span className="font-mono text-[10px] text-muted-foreground">#{c.code}</span>
                    </span>
                    {won ? (
                      <span className="flex items-center gap-1 text-[11px] text-amber-500"><Trophy className="h-3.5 w-3.5" /> ganhou</span>
                    ) : canRemove ? (
                      <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive hover:text-destructive" onClick={() => setRemoving(c)}>
                        <UserMinus className="h-4 w-4" />
                      </Button>
                    ) : null}
                  </div>
                );
              })}
            </div>
          </ScrollArea>
        </DialogContent>
      </Dialog>

      <AlertDialog open={!!removing} onOpenChange={(o) => !o && setRemoving(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Remover {removing?.user_name}?</AlertDialogTitle>
            <AlertDialogDescription>
              A cartela desta pessoa (#{removing?.code}) será removida do jogo. As outras cartelas continuam as mesmas.
              Esta ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(e) => { e.preventDefault(); if (removing) mutation.mutate(removing.id); }}
              disabled={mutation.isPending}
            >
              {mutation.isPending ? "Removendo..." : "Remover"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
