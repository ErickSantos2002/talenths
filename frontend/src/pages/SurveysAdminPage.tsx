import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { surveys as surveysApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import { useToast } from "@/hooks/use-toast";
import type { Survey, SurveyResults, QuestionType } from "@/types/surveys";
import { SURVEY_STATUS_LABELS, SURVEY_STATUS_COLORS } from "@/types/surveys";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from "recharts";
import { BarChart2, Plus, Pencil, Trash2, Eye, Users, Send } from "lucide-react";
import { cn } from "@/lib/utils";

const SCALE_COLORS = ["#ef4444", "#f97316", "#eab308", "#84cc16", "#22c55e"];

// ── Results Sheet ─────────────────────────────────────────────────────────────

function ResultsSheet({ surveyId, title, onClose }: { surveyId: string; title: string; onClose: () => void }) {
  const { data: results, isLoading } = useQuery({
    queryKey: ["survey-results", surveyId],
    queryFn: () => surveysApi.results(surveyId),
  });

  return (
    <Sheet open onOpenChange={onClose}>
      <SheetContent className="w-full sm:max-w-xl overflow-y-auto">
        <SheetHeader className="mb-6">
          <SheetTitle>Resultados — {title}</SheetTitle>
          {results && (
            <p className="text-sm text-muted-foreground">
              {results.response_count} resposta{results.response_count !== 1 ? "s" : ""}
              {results.anonymous && " · Anônima"}
            </p>
          )}
        </SheetHeader>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando resultados...</p>
        ) : !results || results.response_count === 0 ? (
          <p className="text-sm text-muted-foreground">Nenhuma resposta ainda.</p>
        ) : (
          <div className="space-y-8">
            {results.results.map((qr, i) => (
              <div key={qr.question_id} className="space-y-3">
                <p className="text-sm font-semibold">{i + 1}. {qr.text}</p>

                {qr.type === "scale" && qr.distribution && (
                  <div className="space-y-2">
                    <div className="flex items-baseline gap-2">
                      <span className="text-3xl font-bold">{qr.average?.toFixed(1)}</span>
                      <span className="text-sm text-muted-foreground">/ 5 · {qr.count} respostas</span>
                    </div>
                    <ResponsiveContainer width="100%" height={120}>
                      <BarChart data={[1,2,3,4,5].map(v => ({ label: String(v), count: qr.distribution![v] ?? 0 }))}>
                        <XAxis dataKey="label" tick={{ fontSize: 12 }} />
                        <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                        <Tooltip />
                        <Bar dataKey="count" radius={[4, 4, 0, 0]}>
                          {[1,2,3,4,5].map((_, idx) => (
                            <Cell key={idx} fill={SCALE_COLORS[idx]} />
                          ))}
                        </Bar>
                      </BarChart>
                    </ResponsiveContainer>
                  </div>
                )}

                {qr.type === "choice" && qr.counts && (
                  <div className="space-y-1.5">
                    {Object.entries(qr.counts).sort((a, b) => b[1] - a[1]).map(([opt, count]) => {
                      const pct = qr.count ? Math.round(count / qr.count * 100) : 0;
                      return (
                        <div key={opt} className="space-y-0.5">
                          <div className="flex justify-between text-xs">
                            <span>{opt}</span>
                            <span className="text-muted-foreground">{count} ({pct}%)</span>
                          </div>
                          <div className="h-2 rounded-full bg-muted overflow-hidden">
                            <div className="h-full rounded-full bg-primary" style={{ width: `${pct}%` }} />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}

                {qr.type === "text" && qr.answers && (
                  <div className="space-y-2">
                    {qr.answers.map((a, idx) => (
                      <div key={idx} className="rounded-lg border bg-muted/30 px-3 py-2 text-sm">{a}</div>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </SheetContent>
    </Sheet>
  );
}

// ── Survey Dialog ─────────────────────────────────────────────────────────────

function SurveyDialog({ survey, onOpenChange, onSaved }: {
  survey: Survey | null;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [title, setTitle] = useState(survey?.title ?? "");
  const [description, setDescription] = useState(survey?.description ?? "");
  const [anonymous, setAnonymous] = useState(survey?.anonymous ?? true);
  const [status, setStatus] = useState(survey?.status ?? "draft");
  const [startsAt, setStartsAt] = useState(survey?.starts_at ?? "");
  const [endsAt, setEndsAt] = useState(survey?.ends_at ?? "");

  const mutation = useMutation({
    mutationFn: () => {
      const data = { title, description: description || undefined, anonymous, status, starts_at: startsAt || undefined, ends_at: endsAt || undefined };
      return survey ? surveysApi.update(survey.id, data) : surveysApi.create(data);
    },
    onSuccess: () => {
      toast({ title: survey ? "Pesquisa atualizada" : "Pesquisa criada" });
      onSaved();
      onOpenChange(false);
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-lg">
        <DialogHeader><DialogTitle>{survey ? "Editar Pesquisa" : "Nova Pesquisa"}</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Título</Label>
            <Input value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Pesquisa de Clima — Q1 2026" />
          </div>
          <div className="space-y-1.5">
            <Label>Descrição <span className="text-muted-foreground font-normal">(opcional)</span></Label>
            <Textarea value={description} onChange={e => setDescription(e.target.value)} rows={2} className="resize-none" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Início</Label>
              <Input type="date" value={startsAt} onChange={e => setStartsAt(e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Fim</Label>
              <Input type="date" value={endsAt} onChange={e => setEndsAt(e.target.value)} />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label>Status</Label>
              <Select value={status} onValueChange={setStatus}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="draft">Rascunho</SelectItem>
                  <SelectItem value="active">Ativa</SelectItem>
                  <SelectItem value="closed">Encerrada</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="flex items-center gap-3 pt-6">
              <Switch checked={anonymous} onCheckedChange={setAnonymous} id="anon" />
              <Label htmlFor="anon" className="cursor-pointer">Respostas anônimas</Label>
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!title || mutation.isPending}>
            {mutation.isPending ? "Salvando..." : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Question Dialog ───────────────────────────────────────────────────────────

function QuestionDialog({ surveyId, onOpenChange, onSaved }: {
  surveyId: string;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const { toast } = useToast();
  const [text, setText] = useState("");
  const [type, setType] = useState<QuestionType>("scale");
  const [optionsText, setOptionsText] = useState("");

  const mutation = useMutation({
    mutationFn: () => {
      const options = type === "choice" ? optionsText.split("\n").map(o => o.trim()).filter(Boolean) : undefined;
      return surveysApi.addQuestion(surveyId, { text, type, options });
    },
    onSuccess: () => { toast({ title: "Pergunta adicionada" }); onSaved(); onOpenChange(false); },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  return (
    <Dialog open onOpenChange={onOpenChange}>
      <DialogContent className="max-w-md">
        <DialogHeader><DialogTitle>Nova Pergunta</DialogTitle></DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1.5">
            <Label>Pergunta</Label>
            <Textarea value={text} onChange={e => setText(e.target.value)} rows={2} className="resize-none" placeholder="Ex: Como você avalia o ambiente de trabalho?" />
          </div>
          <div className="space-y-1.5">
            <Label>Tipo</Label>
            <Select value={type} onValueChange={v => setType(v as QuestionType)}>
              <SelectTrigger><SelectValue /></SelectTrigger>
              <SelectContent>
                <SelectItem value="scale">Escala 1-5</SelectItem>
                <SelectItem value="text">Texto livre</SelectItem>
                <SelectItem value="choice">Múltipla escolha</SelectItem>
              </SelectContent>
            </Select>
          </div>
          {type === "choice" && (
            <div className="space-y-1.5">
              <Label>Opções <span className="text-muted-foreground font-normal">(uma por linha)</span></Label>
              <Textarea value={optionsText} onChange={e => setOptionsText(e.target.value)} rows={4} className="resize-none" placeholder={"Muito satisfeito\nSatisfeito\nNeutro\nInsatisfeito"} />
            </div>
          )}
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={() => onOpenChange(false)}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!text || mutation.isPending}>
            {mutation.isPending ? "Adicionando..." : "Adicionar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function SurveysAdminPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [surveyDialog, setSurveyDialog] = useState<Survey | null | undefined>(undefined);
  const [questionSurveyId, setQuestionSurveyId] = useState<string | null>(null);
  const [resultsFor, setResultsFor] = useState<Survey | null>(null);

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["surveys-admin"],
    queryFn: surveysApi.list,
  });

  const deleteMutation = useMutation({
    mutationFn: surveysApi.delete,
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["surveys-admin"] }); toast({ title: "Pesquisa removida" }); },
  });

  const deleteQuestionMutation = useMutation({
    mutationFn: surveysApi.deleteQuestion,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["surveys-admin"] }),
  });

  const publishMutation = useMutation({
    mutationFn: (s: Survey) => surveysApi.update(s.id, { ...s, status: "active" }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["surveys-admin"] }),
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <BarChart2 className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Pesquisa de Engajamento</h1>
          </div>
          <Button size="sm" onClick={() => setSurveyDialog(null)}>
            <Plus className="h-4 w-4 mr-1" /> Nova pesquisa
          </Button>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : list.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <BarChart2 className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground mb-3">Nenhuma pesquisa criada ainda.</p>
            <Button size="sm" onClick={() => setSurveyDialog(null)}><Plus className="h-4 w-4 mr-1" /> Criar primeira</Button>
          </div>
        ) : (
          <div className="space-y-4">
            {list.map(s => (
              <Card key={s.id}>
                <CardHeader className="pb-2">
                  <div className="flex items-start gap-2">
                    <div className="flex-1 min-w-0">
                      <div className="flex flex-wrap items-center gap-2 mb-1">
                        <CardTitle className="text-sm">{s.title}</CardTitle>
                        <span className={cn("text-xs font-medium", SURVEY_STATUS_COLORS[s.status])}>
                          {SURVEY_STATUS_LABELS[s.status]}
                        </span>
                        {s.anonymous && <Badge variant="outline" className="text-[10px] h-4 px-1.5">Anônima</Badge>}
                      </div>
                      {s.description && <p className="text-xs text-muted-foreground">{s.description}</p>}
                      <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground">
                        <span className="flex items-center gap-1"><Users className="h-3 w-3" /> {s.response_count} respostas</span>
                        <span>{s.questions.length} perguntas</span>
                        {s.ends_at && <span>até {new Date(s.ends_at).toLocaleDateString("pt-BR")}</span>}
                      </div>
                    </div>
                    <div className="flex gap-1 shrink-0 flex-wrap justify-end">
                      {s.status === "draft" && (
                        <Button size="sm" variant="outline" className="h-7 text-xs" onClick={() => publishMutation.mutate(s)}>
                          <Send className="h-3 w-3 mr-1" /> Ativar
                        </Button>
                      )}
                      <Button size="sm" variant="outline" className="h-7 text-xs" onClick={() => setResultsFor(s)}>
                        <Eye className="h-3 w-3 mr-1" /> Resultados
                      </Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7" onClick={() => setSurveyDialog(s)}>
                        <Pencil className="h-3.5 w-3.5" />
                      </Button>
                      <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive hover:text-destructive"
                        onClick={() => deleteMutation.mutate(s.id)}>
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="pt-0 space-y-1">
                  {s.questions.map((q, i) => (
                    <div key={q.id} className="flex items-center gap-2 py-1 border-t text-sm">
                      <span className="text-xs text-muted-foreground w-4 text-right shrink-0">{i + 1}.</span>
                      <span className="flex-1 truncate">{q.text}</span>
                      <Badge variant="secondary" className="text-[10px] h-4 px-1.5 shrink-0">
                        {q.type === "scale" ? "Escala" : q.type === "text" ? "Texto" : "Escolha"}
                      </Badge>
                      <button onClick={() => deleteQuestionMutation.mutate(q.id)} className="hover:text-destructive shrink-0">
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  ))}
                  <Button size="sm" variant="ghost" className="h-7 text-xs w-full justify-start mt-1"
                    onClick={() => setQuestionSurveyId(s.id)}>
                    <Plus className="h-3 w-3 mr-1" /> Adicionar pergunta
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>

      {surveyDialog !== undefined && (
        <SurveyDialog
          survey={surveyDialog}
          onOpenChange={open => !open && setSurveyDialog(undefined)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["surveys-admin"] })}
        />
      )}
      {questionSurveyId && (
        <QuestionDialog
          surveyId={questionSurveyId}
          onOpenChange={open => !open && setQuestionSurveyId(null)}
          onSaved={() => queryClient.invalidateQueries({ queryKey: ["surveys-admin"] })}
        />
      )}
      {resultsFor && (
        <ResultsSheet
          surveyId={resultsFor.id}
          title={resultsFor.title}
          onClose={() => setResultsFor(null)}
        />
      )}
    </AdminLayout>
  );
}
