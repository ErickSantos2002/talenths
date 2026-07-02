import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { Download, ArrowLeft } from "lucide-react";
import { bingo as bingoApi } from "@/lib/api";
import { generateBingoPdf } from "@/lib/bingoPdf";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { BingoCard } from "@/components/bingo/BingoCard";
import type { BingoCard as BingoCardType } from "@/types/bingo";

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}

export default function BingoPrintPage() {
  const { gameId } = useParams<{ gameId: string }>();
  const navigate = useNavigate();
  const { toast } = useToast();
  const [generating, setGenerating] = useState(false);

  const { data: detail, isLoading } = useQuery({
    queryKey: ["bingo-game", gameId],
    queryFn: () => bingoApi.getGame(gameId!),
    enabled: !!gameId,
  });

  const pages = chunk<BingoCardType>(detail?.cards ?? [], 9);
  const pool = detail?.game.number_pool;

  const downloadPdf = async () => {
    if (!detail) return;
    setGenerating(true);
    try {
      await generateBingoPdf(detail);
    } catch (e) {
      toast({ title: "Erro ao gerar o PDF", description: (e as Error).message, variant: "destructive" });
    } finally {
      setGenerating(false);
    }
  };

  return (
    <div className="min-h-screen bg-muted/40">
      <div className="sticky top-0 z-10 flex items-center justify-between border-b bg-background px-4 py-3">
        <Button variant="ghost" size="sm" onClick={() => { window.close(); setTimeout(() => navigate("/admin/bingo"), 120); }}>
          <ArrowLeft className="h-4 w-4 mr-1" /> Fechar
        </Button>
        <span className="text-sm text-muted-foreground">
          {detail ? `${detail.cards.length} cartela(s) · ${pages.length} folha(s)` : "Carregando..."}
        </span>
        <Button onClick={downloadPdf} disabled={isLoading || generating || pages.length === 0}>
          <Download className="h-4 w-4 mr-1" /> {generating ? "Gerando PDF..." : "Baixar cartelas (PDF)"}
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
