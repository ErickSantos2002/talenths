import { useQuery } from "@tanstack/react-query";
import { bingo as bingoApi } from "@/lib/api";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { BingoCard } from "./BingoCard";

export function BingoPlayerCard({ gameId }: { gameId: string }) {
  const { data, isLoading } = useQuery({
    queryKey: ["bingo-my", gameId],
    queryFn: () => bingoApi.myGame(gameId),
    refetchInterval: 2000,
  });

  if (isLoading || !data) return <Skeleton className="h-72 w-full" />;

  const total = data.card.numbers.length; // 20
  const markedCount = data.marked.length;
  const pending = data.card.numbers.filter((n) => !data.marked.includes(n));
  const pct = Math.round((markedCount / total) * 100);

  return (
    <div className="space-y-4">
      <div className="rounded-2xl border p-4">
        <div className="mb-2 flex items-center justify-between">
          <div className="text-2xl font-black">
            <span className="text-blue-500">{markedCount}</span> / {total} marcados
          </div>
          {data.my_place != null ? (
            <Badge className="bg-amber-500/15 text-amber-500 border-amber-500/30 text-sm">
              🎉 Você ganhou — {data.my_place}º lugar!
            </Badge>
          ) : data.game.status === "finished" ? (
            <span className="text-sm text-muted-foreground">Jogo encerrado</span>
          ) : data.missing <= 2 && data.missing > 0 ? (
            <span className="text-sm font-bold text-amber-500">⚡ quase lá!</span>
          ) : null}
        </div>
        <div className="h-2.5 overflow-hidden rounded-full bg-muted">
          <div className="h-full bg-gradient-to-r from-blue-600 to-blue-400" style={{ width: `${pct}%` }} />
        </div>
        {data.my_place == null && data.game.status !== "finished" && (
          <p className="mt-2 text-sm text-muted-foreground">
            {data.missing === 0 ? "Cartela cheia!" : <>Faltam <b className="text-blue-400">{data.missing}</b> número(s): <b>{pending.join(", ")}</b></>}
          </p>
        )}
      </div>

      <div className="rounded-2xl border p-4">
        <BingoCard
          layout={data.card.layout}
          marked={data.marked}
          pending={pending}
          numberPool={data.game.number_pool}
          name="Minha cartela"
          code={data.card.code}
          showHeader
          variant="screen"
        />
        <div className="mt-3 flex gap-4 text-[11px] text-muted-foreground">
          <span className="flex items-center gap-1.5"><i className="inline-block h-3 w-3 rounded bg-blue-600" /> marcado</span>
          <span className="flex items-center gap-1.5"><i className="inline-block h-3 w-3 rounded border-[1.5px] border-blue-500" /> falta sair</span>
          <span className="flex items-center gap-1.5"><i className="inline-block h-3 w-3 rounded border border-dashed border-[#24334d]" /> vazio</span>
        </div>
      </div>
    </div>
  );
}
