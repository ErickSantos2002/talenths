import { profiles, departments } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Building2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { useQuery } from "@tanstack/react-query";

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

  const statCards = [
    { title: "Colaboradores", value: allProfiles.length, icon: Users, color: "text-primary" },
    { title: "Departamentos", value: deptList.length, icon: Building2, color: "text-brand-red" },
  ];

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <h1 className="text-2xl font-bold text-foreground">
          {isMasterAdmin ? "Gestão de Empresa" : "Minha Empresa"}
        </h1>

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {statCards.map((s) => (
            <Card key={s.title} className="shadow-card">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">{s.title}</CardTitle>
                <s.icon className={`h-5 w-5 ${s.color}`} />
              </CardHeader>
              <CardContent>
                {loading ? <Skeleton className="h-9 w-12" /> : <div className="text-3xl font-bold text-card-foreground">{s.value}</div>}
              </CardContent>
            </Card>
          ))}
        </div>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">Departamentos</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
            ) : deptList.length === 0 ? (
              <p className="py-8 text-center text-muted-foreground">Nenhum departamento cadastrado.</p>
            ) : (
              <div className="space-y-2">
                {deptList.map((d: any) => {
                  const count = allProfiles.filter((p: any) => p.department_id === d.id).length;
                  return (
                    <div key={d.id} className="flex items-center justify-between rounded-lg border border-border p-3">
                      <span className="font-medium text-foreground">{d.name}</span>
                      <Badge variant="outline" className="text-xs">{count} colaborador{count !== 1 ? "es" : ""}</Badge>
                    </div>
                  );
                })}
              </div>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">Colaboradores</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
            ) : allProfiles.length === 0 ? (
              <p className="py-8 text-center text-muted-foreground">Nenhum colaborador cadastrado.</p>
            ) : (
              <div className="space-y-2">
                {allProfiles.map((p: any) => (
                  <div key={p.user_id} className="flex items-center justify-between rounded-lg border border-border p-3">
                    <div>
                      <p className="font-medium text-foreground">{p.name}</p>
                      <p className="text-xs text-muted-foreground">{p.email ?? ""}</p>
                    </div>
                    {p.department_id ? (
                      <Badge variant="outline" className="text-xs">{deptMap[p.department_id] ?? "—"}</Badge>
                    ) : (
                      <span className="text-xs text-muted-foreground">Sem departamento</span>
                    )}
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
}
