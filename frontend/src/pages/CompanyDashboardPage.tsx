import { profiles, departments } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Building2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { useQuery } from "@tanstack/react-query";

function Initials({ name }: { name: string }) {
  const parts = name.trim().split(" ");
  const letters = parts.length >= 2
    ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
    : name.slice(0, 2).toUpperCase();

  const colors = [
    "bg-primary/20 text-primary",
    "bg-blue-500/20 text-blue-400",
    "bg-violet-500/20 text-violet-400",
    "bg-amber-500/20 text-amber-400",
    "bg-rose-500/20 text-rose-400",
    "bg-cyan-500/20 text-cyan-400",
  ];
  const color = colors[name.charCodeAt(0) % colors.length];

  return (
    <div className={`h-8 w-8 rounded-full flex items-center justify-center text-xs font-semibold shrink-0 ${color}`}>
      {letters}
    </div>
  );
}

export default function CompanyDashboardPage() {
  const { profile, hasRole, selectedCompanyId } = useAuth();

  const isMasterAdmin = hasRole("master_admin");
  const companyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;

  const { data: profilesData = [], isLoading: loadingProfiles } = useQuery({
    queryKey: ["profiles", companyId],
    queryFn: () => profiles.list(companyId ?? undefined),
    enabled: !!companyId,
  });

  const { data: deptsData = [], isLoading: loadingDepts } = useQuery({
    queryKey: ["departments", companyId],
    queryFn: () => departments.list(companyId ?? undefined),
    enabled: !!companyId,
  });

  const loading = loadingProfiles || loadingDepts;
  const allProfiles = profilesData as any[];
  const deptList = deptsData as any[];
  const deptMap = Object.fromEntries(deptList.map((d: any) => [d.id, d.name]));

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-8">
        <h1 className="text-2xl font-bold">
          {isMasterAdmin ? "Gestão de Empresa" : "Minha Empresa"}
        </h1>

        {/* Stats */}
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <Card className="hover:shadow-md hover:border-primary/20 transition-all">
            <CardContent className="p-5">
              <div className="flex items-center justify-between mb-3">
                <p className="text-sm text-muted-foreground font-medium">Colaboradores</p>
                <div className="rounded-lg p-2 bg-primary/10">
                  <Users className="h-4 w-4 text-primary" />
                </div>
              </div>
              {loading ? <Skeleton className="h-9 w-12" /> : <p className="text-3xl font-bold tracking-tight">{allProfiles.length}</p>}
            </CardContent>
          </Card>
          <Card className="hover:shadow-md hover:border-blue-500/20 transition-all">
            <CardContent className="p-5">
              <div className="flex items-center justify-between mb-3">
                <p className="text-sm text-muted-foreground font-medium">Departamentos</p>
                <div className="rounded-lg p-2 bg-blue-500/10">
                  <Building2 className="h-4 w-4 text-blue-400" />
                </div>
              </div>
              {loading ? <Skeleton className="h-9 w-12" /> : <p className="text-3xl font-bold tracking-tight">{deptList.length}</p>}
            </CardContent>
          </Card>
        </div>

        {/* Departamentos */}
        <div className="space-y-3">
          <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">Departamentos</h2>
          {loading ? (
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {[1,2,3,4,5,6].map((i) => <Skeleton key={i} className="h-16 w-full rounded-lg" />)}
            </div>
          ) : deptList.length === 0 ? (
            <p className="text-sm text-muted-foreground">Nenhum departamento cadastrado.</p>
          ) : (
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {deptList.map((d: any) => {
                const count = allProfiles.filter((p: any) => p.department_id === d.id).length;
                return (
                  <div key={d.id} className="flex items-center justify-between rounded-lg border bg-card px-4 py-3 hover:bg-muted/30 transition-colors">
                    <div className="flex items-center gap-3">
                      <div className="rounded-md bg-blue-500/10 p-1.5">
                        <Building2 className="h-3.5 w-3.5 text-blue-400" />
                      </div>
                      <span className="font-medium text-sm">{d.name}</span>
                    </div>
                    <span className="text-xs font-semibold tabular-nums text-muted-foreground">
                      {count} <span className="font-normal">{count !== 1 ? "pessoas" : "pessoa"}</span>
                    </span>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Colaboradores */}
        <div className="space-y-3">
          <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">
            Colaboradores {!loading && <span className="normal-case font-normal">({allProfiles.length})</span>}
          </h2>
          {loading ? (
            <div className="space-y-2">
              {[1,2,3,4,5].map((i) => <Skeleton key={i} className="h-14 w-full rounded-lg" />)}
            </div>
          ) : allProfiles.length === 0 ? (
            <p className="text-sm text-muted-foreground">Nenhum colaborador cadastrado.</p>
          ) : (
            <Card>
              <CardContent className="p-0">
                <div className="divide-y divide-border">
                  {allProfiles.map((p: any) => (
                    <div key={p.user_id} className="flex items-center gap-3 px-4 py-3 hover:bg-muted/30 transition-colors">
                      <Initials name={p.name ?? "?"} />
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium truncate">{p.name}</p>
                        <p className="text-xs text-muted-foreground truncate">{p.email ?? ""}</p>
                      </div>
                      {p.department_id ? (
                        <span className="text-xs text-muted-foreground shrink-0">{deptMap[p.department_id] ?? "—"}</span>
                      ) : (
                        <span className="text-xs text-muted-foreground/40 shrink-0 italic">Sem departamento</span>
                      )}
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </AdminLayout>
  );
}
