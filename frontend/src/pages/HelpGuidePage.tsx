import { LifeBuoy } from "lucide-react";
import { useEffect, useMemo } from "react";
import { Link, useParams } from "react-router-dom";

import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { useAuth } from "@/contexts/AuthContext";
import { LazyGuideContent } from "@/help/LazyGuideContent";
import { MODULES, findGuide, guidesFor, useGuides } from "@/help/guides";

export default function HelpGuidePage() {
  const { module = "", slug = "" } = useParams();
  const { roles, profile } = useAuth();
  const { guides, isLoading, isError, refetch } = useGuides(true);

  const visible = useMemo(
    () => (guides ? guidesFor(guides, { roles, timeclockEnabled: !!profile?.timeclock_enabled }) : []),
    [guides, roles, profile?.timeclock_enabled],
  );
  const guide = findGuide(visible, module, slug);
  const moduleName = MODULES.find((m) => m.id === module)?.name ?? module;
  const siblings = guide ? visible.filter((g) => g.module === guide.module && g.slug !== guide.slug) : [];

  useEffect(() => {
    if (!guide) return;
    const previous = document.title;
    document.title = `${guide.title} · Ajuda · TalentHS`;
    return () => {
      document.title = previous;
    };
  }, [guide]);

  return (
    <AdminLayout>
      <div className="space-y-6">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-8 w-1/2" />
            <Skeleton className="h-40 w-full" />
          </div>
        ) : isError ? (
          <div className="space-y-3">
            <p className="text-sm">Não foi possível carregar os guias.</p>
            <Button variant="outline" onClick={() => refetch()}>
              Tentar de novo
            </Button>
          </div>
        ) : !guide ? (
          <div className="space-y-3">
            <h1 className="text-2xl font-bold">Guia não encontrado</h1>
            <Link to="/ajuda" className="text-sm text-primary underline">
              Voltar para a Ajuda
            </Link>
          </div>
        ) : (
          <>
            <nav aria-label="Você está em" className="flex items-center gap-2 text-sm text-muted-foreground">
              <LifeBuoy className="h-4 w-4" />
              <Link to="/ajuda" className="hover:underline">
                Ajuda
              </Link>
              <span aria-hidden="true">›</span>
              <span>{moduleName}</span>
            </nav>
            <div className="grid gap-8 lg:grid-cols-[1fr_16rem]">
              <article className="space-y-4">
                <h1 className="text-2xl font-bold">{guide.title}</h1>
                <LazyGuideContent body={guide.body} />
              </article>
              {siblings.length > 0 && (
                <aside className="space-y-2">
                  <h2 className="text-sm font-semibold">Mais sobre {moduleName}</h2>
                  <ul className="space-y-1">
                    {siblings.map((g) => (
                      <li key={g.slug}>
                        <Link to={`/ajuda/${g.module}/${g.slug}`} className="text-sm text-primary hover:underline">
                          {g.title}
                        </Link>
                      </li>
                    ))}
                  </ul>
                </aside>
              )}
            </div>
          </>
        )}
      </div>
    </AdminLayout>
  );
}
