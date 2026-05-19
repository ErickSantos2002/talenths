import { useState, useEffect } from "react";
import { profiles, departments, tests } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Users, ClipboardList, Building2, TrendingUp } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";

export default function CompanyDashboardPage() {
  const { profile, hasRole, selectedCompanyId } = useAuth();
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({ collaborators: 0, tests: 0, pending: 0, departments: 0 });
  const [depts, setDepts] = useState<any[]>([]);
  const [deptCompatibility, setDeptCompatibility] = useState<Record<string, { score: number | null; testedCount: number }>>({});
  const [pendingProfiles, setPendingProfiles] = useState<any[]>([]);

  const isMasterAdmin = hasRole("master_admin");
  const companyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;

  useEffect(() => {
    if (!companyId) return;
    fetchAll();
  }, [companyId]);

  const fetchAll = async () => {
    if (!companyId) return;
    setLoading(true);
    try {
      const [profilesData, deptsData, allResults] = await Promise.all([
        profiles.list(companyId),
        departments.list(companyId),
        tests.results(),
      ]);

      const allProfiles = profilesData as any[];
      const deptList = deptsData as any[];
      const userIds = new Set(allProfiles.map((p: any) => p.user_id));
      const companyResults = (allResults as any[]).filter((r: any) => userIds.has(r.user_id));
      const testedUserIds = new Set(companyResults.map((r: any) => r.user_id));
      const uniqueTestedCount = testedUserIds.size;

      setStats({
        collaborators: allProfiles.length,
        tests: uniqueTestedCount,
        pending: allProfiles.length - uniqueTestedCount,
        departments: deptList.length,
      });
      setDepts(deptList);

      const deptMap = Object.fromEntries(deptList.map((d: any) => [d.id, d.name]));
      setPendingProfiles(
        allProfiles
          .filter((p: any) => !testedUserIds.has(p.user_id))
          .map((p: any) => ({ ...p, departmentName: p.department_id ? (deptMap[p.department_id] ?? null) : null }))
      );

      const latestTestByUser: Record<string, { D: number; I: number; S: number; C: number }> = {};
      for (const tr of companyResults) {
        if (!latestTestByUser[tr.user_id]) {
          const disc = tr.disc_natural as any;
          if (disc && typeof disc.D === "number") latestTestByUser[tr.user_id] = disc;
        }
      }

      const deptCompat: Record<string, { score: number | null; testedCount: number }> = {};
      for (const dept of deptList) {
        const deptDiscs = allProfiles
          .filter((p: any) => p.department_id === dept.id)
          .map((p: any) => latestTestByUser[p.user_id])
          .filter(Boolean);
        if (deptDiscs.length < 2) {
          deptCompat[dept.id] = { score: null, testedCount: deptDiscs.length };
        } else {
          let totalScore = 0, pairCount = 0;
          for (let i = 0; i < deptDiscs.length; i++) {
            for (let j = i + 1; j < deptDiscs.length; j++) {
              const d1 = deptDiscs[i], d2 = deptDiscs[j];
              const avgDiff = (Math.abs(d1.D - d2.D) + Math.abs(d1.I - d2.I) + Math.abs(d1.S - d2.S) + Math.abs(d1.C - d2.C)) / 4;
              totalScore += 100 - avgDiff;
              pairCount++;
            }
          }
          deptCompat[dept.id] = { score: Math.round(totalScore / pairCount), testedCount: deptDiscs.length };
        }
      }
      setDeptCompatibility(deptCompat);
    } catch { /* silently fail */ } finally {
      setLoading(false);
    }
  };

  const statCards = [
    { title: "Colaboradores", value: stats.collaborators, icon: Users, color: "text-primary" },
    { title: "Testes Realizados", value: stats.tests, icon: ClipboardList, color: "text-chart-4" },
    { title: "Pendentes", value: stats.pending, icon: TrendingUp, color: "text-destructive" },
    { title: "Departamentos", value: stats.departments, icon: Building2, color: "text-brand-red" },
  ];

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <h1 className="text-2xl font-bold text-foreground">
          {isMasterAdmin ? "Gestão de Empresa" : "Minha Empresa"}
        </h1>

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
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

        <Tabs defaultValue="departments">
          <TabsList>
            <TabsTrigger value="departments">Departamentos</TabsTrigger>
            <TabsTrigger value="pending" className="gap-2">
              Pendentes
              {!loading && stats.pending > 0 && (
                <Badge className="h-5 min-w-5 rounded-full bg-destructive px-1.5 text-[10px] text-white">
                  {stats.pending}
                </Badge>
              )}
            </TabsTrigger>
          </TabsList>

          <TabsContent value="departments" className="mt-4">
            <Card>
              <CardContent className="p-6">
                {loading ? (
                  <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
                ) : depts.length === 0 ? (
                  <p className="py-8 text-center text-muted-foreground">Nenhum departamento cadastrado.</p>
                ) : (
                  <div className="space-y-2">
                    {depts.map((d) => {
                      const compat = deptCompatibility[d.id];
                      const score = compat?.score;
                      const testedCount = compat?.testedCount ?? 0;
                      const colorClass = score == null ? "" : score >= 75
                        ? "bg-chart-4/15 text-chart-4 border-chart-4/30"
                        : score >= 50
                        ? "bg-yellow-500/15 text-yellow-600 border-yellow-500/30"
                        : "bg-destructive/15 text-destructive border-destructive/30";
                      return (
                        <div key={d.id} className="flex items-center justify-between rounded-lg border border-border p-3">
                          <span className="font-medium text-foreground">{d.name}</span>
                          <div className="flex items-center gap-3">
                            <span className="text-xs text-muted-foreground">{testedCount} com teste</span>
                            {score != null ? (
                              <Badge variant="outline" className={`${colorClass} text-xs`}>
                                Compatibilidade: {score}%
                              </Badge>
                            ) : (
                              <Badge variant="outline" className="text-xs text-muted-foreground">Sem dados</Badge>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="pending" className="mt-4">
            <Card>
              <CardContent className="p-6">
                {loading ? (
                  <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
                ) : pendingProfiles.length === 0 ? (
                  <p className="py-8 text-center text-muted-foreground">Todos os colaboradores já realizaram o teste.</p>
                ) : (
                  <div className="space-y-2">
                    {pendingProfiles.map((p) => (
                      <div key={p.user_id} className="flex items-center justify-between rounded-lg border border-border p-3">
                        <div>
                          <p className="font-medium text-foreground">{p.name}</p>
                          <p className="text-xs text-muted-foreground">{p.email ?? ""}</p>
                        </div>
                        {p.departmentName ? (
                          <Badge variant="outline" className="text-xs">{p.departmentName}</Badge>
                        ) : (
                          <span className="text-xs text-muted-foreground">Sem departamento</span>
                        )}
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
