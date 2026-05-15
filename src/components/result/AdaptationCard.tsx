import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RefreshCw } from "lucide-react";
import { DniaInfoIcon } from "@/components/DniaInfoIcon";

interface DiscScores {
  D: number;
  I: number;
  S: number;
  C: number;
}

import { dniaDimensions, discToDisplayKey } from "@/data/dniaLabels";

const factorLabels = dniaDimensions;

const factorCharacteristics: Record<string, { high: string; low: string }> = {
  D: { high: "assertivo(a) e direto(a)", low: "colaborativo(a) e paciente" },
  I: { high: "comunicativo(a) e expressivo(a)", low: "reservado(a) e reflexivo(a)" },
  S: { high: "estável e consistente", low: "flexível e adaptável" },
  C: { high: "metódico(a) e detalhista", low: "flexível e pragmático(a)" },
};

function getInsight(factor: string, natural: number, adapted: number): string {
  const diff = adapted - natural;
  const chars = factorCharacteristics[factor];
  if (diff > 0) {
    return `Tem menos ${factorLabels[factor]} naturalmente, mas se adapta sendo mais ${chars.high} no trabalho.`;
  }
  if (diff < 0) {
    return `Tem mais ${factorLabels[factor]} naturalmente, mas se adapta sendo mais ${chars.low} no trabalho.`;
  }
  return `Mantém o mesmo nível de ${factorLabels[factor]} tanto no ambiente natural quanto no trabalho.`;
}

interface AdaptationCardProps {
  natural: DiscScores;
  adapted: DiscScores;
}

export function AdaptationCard({ natural, adapted }: AdaptationCardProps) {
  const factors = (["D", "I", "S", "C"] as const);
  const colors: Record<string, string> = {
    D: "bg-destructive/10 text-destructive",
    I: "bg-accent/10 text-accent",
    S: "bg-secondary/10 text-secondary",
    C: "bg-primary/10 text-primary",
  };

  return (
    <Card className="border-l-4 border-l-accent border-border bg-card shadow-card">
      <CardHeader className="pb-2">
        <CardTitle className="flex items-center gap-2 text-lg text-card-foreground">
          <RefreshCw className="h-5 w-5 text-accent" />
          Como Você Se Adapta
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-3">
        {factors.map((f) => {
          const diff = adapted[f] - natural[f];
          return (
            <div key={f} className="flex items-start gap-3">
              <span className={`mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-md text-xs font-bold ${colors[f]}`}>
                {discToDisplayKey[f]}
              </span>
              <div className="flex-1">
                <div className="flex items-center gap-1">
                  <p className="text-sm font-medium text-foreground">
                    {factorLabels[f]}
                  </p>
                  <DniaInfoIcon letter={f === "S" ? "N" : f === "C" ? "A" : f as "D" | "I"} className="h-4 w-4" />
                </div>
                <p className="text-xs text-muted-foreground">
                  Natural: {natural[f]} → Adaptado: {adapted[f]}{" "}
                  {diff !== 0 && (
                    <span className={diff > 0 ? "text-secondary" : "text-destructive"}>
                      {diff > 0 ? `+${diff}` : diff}
                    </span>
                  )}
                </p>
                <p className="text-sm text-muted-foreground leading-relaxed">
                  {getInsight(f, natural[f], adapted[f])}
                </p>
              </div>
            </div>
          );
        })}
      </CardContent>
    </Card>
  );
}
