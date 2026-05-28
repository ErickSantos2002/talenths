import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { absences as absencesApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import type { AbsenceRequest, AbsenceType } from "@/types/absences";
import { CalendarOff, Plus, Trash2 } from "lucide-react";

// ── Status badge ──────────────────────────────────────────────────────────────

function StatusBadge({ status }: { status: AbsenceRequest["status"] }) {
  if (status === "approved")
    return <Badge className="bg-emerald-500/15 text-emerald-400 border-emerald-500/20">Aprovada</Badge>;
  if (status === "rejected")
    return <Badge className="bg-red-500/15 text-red-400 border-red-500/20">Recusada</Badge>;
  return <Badge className="bg-amber-500/15 text-amber-400 border-amber-500/20">Pendente</Badge>;
}

// ── Request Dialog ────────────────────────────────────────────────────────────

function RequestDialog({
  types,
  onClose,
}: {
  types: AbsenceType[];
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [typeId, setTypeId] = useState("");
  const [isPartial, setIsPartial] = useState(false);
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [reason, setReason] = useState("");

  const mutation = useMutation({
    mutationFn: () =>
      absencesApi.request({
        type_id: typeId,
        start_date: startDate,
        end_date: isPartial ? startDate : endDate,
        reason: reason || undefined,
        ...(isPartial ? { start_time: startTime, end_time: endTime } : {}),
      }),
    onSuccess: () => {
      toast({ title: "Solicitação enviada!" });
      queryClient.invalidateQueries({ queryKey: ["absences-my"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao enviar", description: e.message, variant: "destructive" }),
  });

  const selectedType = types.find((t) => t.id === typeId);
  const days =
    !isPartial && startDate && endDate
      ? Math.max(0, Math.floor((new Date(endDate).getTime() - new Date(startDate).getTime()) / 86400000) + 1)
      : 0;

  const canSubmit = isPartial
    ? typeId && startDate && startTime && endTime && endTime > startTime
    : typeId && startDate && endDate && days > 0;

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Solicitar ausência</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>Tipo de ausência</Label>
            <Select value={typeId} onValueChange={setTypeId}>
              <SelectTrigger>
                <SelectValue placeholder="Selecione..." />
              </SelectTrigger>
              <SelectContent>
                {types.map((t) => (
                  <SelectItem key={t.id} value={t.id}>
                    <div className="flex items-center gap-2">
                      <div className="h-3 w-3 rounded-full" style={{ backgroundColor: t.color }} />
                      {t.name}
                    </div>
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {selectedType && !selectedType.requires_approval && (
              <p className="text-xs text-emerald-400">Aprovação automática — sem necessidade de revisão.</p>
            )}
          </div>

          <div className="flex rounded-lg border overflow-hidden text-sm">
            <button
              type="button"
              onClick={() => setIsPartial(false)}
              className={`flex-1 py-2 transition-colors ${!isPartial ? "bg-primary text-primary-foreground font-medium" : "bg-muted/40 text-muted-foreground hover:bg-muted"}`}
            >
              Dia inteiro
            </button>
            <button
              type="button"
              onClick={() => setIsPartial(true)}
              className={`flex-1 py-2 transition-colors ${isPartial ? "bg-primary text-primary-foreground font-medium" : "bg-muted/40 text-muted-foreground hover:bg-muted"}`}
            >
              Horário específico
            </button>
          </div>

          {isPartial ? (
            <>
              <div className="space-y-1">
                <Label>Data</Label>
                <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <Label>Horário de início</Label>
                  <Input type="time" value={startTime} onChange={(e) => setStartTime(e.target.value)} />
                </div>
                <div className="space-y-1">
                  <Label>Horário de fim</Label>
                  <Input type="time" value={endTime} onChange={(e) => setEndTime(e.target.value)} />
                </div>
              </div>
            </>
          ) : (
            <>
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <Label>Data de início</Label>
                  <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
                </div>
                <div className="space-y-1">
                  <Label>Data de fim</Label>
                  <Input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} min={startDate} />
                </div>
              </div>
              {days > 0 && (
                <p className="text-sm text-muted-foreground">
                  Total: <strong>{days} dia{days !== 1 ? "s" : ""}</strong>
                </p>
              )}
            </>
          )}

          <div className="space-y-1">
            <Label>Motivo (opcional)</Label>
            <Textarea
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder="Descrição do motivo da ausência..."
              rows={3}
              className="resize-none"
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!canSubmit || mutation.isPending}>
            {mutation.isPending ? "Enviando..." : "Enviar solicitação"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function MyAbsencesPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [showDialog, setShowDialog] = useState(false);

  const { data: requests = [], isLoading } = useQuery({
    queryKey: ["absences-my"],
    queryFn: absencesApi.my,
  });

  const { data: types = [] } = useQuery({
    queryKey: ["absence-types"],
    queryFn: absencesApi.types,
  });

  const deleteMutation = useMutation({
    mutationFn: absencesApi.delete,
    onSuccess: () => {
      toast({ title: "Solicitação removida." });
      queryClient.invalidateQueries({ queryKey: ["absences-my"] });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao remover", description: e.message, variant: "destructive" }),
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        {showDialog && (
          <RequestDialog types={types} onClose={() => setShowDialog(false)} />
        )}

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <CalendarOff className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Minhas Ausências</h1>
          </div>
          <Button onClick={() => setShowDialog(true)}>
            <Plus className="h-4 w-4 mr-2" />
            Solicitar ausência
          </Button>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : requests.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <CalendarOff className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Você não tem solicitações de ausência.</p>
            <Button className="mt-4" onClick={() => setShowDialog(true)}>
              Solicitar ausência
            </Button>
          </div>
        ) : (
          <div className="space-y-3">
            {requests.map((r) => (
              <Card key={r.id} className="hover:shadow-md hover:border-primary/20 transition-all">
                <CardContent className="p-4">
                  <div className="flex items-start gap-3">
                    <div
                      className="mt-1 h-3 w-3 rounded-full shrink-0"
                      style={{ backgroundColor: r.type_color ?? "#6b7280" }}
                    />
                    <div className="flex-1 min-w-0 space-y-1">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-semibold text-sm">{r.type_name}</span>
                        <StatusBadge status={r.status} />
                      </div>
                      <p className="text-sm text-muted-foreground">
                        {r.start_time ? (
                          <>
                            {new Date(r.start_date + "T12:00:00").toLocaleDateString("pt-BR")}{" "}
                            <span className="font-medium">{r.start_time} às {r.end_time}</span>
                          </>
                        ) : (
                          <>
                            {new Date(r.start_date + "T12:00:00").toLocaleDateString("pt-BR")} até{" "}
                            {new Date(r.end_date + "T12:00:00").toLocaleDateString("pt-BR")}{" "}
                            <span className="font-medium">({r.days} dia{r.days !== 1 ? "s" : ""})</span>
                          </>
                        )}
                      </p>
                      {r.reason && (
                        <p className="text-xs text-muted-foreground italic">"{r.reason}"</p>
                      )}
                      {r.review_note && (
                        <p className="text-xs text-muted-foreground">Nota do gestor: {r.review_note}</p>
                      )}
                    </div>
                    {r.status === "pending" && (
                      <button
                        className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                        onClick={() => {
                          if (confirm("Cancelar esta solicitação?")) deleteMutation.mutate(r.id);
                        }}
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
