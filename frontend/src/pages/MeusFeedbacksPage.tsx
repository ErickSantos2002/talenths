import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { feedbacks } from "@/lib/api";
import type { FeedbackRequest } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { MessageSquare, Star } from "lucide-react";

function StarPicker({ value, onChange }: { value: number; onChange: (v: number) => void }) {
  const [hovered, setHovered] = useState(0);
  return (
    <div className="flex gap-1">
      {[1, 2, 3, 4, 5].map((i) => (
        <button
          key={i}
          type="button"
          onMouseEnter={() => setHovered(i)}
          onMouseLeave={() => setHovered(0)}
          onClick={() => onChange(i)}
          className="focus:outline-none"
        >
          <Star
            className={`h-7 w-7 transition-colors ${
              i <= (hovered || value)
                ? "fill-yellow-400 text-yellow-400"
                : "text-muted-foreground"
            }`}
          />
        </button>
      ))}
    </div>
  );
}

function StarDisplay({ rating }: { rating: number }) {
  return (
    <span className="flex gap-0.5">
      {[1, 2, 3, 4, 5].map((i) => (
        <Star
          key={i}
          className={`h-4 w-4 ${i <= rating ? "fill-yellow-400 text-yellow-400" : "text-muted-foreground"}`}
        />
      ))}
    </span>
  );
}

export default function MeusFeedbacksPage() {
  const qc = useQueryClient();
  const { toast } = useToast();

  const [respondTarget, setRespondTarget] = useState<FeedbackRequest | null>(null);
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState("");

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["my-feedbacks"],
    queryFn: () => feedbacks.listMy(),
  });

  const respondMut = useMutation({
    mutationFn: ({ id, rating, comment }: { id: string; rating: number; comment: string }) =>
      feedbacks.respond(id, { rating, comment: comment || undefined }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["my-feedbacks"] });
      setRespondTarget(null);
      setRating(0);
      setComment("");
      toast({ title: "Resposta enviada" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  function openRespond(item: FeedbackRequest) {
    setRespondTarget(item);
    setRating(item.my_rating ?? 0);
    setComment(item.my_comment ?? "");
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <MessageSquare className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Feedbacks</h1>
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}

        {!isLoading && list.length === 0 && (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <MessageSquare className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum feedback recebido ainda.</p>
          </div>
        )}

        <div className="space-y-3">
          {list.map((item: FeedbackRequest) => (
            <Card key={item.id} className="hover:shadow-md hover:border-primary/20 transition-all">
              <CardContent className="p-4 space-y-3">
                <div className="flex items-start justify-between gap-3">
                  <div className="space-y-1 flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="font-medium">{item.title}</span>
                      {item.has_responded ? (
                        <Badge className="bg-emerald-500/15 text-emerald-400 border-emerald-500/20 border-0">
                          Respondido
                        </Badge>
                      ) : (
                        <Badge className="bg-amber-500/15 text-amber-400 border-amber-500/20 border-0">
                          Pendente
                        </Badge>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground">{item.question}</p>
                    <p className="text-xs text-muted-foreground">
                      Enviado por {item.created_by_name} ·{" "}
                      {new Date(item.created_at).toLocaleDateString("pt-BR")}
                    </p>
                  </div>
                  {!item.has_responded && (
                    <Button size="sm" onClick={() => openRespond(item)}>
                      Responder
                    </Button>
                  )}
                </div>

                {item.has_responded && item.my_rating != null && (
                  <div className="rounded-md bg-muted/50 p-3 space-y-1">
                    <StarDisplay rating={item.my_rating} />
                    {item.my_comment && (
                      <p className="text-sm text-muted-foreground">{item.my_comment}</p>
                    )}
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <Dialog open={!!respondTarget} onOpenChange={(open) => !open && setRespondTarget(null)}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>{respondTarget?.title}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <p className="text-sm text-muted-foreground">{respondTarget?.question}</p>
            <div className="space-y-1.5">
              <span className="text-sm font-medium">Avaliação</span>
              <StarPicker value={rating} onChange={setRating} />
            </div>
            <div className="space-y-1.5">
              <span className="text-sm font-medium">Comentário (opcional)</span>
              <Textarea
                value={comment}
                onChange={(e) => setComment(e.target.value)}
                placeholder="Deixe um comentário..."
                rows={3}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setRespondTarget(null)}>Cancelar</Button>
            <Button
              disabled={rating === 0 || respondMut.isPending}
              onClick={() => respondMut.mutate({ id: respondTarget!.id, rating, comment })}
            >
              Enviar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
