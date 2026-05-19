import { useQuery } from "@tanstack/react-query";
import { benefits as benefitsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import type { BenefitCategory, BenefitValueType } from "@/types/benefits";
import { Gift } from "lucide-react";
import { cn } from "@/lib/utils";

// ── Helpers ───────────────────────────────────────────────────────────────────

const CATEGORY_LABELS: Record<BenefitCategory, string> = {
  saude: "Saúde",
  alimentacao: "Alimentação",
  transporte: "Transporte",
  financeiro: "Financeiro",
  educacao: "Educação",
  bem_estar: "Bem-estar",
  outro: "Outro",
};

const CATEGORY_COLORS: Record<BenefitCategory, string> = {
  saude: "bg-blue-500",
  alimentacao: "bg-orange-500",
  transporte: "bg-green-500",
  financeiro: "bg-purple-500",
  educacao: "bg-indigo-500",
  bem_estar: "bg-pink-500",
  outro: "bg-gray-400",
};

function formatValue(valueType: BenefitValueType, value?: number): string {
  if (!value) return "Incluso";
  if (valueType === "percentage") return `${value}%`;
  if (valueType === "fixed" || valueType === "variable")
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
  return "Incluso";
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function MeusBeneficiosPage() {
  const { data: myBenefits = [], isLoading } = useQuery({
    queryKey: ["benefits-my"],
    queryFn: benefitsApi.my,
  });

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Gift className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-bold tracking-tight">Meus Benefícios</h1>
          </div>
          {myBenefits.length > 0 && (
            <p className="text-sm text-muted-foreground">
              {myBenefits.length} benefício{myBenefits.length !== 1 ? "s" : ""} ativo{myBenefits.length !== 1 ? "s" : ""}
            </p>
          )}
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : myBenefits.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <Gift className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum benefício atribuído ainda.</p>
            <p className="text-xs text-muted-foreground mt-1">Fale com o seu gestor para mais informações.</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {myBenefits.map((b) => (
              <Card key={b.id} className="overflow-hidden">
                <div
                  className={cn(
                    "h-1.5 w-full",
                    CATEGORY_COLORS[b.benefit_category ?? "outro"]
                  )}
                />
                <CardContent className="p-4 space-y-2">
                  <div>
                    <p className="font-semibold text-base">{b.benefit_name}</p>
                    {b.benefit_provider && (
                      <p className="text-xs text-muted-foreground">{b.benefit_provider}</p>
                    )}
                  </div>

                  <p className="text-sm font-medium text-primary">
                    {formatValue(b.value_type ?? "info", b.value ?? undefined)}
                  </p>

                  <div className="space-y-0.5 text-xs text-muted-foreground">
                    <p>{CATEGORY_LABELS[b.benefit_category ?? "outro"]}</p>
                    {b.start_date && (
                      <p>
                        Desde{" "}
                        {new Date(b.start_date + "T12:00:00").toLocaleDateString("pt-BR", {
                          month: "long",
                          year: "numeric",
                        })}
                      </p>
                    )}
                    {b.notes && <p className="italic mt-1">"{b.notes}"</p>}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
