import { Compass } from "lucide-react";

import {
  AlertDialog, AlertDialogAction, AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useAuth } from "@/contexts/AuthContext";
import { useTour } from "@/help/TourProvider";
import { mustTakeTour, resumeStep } from "@/help/tourRules";

export function WelcomeTourModal() {
  const { user, profile } = useAuth();
  const { welcome, progress, loaded, active, prompted, beginWelcome } = useTour();

  // `profile` arrives together with the roles; before that, the audience (and
  // so the tour offered) could be the wrong one.
  const open = !!user && !!profile && !!welcome && loaded && !active && !prompted && mustTakeTour(progress);
  const resumable = resumeStep(progress, welcome) !== null;

  // Always mounted and closed through `open`: unmounting an open Radix dialog
  // can leave `pointer-events: none` on <body>, blocking the tour popover.
  return (
    <AlertDialog open={open}>
      <AlertDialogContent onEscapeKeyDown={(e) => e.preventDefault()}>
        <AlertDialogHeader>
          <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
            <Compass className="h-5 w-5" />
          </div>
          <AlertDialogTitle>Bem-vindo ao TalentHS</AlertDialogTitle>
          <AlertDialogDescription>
            {resumable
              ? "Você ainda não terminou o tour de boas-vindas. Continue de onde parou para conhecer onde fica cada coisa no sistema."
              : "Antes de começar, faça um tour rápido para conhecer onde fica cada coisa no sistema, incluindo os vídeos que você precisa assistir."}
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogAction autoFocus onClick={beginWelcome}>
            {resumable ? "Continuar de onde parou" : "Começar o tour"}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
