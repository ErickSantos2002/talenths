import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Clock, LogIn, LogOut, MapPin } from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";
import { timeclock as timeclockApi } from "@/lib/api";
import { formatMinutes, formatPunchTime, type DaySummary, type Punch } from "@/types/timeclock";

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

function PunchRow({ punch }: { punch: Punch }) {
  const isIn = punch.kind === "in";
  return (
    <div className="flex items-center gap-3 rounded-lg border bg-card px-3 py-2 text-sm">
      <Badge variant="outline" className={isIn ? "text-emerald-500 border-emerald-500/30" : "text-amber-500 border-amber-500/30"}>
        {isIn ? "Entrada" : "Saída"}
      </Badge>
      <span className="font-medium tabular-nums">{formatPunchTime(punch.punched_at)}</span>
      {punch.source === "manual" && <Badge variant="secondary" className="text-[10px]">ajuste do RH</Badge>}
      {punch.latitude != null && punch.longitude != null && (
        <a
          href={`https://www.google.com/maps?q=${punch.latitude},${punch.longitude}`}
          target="_blank"
          rel="noreferrer"
          className="inline-flex items-center gap-0.5 text-xs text-primary hover:underline"
          title="Ver localização no mapa"
        >
          <MapPin className="h-3.5 w-3.5" /> mapa
        </a>
      )}
      {punch.note && <span className="text-xs text-muted-foreground italic truncate">{punch.note}</span>}
    </div>
  );
}

function DayCard({ day }: { day: DaySummary }) {
  const dateLabel = new Date(day.work_date + "T12:00:00").toLocaleDateString("pt-BR", {
    weekday: "short", day: "2-digit", month: "2-digit",
  });
  return (
    <div className="rounded-xl border p-4 space-y-3">
      <div className="flex items-center justify-between">
        <span className="font-medium capitalize">{dateLabel}</span>
        <div className="flex items-center gap-2 text-sm">
          <span className="font-semibold tabular-nums">{formatMinutes(day.worked_minutes)}</span>
          <span className="text-muted-foreground">/ {formatMinutes(day.expected_minutes)}</span>
          {day.open && <Badge variant="outline" className="text-amber-500 border-amber-500/30">Em aberto</Badge>}
          {day.odd && <Badge variant="outline" className="text-red-500 border-red-500/30">Batida ímpar</Badge>}
        </div>
      </div>
      <div className="grid gap-2 sm:grid-cols-2">
        {day.punches.map((p) => <PunchRow key={p.id} punch={p} />)}
      </div>
    </div>
  );
}

export default function MyTimeclockPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [note, setNote] = useState("");

  const { data: today, isLoading } = useQuery({
    queryKey: ["timeclock-today"],
    queryFn: timeclockApi.today,
  });

  const { data: history = [] } = useQuery({
    queryKey: ["timeclock-my"],
    queryFn: () => timeclockApi.my(),
  });

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
        <div className="flex items-center gap-3">
          <Clock className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Meu Ponto</h1>
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
            {/* Card de batida */}
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

              <Input
                value={note}
                onChange={(e) => setNote(e.target.value)}
                placeholder="Observação (opcional) — ex.: saída para o médico"
              />

              <Button
                size="lg"
                className="w-full h-14 text-base"
                onClick={() => punchMutation.mutate()}
                disabled={punchMutation.isPending}
              >
                {nextIsIn ? <LogIn className="h-5 w-5 mr-2" /> : <LogOut className="h-5 w-5 mr-2" />}
                {punchMutation.isPending ? "Registrando..." : nextIsIn ? "Registrar Entrada" : "Registrar Saída"}
              </Button>
              <p className="flex items-center justify-center gap-1.5 text-xs text-muted-foreground">
                <MapPin className="h-3.5 w-3.5" /> A localização é capturada ao bater (se você permitir).
              </p>
            </div>

            {/* Batidas de hoje */}
            {today.punches.length > 0 && (
              <div className="space-y-2">
                <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">Hoje</h2>
                <div className="grid gap-2 sm:grid-cols-2">
                  {today.punches.map((p) => <PunchRow key={p.id} punch={p} />)}
                </div>
              </div>
            )}

            {/* Histórico */}
            <div className="space-y-3">
              <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">Histórico</h2>
              {history.filter((d) => d.work_date !== today.work_date).length === 0 ? (
                <p className="text-sm text-muted-foreground">Nenhum registro anterior.</p>
              ) : (
                history
                  .filter((d) => d.work_date !== today.work_date)
                  .map((d) => <DayCard key={d.work_date} day={d} />)
              )}
            </div>
          </>
        )}
      </div>
    </AdminLayout>
  );
}
