import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Building2 } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { profiles, departments } from "@/lib/api";
import { Skeleton } from "@/components/ui/skeleton";

function CollaboratorDashboard({ profile }: { profile: any }) {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Meu Painel</h1>
        <p className="mt-1 text-muted-foreground">
          Bem-vindo de volta, {profile?.name ?? "Usuário"}
        </p>
      </div>
      <p className="text-muted-foreground">
        Use o menu lateral para navegar pelas suas avaliações, PDI, aprendizados e mais.
      </p>
    </div>
  );
}

export default function DashboardPage() {
  const { profile, hasRole, selectedCompanyId } = useAuth();

  const isManager = hasRole("master_admin") || hasRole("manager");

  const isMaster = hasRole("master_admin");
  const companyFilter = isMaster ? selectedCompanyId : profile?.company_id;

  const { data: profilesData = [], isLoading: loadingProfiles } = useQuery({
    queryKey: ["profiles", companyFilter],
    queryFn: () => profiles.list(companyFilter ?? undefined),
    enabled: !!isManager,
  });

  const { data: deptsData = [], isLoading: loadingDepts } = useQuery({
    queryKey: ["departments", companyFilter],
    queryFn: () => departments.list(companyFilter ?? undefined),
    enabled: !!isManager,
  });

  if (!isManager) {
    return (
      <AdminLayout>
        <CollaboratorDashboard profile={profile} />
      </AdminLayout>
    );
  }

  const loading = loadingProfiles || loadingDepts;

  const stats = [
    { title: "Colaboradores", value: (profilesData as any[]).length, icon: Users, color: "text-primary" },
    { title: "Departamentos", value: (deptsData as any[]).length, icon: Building2, color: "text-brand-red" },
  ];

  return (
    <AdminLayout>
      <div className="space-y-8">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Dashboard</h1>
          <p className="mt-1 text-muted-foreground">
            Bem-vindo de volta, {profile?.name ?? "Usuário"}
          </p>
        </div>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {stats.map((stat) => (
            <Card key={stat.title} className="shadow-card transition-shadow hover:shadow-card-hover">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">
                  {stat.title}
                </CardTitle>
                <stat.icon className={`h-5 w-5 ${stat.color}`} />
              </CardHeader>
              <CardContent>
                {loading ? (
                  <Skeleton className="h-9 w-16" />
                ) : (
                  <div className="text-3xl font-bold text-card-foreground">{stat.value}</div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </AdminLayout>
  );
}
