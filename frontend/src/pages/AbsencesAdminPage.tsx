import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { absences as absencesApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import type { AbsenceType, AbsenceRequest } from "@/types/absences";
import { CalendarOff, CheckCircle2, XCircle, Clock, Settings, Calendar } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Status badge ──────────────────────────────────────────────────────────────

function StatusBadge({ status }: { status: AbsenceRequest["status"] }) {
  if (status === "approved")
    return <Badge className="bg-emerald-100 text-emerald-700 border-emerald-200">Aprovada</Badge>;
  if (status === "rejected")
    return <Badge className="bg-red-100 text-red-700 border-red-200">Recusada</Badge>;
  return <Badge className="bg-amber-100 text-amber-700 border-amber-200">Pendente</Badge>;
}

// ── Review Dialog ─────────────────────────────────────────────────────────────

function ReviewDialog({
  request,
  action,
  onClose,
}: {
  request: AbsenceRequest;
  action: "approve" | "reject";
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [note, setNote] = useState("");

  const mutation = useMutation({
    mutationFn: () =>
      action === "approve"
        ? absencesApi.approve(request.id, note || undefined)
        : absencesApi.reject(request.id, note || undefined),
    onSuccess: () => {
      toast({ title: action === "approve" ? "Solicitação aprovada!" : "Solicitação recusada." });
      queryClient.invalidateQueries({ queryKey: ["absences-team"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>
            {action === "approve" ? "Aprovar" : "Recusar"} solicitação
          </DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <p className="text-sm text-muted-foreground">
            <strong>{request.user_name}</strong> — {request.type_name} de{" "}
            {new Date(request.start_date + "T12:00:00").toLocaleDateString("pt-BR")} até{" "}
            {new Date(request.end_date + "T12:00:00").toLocaleDateString("pt-BR")} ({request.days} dias)
          </p>
          <div className="space-y-1">
            <Label>Nota (opcional)</Label>
            <Textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="Comentário sobre a decisão..."
              rows={3}
              className="resize-none"
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button
            onClick={() => mutation.mutate()}
            disabled={mutation.isPending}
            variant={action === "approve" ? "default" : "destructive"}
          >
            {mutation.isPending ? "Salvando..." : action === "approve" ? "Aprovar" : "Recusar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Requests Tab ──────────────────────────────────────────────────────────────

function RequestsTab() {
  const [reviewing, setReviewing] = useState<{
    request: AbsenceRequest;
    action: "approve" | "reject";
  } | null>(null);

  const { data: requests = [], isLoading } = useQuery({
    queryKey: ["absences-team"],
    queryFn: absencesApi.team,
  });

  const pending = requests.filter((r) => r.status === "pending");
  const decided = requests.filter((r) => r.status !== "pending");

  if (isLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

  return (
    <div className="space-y-6">
      {reviewing && (
        <ReviewDialog
          request={reviewing.request}
          action={reviewing.action}
          onClose={() => setReviewing(null)}
        />
      )}

      {pending.length === 0 && decided.length === 0 && (
        <div className="rounded-xl border border-dashed p-16 text-center">
          <CalendarOff className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground">Nenhuma solicitação ainda.</p>
        </div>
      )}

      {pending.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
            Pendentes ({pending.length})
          </h2>
          {pending.map((r) => (
            <RequestCard
              key={r.id}
              request={r}
              onApprove={() => setReviewing({ request: r, action: "approve" })}
              onReject={() => setReviewing({ request: r, action: "reject" })}
            />
          ))}
        </section>
      )}

      {decided.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
            Histórico
          </h2>
          {decided.map((r) => (
            <RequestCard key={r.id} request={r} />
          ))}
        </section>
      )}
    </div>
  );
}

function RequestCard({
  request,
  onApprove,
  onReject,
}: {
  request: AbsenceRequest;
  onApprove?: () => void;
  onReject?: () => void;
}) {
  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-start gap-3">
          <div
            className="mt-1 h-3 w-3 rounded-full shrink-0"
            style={{ backgroundColor: request.type_color ?? "#6b7280" }}
          />
          <div className="flex-1 min-w-0 space-y-1">
            <div className="flex items-center gap-2 flex-wrap">
              <span className="font-semibold text-sm">{request.user_name}</span>
              {request.department && (
                <span className="text-xs text-muted-foreground">· {request.department}</span>
              )}
              <StatusBadge status={request.status} />
            </div>
            <p className="text-sm text-muted-foreground">
              {request.type_name} —{" "}
              {new Date(request.start_date + "T12:00:00").toLocaleDateString("pt-BR")} até{" "}
              {new Date(request.end_date + "T12:00:00").toLocaleDateString("pt-BR")}{" "}
              <span className="font-medium">({request.days} dias)</span>
            </p>
            {request.reason && (
              <p className="text-xs text-muted-foreground italic">"{request.reason}"</p>
            )}
            {request.review_note && (
              <p className="text-xs text-muted-foreground">Nota: {request.review_note}</p>
            )}
          </div>
          {request.status === "pending" && onApprove && onReject && (
            <div className="flex gap-2 shrink-0">
              <Button size="sm" variant="outline" onClick={onReject} className="text-red-600 border-red-200 hover:bg-red-50">
                <XCircle className="h-4 w-4 mr-1" /> Recusar
              </Button>
              <Button size="sm" onClick={onApprove}>
                <CheckCircle2 className="h-4 w-4 mr-1" /> Aprovar
              </Button>
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

// ── Calendar Tab ──────────────────────────────────────────────────────────────

function CalendarTab() {
  const { data: approved = [], isLoading } = useQuery({
    queryKey: ["absences-calendar"],
    queryFn: absencesApi.calendar,
  });

  if (isLoading) return <p className="text-sm text-muted-foreground">Carregando...</p>;

  if (approved.length === 0) {
    return (
      <div className="rounded-xl border border-dashed p-16 text-center">
        <Calendar className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
        <p className="text-muted-foreground">Nenhuma ausência aprovada no momento.</p>
      </div>
    );
  }

  const now = new Date();

  const active = approved.filter(
    (r) => new Date(r.end_date + "T23:59:59") >= now
  );
  const past = approved.filter(
    (r) => new Date(r.end_date + "T23:59:59") < now
  );

  return (
    <div className="space-y-6">
      {active.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
            Próximas e em andamento
          </h2>
          {active.map((r) => (
            <CalendarEntry key={r.id} request={r} />
          ))}
        </section>
      )}
      {past.length > 0 && (
        <section className="space-y-3">
          <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
            Passadas
          </h2>
          {past.map((r) => (
            <CalendarEntry key={r.id} request={r} />
          ))}
        </section>
      )}
    </div>
  );
}

function CalendarEntry({ request }: { request: AbsenceRequest }) {
  return (
    <div className="flex items-center gap-3 rounded-lg border p-3">
      <div
        className="h-3 w-3 rounded-full shrink-0"
        style={{ backgroundColor: request.type_color ?? "#6b7280" }}
      />
      <div className="flex-1 min-w-0">
        <p className="text-sm font-medium">{request.user_name}</p>
        <p className="text-xs text-muted-foreground">
          {request.type_name} · {new Date(request.start_date + "T12:00:00").toLocaleDateString("pt-BR")} –{" "}
          {new Date(request.end_date + "T12:00:00").toLocaleDateString("pt-BR")} ({request.days} dias)
        </p>
      </div>
    </div>
  );
}

// ── Types Tab ─────────────────────────────────────────────────────────────────

function TypeDialog({
  type,
  onClose,
}: {
  type?: AbsenceType;
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [name, setName] = useState(type?.name ?? "");
  const [color, setColor] = useState(type?.color ?? "#6366f1");
  const [requiresApproval, setRequiresApproval] = useState(type?.requires_approval ?? true);

  const mutation = useMutation({
    mutationFn: () =>
      type
        ? absencesApi.updateType(type.id, { name, color, requires_approval: requiresApproval })
        : absencesApi.createType({ name, color, requires_approval: requiresApproval }),
    onSuccess: () => {
      toast({ title: type ? "Tipo atualizado!" : "Tipo criado!" });
      queryClient.invalidateQueries({ queryKey: ["absence-types"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{type ? "Editar tipo" : "Novo tipo de ausência"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>Nome</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Ex: Férias" />
          </div>
          <div className="space-y-1">
            <Label>Cor</Label>
            <div className="flex items-center gap-3">
              <input
                type="color"
                value={color}
                onChange={(e) => setColor(e.target.value)}
                className="h-9 w-16 cursor-pointer rounded border"
              />
              <span className="text-sm text-muted-foreground">{color}</span>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <input
              type="checkbox"
              id="req-approval"
              checked={requiresApproval}
              onChange={(e) => setRequiresApproval(e.target.checked)}
              className="h-4 w-4"
            />
            <Label htmlFor="req-approval">Requer aprovação do gestor</Label>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!name.trim() || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function TypesTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dialog, setDialog] = useState<{ open: boolean; type?: AbsenceType }>({ open: false });

  const { data: types = [], isLoading } = useQuery({
    queryKey: ["absence-types"],
    queryFn: absencesApi.types,
  });

  const deleteMutation = useMutation({
    mutationFn: absencesApi.deleteType,
    onSuccess: () => {
      toast({ title: "Tipo removido." });
      queryClient.invalidateQueries({ queryKey: ["absence-types"] });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao remover", description: e.message, variant: "destructive" }),
  });

  return (
    <div className="space-y-4">
      {dialog.open && (
        <TypeDialog type={dialog.type} onClose={() => setDialog({ open: false })} />
      )}

      <div className="flex justify-end">
        <Button onClick={() => setDialog({ open: true })}>+ Novo tipo</Button>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : (
        <div className="space-y-2">
          {types.map((t) => (
            <div key={t.id} className="flex items-center gap-3 rounded-lg border p-3">
              <div className="h-4 w-4 rounded-full shrink-0" style={{ backgroundColor: t.color }} />
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium">{t.name}</p>
                <p className="text-xs text-muted-foreground">
                  {t.requires_approval ? "Requer aprovação" : "Aprovação automática"}
                </p>
              </div>
              <div className="flex gap-2 shrink-0">
                <Button variant="ghost" size="sm" onClick={() => setDialog({ open: true, type: t })}>
                  Editar
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-destructive hover:text-destructive"
                  onClick={() => {
                    if (confirm(`Remover tipo "${t.name}"?`)) deleteMutation.mutate(t.id);
                  }}
                >
                  Remover
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function AbsencesAdminPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <CalendarOff className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Ausências e Férias</h1>
        </div>

        <Tabs defaultValue="requests">
          <TabsList>
            <TabsTrigger value="requests">
              <Clock className="h-4 w-4 mr-2" />
              Solicitações
            </TabsTrigger>
            <TabsTrigger value="calendar">
              <Calendar className="h-4 w-4 mr-2" />
              Calendário
            </TabsTrigger>
            <TabsTrigger value="types">
              <Settings className="h-4 w-4 mr-2" />
              Tipos
            </TabsTrigger>
          </TabsList>

          <TabsContent value="requests" className="mt-6">
            <RequestsTab />
          </TabsContent>

          <TabsContent value="calendar" className="mt-6">
            <CalendarTab />
          </TabsContent>

          <TabsContent value="types" className="mt-6">
            <TypesTab />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
