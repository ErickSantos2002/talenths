import { useQuery } from "@tanstack/react-query";
import { bingo as bingoApi } from "@/lib/api";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { Printer } from "lucide-react";
import { BingoCard } from "./BingoCard";
import type { BingoCard as BingoCardType } from "@/types/bingo";

const PRINT_CSS = `
@media print {
  @page { size: A4 landscape; margin: 8mm; }
  body * { visibility: hidden !important; }
  #bingo-print, #bingo-print * { visibility: visible !important; }
  #bingo-print { position: absolute; left: 0; top: 0; width: 100%; }
  .bingo-page { page-break-after: always; }
  .bingo-page:last-child { page-break-after: auto; }
}
`;

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}

export function BingoPrintSheet({ gameId, open, onClose }: { gameId: string; open: boolean; onClose: () => void }) {
  const { data: detail, isLoading } = useQuery({
    queryKey: ["bingo-game", gameId],
    queryFn: () => bingoApi.getGame(gameId),
    enabled: open,
  });

  const pages = chunk<BingoCardType>(detail?.cards ?? [], 9);
  const pool = detail?.game.number_pool;

  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="max-w-[95vw] max-h-[92vh] overflow-auto">
        <style>{PRINT_CSS}</style>
        <DialogHeader className="flex-row items-center justify-between">
          <DialogTitle>Imprimir cartelas — {detail?.game.name}</DialogTitle>
          <Button onClick={() => window.print()} disabled={isLoading || pages.length === 0}>
            <Printer className="h-4 w-4 mr-1" /> Imprimir
          </Button>
        </DialogHeader>

        {isLoading ? (
          <Skeleton className="h-64 w-full" />
        ) : (
          <div id="bingo-print" className="space-y-6">
            {pages.map((cards, pi) => (
              <div key={pi} className="bingo-page rounded-lg bg-white p-4 text-[#1c2430]">
                <div className="mb-3 text-center">
                  <div className="text-base font-extrabold text-[#0f2a63]">🎯 {detail?.game.name}</div>
                  <div className="text-[11px] text-[#6b7688]">
                    Monte de 1 a {pool} · marque quando seu número for sorteado · cartela cheia (20 números) vence
                  </div>
                </div>
                <div className="grid grid-cols-3 gap-3">
                  {cards.map((c) => (
                    <BingoCard
                      key={c.id}
                      layout={c.layout}
                      numberPool={pool}
                      name={c.user_name}
                      code={c.code}
                      showHeader
                      variant="print"
                    />
                  ))}
                </div>
                <div className="mt-3 text-center text-[9px] text-[#9aa4b4]">
                  TalentHS · Folha {pi + 1} de {pages.length}
                </div>
              </div>
            ))}
            {pages.length === 0 && <p className="text-center text-muted-foreground py-8">Este jogo não tem cartelas.</p>}
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
