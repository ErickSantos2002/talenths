import { useState, useEffect } from "react";
import { useSearchParams } from "react-router-dom";
import { useIsMobile } from "@/hooks/use-mobile";
import { tests, profiles, companies, getToken } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { Navbar } from "@/components/Navbar";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/ui/accordion";
import { SectionCard, ListSection } from "@/components/result/SectionCard";
import {
  Loader2, Share2, Target, AlertTriangle, FileDown, Lightbulb,
  CheckCircle2, ArrowRight, Flame, Users, Compass, Sparkles, Brain, Heart, Zap, BookOpen,
} from "lucide-react";
import { Separator } from "@/components/ui/separator";
import { toast } from "@/hooks/use-toast";
import {
  RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, ResponsiveContainer, Tooltip,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Legend,
} from "recharts";
import { ResultHeader } from "@/components/result/ResultHeader";
import { ScoreTable } from "@/components/result/ScoreTable";
import { AdaptationCard } from "@/components/result/AdaptationCard";
import { PracticalInsightBox } from "@/components/result/PracticalInsightBox";
import { ProfileAccordions } from "@/components/result/ProfileAccordions";
import { detailedProfiles } from "@/data/detailedProfiles";
import { dniaDimensions, dniaDimensionLabels, dniaTraits, discToDisplayKey, dniaDisplayOrder } from "@/data/dniaLabels";
import { DniaInfoIcon, DniaFullAcronym } from "@/components/DniaInfoIcon";

interface TestResult {
  id: string;
  user_id: string;
  disc_natural: { D: number; I: number; S: number; C: number };
  disc_adapted: { D: number; I: number; S: number; C: number };
  big_five: { O: number; C: number; E: number; A: number; N: number };
  iem: number;
  ai_analysis: {
    perfil_dominante?: string;
    ponto_integracao?: string;
    estilo_disc?: { D?: string; I?: string; S?: string; C?: string };
    perfil_estilos_pessoais?: string;
    estilos_predominantes?: string;
    tracos_dominantes?: string[];
    areas_melhoria_papel?: string[];
    pontos_fortes?: string[];
    areas_desenvolvimento?: string[];
    motivacoes?: string;
    maturidade_emocional?: string;
    contribuicao_papel_social?: string;
    maturidade?: string;
    energia_vitalidade?: string;
    iem_analise?: string;
  };
  share_token: string;
  completed_at: string;
}

const discLabels = dniaDimensions;
const oceanLabels = dniaTraits;

/* ───────────────────────────────────────── Parsing ───────────────────────────────────────── */

function parseFullAnalysis(rawAnalysis: any): TestResult["ai_analysis"] {
  let analysis = typeof rawAnalysis === "string"
    ? (() => { try { return JSON.parse(rawAnalysis); } catch { return {}; } })()
    : (rawAnalysis || {});

  // perfil_dominante pode conter o JSON inteiro da análise como string aninhada
  if (
    analysis.perfil_dominante &&
    typeof analysis.perfil_dominante === "string" &&
    analysis.perfil_dominante.trim().startsWith("{")
  ) {
    try {
      const sanitized = analysis.perfil_dominante.replace(/,(\s*[}\]])/g, "$1");
      const inner = JSON.parse(sanitized);
      // Mescla: campos internos prevalecem sobre os vazios do nível superior
      analysis = { ...analysis, ...inner };
    } catch {
      /* mantém analysis original */
    }
  }

  // Garante que arrays sejam arrays
  for (const key of ["tracos_dominantes", "pontos_fortes", "areas_desenvolvimento", "areas_melhoria_papel"] as const) {
    if (analysis[key] && typeof analysis[key] === "string") {
      try { analysis[key] = JSON.parse(analysis[key]); } catch { analysis[key] = []; }
    }
    if (!Array.isArray(analysis[key])) analysis[key] = [];
  }

  // Garante que estilo_disc seja objeto
  if (analysis.estilo_disc && typeof analysis.estilo_disc === "string") {
    try { analysis.estilo_disc = JSON.parse(analysis.estilo_disc); } catch { analysis.estilo_disc = {}; }
  }

  return analysis;
}

/* ───────────────────────────────────────── Helpers de renderização ───────────────────────────────────────── */

