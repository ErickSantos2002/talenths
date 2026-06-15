import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Clock, Plus, Pencil, Trash2, MapPin } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Combobox } from "@/components/Combobox";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { timeclock as timeclockApi, collaborators as collaboratorsApi } from "@/lib/api";
import { formatMinutes, formatPunchTime, type Punch, type DaySummary } from "@/types/timeclock";

const todayISO = () => new Date().toLocaleDateString("en-CA");
const monthStartISO = () => { const d = new Date(); d.setDate(1); return d.toLocaleDateString("en-CA"); };

function toLocalInput(iso: string): string {
  const d = new Date(iso);
  const p = (n: number) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}`;
}

function PunchChip({ p }: { p: Punch }) {
  const isIn = p.kind === "in";
  return (
    <span className={`inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-xs ${isIn ? "text-emerald-500 border-emerald-500/30" : "text-amber-500 border-amber-500/30"}`}>
      {isIn ? "E" : "S"} {formatPunchTime(p.punched_at)}
      {p.latitude != null && p.longitude != null && (
        <a href={`https://www.google.com/maps?q=${p.latitude},${p.longitude}`} target="_blank" rel="noreferrer" title="Ver no mapa" className="hover:opacity-100">
          <MapPin className="h-3 w-3 opacity-60" />
        </a>
      )}
      {p.source === "manual" && <span className="opacity-60">·RH</span>}
    </span>
  );
}

// ── Dialog de batida (adicionar manual ou editar) ──────────────────────────────

