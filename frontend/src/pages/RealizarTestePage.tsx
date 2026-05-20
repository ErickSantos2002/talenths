import { useState, useEffect } from "react";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import { useQuery, useMutation } from "@tanstack/react-query";
import { customTests } from "@/lib/api";
import type { CustomTestDetail, TestAttempt, TestQuestion } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Progress } from "@/components/ui/progress";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { ArrowLeft, ArrowRight, Send } from "lucide-react";
import { cn } from "@/lib/utils";

type ResponseState = {
  selected_option_ids?: string[];
  text_response?: string;
  scale_value?: number;
  boolean_response?: boolean;
};

export default function RealizarTestePage() {
  const { testId } = useParams<{ testId: string }>();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { toast } = useToast();

  const [attempt, setAttempt] = useState<TestAttempt | null>(null);
  const [currentIdx, setCurrentIdx] = useState(0);
  const [responses, setResponses] = useState<Record<string, ResponseState>>({});
  const [showConfirm, setShowConfirm] = useState(false);
  const [starting, setStarting] = useState(false);

  const { data: test, isLoading } = useQuery<CustomTestDetail>({
    queryKey: ["test-detail-public", testId],
    queryFn: () => customTests.get(testId!),
    enabled: !!testId,
  });

  // Start or resume attempt
  useEffect(() => {
    if (!testId || attempt) return;
    const existingAttemptId = searchParams.get("attempt");
    if (existingAttemptId) {
      // Resume: load existing attempt
      setAttempt({ id: existingAttemptId } as TestAttempt);
    } else {
      // Start new attempt
      setStarting(true);
      customTests.start(testId)
        .then((a) => setAttempt(a))
        .catch((e: Error) => {
          toast({ title: "Erro ao iniciar teste", description: e.message, variant: "destructive" });
          navigate("/meus-testes");
        })
        .finally(() => setStarting(false));
    }
  }, [testId]);

  const saveMut = useMutation({
    mutationFn: (resps: object[]) => customTests.respond(attempt!.id, resps),
  });

  const submitMut = useMutation({
    mutationFn: () => customTests.submit(attempt!.id),
    onSuccess: (result) => {
      navigate(`/meus-testes/tentativas/${result.id}`);
    },
    onError: (e: Error) => toast({ title: "Erro ao enviar", description: e.message, variant: "destructive" }),
  });

  const saveAndNext = async () => {
    if (!attempt || !test) return;
    const q = test.questions[currentIdx];
    const resp = responses[q.id];
    if (resp) {
      await saveMut.mutateAsync([{ question_id: q.id, ...resp }]);
    }
    if (currentIdx < test.questions.length - 1) {
      setCurrentIdx(currentIdx + 1);
    }
  };

  const saveAndPrev = async () => {
    if (!attempt || !test) return;
    const q = test.questions[currentIdx];
    const resp = responses[q.id];
    if (resp) {
      await saveMut.mutateAsync([{ question_id: q.id, ...resp }]);
    }
    setCurrentIdx(Math.max(0, currentIdx - 1));
  };

  const handleSubmit = async () => {
    if (!attempt || !test) return;
    // Save current response if any
    const q = test.questions[currentIdx];
    const resp = responses[q.id];
    if (resp) {
      await saveMut.mutateAsync([{ question_id: q.id, ...resp }]);
    }
    submitMut.mutate();
  };

  const updateResponse = (questionId: string, update: ResponseState) => {
    setResponses((prev) => ({ ...prev, [questionId]: { ...prev[questionId], ...update } }));
  };

  if (isLoading || starting) {
    return (
      <AdminLayout>
        <div className="flex min-h-[60vh] items-center justify-center">
          <p className="text-muted-foreground">Carregando teste...</p>
        </div>
      </AdminLayout>
    );
  }

  if (!test || !attempt?.id) return null;

  const questions = test.questions;
  const q = questions[currentIdx];
  const resp = responses[q.id] ?? {};
  const progress = ((currentIdx + 1) / questions.length) * 100;
  const isLast = currentIdx === questions.length - 1;

  return (
    <AdminLayout>
      <div className="p-6 max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div>
          <div className="flex items-center justify-between mb-2">
            <h1 className="text-lg font-semibold">{test.title}</h1>
            <span className="text-sm text-muted-foreground">
              {currentIdx + 1} / {questions.length}
            </span>
          </div>
          <Progress value={progress} className="h-2" />
        </div>

        {/* Instrução inicial */}
        {currentIdx === 0 && test.instructions && (
          <div className="rounded-lg border bg-muted/30 px-4 py-3 text-sm text-muted-foreground">
            {test.instructions}
          </div>
        )}

        {/* Pergunta */}
        <Card>
          <CardContent className="p-6 space-y-6">
            <p className="text-base font-medium leading-snug">{q.text}</p>

            {/* single_choice / true_false */}
            {(q.question_type === "single_choice" || q.question_type === "true_false") && (
              <div className="space-y-2">
                {q.options.map((opt) => {
                  const selected = resp.selected_option_ids?.includes(opt.id);
                  return (
                    <button
                      key={opt.id}
                      onClick={() => updateResponse(q.id, { selected_option_ids: [opt.id] })}
                      className={cn(
                        "w-full text-left rounded-lg border px-4 py-3 text-sm transition-colors",
                        selected
                          ? "border-primary bg-primary/10 text-primary font-medium"
                          : "hover:border-primary/50 hover:bg-muted/40"
                      )}
                    >
                      {opt.text}
                    </button>
                  );
                })}
              </div>
            )}

            {/* multiple_choice / checklist */}
            {(q.question_type === "multiple_choice" || q.question_type === "checklist") && (
              <div className="space-y-2">
                {q.options.map((opt) => {
                  const selected = resp.selected_option_ids?.includes(opt.id) ?? false;
                  return (
                    <button
                      key={opt.id}
                      onClick={() => {
                        const current = resp.selected_option_ids ?? [];
                        const next = selected
                          ? current.filter((id) => id !== opt.id)
                          : [...current, opt.id];
                        updateResponse(q.id, { selected_option_ids: next });
                      }}
                      className={cn(
                        "w-full text-left rounded-lg border px-4 py-3 text-sm transition-colors",
                        selected
                          ? "border-primary bg-primary/10 text-primary font-medium"
                          : "hover:border-primary/50 hover:bg-muted/40"
                      )}
                    >
                      {opt.text}
                    </button>
                  );
                })}
              </div>
            )}

            {/* scale */}
            {q.question_type === "scale" && q.scale_min !== null && q.scale_max !== null && (
              <div className="space-y-3">
                <div className="flex gap-2 flex-wrap">
                  {Array.from(
                    { length: q.scale_max - q.scale_min + 1 },
                    (_, i) => q.scale_min! + i
                  ).map((val) => (
                    <button
                      key={val}
                      onClick={() => updateResponse(q.id, { scale_value: val })}
                      className={cn(
                        "h-10 w-10 rounded-lg border text-sm font-medium transition-colors",
                        resp.scale_value === val
                          ? "border-primary bg-primary text-primary-foreground"
                          : "hover:border-primary/50"
                      )}
                    >
                      {val}
                    </button>
                  ))}
                </div>
                {q.scale_labels && (
                  <div className="flex justify-between text-xs text-muted-foreground">
                    <span>{q.scale_labels[String(q.scale_min)]}</span>
                    <span>{q.scale_labels[String(q.scale_max)]}</span>
                  </div>
                )}
              </div>
            )}

            {/* open_text */}
            {q.question_type === "open_text" && (
              <Textarea
                rows={5}
                placeholder="Sua resposta..."
                value={resp.text_response ?? ""}
                onChange={(e) => updateResponse(q.id, { text_response: e.target.value })}
              />
            )}
          </CardContent>
        </Card>

        {/* Navegação */}
        <div className="flex items-center justify-between">
          <Button variant="outline" onClick={saveAndPrev} disabled={currentIdx === 0}>
            <ArrowLeft className="h-4 w-4 mr-2" /> Anterior
          </Button>

          {isLast ? (
            <Button onClick={() => setShowConfirm(true)} disabled={submitMut.isPending}>
              <Send className="h-4 w-4 mr-2" /> Enviar teste
            </Button>
          ) : (
            <Button onClick={saveAndNext} disabled={saveMut.isPending}>
              Próxima <ArrowRight className="h-4 w-4 ml-2" />
            </Button>
          )}
        </div>
      </div>

      {/* Confirmar envio */}
      <Dialog open={showConfirm} onOpenChange={setShowConfirm}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>Enviar teste?</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground">
            Você respondeu {Object.keys(responses).length} de {questions.length} perguntas.
            Após enviar não será possível alterar as respostas.
          </p>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowConfirm(false)}>
              Revisar
            </Button>
            <Button onClick={() => { setShowConfirm(false); handleSubmit(); }} disabled={submitMut.isPending}>
              Enviar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
