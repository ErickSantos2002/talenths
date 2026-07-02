import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Dices, Plus, Printer, Play, Trash2, Ban } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { bingo as bingoApi } from "@/lib/api";
import type { BingoGame } from "@/types/bingo";
import { CreateBingoGameDialog } from "@/components/bingo/CreateBingoGameDialog";

const STATUS: Record<string, { label: string; variant: "default" | "secondary" | "outline" }> = {
  draft: { label: "Rascunho", variant: "outline" },
  running: { label: "Em andamento", variant: "default" },
  finished: { label: "Encerrado", variant: "secondary" },
  cancelled: { label: "Cancelado", variant: "secondary" },
};

export default function BingoAdminPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [createOpen, setCreateOpen] = useState(false);
  const [openGameId, setOpenGameId] = useState<string | null>(null);
  const [deleting, setDeleting] = useState<BingoGame | null>(null);

  const { data: games, isLoading } = useQuery({ queryKey: ["bingo-games"], queryFn: bingoApi.listGames });

  const invalidate = () => queryClient.invalidateQueries({ queryKey: ["bingo-games"] });

  const cancelMutation = useMutation({
    mutationFn: (id: string) => bingoApi.cancel(id),
    onSuccess: () => { invalidate(); toast({ title: "Jogo cancelado" }); },
    onError: (e: Error) => toast({ title: "Erro ao cancelar", description: e.message, variant: "destructive" }),
  });
  const deleteMutation = useMutation({
    mutationFn: (id: string) => bingoApi.deleteGame(id),
    onSuccess: () => { invalidate(); toast({ title: "Jogo excluído" }); setDeleting(null); },
    onError: (e: Error) => toast({ title: "Erro ao excluir", description: e.message, variant: "destructive" }),
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <Dices className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Bingo</h1>
          </div>
          <Button onClick={() => setCreateOpen(true)}>
            <Plus className="h-4 w-4 mr-1" /> Novo jogo
          </Button>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-20 w-full" />)}</div>
        ) : !games || games.length === 0 ? (
          <div className="rounded-xl border border-dashed p-12 text-center">
            <Dices className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum jogo de bingo ainda.</p>
            <Button onClick={() => setCreateOpen(true)}><Plus className="h-4 w-4 mr-1" /> Criar o primeiro</Button>
          </div>
        ) : (
          <div className="space-y-3">
            {games.map((g) => {
              const st = STATUS[g.status] ?? STATUS.draft;
              return (
                <div key={g.id} className="flex flex-wrap items-center justify-between gap-3 rounded-xl border p-4">
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-semibold">{g.name}</span>
                      <Badge variant={st.variant} className="text-[10px] h-5">{st.label}</Badge>
                    </div>
                    <div className="text-xs text-muted-foreground mt-0.5">
                      Monte 1–{g.number_pool} · {g.winners_target} ganhador(es) · {g.participants ?? 0} participante(s)
                      {(g.draws ?? 0) > 0 && ` · ${g.draws} sorteado(s)`}
                      {(g.winners ?? 0) > 0 && ` · ${g.winners} ganharam`}
                    </div>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <Button size="sm" variant="outline" onClick={() => setOpenGameId(g.id)}>
                      <Play className="h-3.5 w-3.5 mr-1" /> Abrir
                    </Button>
                    <Button size="sm" variant="outline" onClick={() => toast({ title: "Impressão", description: "Disponível na próxima etapa." })}>
                      <Printer className="h-3.5 w-3.5 mr-1" /> Imprimir
                    </Button>
                    {g.status === "running" && (
                      <Button size="sm" variant="outline" className="text-amber-600" onClick={() => cancelMutation.mutate(g.id)}>
                        <Ban className="h-3.5 w-3.5 mr-1" /> Cancelar
                      </Button>
                    )}
                    {g.status !== "running" && (
                      <Button size="sm" variant="outline" className="text-destructive hover:text-destructive" onClick={() => setDeleting(g)}>
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <CreateBingoGameDialog open={createOpen} onOpenChange={setCreateOpen} onCreated={(id) => setOpenGameId(id)} />

      {openGameId && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60" onClick={() => setOpenGameId(null)}>
          <div className="rounded-xl border bg-card p-6" onClick={(e) => e.stopPropagation()}>
            <p className="text-sm text-muted-foreground">Tela do jogo — em construção (próxima etapa).</p>
            <Button className="mt-3" variant="outline" onClick={() => setOpenGameId(null)}>Fechar</Button>
          </div>
        </div>
      )}

      <AlertDialog open={!!deleting} onOpenChange={(o) => !o && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir "{deleting?.name}"?</AlertDialogTitle>
            <AlertDialogDescription>
              O jogo, as cartelas e todo o histórico serão removidos. Esta ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={(e) => { e.preventDefault(); if (deleting) deleteMutation.mutate(deleting.id); }}
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
}
