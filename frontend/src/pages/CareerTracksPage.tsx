import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  GitBranch, Plus, Pencil, Trash2, ChevronDown, ChevronRight,
  User, Star, CheckCircle2,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { career as careerApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { TablePagination } from "@/components/TablePagination";
import type { CareerTrack, CareerLevel, TeamCareerEntry } from "@/types/career";
import { cn } from "@/lib/utils";
import { NINE_BOX_QUADRANTS } from "@/types/evaluations";

const ELIGIBLE_QUADRANTS = Object.entries(NINE_BOX_QUADRANTS)
  .filter(([, v]) => v.eligible)
  .map(([k]) => k);

export default function CareerTracksPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [trackDialog, setTrackDialog] = useState<{ open: boolean; track?: CareerTrack }>({ open: false });
  const [levelDialog, setLevelDialog] = useState<{ open: boolean; trackId?: string; level?: CareerLevel }>({ open: false });
  const [assignDialog, setAssignDialog] = useState<{ open: boolean; member?: TeamCareerEntry }>({ open: false });
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});
  const [teamPage, setTeamPage] = useState(1);
  const PAGE_SIZE = 10;

  const { data: tracks, isLoading: tracksLoading } = useQuery({
    queryKey: ["career-tracks"],
    queryFn: careerApi.listTracks,
  });

  const { data: team, isLoading: teamLoading } = useQuery({
    queryKey: ["career-team"],
    queryFn: careerApi.team,
  });

  const deleteTrackMutation = useMutation({
    mutationFn: careerApi.deleteTrack,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["career-tracks"] });
      toast({ title: "Trilha removida" });
    },
  });

  const deleteLevelMutation = useMutation({
    mutationFn: careerApi.deleteLevel,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["career-tracks"] });
      toast({ title: "Nível removido" });
    },
  });

  const toggleExpand = (id: string) => setExpanded(prev => ({ ...prev, [id]: !prev[id] }));

  const eligibleCount = team?.filter(m => m.eligible_for_next).length ?? 0;
  const noTrackCount = team?.filter(m => !m.track_id).length ?? 0;

  const totalTeamPages = Math.ceil((team?.length ?? 0) / PAGE_SIZE);
  const teamStartIdx = (teamPage - 1) * PAGE_SIZE;
  const teamEndIdx = Math.min(teamStartIdx + PAGE_SIZE, team?.length ?? 0);
  const paginatedTeam = team?.slice(teamStartIdx, teamEndIdx) ?? [];

  return (
    <AdminLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <GitBranch className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Trilha de Carreira</h1>
          </div>
          <Button size="sm" onClick={() => setTrackDialog({ open: true })}>
            <Plus className="h-4 w-4 mr-1" /> Nova Trilha
          </Button>
        </div>

        {/* Summary */}
        {team && (
          <div className="grid grid-cols-3 gap-4">
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Colaboradores</p>
              <p className="text-2xl font-bold mt-1">{team.length}</p>
            </div>
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Sem trilha</p>
              <p className="text-2xl font-bold mt-1 text-amber-500">{noTrackCount}</p>
            </div>
            <div className="rounded-xl border bg-card p-4">
              <p className="text-xs text-muted-foreground">Elegíveis para promoção</p>
              <p className="text-2xl font-bold mt-1 text-emerald-500">{eligibleCount}</p>
            </div>
          </div>
        )}

        <Tabs defaultValue="equipe">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent p-0 h-auto">
            <TabsTrigger value="equipe" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground">Equipe</TabsTrigger>
            <TabsTrigger value="trilhas" className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none h-11 px-4 font-medium text-muted-foreground data-[state=active]:text-foreground">Trilhas & Níveis</TabsTrigger>
          </TabsList>

          {/* ── Equipe ── */}
          <TabsContent value="equipe" className="mt-4">
            {teamLoading ? (
              <div className="space-y-2">
                {[1,2,3,4].map(i => <Skeleton key={i} className="h-14 w-full" />)}
              </div>
            ) : !team || team.length === 0 ? (
              <div className="rounded-xl border border-dashed p-12 text-center">
                <p className="text-muted-foreground">Nenhum colaborador encontrado.</p>
              </div>
            ) : (
              <div className="rounded-xl border overflow-hidden">
                <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-muted/50">
                    <tr>
                      <th className="text-left px-4 py-3 font-medium text-muted-foreground">Colaborador</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden sm:table-cell">Departamento</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground">Trilha</th>
                      <th className="text-left px-3 py-3 font-medium text-muted-foreground hidden md:table-cell">Nível</th>
                      <th className="text-center px-3 py-3 font-medium text-muted-foreground hidden lg:table-cell">Nota</th>
                      <th className="px-3 py-3" />
                    </tr>
                  </thead>
                  <tbody>
                    {paginatedTeam.map(member => (
                      <tr key={member.user_id} className="border-t hover:bg-muted/20 transition-colors">
                        <td className="px-4 py-3">
                          <div className="flex items-center gap-2">
                            <div className="h-7 w-7 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                              <User className="h-4 w-4 text-primary" />
                            </div>
                            <div>
                              <p className="font-medium leading-snug">{member.name}</p>
                              <p className="text-xs text-muted-foreground">{member.email}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-3 py-3 text-muted-foreground hidden sm:table-cell">
                          {member.department ?? "—"}
                        </td>
                        <td className="px-3 py-3">
                          {member.track_name
                            ? <span className="font-medium">{member.track_name}</span>
                            : <span className="text-muted-foreground/50 text-xs">Não definida</span>}
                        </td>
                        <td className="px-3 py-3 hidden md:table-cell">
                          {member.level_name ? (
                            <div className="flex items-center gap-1.5">
                              <Badge variant="outline" className="text-xs">{member.level_name}</Badge>
                              {member.eligible_for_next && (
                                <Star className="h-3.5 w-3.5 text-emerald-500 fill-emerald-500" title="Elegível para promoção" />
                              )}
                            </div>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3 text-center hidden lg:table-cell">
                          {member.score_final !== null && member.score_final !== undefined ? (
                            <span className={cn("font-semibold text-sm", member.score_final >= 4.6 ? "text-emerald-500" : member.score_final >= 3 ? "text-amber-500" : "text-red-500")}>
                              {member.score_final.toFixed(2)}
                            </span>
                          ) : "—"}
                        </td>
                        <td className="px-3 py-3 text-right">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => setAssignDialog({ open: true, member })}
                          >
                            {member.track_id ? "Editar" : "Atribuir"}
                          </Button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                </div>
                <TablePagination
                  currentPage={teamPage}
                  totalPages={totalTeamPages}
                  totalItems={team?.length ?? 0}
                  startIdx={teamStartIdx}
                  endIdx={teamEndIdx}
                  itemLabel="colaboradores"
                  onPage={setTeamPage}
                  onPrev={() => setTeamPage(p => Math.max(1, p - 1))}
                  onNext={() => setTeamPage(p => Math.min(totalTeamPages, p + 1))}
                />
              </div>
            )}
          </TabsContent>

          {/* ── Trilhas & Níveis ── */}
          <TabsContent value="trilhas" className="mt-4">
            {tracksLoading ? (
              <div className="space-y-3">
                {[1,2].map(i => <Skeleton key={i} className="h-24 w-full rounded-xl" />)}
              </div>
            ) : !tracks || tracks.length === 0 ? (
              <div className="rounded-xl border border-dashed p-16 text-center">
                <GitBranch className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
                <p className="text-muted-foreground mb-4">Nenhuma trilha criada ainda.</p>
                <Button onClick={() => setTrackDialog({ open: true })}>
                  <Plus className="h-4 w-4 mr-2" /> Criar primeira trilha
                </Button>
              </div>
            ) : (
              <div className="space-y-3">
                {tracks.map(track => (
                  <div key={track.id} className="rounded-xl border bg-card overflow-hidden">
                    <div className="flex items-center justify-between px-4 py-3">
                      <button
                        className="flex items-center gap-2 text-left flex-1"
                        onClick={() => toggleExpand(track.id)}
                      >
                        {expanded[track.id]
                          ? <ChevronDown className="h-4 w-4 text-muted-foreground shrink-0" />
                          : <ChevronRight className="h-4 w-4 text-muted-foreground shrink-0" />}
                        <div>
                          <p className="font-semibold">{track.name}</p>
                          {track.description && <p className="text-xs text-muted-foreground">{track.description}</p>}
                        </div>
                        <Badge variant="outline" className="ml-2 text-xs shrink-0">{track.levels.length} níveis</Badge>
                      </button>
                      <div className="flex items-center gap-1 ml-2">
                        <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setTrackDialog({ open: true, track })}>
                          <Pencil className="h-3.5 w-3.5" />
                        </Button>
                        <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive" onClick={() => deleteTrackMutation.mutate(track.id)}>
                          <Trash2 className="h-3.5 w-3.5" />
                        </Button>
                      </div>
                    </div>

                    {expanded[track.id] && (
                      <div className="border-t px-4 py-3 space-y-3 bg-muted/20">
                        <div className="flex items-center justify-between">
                          <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide">Níveis</p>
                          <Button size="sm" variant="outline" className="h-7 text-xs" onClick={() => setLevelDialog({ open: true, trackId: track.id })}>
                            <Plus className="h-3 w-3 mr-1" /> Adicionar Nível
                          </Button>
                        </div>

                        {track.levels.length === 0 ? (
                          <p className="text-xs text-muted-foreground py-2">Nenhum nível ainda.</p>
                        ) : (
                          <div className="flex flex-wrap items-center gap-2">
                            {track.levels.map((level, idx) => (
                              <div key={level.id} className="flex items-center gap-2">
                                {idx > 0 && <span className="text-muted-foreground">→</span>}
                                <div className="rounded-lg border bg-background px-3 py-2 text-sm group">
                                  <div className="flex items-center gap-2">
                                    <span className="text-xs text-muted-foreground font-mono">{level.position}</span>
                                    <span className="font-medium">{level.name}</span>
                                    <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                      <button onClick={() => setLevelDialog({ open: true, trackId: track.id, level })} className="hover:text-primary">
                                        <Pencil className="h-3 w-3" />
                                      </button>
                                      <button onClick={() => deleteLevelMutation.mutate(level.id)} className="hover:text-destructive">
                                        <Trash2 className="h-3 w-3" />
                                      </button>
                                    </div>
                                  </div>
                                  {(level.min_score_final || (level.required_9box_quadrants?.length ?? 0) > 0 || level.min_months_in_level) && (
                                    <div className="flex flex-wrap gap-1 mt-1.5">
                                      {level.min_score_final && <Badge variant="secondary" className="text-[10px] h-4 px-1">≥ {level.min_score_final} pts</Badge>}
                                      {level.min_months_in_level && <Badge variant="secondary" className="text-[10px] h-4 px-1">≥ {level.min_months_in_level} meses</Badge>}
                                      {(level.required_9box_quadrants?.length ?? 0) > 0 && <Badge variant="secondary" className="text-[10px] h-4 px-1">9Box requerido</Badge>}
                                    </div>
                                  )}
                                </div>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </TabsContent>
        </Tabs>
      </div>

      <TrackDialog
        open={trackDialog.open}
        track={trackDialog.track}
        onOpenChange={(open) => setTrackDialog({ open })}
        onSaved={() => queryClient.invalidateQueries({ queryKey: ["career-tracks"] })}
      />

      <LevelDialog
        open={levelDialog.open}
        trackId={levelDialog.trackId}
        level={levelDialog.level}
        onOpenChange={(open) => setLevelDialog({ open })}
        onSaved={() => queryClient.invalidateQueries({ queryKey: ["career-tracks"] })}
      />

      {assignDialog.member && (
        <AssignCareerDialog
          open={assignDialog.open}
          member={assignDialog.member}
          tracks={tracks ?? []}
          onOpenChange={(open) => setAssignDialog({ open })}
          onSaved={() => {
            queryClient.invalidateQueries({ queryKey: ["career-team"] });
          }}
        />
      )}
    </AdminLayout>
  );
}

// ── Track Dialog ──────────────────────────────────────────────────────────────

function TrackDialog({ open, track, onOpenChange, onSaved }: {
  open: boolean; track?: CareerTrack;
  onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [name, setName] = useState(track?.name ?? "");
  const [description, setDescription] = useState(track?.description ?? "");

  const mutation = useMutation({
    mutationFn: () => track
      ? careerApi.updateTrack(track.id, { name, description: description || undefined })
      : careerApi.createTrack({ name, description: description || undefined }),
    onSuccess: () => {
      toast({ title: track ? "Trilha atualizada" : "Trilha criada" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>{track ? "Editar Trilha" : "Nova Trilha"}</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Nome</Label>
            <Input value={name} onChange={e => setName(e.target.value)} placeholder="Ex: Trilha Técnica" />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição (opcional)</Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" placeholder="Descreva o propósito desta trilha..." />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!name || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Level Dialog ──────────────────────────────────────────────────────────────

function LevelDialog({ open, trackId, level, onOpenChange, onSaved }: {
  open: boolean; trackId?: string; level?: CareerLevel;
  onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [name, setName] = useState(level?.name ?? "");
  const [position, setPosition] = useState(String(level?.position ?? ""));
  const [description, setDescription] = useState(level?.description ?? "");
  const [minScore, setMinScore] = useState(String(level?.min_score_final ?? ""));
  const [minMonths, setMinMonths] = useState(String(level?.min_months_in_level ?? ""));
  const [quadrants, setQuadrants] = useState<string[]>(level?.required_9box_quadrants ?? []);

  const mutation = useMutation({
    mutationFn: () => {
      const data = {
        name, position: parseInt(position), description: description || undefined,
        min_score_final: minScore ? parseFloat(minScore) : null,
        min_months_in_level: minMonths ? parseInt(minMonths) : null,
        required_9box_quadrants: quadrants.length > 0 ? quadrants : null,
      };
      return level ? careerApi.updateLevel(level.id, data) : careerApi.createLevel(trackId!, data);
    },
    onSuccess: () => {
      toast({ title: level ? "Nível atualizado" : "Nível criado" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const toggleQuadrant = (q: string) =>
    setQuadrants(prev => prev.includes(q) ? prev.filter(x => x !== q) : [...prev, q]);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
        <DialogHeader><DialogTitle>{level ? "Editar Nível" : "Novo Nível"}</DialogTitle></DialogHeader>
        <div className="space-y-4 py-2">
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Nome do nível</Label>
              <Input value={name} onChange={e => setName(e.target.value)} placeholder="Ex: Sênior" />
            </div>
            <div className="space-y-1.5">
              <Label>Posição (ordem)</Label>
              <Input type="number" value={position} onChange={e => setPosition(e.target.value)} placeholder="Ex: 3" />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label>Descrição das expectativas <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" placeholder="O que se espera de alguém neste nível..." />
          </div>
          <div className="space-y-3">
            <Label>Critérios para chegar neste nível <span className="text-muted-foreground font-normal">(opcionais)</span></Label>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <p className="text-xs text-muted-foreground">Nota mínima de avaliação</p>
                <Input type="number" step="0.1" min="1" max="5" value={minScore} onChange={e => setMinScore(e.target.value)} placeholder="Ex: 4.0" />
              </div>
              <div className="space-y-1.5">
                <p className="text-xs text-muted-foreground">Meses mínimos no nível anterior</p>
                <Input type="number" value={minMonths} onChange={e => setMinMonths(e.target.value)} placeholder="Ex: 12" />
              </div>
            </div>
            <div className="space-y-1.5">
              <p className="text-xs text-muted-foreground">Quadrante 9Box exigido <span className="text-muted-foreground/60">(selecione um ou mais)</span></p>
              <div className="flex flex-wrap gap-1.5">
                {ELIGIBLE_QUADRANTS.map(q => (
                  <button key={q} type="button" onClick={() => toggleQuadrant(q)}
                    className={cn(
                      "rounded-full border px-2.5 py-0.5 text-xs transition-colors",
                      quadrants.includes(q) ? "bg-primary text-primary-foreground border-primary" : "bg-background hover:border-primary/50"
                    )}>
                    {q}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!name || !position || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Assign Career Dialog ──────────────────────────────────────────────────────

function AssignCareerDialog({ open, member, tracks, onOpenChange, onSaved }: {
  open: boolean; member: TeamCareerEntry; tracks: CareerTrack[];
  onOpenChange: (open: boolean) => void; onSaved: () => void;
}) {
  const { toast } = useToast();
  const [trackId, setTrackId] = useState(member.track_id ?? "");
  const [levelId, setLevelId] = useState(member.level_id ?? "");
  const [startedAt, setStartedAt] = useState(member.started_at?.slice(0, 10) ?? new Date().toISOString().slice(0, 10));

  const selectedTrack = tracks.find(t => t.id === trackId);

  const mutation = useMutation({
    mutationFn: () => careerApi.setEmployeeCareer(member.user_id, { track_id: trackId, level_id: levelId, started_at: startedAt }),
    onSuccess: () => {
      toast({ title: "Trilha atribuída com sucesso" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>Trilha de {member.name.split(" ")[0]}</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          {member.score_final !== null && member.score_final !== undefined && (
            <div className="rounded-lg bg-muted/40 px-3 py-2.5 text-sm flex flex-wrap items-center gap-2">
              <span className="text-muted-foreground">Última nota:</span>
              <span className={cn("font-semibold", member.score_final >= 4.6 ? "text-emerald-500" : member.score_final >= 3 ? "text-amber-500" : "text-red-500")}>
                {member.score_final.toFixed(2)}
              </span>
              {member.nine_box_quadrant && <Badge variant="outline" className="text-xs">{member.nine_box_quadrant}</Badge>}
              {member.eligible_for_next && (
                <span className="flex items-center gap-1 text-emerald-500 text-xs ml-auto">
                  <CheckCircle2 className="h-3.5 w-3.5" /> Elegível para promoção
                </span>
              )}
            </div>
          )}
          <div className="space-y-1.5">
            <Label>Trilha</Label>
            <Select value={trackId} onValueChange={v => { setTrackId(v); setLevelId(""); }}>
              <SelectTrigger><SelectValue placeholder="Selecionar trilha..." /></SelectTrigger>
              <SelectContent>
                {tracks.map(t => <SelectItem key={t.id} value={t.id}>{t.name}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Nível atual</Label>
            <Select value={levelId} onValueChange={setLevelId} disabled={!selectedTrack}>
              <SelectTrigger><SelectValue placeholder="Selecionar nível..." /></SelectTrigger>
              <SelectContent>
                {(selectedTrack?.levels ?? []).map(l => (
                  <SelectItem key={l.id} value={l.id}>{l.position}. {l.name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <Label>Neste nível desde</Label>
            <Input type="date" value={startedAt} onChange={e => setStartedAt(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!trackId || !levelId || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
