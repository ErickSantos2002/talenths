import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { Printer, ArrowLeft } from "lucide-react";
import { bingo as bingoApi } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { BingoCard } from "@/components/bingo/BingoCard";
import type { BingoCard as BingoCardType } from "@/types/bingo";

const PRINT_CSS = `
@media print {
  @page { size: A4 landscape; margin: 8mm; }
  .no-print { display: none !important; }
  body { background: #fff !important; }
  .bingo-page { box-shadow: none !important; margin: 0 !important; border-radius: 0 !important; page-break-after: always; }
  .bingo-page:last-child { page-break-after: auto; }
}
`;

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}

export default function BingoPrintPage() {
  const { gameId } = useParams<{ gameId: string }>();
  const navigate = useNavigate();
  const { data: detail, isLoading } = useQuery({
    queryKey: ["bingo-game", gameId],
    queryFn: () => bingoApi.getGame(gameId!),
    enabled: !!gameId,
  });

  const pages = chunk<BingoCardType>(detail?.cards ?? [], 9);
  const pool = detail?.game.number_pool;

  return (
    <div className="min-h-screen bg-muted/40">
      <style>{PRINT_CSS}</style>

      <div className="no-print sticky top-0 z-10 flex items-center justify-between border-b bg-background px-4 py-3">
        <Button variant="ghost" size="sm" onClick={() => navigate(-1)}>
          <ArrowLeft className="h-4 w-4 mr-1" /> Voltar
        </Button>
        <span className="text-sm text-muted-foreground">
          {detail ? `${detail.cards.length} cartela(s) · ${pages.length} folha(s)` : "Carregando..."}
        </span>
        <Button onClick={() => window.print()} disabled={isLoading || pages.length === 0}>
          <Printer className="h-4 w-4 mr-1" /> Imprimir / Salvar PDF
        </Button>
      </div>

      <div className="mx-auto max-w-[1100px] space-y-6 p-6">
        {isLoading ? (
          <p className="text-center text-muted-foreground py-12">Carregando cartelas...</p>
        ) : pages.length === 0 ? (
          <p className="text-center text-muted-foreground py-12">Este jogo não tem cartelas.</p>
        ) : (
          pages.map((cards, pi) => (
            <div
              key={pi}
              className="bingo-page mx-auto bg-white text-[#1c2430] shadow-lg"
              style={{ aspectRatio: "297 / 210", padding: "18px 20px", display: "flex", flexDirection: "column" }}
            >
              <div className="mb-3 text-center">
                <div className="text-base font-extrabold text-[#0f2a63]">🎯 {detail?.game.name}</div>
                <div className="text-[11px] text-[#6b7688]">
                  Monte de 1 a {pool} · marque quando seu número for sorteado · cartela cheia (20 números) vence
                </div>
              </div>
              <div className="grid flex-1 grid-cols-3 grid-rows-3 gap-3">
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
              <div className="mt-2 text-center text-[9px] text-[#9aa4b4]">
                TalentHS · Folha {pi + 1} de {pages.length}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
