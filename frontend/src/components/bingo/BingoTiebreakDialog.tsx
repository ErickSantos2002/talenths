import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { bingo as bingoApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import type { TiebreakResult } from "@/types/bingo";

interface Props {
  gameId: string;
  open: boolean;
  tied: { card_id: string; name: string }[];
  onResolved: () => void;
}

export function BingoTiebreakDialog({ gameId, open, tied, onResolved }: Props) {
  const { toast } = useToast();
  const [result, setResult] = useState<TiebreakResult | null>(null);

  const finalRoll = (cardId: string) => {
    const rolls = (result?.rolls ?? []).filter((r) => r.card_id === cardId);
    return rolls.length ? rolls[rolls.length - 1].roll : null;
  };
  const placeOf = (cardId: string) => result?.placed.find((p) => p.card_id === cardId)?.place ?? null;

  const mutation = useMutation({
    mutationFn: () => bingoApi.tiebreak(gameId),
    onSuccess: (r) => setResult(r),
    onError: (e: Error) => toast({ title: "Erro no desempate", description: e.message, variant: "destructive" }),
  });

  const close = () => { setResult(null); onResolved(); };

  return (
    <Dialog open={open} onOpenChange={(o) => { if (!o && result) close(); }}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>🎲 Desempate</DialogTitle>
        </DialogHeader>
        <div className="py-2 text-center">
          <p className="text-sm text-muted-foreground mb-4">
            {tied.length} participantes bateram no mesmo número. Role o d20 — maior valor leva o lugar melhor
            (empate no dado rola de novo automaticamente).
          </p>
          <div className="flex flex-wrap items-stretch justify-center gap-3">
            {tied.map((t) => {
              const roll = finalRoll(t.card_id);
              const place = placeOf(t.card_id);
              return (
                <div
                  key={t.card_id}
                  className={`flex-1 min-w-[130px] rounded-xl border p-4 ${place === 1 ? "border-amber-400 bg-amber-400/10" : "bg-card"}`}
                >
                  <div className="font-semibold text-sm mb-2">{t.name}</div>
                  <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-lg bg-blue-600 text-2xl font-black text-white">
                    {roll ?? "?"}
                  </div>
                  {place != null && (
                    <div className="mt-2 text-xs font-bold">
                      {place}º lugar
                    </div>
                  )}
                  {result && place == null && (
                    <div className="mt-2 text-xs text-muted-foreground">sem prêmio</div>
                  )}
                </div>
              );
            })}
          </div>

          <div className="mt-5">
            {!result ? (
              <Button onClick={() => mutation.mutate()} disabled={mutation.isPending}>
                {mutation.isPending ? "Rolando..." : "🎲 Rolar d20"}
              </Button>
            ) : (
              <Button onClick={close}>Continuar</Button>
            )}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
