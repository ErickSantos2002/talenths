import { useState, type ReactNode } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { requests as requestsApi } from "@/lib/api";
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
import { CATEGORY_LABEL, type HrRequest, type HrRequestType, type RequestCategory } from "@/types/requests";
import { RequestCategoryBadge } from "@/components/requests/RequestCategoryBadge";
import { CalendarOff, Pencil, Plus, Trash2 } from "lucide-react";

// ── Status badge ──────────────────────────────────────────────────────────────

function StatusBadge({ status }: { status: HrRequest["status"] }) {
  if (status === "approved")
    return <Badge className="bg-emerald-500/15 text-emerald-400 border-emerald-500/20">Aprovada</Badge>;
  if (status === "rejected")
    return <Badge className="bg-red-500/15 text-red-400 border-red-500/20">Recusada</Badge>;
  return <Badge className="bg-amber-500/15 text-amber-400 border-amber-500/20">Pendente</Badge>;
}

// ── Request Dialog ────────────────────────────────────────────────────────────

const MIN_REASON_LENGTH = 20;

function SegmentButton({ active, onClick, disabled, children }: {
  active: boolean; onClick: () => void; disabled?: boolean; children: ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      aria-pressed={active}
      className={`flex-1 py-2 transition-colors disabled:cursor-not-allowed ${active ? "bg-primary text-primary-foreground font-medium" : "bg-muted/40 text-muted-foreground hover:bg-muted disabled:hover:bg-muted/40"}`}
    >
      {children}
    </button>
  );
}

