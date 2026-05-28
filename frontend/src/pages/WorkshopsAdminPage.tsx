import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { workshops as workshopsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import { useToast } from "@/hooks/use-toast";
import type { Workshop, WorkshopRegistration, WorkshopStatus } from "@/types/workshops";
import { WORKSHOP_STATUS_LABELS, WORKSHOP_STATUS_COLORS } from "@/types/workshops";
import { CalendarDays, MapPin, Users, Plus, Pencil, Trash2, CheckSquare, Clock } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Helpers ───────────────────────────────────────────────────────────────────

function formatDatetime(iso: string) {
  const d = new Date(iso);
  return d.toLocaleString("pt-BR", { dateStyle: "short", timeStyle: "short" });
}

function seatsLabel(w: Workshop) {
  if (!w.max_seats) return `${w.seats_taken} inscritos`;
  return `${w.seats_taken}/${w.max_seats} vagas`;
}

// ── Workshop Form Dialog ──────────────────────────────────────────────────────

const EMPTY_FORM = {
  title: "", area: "", description: "", location: "",
  starts_at: "", ends_at: "", max_seats: "", status: "open" as WorkshopStatus,
};

function WorkshopDialog({ workshop, onOpenChange, onSaved }: {
  workshop: Workshop | null;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const toLocal = (iso: string) => iso ? iso.slice(0, 16) : "";

  const [form, setForm] = useState(workshop ? {
    title: workshop.title,
    area: workshop.area,
    description: workshop.description ?? "",
    location: workshop.location ?? "",
    starts_at: toLocal(workshop.starts_at),
    ends_at: toLocal(workshop.ends_at),
    max_seats: workshop.max_seats ? String(workshop.max_seats) : "",
    status: workshop.status,
  } : { ...EMPTY_FORM });

  const set = (k: string, v: string) => setForm(f => ({ ...f, [k]: v }));

  const mutation = useMutation({
    mutationFn: () => {
      const data = {
        ...form,
        max_seats: form.max_seats ? parseInt(form.max_seats) : null,
      };
      return workshop ? workshopsApi.update(workshop.id, data) : workshopsApi.create(data);
    },
    onSuccess: () => {
      toast({ title: workshop ? "Workshop atualizado" : "Workshop criado" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const valid = form.title && form.area && form.starts_at && form.ends_at;

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>{workshop ? "Editar Workshop" : "Novo Workshop"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={form.title} onChange={e => set("title", e.target.value)} placeholder="Ex: Workshop de Comunicação" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Área</Label>
              <Input value={form.area} onChange={e => set("area", e.target.value)} placeholder="Ex: Liderança" />
            </div>
            <div className="space-y-1.5">
              <Label>Status</Label>
              <Select value={form.status} onValueChange={v => set("status", v)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="draft">Rascunho</SelectItem>
                  <SelectItem value="open">Inscrições abertas</SelectItem>
                  <SelectItem value="closed">Inscrições encerradas</SelectItem>
                  <SelectItem value="done">Realizado</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Início</Label>
              <Input type="datetime-local" value={form.starts_at} onChange={e => set("starts_at", e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Fim</Label>
              <Input type="datetime-local" value={form.ends_at} onChange={e => set("ends_at", e.target.value)} />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Local <span className="text-muted-foreground font-normal">(opcional)</span></Label>
              <Input value={form.location} onChange={e => set("location", e.target.value)} placeholder="Ex: Sala de Reuniões A" />
            </div>
            <div className="space-y-1.5">
              <Label>Vagas <span className="text-muted-foreground font-normal">(opcional)</span></Label>
              <Input type="number" min="1" value={form.max_seats} onChange={e => set("max_seats", e.target.value)} placeholder="Ilimitado" />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={form.description} onChange={e => set("description", e.target.value)} rows={2} className="resize-none" />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!valid || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Attendance Sheet ──────────────────────────────────────────────────────────

function AttendanceSheet({ workshop, onClose }: { workshop: Workshop; onClose: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [attended, setAttended] = useState<Record<string, boolean>>({});
  const [initialized, setInitialized] = useState(false);

  const { data: registrations = [], isLoading } = useQuery({
    queryKey: ["workshop-registrations", workshop.id],
    queryFn: () => workshopsApi.registrations(workshop.id),
    onSuccess: (data: WorkshopRegistration[]) => {
      if (!initialized) {
        const init: Record<string, boolean> = {};
        data.forEach(r => { init[r.user_id] = r.status === "attended"; });
        setAttended(init);
        setInitialized(true);
      }
    },
  } as Parameters<typeof useQuery>[0]);

  const saveMutation = useMutation({
    mutationFn: () => workshopsApi.markAttendance(
      workshop.id,
      registrations.map(r => ({ user_id: r.user_id, attended: attended[r.user_id] ?? false }))
    ),
    onSuccess: () => {
      toast({ title: "Presença registrada" });
      queryClient.invalidateQueries({ queryKey: ["workshops"] });
      onClose();
    },
    onError: () => toast({ title: "Erro ao salvar presença", variant: "destructive" }),
  });

  return (
    <Sheet open onOpenChange={onClose}>
      <SheetContent className="w-full sm:max-w-md overflow-y-auto">
        <SheetHeader className="mb-4">
          <SheetTitle>Presença — {workshop.title}</SheetTitle>
        </SheetHeader>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando inscritos...</p>
        ) : registrations.length === 0 ? (
          <p className="text-sm text-muted-foreground">Nenhum inscrito ainda.</p>
        ) : (
          <div className="space-y-2">
            {registrations.map(r => (
              <div key={r.user_id} className="flex items-center gap-3 rounded-lg border px-3 py-2.5">
                <Checkbox
                  id={r.user_id}
                  checked={attended[r.user_id] ?? false}
                  onCheckedChange={v => setAttended(prev => ({ ...prev, [r.user_id]: !!v }))}
                />
                <label htmlFor={r.user_id} className="flex-1 min-w-0 cursor-pointer">
                  <p className="text-sm font-medium">{r.user_name ?? r.user_email}</p>
                  {r.department && <p className="text-xs text-muted-foreground">{r.department}</p>}
                </label>
              </div>
            ))}
          </div>
        )}

        {registrations.length > 0 && (
          <div className="mt-4 flex gap-2">
            <Button className="flex-1" onClick={() => saveMutation.mutate()} disabled={saveMutation.isPending}>
              {saveMutation.isPending ? "Salvando..." : "Salvar presenças"}
            </Button>
            <Button variant="ghost" onClick={onClose}>Cancelar</Button>
          </div>
        )}
      </SheetContent>
    </Sheet>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function WorkshopsAdminPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [editingWorkshop, setEditingWorkshop] = useState<Workshop | null | undefined>(undefined);
  const [attendanceWorkshop, setAttendanceWorkshop] = useState<Workshop | null>(null);

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["workshops"],
    queryFn: workshopsApi.list,
  });

  const deleteMutation = useMutation({
    mutationFn: workshopsApi.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["workshops"] });
      toast({ title: "Workshop removido" });
    },
    onError: () => toast({ title: "Erro ao remover", variant: "destructive" }),
  });

  const upcoming = list.filter(w => w.status !== "done");
  const done = list.filter(w => w.status === "done");

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <CalendarDays className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Programa de Desenvolvimento</h1>
          </div>
          <Button size="sm" onClick={() => setEditingWorkshop(null)}>
            <Plus className="h-4 w-4 mr-1" /> Novo Workshop
          </Button>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : list.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <CalendarDays className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-4">Nenhum workshop cadastrado ainda.</p>
            <Button onClick={() => setEditingWorkshop(null)}>
              <Plus className="h-4 w-4 mr-2" /> Criar primeiro workshop
            </Button>
          </div>
        ) : (
          <div className="space-y-6">
            {upcoming.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Próximos</h2>
                {upcoming.map(w => (
                  <WorkshopCard
                    key={w.id}
                    workshop={w}
                    onEdit={() => setEditingWorkshop(w)}
                    onDelete={() => deleteMutation.mutate(w.id)}
                    onAttendance={() => setAttendanceWorkshop(w)}
                    isAdmin
                  />
                ))}
              </section>
            )}
            {done.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Realizados</h2>
                {done.map(w => (
                  <WorkshopCard
                    key={w.id}
                    workshop={w}
                    onEdit={() => setEditingWorkshop(w)}
                    onDelete={() => deleteMutation.mutate(w.id)}
                    onAttendance={() => setAttendanceWorkshop(w)}
                    isAdmin
                  />
                ))}
              </section>
            )}
          </div>
        )}
      </div>

      {editingWorkshop !== undefined && (
        <WorkshopDialog
          workshop={editingWorkshop}
          onOpenChange={open => !open && setEditingWorkshop(undefined)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["workshops"] })}
        />
      )}

      {attendanceWorkshop && (
        <AttendanceSheet
          workshop={attendanceWorkshop}
          onClose={() => setAttendanceWorkshop(null)}
        />
      )}
    </AdminLayout>
  );
}