function renderFormattedText(text: string | undefined | null): React.ReactNode {
  if (!text) return null;
  const str = String(text);

    const highlightTerms = (s: string): React.ReactNode[] => {
      const pattern = /(Determinado|Influenciador|Navegador|Analista|Determinação|Natureza|Influência|Adaptação|Inovação|Disciplina|Sociabilidade|Empatia|Resiliência|dnia|DNIA|IEM)/g;
    const parts = s.split(pattern);
    return parts.map((part, i) =>
      pattern.test(part)
        ? <strong key={i} className="text-foreground font-semibold">{part}</strong>
        : <span key={i}>{part}</span>
    );
  };

  const paragraphs = str.split(/\n\n+/).filter(Boolean);
  return (
    <div className="space-y-3">
      {paragraphs.map((para, i) => {
        const lines = para.split(/\n/).filter(Boolean);
        return (
          <p key={i} className="text-[15px] leading-[1.75] tracking-normal text-foreground/75">
            {lines.map((line, j) => (
              <span key={j}>
                {j > 0 && <br />}
                {highlightTerms(line.trim())}
              </span>
            ))}
          </p>
        );
      })}
    </div>
  );
}

function getDominantDisc(disc: { D: number; I: number; S: number; C: number }): string {
  return Object.entries(disc).sort((a, b) => b[1] - a[1])[0][0];
}

function getSecondaryDisc(disc: { D: number; I: number; S: number; C: number }): string | null {
  const sorted = Object.entries(disc).sort((a, b) => b[1] - a[1]);
  return sorted[1][1] > 50 ? sorted[1][0] : null;
}

function getDiscPracticalText(disc: { D: number; I: number; S: number; C: number }): string {
  const insights: string[] = [];
  if (disc.D > 60) insights.push("Você é uma pessoa de ação rápida e direta.");
  if (disc.D < 30) insights.push("Você prefere colaborar a competir.");
  if (disc.I > 60) insights.push("Você é comunicativo e gosta de estar com pessoas.");
  if (disc.I < 30) insights.push("Você prefere reflexão individual a grandes grupos.");
  if (disc.S > 60) insights.push("Você valoriza harmonia e prefere ambientes estáveis.");
  if (disc.S < 30) insights.push("Você se adapta facilmente a mudanças.");
  if (disc.C > 60) insights.push("Você é detalhista e gosta de seguir processos.");
  if (disc.C < 30) insights.push("Você prefere flexibilidade a regras rígidas.");
  return insights.length > 0 ? insights.join(" ") : "Seu mapeamento dnia mostra um equilíbrio entre os fatores comportamentais.";
}

function getBigFivePracticalText(bf: { O: number; C: number; E: number; A: number; N: number }): string {
  const insights: string[] = [];
  if (bf.O > 60) insights.push("Sua alta Abertura indica curiosidade e criatividade.");
  else if (bf.O < 30) insights.push("Você prefere o prático e concreto ao abstrato.");
  if (bf.C > 60) insights.push("Sua Conscienciosidade alta indica organização e disciplina.");
  else if (bf.C < 30) insights.push("Você é flexível e adaptável nos processos.");
  if (bf.E > 60) insights.push("Sua Extroversão alta traz energia social e assertividade.");
  else if (bf.E < 30) insights.push("Você recarrega energia em momentos de introspecção.");
  if (bf.A > 60) insights.push("Sua alta Amabilidade indica empatia e cooperação.");
  else if (bf.A < 30) insights.push("Você é mais analítico que empático nas decisões.");
  if (bf.N < 30) insights.push("Sua estabilidade emocional é uma grande fortaleza.");
  else if (bf.N > 60) insights.push("Você é mais sensível emocionalmente, o que traz profundidade.");
  return insights.length > 0 ? insights.join(" ") : "Seus traços de personalidade estão equilibrados.";
}

/* ───────────────────────────────────────── Component ───────────────────────────────────────── */

