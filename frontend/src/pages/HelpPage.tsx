import { LifeBuoy } from "lucide-react";

import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { useTour } from "@/help/TourProvider";
import { tourStatus } from "@/help/tourRules";

export default function HelpPage() {
  const { welcome, progress, loaded, startWelcome } = useTour();

  const status = loaded && welcome ? tourStatus(progress, welcome) : null;
  const label =
    status?.kind === "done"
      ? `Concluído em ${status.date}`
      : status?.kind === "stopped"
        ? `Parou no passo ${status.step} de ${status.total}`
        : status
          ? "Você ainda não fez"
          : null;

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <LifeBuoy className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold">Ajuda</h1>
        </div>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0">
            <CardTitle className="text-base">Tour de boas-vindas</CardTitle>
            {label && <Badge variant="secondary">{label}</Badge>}
          </CardHeader>
          <CardContent className="space-y-4">
            <p className="text-sm text-muted-foreground">
              Um passeio rápido pelas principais telas do TalentHS. Você pode refazê-lo quando quiser.
            </p>
            <Button data-tour="help-start-tour" disabled={!loaded} onClick={() => startWelcome()}>
              Fazer o tour de boas-vindas
            </Button>
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
}
