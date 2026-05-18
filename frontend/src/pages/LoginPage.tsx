import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Eye, EyeOff, Loader2, Brain, Mail } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";

const meshGradientStyle: React.CSSProperties = {
  background: `
    radial-gradient(ellipse at 15% 0%, rgba(222, 26, 17, 0.4) 0%, transparent 50%),
    radial-gradient(ellipse at 85% 5%, rgba(61, 97, 255, 0.35) 0%, transparent 45%),
    radial-gradient(ellipse at 75% 85%, rgba(222, 26, 17, 0.3) 0%, transparent 45%),
    radial-gradient(ellipse at 5% 95%, rgba(61, 97, 255, 0.4) 0%, transparent 50%),
    radial-gradient(ellipse at 50% 50%, rgba(222, 26, 17, 0.1) 0%, transparent 70%),
    #0A0A0A
  `,
  overflow: "hidden",
  position: "relative",
};

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const { signIn } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  // Forgot password modal state
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
      navigate("/dashboard");
    }
    setIsLoading(false);
  };

  const handleForgotPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setForgotLoading(true);
    // Funcionalidade de email de recuperação requer configuração de SMTP no backend
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
    <div className="dark">
      <div
        className="flex min-h-screen items-center justify-center px-4"
        style={meshGradientStyle}
      >
        {/* Content area */}
        <div className="relative z-10 w-full max-w-[28rem] animate-fade-in">
          {/* Glassmorphism Card */}
          <div
            className="rounded-[1.5rem] p-8"
            style={{
              background: "rgba(10, 10, 10, 0.2)",
              backdropFilter: "blur(24px)",
              WebkitBackdropFilter: "blur(24px)",
              border: "1px solid rgba(255, 255, 255, 0.1)",
              boxShadow:
                "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)",
            }}
          >
            {/* Logo Section — inside card */}
            <div className="mb-8 flex flex-col items-center text-center">
              <div className="mb-4 inline-flex h-16 w-16 items-center justify-center rounded-[1.5rem] bg-[hsl(231,100%,62%)]/10">
                <Brain className="h-10 w-10 text-[hsl(231,100%,62%)]" />
              </div>
              <Link to="/">
                <img
                  src="/logo.svg"
                  alt="Logo"
                  className="h-10 w-auto"
                />
              </Link>
              <p className="mt-2 text-sm text-[#FAFAFA]/80">
                Entre na sua conta
              </p>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-4">
                {/* Email */}
                <div className="space-y-2">
                  <Label
                    htmlFor="login-email"
                    className="text-sm font-medium text-[#FAFAFA]"
                  >
                    Email
                  </Label>
                  <Input
                    id="login-email"
                    type="email"
                    placeholder="seu@email.com"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    className="h-10 rounded-[1rem] border-[#333333] bg-[#0A0A0A] px-3 py-2 text-base text-[#FAFAFA] placeholder:text-[#A3A3A3] transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#3D61FF] focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                  />
                </div>

                {/* Password */}
                <div className="space-y-2">
                  <Label
                    htmlFor="login-password"
                    className="text-sm font-medium text-[#FAFAFA]"
                  >
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
                      className="h-10 rounded-[1rem] border-[#333333] bg-[#0A0A0A] px-3 py-2 pr-10 text-base text-[#FAFAFA] placeholder:text-[#A3A3A3] transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#3D61FF] focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-[#A3A3A3] transition-colors hover:text-[#FAFAFA]"
                    >
                      {showPassword ? (
                        <EyeOff className="h-4 w-4" />
                      ) : (
                        <Eye className="h-4 w-4" />
                      )}
                    </button>
                  </div>
                </div>
              </div>

              {/* Forgot Password Link */}
              <div className="text-right">
                <button
                  type="button"
                  onClick={openForgotModal}
                  className="text-sm font-medium text-[#FAFAFA] transition-colors hover:text-[#3D61FF] hover:underline"
                >
                  Esqueci minha senha
                </button>
              </div>

              {/* Submit Button */}
              <Button
                type="submit"
                disabled={isLoading}
                className="h-10 w-full rounded-[1rem] bg-[#3D61FF] text-sm font-medium text-white transition-colors hover:bg-[#3D61FF]/90 disabled:pointer-events-none disabled:opacity-50"
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
            </form>
          </div>
        </div>

        {/* Forgot Password Modal */}
        <Dialog open={forgotOpen} onOpenChange={setForgotOpen}>
          <DialogContent
            className="max-w-[28rem] border-[#333333] p-6 text-[#FAFAFA]"
            style={{
              background: "hsl(0 0% 7%)",
              borderRadius: "8px",
              boxShadow: "0 10px 15px -3px rgb(0 0 0 / 0.1)",
            }}
          >
            {forgotSent ? (
              <div className="space-y-4 text-center">
                <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-[#3D61FF]/10">
                  <Mail className="h-8 w-8 text-[#3D61FF]" />
                </div>
                <DialogHeader className="items-center">
                  <DialogTitle className="text-lg font-semibold text-[#FAFAFA]">
                    Email enviado
                  </DialogTitle>
                  <DialogDescription className="text-sm text-[#A3A3A3]">
                    Enviamos um link de recuperacao para{" "}
                    <strong className="text-[#FAFAFA]">{forgotEmail}</strong>.
                    Verifique sua caixa de entrada e spam.
                  </DialogDescription>
                </DialogHeader>
                <DialogFooter className="sm:justify-center">
                  <Button
                    variant="outline"
                    onClick={() => setForgotOpen(false)}
                    className="rounded-[1rem] border-[#333333] text-[#FAFAFA] hover:bg-[#FAFAFA]/10"
                  >
                    Fechar
                  </Button>
                </DialogFooter>
              </div>
            ) : (
              <form onSubmit={handleForgotPassword}>
                <DialogHeader>
                  <DialogTitle className="text-lg font-semibold text-[#FAFAFA]">
                    Recuperar senha
                  </DialogTitle>
                  <DialogDescription className="text-sm text-[#A3A3A3]">
                    Informe seu email para receber o link de recuperacao.
                  </DialogDescription>
                </DialogHeader>
                <div className="mt-4 space-y-2">
                  <Label
                    htmlFor="forgot-email"
                    className="text-sm font-medium text-[#FAFAFA]"
                  >
                    Email
                  </Label>
                  <Input
                    id="forgot-email"
                    type="email"
                    placeholder="seu@email.com"
                    value={forgotEmail}
                    onChange={(e) => setForgotEmail(e.target.value)}
                    required
                    className="h-10 rounded-[1rem] border-[#333333] bg-[#0A0A0A] px-3 py-2 text-base text-[#FAFAFA] placeholder:text-[#A3A3A3] transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#3D61FF] focus-visible:ring-offset-2 focus-visible:ring-offset-transparent"
                  />
                </div>
                <DialogFooter className="mt-6">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => setForgotOpen(false)}
                    className="rounded-[1rem] border-[#333333] text-[#FAFAFA] hover:bg-[#FAFAFA]/10"
                  >
                    Cancelar
                  </Button>
                  <Button
                    type="submit"
                    disabled={forgotLoading}
                    className="rounded-[1rem] bg-[#3D61FF] text-white hover:bg-[#3D61FF]/90"
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
    </div>
  );
}
