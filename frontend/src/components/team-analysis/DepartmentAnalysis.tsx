import { useMemo } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Crown } from "lucide-react";
import {
  TeamMember,
  PairResult,
  calculateCompatibility,
  getLevel,
  scoreColor,
  dotColor,
  levelLabel,
  buildPairs,
} from "@/lib/teamAnalysisUtils";

interface Department {
  id: string;
  name: string;
}

interface DepartmentGroup {
  department: Department;
  members: TeamMember[];
  leader: TeamMember | null;
  pairs: PairResult[];
  leaderScores: { member: TeamMember; score: number; level: "high" | "medium" | "low" }[];
  avgScore: number;
}

interface Props {
  members: TeamMember[];
  departments: Department[];
  onCompare: (user1Id: string, user2Id: string, type: "peer_to_peer" | "leader_member") => void;
}

export function DepartmentAnalysis({ members, departments, onCompare }: Props) {
  const groups = useMemo<DepartmentGroup[]>(() => {
    const deptMap = new Map(departments.map((d) => [d.id, d]));
    const byDept = new Map<string, TeamMember[]>();

    for (const m of members) {
      if (!m.department_id) continue;
      const list = byDept.get(m.department_id) ?? [];
      list.push(m);
      byDept.set(m.department_id, list);
    }

    const result: DepartmentGroup[] = [];

    for (const [deptId, deptMembers] of byDept) {
      if (deptMembers.length < 2) continue;
      const dept = deptMap.get(deptId);
      if (!dept) continue;

      const leader = deptMembers.find((m) => m.isLeader) ?? null;
      const nonLeaders = leader ? deptMembers.filter((m) => m.user_id !== leader.user_id) : deptMembers;

      const leaderScores = leader
        ? nonLeaders.map((m) => {
            const score = calculateCompatibility(leader, m);
            return { member: m, score, level: getLevel(score) };
          }).sort((a, b) => a.score - b.score)
        : [];

      const pairs = buildPairs(deptMembers);
      const allScores = [...pairs.map((p) => p.score), ...leaderScores.map((l) => l.score)];
      const avgScore = allScores.length > 0 ? Math.round(allScores.reduce((s, v) => s + v, 0) / allScores.length) : 0;

      result.push({ department: dept, members: deptMembers, leader, pairs, leaderScores, avgScore });
    }

    return result.sort((a, b) => a.department.name.localeCompare(b.department.name));
  }, [members, departments]);

  if (groups.length === 0) {
    return (
      <Card>
        <CardContent className="py-16 text-center">
          <Users className="mx-auto h-12 w-12 text-muted-foreground" />
          <p className="mt-4 text-muted-foreground">
            Nenhum departamento com pelo menos 2 colaboradores com testes completos.
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-6">
      {groups.map((g) => (
        <Card key={g.department.id}>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle className="text-lg">{g.department.name}</CardTitle>
                <CardDescription>
                  {g.members.length} membros{g.leader ? ` · Líder: ${g.leader.name}` : ""}
                </CardDescription>
              </div>
              <div className="text-right">
                <p className="text-xs text-muted-foreground">Score médio</p>
                <p className={`text-2xl font-bold ${scoreColor(g.avgScore)}`}>{g.avgScore}%</p>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Leader compatibility */}
            {g.leader && g.leaderScores.length > 0 && (
              <div>
                <div className="flex items-center gap-2 mb-2">
                  <Crown className="h-4 w-4 text-primary" />
                  <h4 className="text-sm font-semibold text-foreground">Compatibilidade com Líder</h4>
                </div>
                <div className="space-y-1">
                  {g.leaderScores.map((ls) => (
                    <div
                      key={ls.member.user_id}
                      onClick={() => onCompare(g.leader!.user_id, ls.member.user_id, "leader_member")}
                      className="flex items-center justify-between rounded-lg px-4 py-2 hover:bg-accent transition-colors cursor-pointer"
                    >
                      <div className="flex items-center gap-3 min-w-0">
                        <span className={`h-3 w-3 shrink-0 rounded-full ${dotColor(ls.score)}`} />
                        <div className="min-w-0">
                          <p className="text-sm font-medium truncate">{ls.member.name}</p>
                          <p className="text-xs text-muted-foreground">{levelLabel(ls.level)}</p>
                        </div>
                      </div>
                      <span className={`text-xl font-bold shrink-0 ml-4 ${scoreColor(ls.score)}`}>{ls.score}%</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Peer compatibility */}
            {g.pairs.length > 0 && (
              <div>
                <div className="flex items-center gap-2 mb-2">
                  <Users className="h-4 w-4 text-primary" />
                  <h4 className="text-sm font-semibold text-foreground">Entre Colaboradores</h4>
                </div>
                <div className="space-y-1">
                  {g.pairs.map((p) => (
                    <div
                      key={`${p.user1.id}-${p.user2.id}`}
                      onClick={() => onCompare(p.user1.id, p.user2.id, "peer_to_peer")}
                      className="flex items-center justify-between rounded-lg px-4 py-2 hover:bg-accent transition-colors cursor-pointer"
                    >
                      <div className="flex items-center gap-3 min-w-0">
                        <span className={`h-3 w-3 shrink-0 rounded-full ${dotColor(p.score)}`} />
                        <div className="min-w-0">
                          <p className="text-sm font-medium truncate">{p.user1.name} × {p.user2.name}</p>
                          <p className="text-xs text-muted-foreground">{levelLabel(p.level)}</p>
                        </div>
                      </div>
                      <span className={`text-xl font-bold shrink-0 ml-4 ${scoreColor(p.score)}`}>{p.score}%</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
