import { useQuery } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";
import { customTests } from "@/lib/api";
import type { CustomTest, TestAttempt } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ClipboardList, CheckCircle, Clock, AlertCircle, Play } from "lucide-react";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

const SCORING_LABELS: Record<string, string> = {
  auto: "Resultado imediato",
  manual: "Avaliação manual",
  mixed: "Avaliação mista",
};

const ATTEMPT_STATUS_CONFIG: Record<string, { label: string; color: string }> = {
  in_progress: { label: "Em andamento", color: "bg-blue-500/15 text-blue-400 border-blue-500/20" },
  submitted: { label: "Aguardando avaliação", color: "bg-amber-500/15 text-amber-400 border-amber-500/20" },
  evaluated: { label: "Avaliado", color: "bg-emerald-500/15 text-emerald-400 border-emerald-500/20" },
};

function fmt(d: string) {
  return format(new Date(d), "dd/MM/yyyy", { locale: ptBR });
}

export default function MeusTestesPage() {
  const navigate = useNavigate();

  const { data: available = [], isLoading: loadingAvailable } = useQuery<CustomTest[]>({
    queryKey: ["tests-available"],
    queryFn: () => customTests.available(),
  });

  const { data: myAttempts = [], isLoading: loadingAttempts } = useQuery<TestAttempt[]>({
    queryKey: ["my-attempts"],
    queryFn: () => customTests.myAttempts(),
  });

  const inProgressAttempts = myAttempts.filter((a) => a.status === "in_progress");
  const doneAttempts = myAttempts.filter((a) => a.status !== "in_progress");

  return (
    <AdminLayout>
      <div className="space-y-8">
        <div className="flex items-center gap-2">
          <ClipboardList className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-semibold">Meus Testes</h1>
        </div>

        {/* Testes em andamento */}
        {inProgressAttempts.length > 0 && (
          <div className="space-y-3">
            <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Em andamento</h2>
            {inProgressAttempts.map((attempt) => (
              <Card key={attempt.id} className="border-blue-500/30">
                <CardContent className="p-4 flex items-center gap-4">
                  <Clock className="h-5 w-5 text-blue-500 shrink-0" />
                  <div className="flex-1 min-w-0">
                    <p className="font-medium">{attempt.test_title}</p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Iniciado em {fmt(attempt.started_at)}
                    </p>
                  </div>
                  <Button
                    size="sm"
                    onClick={() => navigate(`/meus-testes/${attempt.test_id}/realizar?attempt=${attempt.id}`)}
                  >
                    Continuar
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Testes disponíveis */}
        <div className="space-y-3">
          <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Disponíveis</h2>
          {loadingAvailable ? (
            <p className="text-sm text-muted-foreground">Carregando...</p>
          ) : available.length === 0 ? (
            <div className="rounded-xl border border-dashed p-16 text-center">
              <ClipboardList className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
              <p className="text-muted-foreground">Nenhum teste disponível no momento.</p>
            </div>
          ) : (
            available.map((test) => {
              const attemptsDone = myAttempts.filter((a) => a.test_id === test.id && a.status !== "in_progress").length;
              const maxReached = test.max_attempts !== null && attemptsDone >= test.max_attempts;

              return (
                <Card key={test.id} className="hover:shadow-md hover:border-primary/20 transition-all">
                  <CardContent className="p-4">
                    <div className="flex items-start gap-4">
                      <div className="flex-1 min-w-0">
                        <p className="font-medium">{test.title}</p>
                        {test.description && (
                          <p className="text-sm text-muted-foreground mt-1 line-clamp-2">{test.description}</p>
                        )}
                        <div className="flex items-center gap-3 mt-2 text-xs text-muted-foreground">
                          <span>{test.question_count ?? "?"} perguntas</span>
                          <span>{test.total_points} pts</span>
                          <span>{SCORING_LABELS[test.scoring_mode]}</span>
                          {test.time_limit_min && <span>{test.time_limit_min} min</span>}
                          {test.max_attempts && (
                            <span>{attemptsDone}/{test.max_attempts} tentativas</span>
                          )}
                        </div>
                      </div>
                      <Button
                        size="sm"
                        disabled={maxReached}
                        onClick={() => navigate(`/meus-testes/${test.id}/realizar`)}
                      >
                        <Play className="h-3 w-3 mr-1" />
                        {maxReached ? "Limite atingido" : "Iniciar"}
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              );
            })
          )}
        </div>

        {/* Histórico */}
        {doneAttempts.length > 0 && (
          <div className="space-y-3">
            <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Histórico</h2>
            {doneAttempts.map((attempt) => {
              const cfg = ATTEMPT_STATUS_CONFIG[attempt.status];
              return (
                <Card
                  key={attempt.id}
                  className="cursor-pointer hover:shadow-md transition-shadow"
                  onClick={() => navigate(`/meus-testes/tentativas/${attempt.id}`)}
                >
                  <CardContent className="p-4">
                    <div className="flex items-center gap-4">
                      {attempt.status === "evaluated" ? (
                        <CheckCircle className="h-4 w-4 text-green-500 shrink-0" />
                      ) : (
                        <AlertCircle className="h-4 w-4 text-yellow-500 shrink-0" />
                      )}
                      <div className="flex-1 min-w-0">
                        <p className="font-medium text-sm">{attempt.test_title}</p>
                        <p className="text-xs text-muted-foreground mt-0.5">
                          Tentativa #{attempt.attempt_number} · {fmt(attempt.submitted_at ?? attempt.started_at)}
                        </p>
                      </div>
                      <div className="flex items-center gap-2 shrink-0">
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
    </AdminLayout>
  );
}
