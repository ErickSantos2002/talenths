import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { calendar as calendarApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
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
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import type { CalendarEvent, FeedEntry, CalendarEventType } from "@/types/calendar";
import { CalendarDays, ChevronLeft, ChevronRight, Plus, Pencil, Trash2 } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Constants ─────────────────────────────────────────────────────────────────

const EVENT_TYPE_LABELS: Record<string, string> = {
  event: "Evento",
  holiday: "Feriado",
  deadline: "Prazo",
  meeting: "Reunião",
  training: "Treinamento",
  absence: "Ausência",
  birthday: "Aniversário",
};

const EVENT_TYPE_COLORS: Record<string, string> = {
  event: "#6366f1",
  holiday: "#ef4444",
  deadline: "#f59e0b",
  meeting: "#3b82f6",
  training: "#10b981",
  absence: "#6b7280",
  birthday: "#ec4899",
};

const MONTHS = [
  "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
  "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
];

const WEEKDAYS = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];

// ── Event Dialog ──────────────────────────────────────────────────────────────

function EventDialog({
  event,
  defaultDate,
  onClose,
}: {
  event?: CalendarEvent;
  defaultDate?: string;
  onClose: () => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [title, setTitle] = useState(event?.title ?? "");
  const [description, setDescription] = useState(event?.description ?? "");
  const [eventType, setEventType] = useState<CalendarEventType>(event?.event_type ?? "event");
  const [color, setColor] = useState(event?.color ?? "#6366f1");
  const [startDate, setStartDate] = useState(event?.start_date ?? defaultDate ?? "");
  const [endDate, setEndDate] = useState(event?.end_date ?? defaultDate ?? "");
  const [colorOverride, setColorOverride] = useState(!!event?.color);

  const handleTypeChange = (t: CalendarEventType) => {
    setEventType(t);
    if (!colorOverride) setColor(EVENT_TYPE_COLORS[t] ?? "#6366f1");
  };

  const mutation = useMutation({
    mutationFn: () => {
      const data = { title, description: description || undefined, event_type: eventType, color, start_date: startDate, end_date: endDate || startDate };
      return event
        ? calendarApi.updateEvent(event.id, data)
        : calendarApi.createEvent(data);
    },
    onSuccess: () => {
      toast({ title: event ? "Evento atualizado!" : "Evento criado!" });
      queryClient.invalidateQueries({ queryKey: ["calendar-feed"] });
      queryClient.invalidateQueries({ queryKey: ["calendar-events"] });
      onClose();
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{event ? "Editar evento" : "Novo evento"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1">
            <Label>Título</Label>
            <Input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Nome do evento" />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Tipo</Label>
              <Select value={eventType} onValueChange={(v) => handleTypeChange(v as CalendarEventType)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="event">Evento</SelectItem>
                  <SelectItem value="holiday">Feriado</SelectItem>
                  <SelectItem value="deadline">Prazo</SelectItem>
                  <SelectItem value="meeting">Reunião</SelectItem>
                  <SelectItem value="training">Treinamento</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-1">
              <Label>Cor</Label>
              <div className="flex items-center gap-2">
                <input
                  type="color"
                  value={color}
                  onChange={(e) => { setColor(e.target.value); setColorOverride(true); }}
                  className="h-9 w-16 cursor-pointer rounded border"
                />
                <span className="text-xs text-muted-foreground">{color}</span>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Data de início</Label>
              <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label>Data de fim</Label>
              <Input type="date" value={endDate} min={startDate} onChange={(e) => setEndDate(e.target.value)} />
            </div>
          </div>

          <div className="space-y-1">
            <Label>Descrição (opcional)</Label>
            <Textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Detalhes do evento..."
              rows={2}
              className="resize-none"
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!title.trim() || !startDate || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Calendar Grid ─────────────────────────────────────────────────────────────

function getDaysInMonth(year: number, month: number) {
  return new Date(year, month + 1, 0).getDate();
}

function getFirstDayOfMonth(year: number, month: number) {
  return new Date(year, month, 1).getDay();
}

function isSameDate(dateStr: string, year: number, month: number, day: number): boolean {
  const d = new Date(dateStr + "T12:00:00");
  return d.getFullYear() === year && d.getMonth() === month && d.getDate() === day;
}

function isInRange(entry: FeedEntry, year: number, month: number, day: number): boolean {
  if (entry.recurring_monthly) {
    const [mm, dd] = entry.start_date.split("-").map(Number);
    return mm === month + 1 && dd === day;
  }
  const start = new Date(entry.start_date + "T00:00:00");
  const end = new Date(entry.end_date + "T23:59:59");
  const target = new Date(year, month, day);
  return target >= start && target <= end;
}

interface CalendarGridProps {
  year: number;
  month: number;
  feed: FeedEntry[];
  isAdmin: boolean;
  onDayClick: (dateStr: string) => void;
  onEditEvent: (event: CalendarEvent) => void;
  onDeleteEvent: (id: string) => void;
  managerEvents: CalendarEvent[];
}

function CalendarGrid({ year, month, feed, isAdmin, onDayClick, onEditEvent, onDeleteEvent, managerEvents }: CalendarGridProps) {
  const daysInMonth = getDaysInMonth(year, month);
  const firstDay = getFirstDayOfMonth(year, month);
  const today = new Date();

  const cells: (number | null)[] = [
    ...Array(firstDay).fill(null),
    ...Array.from({ length: daysInMonth }, (_, i) => i + 1),
  ];

  while (cells.length % 7 !== 0) cells.push(null);

  return (
    <div>
      <div className="grid grid-cols-7 mb-1">
        {WEEKDAYS.map((d) => (
          <div key={d} className="py-2 text-center text-xs font-semibold text-muted-foreground">
            {d}
          </div>
        ))}
      </div>
      <div className="grid grid-cols-7 gap-px bg-border rounded-lg overflow-hidden">
        {cells.map((day, i) => {
          if (!day) return <div key={i} className="bg-muted/20 min-h-[80px]" />;

          const isToday =
            today.getFullYear() === year &&
            today.getMonth() === month &&
            today.getDate() === day;

          const dayFeed = feed.filter((e) => isInRange(e, year, month, day));
          const dateStr = `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;

          return (
            <div
              key={i}
              className={cn(
                "bg-background min-h-[80px] p-1.5 cursor-pointer hover:bg-muted/30 transition-colors",
                isToday && "bg-primary/5"
              )}
              onClick={() => isAdmin && onDayClick(dateStr)}
            >
              <div className={cn(
                "text-xs font-medium mb-1 h-5 w-5 flex items-center justify-center rounded-full",
                isToday ? "bg-primary text-primary-foreground" : "text-foreground"
              )}>
                {day}
              </div>
              <div className="space-y-0.5">
                {dayFeed.slice(0, 3).map((e) => (
                  <div
                    key={e.id}
                    className="text-[10px] leading-tight rounded px-1 py-0.5 text-white truncate"
                    style={{ backgroundColor: e.color }}
                    onClick={(ev) => {
                      ev.stopPropagation();
                      if (isAdmin && e.source === "event") {
                        const full = managerEvents.find((me) => me.id === e.id);
                        if (full) onEditEvent(full);
                      }
                    }}
                    title={e.title}
                  >
                    {e.title}
                  </div>
                ))}
                {dayFeed.length > 3 && (
                  <div className="text-[10px] text-muted-foreground px-1">
                    +{dayFeed.length - 3} mais
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ── Upcoming Events List ──────────────────────────────────────────────────────

function UpcomingList({ feed }: { feed: FeedEntry[] }) {
  const now = new Date();
  const upcoming = feed
    .filter((e) => !e.recurring_monthly && new Date(e.end_date + "T23:59:59") >= now)
    .slice(0, 8);

  if (upcoming.length === 0) {
    return <p className="text-xs text-muted-foreground">Nenhum evento próximo.</p>;
  }

  return (
    <div className="space-y-2">
      {upcoming.map((e) => (
        <div key={e.id} className="flex items-start gap-2">
          <div className="mt-1 h-2.5 w-2.5 rounded-full shrink-0" style={{ backgroundColor: e.color }} />
          <div className="min-w-0">
            <p className="text-xs font-medium truncate">{e.title}</p>
            <p className="text-[10px] text-muted-foreground">
              {new Date(e.start_date + "T12:00:00").toLocaleDateString("pt-BR", { day: "2-digit", month: "short" })}
              {e.start_date !== e.end_date && ` – ${new Date(e.end_date + "T12:00:00").toLocaleDateString("pt-BR", { day: "2-digit", month: "short" })}`}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function CalendarPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");

  const today = new Date();
  const [year, setYear] = useState(today.getFullYear());
  const [month, setMonth] = useState(today.getMonth());
  const [dialog, setDialog] = useState<{ open: boolean; event?: CalendarEvent; date?: string }>({ open: false });

  const { data: feed = [] } = useQuery({
    queryKey: ["calendar-feed"],
    queryFn: calendarApi.feed,
  });

  const { data: managerEvents = [] } = useQuery({
    queryKey: ["calendar-events"],
    queryFn: calendarApi.events,
    enabled: isAdmin,
  });

  const deleteMutation = useMutation({
    mutationFn: calendarApi.deleteEvent,
    onSuccess: () => {
      toast({ title: "Evento removido." });
      queryClient.invalidateQueries({ queryKey: ["calendar-feed"] });
      queryClient.invalidateQueries({ queryKey: ["calendar-events"] });
    },
    onError: (e: Error) =>
      toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const prevMonth = () => {
    if (month === 0) { setMonth(11); setYear(y => y - 1); }
    else setMonth(m => m - 1);
  };

  const nextMonth = () => {
    if (month === 11) { setMonth(0); setYear(y => y + 1); }
    else setMonth(m => m + 1);
  };

  return (
    <AdminLayout>
      <div className="space-y-6">
        {dialog.open && (
          <EventDialog
            event={dialog.event}
            defaultDate={dialog.date}
            onClose={() => setDialog({ open: false })}
          />
        )}

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <CalendarDays className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Calendário</h1>
          </div>
          {isAdmin && (
            <Button onClick={() => setDialog({ open: true })}>
              <Plus className="h-4 w-4 mr-2" />
              Novo evento
            </Button>
          )}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          <div className="lg:col-span-3 space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold">
                {MONTHS[month]} {year}
              </h2>
              <div className="flex gap-1">
                <Button variant="outline" size="icon" className="h-8 w-8" onClick={prevMonth}>
                  <ChevronLeft className="h-4 w-4" />
                </Button>
                <Button variant="outline" size="sm" onClick={() => { setYear(today.getFullYear()); setMonth(today.getMonth()); }}>
                  Hoje
                </Button>
                <Button variant="outline" size="icon" className="h-8 w-8" onClick={nextMonth}>
                  <ChevronRight className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <CalendarGrid
              year={year}
              month={month}
              feed={feed}
              isAdmin={isAdmin}
              onDayClick={(date) => setDialog({ open: true, date })}
              onEditEvent={(event) => setDialog({ open: true, event })}
              onDeleteEvent={(id) => {
                if (confirm("Remover este evento?")) deleteMutation.mutate(id);
              }}
              managerEvents={managerEvents}
            />

            {/* Legend */}
            <div className="flex flex-wrap gap-3 pt-1">
              {(Object.entries(EVENT_TYPE_LABELS) as [string, string][])
                .filter(([k]) => !["absence", "birthday"].includes(k))
                .map(([type, label]) => (
                  <div key={type} className="flex items-center gap-1.5 text-xs text-muted-foreground">
                    <div className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: EVENT_TYPE_COLORS[type] }} />
                    {label}
                  </div>
                ))}
              <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
                <div className="h-2.5 w-2.5 rounded-full bg-[#6b7280]" />
                Ausências
              </div>
              <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
                <div className="h-2.5 w-2.5 rounded-full bg-[#ec4899]" />
                Aniversários
              </div>
            </div>
          </div>

          <div className="space-y-4">
            <Card>
              <CardContent className="p-4 space-y-3">
                <h3 className="text-sm font-semibold">Próximos eventos</h3>
                <UpcomingList feed={feed} />
              </CardContent>
            </Card>

            {isAdmin && managerEvents.length > 0 && (
              <Card>
                <CardContent className="p-4 space-y-2">
                  <h3 className="text-sm font-semibold">Gerenciar eventos</h3>
                  <div className="space-y-1.5">
                    {managerEvents.slice(0, 6).map((e) => (
                      <div key={e.id} className="flex items-center gap-2">
                        <div className="h-2.5 w-2.5 rounded-full shrink-0" style={{ backgroundColor: e.color }} />
                        <span className="text-xs flex-1 truncate">{e.title}</span>
                        <div className="flex gap-0.5 shrink-0">
                          <button
                            onClick={() => setDialog({ open: true, event: e })}
                            className="text-muted-foreground hover:text-foreground p-0.5"
                          >
                            <Pencil className="h-3 w-3" />
                          </button>
                          <button
                            onClick={() => {
                              if (confirm(`Remover "${e.title}"?`)) deleteMutation.mutate(e.id);
                            }}
                            className="text-muted-foreground hover:text-destructive p-0.5"
                          >
                            <Trash2 className="h-3 w-3" />
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </div>
    </AdminLayout>
  );
}