// ── Shared Card (used in both pages) ─────────────────────────────────────────

export function WorkshopCard({ workshop: w, onEdit, onDelete, onAttendance, onRegister, onUnregister, isAdmin }: {
  workshop: Workshop;
  onEdit?: () => void;
  onDelete?: () => void;
  onAttendance?: () => void;
  onRegister?: () => void;
  onUnregister?: () => void;
  isAdmin?: boolean;
}) {
  const regStatus = w.user_registration_status;
  const isFull = !!w.max_seats && w.seats_taken >= w.max_seats && !regStatus;

  return (
    <Card className="overflow-hidden hover:shadow-md hover:border-primary/20 transition-all">
      <CardContent className="p-4">
        <div className="flex items-start gap-3">
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-1">
              <span className="font-semibold text-sm">{w.title}</span>
              <Badge variant="secondary" className="text-[10px] h-4 px-1.5">{w.area}</Badge>
              <span className={cn("text-xs font-medium", WORKSHOP_STATUS_COLORS[w.status])}>
                {WORKSHOP_STATUS_LABELS[w.status]}
              </span>
            </div>

            {w.description && (
              <p className="text-xs text-muted-foreground mb-2 line-clamp-2">{w.description}</p>
            )}

            <div className="flex flex-wrap gap-3 text-xs text-muted-foreground">
              <span className="flex items-center gap-1">
                <CalendarDays className="h-3 w-3" />
                {formatDatetime(w.starts_at)} — {formatDatetime(w.ends_at)}
              </span>
              {w.location && (
                <span className="flex items-center gap-1">
                  <MapPin className="h-3 w-3" />{w.location}
                </span>
              )}
              <span className="flex items-center gap-1">
                <Users className="h-3 w-3" />{seatsLabel(w)}
              </span>
            </div>
          </div>

          <div className="flex flex-col gap-1 shrink-0">
            {isAdmin ? (
              <>
                {(w.status === "closed" || w.status === "done") && onAttendance && (
                  <Button size="sm" variant="outline" className="h-7 text-xs" onClick={onAttendance}>
                    <CheckSquare className="h-3 w-3 mr-1" /> Presença
                  </Button>
                )}
                {onEdit && (
                  <button className="flex h-7 w-7 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25" onClick={onEdit}>
                    <Pencil className="h-3.5 w-3.5" />
                  </button>
                )}
                {onDelete && (
                  <button className="flex h-7 w-7 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25" onClick={onDelete}>
                    <Trash2 className="h-3.5 w-3.5" />
                  </button>
                )}
              </>
            ) : (
              <>
                {regStatus === "registered" && onUnregister && (
                  <Button size="sm" variant="outline" className="h-7 text-xs" onClick={onUnregister}>
                    Cancelar inscrição
                  </Button>
                )}
                {regStatus === "attended" && (
                  <Badge className="text-xs bg-emerald-500/10 text-emerald-400 border-0">Presença confirmada</Badge>
                )}
                {regStatus === "absent" && (
                  <Badge variant="outline" className="text-xs text-muted-foreground">Ausente</Badge>
                )}
                {!regStatus && w.status === "open" && onRegister && (
                  <Button size="sm" className="h-7 text-xs" onClick={onRegister} disabled={isFull}>
                    {isFull ? "Vagas esgotadas" : "Inscrever-se"}
                  </Button>
                )}
              </>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
