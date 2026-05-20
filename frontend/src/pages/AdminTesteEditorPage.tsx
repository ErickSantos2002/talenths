import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { customTests } from "@/lib/api";
import type { CustomTestDetail, TestQuestion, TestOption } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import {
  ArrowLeft, Plus, Trash2, ChevronUp, ChevronDown,
  CheckSquare, Circle, ToggleLeft, List, SlidersHorizontal, FileText,
  Send, Archive
} from "lucide-react";
import { cn } from "@/lib/utils";

const QUESTION_TYPES = [
  { value: "single_choice", label: "Múltipla escolha (uma resposta)", icon: Circle },
  { value: "multiple_choice", label: "Múltipla escolha (várias respostas)", icon: CheckSquare },
  { value: "true_false", label: "Verdadeiro ou Falso", icon: ToggleLeft },
  { value: "checklist", label: "Checklist", icon: List },
  { value: "scale", label: "Escala numérica", icon: SlidersHorizontal },
  { value: "open_text", label: "Texto aberto", icon: FileText },
];

type QuestionForm = {
  question_type: string;
  text: string;
  explanation: string;
  points: string;
  scale_min: string;
  scale_max: string;
};

const emptyQ: QuestionForm = {
  question_type: "single_choice",
  text: "",
  explanation: "",
  points: "1",
  scale_min: "1",
  scale_max: "5",
};

