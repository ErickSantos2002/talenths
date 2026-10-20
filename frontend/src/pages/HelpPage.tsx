import { LifeBuoy } from "lucide-react";
import { useMemo } from "react";
import { Link, useSearchParams } from "react-router-dom";

import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import { useAuth } from "@/contexts/AuthContext";
import { MODULES, guidesFor, searchGuides, useGuides } from "@/help/guides";
import { useTour } from "@/help/TourProvider";
import { tourStatus } from "@/help/tourRules";

export default function HelpPage() {
  const { welcome, progress, loaded, startWelcome } = useTour();
  const { roles, profile } = useAuth();
  const { guides, isLoading, isError, refetch } = useGuides(true);
  const [searchParams, setSearchParams] = useSearchParams();
  const query = searchParams.get("busca") ?? "";
  const hasQuery = query.trim() !== "";

  const visible = useMemo(
    () => (guides ? guidesFor(guides, { roles, timeclockEnabled: !!profile?.timeclock_enabled }) : []),
    [guides, roles, profile?.timeclock_enabled],
  );
  const results = useMemo(() => (hasQuery ? searchGuides(visible, query) : []), [visible, query, hasQuery]);
  const moduleName = (id: string) => MODULES.find((m) => m.id === id)?.name ?? id;

  const announcement =
    !hasQuery || !guides
      ? ""
      : results.length === 0
        ? "Nenhum guia encontrado"
        : results.length === 1
          ? "1 guia encontrado"
          : `${results.length} guias encontrados`;

  const setQuery = (value: string) => setSearchParams(value ? { busca: value } : {}, { replace: true });

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

        <div className="space-y-2">
          <label htmlFor="help-search" className="text-sm font-medium">
            Buscar na ajuda
          </label>
          <Input
            id="help-search"
            data-tour="help-search"
            type="search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Ex.: avaliação, férias, vídeos"
          />
          <p aria-live="polite" className="min-h-5 text-sm text-muted-foreground">
            {announcement}
          </p>
        </div>

        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-24 w-full" />
            <Skeleton className="h-24 w-full" />
          </div>
        ) : isError ? (
          <div className="space-y-3">
            <p className="text-sm">Não foi possível carregar os guias.</p>
            <Button variant="outline" onClick={() => refetch()}>
              Tentar de novo
            </Button>
          </div>
        ) : hasQuery ? (
          results.length === 0 ? (
            <Link to="/ajuda" replace className="text-sm text-primary underline">
              Ver todos os guias
            </Link>
          ) : (
            <ul className="space-y-2">
              {results.map((g) => (
                <li key={`${g.module}/${g.slug}`}>
                  <Link to={`/ajuda/${g.module}/${g.slug}`} className="block rounded-md border p-3 hover:bg-muted">
                    <span className="font-medium">{g.title}</span>
                    <span className="block text-xs text-muted-foreground">{moduleName(g.module)}</span>
                  </Link>
                </li>
              ))}
            </ul>
          )
        ) : (
          <div className="grid gap-4 md:grid-cols-2">
            {MODULES.map((m) => {
              const items = visible.filter((g) => g.module === m.id);
              if (!items.length) return null;
              return (
                <Card key={m.id}>
                  <CardHeader>
                    <h2 className="text-base font-semibold leading-none tracking-tight">{m.name}</h2>
                  </CardHeader>
                  <CardContent>
                    <ul className="space-y-1">
                      {items.map((g) => (
                        <li key={g.slug}>
                          <Link to={`/ajuda/${g.module}/${g.slug}`} className="text-sm text-primary hover:underline">
                            {g.title}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
