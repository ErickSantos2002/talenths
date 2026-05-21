import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { customTests } from "@/lib/api";
import type { TestAttempt, TestAttemptDetail, TestStats } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import { useToast } from "@/hooks/use-toast";
import { ArrowLeft, CheckCircle, Clock, AlertCircle } from "lucide-react";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

const STATUS_CONFIG: Record<string, { label: string; color: string; icon: typeof Clock }> = {
  in_progress: { label: "Em andamento", color: "bg-blue-500/15 text-blue-400 border-blue-500/20", icon: Clock },
  submitted: { label: "Aguardando avaliação", color: "bg-amber-500/15 text-amber-400 border-amber-500/20", icon: AlertCircle },
  evaluated: { label: "Avaliado", color: "bg-emerald-500/15 text-emerald-400 border-emerald-500/20", icon: CheckCircle },
};

function fmt(dateStr: string | null): string {
  if (!dateStr) return "—";
  return format(new Date(dateStr), "dd/MM/yyyy HH:mm", { locale: ptBR });
}

export default function AdminTesteTentativasPage() {
  const { testId } = useParams<{ testId: string }>();
  const navigate = useNavigate();
  const qc = useQueryClient();
  const { toast } = useToast();

  const [selectedAttemptId, setSelectedAttemptId] = useState<string | null>(null);
  const [evalScore, setEvalScore] = useState("");
  const [evalFeedback, setEvalFeedback] = useState("");
  const [questionScores, setQuestionScores] = useState<Record<string, { pts: string; comment: string }>>({});

  const { data: test } = useQuery({
    queryKey: ["test-detail", testId],
    queryFn: () => customTests.get(testId!),
    enabled: !!testId,
  });

  const { data: attempts = [], isLoading } = useQuery<TestAttempt[]>({
    queryKey: ["test-attempts", testId],
    queryFn: () => customTests.attempts(testId!),
    enabled: !!testId,
  });

  const { data: stats } = useQuery<TestStats>({
    queryKey: ["test-stats", testId],
    queryFn: () => customTests.stats(testId!),
    enabled: !!testId,
  });

  const { data: attemptDetail } = useQuery<TestAttemptDetail>({
    queryKey: ["attempt-detail", selectedAttemptId],
    queryFn: () => customTests.getAttempt(selectedAttemptId!),
    enabled: !!selectedAttemptId,
  });

  const evaluateMut = useMutation({
    mutationFn: (data: object) => customTests.evaluate(selectedAttemptId!, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["test-attempts", testId] });
      qc.invalidateQueries({ queryKey: ["test-stats", testId] });
      qc.invalidateQueries({ queryKey: ["attempt-detail", selectedAttemptId] });
      setSelectedAttemptId(null);
      toast({ title: "Avaliação salva com sucesso" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const openAttempt = (attempt: TestAttempt) => {
    setSelectedAttemptId(attempt.id);
    setEvalScore(attempt.final_score !== null ? String(attempt.final_score) : "");
    setEvalFeedback(attempt.hr_feedback ?? "");
    setQuestionScores({});
  };

  const handleEvaluate = () => {
    const qs = Object.entries(questionScores)
      .filter(([, v]) => v.pts !== "")
      .map(([qid, v]) => ({
        question_id: qid,
        manual_points: parseFloat(v.pts),
        hr_comment: v.comment || undefined,
      }));

    evaluateMut.mutate({
      manual_score: evalScore !== "" ? parseFloat(evalScore) : undefined,
      hr_feedback: evalFeedback || undefined,
      question_scores: qs.length > 0 ? qs : undefined,
    });
  };

  const isManual = test?.scoring_mode === "manual";
  const isMixed = test?.scoring_mode === "mixed";

  return (
    <AdminLayout>
      <div className="p-6 max-w-4xl mx-auto space-y-6">
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="icon" onClick={() => navigate("/admin/testes")}>
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-xl font-semibold">{test?.title ?? "Carregando..."}</h1>
            <p className="text-sm text-muted-foreground">Tentativas e avaliações</p>
          </div>
        </div>

        {/* Estatísticas */}
        {stats && (
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {[
              { label: "Total", value: stats.total_attempts },
              { label: "Avaliados", value: stats.evaluated },
              { label: "Aguardando", value: stats.submitted },
              { label: "Aprovados", value: stats.approved },
            ].map((s) => (
              <Card key={s.label}>
                <CardContent className="p-4 text-center">
                  <p className="text-2xl font-bold">{s.value}</p>
                  <p className="text-xs text-muted-foreground">{s.label}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Lista de tentativas */}
        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando tentativas...</p>
        ) : attempts.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center text-muted-foreground text-sm">
              Nenhuma tentativa registrada ainda.
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-2">
            {attempts.map((attempt) => {
              const cfg = STATUS_CONFIG[attempt.status];
              const Icon = cfg.icon;
              return (
                <Card
                  key={attempt.id}
                  className="cursor-pointer hover:shadow-md transition-shadow"
                  onClick={() => openAttempt(attempt)}
                >
                  <CardContent className="p-4">
                    <div className="flex items-center gap-4">
                      <Icon className="h-4 w-4 text-muted-foreground shrink-0" />
                      <div className="flex-1 min-w-0">
                        <p className="font-medium text-sm">
                          {attempt.collaborator_name ?? "Colaborador"}
                          <span className="text-muted-foreground font-normal"> · Tentativa #{attempt.attempt_number}</span>
                        </p>
                        <p className="text-xs text-muted-foreground mt-0.5">
                          Iniciada em {fmt(attempt.started_at)}
                          {attempt.submitted_at && ` · Submetida em ${fmt(attempt.submitted_at)}`}
                        </p>
                      </div>
                      <div className="flex items-center gap-3 shrink-0">
                        {attempt.final_score !== null && (
                          <span className="text-sm font-semibold">{attempt.final_score} pts</span>
                        )}
                        {attempt.passed !== null && (
                          <Badge variant={attempt.passed ? "default" : "destructive"} className="text-xs">
                            {attempt.passed ? "Aprovado" : "Reprovado"}
                          </Badge>
                        )}
                        <Badge className={cn("text-xs", cfg.color)}>{cfg.label}</Badge>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        )}
      </div>

      {/* Sheet de avaliação */}
      <Sheet open={!!selectedAttemptId} onOpenChange={() => setSelectedAttemptId(null)}>
        <SheetContent className="w-full sm:max-w-2xl overflow-y-auto">
          {attemptDetail && (
            <>
              <SheetHeader className="mb-6">
                <SheetTitle>
                  {attemptDetail.collaborator_name ?? "Colaborador"} — Tentativa #{attemptDetail.attempt_number}
                </SheetTitle>
                <p className="text-sm text-muted-foreground">
                  {fmt(attemptDetail.submitted_at ?? attemptDetail.started_at)}
                  {attemptDetail.auto_score !== null && ` · Auto: ${attemptDetail.auto_score} pts`}
                </p>
              </SheetHeader>

              <div className="space-y-6">
                {/* Respostas */}
                {attemptDetail.responses.map((resp, i) => (
                  <div key={resp.id} className="space-y-2 pb-4 border-b last:border-0">
                    <p className="text-sm font-semibold">{i + 1}. {resp.question_text}</p>

                    {resp.question_type === "open_text" && (
                      <p className="text-sm text-muted-foreground whitespace-pre-wrap bg-muted/30 rounded p-2">
                        {resp.text_response ?? "—"}
                      </p>
                    )}
                    {resp.question_type === "scale" && (
                      <p className="text-sm">Resposta: <strong>{resp.scale_value ?? "—"}</strong></p>
                    )}
                    {resp.question_type === "true_false" && (
                      <p className="text-sm">Resposta: <strong>{resp.boolean_response === null ? "—" : resp.boolean_response ? "Verdadeiro" : "Falso"}</strong></p>
                    )}
                    {["single_choice", "multiple_choice", "checklist"].includes(resp.question_type) && (
                      <div className="space-y-1">
                        {resp.options?.map((opt) => {
                          const selected = resp.selected_option_ids?.includes(opt.id);
                          return (
                            <p key={opt.id} className={cn("text-sm", selected && "font-medium", opt.is_correct && "text-green-700 dark:text-green-400")}>
                              {selected ? "▶ " : "○ "}{opt.text}
                              {opt.is_correct && " ✓"}
                            </p>
                          );
                        })}
                      </div>
                    )}

                    {resp.auto_points !== null && (
                      <p className="text-xs text-muted-foreground">Auto: {resp.auto_points} pts</p>
                    )}

                    {/* Avaliação por questão (modo mixed, para questões abertas) */}
                    {(isMixed && resp.question_type === "open_text" && attemptDetail.status !== "in_progress") && (
                      <div className="flex gap-2 items-end mt-2">
                        <div className="space-y-1">
                          <Label className="text-xs">Pontos</Label>
                          <Input
                            type="number" min="0" step="0.5" className="w-20 h-7 text-sm"
                            value={questionScores[resp.question_id]?.pts ?? (resp.manual_points !== null ? String(resp.manual_points) : "")}
                            onChange={(e) =>
                              setQuestionScores({
                                ...questionScores,
                                [resp.question_id]: { ...questionScores[resp.question_id], pts: e.target.value },
                              })
                            }
                          />
                        </div>
                        <div className="flex-1 space-y-1">
                          <Label className="text-xs">Comentário</Label>
                          <Input
                            className="h-7 text-sm"
                            value={questionScores[resp.question_id]?.comment ?? (resp.hr_comment ?? "")}
                            onChange={(e) =>
                              setQuestionScores({
                                ...questionScores,
                                [resp.question_id]: { ...questionScores[resp.question_id], comment: e.target.value },
                              })
                            }
                          />
                        </div>
                      </div>
                    )}
                  </div>
                ))}

                {/* Avaliação global */}
                {attemptDetail.status !== "in_progress" && (
                  <div className="space-y-4 pt-2">
                    {isManual && (
                      <div className="space-y-1.5">
                        <Label>Nota final</Label>
                        <Input
                          type="number" min="0" step="0.5" className="w-32"
                          value={evalScore}
                          onChange={(e) => setEvalScore(e.target.value)}
                          placeholder="Ex: 8.5"
                        />
                      </div>
                    )}
                    <div className="space-y-1.5">
                      <Label>Feedback para o colaborador</Label>
                      <Textarea
                        rows={3}
                        value={evalFeedback}
                        onChange={(e) => setEvalFeedback(e.target.value)}
                        placeholder="Escreva um feedback..."
                      />
                    </div>
                    <Button onClick={handleEvaluate} disabled={evaluateMut.isPending} className="w-full">
                      Salvar avaliação
                    </Button>
                  </div>
                )}

                {attemptDetail.status === "evaluated" && attemptDetail.hr_feedback && (
                  <div className="rounded-lg bg-muted/40 p-3">
                    <p className="text-xs font-semibold mb-1">Feedback registrado</p>
                    <p className="text-sm text-muted-foreground">{attemptDetail.hr_feedback}</p>
                  </div>
                )}
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>
    </AdminLayout>
  );
}
