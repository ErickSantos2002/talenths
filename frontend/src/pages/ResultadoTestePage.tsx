import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { customTests } from "@/lib/api";
import type { TestAttemptDetail } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, CheckCircle, Clock, XCircle } from "lucide-react";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

function fmt(d: string | null) {
  if (!d) return "—";
  return format(new Date(d), "dd/MM/yyyy HH:mm", { locale: ptBR });
}

export default function ResultadoTestePage() {
  const { attemptId } = useParams<{ attemptId: string }>();
  const navigate = useNavigate();

  const { data: attempt, isLoading } = useQuery<TestAttemptDetail>({
    queryKey: ["my-attempt-detail", attemptId],
    queryFn: () => customTests.myAttemptDetail(attemptId!),
    enabled: !!attemptId,
  });

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="flex min-h-[60vh] items-center justify-center">
          <p className="text-muted-foreground">Carregando resultado...</p>
        </div>
      </AdminLayout>
    );
  }

  if (!attempt) return null;

  const isEvaluated = attempt.status === "evaluated";
  const isPending = attempt.status === "submitted";

  return (
    <AdminLayout>
      <div className="p-6 max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="icon" onClick={() => navigate("/meus-testes")}>
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-xl font-semibold">{attempt.test_title}</h1>
            <p className="text-sm text-muted-foreground">
              Tentativa #{attempt.attempt_number} · {fmt(attempt.submitted_at)}
            </p>
          </div>
        </div>

        {/* Status card */}
        <Card>
          <CardContent className="p-6 text-center space-y-3">
            {isPending && (
              <>
                <Clock className="h-12 w-12 text-yellow-500 mx-auto" />
                <h2 className="text-lg font-semibold">Aguardando avaliação</h2>
                <p className="text-sm text-muted-foreground">
                  Seu teste foi enviado. O RH avaliará em breve e você receberá uma notificação.
                </p>
              </>
            )}
            {isEvaluated && (
              <>
                {attempt.passed === true && <CheckCircle className="h-12 w-12 text-green-500 mx-auto" />}
                {attempt.passed === false && <XCircle className="h-12 w-12 text-red-500 mx-auto" />}
                {attempt.passed === null && <CheckCircle className="h-12 w-12 text-primary mx-auto" />}

                <h2 className="text-lg font-semibold">
                  {attempt.passed === true && "Aprovado!"}
                  {attempt.passed === false && "Não aprovado"}
                  {attempt.passed === null && "Avaliado"}
                </h2>

                {attempt.final_score !== null && (
                  <div>
                    <span className="text-4xl font-bold">{attempt.final_score}</span>
                    <span className="text-lg text-muted-foreground"> / {attempt.total_points ?? "?"} pts</span>
                  </div>
                )}

                {attempt.pass_score !== null && attempt.pass_score !== undefined && (
                  <p className="text-sm text-muted-foreground">
                    Nota mínima: {attempt.pass_score} pts
                  </p>
                )}

                {attempt.hr_feedback && (
                  <div className="rounded-lg border bg-muted/30 px-4 py-3 text-sm text-left mt-4">
                    <p className="font-semibold mb-1">Feedback do RH</p>
                    <p className="text-muted-foreground whitespace-pre-wrap">{attempt.hr_feedback}</p>
                  </div>
                )}
              </>
            )}
          </CardContent>
        </Card>

        {/* Revisão das respostas (só quando avaliado) */}
        {isEvaluated && attempt.responses.length > 0 && (
          <div className="space-y-4">
            <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wide">
              Revisão das respostas
            </h2>
            {attempt.responses.map((resp, i) => (
              <Card key={resp.id}>
                <CardContent className="p-4 space-y-3">
                  <p className="text-sm font-medium">{i + 1}. {resp.question_text}</p>

                  {resp.question_type === "open_text" && (
                    <div className="space-y-1">
                      <p className="text-sm bg-muted/30 rounded p-2 whitespace-pre-wrap">
                        {resp.text_response ?? "—"}
                      </p>
                      {resp.manual_points !== null && (
                        <p className="text-xs text-muted-foreground">
                          Pontuação: {resp.manual_points} pts
                          {resp.hr_comment && ` · "${resp.hr_comment}"`}
                        </p>
                      )}
                    </div>
                  )}

                  {resp.question_type === "scale" && (
                    <p className="text-sm">
                      Resposta: <strong>{resp.scale_value ?? "—"}</strong>
                      {resp.auto_points !== null && (
                        <span className="text-muted-foreground ml-2">({resp.auto_points} pts)</span>
                      )}
                    </p>
                  )}

                  {["single_choice", "multiple_choice", "checklist", "true_false"].includes(resp.question_type) && (
                    <div className="space-y-1">
                      {resp.options?.map((opt) => {
                        const selected = resp.selected_option_ids?.includes(opt.id);
                        return (
                          <div
                            key={opt.id}
                            className={cn(
                              "flex items-center gap-2 text-sm rounded px-2 py-1",
                              opt.is_correct && "bg-green-50 text-green-800 dark:bg-green-950 dark:text-green-200",
                              selected && !opt.is_correct && "bg-red-50 text-red-800 dark:bg-red-950 dark:text-red-200"
                            )}
                          >
                            <span>{selected ? "▶" : "○"}</span>
                            <span className="flex-1">{opt.text}</span>
                            {opt.is_correct && <span className="text-xs font-semibold">✓ Correta</span>}
                          </div>
                        );
                      })}
                      {resp.auto_points !== null && (
                        <p className="text-xs text-muted-foreground mt-1">{resp.auto_points} pts</p>
                      )}
                    </div>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        <Button variant="outline" className="w-full" onClick={() => navigate("/meus-testes")}>
          Voltar para Meus Testes
        </Button>
      </div>
    </AdminLayout>
  );
}
