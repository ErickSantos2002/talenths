import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Clock, LogIn, LogOut, MapPin, Plus, PencilLine } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { timeclock as timeclockApi } from "@/lib/api";
import { PunchHistoryDialog } from "@/components/PunchHistoryDialog";
import { formatMinutes, formatPunchTime, TIMECLOCK_REASONS, type DaySummary, type Punch } from "@/types/timeclock";

function getCoords(): Promise<{ latitude?: number; longitude?: number }> {
  return new Promise((resolve) => {
    if (!navigator.geolocation) return resolve({});
    navigator.geolocation.getCurrentPosition(
      (pos) => resolve({ latitude: pos.coords.latitude, longitude: pos.coords.longitude }),
      () => resolve({}),
      { timeout: 8000, enableHighAccuracy: false },
    );
  });
}

function toLocalInput(iso: string): string {
  const d = new Date(iso);
  const p = (n: number) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}`;
}

// Campo de motivo (lista fixa + detalhe quando "Outro")
function ReasonField({ sel, setSel, detail, setDetail }: {
  sel: string; setSel: (v: string) => void; detail: string; setDetail: (v: string) => void;
}) {
  return (
    <div className="space-y-2">
      <div className="space-y-1.5">
        <Label>Motivo</Label>
        <Select value={sel} onValueChange={setSel}>
          <SelectTrigger><SelectValue placeholder="Selecione o motivo" /></SelectTrigger>
          <SelectContent>
            {TIMECLOCK_REASONS.map((r) => <SelectItem key={r} value={r}>{r}</SelectItem>)}
          </SelectContent>
        </Select>
      </div>
      {sel === "Outro" && (
        <Input value={detail} onChange={(e) => setDetail(e.target.value)} placeholder="Descreva o motivo" />
      )}
    </div>
  );
}

function buildReason(sel: string, detail: string): string {
  return sel === "Outro" ? (detail.trim() ? `Outro: ${detail.trim()}` : "Outro") : sel;
}

function PunchRow({ punch, onAdjust, onHistory }: { punch: Punch; onAdjust?: (p: Punch) => void; onHistory?: (id: string) => void }) {
  const isIn = punch.kind === "in";
  const canAdjust = onAdjust && punch.status === "valid" && !punch.pending_adjustment;
  return (
    <div className="flex items-center gap-2 rounded-lg border bg-card px-3 py-2 text-sm">
      <Badge variant="outline" className={isIn ? "text-emerald-500 border-emerald-500/30" : "text-amber-500 border-amber-500/30"}>
        {isIn ? "Entrada" : "Saída"}
      </Badge>
      <span className="font-medium tabular-nums">{formatPunchTime(punch.punched_at)}</span>
      {punch.status === "pending" && <Badge className="bg-amber-500/15 text-amber-600 dark:text-amber-400 hover:bg-amber-500/15 text-[10px]">Aguardando RH</Badge>}
      {punch.pending_adjustment && (
        <Badge className="bg-amber-500/15 text-amber-600 dark:text-amber-400 hover:bg-amber-500/15 text-[10px]" title={`Solicitado: ${formatPunchTime(punch.pending_adjustment.requested_punched_at)}`}>
          Ajuste solicitado
        </Badge>
      )}
      {punch.adjusted && onHistory && (
        <button type="button" onClick={() => onHistory(punch.id)} className="text-[11px] text-primary hover:underline" title="Ver histórico do ajuste">
          ajustado
        </button>
      )}
      {punch.latitude != null && punch.longitude != null && (
        <a href={`https://www.google.com/maps?q=${punch.latitude},${punch.longitude}`} target="_blank" rel="noreferrer" className="inline-flex items-center gap-0.5 text-xs text-primary hover:underline" title="Ver no mapa">
          <MapPin className="h-3.5 w-3.5" /> mapa
        </a>
      )}
      {punch.reason && <span className="text-xs text-muted-foreground italic truncate">{punch.reason}</span>}
      {punch.note && <span className="text-xs text-muted-foreground italic truncate">{punch.note}</span>}
      {canAdjust && (
        <Button variant="ghost" size="sm" className="ml-auto h-7 text-xs" onClick={() => onAdjust!(punch)}>
          <PencilLine className="h-3.5 w-3.5 mr-1" /> Ajustar
        </Button>
      )}
    </div>
  );
}

