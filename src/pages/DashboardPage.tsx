import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { supabase } from "@/integrations/supabase/client";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Users, Building2, ClipboardList, TrendingUp, Clock, Eye, AlertTriangle } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

interface RecentActivity {
  userName: string;
  completedAt: string;
}

interface TestItem {
  id: string;
  completed_at: string;
  disc_natural: { D: number; I: number; S: number; C: number };
}

import { dniaDimensions, discToDisplayKey } from "@/data/dniaLabels";
const discLabels = dniaDimensions;

function getDominantProfile(disc: { D: number; I: number; S: number; C: number }): string {
  const entries = Object.entries(disc) as [string, number][];
  entries.sort((a, b) => b[1] - a[1]);
  return `${discToDisplayKey[entries[0][0]] || entries[0][0]} - ${discLabels[entries[0][0]]}`;
}

function CollaboratorDashboard({ profile, user }: { profile: any; user: any }) {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [tests, setTests] = useState<TestItem[]>([]);

  useEffect(() => {
    if (!user) return;
    const fetchTests = async () => {
      const { data } = await supabase
        .from("test_results")
        .select("id, completed_at, disc_natural")
        .eq("user_id", user.id)
        .order("completed_at", { ascending: false });
      setTests((data as unknown as TestItem[]) ?? []);
      setLoading(false);
    };
    fetchTests();
  }, [user]);

  return (
    <div className="space-y-8">
      {!profile?.cpf && (
        <Card className="border-yellow-500/50 bg-yellow-500/10 shadow-card">
          <CardContent className="flex items-center gap-4 py-4">
            <AlertTriangle className="h-6 w-6 shrink-0 text-yellow-600" />
            <div className="flex-1">
              <p className="font-medium text-foreground">Complete seu cadastro</p>
              <p className="text-sm text-muted-foreground">Informe seu CPF para poder realizar testes.</p>
            </div>
            <Button size="sm" onClick={() => navigate("/meu-perfil")}>
              Completar Cadastro
            </Button>
          </CardContent>
        </Card>
      )}

      <div>
        <h1 className="text-3xl font-bold text-foreground">Meu Painel</h1>
        <p className="mt-1 text-muted-foreground">
          Bem-vindo de volta, {profile?.name ?? "Usuário"}
        </p>
      </div>

      <div className="grid gap-6 sm:grid-cols-2">
        <Card className="shadow-card transition-shadow hover:shadow-card-hover">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Meus Testes</CardTitle>
            <ClipboardList className="h-5 w-5 text-primary" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <Skeleton className="h-9 w-16" />
            ) : (
              <div className="text-3xl font-bold text-card-foreground">{tests.length}</div>
            )}
          </CardContent>
        </Card>

        <Card className="shadow-card transition-shadow hover:shadow-card-hover flex items-center justify-center">
          <CardContent className="py-6">
            <Button onClick={() => navigate("/teste")} className="gap-2">
              <ClipboardList className="h-4 w-4" />
              Fazer novo teste
            </Button>
          </CardContent>
        </Card>
      </div>

      <Card className="shadow-card">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Clock className="h-5 w-5 text-primary" />
            Histórico de Testes
          </CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="space-y-3">
              {[1, 2, 3].map((i) => <Skeleton key={i} className="h-20 w-full" />)}
            </div>
          ) : tests.length === 0 ? (
            <div className="py-8 text-center">
              <ClipboardList className="mx-auto h-10 w-10 text-muted-foreground" />
              <p className="mt-3 text-muted-foreground">Nenhum teste realizado ainda.</p>
              <Button className="mt-4" onClick={() => navigate("/teste")}>Fazer Teste</Button>
            </div>
          ) : (
            <div className="space-y-3">
              {tests.map((item) => (
                <div key={item.id} className="flex items-center justify-between rounded-lg border border-border p-4">
                  <div>
                    <p className="font-medium text-foreground">
                      {format(new Date(item.completed_at), "dd 'de' MMMM 'de' yyyy", { locale: ptBR })}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      Perfil dominante: <span className="font-semibold text-primary">{getDominantProfile(item.disc_natural)}</span>
                    </p>
                    <div className="mt-1 flex gap-3 text-xs text-muted-foreground">
                      {Object.entries(item.disc_natural).map(([k, v]) => (
                        <span key={k}>{k}: {v}</span>
                      ))}
                    </div>
                  </div>
                  <Button size="sm" variant="outline" onClick={() => navigate("/resultado")} className="gap-1">
                    <Eye className="h-3 w-3" />
                    Ver
                  </Button>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { user, profile, hasRole, selectedCompanyId } = useAuth();
  const [loading, setLoading] = useState(true);
  const [totalCollaborators, setTotalCollaborators] = useState(0);
  const [totalTests, setTotalTests] = useState(0);
  const [totalDepartments, setTotalDepartments] = useState(0);
  const [completionRate, setCompletionRate] = useState("0%");
  const [recentActivity, setRecentActivity] = useState<RecentActivity[]>([]);

  const isManager = hasRole("master_admin") || hasRole("company_admin") || hasRole("leader");

  useEffect(() => {
    if (!profile || !isManager) return;
    const fetchStats = async () => {
      setLoading(true);
      const isMaster = hasRole("master_admin");
      const isCompanyAdmin = hasRole("company_admin");
      const isLeader = hasRole("leader");

      let profilesQuery = supabase.from("profiles").select("user_id", { count: "exact" });
      let deptsQuery = supabase.from("departments").select("id", { count: "exact" });

      const companyFilter = isMaster ? selectedCompanyId : profile.company_id;
      if (companyFilter) {
        profilesQuery = profilesQuery.eq("company_id", companyFilter);
        deptsQuery = deptsQuery.eq("company_id", companyFilter);
      }
      if (isLeader && !isMaster && !isCompanyAdmin && profile.department_id) {
        profilesQuery = profilesQuery.eq("department_id", profile.department_id);
      }

      const [profilesRes, deptsRes] = await Promise.all([profilesQuery, deptsQuery]);

      const collaboratorCount = profilesRes.count ?? 0;
      const deptCount = deptsRes.count ?? 0;
      setTotalCollaborators(collaboratorCount);
      setTotalDepartments(deptCount);

      const userIds = (profilesRes.data ?? []).map((p) => p.user_id);

      if (userIds.length > 0) {
        const [testsCountRes, recentRes] = await Promise.all([
          supabase.from("test_results").select("id", { count: "exact" }).in("user_id", userIds),
          supabase
            .from("test_results")
            .select("user_id, completed_at")
            .in("user_id", userIds)
            .order("completed_at", { ascending: false })
            .limit(5),
        ]);

        const testCount = testsCountRes.count ?? 0;
        setTotalTests(testCount);
        setCompletionRate(
          collaboratorCount > 0 ? `${Math.round((testCount / collaboratorCount) * 100)}%` : "0%"
        );

        if (recentRes.data && recentRes.data.length > 0) {
          const recentUserIds = recentRes.data.map((r) => r.user_id);
          const { data: names } = await supabase
            .from("profiles")
            .select("user_id, name")
            .in("user_id", recentUserIds);
          const nameMap = new Map((names ?? []).map((n) => [n.user_id, n.name]));
          setRecentActivity(
            recentRes.data.map((r) => ({
              userName: nameMap.get(r.user_id) ?? "Usuário",
              completedAt: r.completed_at,
            }))
          );
        }
      } else {
        setTotalTests(0);
        setCompletionRate("0%");
      }

      setLoading(false);
    };
    fetchStats();
  }, [profile, hasRole, isManager, selectedCompanyId]);

  if (!isManager) {
    return (
      <AdminLayout>
        <CollaboratorDashboard profile={profile} user={user} />
      </AdminLayout>
    );
  }

  const stats = [
    { title: "Colaboradores", value: totalCollaborators.toString(), icon: Users, color: "text-primary" },
    { title: "Testes Realizados", value: totalTests.toString(), icon: ClipboardList, color: "text-chart-4" },
    { title: "Departamentos", value: totalDepartments.toString(), icon: Building2, color: "text-brand-red" },
    { title: "Taxa de Conclusão", value: completionRate, icon: TrendingUp, color: "text-emerald-500" },
  ];

  return (
    <AdminLayout>
      <div className="space-y-8">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Dashboard</h1>
            <p className="mt-1 text-muted-foreground">
              Bem-vindo de volta, {profile?.name ?? "Usuário"}
            </p>
          </div>
          <Button onClick={() => navigate("/teste")} className="gap-2">
            <ClipboardList className="h-4 w-4" />
            Realizar Teste
          </Button>
        </div>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
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

        <Card className="shadow-card">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Clock className="h-5 w-5 text-primary" />
              Atividade Recente
            </CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="space-y-3">
                {[1, 2, 3].map((i) => <Skeleton key={i} className="h-6 w-full" />)}
              </div>
            ) : recentActivity.length === 0 ? (
              <p className="text-muted-foreground">
                Nenhuma atividade registrada ainda. Comece convidando colaboradores para realizar testes.
              </p>
            ) : (
              <div className="space-y-3">
                {recentActivity.map((a, i) => (
                  <div key={i} className="flex items-center justify-between rounded-lg border border-border p-3">
                    <div className="flex items-center gap-3">
                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary/10">
                        <ClipboardList className="h-4 w-4 text-primary" />
                      </div>
                      <span className="text-sm font-medium text-foreground">{a.userName}</span>
                    </div>
                    <span className="text-xs text-muted-foreground">
                      {format(new Date(a.completedAt), "dd MMM yyyy, HH:mm", { locale: ptBR })}
                    </span>
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
