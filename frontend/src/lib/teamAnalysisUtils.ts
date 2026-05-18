export interface TeamMember {
  user_id: string;
  name: string;
  department_id: string | null;
  isLeader: boolean;
  disc: { D: number; I: number; S: number; C: number };
  bigFive: { O: number; C: number; E: number; A: number; N: number };
}

export interface PairResult {
  user1: { id: string; name: string };
  user2: { id: string; name: string };
  score: number;
  level: "high" | "medium" | "low";
}

function clamp(val: number, min: number, max: number) {
  return Math.max(min, Math.min(max, val));
}

export function calculateCompatibility(a: TeamMember, b: TeamMember): number {
  const diffD = Math.abs(a.disc.D - b.disc.D);
  const diffI = Math.abs(a.disc.I - b.disc.I);
  const diffS = Math.abs(a.disc.S - b.disc.S);
  const diffC = Math.abs(a.disc.C - b.disc.C);
  const discScore = clamp(100 - ((diffD + diffI + diffS + diffC) / 80 * 100), 0, 100);

  const diffO = Math.abs(a.bigFive.O - b.bigFive.O);
  const diffCo = Math.abs(a.bigFive.C - b.bigFive.C);
  const diffE = Math.abs(a.bigFive.E - b.bigFive.E);
  const diffA = Math.abs(a.bigFive.A - b.bigFive.A);
  const diffN = Math.abs(a.bigFive.N - b.bigFive.N);
  const oceanScore = clamp(100 - ((diffO + diffCo + diffE + diffA + diffN) / 150 * 100), 0, 100);

  return Math.round(discScore * 0.6 + oceanScore * 0.4);
}

export function getLevel(score: number): "high" | "medium" | "low" {
  if (score >= 80) return "high";
  if (score >= 60) return "medium";
  return "low";
}

export function getRiskReason(score: number): string {
  if (score < 40) return "Incompatibilidade alta — evitar trabalho conjunto direto";
  if (score < 50) return "Risco significativo de conflito — considerar mediação";
  return "Compatibilidade baixa — monitorar interações";
}

export function scoreColor(score: number) {
  if (score >= 80) return "text-green-600";
  if (score >= 60) return "text-yellow-600";
  return "text-red-600";
}

export function dotColor(score: number) {
  if (score >= 80) return "bg-green-500";
  if (score >= 60) return "bg-yellow-500";
  return "bg-red-500";
}

export function levelLabel(level: "high" | "medium" | "low") {
  if (level === "high") return "Alta sinergia";
  if (level === "medium") return "Compatibilidade neutra";
  return "Potencial conflito";
}

export function buildPairs(members: TeamMember[]): PairResult[] {
  const result: PairResult[] = [];
  for (let i = 0; i < members.length; i++) {
    for (let j = i + 1; j < members.length; j++) {
      const score = calculateCompatibility(members[i], members[j]);
      result.push({
        user1: { id: members[i].user_id, name: members[i].name },
        user2: { id: members[j].user_id, name: members[j].name },
        score,
        level: getLevel(score),
      });
    }
  }
  return result.sort((a, b) => a.score - b.score);
}
