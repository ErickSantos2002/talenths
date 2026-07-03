import { useEffect, useRef, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { bingo as bingoApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { X, Play, Pause, Dices } from "lucide-react";
import { BingoTiebreakDialog } from "./BingoTiebreakDialog";

const AUTO_MS = 5000;

export function BingoLiveGame({ gameId, onClose }: { gameId: string; onClose: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [auto, setAuto] = useState(false);
  const [winnerModal, setWinnerModal] = useState<{ user_name?: string; place: number } | null>(null);
  const autoTimer = useRef<ReturnType<typeof setInterval> | null>(null);

  const { data: detail, isLoading } = useQuery({
    queryKey: ["bingo-game", gameId],
    queryFn: () => bingoApi.getGame(gameId),
    refetchInterval: 2000,
  });

  const invalidate = () => queryClient.invalidateQueries({ queryKey: ["bingo-game", gameId] });

  const startMutation = useMutation({
    mutationFn: () => bingoApi.start(gameId),
    onSuccess: invalidate,
    onError: (e: Error) => toast({ title: "Erro ao iniciar", description: e.message, variant: "destructive" }),
  });

  const drawMutation = useMutation({
    mutationFn: () => bingoApi.draw(gameId),
    onSuccess: (r) => {
      invalidate();
      if (r.tiebreak) {
        setAuto(false);
      } else if (r.winner) {
        setAuto(false);
        setWinnerModal(r.winner);
      }
    },
    onError: () => setAuto(false),
  });

  const game = detail?.game;
  const pool = game?.number_pool ?? 30;
  const drawn = new Set((detail?.draws ?? []).map((d) => d.number));
  const lastNumber = detail?.draws?.length ? detail.draws[detail.draws.length - 1].number : null;
  const pending = game?.pending_tiebreak ?? null;
  const nameOfCard = (cardId: string) => detail?.cards.find((c) => c.id === cardId)?.user_name ?? "—";

  // Modo automático: sorteia sozinho enquanto rodando e sem desempate pendente.
  useEffect(() => {
    if (autoTimer.current) { clearInterval(autoTimer.current); autoTimer.current = null; }
    if (auto && game?.status === "running" && !pending) {
      autoTimer.current = setInterval(() => {
        if (!drawMutation.isPending) drawMutation.mutate();
      }, AUTO_MS);
    }
    return () => { if (autoTimer.current) clearInterval(autoTimer.current); };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [auto, game?.status, pending]);

  const near1 = (detail?.near ?? []).filter((n) => n.missing === 1);
  const near2 = (detail?.near ?? []).filter((n) => n.missing === 2);
  const medal = (place: number) => (place === 1 ? "🥇" : place === 2 ? "🥈" : place === 3 ? "🥉" : `${place}º`);

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-auto bg-black/70 p-4">
      <div className="w-full max-w-5xl rounded-2xl border bg-card p-5" onClick={(e) => e.stopPropagation()}>
        <div className="mb-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Dices className="h-5 w-5 text-primary" />
            <h2 className="text-lg font-bold">{game?.name ?? "Bingo"}</h2>
            {game && (
              <Badge variant={game.status === "running" ? "default" : "secondary"}>
                {game.status === "running" ? "Em andamento" : game.status === "draft" ? "Rascunho"
                  : game.status === "finished" ? "Encerrado" : "Cancelado"}
              </Badge>
            )}
            {game && <Badge variant="outline">Ganhadores: {detail?.winners.length ?? 0} / {game.winners_target}</Badge>}
          </div>
          <Button variant="ghost" size="icon" onClick={onClose}><X className="h-5 w-5" /></Button>
        </div>

        {isLoading || !game ? (
          <Skeleton className="h-64 w-full" />
        ) : (
          <div className="grid gap-4 md:grid-cols-[1.6fr_1fr]">
            {/* Coluna principal */}
            <div className="rounded-xl border p-4">
              {game.status === "draft" ? (
                <div className="flex flex-col items-center gap-3 py-10">
                  <p className="text-muted-foreground">O jogo ainda não começou.</p>
                  <Button onClick={() => startMutation.mutate()} disabled={startMutation.isPending}>
                    <Play className="h-4 w-4 mr-1" /> Iniciar jogo
                  </Button>
                </div>
              ) : (
                <>
                  <div className="flex flex-col items-center gap-3 py-3">
                    <div
                      key={lastNumber ?? "none"}
                      className="flex h-32 w-32 items-center justify-center rounded-full text-5xl font-black text-white animate-in zoom-in-50"
                      style={{ background: "radial-gradient(circle at 35% 30%, #60a5fa, #2563eb 60%, #1e3a8a)", boxShadow: "0 12px 30px #2563eb55" }}
                    >
                      {lastNumber ?? "—"}
                    </div>
                    {game.status === "running" && (
                      <div className="flex gap-2">
                        <Button onClick={() => drawMutation.mutate()} disabled={drawMutation.isPending || !!pending}>
                          🎰 Girar próximo
                        </Button>
                        <Button variant="outline" onClick={() => setAuto((a) => !a)} disabled={!!pending}>
                          {auto ? <><Pause className="h-4 w-4 mr-1" /> Parar auto</> : <><Play className="h-4 w-4 mr-1" /> Auto</>}
                        </Button>
                      </div>
                    )}
                    {game.status === "finished" && <p className="font-semibold text-primary">Jogo encerrado 🎉</p>}
                  </div>

                  <p className="mt-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-muted-foreground">
                    Números (1–{pool}) · {drawn.size} sorteados
                  </p>
                  <div className="grid grid-cols-10 gap-1.5">
                    {Array.from({ length: pool }, (_, i) => i + 1).map((n) => (
                      <div
                        key={n}
                        className={`aspect-square flex items-center justify-center rounded-md text-xs font-bold ${
                          drawn.has(n) ? "bg-[#13233f] border border-[#2b6fe0] text-[#7fb0ff]"
                            : "bg-[#0c1526] border border-[#1e2c44] text-[#3f5170]"}`}
                      >
                        {n}
                      </div>
                    ))}
                  </div>
                </>
              )}
            </div>

            {/* Sidebar */}
            <div className="space-y-3">
              <div className="rounded-xl border p-3">
                <h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">⚡ Quase lá</h4>
                {near1.length === 0 && near2.length === 0 && (
                  <p className="text-sm text-muted-foreground">Ninguém perto ainda.</p>
                )}
                {near1.map((n) => (
                  <div key={n.card_id} className="flex items-center justify-between py-1 text-sm">
                    <span className="font-medium">{n.user_name}</span>
                    <Badge className="bg-amber-500/15 text-amber-500 border-amber-500/30">falta 1!</Badge>
                  </div>
                ))}
                {near2.map((n) => (
                  <div key={n.card_id} className="flex items-center justify-between py-1 text-sm">
                    <span>{n.user_name}</span>
                    <Badge variant="outline" className="text-blue-400 border-blue-500/40">faltam 2</Badge>
                  </div>
                ))}
              </div>

              <div className="rounded-xl border p-3">
                <h4 className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">🏆 Ganhadores</h4>
                {(detail?.winners.length ?? 0) === 0 && <p className="text-sm text-muted-foreground">Ainda ninguém.</p>}
                {(detail?.winners ?? []).map((w) => (
                  <div key={w.card_id} className="flex items-center gap-2 py-1 text-sm">
                    <span className="text-base">{medal(w.place)}</span>
                    <span className="font-medium">{w.user_name}</span>
                    {w.by_tiebreak && <span className="text-[10px] text-muted-foreground">(desempate)</span>}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>

      {pending && (
        <BingoTiebreakDialog
          gameId={gameId}
          open={true}
          tied={pending.card_ids.map((cid) => ({ card_id: cid, name: nameOfCard(cid) }))}
          onResolved={invalidate}
        />
      )}

      <Dialog open={!!winnerModal} onOpenChange={(o) => !o && setWinnerModal(null)}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle className="text-center text-2xl">🎉 Parabéns!</DialogTitle>
          </DialogHeader>
          <div className="pb-2 text-center">
            <div className="my-2 text-5xl">{winnerModal ? medal(winnerModal.place) : ""}</div>
            <p className="text-lg font-bold text-primary">{winnerModal?.user_name}</p>
            <p className="text-sm text-muted-foreground">bateu a cartela — {winnerModal?.place}º lugar!</p>
            <Button className="mt-5" onClick={() => setWinnerModal(null)}>Continuar</Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
