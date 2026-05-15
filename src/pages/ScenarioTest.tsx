import { useState, useEffect, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { Navbar } from "@/components/Navbar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Label } from "@/components/ui/label";
import { ArrowLeft, ArrowRight, Loader2, CheckCircle2, RotateCcw } from "lucide-react";
import { toast } from "@/hooks/use-toast";

interface ScenarioBlock {
  id: string;
  block_number: number;
  scenario: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
}

interface Response {
  blockNumber: number;
  most: string;
  least: string;
}

const optionLabels = ["A", "B", "C", "D"] as const;
const optionKeys = ["option_a", "option_b", "option_c", "option_d"] as const;
const STORAGE_KEY = "talentia_test_responses";

export default function ScenarioTest() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const [scenarios, setScenarios] = useState<ScenarioBlock[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [responses, setResponses] = useState<Response[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitFailed, setSubmitFailed] = useState(false);

  useEffect(() => {
    const fetchScenarios = async () => {
      const { data, error } = await supabase
        .from("scenario_blocks")
        .select("id, block_number, scenario, option_a, option_b, option_c, option_d")
        .order("block_number");

      if (error) {
        toast({ title: "Erro ao carregar cenários", variant: "destructive" });
        return;
      }
      setScenarios(data || []);

      // Try to recover responses from localStorage
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        try {
          const parsed = JSON.parse(saved) as Response[];
          if (parsed.length === (data || []).length) {
            setResponses(parsed);
            setIsLoading(false);
            return;
          }
        } catch { /* ignore */ }
      }

      setResponses(
        (data || []).map((s) => ({ blockNumber: s.block_number, most: "", least: "" }))
      );
      setIsLoading(false);
    };
    fetchScenarios();
  }, []);

  const current = scenarios[currentIndex];
  const currentResponse = responses[currentIndex];
  const isComplete = currentResponse?.most && currentResponse?.least && currentResponse.most !== currentResponse.least;
  const isLastScenario = currentIndex === scenarios.length - 1;
  const progress = ((currentIndex + 1) / scenarios.length) * 100;

  const updateResponse = (field: "most" | "least", value: string) => {
    setResponses((prev) =>
      prev.map((r, i) => (i === currentIndex ? { ...r, [field]: value } : r))
    );
  };

  const handleNext = () => {
    if (!isComplete) {
      toast({
        title: "Selecione ambas as opções",
        description: "Escolha uma opção para MAIS e outra diferente para MENOS.",
        variant: "destructive",
      });
      return;
    }
    setCurrentIndex((prev) => prev + 1);
  };

  const handleFinish = useCallback(async () => {
    if (!isComplete) return;
    setIsSubmitting(true);
    setSubmitFailed(false);

    // Save to localStorage before submitting
    localStorage.setItem(STORAGE_KEY, JSON.stringify(responses));

    try {
      const { data, error } = await supabase.functions.invoke("calculate-results", {
        body: { responses },
      });

      if (error) throw error;

      // Clear localStorage on success
      localStorage.removeItem(STORAGE_KEY);
      toast({ title: "Teste concluído com sucesso! 🎉" });
      navigate("/resultado");
    } catch (err: any) {
      setSubmitFailed(true);
      toast({
        title: "Erro ao calcular resultado",
        description: "Suas respostas foram salvas. Tente novamente.",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  }, [isComplete, responses, navigate]);

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!current) return null;

  const options = optionKeys.map((key, i) => ({
    label: optionLabels[i],
    text: current[key],
  }));

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <div className="container max-w-2xl py-4 sm:py-8 lg:py-12">
        {/* Progress */}
        <div className="mb-4 sm:mb-6 space-y-2">
          <div className="flex items-center justify-between text-sm">
            <span className="font-medium text-foreground">
              Cenário {currentIndex + 1} de {scenarios.length}
            </span>
            <span className="text-muted-foreground">
              {Math.round(progress)}%
            </span>
          </div>
          <Progress value={progress} className="h-2" />
        </div>

        {/* Scenario Card */}
        <Card className="border-border bg-card shadow-card">
          <CardHeader className="px-4 sm:px-6">
            <CardTitle className="text-base sm:text-lg font-semibold leading-relaxed text-card-foreground">
              {current.scenario}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-5 sm:space-y-6 px-4 sm:px-6">
            {/* MAIS me representa */}
            <div className="space-y-2.5 sm:space-y-3">
              <h3 className="flex items-center gap-2 text-sm font-bold uppercase tracking-wide text-primary">
                <CheckCircle2 className="h-4 w-4" />
                MAIS me representa
              </h3>
              <RadioGroup
                value={currentResponse?.most || ""}
                onValueChange={(v) => updateResponse("most", v)}
                className="space-y-1.5 sm:space-y-2"
              >
                {options.map((opt) => (
                  <div
                    key={`most-${opt.label}`}
                    className={`flex items-center gap-2.5 sm:gap-3 rounded-lg border px-3 py-2.5 sm:px-4 sm:py-3 transition-colors ${
                      currentResponse?.most === opt.label
                        ? "border-primary bg-primary/5"
                        : "border-border hover:border-primary/30"
                    } ${
                      currentResponse?.least === opt.label
                        ? "opacity-40 pointer-events-none"
                        : ""
                    }`}
                  >
                    <RadioGroupItem
                      value={opt.label}
                      id={`most-${opt.label}`}
                      disabled={currentResponse?.least === opt.label}
                    />
                    <Label
                      htmlFor={`most-${opt.label}`}
                      className="flex-1 cursor-pointer text-sm text-foreground"
                    >
                      <span className="mr-1.5 sm:mr-2 font-bold text-primary">{opt.label}.</span>
                      {opt.text}
                    </Label>
                  </div>
                ))}
              </RadioGroup>
            </div>

            {/* MENOS me representa */}
            <div className="space-y-2.5 sm:space-y-3">
              <h3 className="flex items-center gap-2 text-sm font-bold uppercase tracking-wide text-destructive">
                <CheckCircle2 className="h-4 w-4" />
                MENOS me representa
              </h3>
              <RadioGroup
                value={currentResponse?.least || ""}
                onValueChange={(v) => updateResponse("least", v)}
                className="space-y-1.5 sm:space-y-2"
              >
                {options.map((opt) => (
                  <div
                    key={`least-${opt.label}`}
                    className={`flex items-center gap-2.5 sm:gap-3 rounded-lg border px-3 py-2.5 sm:px-4 sm:py-3 transition-colors ${
                      currentResponse?.least === opt.label
                        ? "border-destructive bg-destructive/5"
                        : "border-border hover:border-destructive/30"
                    } ${
                      currentResponse?.most === opt.label
                        ? "opacity-40 pointer-events-none"
                        : ""
                    }`}
                  >
                    <RadioGroupItem
                      value={opt.label}
                      id={`least-${opt.label}`}
                      disabled={currentResponse?.most === opt.label}
                    />
                    <Label
                      htmlFor={`least-${opt.label}`}
                      className="flex-1 cursor-pointer text-sm text-foreground"
                    >
                      <span className="mr-1.5 sm:mr-2 font-bold text-destructive">{opt.label}.</span>
                      {opt.text}
                    </Label>
                  </div>
                ))}
              </RadioGroup>
            </div>
          </CardContent>
        </Card>

        {/* Navigation */}
        <div className="mt-4 sm:mt-6 flex items-center justify-between">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setCurrentIndex((prev) => prev - 1)}
            disabled={currentIndex === 0}
            className="sm:size-default"
          >
            <ArrowLeft className="h-4 w-4 sm:mr-2" />
            <span className="hidden sm:inline">Voltar</span>
          </Button>

          {isLastScenario ? (
            <div className="flex gap-2">
              {submitFailed && (
                <Button
                  onClick={handleFinish}
                  variant="outline"
                  className="gap-2"
                  disabled={isSubmitting}
                >
                  <RotateCcw className="h-4 w-4" />
                  Tentar Novamente
                </Button>
              )}
              <Button
                onClick={handleFinish}
                disabled={!isComplete || isSubmitting}
                className="bg-primary text-primary-foreground hover:bg-primary/90"
              >
                {isSubmitting ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                ) : (
                  <CheckCircle2 className="mr-2 h-4 w-4" />
                )}
                Finalizar
              </Button>
            </div>
          ) : (
            <Button onClick={handleNext} disabled={!isComplete}>
              Próximo
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
