import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { communications as commsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/hooks/use-toast";
import type { Announcement } from "@/types/communications";
import { ANNOUNCEMENT_CATEGORIES } from "@/types/communications";
import { Megaphone, Plus, Pencil, Trash2, Cake, Award, Send } from "lucide-react";
import { cn } from "@/lib/utils";

const MONTH_NAMES = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"];

const CATEGORY_COLORS: Record<string, string> = {
  Geral: "bg-slate-500/15 text-slate-400",
  RH: "bg-blue-500/15 text-blue-400",
  Benefícios: "bg-emerald-500/15 text-emerald-400",
  Evento: "bg-purple-500/15 text-purple-400",
  Urgente: "bg-red-500/15 text-red-400",
  Reconhecimento: "bg-amber-500/15 text-amber-400",
};

// ── Announcement Dialog ───────────────────────────────────────────────────────

function AnnouncementDialog({ item, onOpenChange, onSaved }: {
  item: Announcement | null;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState(item?.title ?? "");
  const [content, setContent] = useState(item?.content ?? "");
  const [category, setCategory] = useState(item?.category ?? "Geral");
  const [status, setStatus] = useState(item?.status ?? "draft");

  const mutation = useMutation({
    mutationFn: () => {
      const data = { title, content, category, status };
      return item ? commsApi.updateAnnouncement(item.id, data) : commsApi.createAnnouncement(data);
    },
    onSuccess: () => {
      toast({ title: item ? "Comunicado atualizado" : "Comunicado criado" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>{item ? "Editar Comunicado" : "Novo Comunicado"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Novidades do mês de maio" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Categoria</Label>
              <Select value={category} onValueChange={setCategory}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {ANNOUNCEMENT_CATEGORIES.map(c => (
                    <SelectItem key={c} value={c}>{c}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Status</Label>
              <Select value={status} onValueChange={setStatus}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="draft">Rascunho</SelectItem>
                  <SelectItem value="published">Publicado</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Conteúdo</Label>
            <Textarea
              value={content}
              onChange={e => setContent(e.target.value)}
              rows={6}
              className="resize-none"
              placeholder="Escreva o comunicado aqui..."
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button
            variant="outline"
            onClick={() => { setStatus("draft"); setTimeout(() => mutation.mutate(), 0); }}
            disabled={!title || !content || mutation.isPending}
          >
            Salvar rascunho
          </Button>
          <Button
            onClick={() => { setStatus("published"); setTimeout(() => mutation.mutate(), 0); }}
            disabled={!title || !content || mutation.isPending}
          >
            <Send className="h-4 w-4 mr-1" />
            {mutation.isPending ? "Publicando..." : "Publicar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Mural Tab ─────────────────────────────────────────────────────────────────

function MuralTab() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [dialogItem, setDialogItem] = useState<Announcement | null | undefined>(undefined);

  const { data: announcements = [], isLoading } = useQuery({
    queryKey: ["announcements"],
    queryFn: commsApi.listAnnouncements,
  });

  const deleteMutation = useMutation({
    mutationFn: commsApi.deleteAnnouncement,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["announcements"] });
      toast({ title: "Comunicado removido" });
    },
  });

  const publishMutation = useMutation({
    mutationFn: (a: Announcement) =>
      commsApi.updateAnnouncement(a.id, { ...a, status: "published" }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["announcements"] }),
  });

  const drafts = announcements.filter(a => a.status === "draft");
  const published = announcements.filter(a => a.status === "published");

  return (
    <div className="space-y-5">
      <div className="flex justify-end">
        <Button size="sm" onClick={() => setDialogItem(null)}>
          <Plus className="h-4 w-4 mr-1" /> Novo comunicado
        </Button>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Carregando...</p>
      ) : announcements.length === 0 ? (
        <div className="rounded-xl border border-dashed p-12 text-center">
          <Megaphone className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
          <p className="text-muted-foreground mb-3">Nenhum comunicado ainda.</p>
          <Button size="sm" onClick={() => setDialogItem(null)}>
            <Plus className="h-4 w-4 mr-1" /> Criar primeiro comunicado
          </Button>
        </div>
      ) : (
        <div className="space-y-5">
          {drafts.length > 0 && (
            <section className="space-y-2">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Rascunhos</h3>
              {drafts.map(a => (
                <AnnouncementCard
                  key={a.id}
                  announcement={a}
                  onEdit={() => setDialogItem(a)}
                  onDelete={() => deleteMutation.mutate(a.id)}
                  onPublish={() => publishMutation.mutate(a)}
                  isAdmin
                />
              ))}
            </section>
          )}
          {published.length > 0 && (
            <section className="space-y-2">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Publicados</h3>
              {published.map(a => (
                <AnnouncementCard
                  key={a.id}
                  announcement={a}
                  onEdit={() => setDialogItem(a)}
                  onDelete={() => deleteMutation.mutate(a.id)}
                  isAdmin
                />
              ))}
            </section>
          )}
        </div>
      )}

      {dialogItem !== undefined && (
        <AnnouncementDialog
          item={dialogItem}
          onOpenChange={open => !open && setDialogItem(undefined)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["announcements"] })}
        />
      )}
    </div>
  );
}

// ── Birthdays Tab ─────────────────────────────────────────────────────────────

function BirthdaysTab() {
  const { data: birthdays = [], isLoading } = useQuery({
    queryKey: ["birthdays"],
    queryFn: commsApi.birthdays,
  });
  const { data: milestones = [] } = useQuery({
    queryKey: ["milestones"],
    queryFn: commsApi.milestones,
  });

  const currentMonth = MONTH_NAMES[new Date().getMonth()];

  return (
    <div className="space-y-6">
      <section className="space-y-3">
        <h3 className="flex items-center gap-2 text-sm font-semibold">
          <Cake className="h-4 w-4 text-pink-500" /> Aniversariantes de {currentMonth}
        </h3>
        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : birthdays.length === 0 ? (
          <p className="text-sm text-muted-foreground">Nenhum aniversariante este mês.</p>
        ) : (
          <div className="space-y-2">
            {birthdays.map(b => (
              <div key={b.user_id} className={cn(
                "flex items-center gap-3 rounded-xl border px-4 py-3",
                b.is_today && "border-pink-500/30 bg-pink-500/10"
              )}>
                <div className="flex h-9 w-9 items-center justify-center rounded-full bg-pink-500/15 text-pink-400 font-bold text-sm shrink-0">
                  {b.day}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium">{b.name}</p>
                  {b.department && <p className="text-xs text-muted-foreground">{b.department}</p>}
                </div>
                {b.is_today && (
                  <Badge className="bg-pink-500/15 text-pink-400 border-0 text-xs">Hoje! 🎂</Badge>
                )}
              </div>
            ))}
          </div>
        )}
      </section>

      <section className="space-y-3">
        <h3 className="flex items-center gap-2 text-sm font-semibold">
          <Award className="h-4 w-4 text-amber-500" /> Aniversários de Empresa — {currentMonth}
        </h3>
        {milestones.length === 0 ? (
          <p className="text-sm text-muted-foreground">Nenhum aniversário de empresa este mês.</p>
        ) : (
          <div className="space-y-2">
            {milestones.map(m => (
              <div key={m.user_id} className={cn(
                "flex items-center gap-3 rounded-xl border px-4 py-3",
                m.is_today && "border-amber-500/30 bg-amber-500/10"
              )}>
                <div className="flex h-9 w-9 items-center justify-center rounded-full bg-amber-500/15 text-amber-400 font-bold text-sm shrink-0">
                  {m.years}a
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium">{m.name}</p>
                  {m.department && <p className="text-xs text-muted-foreground">{m.department}</p>}
                </div>
                <span className="text-xs text-muted-foreground shrink-0">dia {m.day}</span>
                {m.is_today && (
                  <Badge className="bg-amber-500/15 text-amber-400 border-0 text-xs">Hoje! 🏆</Badge>
                )}
              </div>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}

// ── Shared Card ───────────────────────────────────────────────────────────────

export function AnnouncementCard({ announcement: a, onEdit, onDelete, onPublish, isAdmin }: {
  announcement: Announcement;
  onEdit?: () => void;
  onDelete?: () => void;
  onPublish?: () => void;
  isAdmin?: boolean;
}) {
  const [expanded, setExpanded] = useState(false);
  const longContent = a.content.length > 200;

  return (
    <Card className={cn(a.status === "draft" && "opacity-70")}>
      <CardHeader className="pb-2 pt-4 px-4">
        <div className="flex items-start gap-2">
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-1">
              <CardTitle className="text-sm font-semibold">{a.title}</CardTitle>
              <Badge className={cn("text-[10px] h-4 px-1.5 border-0", CATEGORY_COLORS[a.category] ?? "bg-slate-100 text-slate-700")}>
                {a.category}
              </Badge>
              {a.status === "draft" && (
                <Badge variant="outline" className="text-[10px] h-4 px-1.5">Rascunho</Badge>
              )}
            </div>
            {a.published_at && (
              <p className="text-xs text-muted-foreground">
                {new Date(a.published_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "long", year: "numeric" })}
              </p>
            )}
          </div>
          {isAdmin && (
            <div className="flex gap-1 shrink-0">
              {onPublish && a.status === "draft" && (
                <Button size="sm" variant="outline" className="h-7 text-xs" onClick={onPublish}>
                  <Send className="h-3 w-3 mr-1" /> Publicar
                </Button>
              )}
              {onEdit && (
                <Button size="icon" variant="ghost" className="h-7 w-7" onClick={onEdit}>
                  <Pencil className="h-3.5 w-3.5" />
                </Button>
              )}
              {onDelete && (
                <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive" onClick={onDelete}>
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              )}
            </div>
          )}
        </div>
      </CardHeader>
      <CardContent className="px-4 pb-4">
        <p className="text-sm text-muted-foreground whitespace-pre-line">
          {longContent && !expanded ? a.content.slice(0, 200) + "..." : a.content}
        </p>
        {longContent && (
          <button
            className="text-xs text-primary mt-1 hover:underline"
            onClick={() => setExpanded(!expanded)}
          >
            {expanded ? "Ver menos" : "Ver mais"}
          </button>
        )}
      </CardContent>
    </Card>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function CommunicationsAdminPage() {
  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <Megaphone className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Comunicação Interna</h1>
        </div>

        <Tabs defaultValue="mural">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger value="mural" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2">
              <Megaphone className="h-4 w-4" /> Mural
            </TabsTrigger>
            <TabsTrigger value="birthdays" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground gap-2">
              <Cake className="h-4 w-4" /> Aniversários
            </TabsTrigger>
          </TabsList>
          <TabsContent value="mural" className="mt-4">
            <MuralTab />
          </TabsContent>
          <TabsContent value="birthdays" className="mt-4">
            <BirthdaysTab />
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
