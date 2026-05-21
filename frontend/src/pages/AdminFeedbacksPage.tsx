import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { feedbacks, departments, collaborators } from "@/lib/api";
import type { FeedbackRequest, FeedbackResponse } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import { useToast } from "@/hooks/use-toast";
import { MessageSquare, Plus, Star } from "lucide-react";

type CreateForm = {
  title: string;
  question: string;
  target_type: string;
  target_department_id: string;
  target_user_id: string;
};

const emptyForm: CreateForm = {
  title: "",
  question: "",
  target_type: "all",
  target_department_id: "",
  target_user_id: "",
};

function StarRating({ rating }: { rating: number }) {
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

export default function AdminFeedbacksPage() {
  const qc = useQueryClient();
  const { toast } = useToast();

  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState<CreateForm>(emptyForm);
  const [selectedFeedback, setSelectedFeedback] = useState<FeedbackRequest | null>(null);

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["admin-feedbacks"],
    queryFn: () => feedbacks.list(),
  });

  const { data: deptList = [] } = useQuery({
    queryKey: ["departments"],
    queryFn: () => departments.list(),
    enabled: form.target_type === "department",
  });

  const { data: collabList = [] } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaborators.list(),
    enabled: form.target_type === "individual",
  });

  const { data: responses = [], isFetching: loadingResponses } = useQuery({
    queryKey: ["feedback-responses", selectedFeedback?.id],
    queryFn: () => feedbacks.getResponses(selectedFeedback!.id),
    enabled: !!selectedFeedback,
  });

  const createMut = useMutation({
    mutationFn: (data: typeof emptyForm) =>
      feedbacks.create({
        title: data.title,
        question: data.question,
        target_type: data.target_type,
        target_department_id: data.target_type === "department" ? data.target_department_id || undefined : undefined,
        target_user_id: data.target_type === "individual" ? data.target_user_id || undefined : undefined,
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-feedbacks"] });
      setShowCreate(false);
      setForm(emptyForm);
      toast({ title: "Feedback criado com sucesso" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  function targetBadge(item: FeedbackRequest) {
    if (item.target_type === "all") return <Badge variant="secondary">Todos</Badge>;
    if (item.target_type === "department")
      return <Badge variant="outline">{item.target_name ?? "Departamento"}</Badge>;
    return <Badge variant="outline">{item.target_name ?? "Colaborador"}</Badge>;
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <MessageSquare className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-semibold">Feedbacks</h1>
          </div>
          <Button onClick={() => setShowCreate(true)}>
            <Plus className="h-4 w-4 mr-2" /> Novo Feedback
          </Button>
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}

        {!isLoading && list.length === 0 && (
          <p className="text-muted-foreground text-sm">Nenhum feedback criado ainda.</p>
        )}

        <div className="space-y-3">
          {list.map((item) => (
            <Card key={item.id}>
              <CardContent className="p-4 flex items-start justify-between gap-4">
                <div className="flex-1 space-y-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="font-medium">{item.title}</span>
                    {targetBadge(item)}
                  </div>
                  <p className="text-sm text-muted-foreground truncate">{item.question}</p>
                  <p className="text-xs text-muted-foreground">
                    {item.response_count ?? 0} resposta{(item.response_count ?? 0) !== 1 ? "s" : ""} ·{" "}
                    {item.created_by_name} · {new Date(item.created_at).toLocaleDateString("pt-BR")}
                  </p>
                </div>
                <Button variant="outline" size="sm" onClick={() => setSelectedFeedback(item)}>
                  Ver respostas
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      {/* Create dialog */}
      <Dialog open={showCreate} onOpenChange={setShowCreate}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Novo Feedback</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-1.5">
              <Label>Título</Label>
              <Input
                value={form.title}
                onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
                placeholder="Título do feedback"
              />
            </div>
            <div className="space-y-1.5">
              <Label>Pergunta</Label>
              <Textarea
                value={form.question}
                onChange={(e) => setForm((f) => ({ ...f, question: e.target.value }))}
                placeholder="Qual é a pergunta deste feedback?"
                rows={3}
              />
            </div>
            <div className="space-y-1.5">
              <Label>Destinatário</Label>
              <Select
                value={form.target_type}
                onValueChange={(v) => setForm((f) => ({ ...f, target_type: v, target_department_id: "", target_user_id: "" }))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos os colaboradores</SelectItem>
                  <SelectItem value="department">Por departamento</SelectItem>
                  <SelectItem value="individual">Colaborador específico</SelectItem>
                </SelectContent>
              </Select>
            </div>
            {form.target_type === "department" && (
              <div className="space-y-1.5">
                <Label>Departamento</Label>
                <Select
                  value={form.target_department_id}
                  onValueChange={(v) => setForm((f) => ({ ...f, target_department_id: v }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar departamento" />
                  </SelectTrigger>
                  <SelectContent>
                    {(deptList as { id: string; name: string }[]).map((d) => (
                      <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            {form.target_type === "individual" && (
              <div className="space-y-1.5">
                <Label>Colaborador</Label>
                <Select
                  value={form.target_user_id}
                  onValueChange={(v) => setForm((f) => ({ ...f, target_user_id: v }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar colaborador" />
                  </SelectTrigger>
                  <SelectContent>
                    {(collabList as { user_id: string; name: string }[]).map((c) => (
                      <SelectItem key={c.user_id} value={c.user_id}>{c.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowCreate(false)}>Cancelar</Button>
            <Button
              onClick={() => createMut.mutate(form)}
              disabled={createMut.isPending || !form.title || !form.question}
            >
              Criar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Responses sheet */}
      <Sheet open={!!selectedFeedback} onOpenChange={(open) => !open && setSelectedFeedback(null)}>
        <SheetContent className="w-full sm:max-w-lg overflow-y-auto">
          <SheetHeader>
            <SheetTitle>{selectedFeedback?.title}</SheetTitle>
          </SheetHeader>
          <div className="mt-4 space-y-3">
            {loadingResponses && <p className="text-sm text-muted-foreground">Carregando...</p>}
            {!loadingResponses && responses.length === 0 && (
              <p className="text-sm text-muted-foreground">Nenhuma resposta ainda.</p>
            )}
            {(responses as FeedbackResponse[]).map((r) => (
              <div key={r.id} className="rounded-lg border p-3 space-y-1">
                <div className="flex items-center justify-between">
                  <span className="font-medium text-sm">{r.user_name}</span>
                  <StarRating rating={r.rating} />
                </div>
                {r.comment && <p className="text-sm text-muted-foreground">{r.comment}</p>}
                <p className="text-xs text-muted-foreground">
                  {new Date(r.created_at).toLocaleDateString("pt-BR")}
                </p>
              </div>
            ))}
          </div>
        </SheetContent>
      </Sheet>
    </AdminLayout>
  );
}
