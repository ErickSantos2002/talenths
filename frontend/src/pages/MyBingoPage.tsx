import { useEffect, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Dices } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { bingo as bingoApi } from "@/lib/api";
import { BingoPlayerCard } from "@/components/bingo/BingoPlayerCard";

export default function MyBingoPage() {
  const [selected, setSelected] = useState<string | null>(null);
  const { data: games, isLoading } = useQuery({ queryKey: ["bingo-my-list"], queryFn: bingoApi.my });

  useEffect(() => {
    if (!selected && games && games.length > 0) setSelected(games[0].id);
  }, [games, selected]);

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <Dices className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Bingo</h1>
        </div>

        {isLoading ? (
          <Skeleton className="h-72 w-full" />
        ) : !games || games.length === 0 ? (
          <div className="rounded-xl border border-dashed p-12 text-center">
            <Dices className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Você não está em nenhum bingo no momento.</p>
          </div>
        ) : (
          <>
            {games.length > 1 && (
              <div className="flex flex-wrap gap-2">
                {games.map((g) => (
                  <button
                    key={g.id}
                    onClick={() => setSelected(g.id)}
                    className={`rounded-lg border px-3 py-1.5 text-sm transition-colors ${selected === g.id ? "border-primary bg-primary/10 text-primary" : "hover:bg-muted/50"}`}
                  >
                    {g.name}
                    <Badge variant="outline" className="ml-2 text-[10px] h-4">
                      {g.status === "running" ? "ao vivo" : "encerrado"}
                    </Badge>
                  </button>
                ))}
              </div>
            )}
            {selected && <BingoPlayerCard gameId={selected} />}
          </>
        )}
      </div>
    </AdminLayout>
  );
}
