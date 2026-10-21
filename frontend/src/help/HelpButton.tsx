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
import { useTour } from "@/help/TourProvider";

function GuideList({ guides, heading }: { guides: Guide[]; heading: string }) {
  if (guides.length === 0) return null;
  return (
    <section className="space-y-2">
      <h3 className="text-sm font-semibold">{heading}</h3>
      <ul className="space-y-1">
        {guides.map((g) => (
          <li key={`${g.module}/${g.slug}`}>
            <Link to={`/ajuda/${g.module}/${g.slug}`} className="text-sm text-primary hover:underline">
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
  const { active } = useTour();
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
        aria-label="Ajuda desta tela"
        onClick={() => setOpen(true)}
      >
        <HelpCircle className="h-5 w-5" />
      </Button>
      <Sheet open={open} onOpenChange={setOpen}>
        <SheetContent side="right" className="w-full overflow-y-auto sm:max-w-md">
          <SheetHeader>
            <SheetTitle>{found?.main ? found.main.title : "Ajuda desta tela"}</SheetTitle>
            <SheetDescription className="sr-only">Guia da tela em que você está.</SheetDescription>
          </SheetHeader>
          <div className="mt-4 space-y-6">
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
                  <GuideList guides={found.others} heading={listHeading} />
                </>
              )
            )}
            <Link to="/ajuda" className="block text-sm font-medium text-primary underline">
              Abrir a central de ajuda
            </Link>
          </div>
        </SheetContent>
      </Sheet>
    </>
  );
}