export default function ResultPage() {
  const isMobile = useIsMobile();
  const { user, hasRole } = useAuth();
  const isAdmin = hasRole("master_admin") || hasRole("company_admin");
  const [searchParams] = useSearchParams();
  const shareToken = searchParams.get("token");
  const paramUserId = searchParams.get("userId");
  const paramTestId = searchParams.get("testId");
  const [result, setResult] = useState<TestResult | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isDownloadingPdf, setIsDownloadingPdf] = useState(false);
  const [profileInfo, setProfileInfo] = useState<{ name: string; companyName?: string } | null>(null);
  const [responses, setResponses] = useState<any[]>([]);
  const [scenarios, setScenarios] = useState<any[]>([]);
  const isMasterAdmin = hasRole("master_admin");

  useEffect(() => {
    const fetchResult = async () => {
      try {
        let r: TestResult | null = null;

        if (paramTestId) {
          r = (await tests.result(paramTestId)) as unknown as TestResult;
        } else if (shareToken) {
          r = (await tests.sharedResult(shareToken)) as unknown as TestResult;
        } else if (paramUserId) {
          const allResults = (await tests.results()) as unknown as TestResult[];
          const userResults = allResults
            .filter((x) => x.user_id === paramUserId)
            .sort((a, b) => new Date(b.completed_at).getTime() - new Date(a.completed_at).getTime());
          r = userResults[0] ?? null;
        } else if (user) {
          const allResults = (await tests.results()) as unknown as TestResult[];
          const sorted = [...allResults].sort(
            (a, b) => new Date(b.completed_at).getTime() - new Date(a.completed_at).getTime()
          );
          r = sorted[0] ?? null;
        } else {
          setIsLoading(false);
          return;
        }

        if (r) {
          setResult(r);
          try {
            const profileData = (await profiles.get(r.user_id)) as any;
            if (profileData) {
              let companyName: string | undefined;
              if (profileData.company_id) {
                try {
                  const allCompanies = (await companies.list()) as any[];
                  const company = allCompanies.find((c) => c.id === profileData.company_id);
                  companyName = company?.name;
                } catch { /* ignore */ }
              }
              setProfileInfo({ name: profileData.name, companyName });
            }
          } catch { /* ignore profile fetch errors */ }
        } else {
          toast({ title: "Erro ao carregar resultado", variant: "destructive" });
        }
      } catch {
        toast({ title: "Erro ao carregar resultado", variant: "destructive" });
      } finally {
        setIsLoading(false);
      }
    };
    fetchResult();
  }, [user, shareToken, paramUserId, paramTestId]);

  // Fetch responses and scenarios for master admin
  useEffect(() => {
    if (!isMasterAdmin || !result) return;
    const fetchResponses = async () => {
      try {
        const scenData = await tests.scenarios();
        setScenarios((scenData as any[]) || []);
        // Responses are embedded in the result or fetched via result detail
        // The API does not expose a standalone responses endpoint; use what's on result
        setResponses((result as any).responses || []);
      } catch { /* ignore */ }
    };
    fetchResponses();
  }, [isMasterAdmin, result]);

  const handleShare = async () => {
    if (!result) return;
    const url = `${window.location.origin}/resultado?token=${result.share_token}`;
    try {
      await navigator.clipboard.writeText(url);
      toast({ title: "Link copiado!", description: "Compartilhe com quem quiser." });
    } catch {
      toast({ title: "Link de compartilhamento", description: url });
    }
  };

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!result) {
    const content = (
      <div className={isAdmin ? "" : "min-h-screen bg-background"}>
        {!isAdmin && <Navbar />}
        <div className="container py-16 text-center">
          <h1 className="text-2xl font-bold text-foreground">Nenhum resultado encontrado</h1>
          <p className="mt-2 text-muted-foreground">Faça o teste primeiro para ver seus resultados.</p>
        </div>
      </div>
    );
    return isAdmin ? <AdminLayout>{content}</AdminLayout> : content;
  }

  const analysis = parseFullAnalysis(result.ai_analysis);
  const dominantDisc = getDominantDisc(result.disc_natural);
  const secondaryDisc = getSecondaryDisc(result.disc_natural);
  const profile = detailedProfiles[dominantDisc];

  const discDimLabels = dniaDimensionLabels;

  const hasAiAnalysis = analysis && Object.keys(analysis).some(
    (k) => k !== "pontos_fortes" && k !== "areas_desenvolvimento" && analysis[k as keyof typeof analysis]
  );
  const hasEstiloDisc = analysis.estilo_disc && typeof analysis.estilo_disc === "object" &&
    Object.values(analysis.estilo_disc).some((v) => v);
  const hasTracos = Array.isArray(analysis.tracos_dominantes) && analysis.tracos_dominantes.length > 0;
  const hasPontosFortes = Array.isArray(analysis.pontos_fortes) && analysis.pontos_fortes.length > 0;
  const hasAreasDesenv = Array.isArray(analysis.areas_desenvolvimento) && analysis.areas_desenvolvimento.length > 0;
  const hasAreasMelhoria = Array.isArray(analysis.areas_melhoria_papel) && analysis.areas_melhoria_papel.length > 0;

  const content = (
    <div className={isAdmin ? "" : "min-h-screen bg-background"}>
      {!isAdmin && <Navbar />}
      <div className="container max-w-4xl py-4 sm:py-8 lg:py-12 space-y-5 sm:space-y-6">

        {/* 1. Header */}
        <div className="animate-fade-in-up">
          <ResultHeader
            userName={profileInfo?.name || user?.email || "Usuário"}
            companyName={profileInfo?.companyName}
            dominantProfile={dominantDisc}
            completedAt={result.completed_at}
          />
        </div>

        {/* AI Processing Banner */}
        {!hasAiAnalysis && (
          <div className="animate-fade-in-up rounded-lg border border-brand-red/40 bg-brand-red/10 p-4">
            <div className="flex items-center gap-3">
              <Loader2 className="h-5 w-5 animate-spin text-brand-red shrink-0" />
              <div>
                <p className="text-sm font-semibold text-foreground">Análise detalhada em processamento</p>
                <p className="text-xs text-muted-foreground">Seus gráficos e scores estão disponíveis abaixo. A análise completa por IA estará disponível em breve.</p>
              </div>
            </div>
          </div>
        )}

        {/* 2. Card Principal: Perfil Predominante */}
        <div className="animate-fade-in-up" style={{ animationDelay: "0.1s" }}>
          <Card className="border-2 border-brand-red/50 hover:border-brand-red bg-card shadow-card card-glow-orange transition-colors">
            <CardHeader className="pb-2">
              <CardTitle className="text-xl text-card-foreground">
                Seu Perfil: {profile?.name || dominantDisc}
                {secondaryDisc && (
                  <span className="text-base font-normal text-muted-foreground ml-2">
                    (com traços de {detailedProfiles[secondaryDisc]?.name || secondaryDisc})
                  </span>
                )}
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-5">
              {renderFormattedText(
                (typeof analysis.perfil_dominante === "string" ? analysis.perfil_dominante : null) ||
                profile?.description || ""
              )}
              {analysis.ponto_integracao && typeof analysis.ponto_integracao === "string" && (
                <>
                  <Separator className="bg-brand-red/20" />
                  <div className="rounded-lg bg-brand-red/10 border border-brand-red/30 p-4">
                    <div className="flex items-start gap-3">
                      <Lightbulb className="h-5 w-5 mt-1 shrink-0 text-brand-red" />
                      <div>
                        <p className="text-sm font-semibold text-foreground mb-1.5">Seu Perfil Único</p>
                        {renderFormattedText(analysis.ponto_integracao)}
                      </div>
                    </div>
                  </div>
                </>
              )}
            </CardContent>
          </Card>
        </div>

        {/* 3. Traços Dominantes + Pontos Fortes (lado a lado) */}
        {(hasTracos || hasPontosFortes) && (
          <div className="animate-fade-in-up grid gap-4 md:grid-cols-2" style={{ animationDelay: "0.12s" }}>
            {hasTracos && (
              <SectionCard icon={<Sparkles className="h-5 w-5" />} iconColor="text-brand-red" title="Traços Dominantes">
                <div className="flex flex-wrap gap-2">
                  {analysis.tracos_dominantes!.map((t, i) => (
                    <Badge key={i} variant="secondary" className="text-sm">{t}</Badge>
                  ))}
                </div>
              </SectionCard>
            )}
            {hasPontosFortes && (
              <ListSection
                icon={<CheckCircle2 className="h-5 w-5" />}
                iconColor="text-emerald-500"
                title="Pontos Fortes"
                items={analysis.pontos_fortes!}
                itemIcon={<CheckCircle2 className="h-4 w-4" />}
              />
            )}
          </div>
        )}

        {/* 4. Gráfico DISC */}
        <div className="animate-fade-in-up" style={{ animationDelay: "0.15s" }}>
          <Card className="border-border bg-card shadow-card">
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-lg font-semibold text-card-foreground">
                Perfil DNIA: Natural vs Adaptado
                <DniaFullAcronym />
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <ResponsiveContainer width="100%" height={isMobile ? 220 : 300}>
                <BarChart
                  data={dniaDisplayOrder.map((key) => ({
                    name: isMobile ? discToDisplayKey[key] : `${discToDisplayKey[key]} - ${discLabels[key]}`,
                    Natural: (result.disc_natural as any)[key],
                    Adaptado: (result.disc_adapted as any)[key],
                  }))}
                  margin={{ top: 5, right: 10, left: -10, bottom: 5 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                  <XAxis dataKey="name" tick={{ fill: "hsl(var(--foreground))", fontSize: isMobile ? 12 : 11 }} />
                  <YAxis domain={[0, 100]} tick={{ fill: "hsl(var(--muted-foreground))", fontSize: 10 }} />
                  <Tooltip contentStyle={{ backgroundColor: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: "8px", color: "hsl(var(--foreground))" }} />
                  <Legend />
                  <Bar dataKey="Natural" fill="#E41A11" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="Adaptado" fill="#10B981" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
              <ScoreTable labels={discLabels} naturalData={result.disc_natural} adaptedData={result.disc_adapted} />
              <PracticalInsightBox variant="disc">
                {getDiscPracticalText(result.disc_natural)}
              </PracticalInsightBox>
            </CardContent>
          </Card>
        </div>

        {/* 5. Estilo DISC Detalhado */}
        {hasEstiloDisc && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.17s" }}>
            <SectionCard icon={<Compass className="h-5 w-5" />} iconColor="text-primary" title="Estilo Comportamental Detalhado">
              <div className="space-y-4">
                {dniaDisplayOrder.map((dim) => {
                  const text = analysis.estilo_disc?.[dim];
                  if (!text) return null;
                  return (
                    <div key={dim} className="rounded-lg border border-primary/15 bg-primary/5 p-4">
                      <h4 className="text-sm font-semibold text-foreground mb-2">{discDimLabels[dim]}</h4>
                      {renderFormattedText(text)}
                    </div>
                  );
                })}
              </div>
            </SectionCard>
          </div>
        )}

        {/* 6. Estilos Predominantes */}
        {analysis.estilos_predominantes && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.19s" }}>
            <SectionCard icon={<Flame className="h-5 w-5" />} iconColor="text-brand-red" title="Estilos Predominantes">
              {renderFormattedText(analysis.estilos_predominantes)}
            </SectionCard>
          </div>
        )}

        {/* 7. Perfil de Estilos Pessoais */}
        {analysis.perfil_estilos_pessoais && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.21s" }}>
            <SectionCard icon={<Users className="h-5 w-5" />} iconColor="text-emerald-500" title="Perfil de Estilos Pessoais">
              {renderFormattedText(analysis.perfil_estilos_pessoais)}
            </SectionCard>
          </div>
        )}

        {/* 8. Radar Big Five */}
        <div className="animate-fade-in-up" style={{ animationDelay: "0.23s" }}>
          <Card className="border-border bg-card shadow-card">
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-lg font-semibold text-card-foreground">
                Traços de Personalidade dnia
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <ResponsiveContainer width="100%" height={isMobile ? 220 : 280}>
                <RadarChart data={Object.entries(result.big_five).map(([key, value]) => ({
                  subject: isMobile ? key : `${key} - ${oceanLabels[key]}`, value, fullMark: 100,
                }))}>
                  <PolarGrid stroke="hsl(var(--border))" />
                  <PolarAngleAxis dataKey="subject" tick={{ fill: "hsl(var(--foreground))", fontSize: isMobile ? 12 : 11 }} />
                  <PolarRadiusAxis angle={90} domain={[0, 100]} tick={{ fill: "hsl(var(--muted-foreground))", fontSize: 10 }} />
                  <Radar name="Personalidade" dataKey="value" stroke="#10B981" fill="#10B981" fillOpacity={0.3} strokeWidth={2} animationDuration={800} />
                  <Tooltip contentStyle={{ backgroundColor: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: "8px", color: "hsl(var(--foreground))" }} />
                </RadarChart>
              </ResponsiveContainer>
              <ScoreTable labels={oceanLabels} naturalData={result.big_five} primaryColor="text-emerald-500" showDniaAcronym={false} />
              <PracticalInsightBox variant="bigfive">
                {getBigFivePracticalText(result.big_five)}
              </PracticalInsightBox>
            </CardContent>
          </Card>
        </div>

        {/* 9. Como Você Se Adapta */}
        <div className="animate-fade-in-up" style={{ animationDelay: "0.25s" }}>
          <AdaptationCard natural={result.disc_natural} adapted={result.disc_adapted} />
        </div>

        {/* 10. Seções Expansíveis do Perfil */}
        {profile && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.27s" }}>
            <ProfileAccordions profile={profile} />
          </div>
        )}

        {/* 11. Motivações */}
        {analysis.motivacoes && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.29s" }}>
            <SectionCard icon={<Zap className="h-5 w-5" />} iconColor="text-brand-red" title="Motivações">
              {renderFormattedText(analysis.motivacoes)}
            </SectionCard>
          </div>
        )}

        {/* 12. Maturidade Emocional */}
        {analysis.maturidade_emocional && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.31s" }}>
            <SectionCard icon={<Heart className="h-5 w-5" />} iconColor="text-emerald-500" title="Perfil de Maturidade Emocional">
              {renderFormattedText(analysis.maturidade_emocional)}
            </SectionCard>
          </div>
        )}

        {/* 13. Maturidade */}
        {analysis.maturidade && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.33s" }}>
            <SectionCard icon={<BookOpen className="h-5 w-5" />} iconColor="text-primary" title="Maturidade">
              {renderFormattedText(analysis.maturidade)}
            </SectionCard>
          </div>
        )}

        {/* 14. Contribuição e Papel Social */}
        {analysis.contribuicao_papel_social && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.35s" }}>
            <SectionCard icon={<Users className="h-5 w-5" />} iconColor="text-brand-red" title="Contribuição e Papel Social">
              {renderFormattedText(analysis.contribuicao_papel_social)}
            </SectionCard>
          </div>
        )}

        {/* 15. Energia e Vitalidade */}
        {analysis.energia_vitalidade && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.37s" }}>
            <SectionCard icon={<Flame className="h-5 w-5" />} iconColor="text-brand-red" title="Energia e Vitalidade">
              {renderFormattedText(analysis.energia_vitalidade)}
            </SectionCard>
          </div>
        )}

        {/* 16. IEM */}
        <div className="animate-fade-in-up" style={{ animationDelay: "0.39s" }}>
          <Card className="border-border bg-card shadow-card">
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-lg text-card-foreground">
                <AlertTriangle className="h-5 w-5 text-destructive" />
                IEM (Índice de Equilíbrio Mental)
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex flex-col sm:flex-row items-center gap-4">
                <div className="flex h-14 w-14 sm:h-16 sm:w-16 items-center justify-center rounded-full bg-destructive/10">
                  <span className="text-xl sm:text-2xl font-bold text-destructive">{result.iem}</span>
                </div>
                <div className="flex-1 text-center sm:text-left">
                  {analysis.iem_analise
                    ? renderFormattedText(analysis.iem_analise)
                    : <p className="text-sm leading-relaxed text-foreground/75">Seu índice de estresse mental é {result.iem}/100.</p>
                  }
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* 17. Áreas de Desenvolvimento + Áreas de Melhoria */}
        {(hasAreasDesenv || hasAreasMelhoria) && (
          <div className="animate-fade-in-up grid gap-4 md:grid-cols-2" style={{ animationDelay: "0.41s" }}>
            {hasAreasDesenv && (
              <ListSection
                icon={<Target className="h-5 w-5" />}
                iconColor="text-primary"
                title="Áreas de Desenvolvimento"
                items={analysis.areas_desenvolvimento!}
                itemIcon={<ArrowRight className="h-4 w-4" />}
              />
            )}
            {hasAreasMelhoria && (
              <ListSection
                icon={<AlertTriangle className="h-5 w-5" />}
                iconColor="text-destructive"
                title="Áreas de Melhoria no Papel"
                items={analysis.areas_melhoria_papel!}
                itemIcon={<AlertTriangle className="h-4 w-4" />}
              />
            )}
          </div>
        )}

        {/* 18. Respostas do Teste (Master Admin only) */}
        {isMasterAdmin && scenarios.length > 0 && (
          <div className="animate-fade-in-up" style={{ animationDelay: "0.46s" }}>
            <Accordion type="single" collapsible className="space-y-3">
              <AccordionItem value="test-responses" className="border-none">
                <Card className="border-border bg-card shadow-card overflow-hidden">
                  <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
                    <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
                      <BookOpen className="h-5 w-5 text-primary" />
                      Respostas do Teste
                    </span>
                  </AccordionTrigger>
                  <AccordionContent className="px-4 pb-4 space-y-3">
                    {scenarios.map((scenario) => {
                      const response = responses.find((r) => r.block_number === scenario.block_number);
                      const options = [
                        { key: "a", label: scenario.option_a },
                        { key: "b", label: scenario.option_b },
                        { key: "c", label: scenario.option_c },
                        { key: "d", label: scenario.option_d },
                      ];
                      return (
                        <div key={scenario.id} className="rounded-lg border border-border p-4 space-y-2">
                          <p className="text-sm font-semibold text-foreground">
                            Cenário {scenario.block_number}: <span className="font-normal text-muted-foreground">{scenario.scenario}</span>
                          </p>
                          <div className="grid gap-1.5">
                            {options.filter((opt) => opt.key === response?.most_option?.toLowerCase() || opt.key === response?.least_option?.toLowerCase()).map((opt) => {
                              const isMost = response?.most_option?.toLowerCase() === opt.key;
                              return (
                                <div
                                  key={opt.key}
                                  className={`flex items-center gap-2 rounded-md px-3 py-1.5 text-sm ${
                                    isMost
                                      ? "bg-emerald-500/20 border border-emerald-500 text-foreground font-medium"
                                      : "bg-destructive/10 border border-destructive/30 text-foreground font-medium"
                                  }`}
                                >
                                  <span className="uppercase font-bold w-4">{opt.key}</span>
                                  <span className="flex-1">{opt.label}</span>
                                  {isMost ? <Badge variant="secondary" className="text-xs">MAIS</Badge> : <Badge variant="destructive" className="text-xs">MENOS</Badge>}
                                </div>
                              );
                            })}
                          </div>
                        </div>
                      );
                    })}
                  </AccordionContent>
                </Card>
              </AccordionItem>
            </Accordion>
          </div>
        )}

        {/* 19. Footer Actions */}
        <div className="animate-fade-in-up flex flex-wrap justify-center gap-4 pb-8" style={{ animationDelay: "0.45s" }}>
          <Button onClick={handleShare} className="gap-2">
            <Share2 className="h-4 w-4" />
            Compartilhar Resultado
          </Button>
          <Button
            variant="outline"
            className="gap-2"
            disabled={isDownloadingPdf}
            onClick={async () => {
              setIsDownloadingPdf(true);
              try {
                const token = getToken();
                const BASE_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000";
                const res = await fetch(`${BASE_URL}/tests/results/${result.id}/pdf`, {
                  method: "GET",
                  headers: token ? { Authorization: `Bearer ${token}` } : {},
                });
                if (!res.ok) throw new Error("Erro ao gerar PDF");
                const blob = await res.blob();
                const url = URL.createObjectURL(blob);
                const a = document.createElement("a");
                a.href = url;
                a.download = "dnia-resultado.pdf";
                a.click();
                URL.revokeObjectURL(url);
                toast({ title: "PDF baixado com sucesso!" });
              } catch {
                toast({ title: "Erro ao gerar PDF", variant: "destructive" });
              } finally {
                setIsDownloadingPdf(false);
              }
            }}
          >
            {isDownloadingPdf ? <Loader2 className="h-4 w-4 animate-spin" /> : <FileDown className="h-4 w-4" />}
            Baixar PDF
          </Button>
        </div>
      </div>
    </div>
  );

  return isAdmin ? <AdminLayout>{content}</AdminLayout> : content;
}
