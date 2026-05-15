import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Card } from "@/components/ui/card";
import type { ProfileData } from "@/data/detailedProfiles";
import {
  Settings,
  Zap,
  Target,
  Flame,
  MessageCircle,
  BookOpen,
  Users,
  AlertTriangle,
  Ban,
  CheckCircle2,
  Star,
  Lightbulb,
  Siren,
  X,
  ArrowRight,
} from "lucide-react";

interface ProfileAccordionsProps {
  profile: ProfileData;
}

export function ProfileAccordions({ profile }: ProfileAccordionsProps) {
  return (
    <Accordion type="multiple" defaultValue={["leadership-guide"]} className="space-y-3">
      {/* 1. Como Você Funciona */}
      <AccordionItem value="how-you-work" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-primary/10">
                <Settings className="h-5 w-5 text-primary" />
              </span>
              Como Você Funciona
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <div className="grid gap-4 md:grid-cols-3">
              <div className="rounded-lg bg-primary/5 border border-primary/10 p-3">
                <h4 className="text-sm font-semibold text-foreground mb-2">O que te motiva</h4>
                <ul className="space-y-1.5">
                  {profile.howYouWork.motivations.map((m, i) => (
                    <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                      <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-primary" />
                      {m}
                    </li>
                  ))}
                </ul>
              </div>
              <div className="rounded-lg bg-emerald-500/5 border border-emerald-500/10 p-3">
                <h4 className="text-sm font-semibold text-foreground mb-2">Seus valores</h4>
                <ul className="space-y-1.5">
                  {profile.howYouWork.values.map((v, i) => (
                    <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                      <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-emerald-500" />
                      {v}
                    </li>
                  ))}
                </ul>
              </div>
              <div className="rounded-lg bg-destructive/5 border border-destructive/10 p-3">
                <h4 className="text-sm font-semibold text-foreground mb-2">Seus medos</h4>
                <ul className="space-y-1.5">
                  {profile.howYouWork.fears.map((f, i) => (
                    <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                      <AlertTriangle className="h-4 w-4 mt-0.5 shrink-0 text-destructive" />
                      {f}
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 2. Pontos Fortes */}
      <AccordionItem value="strengths" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-emerald-500/10">
                <Zap className="h-5 w-5 text-emerald-500" />
              </span>
              Seus Pontos Fortes (e Como Usar)
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <div className="space-y-3">
              {profile.strengthsWithHow.map((s, i) => (
                <div key={i} className="rounded-lg border border-emerald-500/15 bg-emerald-500/5 p-3">
                  <p className="font-medium text-sm text-foreground">{s.strength}</p>
                  <p className="mt-1 text-sm text-foreground/70 leading-relaxed">{s.howToUse}</p>
                </div>
              ))}
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 3. Áreas de Desenvolvimento */}
      <AccordionItem value="development" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-primary/10">
                <Target className="h-5 w-5 text-primary" />
              </span>
              Áreas de Desenvolvimento (com Plano de Ação)
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <div className="space-y-3">
              {profile.developmentWithPlan.map((d, i) => (
                <div key={i} className="rounded-lg border border-primary/15 bg-primary/5 p-3 space-y-1">
                  <p className="font-medium text-sm text-foreground">{d.area}</p>
                  <p className="text-sm text-foreground/70"><span className="font-medium text-foreground/90">Por quê:</span> {d.why}</p>
                  <p className="text-sm text-foreground/70"><span className="font-medium text-foreground/90">Como desenvolver:</span> {d.howToDevelop}</p>
                </div>
              ))}
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 4. Sob Pressão */}
      <AccordionItem value="under-pressure" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-destructive/10">
                <Flame className="h-5 w-5 text-destructive" />
              </span>
              Você Sob Pressão
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4 space-y-3">
            <div className="rounded-lg bg-destructive/5 border border-destructive/20 p-3">
              <p className="text-sm font-medium text-destructive mb-1">Como você reage:</p>
              <p className="text-sm text-foreground/80 leading-relaxed">{profile.underPressure.howYouReact}</p>
            </div>
            <div>
              <p className="text-sm font-medium text-foreground mb-2">O que fazer:</p>
              <ul className="space-y-1.5">
                {profile.underPressure.whatToDo.map((w, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <ArrowRight className="h-4 w-4 mt-0.5 shrink-0 text-primary" /> {w}
                  </li>
                ))}
              </ul>
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 5. Estilo de Comunicação */}
      <AccordionItem value="communication" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-primary/10">
                <MessageCircle className="h-5 w-5 text-primary" />
              </span>
              Seu Estilo de Comunicação
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4 space-y-3">
            <p className="text-sm text-foreground/80 leading-relaxed">{profile.communicationStyle.howYouCommunicate}</p>
            <div>
              <p className="text-sm font-medium text-foreground mb-2 flex items-center gap-1.5">
                <Lightbulb className="h-4 w-4 text-yellow-500" />
                Dicas para comunicar melhor:
              </p>
              <ul className="space-y-1.5">
                {profile.communicationStyle.tips.map((t, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <Lightbulb className="h-4 w-4 mt-0.5 shrink-0 text-yellow-500/70" /> {t}
                  </li>
                ))}
              </ul>
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 6. Como Aprende */}
      <AccordionItem value="learning" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-primary/10">
                <BookOpen className="h-5 w-5 text-primary" />
              </span>
              Como Você Aprende Melhor
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <p className="text-sm text-foreground/80 leading-relaxed">{profile.learningStyle}</p>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 7. Guia para Seu Líder (ABERTO por padrão) */}
      <AccordionItem value="leadership-guide" className="border-none">
        <Card className="border-2 border-primary/40 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-primary/10">
                <Users className="h-5 w-5 text-primary" />
              </span>
              <Star className="h-4 w-4 text-yellow-500" />
              Guia para Seu Líder
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4 space-y-4">
            <p className="text-sm text-foreground/60 italic">
              Como te motivar, delegar, dar feedback e te liderar em diferentes situações.
            </p>

            <div>
              <h4 className="text-sm font-semibold text-foreground mb-2 flex items-center gap-1.5"><CheckCircle2 className="h-4 w-4 text-emerald-500" /> Como me motivar:</h4>
              <ul className="space-y-1.5">
                {profile.leadershipGuide.howToMotivate.map((m, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-emerald-500/70" /> {m}
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h4 className="text-sm font-semibold text-foreground mb-2 flex items-center gap-1.5"><CheckCircle2 className="h-4 w-4 text-emerald-500" /> Como delegar para mim:</h4>
              <ul className="space-y-1.5">
                {profile.leadershipGuide.howToDelegate.map((d, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-emerald-500/70" /> {d}
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h4 className="text-sm font-semibold text-foreground mb-2">Como dar feedback:</h4>
              <div className="grid gap-3 md:grid-cols-2">
                <div className="rounded-lg border border-emerald-500/30 bg-emerald-500/5 p-3">
                  <p className="text-sm font-medium text-emerald-500 mb-2 flex items-center gap-1.5"><CheckCircle2 className="h-4 w-4" /> O que funciona</p>
                  <ul className="space-y-1.5">
                    {profile.leadershipGuide.howToGiveFeedback.whatWorks.map((w, i) => (
                      <li key={i} className="text-sm text-foreground/80">• {w}</li>
                    ))}
                  </ul>
                </div>
                <div className="rounded-lg border border-destructive/30 bg-destructive/5 p-3">
                  <p className="text-sm font-medium text-destructive mb-2 flex items-center gap-1.5"><X className="h-4 w-4" /> O que não funciona</p>
                  <ul className="space-y-1.5">
                    {profile.leadershipGuide.howToGiveFeedback.whatDoesntWork.map((w, i) => (
                      <li key={i} className="text-sm text-foreground/80">• {w}</li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>

            <div>
              <h4 className="text-sm font-semibold text-foreground mb-2 flex items-center gap-1.5"><ArrowRight className="h-4 w-4 text-primary" /> Em situações de crise:</h4>
              <ul className="space-y-1.5">
                {profile.leadershipGuide.inCrisis.map((c, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <ArrowRight className="h-4 w-4 mt-0.5 shrink-0 text-primary" /> {c}
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h4 className="text-sm font-semibold text-foreground mb-2 flex items-center gap-1.5"><ArrowRight className="h-4 w-4 text-primary" /> Em situações de mudança:</h4>
              <ul className="space-y-1.5">
                {profile.leadershipGuide.inChange.map((c, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                    <ArrowRight className="h-4 w-4 mt-0.5 shrink-0 text-primary" /> {c}
                  </li>
                ))}
              </ul>
            </div>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 8. Sinais de Alerta */}
      <AccordionItem value="warning-signals" className="border-none">
        <Card className="border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-warning/10">
                <AlertTriangle className="h-5 w-5 text-warning" />
              </span>
              Sinais de Alerta (Quando Estou Desmotivado)
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <ul className="space-y-1.5">
              {profile.warningSignals.map((s, i) => (
                <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                  <Siren className="h-4 w-4 mt-0.5 shrink-0 text-warning" /> {s}
                </li>
              ))}
            </ul>
          </AccordionContent>
        </Card>
      </AccordionItem>

      {/* 9. O que NÃO Fazer */}
      <AccordionItem value="what-not-to-do" className="border-none">
        <Card className="border-l-4 border-l-destructive border-border/60 bg-card shadow-card overflow-hidden hover:shadow-card-hover transition-shadow">
          <AccordionTrigger className="px-4 py-3 hover:no-underline hover:bg-muted/50">
            <span className="flex items-center gap-2 text-base font-semibold text-card-foreground">
              <span className="p-1.5 rounded-lg bg-destructive/10">
                <Ban className="h-5 w-5 text-destructive" />
              </span>
              O que NÃO Fazer Comigo
            </span>
          </AccordionTrigger>
          <AccordionContent className="px-4 pb-4">
            <ul className="space-y-1.5">
              {profile.whatNotToDo.map((w, i) => (
                <li key={i} className="flex items-start gap-2 text-sm text-foreground/80">
                  <X className="h-4 w-4 mt-0.5 shrink-0 text-destructive" /> {w}
                </li>
              ))}
            </ul>
          </AccordionContent>
        </Card>
      </AccordionItem>
    </Accordion>
  );
}