export default function AdminTesteEditorPage() {
  const { testId } = useParams<{ testId: string }>();
  const navigate = useNavigate();
  const qc = useQueryClient();
  const { toast } = useToast();

  const [showAddQ, setShowAddQ] = useState(false);
  const [qForm, setQForm] = useState<QuestionForm>(emptyQ);
  const [expandedQ, setExpandedQ] = useState<string | null>(null);
  const [optionText, setOptionText] = useState<Record<string, string>>({});
  const [settings, setSettings] = useState<{
    max_attempts: string;
    time_limit_min: string;
    pass_score: string;
    is_public: boolean;
  } | null>(null);

  const { data: test, isLoading } = useQuery<CustomTestDetail>({
    queryKey: ["test-detail", testId],
    queryFn: () => customTests.get(testId!),
    enabled: !!testId,
    select: (data) => {
      // Sync settings state when test loads for the first time
      if (!settings) {
        setSettings({
          max_attempts: data.max_attempts !== null ? String(data.max_attempts) : "",
          time_limit_min: data.time_limit_min !== null ? String(data.time_limit_min) : "",
          pass_score: data.pass_score !== null ? String(data.pass_score) : "",
          is_public: data.is_public,
        });
      }
      return data;
    },
  });

  const isDraft = test?.status === "draft";

  const addQMut = useMutation({
    mutationFn: (data: object) => customTests.addQuestion(testId!, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["test-detail", testId] });
      setShowAddQ(false);
      setQForm(emptyQ);
      toast({ title: "Pergunta adicionada" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const deleteQMut = useMutation({
    mutationFn: (qid: string) => customTests.deleteQuestion(qid),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["test-detail", testId] }),
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const addOptMut = useMutation({
    mutationFn: ({ qid, text, isCorrect }: { qid: string; text: string; isCorrect: boolean }) =>
      customTests.addOption(qid, {
        text,
        is_correct: isCorrect,
        point_value: isCorrect ? 1 : 0,
        order_index: 0,
      }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["test-detail", testId] }),
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const toggleCorrectMut = useMutation({
    mutationFn: ({ optId, isCorrect }: { optId: string; isCorrect: boolean }) =>
      customTests.updateOption(optId, { is_correct: isCorrect }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["test-detail", testId] }),
  });

  const deleteOptMut = useMutation({
    mutationFn: (optId: string) => customTests.deleteOption(optId),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["test-detail", testId] }),
  });

  const publishMut = useMutation({
    mutationFn: () => customTests.publish(testId!),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["test-detail", testId] });
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      toast({ title: "Teste publicado com sucesso!" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const archiveMut = useMutation({
    mutationFn: () => customTests.archive(testId!),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["test-detail", testId] });
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      toast({ title: "Teste arquivado" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const saveSettingsMut = useMutation({
    mutationFn: (data: object) => customTests.update(testId!, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["test-detail", testId] });
      qc.invalidateQueries({ queryKey: ["admin-tests"] });
      toast({ title: "Configurações salvas" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const handleSaveSettings = () => {
    if (!settings) return;
    saveSettingsMut.mutate({
      max_attempts: settings.max_attempts !== "" ? parseInt(settings.max_attempts) : null,
      time_limit_min: settings.time_limit_min !== "" ? parseInt(settings.time_limit_min) : null,
      pass_score: settings.pass_score !== "" ? parseFloat(settings.pass_score) : null,
      is_public: settings.is_public,
    });
  };

  const moveQ = async (idx: number, dir: -1 | 1) => {
    if (!test) return;
    const qs = [...test.questions];
    const target = idx + dir;
    if (target < 0 || target >= qs.length) return;
    [qs[idx], qs[target]] = [qs[target], qs[idx]];
    await customTests.reorderQuestions(testId!, qs.map((q) => q.id));
    qc.invalidateQueries({ queryKey: ["test-detail", testId] });
  };

  const needsOptions = (type: string) =>
    ["single_choice", "multiple_choice", "true_false", "checklist", "scale"].includes(type);

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="p-6">
          <p className="text-muted-foreground">Carregando...</p>
        </div>
      </AdminLayout>
    );
  }

  if (!test) return null;

  return (
    <AdminLayout>
      <div className="p-6 max-w-3xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-start justify-between gap-4">
          <div className="flex items-center gap-3">
            <Button variant="ghost" size="icon" onClick={() => navigate("/admin/testes")}>
              <ArrowLeft className="h-4 w-4" />
            </Button>
            <div>
              <h1 className="text-xl font-semibold">{test.title}</h1>
              <p className="text-sm text-muted-foreground mt-0.5">
                {test.questions.length} perguntas · {test.total_points} pts
              </p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            {test.status === "draft" && (
              <Button onClick={() => publishMut.mutate()} disabled={publishMut.isPending}>
                <Send className="h-4 w-4 mr-2" /> Publicar
              </Button>
            )}
            {test.status === "published" && (
              <Button variant="outline" onClick={() => archiveMut.mutate()} disabled={archiveMut.isPending}>
                <Archive className="h-4 w-4 mr-2" /> Arquivar
              </Button>
            )}
          </div>
        </div>

        {!isDraft && (
          <div className="rounded-lg border border-yellow-200 bg-yellow-50 px-4 py-3 text-sm text-yellow-800 dark:border-yellow-800 dark:bg-yellow-950 dark:text-yellow-200">
            Testes publicados ou arquivados não podem ser editados. Para modificar, duplique o teste.
          </div>
        )}

        {/* Configurações */}
        {settings && (
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-semibold">Configurações</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs">Limite de tentativas</Label>
                  <Input
                    type="number" min="1" step="1"
                    placeholder="Ilimitado"
                    value={settings.max_attempts}
                    onChange={(e) => setSettings({ ...settings, max_attempts: e.target.value })}
                    disabled={!isDraft}
                    className="h-8 text-sm"
                  />
                  <p className="text-xs text-muted-foreground">Deixe em branco para ilimitado</p>
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs">Tempo limite (min)</Label>
                  <Input
                    type="number" min="1" step="1"
                    placeholder="Sem limite"
                    value={settings.time_limit_min}
                    onChange={(e) => setSettings({ ...settings, time_limit_min: e.target.value })}
                    disabled={!isDraft}
                    className="h-8 text-sm"
                  />
                  <p className="text-xs text-muted-foreground">Deixe em branco para sem limite</p>
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs">Nota mínima para aprovação</Label>
                  <Input
                    type="number" min="0" step="0.5"
                    placeholder="Sem corte"
                    value={settings.pass_score}
                    onChange={(e) => setSettings({ ...settings, pass_score: e.target.value })}
                    disabled={!isDraft}
                    className="h-8 text-sm"
                  />
                  <p className="text-xs text-muted-foreground">Deixe em branco sem corte de aprovação</p>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <Switch
                    checked={settings.is_public}
                    onCheckedChange={(v) => setSettings({ ...settings, is_public: v })}
                    disabled={!isDraft}
                  />
                  <div>
                    <p className="text-sm font-medium">Acesso público</p>
                    <p className="text-xs text-muted-foreground">
                      {settings.is_public
                        ? "Todos os colaboradores podem fazer o teste"
                        : "Apenas colaboradores atribuídos podem fazer o teste"}
                    </p>
                  </div>
                </div>
                {isDraft && (
                  <Button
                    size="sm" variant="outline"
                    onClick={handleSaveSettings}
                    disabled={saveSettingsMut.isPending}
                  >
                    Salvar
                  </Button>
                )}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Perguntas */}
        <div className="space-y-3">
          {test.questions.map((q, idx) => (
            <Card key={q.id} className={cn(!isDraft && "opacity-80")}>
              <CardHeader className="pb-2">
                <div className="flex items-start gap-2">
                  <div className="flex flex-col gap-0.5 pt-1">
                    <button
                      className="text-muted-foreground hover:text-foreground disabled:opacity-30"
                      onClick={() => moveQ(idx, -1)}
                      disabled={!isDraft || idx === 0}
                    >
                      <ChevronUp className="h-4 w-4" />
                    </button>
                    <button
                      className="text-muted-foreground hover:text-foreground disabled:opacity-30"
                      onClick={() => moveQ(idx, 1)}
                      disabled={!isDraft || idx === test.questions.length - 1}
                    >
                      <ChevronDown className="h-4 w-4" />
                    </button>
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-mono text-muted-foreground w-5">{idx + 1}.</span>
                      <span className="text-sm font-medium">{q.text}</span>
                    </div>
                    <div className="flex items-center gap-2 mt-1 ml-7">
                      <span className="text-xs text-muted-foreground">
                        {QUESTION_TYPES.find((t) => t.value === q.question_type)?.label}
                      </span>
                      <span className="text-xs text-muted-foreground">· {q.points} pt{q.points !== 1 ? "s" : ""}</span>
                    </div>
                  </div>
                  <div className="flex items-center gap-1">
                    <Button
                      variant="ghost" size="sm"
                      onClick={() => setExpandedQ(expandedQ === q.id ? null : q.id)}
                    >
                      {expandedQ === q.id ? "Fechar" : "Ver opções"}
                    </Button>
                    {isDraft && (
                      <Button
                        variant="ghost" size="icon"
                        onClick={() => deleteQMut.mutate(q.id)}
                      >
                        <Trash2 className="h-4 w-4 text-destructive" />
                      </Button>
                    )}
                  </div>
                </div>
              </CardHeader>

              {expandedQ === q.id && (
                <CardContent className="pt-0 ml-11 space-y-2">
                  {q.options.map((opt) => (
                    <div key={opt.id} className="flex items-center gap-2 text-sm">
                      {isDraft && needsOptions(q.question_type) && (
                        <input
                          type="checkbox"
                          checked={opt.is_correct}
                          onChange={(e) =>
                            toggleCorrectMut.mutate({ optId: opt.id, isCorrect: e.target.checked })
                          }
                          className="rounded"
                          title="Marcar como correta"
                        />
                      )}
                      <span className={cn("flex-1", opt.is_correct && "font-medium text-green-700 dark:text-green-400")}>
                        {opt.text}
                      </span>
                      {isDraft && (
                        <Button
                          variant="ghost" size="icon" className="h-6 w-6"
                          onClick={() => deleteOptMut.mutate(opt.id)}
                        >
                          <Trash2 className="h-3 w-3 text-destructive" />
                        </Button>
                      )}
                    </div>
                  ))}

                  {isDraft && needsOptions(q.question_type) && (
                    <div className="flex gap-2 mt-2">
                      <Input
                        placeholder="Nova opção..."
                        value={optionText[q.id] ?? ""}
                        onChange={(e) => setOptionText({ ...optionText, [q.id]: e.target.value })}
                        className="text-sm h-8"
                        onKeyDown={(e) => {
                          if (e.key === "Enter" && optionText[q.id]?.trim()) {
                            addOptMut.mutate({
                              qid: q.id,
                              text: optionText[q.id].trim(),
                              isCorrect: false,
                            });
                            setOptionText({ ...optionText, [q.id]: "" });
                          }
                        }}
                      />
                      <Button
                        size="sm" variant="outline"
                        onClick={() => {
                          if (optionText[q.id]?.trim()) {
                            addOptMut.mutate({
                              qid: q.id,
                              text: optionText[q.id].trim(),
                              isCorrect: false,
                            });
                            setOptionText({ ...optionText, [q.id]: "" });
                          }
                        }}
                      >
                        <Plus className="h-3 w-3" />
                      </Button>
                    </div>
                  )}

                  {q.question_type === "open_text" && (
                    <p className="text-xs text-muted-foreground italic">
                      Resposta textual — sem opções predefinidas.
                    </p>
                  )}
                  {q.question_type === "scale" && q.scale_min !== null && (
                    <p className="text-xs text-muted-foreground">
                      Escala de {q.scale_min} a {q.scale_max}
                    </p>
                  )}
                </CardContent>
              )}
            </Card>
          ))}
        </div>

        {isDraft && (
          <Button variant="outline" className="w-full" onClick={() => setShowAddQ(true)}>
            <Plus className="h-4 w-4 mr-2" /> Adicionar pergunta
          </Button>
        )}
      </div>

      {/* Dialog: Nova Pergunta */}
      <Dialog open={showAddQ} onOpenChange={setShowAddQ}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Nova Pergunta</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <Label>Tipo</Label>
              <Select
                value={qForm.question_type}
                onValueChange={(v) => setQForm({ ...qForm, question_type: v })}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {QUESTION_TYPES.map((t) => (
                    <SelectItem key={t.value} value={t.value}>{t.label}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Texto da pergunta *</Label>
              <Textarea
                value={qForm.text}
                onChange={(e) => setQForm({ ...qForm, text: e.target.value })}
                rows={3}
                placeholder="Digite a pergunta..."
              />
            </div>
            <div className="space-y-1.5">
              <Label>Pontos</Label>
              <Input
                type="number" min="0" step="0.5"
                value={qForm.points}
                onChange={(e) => setQForm({ ...qForm, points: e.target.value })}
                className="w-28"
              />
            </div>
            {qForm.question_type === "scale" && (
              <div className="flex gap-4">
                <div className="space-y-1.5">
                  <Label>Mínimo</Label>
                  <Input
                    type="number"
                    value={qForm.scale_min}
                    onChange={(e) => setQForm({ ...qForm, scale_min: e.target.value })}
                    className="w-20"
                  />
                </div>
                <div className="space-y-1.5">
                  <Label>Máximo</Label>
                  <Input
                    type="number"
                    value={qForm.scale_max}
                    onChange={(e) => setQForm({ ...qForm, scale_max: e.target.value })}
                    className="w-20"
                  />
                </div>
              </div>
            )}
            <div className="space-y-1.5">
              <Label>Explicação (opcional)</Label>
              <Input
                value={qForm.explanation}
                onChange={(e) => setQForm({ ...qForm, explanation: e.target.value })}
                placeholder="Exibida após a resposta"
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setShowAddQ(false); setQForm(emptyQ); }}>
              Cancelar
            </Button>
            <Button
              onClick={() =>
                addQMut.mutate({
                  question_type: qForm.question_type,
                  text: qForm.text.trim(),
                  explanation: qForm.explanation.trim() || undefined,
                  points: parseFloat(qForm.points) || 1,
                  scale_min: qForm.question_type === "scale" ? parseInt(qForm.scale_min) : undefined,
                  scale_max: qForm.question_type === "scale" ? parseInt(qForm.scale_max) : undefined,
                })
              }
              disabled={!qForm.text.trim() || addQMut.isPending}
            >
              Adicionar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
