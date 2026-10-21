import { HelpCircle } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { Link, useLocation } from "react-router-dom";

import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import { Skeleton } from "@/components/ui/skeleton";
import { useAuth } from "@/contexts/AuthContext";
import { GuideLoadError } from "@/help/GuideLoadError";
import { LazyGuideContent } from "@/help/LazyGuideContent";
import { MODULES, guidesFor, guidesForPath, useGuides, type Guide } from "@/help/guides";
import { matchScreen } from "@/help/screens";
import { useTour } from "@/help/TourProvider";
import { asTour, screenTourFor, whatsNew } from "@/help/tourRules";
import { SCREEN_TOURS } from "@/help/tours/screenTours";
import type { Tour } from "@/help/tours/types";

function GuideList({ guides, heading, onNavigate }: { guides: Guide[]; heading: string; onNavigate: () => void }) {
  if (guides.length === 0) return null;
  return (
    <section className="space-y-2">
      <h3 className="text-sm font-semibold">{heading}</h3>
      <ul className="space-y-1">
        {guides.map((g) => (
          <li key={`${g.module}/${g.slug}`}>
            <Link to={`/ajuda/${g.module}/${g.slug}`} onClick={onNavigate} className="text-sm text-primary hover:underline">
              {g.title}
            </Link>
          </li>
        ))}
      </ul>
    </section>
  );
}

export function HelpButton() {
  const [open, setOpen] = useState(false);
  const { pathname } = useLocation();
  const { active, welcome, progress, progressAll, showScreenTour, viewWhatsNew, dismissWhatsNew } = useTour();
  const { roles, profile } = useAuth();
  const { guides, isLoading, isError } = useGuides(open);

  useEffect(() => {
    setOpen(false);
  }, [pathname]);

  useEffect(() => {
    if (active) setOpen(false);
  }, [active]);

  const found = useMemo(() => {
    if (!guides) return null;
    const visible = guidesFor(guides, { roles, timeclockEnabled: !!profile?.timeclock_enabled });
    return guidesForPath(visible, pathname);
  }, [guides, roles, profile?.timeclock_enabled, pathname]);

  // The screen tour comes from the current screen, not from the guide: one guide
  // can cover several screens, and only some of them have a tour.
  const screenTour = screenTourFor(SCREEN_TOURS, matchScreen(pathname)?.path ?? null, roles);
  const cuts = useMemo(() => {
    const list: { label: string; cut: Tour }[] = [];
    const welcomeCut = welcome && whatsNew(welcome, progress);
    if (welcomeCut) list.push({ label: "O tour de boas-vindas", cut: welcomeCut });
    if (screenTour) {
      const screenCut = whatsNew(asTour(screenTour), progressAll.find((p) => p.tour === screenTour.id) ?? null);
      if (screenCut) list.push({ label: "O tour desta tela", cut: screenCut });
    }
    return list;
  }, [welcome, progress, progressAll, screenTour]);

  const moduleName = found?.others[0] ? MODULES.find((m) => m.id === found.others[0].module)?.name : undefined;
  const listHeading =
    found?.origin === "screen"
      ? "Outros guias desta tela"
      : found?.origin === "module"
        ? `Guias de ${moduleName ?? ""}`
        : "Primeiros passos";

  return (
    <>
      <Button
        variant="ghost"
        size="icon"
        data-tour="help-button"
        className="relative"
        aria-label="Ajuda desta tela"
        onClick={() => setOpen(true)}
      >
        <HelpCircle className="h-5 w-5" />
        {cuts.length > 0 && (
          <>
            <span aria-hidden="true" className="absolute right-1 top-1 h-2 w-2 rounded-full bg-primary" />
            <span className="sr-only">(há novidades)</span>
          </>
        )}
      </Button>
      <Sheet open={open} onOpenChange={setOpen}>
        <SheetContent side="right" className="w-full overflow-y-auto sm:max-w-md">
          <SheetHeader>
            <SheetTitle>{found?.main ? found.main.title : "Ajuda desta tela"}</SheetTitle>
            <SheetDescription className="sr-only">Guia da tela em que você está.</SheetDescription>
          </SheetHeader>
          {screenTour && (
            <Button
              variant="outline"
              size="sm"
              className="mt-3"
              onClick={() => { setOpen(false); showScreenTour(screenTour); }}
            >
              Mostrar nesta tela
            </Button>
          )}
          <div className="mt-4 space-y-6">
            {cuts.map(({ label, cut }) => (
              <section key={cut.id} className="space-y-2 rounded-md border border-primary/40 bg-primary/5 p-3">
                <h3 className="text-sm font-semibold">O que mudou</h3>
                <p className="text-sm">
                  {label} ganhou {cut.steps.length === 1 ? "1 passo novo" : `${cut.steps.length} passos novos`}.
                </p>
                <div className="flex gap-2">
                  <Button size="sm" onClick={() => { setOpen(false); viewWhatsNew(cut); }}>
                    Ver o que mudou
                  </Button>
                  <Button size="sm" variant="ghost" onClick={() => { setOpen(false); dismissWhatsNew(cut); }}>
                    Dispensar
                  </Button>
                </div>
              </section>
            ))}
            {isLoading || (!guides && !isError) ? (
              <div className="space-y-3">
                <Skeleton className="h-6 w-1/2" />
                <Skeleton className="h-32 w-full" />
              </div>
            ) : isError ? (
              <GuideLoadError />
            ) : (
              found && (
                <>
                  {found.main && <LazyGuideContent body={found.main.body} />}
                  <GuideList guides={found.others} heading={listHeading} onNavigate={() => setOpen(false)} />
                </>
              )
            )}
            <Link to="/ajuda" onClick={() => setOpen(false)} className="block text-sm font-medium text-primary underline">
              Abrir a central de ajuda
            </Link>
          </div>
        </SheetContent>
      </Sheet>
    </>
  );
}
