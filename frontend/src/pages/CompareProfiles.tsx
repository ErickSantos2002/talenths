import { useState, useEffect, useRef, useCallback } from "react";
import { useSearchParams } from "react-router-dom";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { profiles, comparisons, tests } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import {
  Brain, Users, Zap, AlertTriangle, Lightbulb, Loader2,
  TrendingUp, CheckCircle, RotateCcw, Shield, MessageCircle, Clock
} from "lucide-react";
import { RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, Legend, ResponsiveContainer } from "recharts";
import { useToast } from "@/hooks/use-toast";
import { DniaFullAcronym } from "@/components/DniaInfoIcon";
import { discToDisplayKey } from "@/data/dniaLabels";

interface Collaborator {
  user_id: string;
  name: string;
  has_test: boolean;
  role: string;
}

type ComparisonType = "peer_to_peer" | "leader_member";

interface ComparisonResult {
  compatibility_score: number;
  comparison_type: ComparisonType;
  ai_analysis: Record<string, string[]>;
  user1: { name: string; disc: { D: number; I: number; S: number; C: number }; disc_adapted?: Record<string, number>; big_five?: Record<string, number> };
  user2: { name: string; disc: { D: number; I: number; S: number; C: number }; disc_adapted?: Record<string, number>; big_five?: Record<string, number> };
}

// Section config for rendering dynamic cards
interface SectionConfig {
  key: string;
  title: string;
  borderColor: string;
  iconColor: string;
  dotColor: string;
  Icon: React.ElementType;
}

const commonSections: SectionConfig[] = [
  { key: "pontos_fortes", title: "Pontos Fortes da Dupla", borderColor: "border-l-green-500", iconColor: "text-green-600", dotColor: "bg-green-500", Icon: TrendingUp },
  { key: "conflitos", title: "Possíveis Conflitos", borderColor: "border-l-yellow-500", iconColor: "text-yellow-600", dotColor: "bg-yellow-500", Icon: AlertTriangle },
  { key: "recomendacoes", title: "Recomendações", borderColor: "border-l-blue-500", iconColor: "text-blue-600", dotColor: "bg-blue-500", Icon: Lightbulb },
];

const peerSections: SectionConfig[] = [
  { key: "complementaridades", title: "Complementariedades", borderColor: "border-l-cyan-500", iconColor: "text-cyan-600", dotColor: "bg-cyan-500", Icon: Users },
  { key: "dicas_trabalho", title: "Como Trabalhar Juntos", borderColor: "border-l-indigo-500", iconColor: "text-indigo-600", dotColor: "bg-indigo-500", Icon: Lightbulb },
  { key: "projetos_ideais", title: "Projetos Ideais", borderColor: "border-l-emerald-500", iconColor: "text-emerald-600", dotColor: "bg-emerald-500", Icon: TrendingUp },
  { key: "o_que_evitar", title: "O Que Evitar", borderColor: "border-l-red-500", iconColor: "text-red-600", dotColor: "bg-red-500", Icon: AlertTriangle },
];

const leaderSections: SectionConfig[] = [
  { key: "estilo_lideranca", title: "Estilo de Liderança Ideal", borderColor: "border-l-purple-500", iconColor: "text-purple-600", dotColor: "bg-purple-500", Icon: Shield },
  { key: "estrategias_delegacao", title: "Estratégias de Delegação", borderColor: "border-l-blue-500", iconColor: "text-blue-600", dotColor: "bg-blue-500", Icon: TrendingUp },
  { key: "comunicacao_efetiva", title: "Comunicação Efetiva", borderColor: "border-l-cyan-500", iconColor: "text-cyan-600", dotColor: "bg-cyan-500", Icon: MessageCircle },
  { key: "motivadores_chave", title: "Motivadores-Chave", borderColor: "border-l-emerald-500", iconColor: "text-emerald-600", dotColor: "bg-emerald-500", Icon: TrendingUp },
  { key: "sinais_alerta", title: "Sinais de Alerta", borderColor: "border-l-orange-500", iconColor: "text-orange-600", dotColor: "bg-orange-500", Icon: AlertTriangle },
  { key: "nivel_autonomia", title: "Nível de Autonomia", borderColor: "border-l-indigo-500", iconColor: "text-indigo-600", dotColor: "bg-indigo-500", Icon: Users },
  { key: "frequencia_feedback", title: "Frequência de Feedback", borderColor: "border-l-pink-500", iconColor: "text-pink-600", dotColor: "bg-pink-500", Icon: Clock },
];

