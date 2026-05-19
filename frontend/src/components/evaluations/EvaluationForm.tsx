import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { evaluations as evalApi } from "@/lib/api";
import { BEHAVIORS, PILLAR_INFO, type ScoreItem } from "@/types/evaluations";
import { useToast } from "@/hooks/use-toast";
import { StarRating } from "./StarRating";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { CheckCircle2 } from "lucide-react";

interface Props {
  cycleId: string;
  evaluatedUserId: string;
  evalType: "self" | "manager" | "chief";
  evaluatedName?: string;
  existingScores?: ScoreItem[];
  onSuccess?: () => void;
}

export function EvaluationForm({
  cycleId,
  evaluatedUserId,
  evalType,
  evaluatedName,
  existingScores = [],
  onSuccess,
}: Props) {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const [scores, setScores] = useState<Record<string, number>>(
    Object.fromEntries(existingScores.map(s => [s.behavior_key, s.score]))
  );
  const [comments, setComments] = useState<Record<string, string>>(
    Object.fromEntries(existingScores.map(s => [s.behavior_key, s.comment ?? ""]))
  );

  const mutation = useMutation({
    mutationFn: () => evalApi.submitEvaluation({
      eval_cycle_id: cycleId,
      evaluated_user_id: evaluatedUserId,
      eval_type: evalType,
      scores: BEHAVIORS.map(b => ({
        behavior_key: b.key,
        score: scores[b.key] ?? 0,
        comment: comments[b.key] || undefined,
      })).filter(s => s.score > 0),
    }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["my-evaluation", cycleId] });
      queryClient.invalidateQueries({ queryKey: ["team-status", cycleId] });
      toast({ title: "Avaliação enviada com sucesso!" });
      onSuccess?.();
    },
    onError: (err: Error) => toast({ title: "Erro ao enviar avaliação", description: err.message, variant: "destructive" }),
  });

  const allScored = BEHAVIORS.every(b => (scores[b.key] ?? 0) > 0);
  const pillars = ["cultura", "entregas", "desenvolvimento"] as const;

  return (
    <div className="space-y-8">
      {evaluatedName && evalType !== "self" && (
        <div className="rounded-lg bg-muted/40 px-4 py-3 text-sm">
          Avaliando: <span className="font-semibold">{evaluatedName}</span>
        </div>
      )}

      {pillars.map((pillar) => {
        const info = PILLAR_INFO[pillar];
        const pillarBehaviors = BEHAVIORS.filter(b => b.pillar === pillar);
        const pillarAvg = pillarBehaviors
          .map(b => scores[b.key] ?? 0)
          .filter(v => v > 0)
          .reduce((sum, v, _, arr) => sum + v / arr.length, 0);

        return (
          <section key={pillar} className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <h3 className={`font-semibold text-sm uppercase tracking-wide ${info.color}`}>
                  {info.label}
                </h3>
                <Badge variant="outline" className="text-xs">{Math.round(info.weight * 100)}%</Badge>
              </div>
              {pillarAvg > 0 && (
                <span className="text-xs text-muted-foreground">
                  Média: {pillarAvg.toFixed(1)}
                </span>
              )}
            </div>

            <div className="space-y-5 pl-2">
              {pillarBehaviors.map((behavior) => (
                <div key={behavior.key} className="space-y-2">
                  <p className="text-sm font-medium">{behavior.label}</p>
                  <StarRating
                    value={scores[behavior.key] ?? 0}
                    onChange={(v) => setScores(prev => ({ ...prev, [behavior.key]: v }))}
                  />
                  <Textarea
                    value={comments[behavior.key] ?? ""}
                    onChange={(e) => setComments(prev => ({ ...prev, [behavior.key]: e.target.value }))}
                    placeholder="Comentário (opcional)..."
                    rows={2}
                    className="resize-none text-sm"
                  />
                </div>
              ))}
            </div>
          </section>
        );
      })}

      <div className="flex items-center justify-between pt-4 border-t">
        {allScored ? (
          <span className="flex items-center gap-1.5 text-sm text-emerald-600 dark:text-emerald-400">
            <CheckCircle2 className="h-4 w-4" /> Todos os comportamentos avaliados
          </span>
        ) : (
          <span className="text-sm text-muted-foreground">
            {BEHAVIORS.filter(b => (scores[b.key] ?? 0) === 0).length} comportamento(s) sem nota
          </span>
        )}
        <Button
          onClick={() => mutation.mutate()}
          disabled={!allScored || mutation.isPending}
        >
          {mutation.isPending ? "Enviando..." : "Enviar Avaliação"}
        </Button>
      </div>
    </div>
  );
}