function RequestDialog({
  types,
  request,
  onClose,
}: {
  types: HrRequestType[];
  request?: HrRequest;
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isEdit = Boolean(request);
  // A categoria não muda na edição: o backend recusa a troca.
  const [category, setCategory] = useState<RequestCategory>(request?.type_category ?? "saida");
  const leaveTypes = types.filter((t) => t.category === "saida");
  const payType = types.find((t) => t.category === "pagar_hora");
  const isPayHours = category === "pagar_hora";
  const [leaveTypeId, setLeaveTypeId] = useState(request?.type_category === "saida" ? request.type_id : "");
  const typeId = isPayHours ? payType?.id ?? "" : leaveTypeId;
  const [partialChoice, setPartialChoice] = useState(Boolean(request?.start_time));
  const isPartial = isPayHours || partialChoice;
  const [startDate, setStartDate] = useState(request?.start_date ?? "");
  const [endDate, setEndDate] = useState(request?.end_date ?? "");
  const [startTime, setStartTime] = useState(request?.start_time ?? "");
  const [endTime, setEndTime] = useState(request?.end_time ?? "");
  const [reason, setReason] = useState(request?.reason ?? "");

  const mutation = useMutation({
    mutationFn: () => {
      const data = {
        type_id: typeId,
        start_date: startDate,
        end_date: isPartial ? startDate : endDate,
        reason: reason.trim(),
        ...(isPartial ? { start_time: startTime, end_time: endTime } : {}),
      };
      return request ? requestsApi.update(request.id, data) : requestsApi.request(data);
    },
    onSuccess: () => {
      toast({ title: isEdit ? "Solicitação atualizada!" : "Solicitação enviada!" });
      queryClient.invalidateQueries({ queryKey: ["requests-my"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao enviar", description: e.message, variant: "destructive" }),
  });

  const days =
    !isPartial && startDate && endDate
      ? Math.max(0, Math.floor((new Date(endDate).getTime() - new Date(startDate).getTime()) / 86400000) + 1)
      : 0;

  const reasonLength = reason.trim().length;
  const reasonOk = reasonLength >= MIN_REASON_LENGTH;
  const canSubmit =
    reasonOk &&
    (isPartial
      ? typeId && startDate && startTime && endTime && endTime > startTime
      : typeId && startDate && endDate && days > 0);

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{isEdit ? "Editar solicitação" : "Nova solicitação"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>O que você quer pedir?</Label>
            <div className="flex rounded-lg border overflow-hidden text-sm">
              {(["saida", "pagar_hora"] as const).map((c) => (
                <SegmentButton key={c} active={category === c} disabled={isEdit && category !== c} onClick={() => setCategory(c)}>
                  {CATEGORY_LABEL[c]}
                </SegmentButton>
              ))}
            </div>
            <p className="text-xs text-muted-foreground">
              {isPayHours
                ? "Combine com o RH o dia e o horário da hora extra que compensa horas que você deve."
                : "Peça antes de sair: ida ao médico, saída pessoal ou outro motivo."}
            </p>
          </div>

          {!isPayHours && (
          <div className="space-y-1">
            <Label>Tipo de saída</Label>
            <Select value={leaveTypeId} onValueChange={setLeaveTypeId}>
              <SelectTrigger>
                <SelectValue placeholder="Selecione..." />
              </SelectTrigger>
              <SelectContent>
                {leaveTypes.map((t) => (
                  <SelectItem key={t.id} value={t.id}>
                    <div className="flex items-center gap-2">
                      <div className="h-3 w-3 rounded-full" style={{ backgroundColor: t.color }} />
                      {t.name}
                    </div>
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          )}

          {!isPayHours && (
            <div className="flex rounded-lg border overflow-hidden text-sm">
              <SegmentButton active={!partialChoice} onClick={() => setPartialChoice(false)}>Dia inteiro</SegmentButton>
              <SegmentButton active={partialChoice} onClick={() => setPartialChoice(true)}>Horário específico</SegmentButton>
            </div>
          )}

          {isPartial ? (
            <>
              <div className="space-y-1">
                <Label htmlFor="request-date">{isPayHours ? "Dia" : "Data"}</Label>
                <Input id="request-date" type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1">
                  <Label htmlFor="request-start">{isPayHours ? "Das" : "Horário de início"}</Label>
                  <Input id="request-start" type="time" value={startTime} onChange={(e) => setStartTime(e.target.value)} />
                </div>
                <div className="space-y-1">
                  <Label htmlFor="request-end">{isPayHours ? "Às" : "Horário de fim"}</Label>
                  <Input id="request-end" type="time" value={endTime} onChange={(e) => setEndTime(e.target.value)} />
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
            <Label htmlFor="request-reason">Motivo</Label>
            <Textarea
              id="request-reason"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder={isPayHours ? "Explique quais horas você vai compensar..." : "Explique o motivo da saída..."}
              rows={3}
              className="resize-none"
              required
              aria-describedby="request-reason-count"
            />
            <p
              id="request-reason-count"
              className={`text-xs ${reasonOk ? "text-muted-foreground" : "text-amber-500"}`}
            >
              {reasonOk ? `${reasonLength} caracteres` : `Mínimo de ${MIN_REASON_LENGTH} caracteres (${reasonLength}/${MIN_REASON_LENGTH})`}
            </p>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!canSubmit || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : isEdit ? "Salvar alterações" : "Enviar solicitação"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function MyRequestsPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [showDialog, setShowDialog] = useState(false);
  const [editing, setEditing] = useState<HrRequest | null>(null);

  const { data: requests = [], isLoading } = useQuery({
    queryKey: ["requests-my"],
    queryFn: requestsApi.my,
  });

  const { data: types = [] } = useQuery({
    queryKey: ["request-types"],
    queryFn: requestsApi.types,
  });

  const deleteMutation = useMutation({
    mutationFn: requestsApi.delete,
    onSuccess: () => {
      toast({ title: "Solicitação removida." });
      queryClient.invalidateQueries({ queryKey: ["requests-my"] });
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
        {editing && (
          <RequestDialog types={types} request={editing} onClose={() => setEditing(null)} />
        )}

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <CalendarOff className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Minhas Solicitações</h1>
          </div>
          <Button onClick={() => setShowDialog(true)}>
            <Plus className="h-4 w-4 mr-2" />
            Nova solicitação
          </Button>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : requests.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <CalendarOff className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Você não tem solicitações.</p>
            <Button className="mt-4" onClick={() => setShowDialog(true)}>
              Nova solicitação
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
                        <RequestCategoryBadge category={r.type_category} />
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
                      <div className="flex gap-1 shrink-0">
                        <button
                          type="button"
                          aria-label="Editar solicitação"
                          title="Editar solicitação"
                          className="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25"
                          onClick={() => setEditing(r)}
                        >
                          <Pencil className="h-4 w-4" />
                        </button>
                        <button
                          type="button"
                          aria-label="Cancelar solicitação"
                          title="Cancelar solicitação"
                          className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                          onClick={() => {
                            if (confirm("Cancelar esta solicitação?")) deleteMutation.mutate(r.id);
                          }}
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
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
