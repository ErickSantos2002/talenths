import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Shield } from "lucide-react";
import {
  TeamMember,
  calculateCompatibility,
  getLevel,
  scoreColor,
  dotColor,
  levelLabel,
} from "@/lib/teamAnalysisUtils";

interface AdminLeaderAnalysisProps {
  members: TeamMember[];
  adminUserIds: Set<string>;
  leaderUserIds: Set<string>;
  onCompare: (user1Id: string, user2Id: string, type: "peer_to_peer" | "leader_member") => void;
}

export function AdminLeaderAnalysis({ members, adminUserIds, leaderUserIds, onCompare }: AdminLeaderAnalysisProps) {
  const admins = members.filter((m) => adminUserIds.has(m.user_id));
  const leaders = members.filter((m) => leaderUserIds.has(m.user_id));

  if (admins.length === 0 || leaders.length === 0) {
    return (
      <Card>
        <CardContent className="py-16 text-center">
          <Shield className="mx-auto h-12 w-12 text-muted-foreground" />
          <p className="mt-4 text-muted-foreground">
            {admins.length === 0
              ? "Nenhum admin da empresa com teste completo encontrado."
              : "Nenhum líder com teste completo encontrado."}
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-6">
      {admins.map((admin) => {
        const pairs = leaders.map((leader) => {
          const score = calculateCompatibility(admin, leader);
          return { leader, score, level: getLevel(score) };
        }).sort((a, b) => b.score - a.score);

        const avgScore = Math.round(pairs.reduce((s, p) => s + p.score, 0) / pairs.length);

        return (
          <Card key={admin.user_id}>
            <CardHeader>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10">
                    <Shield className="h-5 w-5 text-primary" />
                  </div>
                  <CardTitle className="text-lg">{admin.name}</CardTitle>
                </div>
                <div className="text-right">
                  <p className="text-xs text-muted-foreground">Score médio</p>
                  <p className={`text-2xl font-bold ${scoreColor(avgScore)}`}>{avgScore}%</p>
                </div>
              </div>
            </CardHeader>
            <CardContent className="space-y-2">
              {pairs.map((p) => (
                <div
                  key={p.leader.user_id}
                  onClick={() => onCompare(admin.user_id, p.leader.user_id, "leader_member")}
                  className="flex items-center justify-between rounded-lg px-4 py-3 hover:bg-accent transition-colors cursor-pointer"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <span className={`h-3 w-3 shrink-0 rounded-full ${dotColor(p.score)}`} />
                    <div className="min-w-0">
                      <p className="text-sm font-medium truncate">{p.leader.name}</p>
                      <p className="text-xs text-muted-foreground">{levelLabel(p.level)}</p>
                    </div>
                  </div>
                  <span className={`text-2xl font-bold shrink-0 ml-4 ${scoreColor(p.score)}`}>
                    {p.score}%
                  </span>
                </div>
              ))}
            </CardContent>
          </Card>
        );
      })}
    </div>
  );
}
