import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { surveys as surveysApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import type { Survey, SurveyAnswer, SurveyQuestion } from "@/types/surveys";
import { BarChart2, CheckCircle2, Send, Star } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Scale Input ───────────────────────────────────────────────────────────────

function ScaleInput({ value, onChange }: { value?: number; onChange: (v: number) => void }) {
  const labels = ["Muito insatisfeito", "Insatisfeito", "Neutro", "Satisfeito", "Muito satisfeito"];
  return (
    <div className="space-y-2">
      <div className="flex gap-2">
        {[1, 2, 3, 4, 5].map(n => (
          <button
            key={n}
            onClick={() => onChange(n)}
            className={cn(
              "flex-1 flex flex-col items-center gap-1 rounded-lg border py-3 transition-all",
              value === n ? "border-primary bg-primary/10" : "hover:border-muted-foreground"
            )}
          >
            <Star className={cn("h-5 w-5", value !== undefined && n <= value ? "fill-amber-400 text-amber-400" : "text-muted-foreground")} />
            <span className="text-xs font-medium">{n}</span>
          </button>
        ))}
      </div>
      {value && <p className="text-xs text-center text-muted-foreground">{labels[value - 1]}</p>}
    </div>
  );
}

// ── Survey Form ───────────────────────────────────────────────────────────────

function SurveyForm({ survey, onDone }: { survey: Survey; onDone: () => void }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [answers, setAnswers] = useState<Record<string, Partial<SurveyAnswer>>>({});

  const setAnswer = (qId: string, field: keyof SurveyAnswer, value: string | number) => {
    setAnswers(prev => ({
      ...prev,
      [qId]: { ...prev[qId], question_id: qId, [field]: value },
    }));
  };

  const mutation = useMutation({
    mutationFn: () => {
      const ans = survey.questions.map(q => ({
        question_id: q.id,
        ...answers[q.id],
      }));
      return surveysApi.respond(survey.id, ans as SurveyAnswer[]);
    },
    onSuccess: () => {
      toast({ title: "Resposta enviada! Obrigado." });
      queryClient.invalidateQueries({ queryKey: ["surveys-my"] });
      onDone();
    },
    onError: (e: Error) => toast({ title: "Erro ao enviar", description: e.message, variant: "destructive" }),
  });

  const allAnswered = survey.questions.every(q => {
    const a = answers[q.id];
    if (q.type === "scale") return a?.scale_value !== undefined;
    if (q.type === "text") return (a?.text_value ?? "").trim().length > 0;
    if (q.type === "choice") return (a?.choice_value ?? "").length > 0;
    return false;
  });

  return (
    <div className="space-y-6">
      {survey.anonymous && (
        <div className="rounded-lg bg-muted/50 px-4 py-2.5 text-xs text-muted-foreground">
          Esta pesquisa é anônima. Suas respostas não serão identificadas.
        </div>
      )}

      {survey.questions.map((q, i) => (
        <div key={q.id} className="space-y-3">
          <p className="text-sm font-medium">{i + 1}. {q.text}</p>

          {q.type === "scale" && (
            <ScaleInput
              value={answers[q.id]?.scale_value}
              onChange={v => setAnswer(q.id, "scale_value", v)}
            />
          )}

          {q.type === "text" && (
            <Textarea
              value={answers[q.id]?.text_value ?? ""}
              onChange={e => setAnswer(q.id, "text_value", e.target.value)}
              rows={3}
              className="resize-none"
              placeholder="Sua resposta..."
            />
          )}

          {q.type === "choice" && q.options && (
            <div className="space-y-2">
              {q.options.map(opt => (
                <button
                  key={opt}
                  onClick={() => setAnswer(q.id, "choice_value", opt)}
                  className={cn(
                    "w-full text-left rounded-lg border px-4 py-2.5 text-sm transition-all",
                    answers[q.id]?.choice_value === opt
                      ? "border-primary bg-primary/10 font-medium"
                      : "hover:border-muted-foreground"
                  )}
                >
                  {opt}
                </button>
              ))}
            </div>
          )}
        </div>
      ))}

      <Button
        className="w-full"
        onClick={() => mutation.mutate()}
        disabled={!allAnswered || mutation.isPending}
      >
        <Send className="h-4 w-4 mr-2" />
        {mutation.isPending ? "Enviando..." : "Enviar respostas"}
      </Button>
    </div>
  );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function MySurveysPage() {
  const [activeSurvey, setActiveSurvey] = useState<Survey | null>(null);

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["surveys-my"],
    queryFn: surveysApi.list,
  });

  const pending = list.filter(s => !s.user_responded);
  const answered = list.filter(s => s.user_responded);

  if (activeSurvey) {
    return (
      <AdminLayout>
        <div className="max-w-2xl space-y-6">
          <div className="flex items-center gap-3">
            <Button variant="ghost" size="sm" onClick={() => setActiveSurvey(null)}>← Voltar</Button>
          </div>
          <div>
            <h1 className="text-xl font-bold">{activeSurvey.title}</h1>
            {activeSurvey.description && (
              <p className="text-muted-foreground text-sm mt-1">{activeSurvey.description}</p>
            )}
          </div>
          <SurveyForm survey={activeSurvey} onDone={() => setActiveSurvey(null)} />
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <BarChart2 className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold tracking-tight">Pesquisas</h1>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : list.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <BarChart2 className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhuma pesquisa disponível no momento.</p>
          </div>
        ) : (
          <div className="space-y-6">
            {pending.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Aguardando sua resposta</h2>
                {pending.map(s => (
                  <Card key={s.id} className="border-primary/30">
                    <CardContent className="p-4 flex items-center gap-4">
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold text-sm">{s.title}</p>
                        {s.description && <p className="text-xs text-muted-foreground mt-0.5 truncate">{s.description}</p>}
                        <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground">
                          <span>{s.questions.length} perguntas</span>
                          {s.ends_at && <span>até {new Date(s.ends_at).toLocaleDateString("pt-BR")}</span>}
                          {s.anonymous && <Badge variant="outline" className="text-[10px] h-4 px-1.5">Anônima</Badge>}
                        </div>
                      </div>
                      <Button size="sm" onClick={() => setActiveSurvey(s)}>Responder</Button>
                    </CardContent>
                  </Card>
                ))}
              </section>
            )}

            {answered.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Respondidas</h2>
                {answered.map(s => (
                  <Card key={s.id} className="opacity-70">
                    <CardContent className="p-4 flex items-center gap-3">
                      <CheckCircle2 className="h-5 w-5 text-emerald-500 shrink-0" />
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium">{s.title}</p>
                      </div>
                      <Badge variant="secondary" className="text-xs">Respondida</Badge>
                    </CardContent>
                  </Card>
                ))}
              </section>
            )}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
