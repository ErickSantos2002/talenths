import { useState, useCallback } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { supabase } from "@/integrations/supabase/client";
import { Loader2, Brain, TrendingUp, AlertTriangle, Lightbulb, Users, Shield, MessageCircle, Clock } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, Legend, ResponsiveContainer } from "recharts";
import { scoreColor } from "@/lib/teamAnalysisUtils";

type ComparisonType = "peer_to_peer" | "leader_member";

interface ComparisonResult {
  compatibility_score: number;
  comparison_type: ComparisonType;
  ai_analysis: Record<string, string[]>;
  user1: { name: string; disc: { D: number; I: number; S: number; C: number } };
  user2: { name: string; disc: { D: number; I: number; S: number; C: number } };
}

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
        <CardTitle className="flex items-center gap-2 text-base">
          <Icon className={`h-4 w-4 ${section.iconColor}`} />
          {section.title}
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ul className="space-y-1.5">
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

export function useCompatibilityModal(onResult?: (user1Id: string, user2Id: string, score: number) => void) {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<ComparisonResult | null>(null);
  const [error, setError] = useState<string | null>(null);

  const openModal = useCallback(async (user1Id: string, user2Id: string, type: ComparisonType) => {
    setOpen(true);
    setLoading(true);
    setResult(null);
    setError(null);

    try {
      const { data, error: fnError } = await supabase.functions.invoke("compare-profiles", {
        body: { user1_id: user1Id, user2_id: user2Id, comparison_type: type },
      });
      if (fnError) throw fnError;
      const comparison = data as ComparisonResult;
      setResult(comparison);
      onResult?.(user1Id, user2Id, comparison.compatibility_score);
    } catch (err: any) {
      setError(err.message || "Erro ao comparar perfis");
    } finally {
      setLoading(false);
    }
  }, [onResult]);

  const closeModal = useCallback(() => {
    setOpen(false);
    setResult(null);
    setError(null);
  }, []);

  return { open, loading, result, error, openModal, closeModal };
}

interface CompatibilityModalProps {
  open: boolean;
  onClose: () => void;
  loading: boolean;
  result: ComparisonResult | null;
  error: string | null;
}

export function CompatibilityModal({ open, onClose, loading, result, error }: CompatibilityModalProps) {
  const getScoreLabel = (score: number) => {
    if (score >= 80) return "Excelente";
    if (score >= 60) return "Boa";
    return "Atenção Necessária";
  };

  const radarData = result
    ? [
        { dimension: "D", [result.user1.name]: result.user1.disc.D, [result.user2.name]: result.user2.disc.D },
        { dimension: "I", [result.user1.name]: result.user1.disc.I, [result.user2.name]: result.user2.disc.I },
        { dimension: "S", [result.user1.name]: result.user1.disc.S, [result.user2.name]: result.user2.disc.S },
        { dimension: "C", [result.user1.name]: result.user1.disc.C, [result.user2.name]: result.user2.disc.C },
      ]
    : [];

  const typeSections = result?.comparison_type === "leader_member" ? leaderSections : peerSections;

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="max-w-3xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Brain className="h-5 w-5 text-primary" />
            Análise de Compatibilidade
          </DialogTitle>
        </DialogHeader>

        {loading && (
          <div className="flex flex-col items-center justify-center py-16 gap-3">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Gerando análise com IA...</p>
          </div>
        )}

        {error && (
          <div className="py-8 text-center">
            <AlertTriangle className="mx-auto h-8 w-8 text-destructive" />
            <p className="mt-2 text-sm text-destructive">{error}</p>
          </div>
        )}

        {result && (
          <div className="space-y-4">
            {/* Score */}
            <div className="text-center py-4">
              <span className={`text-5xl font-bold ${scoreColor(result.compatibility_score)}`}>
                {result.compatibility_score}
              </span>
              <span className="text-xl text-muted-foreground">/100</span>
              <p className={`mt-1 text-sm font-semibold ${scoreColor(result.compatibility_score)}`}>
                {getScoreLabel(result.compatibility_score)}
              </p>
              <p className="text-xs text-muted-foreground">
                {result.user1.name} & {result.user2.name}
              </p>
            </div>

            {/* Radar */}
            <ResponsiveContainer width="100%" height={280}>
              <RadarChart data={radarData}>
                <PolarGrid />
                <PolarAngleAxis dataKey="dimension" />
                <PolarRadiusAxis angle={90} domain={[0, 100]} />
                <Radar name={result.user1.name} dataKey={result.user1.name} stroke="#3D61FF" fill="#3D61FF" fillOpacity={0.3} />
                <Radar name={result.user2.name} dataKey={result.user2.name} stroke="#E41A11" fill="#E41A11" fillOpacity={0.3} />
                <Legend />
              </RadarChart>
            </ResponsiveContainer>

            {/* Common Sections */}
            <div className="grid gap-3 md:grid-cols-3">
              {commonSections.map((s) => (
                <AnalysisCard key={s.key} section={s} items={result.ai_analysis[s.key] || []} />
              ))}
            </div>

            {/* Type-Specific Sections */}
            <div className="grid gap-3 md:grid-cols-2">
              {typeSections.map((s) => (
                <AnalysisCard key={s.key} section={s} items={result.ai_analysis[s.key] || []} />
              ))}
            </div>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
