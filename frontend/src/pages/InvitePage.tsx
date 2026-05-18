import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { invitations as invitationsApi, auth as authApi, setToken } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Brain, Loader2, CheckCircle, RotateCcw } from "lucide-react";
import { toast } from "@/hooks/use-toast";

export default function InvitePage() {
  const { token } = useParams<{ token: string }>();
  const navigate = useNavigate();
  const { signIn } = useAuth();
  const [invitation, setInvitation] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [phone, setPhone] = useState("");
  const [lastError, setLastError] = useState<string | null>(null);

  useEffect(() => {
    if (!token) return;
    invitationsApi.byToken(token)
      .then((data) => setInvitation(data))
      .catch(() => toast({ title: "Convite inválido ou expirado", variant: "destructive" }))
      .finally(() => setLoading(false));
  }, [token]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim() || !email.trim() || !password.trim() || !phone.trim()) {
      toast({ title: "Preencha todos os campos", variant: "destructive" });
      return;
    }
    if (password.length < 6) {
      toast({ title: "A senha deve ter pelo menos 6 caracteres", variant: "destructive" });
      return;
    }
    const phoneDigits = phone.replace(/\D/g, "");
    if (phoneDigits.length !== 11) {
      toast({ title: "Telefone deve ter 11 dígitos", variant: "destructive" });
      return;
    }

    setSubmitting(true);
    setLastError(null);

    try {
      const res = await authApi.registerInvite({
        token: token!,
        name: name.trim(),
        email: email.trim(),
        password,
        phone: phoneDigits,
      });
      setToken(res.access_token);
      toast({ title: "Conta criada com sucesso!" });
      navigate("/teste");
    } catch (err) {
      const msg = (err as Error).message;
      if (msg.includes("já cadastrado") || msg.includes("conflict")) {
        toast({ title: "Email já cadastrado", description: "Faça login para continuar.", variant: "destructive" });
        setLastError("email_exists");
      } else if (msg.includes("inválido") || msg.includes("expirado")) {
        toast({ title: "Convite inválido ou expirado", variant: "destructive" });
        setLastError("exhausted");
      } else {
        toast({ title: "Erro temporário", description: "Tente novamente.", variant: "destructive" });
        setLastError("temporary");
      }
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!invitation) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background p-4">
        <Card className="w-full max-w-md">
          <CardContent className="py-12 text-center">
            <p className="text-lg font-semibold text-foreground">Convite inválido</p>
            <p className="mt-2 text-sm text-muted-foreground">Este convite não existe, expirou ou atingiu o limite de usos.</p>
            <Button className="mt-6" onClick={() => navigate("/login")}>Ir para Login</Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10">
            <Brain className="h-6 w-6 text-primary" />
          </div>
          <CardTitle className="text-xl">Bem-vindo ao TalentHS</CardTitle>
          <p className="text-sm text-muted-foreground">
            Você foi convidado por <strong>{invitation.company_name ?? "uma empresa"}</strong>
          </p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label>Nome completo</Label>
              <Input value={name} onChange={(e) => setName(e.target.value)} placeholder="Seu nome" />
            </div>
            <div className="space-y-2">
              <Label>Email</Label>
              <Input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="seu@email.com" type="email" />
            </div>
            <div className="space-y-2">
              <Label>Senha</Label>
              <Input value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Mínimo 6 caracteres" type="password" />
            </div>
            <div className="space-y-2">
              <Label>Telefone</Label>
              <Input
                value={phone}
                onChange={(e) => {
                  const cleaned = e.target.value.replace(/\D/g, "").slice(0, 11);
                  let formatted = cleaned;
                  if (cleaned.length > 2) formatted = `(${cleaned.slice(0, 2)}) ${cleaned.slice(2, 7)}-${cleaned.slice(7)}`;
                  setPhone(formatted);
                }}
                placeholder="(11) 99999-9999"
                maxLength={15}
              />
            </div>

            {lastError === "email_exists" && (
              <Button type="button" variant="outline" className="w-full" onClick={() => navigate("/login")}>
                Ir para Login
              </Button>
            )}

            <Button type="submit" className="w-full" disabled={submitting}>
              {submitting && <Loader2 className="h-4 w-4 animate-spin mr-2" />}
              {lastError === "temporary" ? (
                <><RotateCcw className="h-4 w-4 mr-2" />Tentar Novamente</>
              ) : "Criar Conta"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
