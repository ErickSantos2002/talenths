import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { supabase } from "@/integrations/supabase/client";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ClipboardList, Clock, Brain, ArrowRight } from "lucide-react";
import { toast } from "@/hooks/use-toast";

const steps = [
  { icon: ClipboardList, text: "12 cenários do dia a dia profissional" },
  { icon: Brain, text: "Escolha o que MAIS e MENOS representa você" },
  { icon: Clock, text: "Leva de 10 a 15 minutos" },
];

function formatCpf(value: string) {
  const digits = value.replace(/\D/g, "").slice(0, 11);
  if (digits.length <= 3) return digits;
  if (digits.length <= 6) return `${digits.slice(0, 3)}.${digits.slice(3)}`;
  if (digits.length <= 9) return `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6)}`;
  return `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6, 9)}-${digits.slice(9)}`;
}

export default function TestIntro() {
  const navigate = useNavigate();
  const { user, profile } = useAuth();
  const [cpfModalOpen, setCpfModalOpen] = useState(false);
  const [cpfValue, setCpfValue] = useState("");
  const [saving, setSaving] = useState(false);

  const handleStart = () => {
    if (!user) {
      navigate("/login");
      return;
    }
    if (!profile?.cpf) {
      setCpfModalOpen(true);
      return;
    }
    navigate("/teste/cenarios");
  };

  const handleSaveCpf = async () => {
    const digits = cpfValue.replace(/\D/g, "");
    if (digits.length !== 11) {
      toast({ title: "CPF inválido", description: "O CPF deve ter 11 dígitos.", variant: "destructive" });
      return;
    }
    setSaving(true);
    const { error } = await supabase
      .from("profiles")
      .update({ cpf: digits } as any)
      .eq("user_id", user!.id);
    setSaving(false);
    if (error) {
      toast({ title: "Erro ao salvar CPF", description: error.message, variant: "destructive" });
      return;
    }
    toast({ title: "CPF salvo com sucesso!" });
    setCpfModalOpen(false);
    navigate("/teste/cenarios");
  };

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <div className="container flex items-center justify-center py-8 sm:py-16 lg:py-24">
        <Card className="mx-auto w-full max-w-lg border-border bg-card shadow-card">
          <CardHeader className="text-center pb-2">
            <div className="mx-auto mb-3 sm:mb-4 flex h-12 w-12 sm:h-16 sm:w-16 items-center justify-center rounded-2xl bg-primary/10">
              <Brain className="h-6 w-6 sm:h-8 sm:w-8 text-primary" />
            </div>
            <CardTitle className="text-xl sm:text-2xl font-bold text-card-foreground">
              🎯 Teste de Perfil DNIA
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-5 sm:space-y-6 pt-2">
            <p className="text-center text-sm sm:text-base text-muted-foreground">
              Descubra seu estilo natural de agir, comunicar e tomar decisões em
              diferentes situações do dia a dia.
            </p>

            <div className="space-y-2.5 sm:space-y-3">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                Como funciona
              </h3>
              {steps.map((step) => (
                <div
                  key={step.text}
                  className="flex items-center gap-3 rounded-lg bg-muted/50 px-3 py-2.5 sm:px-4 sm:py-3"
                >
                  <step.icon className="h-5 w-5 shrink-0 text-primary" />
                  <span className="text-sm text-foreground">{step.text}</span>
                </div>
              ))}
            </div>

            <Button
              className="w-full text-base font-semibold h-11 sm:h-12"
              onClick={handleStart}
            >
              Começar Teste
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>
          </CardContent>
        </Card>
      </div>

      <Dialog open={cpfModalOpen} onOpenChange={setCpfModalOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Informe seu CPF</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground">
            Para iniciar o teste, precisamos do seu CPF cadastrado.
          </p>
          <div className="space-y-2">
            <Label htmlFor="cpf-input">CPF</Label>
            <Input
              id="cpf-input"
              placeholder="000.000.000-00"
              value={cpfValue}
              onChange={(e) => setCpfValue(formatCpf(e.target.value))}
              maxLength={14}
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCpfModalOpen(false)}>Cancelar</Button>
            <Button onClick={handleSaveCpf} disabled={saving}>
              {saving ? "Salvando..." : "Salvar e Continuar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