function DayCard({ day, onAdjust, onHistory }: { day: DaySummary; onAdjust: (p: Punch) => void; onHistory: (id: string) => void }) {
  const dateLabel = new Date(day.work_date + "T12:00:00").toLocaleDateString("pt-BR", { weekday: "short", day: "2-digit", month: "2-digit" });
  return (
    <div className="rounded-xl border p-4 space-y-3">
      <div className="flex items-center justify-between">
        <span className="font-medium capitalize">{dateLabel}</span>
        <div className="flex items-center gap-2 text-sm">
          <span className="font-semibold tabular-nums">{formatMinutes(day.worked_minutes)}</span>
          <span className="text-muted-foreground">/ {formatMinutes(day.expected_minutes)}</span>
          {day.open && <Badge variant="outline" className="text-amber-500 border-amber-500/30">Em aberto</Badge>}
          {day.odd && <Badge variant="outline" className="text-red-500 border-red-500/30">Incompleto — falta batida</Badge>}
        </div>
      </div>
      <div className="space-y-1.5">
        {day.punches.map((p) => <PunchRow key={p.id} punch={p} onAdjust={onAdjust} onHistory={onHistory} />)}
      </div>
    </div>
  );
}

// ── Dialogs ────────────────────────────────────────────────────────────────────

