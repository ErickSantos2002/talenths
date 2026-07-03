import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { BingoCard } from "./BingoCard";
import type { BingoCard as BingoCardType } from "@/types/bingo";

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  card: BingoCardType | null;
  numberPool: number;
  place?: number | null;
}

/** Mostra a cartela de um participante no estado atual (marcados/pendentes). */
export function BingoCardViewDialog({ open, onOpenChange, card, numberPool, place }: Props) {
  const marked = card?.marked ?? [];
  const pending = card ? card.numbers.filter((n) => !marked.includes(n)) : [];
  const missing = pending.length;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-xl">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            {card?.user_name ?? "Cartela"}
            {place != null && (
              <Badge className="bg-amber-500/15 text-amber-500 border-amber-500/30">{place}º lugar</Badge>
            )}
          </DialogTitle>
        </DialogHeader>
        {card && (
          <div className="space-y-3">
            <div className="text-sm text-muted-foreground">
              <b className="text-foreground">{marked.length}</b> / {card.numbers.length} marcados
              {place == null && (
                missing === 0
                  ? " · cartela cheia!"
                  : <> · faltam <b className="text-blue-400">{missing}</b>: <b>{pending.join(", ")}</b></>
              )}
            </div>
            <BingoCard
              layout={card.layout}
              marked={marked}
              pending={pending}
              numberPool={numberPool}
              name={card.user_name}
              code={card.code}
              showHeader
              variant="screen"
            />
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