function PunchDialog({ userId, punch, onClose }: { userId: string; punch?: Punch; onClose: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dt, setDt] = useState(punch ? toLocalInput(punch.punched_at) : `${todayISO()}T08:00`);
  const [kind, setKind] = useState<"in" | "out">(punch?.kind ?? "in");
  const [note, setNote] = useState(punch?.note ?? "");

  const mutation = useMutation({
    mutationFn: () =>
      punch
        ? timeclockApi.update(punch.id, { punched_at: dt, kind, note: note.trim() || undefined })
        : timeclockApi.manual({ user_id: userId, punched_at: dt, kind, note: note.trim() || undefined }),
    onSuccess: () => {
      toast({ title: punch ? "Batida atualizada" : "Batida adicionada" });
      queryClient.invalidateQueries({ queryKey: ["timeclock-team-user"] });
      queryClient.invalidateQueries({ queryKey: ["timeclock-team-day"] });
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-sm">
        <DialogHeader>
          <DialogTitle>{punch ? "Editar batida" : "Adicionar batida"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
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
          <div className="space-y-1.5">
            <Label>Observação (opcional)</Label>
            <Input value={note} onChange={(e) => setNote(e.target.value)} placeholder="Ex.: correção de batida esquecida" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!dt || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Aba Hoje ───────────────────────────────────────────────────────────────────

function TodayTab() {
  const [date, setDate] = useState(todayISO());
  const { data, isLoading } = useQuery({
    queryKey: ["timeclock-team-day", date],
    queryFn: () => timeclockApi.teamDay(date),
  });

  const STATUS = {
    working: { label: "Trabalhando", cls: "text-emerald-500 border-emerald-500/30" },
    done: { label: "Encerrado", cls: "text-muted-foreground" },
    none: { label: "Sem registro", cls: "text-muted-foreground/60" },
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <Label className="text-sm text-muted-foreground">Dia:</Label>
        <Input type="date" value={date} onChange={(e) => setDate(e.target.value)} className="w-auto" />
      </div>
      {isLoading ? (
        <Skeleton className="h-64 w-full" />
      ) : !data || data.people.length === 0 ? (
        <p className="text-sm text-muted-foreground">Nenhum colaborador habilitado para ponto.</p>
      ) : (
        <div className="rounded-xl border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-muted-foreground">Colaborador</th>
                <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden md:table-cell">Departamento</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground">Status</th>
                <th className="text-center px-3 py-3 font-medium text-muted-foreground">Trabalhado</th>
                <th className="text-left px-4 py-3 font-medium text-muted-foreground">Batidas</th>
              </tr>
            </thead>
            <tbody>
              {data.people.map((p) => (
                <tr key={p.user_id} className="border-t">
                  <td className="px-4 py-3 font-medium">{p.user_name}</td>
                  <td className="px-3 py-3 text-muted-foreground hidden md:table-cell">{p.department ?? "—"}</td>
                  <td className="px-3 py-3 text-center">
                    <Badge variant="outline" className={STATUS[p.status].cls}>{STATUS[p.status].label}</Badge>
                  </td>
                  <td className="px-3 py-3 text-center tabular-nums">
                    {formatMinutes(p.worked_minutes)} <span className="text-muted-foreground">/ {formatMinutes(p.expected_minutes)}</span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex flex-wrap gap-1">
                      {p.punches.length ? p.punches.map((pu) => <PunchChip key={pu.id} p={pu} />) : <span className="text-muted-foreground">—</span>}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ── Aba Período (por colaborador, com correções) ───────────────────────────────

function PeriodTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [userId, setUserId] = useState<string | undefined>();
  const [start, setStart] = useState(monthStartISO());
  const [end, setEnd] = useState(todayISO());
  const [dialog, setDialog] = useState<{ punch?: Punch } | null>(null);
  const [deleting, setDeleting] = useState<Punch | null>(null);

  const { data: colabs = [] } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaboratorsApi.list(),
  });
  const options = (colabs as Record<string, unknown>[])
    .filter((c) => c.timeclock_enabled)
    .map((c) => ({ value: c.user_id as string, label: c.name as string }));

  const { data, isLoading } = useQuery({
    queryKey: ["timeclock-team-user", userId, start, end],
    queryFn: () => timeclockApi.teamUser(userId!, start, end),
    enabled: !!userId,
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => timeclockApi.delete(id),
    onSuccess: () => {
      toast({ title: "Batida excluída" });
      queryClient.invalidateQueries({ queryKey: ["timeclock-team-user"] });
      setDeleting(null);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const days: DaySummary[] = data?.mode === "user" ? data.days : [];

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-end gap-3">
        <div className="space-y-1 min-w-56">
          <Label className="text-xs">Colaborador</Label>
          <Combobox
            options={options}
            value={userId}
            onChange={setUserId}
            placeholder="Selecione um colaborador"
            searchPlaceholder="Buscar pessoa..."
            emptyText="Nenhum habilitado."
          />
        </div>
        <div className="space-y-1">
          <Label className="text-xs">De</Label>
          <Input type="date" value={start} onChange={(e) => setStart(e.target.value)} className="w-auto" />
        </div>
        <div className="space-y-1">
          <Label className="text-xs">Até</Label>
          <Input type="date" value={end} onChange={(e) => setEnd(e.target.value)} className="w-auto" />
        </div>
        {userId && (
          <Button variant="outline" size="sm" onClick={() => setDialog({})}>
            <Plus className="h-4 w-4 mr-1" /> Adicionar batida
          </Button>
        )}
      </div>

      {!userId ? (
        <p className="text-sm text-muted-foreground">Selecione um colaborador para ver o ponto.</p>
      ) : isLoading ? (
        <Skeleton className="h-48 w-full" />
      ) : days.length === 0 ? (
        <p className="text-sm text-muted-foreground">Nenhuma batida no período.</p>
      ) : (
        <div className="space-y-3">
          {days.map((day) => {
            const dateLabel = new Date(day.work_date + "T12:00:00").toLocaleDateString("pt-BR", { weekday: "short", day: "2-digit", month: "2-digit" });
            return (
              <div key={day.work_date} className="rounded-xl border p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <span className="font-medium capitalize">{dateLabel}</span>
                  <div className="flex items-center gap-2 text-sm">
                    <span className="font-semibold tabular-nums">{formatMinutes(day.worked_minutes)}</span>
                    <span className="text-muted-foreground">/ {formatMinutes(day.expected_minutes)}</span>
                    {day.open && <Badge variant="outline" className="text-amber-500 border-amber-500/30">Em aberto</Badge>}
                    {day.odd && <Badge variant="outline" className="text-red-500 border-red-500/30">Batida ímpar</Badge>}
                  </div>
                </div>
                <div className="space-y-1.5">
                  {day.punches.map((p) => (
                    <div key={p.id} className="flex items-center gap-3 rounded-lg border bg-card px-3 py-1.5 text-sm">
                      <Badge variant="outline" className={p.kind === "in" ? "text-emerald-500 border-emerald-500/30" : "text-amber-500 border-amber-500/30"}>
                        {p.kind === "in" ? "Entrada" : "Saída"}
                      </Badge>
                      <span className="font-medium tabular-nums">{formatPunchTime(p.punched_at)}</span>
                      {p.source === "manual" && <Badge variant="secondary" className="text-[10px]">RH</Badge>}
                      {p.latitude != null && p.longitude != null && (
                        <a href={`https://www.google.com/maps?q=${p.latitude},${p.longitude}`} target="_blank" rel="noreferrer" title="Ver no mapa" className="text-primary">
                          <MapPin className="h-3.5 w-3.5" />
                        </a>
                      )}
                      {p.note && <span className="text-xs text-muted-foreground italic truncate flex-1">{p.note}</span>}
                      <div className="ml-auto flex gap-1">
                        <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => setDialog({ punch: p })}><Pencil className="h-3.5 w-3.5" /></Button>
                        <Button variant="ghost" size="icon" className="h-7 w-7 text-destructive" onClick={() => setDeleting(p)}><Trash2 className="h-3.5 w-3.5" /></Button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      )}

      {dialog && userId && <PunchDialog userId={userId} punch={dialog.punch} onClose={() => setDialog(null)} />}

      <AlertDialog open={!!deleting} onOpenChange={(o) => !o && setDeleting(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir esta batida?</AlertDialogTitle>
            <AlertDialogDescription>A batida será removida permanentemente.</AlertDialogDescription>
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
    </div>
  );
}

export default function AdminTimeclockPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <Clock className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Ponto Eletrônico</h1>
        </div>

        <Tabs defaultValue="today">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger value="today" className="data-[state=active]:border-primary data-[state=active]:bg-transparent rounded-none border-b-2 border-transparent">
              Hoje
            </TabsTrigger>
            <TabsTrigger value="period" className="data-[state=active]:border-primary data-[state=active]:bg-transparent rounded-none border-b-2 border-transparent">
              Por período
            </TabsTrigger>
          </TabsList>
          <TabsContent value="today" className="mt-6"><TodayTab /></TabsContent>
          <TabsContent value="period" className="mt-6"><PeriodTab /></TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
