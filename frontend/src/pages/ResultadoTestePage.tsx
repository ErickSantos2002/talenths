import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { customTests } from "@/lib/api";
import type { TestAttemptDetail } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, CheckCircle2, Clock, XCircle, ClipboardList, Star } from "lucide-react";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

function fmt(d: string | null) {
  if (!d) return "—";
  return format(new Date(d), "dd/MM/yyyy 'às' HH:mm", { locale: ptBR });
}

const STATUS_CONFIG = {
  submitted: {
    icon: Clock,
    iconClass: "text-amber-400",
    bgClass: "bg-amber-500/10 border-amber-500/20",
    title: "Aguardando avaliação",
    description: "Seu teste foi enviado. O RH avaliará em breve e você receberá uma notificação.",
    badge: "bg-amber-500/15 text-amber-400 border-amber-500/20",
    badgeLabel: "Pendente",
  },
  evaluated_pass: {
    icon: CheckCircle2,
    iconClass: "text-emerald-400",
    bgClass: "bg-emerald-500/10 border-emerald-500/20",
    title: "Aprovado!",
    description: "Parabéns! Você atingiu a nota mínima exigida.",
    badge: "bg-emerald-500/15 text-emerald-400 border-emerald-500/20",
    badgeLabel: "Aprovado",
  },
  evaluated_fail: {
    icon: XCircle,
    iconClass: "text-red-400",
    bgClass: "bg-red-500/10 border-red-500/20",
    title: "Não aprovado",
    description: "Você não atingiu a nota mínima exigida nesta tentativa.",
    badge: "bg-red-500/15 text-red-400 border-red-500/20",
    badgeLabel: "Reprovado",
  },
  evaluated_neutral: {
    icon: CheckCircle2,
    iconClass: "text-primary",
    bgClass: "bg-primary/10 border-primary/20",
    title: "Avaliado",
    description: "Sua tentativa foi avaliada pelo RH.",
    badge: "bg-primary/15 text-primary border-primary/20",
    badgeLabel: "Avaliado",
  },
};

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

  const statusKey = isPending
    ? "submitted"
    : attempt.passed === true
    ? "evaluated_pass"
    : attempt.passed === false
    ? "evaluated_fail"
    : "evaluated_neutral";

  const status = STATUS_CONFIG[statusKey];
  const StatusIcon = status.icon;

  return (
    <AdminLayout>
      <div className="p-6 max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-start gap-3">
          <Button variant="ghost" size="icon" className="shrink-0 mt-0.5" onClick={() => navigate("/meus-testes")}>
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div className="flex items-center gap-3 min-w-0">
            <ClipboardList className="h-6 w-6 text-primary shrink-0" />
            <div className="min-w-0">
              <h1 className="text-2xl font-bold tracking-tight truncate">{attempt.test_title}</h1>
              <p className="text-sm text-muted-foreground">
                Tentativa #{attempt.attempt_number} · {fmt(attempt.submitted_at)}
              </p>
            </div>
          </div>
        </div>

        {/* Status card */}
        <Card className={cn("border", status.bgClass)}>
          <CardContent className="p-6 text-center space-y-3">
            <StatusIcon className={cn("h-12 w-12 mx-auto", status.iconClass)} />
            <div className="space-y-1">
              <h2 className="text-lg font-semibold">{status.title}</h2>
              <p className="text-sm text-muted-foreground">{status.description}</p>
            </div>

            {isEvaluated && attempt.final_score !== null && (
              <div className="pt-2">
                <div className="inline-flex items-baseline gap-1">
                  <span className="text-5xl font-bold tabular-nums">{attempt.final_score}</span>
                  <span className="text-xl text-muted-foreground">/ {attempt.total_points ?? "?"}</span>
                  <span className="text-sm text-muted-foreground ml-1">pts</span>
                </div>
                {attempt.pass_score !== null && attempt.pass_score !== undefined && (
                  <p className="text-xs text-muted-foreground mt-1">Nota mínima: {attempt.pass_score} pts</p>
                )}
              </div>
            )}

            <Badge variant="outline" className={cn("text-xs", status.badge)}>
              {status.badgeLabel}
            </Badge>
          </CardContent>
        </Card>

        {/* HR Feedback */}
        {isEvaluated && attempt.hr_feedback && (
          <div className="rounded-xl border border-primary/20 bg-primary/5 px-4 py-4 space-y-1">
            <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Feedback do RH</p>
            <p className="text-sm text-foreground/80 whitespace-pre-wrap leading-relaxed">{attempt.hr_feedback}</p>
          </div>
        )}

        {/* Revisão das respostas */}
        {isEvaluated && attempt.responses.length > 0 && (
          <div className="space-y-3">
            <p className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">
              Revisão das respostas
            </p>

            {attempt.responses.map((resp, i) => (
              <Card key={resp.id} className="hover:shadow-md hover:border-primary/20 transition-all">
                <CardContent className="p-4 space-y-3">
                  <div className="flex items-start gap-2">
                    <span className="text-xs font-bold text-muted-foreground/50 mt-0.5 shrink-0 tabular-nums">
                      {String(i + 1).padStart(2, "0")}
                    </span>
                    <p className="text-sm font-medium leading-relaxed">{resp.question_text}</p>
                  </div>

                  {resp.question_type === "open_text" && (
                    <div className="space-y-2 ml-6">
                      <div className="rounded-lg border bg-secondary px-3 py-2">
                        <p className="text-sm text-foreground/80 whitespace-pre-wrap">
                          {resp.text_response ?? "—"}
                        </p>
                      </div>
                      {resp.manual_points !== null && (
                        <div className="flex items-center gap-1.5">
                          <Star className="h-3.5 w-3.5 text-amber-400" />
                          <p className="text-xs text-muted-foreground">
                            {resp.manual_points} pts
                            {resp.hr_comment && (
                              <span className="italic"> · "{resp.hr_comment}"</span>
                            )}
                          </p>
                        </div>
                      )}
                    </div>
                  )}

                  {resp.question_type === "scale" && (
                    <div className="ml-6 flex items-center gap-2">
                      <span className="rounded-md border bg-secondary px-3 py-1 text-sm font-semibold">
                        {resp.scale_value ?? "—"}
                      </span>
                      {resp.auto_points !== null && (
                        <span className="text-xs text-muted-foreground">{resp.auto_points} pts</span>
                      )}
                    </div>
                  )}

                  {["single_choice", "multiple_choice", "checklist", "true_false"].includes(resp.question_type) && (
                    <div className="space-y-1.5 ml-6">
                      {resp.options?.map((opt) => {
                        const selected = resp.selected_option_ids?.includes(opt.id);
                        return (
                          <div
                            key={opt.id}
                            className={cn(
                              "flex items-center gap-2.5 rounded-lg border px-3 py-2 text-sm transition-colors",
                              opt.is_correct
                                ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400"
                                : selected
                                ? "bg-red-500/10 border-red-500/20 text-red-400"
                                : "bg-secondary/50 border-transparent text-muted-foreground"
                            )}
                          >
                            <span className="shrink-0 text-xs">
                              {opt.is_correct ? "✓" : selected ? "✗" : "○"}
                            </span>
                            <span className="flex-1">{opt.text}</span>
                            {opt.is_correct && (
                              <span className="text-[10px] font-semibold uppercase tracking-wide shrink-0">Correta</span>
                            )}
                          </div>
                        );
                      })}
                      {resp.auto_points !== null && (
                        <p className="text-xs text-muted-foreground pt-0.5">{resp.auto_points} pts</p>
                      )}
                    </div>
                  )}
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        <Button variant="outline" className="w-full" onClick={() => navigate("/meus-testes")}>
          <ArrowLeft className="h-4 w-4 mr-2" />
          Voltar para Meus Testes
        </Button>
      </div>
    </AdminLayout>
  );
}
