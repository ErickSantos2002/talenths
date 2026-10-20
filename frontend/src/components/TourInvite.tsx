import { useState } from "react";
import { toast } from "sonner";
import { Compass } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { useAuth } from "@/contexts/AuthContext";
import { useTour } from "@/help/TourProvider";
import { resumeStep, shouldInvite } from "@/help/tourRules";

const snoozeKey = (userId: string) => `talenths_tour_invite_snoozed_${userId}`;

function readSnoozed(userId: string | undefined): boolean {
  if (!userId) return false;
  try {
    return sessionStorage.getItem(snoozeKey(userId)) === "1";
  } catch {
    return false;
  }
}

export function TourInvite() {
  const { user, profile } = useAuth();
  const { welcome, progress, loaded, active, startWelcome, declineInvite, dismissInvite } = useTour();
  const [snoozedNow, setSnoozedNow] = useState(false);
  const [busy, setBusy] = useState(false);

  // `profile` arrives together with the roles; before that, the audience (and
  // so the tour offered) could be the wrong one.
  if (!loaded || active || !user || !profile) return null;
  if (!shouldInvite(progress) || snoozedNow || readSnoozed(user.id)) return null;

  const resumable = resumeStep(progress, welcome) !== null;

  const snooze = async () => {
    try {
      sessionStorage.setItem(snoozeKey(user.id), "1");
    } catch {
      // sem sessionStorage, o convite só some nesta montagem
    }
    setSnoozedNow(true);
    try {
      await declineInvite();
    } catch {
      toast.error("Não foi possível registrar sua resposta. Tente novamente.");
    }
  };

  const dismiss = async () => {
    setBusy(true);
    try {
      await dismissInvite();
    } catch {
      toast.error("Não foi possível salvar sua escolha. Tente novamente.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <Card className="border-primary/30 bg-primary/5">
      <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
        <div className="flex flex-1 items-start gap-4">
          <div className="mt-0.5 shrink-0 rounded-lg bg-primary/10 p-2.5 text-primary">
            <Compass className="h-5 w-5" />
          </div>
          <div>
            <h2 className="text-sm font-semibold">Conheça o TalentHS</h2>
            <p className="mt-0.5 text-xs leading-relaxed text-muted-foreground">
              Um tour rápido mostra onde fica cada coisa e como aproveitar o sistema.
            </p>
          </div>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={() => startWelcome()}>
            {resumable ? "Continuar o tour" : "Começar"}
          </Button>
          <Button size="sm" variant="outline" onClick={snooze}>Agora não</Button>
          <Button size="sm" variant="ghost" disabled={busy} onClick={dismiss}>Não mostrar mais</Button>
        </div>
      </CardContent>
    </Card>
  );
}