function AnalysisCard({ section, items }: { section: SectionConfig; items: string[] }) {
  const { Icon } = section;
  if (!items?.length) return null;
  return (
    <Card className={`border-l-4 ${section.borderColor}`}>
      <CardHeader className="pb-3">
        <CardTitle className="flex items-center gap-2 text-lg">
          <Icon className={`h-5 w-5 ${section.iconColor}`} />
          {section.title}
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ul className="space-y-2">
          {items.map((item, i) => (
            <li key={i} className="flex items-start gap-2 text-sm text-foreground">
              <span className={`mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full ${section.dotColor}`} />
              {item}
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}

export default function CompareProfiles() {
  const { profile, selectedCompanyId, hasRole } = useAuth();
  const isMasterAdmin = hasRole("master_admin");
  const effectiveCompanyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;
  const { toast } = useToast();
  const [searchParams] = useSearchParams();
  const autoCompareTriggered = useRef(false);
  const [comparisonType, setComparisonType] = useState<ComparisonType>(
    (searchParams.get("type") as ComparisonType) || "peer_to_peer"
  );
  const [allCollaborators, setAllCollaborators] = useState<Collaborator[]>([]);
  const [subordinates, setSubordinates] = useState<string[]>([]);
  const [user1Id, setUser1Id] = useState(searchParams.get("user1") || "");
  const [user2Id, setUser2Id] = useState(searchParams.get("user2") || "");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<ComparisonResult | null>(null);

  // Fetch collaborators with test status
  useEffect(() => {
    (async () => {
      try {
        const [allResults, profilesData] = await Promise.all([
          tests.results(),
          profiles.list(effectiveCompanyId ?? undefined),
        ]);

        const testedIds = new Set((allResults as any[]).map((r: any) => r.user_id));
        const profileList = profilesData as any[];

        setAllCollaborators(
          profileList.map((p: any) => ({
            user_id: p.user_id,
            name: p.name,
            has_test: testedIds.has(p.user_id),
            role: p.role ?? "user",
          }))
        );
      } catch { /* ignore */ }
    })();
  }, [effectiveCompanyId]);

  // Reset second user when type or first user changes (skip if deep link params present)
  useEffect(() => {
    const qUser1 = searchParams.get("user1");
    const qUser2 = searchParams.get("user2");
    if (qUser1 && qUser2) return; // Don't reset when deep linking
    setUser2Id("");
  }, [comparisonType, user1Id, searchParams]);

  // Gerentes e admins para o modo gerente-colaborador
  const leaderOptions = allCollaborators.filter((c) =>
    ["master_admin", "manager"].includes(c.role)
  );

  // Filter regular collaborators (users without leadership roles) for member field
  const memberOptions = allCollaborators.filter((c) => c.role === "user");

  const user1Options = comparisonType === "leader_member" ? leaderOptions : allCollaborators;
  const user2Options = comparisonType === "leader_member" ? memberOptions : allCollaborators;

  const handleCompare = useCallback(async (overrideUser1?: string, overrideUser2?: string) => {
    const u1 = overrideUser1 || user1Id;
    const u2 = overrideUser2 || user2Id;
    if (!u1 || !u2) {
      toast({ title: "Selecione dois colaboradores", variant: "destructive" });
      return;
    }
    if (u1 === u2) {
      toast({ title: "Selecione colaboradores diferentes", variant: "destructive" });
      return;
    }

    setLoading(true);
    setResult(null);

    try {
      const data = await comparisons.create(u1, u2, comparisonType);
      setResult(data as unknown as ComparisonResult);
    } catch (err: any) {
      toast({ title: "Erro ao comparar perfis", description: err.message, variant: "destructive" });
    } finally {
      setLoading(false);
    }
  }, [user1Id, user2Id, comparisonType, toast]);

  // Auto-trigger comparison from deep link query params
  useEffect(() => {
    if (autoCompareTriggered.current || allCollaborators.length === 0) return;
    const qUser1 = searchParams.get("user1");
    const qUser2 = searchParams.get("user2");
    if (!qUser1 || !qUser2) return;
    const u1Valid = allCollaborators.some((c) => c.user_id === qUser1 && c.has_test);
    const u2Valid = allCollaborators.some((c) => c.user_id === qUser2 && c.has_test);
    if (!u1Valid || !u2Valid) return;
    autoCompareTriggered.current = true;
    const qType = searchParams.get("type") as ComparisonType;
    if (qType) setComparisonType(qType);
    setUser1Id(qUser1);
    setUser2Id(qUser2);
    handleCompare(qUser1, qUser2);
  }, [allCollaborators, searchParams, handleCompare]);

  const handleNewComparison = () => {
    setResult(null);
    setUser1Id("");
    setUser2Id("");
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return "text-green-600";
    if (score >= 60) return "text-yellow-600";
    return "text-red-600";
  };

  const getScoreLabel = (score: number) => {
    if (score >= 80) return "Excelente";
    if (score >= 60) return "Boa";
    return "Atenção Necessária";
  };

  const radarData = result
    ? [
        { dimension: discToDisplayKey["D"], [result.user1.name]: result.user1.disc.D, [result.user2.name]: result.user2.disc.D },
        { dimension: discToDisplayKey["I"], [result.user1.name]: result.user1.disc.I, [result.user2.name]: result.user2.disc.I },
        { dimension: discToDisplayKey["S"], [result.user1.name]: result.user1.disc.S, [result.user2.name]: result.user2.disc.S },
        { dimension: discToDisplayKey["C"], [result.user1.name]: result.user1.disc.C, [result.user2.name]: result.user2.disc.C },
      ]
    : [];

  const typeSections = result?.comparison_type === "leader_member" ? leaderSections : peerSections;

  return (
    <AdminLayout>
      <div className="mx-auto max-w-5xl space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Comparar Perfis dnia</h1>
          <p className="text-muted-foreground">Selecione o tipo de relação e dois colaboradores para comparar</p>
        </div>

        {/* Selection Section */}
        {!result && (
          <Card>
            <CardContent className="pt-6 space-y-4">
              {/* Comparison Type */}
              <div className="space-y-2">
                <label className="text-sm font-medium text-foreground">Tipo de Relação</label>
                <Select value={comparisonType} onValueChange={(v) => setComparisonType(v as ComparisonType)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="peer_to_peer">Colega-Colega</SelectItem>
                    <SelectItem value="leader_member">Líder-Liderado</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* User Selects */}
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div className="space-y-2">
                  <label className="text-sm font-medium text-foreground">
                    {comparisonType === "leader_member" ? "Líder" : "Primeiro Perfil"}
                  </label>
                   <Select value={user1Id} onValueChange={setUser1Id}>
                     <SelectTrigger>
                       <SelectValue placeholder="Selecione..." />
                     </SelectTrigger>
                     <SelectContent>
                       {user1Options.map((c) => (
                         <SelectItem key={c.user_id} value={c.user_id} disabled={!c.has_test}>
                           {c.name}{!c.has_test ? " (sem teste)" : ""}
                         </SelectItem>
                       ))}
                     </SelectContent>
                   </Select>
                 </div>

                 <div className="space-y-2">
                   <label className="text-sm font-medium text-foreground">
                     {comparisonType === "leader_member" ? "Liderado" : "Segundo Perfil"}
                   </label>
                   <Select value={user2Id} onValueChange={setUser2Id} disabled={comparisonType === "leader_member" && !user1Id}>
                     <SelectTrigger>
                       <SelectValue placeholder={comparisonType === "leader_member" && !user1Id ? "Selecione o líder primeiro" : "Selecione..."} />
                     </SelectTrigger>
                     <SelectContent>
                       {user2Options.map((c) => (
                         <SelectItem key={c.user_id} value={c.user_id} disabled={!c.has_test || c.user_id === user1Id}>
                           {c.name}{!c.has_test ? " (sem teste)" : ""}
                         </SelectItem>
                       ))}
                       {comparisonType === "leader_member" && user1Id && user2Options.length === 0 && (
                         <div className="px-2 py-3 text-sm text-muted-foreground text-center">
                           Nenhum liderado encontrado
                         </div>
                       )}
                     </SelectContent>
                   </Select>
                </div>
              </div>

              <Button
                id="btn-compare"
                onClick={() => handleCompare()}
                disabled={loading || !user1Id || !user2Id || user1Id === user2Id}
                className="w-full sm:w-auto"
              >
                {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : <Users className="h-4 w-4 mr-2" />}
                Calcular Compatibilidade
              </Button>
            </CardContent>
          </Card>
        )}

        {/* Results */}
        {result && (
          <div className="space-y-6 animate-in fade-in-0 slide-in-from-bottom-4 duration-500">
            {/* Score Card */}
            <Card className="border-2 bg-gradient-to-br from-blue-500/5 to-purple-500/5" style={{ borderImage: "linear-gradient(135deg, hsl(217 91% 60%), hsl(271 91% 65%)) 1" }}>
              <CardContent className="py-8 text-center">
                <span className={`text-5xl md:text-7xl font-bold ${getScoreColor(result.compatibility_score)}`}>
                  {result.compatibility_score}
                </span>
                <span className="text-2xl text-muted-foreground">/100</span>
                <p className={`mt-2 text-lg font-semibold ${getScoreColor(result.compatibility_score)}`}>
                  {getScoreLabel(result.compatibility_score)}
                </p>
                <p className="mt-1 text-sm text-muted-foreground">
                  {result.user1.name} & {result.user2.name}
                </p>
              </CardContent>
            </Card>

            {/* Radar Chart */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Brain className="h-5 w-5 text-primary" />
                  Comparação dnia
                  <DniaFullAcronym />
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width="100%" height={350}>
                  <RadarChart data={radarData}>
                    <PolarGrid />
                    <PolarAngleAxis dataKey="dimension" />
                    <PolarRadiusAxis angle={90} domain={[0, 100]} />
                    <Radar name={result.user1.name} dataKey={result.user1.name} stroke="#3D61FF" fill="#3D61FF" fillOpacity={0.3} />
                    <Radar name={result.user2.name} dataKey={result.user2.name} stroke="#E41A11" fill="#E41A11" fillOpacity={0.3} />
                    <Legend />
                  </RadarChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Common Sections */}
            <div className="grid gap-4 md:grid-cols-3">
              {commonSections.map((s) => (
                <AnalysisCard key={s.key} section={s} items={result.ai_analysis[s.key] || []} />
              ))}
            </div>

            {/* Type-Specific Sections */}
            <div className="grid gap-4 md:grid-cols-2">
              {typeSections.map((s) => (
                <AnalysisCard key={s.key} section={s} items={result.ai_analysis[s.key] || []} />
              ))}
            </div>

            {/* Actions */}
            <div className="flex flex-col sm:flex-row gap-3">
              <Button variant="outline" onClick={handleNewComparison} className={comparisonType === "peer_to_peer" ? "w-full" : ""}>
                <RotateCcw className="h-4 w-4 mr-2" />
                Nova Comparação
              </Button>
            </div>
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
