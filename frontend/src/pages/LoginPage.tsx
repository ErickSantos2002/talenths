import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Eye, EyeOff, Loader2, Mail, Users, BarChart3, Brain, MessageSquare } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";

const FEATURES = [
  {
    title: "Psicometria DISC + OCEAN",
    desc: "Mapeie o perfil comportamental de cada colaborador com precisão científica.",
    icon: <Brain className="w-5 h-5" />,
  },
  {
    title: "Chat IA personalizado",
    desc: "Insights e orientações baseados no perfil único de cada colaborador.",
    icon: <MessageSquare className="w-5 h-5" />,
  },
  {
    title: "Dashboard de desenvolvimento",
    desc: "Acompanhe a evolução de cada pessoa ao longo do tempo.",
    icon: <BarChart3 className="w-5 h-5" />,
  },
  {
    title: "Análise de equipe",
    desc: "Compare perfis e descubra a dinâmica ideal para o seu time.",
    icon: <Users className="w-5 h-5" />,
  },
];

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const { signIn } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  const [forgotOpen, setForgotOpen] = useState(false);
  const [forgotEmail, setForgotEmail] = useState("");
  const [forgotLoading, setForgotLoading] = useState(false);
  const [forgotSent, setForgotSent] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    const { error } = await signIn(email, password);
    if (error) {
      toast({
        variant: "destructive",
        title: "Erro ao entrar",
        description: "Email ou senha incorretos. Verifique suas credenciais.",
      });
    } else {
      navigate("/apresentacao");
    }
    setIsLoading(false);
  };

  const handleForgotPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setForgotLoading(true);
    await new Promise((r) => setTimeout(r, 600));
    setForgotSent(true);
    setForgotLoading(false);
  };

  const openForgotModal = () => {
    setForgotEmail(email);
    setForgotSent(false);
    setForgotOpen(true);
  };

  return (
    <div className="dark min-h-screen flex">
      {/* ── Left panel 60% — branding ───────────────────────── */}
      <div className="hidden lg:flex lg:w-3/5 relative flex-col justify-between overflow-hidden px-14 py-12" style={{ backgroundColor: "#080F1A" }}>
        {/* Decorative blobs */}
        <div className="pointer-events-none absolute -top-32 -right-32 w-[500px] h-[500px] rounded-full blur-[120px]" style={{ backgroundColor: "rgba(16,185,129,0.15)" }} />
        <div className="pointer-events-none absolute -bottom-40 -left-20 w-[400px] h-[400px] rounded-full blur-[100px]" style={{ backgroundColor: "rgba(16,185,129,0.08)" }} />

        {/* Logo */}
        <div className="relative z-10">
          <Link to="/">
            <img src="/logo.png" alt="TalentHS" className="h-10 w-auto object-contain" />
          </Link>
        </div>

        {/* Main copy */}
        <div className="relative z-10 space-y-10">
          <div className="space-y-4">
            <div
              className="inline-flex items-center gap-2 rounded-full px-3 py-1"
              style={{ border: "1px solid rgba(16,185,129,0.3)", backgroundColor: "rgba(16,185,129,0.1)" }}
            >
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
              <span className="text-xs font-medium text-emerald-400">RH Inteligente — HealthSafety Tech</span>
            </div>
            <h1 className="text-4xl font-bold text-white leading-tight">
              Desenvolva o potencial<br />do seu time
            </h1>
            <p className="text-base leading-relaxed max-w-md" style={{ color: "#94a3b8" }}>
              Plataforma completa de RH com psicometria, IA e análise de equipe para potencializar o desenvolvimento de cada colaborador.
            </p>
          </div>

          {/* Features */}
          <div className="grid grid-cols-1 gap-5">
            {FEATURES.map((f) => (
              <div key={f.title} className="flex items-start gap-4">
                <div
                  className="shrink-0 flex items-center justify-center w-9 h-9 rounded-lg text-emerald-400"
                  style={{ backgroundColor: "rgba(16,185,129,0.12)" }}
                >
                  {f.icon}
                </div>
                <div>
                  <p className="text-sm font-semibold text-white">{f.title}</p>
                  <p className="text-xs mt-0.5 leading-relaxed" style={{ color: "#64748b" }}>{f.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <div className="relative z-10">
          <p className="text-xs" style={{ color: "#334155" }}>
            © {new Date().getFullYear()} TalentHS — HealthSafety Tech. Todos os direitos reservados.
          </p>
        </div>
      </div>

      {/* ── Right panel 40% — form ──────────────────────────── */}
      <div className="flex flex-1 lg:w-2/5 flex-col items-center justify-center px-6 py-12" style={{ backgroundColor: "#0D1623" }}>
        <div className="w-full max-w-sm space-y-8">
          {/* Mobile logo */}
          <div className="flex lg:hidden items-center justify-center">
            <img src="/logo.png" alt="TalentHS" className="h-10 w-auto object-contain" />
          </div>

          {/* Heading */}
          <div className="space-y-1 text-center lg:text-left">
            <h2 className="text-2xl font-bold" style={{ color: "#f1f5f9" }}>Bem-vindo de volta</h2>
            <p className="text-sm" style={{ color: "#64748b" }}>Entre com suas credenciais para continuar</p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="space-y-2">
              <Label htmlFor="login-email" className="text-sm font-medium" style={{ color: "#cbd5e1" }}>
                E-mail
              </Label>
              <Input
                id="login-email"
                type="email"
                placeholder="seu@email.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="h-10 border-[#1e293b] bg-[#0f1d2e] text-slate-100 placeholder:text-slate-600 focus-visible:ring-emerald-500 focus-visible:border-emerald-500"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="login-password" className="text-sm font-medium" style={{ color: "#cbd5e1" }}>
                Senha
              </Label>
              <div className="relative">
                <Input
                  id="login-password"
                  type={showPassword ? "text" : "password"}
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="h-10 border-[#1e293b] bg-[#0f1d2e] text-slate-100 placeholder:text-slate-600 pr-10 focus-visible:ring-emerald-500 focus-visible:border-emerald-500"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 transition-colors"
                  style={{ color: "#475569" }}
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
            </div>

            <div className="text-right">
              <button
                type="button"
                onClick={openForgotModal}
                className="text-sm font-medium text-emerald-400 hover:text-emerald-300 transition-colors"
              >
                Esqueci minha senha
              </button>
            </div>

            <Button
              type="submit"
              disabled={isLoading}
              className="h-10 w-full bg-emerald-500 hover:bg-emerald-400 text-white font-medium transition-colors disabled:opacity-50"
            >
              {isLoading ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Entrando...
                </>
              ) : (
                "Entrar"
              )}
            </Button>

            {/* Divider */}
            <div className="relative flex items-center gap-3">
              <div className="h-px flex-1" style={{ backgroundColor: "#1e293b" }} />
              <span className="text-xs" style={{ color: "#475569" }}>ou</span>
              <div className="h-px flex-1" style={{ backgroundColor: "#1e293b" }} />
            </div>

            {/* Microsoft SSO */}
            <a
              href={`${import.meta.env.VITE_API_URL ?? "http://localhost:8000"}/auth/microsoft`}
              className="flex h-10 w-full items-center justify-center gap-3 rounded-md border text-sm font-medium transition-colors"
              style={{
                borderColor: "#1e293b",
                backgroundColor: "#0f1d2e",
                color: "#cbd5e1",
              }}
              onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = "#162032")}
              onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "#0f1d2e")}
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 21 21" className="h-4 w-4" aria-hidden="true">
                <rect x="1" y="1" width="9" height="9" fill="#F25022" />
                <rect x="11" y="1" width="9" height="9" fill="#7FBA00" />
                <rect x="1" y="11" width="9" height="9" fill="#00A4EF" />
                <rect x="11" y="11" width="9" height="9" fill="#FFB900" />
              </svg>
              Entrar com Microsoft
            </a>
          </form>

          <p className="text-xs text-center" style={{ color: "#334155" }}>
            Problemas para acessar? Contate o administrador.
          </p>
        </div>
      </div>

      {/* Forgot Password Modal */}
      <Dialog open={forgotOpen} onOpenChange={setForgotOpen}>
        <DialogContent
          className="max-w-[28rem] p-6 text-slate-100"
          style={{ background: "#0D1623", border: "1px solid #1e293b", borderRadius: "8px" }}
        >
          {forgotSent ? (
            <div className="space-y-4 text-center">
              <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full" style={{ backgroundColor: "rgba(16,185,129,0.1)" }}>
                <Mail className="h-8 w-8 text-emerald-400" />
              </div>
              <DialogHeader className="items-center">
                <DialogTitle className="text-lg font-semibold text-slate-100">Email enviado</DialogTitle>
                <DialogDescription className="text-sm text-slate-500">
                  Enviamos um link de recuperação para{" "}
                  <strong className="text-slate-200">{forgotEmail}</strong>.
                  Verifique sua caixa de entrada e spam.
                </DialogDescription>
              </DialogHeader>
              <DialogFooter className="sm:justify-center">
                <Button
                  variant="outline"
                  onClick={() => setForgotOpen(false)}
                  className="border-[#1e293b] text-slate-100 hover:bg-white/5"
                >
                  Fechar
                </Button>
              </DialogFooter>
            </div>
          ) : (
            <form onSubmit={handleForgotPassword}>
              <DialogHeader>
                <DialogTitle className="text-lg font-semibold text-slate-100">Recuperar senha</DialogTitle>
                <DialogDescription className="text-sm text-slate-500">
                  Informe seu email para receber o link de recuperação.
                </DialogDescription>
              </DialogHeader>
              <div className="mt-4 space-y-2">
                <Label htmlFor="forgot-email" className="text-sm font-medium text-slate-300">Email</Label>
                <Input
                  id="forgot-email"
                  type="email"
                  placeholder="seu@email.com"
                  value={forgotEmail}
                  onChange={(e) => setForgotEmail(e.target.value)}
                  required
                  className="h-10 border-[#1e293b] bg-[#0f1d2e] text-slate-100 placeholder:text-slate-600 focus-visible:ring-emerald-500"
                />
              </div>
              <DialogFooter className="mt-6">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setForgotOpen(false)}
                  className="border-[#1e293b] text-slate-100 hover:bg-white/5"
                >
                  Cancelar
                </Button>
                <Button
                  type="submit"
                  disabled={forgotLoading}
                  className="bg-emerald-500 hover:bg-emerald-400 text-white"
                >
                  {forgotLoading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Enviando...
                    </>
                  ) : (
                    "Enviar link"
                  )}
                </Button>
              </DialogFooter>
            </form>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
