import { useNavigate } from "react-router-dom";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { BarChart3, Users, Sparkles, ArrowRight, CheckCircle2 } from "lucide-react";
import { DniaInfoIcon } from "@/components/DniaInfoIcon";

const features = [
  {
    icon: BarChart3,
    title: "Análise Precisa",
    description:
      "Análise comportamental e inteligência emocional integrada no dnia para mapear o perfil de cada colaborador.",
  },
  {
    icon: Users,
    title: "Gestão de Equipes",
    description:
      "Compare perfis, identifique complementaridades e monte equipes de alta performance com dados concretos.",
  },
  {
    icon: Sparkles,
    title: "IA Integrada",
    description:
      "Receba análises textuais e recomendações geradas por inteligência artificial para cada perfil mapeado.",
  },
];

const benefits = [
  "Metodologia dnia validada",
  "Resultados em tempo real",
  "Relatórios personalizados",
  "Comparação entre perfis",
  "Dashboard intuitivo",
  "Suporte especializado",
];

export default function HomePage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-background">
      <Navbar />

      {/* Hero Section */}
      <section className="relative overflow-hidden">
        <div className="gradient-hero">
          <div className="container relative z-10 py-24 lg:py-32">
            <div className="mx-auto max-w-3xl text-center">
              <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/10 px-4 py-1.5 text-sm font-medium text-primary-foreground/90">
                <img src="/logo-dark.svg" alt="dnia" className="h-4 w-4 dark:hidden" />
                <img src="/logo.svg" alt="dnia" className="hidden h-4 w-4 dark:block" />
                Plataforma de Análise dnia
              </div>

              <h1 className="mb-6 text-4xl font-extrabold leading-tight tracking-tight text-primary-foreground sm:text-5xl lg:text-6xl">
                Descubra o seu DNIA comportamental e de todo o seu time
              </h1>

              <p className="mb-10 text-lg text-primary-foreground/80 sm:text-xl">
                O Mapeamento DNIA é para empresas que valorizam dados na gestão de pessoas. Perfil comportamental e inteligência emocional em uma análise única.
              </p>

              <div className="flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
                <Button
                  size="lg"
                  onClick={() => navigate("/login")}
                  className="btn-shine text-base font-semibold px-8 py-6 rounded-lg"
                >
                  Começar Agora
                  <ArrowRight className="ml-2 h-5 w-5" />
                </Button>
                <Button
                  size="lg"
                  variant="outline"
                  className="border-primary-foreground/30 text-primary-foreground hover:bg-primary-foreground/10 text-base px-8 py-6 rounded-lg"
                >
                  Saiba Mais
                </Button>
              </div>
            </div>
          </div>
        </div>

        {/* Decorative elements */}
        <div className="absolute -bottom-1 left-0 right-0 h-16 bg-gradient-to-t from-background to-transparent" />
      </section>

      {/* Features Section */}
      <section className="container py-20 lg:py-28">
        <div className="mx-auto mb-16 max-w-2xl text-center">
          <h2 className="mb-4 text-3xl font-bold text-foreground sm:text-4xl">
            Tudo que você precisa para gestão comportamental
          </h2>
          <p className="text-lg text-muted-foreground">
            Uma plataforma completa para mapear, analisar e comparar perfis comportamentais da sua equipe.
          </p>
        </div>

        <div className="grid gap-8 md:grid-cols-3">
          {features.map((feature, i) => (
            <Card
              key={feature.title}
              className="group border-border bg-card shadow-card transition-all duration-300 hover:shadow-card-hover hover:-translate-y-1"
              style={{ animationDelay: `${i * 100}ms` }}
            >
              <CardContent className="p-8">
                <div className="mb-5 flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10">
                  <feature.icon className="h-6 w-6 text-primary" />
                </div>
                <h3 className="mb-3 text-xl font-semibold text-card-foreground">{feature.title}</h3>
                <p className="leading-relaxed text-muted-foreground">{feature.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Benefits Section */}
      <section className="bg-card/50 py-20">
        <div className="container">
          <div className="grid items-center gap-12 lg:grid-cols-2">
            <div>
              <h2 className="mb-4 text-3xl font-bold text-foreground sm:text-4xl">
                Por que escolher o dnia?
              </h2>
              <p className="mb-8 text-lg text-muted-foreground">
                Combinamos ciência comportamental com inteligência artificial para entregar insights acionáveis sobre sua equipe.
              </p>
              <div className="grid gap-3 sm:grid-cols-2">
                {benefits.map((benefit) => (
                  <div key={benefit} className="flex items-center gap-2.5">
                    <CheckCircle2 className="h-5 w-5 shrink-0 text-success" />
                    <span className="text-sm font-medium text-foreground">{benefit}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="relative">
              <div className="rounded-2xl border border-border bg-card p-8 shadow-card">
                <div className="mb-6 flex items-center gap-3">
                  <div className="h-3 w-3 rounded-full bg-destructive" />
                  <div className="h-3 w-3 rounded-full bg-brand-red" />
                  <div className="h-3 w-3 rounded-full bg-success" />
                </div>
                <div className="space-y-4">
                  <div className="flex items-center gap-4">
                    <div className="text-sm font-semibold text-foreground">Perfil dnia</div>
                  </div>
                  <div className="grid grid-cols-4 gap-3">
                    {[
                      { label: "D", value: 75, color: "bg-primary" },
                      { label: "N", value: 60, color: "bg-brand-red" },
                      { label: "I", value: 45, color: "bg-success" },
                      { label: "A", value: 85, color: "bg-emerald-500" },
                    ].map((item) => (
                      <div key={item.label} className="text-center">
                        <div className="relative mx-auto mb-2 h-24 w-8 overflow-hidden rounded-full bg-muted">
                          <div
                            className={`absolute bottom-0 w-full rounded-full ${item.color} transition-all duration-1000`}
                            style={{ height: `${item.value}%` }}
                          />
                        </div>
                        <div className="flex items-center justify-center gap-0.5">
                          <span className="text-xs font-bold text-foreground">{item.label}</span>
                          <DniaInfoIcon letter={item.label as "D" | "N" | "I" | "A"} className="h-4 w-4" />
                        </div>
                        <span className="block text-xs text-muted-foreground">{item.value}%</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border bg-card py-10">
        <div className="container">
          <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
            <img src="/logo-dark.svg" alt="dnia Logo" className="h-7 w-auto dark:hidden" />
            <img src="/logo.svg" alt="dnia Logo" className="hidden h-7 w-auto dark:block" />
            <p className="text-sm text-muted-foreground">
              © {new Date().getFullYear()} dnia. Todos os direitos reservados.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
