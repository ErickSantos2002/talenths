import { useState, useEffect, useMemo, useCallback } from "react";
import { profiles, departments, tests } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Users, TrendingUp, AlertTriangle, Loader2, Grid3X3, Building2, Shield } from "lucide-react";
import { DepartmentAnalysis } from "@/components/team-analysis/DepartmentAnalysis";
import { AdminLeaderAnalysis } from "@/components/team-analysis/AdminLeaderAnalysis";
import { CompatibilityModal, useCompatibilityModal } from "@/components/team-analysis/CompatibilityModal";
import {
  TeamMember,
  PairResult,
  scoreColor,
  dotColor,
  levelLabel,
  getRiskReason,
  buildPairs,
} from "@/lib/teamAnalysisUtils";

interface Department {
  id: string;
  name: string;
}

export default function TeamAnalysisPage() {
  const { profile, hasRole, selectedCompanyId } = useAuth();
  const isMasterAdmin = hasRole("master_admin");
  const effectiveCompanyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;

  const [members, setMembers] = useState<TeamMember[]>([]);
  const [depts, setDepts] = useState<Department[]>([]);
  const [adminUserIds, setAdminUserIds] = useState<Set<string>>(new Set());
  const [leaderUserIds, setLeaderUserIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [scoreOverrides, setScoreOverrides] = useState<Map<string, number>>(new Map());
  const handleModalResult = useCallback((user1Id: string, user2Id: string, score: number) => {
    const key = [user1Id, user2Id].sort().join(":");
    setScoreOverrides(prev => new Map(prev).set(key, score));
  }, []);
  const modal = useCompatibilityModal(handleModalResult);

  const load = useCallback(async () => {
    if (!effectiveCompanyId) { setMembers([]); setDepts([]); setLoading(false); return; }
    setLoading(true);

    try {
      const [profilesData, deptsData, allResults] = await Promise.all([
        profiles.list(effectiveCompanyId),
        departments.list(effectiveCompanyId),
        tests.results(),
      ]);

      const profileList = (profilesData as any[]);
      if (!profileList || profileList.length < 2) {
        setMembers([]);
        setDepts([]);
        setLoading(false);
        return;
      }

      const deptList = (deptsData as any[]);
      setDepts(deptList.map((d: any) => ({ id: d.id, name: d.name })));

      // Derive leader/admin sets from profile role field
      const leaderIds = new Set<string>();
      const adminIds = new Set<string>();
      for (const p of profileList) {
        if (p.role === "leader") leaderIds.add(p.user_id);
        if (p.role === "company_admin") adminIds.add(p.user_id);
      }
      setLeaderUserIds(leaderIds);
      setAdminUserIds(adminIds);

      const userIds = new Set(profileList.map((p: any) => p.user_id));
      const results = (allResults as any[]).filter((r: any) => userIds.has(r.user_id));

      // Keep latest result per user
      const latestByUser = new Map<string, any>();
      for (const r of results) {
        const existing = latestByUser.get(r.user_id);
        if (!existing || new Date(r.completed_at) > new Date(existing.completed_at)) {
          latestByUser.set(r.user_id, r);
        }
      }

      const profileMap = new Map(profileList.map((p: any) => [p.user_id, p]));
      const team: TeamMember[] = [];
      for (const [uid, result] of latestByUser) {
        const disc = result.disc_natural as any;
        const bf = result.big_five as any;
        if (!disc || !bf) continue;
        const prof = profileMap.get(uid);
        team.push({
          user_id: uid,
          name: prof?.name ?? "Sem nome",
          department_id: prof?.department_id ?? null,
          isLeader: leaderIds.has(uid),
          disc: { D: disc.D ?? 0, I: disc.I ?? 0, S: disc.S ?? 0, C: disc.C ?? 0 },
          bigFive: { O: bf.O ?? 0, C: bf.C ?? 0, E: bf.E ?? 0, A: bf.A ?? 0, N: bf.N ?? 0 },
        });
      }

      setMembers(team);
    } catch { /* silently fail */ } finally {
      setLoading(false);
    }
  }, [effectiveCompanyId]);

  useEffect(() => { load(); }, [load]);

  const pairs = useMemo<PairResult[]>(() => {
    const basePairs = buildPairs(members);
    if (scoreOverrides.size === 0) return basePairs;
    return basePairs.map(p => {
      const key = [p.user1.id, p.user2.id].sort().join(":");
      const override = scoreOverrides.get(key);
      if (override !== undefined) {
        return { ...p, score: override, level: override >= 80 ? "high" as const : override >= 60 ? "medium" as const : "low" as const };
      }
      return p;
    }).sort((a, b) => a.score - b.score);
  }, [members, scoreOverrides]);

  const risks = pairs.filter((p) => p.level === "low");
  const highSynergy = pairs.filter((p) => p.level === "high").length;
  const avgScore = pairs.length > 0 ? Math.round(pairs.reduce((s, p) => s + p.score, 0) / pairs.length) : 0;

  if (loading) {
    return (
      <AdminLayout>
        <div className="flex flex-col items-center justify-center py-32 gap-3">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-muted-foreground">Carregando análise de equipe...</p>
        </div>
      </AdminLayout>
    );
  }

  if (members.length < 2) {
    return (
      <AdminLayout>
        <div className="animate-fade-in space-y-6">
          <Header />
          <Card>
            <CardContent className="py-16 text-center">
              <Users className="mx-auto h-12 w-12 text-muted-foreground" />
              <p className="mt-4 text-muted-foreground">
                Nenhuma comparação disponível. Certifique-se de que há pelo menos 2 colaboradores com testes completos.
              </p>
            </CardContent>
          </Card>
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <Header />

        <Tabs defaultValue="geral">
          <TabsList>
            <TabsTrigger value="geral" className="gap-1.5">
              <Grid3X3 className="h-4 w-4" /> Geral
            </TabsTrigger>
            <TabsTrigger value="departamento" className="gap-1.5">
              <Building2 className="h-4 w-4" /> Por Departamento
            </TabsTrigger>
            <TabsTrigger value="admin-lideres" className="gap-1.5">
              <Shield className="h-4 w-4" /> Admin vs Líderes
            </TabsTrigger>
          </TabsList>

          <TabsContent value="geral" className="space-y-6">
            {/* Stats Grid */}
            <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
              <StatCard title="Total de Pares" value={pairs.length} />
              <StatCard title="Score Médio" value={`${avgScore}%`} valueClass={scoreColor(avgScore)} />
              <StatCard title="Alta Sinergia" value={highSynergy} valueClass="text-green-600" icon={<TrendingUp className="h-4 w-4 text-green-600" />} />
              <StatCard title="Duplas de Risco" value={risks.length} valueClass="text-red-600" icon={<AlertTriangle className="h-4 w-4 text-red-600" />} />
            </div>

            {/* Risk Alerts */}
            {risks.length > 0 && (
              <Card className="border-red-200 bg-red-50 dark:bg-red-950/20">
                <CardHeader>
                  <div className="flex items-center gap-3">
                    <AlertTriangle className="h-8 w-8 text-red-600" />
                    <div>
                      <CardTitle className="text-red-700 dark:text-red-400">Duplas de Risco Identificadas</CardTitle>
                      <CardDescription className="text-red-600/80 dark:text-red-400/70">
                        Pares com baixa compatibilidade que requerem atenção
                      </CardDescription>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-3">
                  {risks.map((r) => (
                    <div
                      key={`${r.user1.id}-${r.user2.id}`}
                      onClick={() => modal.openModal(r.user1.id, r.user2.id, "peer_to_peer")}
                      className="flex items-center justify-between rounded-lg bg-card p-4 border cursor-pointer hover:bg-accent transition-colors"
                    >
                      <div className="flex items-center gap-3 min-w-0">
                        <Users className="h-4 w-4 shrink-0 text-red-500" />
                        <div className="min-w-0">
                          <p className="font-medium text-sm truncate">{r.user1.name} × {r.user2.name}</p>
                          <p className="text-xs text-muted-foreground">{getRiskReason(r.score)}</p>
                        </div>
                      </div>
                      <span className={`text-2xl font-bold shrink-0 ml-4 ${scoreColor(r.score)}`}>{r.score}%</span>
                    </div>
                  ))}
                </CardContent>
              </Card>
            )}

            {/* Compatibility Matrix */}
            <Card>
              <CardHeader>
                <CardTitle>Matriz de Compatibilidade</CardTitle>
                <CardDescription>Visualização de compatibilidade entre todos os membros da equipe</CardDescription>
              </CardHeader>
              <CardContent className="space-y-2">
                {pairs.map((p) => (
                  <div
                    key={`${p.user1.id}-${p.user2.id}`}
                    onClick={() => modal.openModal(p.user1.id, p.user2.id, "peer_to_peer")}
                    className="flex items-center justify-between rounded-lg px-4 py-3 hover:bg-accent transition-colors cursor-pointer"
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <span className={`h-3 w-3 shrink-0 rounded-full ${dotColor(p.score)}`} />
                      <div className="min-w-0">
                        <p className="text-sm font-medium truncate">{p.user1.name} × {p.user2.name}</p>
                        <p className="text-xs text-muted-foreground">{levelLabel(p.level)}</p>
                      </div>
                    </div>
                    <span className={`text-2xl font-bold shrink-0 ml-4 ${scoreColor(p.score)}`}>{p.score}%</span>
                  </div>
                ))}
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="departamento" className="space-y-6">
            <DepartmentAnalysis members={members} departments={depts} onCompare={modal.openModal} />
          </TabsContent>

          <TabsContent value="admin-lideres" className="space-y-6">
            <AdminLeaderAnalysis members={members} adminUserIds={adminUserIds} leaderUserIds={leaderUserIds} onCompare={modal.openModal} />
          </TabsContent>
        </Tabs>

        <CompatibilityModal
          open={modal.open}
          onClose={modal.closeModal}
          loading={modal.loading}
          result={modal.result}
          error={modal.error}
        />
      </div>
    </AdminLayout>
  );
}

function Header() {
  return (
    <div className="flex items-center gap-3">
      <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
        <Grid3X3 className="h-5 w-5 text-primary" />
      </div>
      <div>
        <h1 className="text-2xl font-bold text-foreground">Análise de Equipe</h1>
        <p className="text-sm text-muted-foreground">Matriz de compatibilidade e alertas de risco</p>
      </div>
    </div>
  );
}

function StatCard({ title, value, valueClass, icon }: { title: string; value: string | number; valueClass?: string; icon?: React.ReactNode }) {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <p className="text-sm font-medium text-muted-foreground">{title}</p>
          {icon}
        </div>
        <p className={`mt-2 text-3xl font-bold ${valueClass ?? "text-foreground"}`}>{value}</p>
      </CardContent>
    </Card>
  );
}
