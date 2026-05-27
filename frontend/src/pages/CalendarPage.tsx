import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { calendar as calendarApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import type { CalendarEvent, FeedEntry, CalendarEventType } from "@/types/calendar";
import { CalendarDays, ChevronLeft, ChevronRight, Plus, Pencil, Trash2 } from "lucide-react";
import { cn } from "@/lib/utils";

// ─── Constants ────────────────────────────────────────────────────────────────
const EVENT_TYPE_LABELS: Record<string, string> = {
  event: "Evento", holiday: "Feriado", deadline: "Prazo",
  meeting: "Reunião", training: "Treinamento", absence: "Ausências", birthday: "Aniversários",
};

const EVENT_TYPE_COLORS: Record<string, string> = {
  event: "#6366f1", holiday: "#ef4444", deadline: "#f59e0b",
  meeting: "#3b82f6", training: "#10b981", absence: "#6b7280", birthday: "#ec4899",
};

const MONTHS = [
  "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
  "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
];

const MONTHS_SHORT = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];

const WEEKDAYS_FULL = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"];
const WEEKDAYS = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];

const CURRENT_YEAR = new Date().getFullYear();
const YEARS = Array.from({ length: 11 }, (_, i) => CURRENT_YEAR - 2 + i);

// ─── Event Dialog ─────────────────────────────────────────────────────────────
function EventDialog({ event, defaultDate, onClose }: {
  event?: CalendarEvent; defaultDate?: string; onClose: () => void;
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
      return event ? calendarApi.updateEvent(event.id, data) : calendarApi.createEvent(data);
    },
    onSuccess: () => {
      toast({ title: event ? "Evento atualizado!" : "Evento criado!" });
      queryClient.invalidateQueries({ queryKey: ["calendar-feed"] });
      queryClient.invalidateQueries({ queryKey: ["calendar-events"] });
      onClose();
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{event ? "Editar evento" : "Novo evento"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Nome do evento" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Tipo</Label>
              <Select value={eventType} onValueChange={(v) => handleTypeChange(v as CalendarEventType)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {["event","holiday","deadline","meeting","training"].map(t => (
                    <SelectItem key={t} value={t}>{EVENT_TYPE_LABELS[t]}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Cor</Label>
              <div className="flex items-center gap-2">
                <input type="color" value={color}
                  onChange={(e) => { setColor(e.target.value); setColorOverride(true); }}
                  className="h-9 w-14 cursor-pointer rounded border border-border bg-transparent"
                />
                <span className="text-xs text-muted-foreground font-mono">{color}</span>
              </div>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Data de início</Label>
              <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Data de fim</Label>
              <Input type="date" value={endDate} min={startDate} onChange={(e) => setEndDate(e.target.value)} />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Descrição (opcional)</Label>
            <Textarea value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Detalhes do evento..." rows={2} className="resize-none" />
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

// ─── Helpers ──────────────────────────────────────────────────────────────────
function getDaysInMonth(year: number, month: number) {
  return new Date(year, month + 1, 0).getDate();
}
function getFirstDayOfMonth(year: number, month: number) {
  return new Date(year, month, 1).getDay();
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

// ─── Day Detail Panel ─────────────────────────────────────────────────────────
function DayDetailPanel({ date, events, isAdmin, onAddEvent, onEditEvent, onDeleteEvent, onClose }: {
  date: Date; events: FeedEntry[]; isAdmin: boolean;
  onAddEvent: (dateStr: string) => void;
  onEditEvent: (event: CalendarEvent) => void;
  onDeleteEvent: (id: string) => void;
  onClose: () => void;
  managerEvents: CalendarEvent[];
}) {
  const dateStr = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
  return (
    <div className="rounded-xl border border-border bg-card p-4 space-y-3">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-xs text-muted-foreground font-medium uppercase tracking-wide">{WEEKDAYS_FULL[date.getDay()]}</p>
          <p className="text-xl font-bold">{date.getDate()} de {MONTHS[date.getMonth()]}</p>
        </div>
        <div className="flex items-center gap-2">
          {isAdmin && (
            <button
              onClick={() => onAddEvent(dateStr)}
              className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary hover:bg-primary/20 transition-colors"
            >
              <Plus className="h-4 w-4" />
            </button>
          )}
          <button onClick={onClose} className="flex h-8 w-8 items-center justify-center rounded-lg bg-muted text-muted-foreground hover:bg-muted/80 transition-colors text-sm">✕</button>
        </div>
      </div>
      {events.length === 0 ? (
        <p className="text-sm text-muted-foreground py-2">Nenhum evento neste dia.</p>
      ) : (
        <div className="space-y-2">
          {events.map((e) => (
            <div key={e.id} className="flex items-center gap-2.5 rounded-lg border border-border bg-background px-3 py-2">
              <div className="h-2.5 w-2.5 shrink-0 rounded-full" style={{ backgroundColor: e.color }} />
              <span className="flex-1 text-sm font-medium truncate">{e.title}</span>
              <span className="text-[10px] text-muted-foreground shrink-0">{EVENT_TYPE_LABELS[e.event_type] ?? e.event_type}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// ─── Calendar Grid ────────────────────────────────────────────────────────────
function CalendarGrid({ year, month, feed, isAdmin, onDayClick, onEditEvent, managerEvents, selectedDay, onSelectDay }: {
  year: number; month: number; feed: FeedEntry[]; isAdmin: boolean;
  onDayClick: (dateStr: string) => void;
  onEditEvent: (event: CalendarEvent) => void;
  managerEvents: CalendarEvent[];
  selectedDay: number | null;
  onSelectDay: (day: number) => void;
}) {
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
      {/* Weekday headers */}
      <div className="grid grid-cols-7 mb-2">
        {WEEKDAYS.map((d) => (
          <div key={d} className="py-2 text-center text-xs font-semibold text-muted-foreground uppercase tracking-wide">{d}</div>
        ))}
      </div>
      {/* Grid */}
      <div className="grid grid-cols-7 gap-px bg-border rounded-xl overflow-hidden border border-border">
        {cells.map((day, i) => {
          if (!day) return <div key={i} className="bg-card/40 min-h-[90px]" />;

          const isToday = today.getFullYear() === year && today.getMonth() === month && today.getDate() === day;
          const isSelected = selectedDay === day;
          const dayFeed = feed.filter((e) => isInRange(e, year, month, day));
          const isWeekend = (firstDay + day - 1) % 7 === 0 || (firstDay + day - 1) % 7 === 6;

          return (
            <div
              key={i}
              onClick={() => { onSelectDay(day); isAdmin && onDayClick(`${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`); }}
              className={cn(
                "min-h-[90px] p-2 cursor-pointer transition-colors group",
                isSelected ? "bg-primary/8 ring-1 ring-inset ring-primary/30" : "bg-card hover:bg-muted/30",
                isWeekend && !isSelected && "bg-muted/10",
              )}
            >
              <div className={cn(
                "text-xs font-semibold mb-1.5 h-6 w-6 flex items-center justify-center rounded-full transition-colors",
                isToday ? "bg-primary text-primary-foreground shadow-sm" : isSelected ? "text-primary font-bold" : "text-foreground/70 group-hover:text-foreground"
              )}>
                {day}
              </div>
              <div className="space-y-0.5">
                {dayFeed.slice(0, 3).map((e) => (
                  <div
                    key={e.id}
                    className="flex items-center gap-1 text-[10px] leading-tight rounded-md px-1.5 py-0.5 text-white truncate"
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
                  <div className="text-[10px] text-muted-foreground px-1 font-medium">+{dayFeed.length - 3}</div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ─── Upcoming Events ──────────────────────────────────────────────────────────
function UpcomingList({ feed }: { feed: FeedEntry[] }) {
  const now = new Date();
  const upcoming = feed
    .filter((e) => !e.recurring_monthly && new Date(e.end_date + "T23:59:59") >= now)
    .slice(0, 6);

  if (upcoming.length === 0) {
    return <p className="text-xs text-muted-foreground py-2">Nenhum evento próximo.</p>;
  }

  return (
    <div className="space-y-2">
      {upcoming.map((e) => (
        <div key={e.id} className="flex items-start gap-2.5 rounded-lg bg-muted/30 px-3 py-2">
          <div className="mt-1 h-2.5 w-2.5 shrink-0 rounded-full" style={{ backgroundColor: e.color }} />
          <div className="min-w-0 flex-1">
            <p className="text-xs font-medium truncate">{e.title}</p>
            <p className="text-[10px] text-muted-foreground mt-0.5">
              {new Date(e.start_date + "T12:00:00").toLocaleDateString("pt-BR", { day: "2-digit", month: "short" })}
              {e.start_date !== e.end_date && ` → ${new Date(e.end_date + "T12:00:00").toLocaleDateString("pt-BR", { day: "2-digit", month: "short" })}`}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── Page ─────────────────────────────────────────────────────────────────────
export default function CalendarPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");

  const today = new Date();
  const [year, setYear] = useState(today.getFullYear());
  const [month, setMonth] = useState(today.getMonth());
  const [selectedDay, setSelectedDay] = useState<number | null>(null);
  const [dialog, setDialog] = useState<{ open: boolean; event?: CalendarEvent; date?: string }>({ open: false });

  const { data: feed = [] } = useQuery({ queryKey: ["calendar-feed"], queryFn: calendarApi.feed });
  const { data: managerEvents = [] } = useQuery({ queryKey: ["calendar-events"], queryFn: calendarApi.events, enabled: isAdmin });

  const deleteMutation = useMutation({
    mutationFn: calendarApi.deleteEvent,
    onSuccess: () => {
      toast({ title: "Evento removido." });
      queryClient.invalidateQueries({ queryKey: ["calendar-feed"] });
      queryClient.invalidateQueries({ queryKey: ["calendar-events"] });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const goToToday = () => { setYear(today.getFullYear()); setMonth(today.getMonth()); setSelectedDay(today.getDate()); };
  const prevMonth = () => { if (month === 0) { setMonth(11); setYear(y => y - 1); } else setMonth(m => m - 1); setSelectedDay(null); };
  const nextMonth = () => { if (month === 11) { setMonth(0); setYear(y => y + 1); } else setMonth(m => m + 1); setSelectedDay(null); };

  const selectedDate = selectedDay ? new Date(year, month, selectedDay) : null;
  const selectedDayFeed = selectedDay ? feed.filter((e) => isInRange(e, year, month, selectedDay)) : [];

  return (
    <AdminLayout>
      <div className="space-y-5">
        {dialog.open && (
          <EventDialog event={dialog.event} defaultDate={dialog.date} onClose={() => setDialog({ open: false })} />
        )}

        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <CalendarDays className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Calendário</h1>
          </div>
          {isAdmin && (
            <Button onClick={() => setDialog({ open: true })}>
              <Plus className="h-4 w-4 mr-2" /> Novo evento
            </Button>
          )}
        </div>

        {/* Navigation bar */}
        <div className="flex flex-wrap items-center gap-2">
          <button onClick={prevMonth} className="flex h-8 w-8 items-center justify-center rounded-lg border border-border bg-background text-muted-foreground hover:bg-muted transition-colors">
            <ChevronLeft className="h-4 w-4" />
          </button>

          {/* Month select */}
          <Select value={String(month)} onValueChange={(v) => { setMonth(Number(v)); setSelectedDay(null); }}>
            <SelectTrigger className="w-36 h-8 text-sm font-semibold">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {MONTHS.map((m, i) => (
                <SelectItem key={i} value={String(i)}>{m}</SelectItem>
              ))}
            </SelectContent>
          </Select>

          {/* Year select */}
          <Select value={String(year)} onValueChange={(v) => { setYear(Number(v)); setSelectedDay(null); }}>
            <SelectTrigger className="w-24 h-8 text-sm font-semibold">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {YEARS.map((y) => (
                <SelectItem key={y} value={String(y)}>{y}</SelectItem>
              ))}
            </SelectContent>
          </Select>

          <button onClick={nextMonth} className="flex h-8 w-8 items-center justify-center rounded-lg border border-border bg-background text-muted-foreground hover:bg-muted transition-colors">
            <ChevronRight className="h-4 w-4" />
          </button>

          <button onClick={goToToday} className="h-8 rounded-lg border border-primary/30 bg-primary/10 px-3 text-sm font-medium text-primary hover:bg-primary/20 transition-colors">
            Hoje
          </button>
        </div>

        {/* Main layout */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-5">
          {/* Calendar */}
          <div className="lg:col-span-3 space-y-4">
            <CalendarGrid
              year={year} month={month} feed={feed} isAdmin={isAdmin}
              onDayClick={(date) => setDialog({ open: true, date })}
              onEditEvent={(event) => setDialog({ open: true, event })}
              managerEvents={managerEvents}
              selectedDay={selectedDay}
              onSelectDay={setSelectedDay}
            />

            {/* Legend */}
            <div className="flex flex-wrap gap-x-4 gap-y-2 pt-1">
              {Object.entries(EVENT_TYPE_LABELS).map(([type, label]) => (
                <div key={type} className="flex items-center gap-1.5 text-xs text-muted-foreground">
                  <div className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: EVENT_TYPE_COLORS[type] }} />
                  {label}
                </div>
              ))}
            </div>

            {/* Day detail */}
            {selectedDate && (
              <DayDetailPanel
                date={selectedDate}
                events={selectedDayFeed}
                isAdmin={isAdmin}
                onAddEvent={(date) => setDialog({ open: true, date })}
                onEditEvent={(event) => setDialog({ open: true, event })}
                onDeleteEvent={(id) => { if (confirm("Remover este evento?")) deleteMutation.mutate(id); }}
                onClose={() => setSelectedDay(null)}
                managerEvents={managerEvents}
              />
            )}
          </div>

          {/* Sidebar */}
          <div className="space-y-4">
            {/* Upcoming */}
            <div className="rounded-xl border border-border bg-card p-4 space-y-3">
              <h3 className="text-sm font-semibold">Próximos eventos</h3>
              <UpcomingList feed={feed} />
            </div>

            {/* Manage events */}
            {isAdmin && managerEvents.length > 0 && (
              <div className="rounded-xl border border-border bg-card p-4 space-y-3">
                <h3 className="text-sm font-semibold">Gerenciar eventos</h3>
                <div className="space-y-1.5">
                  {managerEvents.slice(0, 8).map((e) => (
                    <div key={e.id} className="flex items-center gap-2 rounded-lg bg-muted/20 px-2.5 py-1.5">
                      <div className="h-2 w-2 shrink-0 rounded-full" style={{ backgroundColor: e.color }} />
                      <span className="flex-1 text-xs truncate">{e.title}</span>
                      <div className="flex gap-1 shrink-0">
                        <button
                          onClick={() => setDialog({ open: true, event: e })}
                          className="flex h-6 w-6 items-center justify-center rounded-md bg-amber-500/15 text-amber-500 hover:bg-amber-500/25 transition-colors"
                        >
                          <Pencil className="h-3 w-3" />
                        </button>
                        <button
                          onClick={() => { if (confirm(`Remover "${e.title}"?`)) deleteMutation.mutate(e.id); }}
                          className="flex h-6 w-6 items-center justify-center rounded-md bg-destructive/15 text-destructive hover:bg-destructive/25 transition-colors"
                        >
                          <Trash2 className="h-3 w-3" />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Mini month map */}
            <div className="rounded-xl border border-border bg-card p-4 space-y-2">
              <h3 className="text-sm font-semibold mb-3">Meses do ano</h3>
              <div className="grid grid-cols-3 gap-1.5">
                {MONTHS_SHORT.map((m, i) => {
                  const hasEvents = feed.some((e) => {
                    if (e.recurring_monthly) {
                      const [mm] = e.start_date.split("-").map(Number);
                      return mm === i + 1;
                    }
                    const s = new Date(e.start_date + "T00:00:00");
                    const en = new Date(e.end_date + "T23:59:59");
                    return (s.getFullYear() === year && s.getMonth() === i) ||
                           (en.getFullYear() === year && en.getMonth() === i);
                  });
                  const isCurrent = i === month;
                  const isCurrentMonth = i === today.getMonth() && year === today.getFullYear();
                  return (
                    <button
                      key={i}
                      onClick={() => { setMonth(i); setSelectedDay(null); }}
                      className={cn(
                        "relative rounded-lg py-1.5 text-xs font-medium transition-colors",
                        isCurrent ? "bg-primary text-primary-foreground" : "bg-muted/30 text-muted-foreground hover:bg-muted hover:text-foreground"
                      )}
                    >
                      {m}
                      {hasEvents && !isCurrent && (
                        <span className="absolute top-0.5 right-1 h-1.5 w-1.5 rounded-full bg-primary/60" />
                      )}
                      {isCurrentMonth && !isCurrent && (
                        <span className="absolute bottom-0.5 left-1/2 -translate-x-1/2 h-0.5 w-3 rounded-full bg-primary/40" />
                      )}
                    </button>
                  );
                })}
              </div>
            </div>
          </div>
        </div>
      </div>
    </AdminLayout>
  );
}