function ManualSelfDialog({ onClose }: { onClose: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dt, setDt] = useState(`${new Date().toLocaleDateString("en-CA")}T08:00`);
  const [kind, setKind] = useState<"in" | "out">("in");
  const [sel, setSel] = useState("Esqueci de bater");
  const [detail, setDetail] = useState("");

  const mutation = useMutation({
    mutationFn: () => timeclockApi.manualSelf({ punched_at: dt, kind, reason: buildReason(sel, detail) }),
    onSuccess: () => {
      toast({ title: "Registro enviado", description: "Ficará pendente até o RH confirmar." });
      queryClient.invalidateQueries({ queryKey: ["timeclock-today"] });
      queryClient.invalidateQueries({ queryKey: ["timeclock-my"] });
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-sm">
        <DialogHeader><DialogTitle>Registrar manualmente</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <p className="text-xs text-muted-foreground">Use para uma batida esquecida. Ficará pendente até o RH confirmar.</p>
          <div className="space-y-1.5">
            <Label>Data e hora</Label>
            <Input type="datetime-local" value={dt} onChange={(e) => setDt(e.target.value)} />
          </div>
          <div className="space-y-1.5">
            <Label>Tipo</Label>
            <Select value={kind} onValueChange={(v) => setKind(v as "in" | "out")}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="in">Entrada</SelectItem>
                <SelectItem value="out">Saída</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <ReasonField sel={sel} setSel={setSel} detail={detail} setDetail={setDetail} />
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!dt || !sel || mutation.isPending}>
            {mutation.isPending ? "Enviando..." : "Enviar solicitação"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function AdjustDialog({ punch, onClose }: { punch: Punch; onClose: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dt, setDt] = useState(toLocalInput(punch.punched_at));
  const [sel, setSel] = useState("Esqueci de bater");
  const [detail, setDetail] = useState("");

  const mutation = useMutation({
    mutationFn: () => timeclockApi.adjust(punch.id, { requested_punched_at: dt, reason: buildReason(sel, detail) }),
    onSuccess: () => {
      toast({ title: "Ajuste solicitado", description: "O RH vai analisar a alteração." });
      queryClient.invalidateQueries({ queryKey: ["timeclock-today"] });
      queryClient.invalidateQueries({ queryKey: ["timeclock-my"] });
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-sm">
        <DialogHeader><DialogTitle>Ajustar horário</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <p className="text-xs text-muted-foreground">
            Batida atual: <b>{punch.kind === "in" ? "Entrada" : "Saída"}</b> às {formatPunchTime(punch.punched_at)}.
            A alteração será enviada ao RH para aprovação.
          </p>
          <div className="space-y-1.5">
            <Label>Horário correto</Label>
            <Input type="datetime-local" value={dt} onChange={(e) => setDt(e.target.value)} />
          </div>
          <ReasonField sel={sel} setSel={setSel} detail={detail} setDetail={setDetail} />
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!dt || !sel || mutation.isPending}>
            {mutation.isPending ? "Enviando..." : "Solicitar ajuste"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

export default function MyTimeclockPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [note, setNote] = useState("");
  const [manualOpen, setManualOpen] = useState(false);
  const [adjustTarget, setAdjustTarget] = useState<Punch | null>(null);
  const [historyPunchId, setHistoryPunchId] = useState<string | null>(null);

  const { data: today, isLoading } = useQuery({ queryKey: ["timeclock-today"], queryFn: timeclockApi.today });
  const { data: history = [] } = useQuery({ queryKey: ["timeclock-my"], queryFn: () => timeclockApi.my() });

  const punchMutation = useMutation({
    mutationFn: async () => {
      const coords = await getCoords();
      return timeclockApi.punch({ ...coords, note: note.trim() || undefined });
    },
    onSuccess: (p) => {
      toast({ title: p.kind === "in" ? "Entrada registrada!" : "Saída registrada!" });
      setNote("");
      queryClient.invalidateQueries({ queryKey: ["timeclock-today"] });
      queryClient.invalidateQueries({ queryKey: ["timeclock-my"] });
    },
    onError: (e: Error) => toast({ title: "Erro ao bater ponto", description: e.message, variant: "destructive" }),
  });

  const nextIsIn = today?.next_action === "in";

  return (
    <AdminLayout>
      <div className="space-y-6 max-w-3xl">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <Clock className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Meu Ponto</h1>
          </div>
          {today?.enabled && (
            <Button variant="outline" size="sm" onClick={() => setManualOpen(true)}>
              <Plus className="h-4 w-4 mr-1" /> Registrar Manualmente
            </Button>
          )}
        </div>

        {isLoading ? (
          <Skeleton className="h-48 w-full" />
        ) : !today?.enabled ? (
          <div className="rounded-xl border border-dashed p-12 text-center">
            <Clock className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Você ainda não está habilitado para bater ponto. Fale com o RH.</p>
          </div>
        ) : (
          <>
            <div className="rounded-2xl border bg-card p-6 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">Trabalhado hoje</p>
                  <p className="text-3xl font-bold tabular-nums">
                    {formatMinutes(today.worked_minutes)}
                    <span className="text-base font-normal text-muted-foreground"> / {formatMinutes(today.expected_minutes)}</span>
                  </p>
                </div>
                {today.open && <Badge variant="outline" className="text-emerald-500 border-emerald-500/30">Trabalhando</Badge>}
              </div>

              <Input value={note} onChange={(e) => setNote(e.target.value)} placeholder="Observação (opcional)" />

              <Button size="lg" className="w-full h-14 text-base" onClick={() => punchMutation.mutate()} disabled={punchMutation.isPending}>
                {nextIsIn ? <LogIn className="h-5 w-5 mr-2" /> : <LogOut className="h-5 w-5 mr-2" />}
                {punchMutation.isPending ? "Registrando..." : nextIsIn ? "Registrar Entrada" : "Registrar Saída"}
              </Button>
              <p className="flex items-center justify-center gap-1.5 text-xs text-muted-foreground">
                <MapPin className="h-3.5 w-3.5" /> A localização é capturada ao bater (se você permitir).
              </p>
            </div>

            {today.punches.length > 0 && (
              <div className="space-y-2">
                <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">Hoje</h2>
                <div className="space-y-1.5">
                  {today.punches.map((p) => <PunchRow key={p.id} punch={p} onAdjust={setAdjustTarget} onHistory={setHistoryPunchId} />)}
                </div>
              </div>
            )}

            <div className="space-y-3">
              <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">Histórico</h2>
              {history.filter((d) => d.work_date !== today.work_date).length === 0 ? (
                <p className="text-sm text-muted-foreground">Nenhum registro anterior.</p>
              ) : (
                history.filter((d) => d.work_date !== today.work_date).map((d) => <DayCard key={d.work_date} day={d} onAdjust={setAdjustTarget} onHistory={setHistoryPunchId} />)
              )}
            </div>
          </>
        )}
      </div>

      {manualOpen && <ManualSelfDialog onClose={() => setManualOpen(false)} />}
      {adjustTarget && <AdjustDialog punch={adjustTarget} onClose={() => setAdjustTarget(null)} />}
      {historyPunchId && <PunchHistoryDialog punchId={historyPunchId} onClose={() => setHistoryPunchId(null)} />}
    </AdminLayout>
  );
}
