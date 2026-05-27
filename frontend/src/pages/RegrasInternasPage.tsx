import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { companies } from "@/lib/api";
import type { InternalRule } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Pencil, Check, X, Plus, Trash2, ScrollText } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

// ─── Hooks ───────────────────────────────────────────────────────────────────
function useReveal(ref: React.RefObject<Element>, threshold = 0.1) {
  const [visible, setVisible] = useState(false);
  useEffect(() => {
    const el = ref.current;
    if (!el || visible) return;
    const obs = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) { setVisible(true); obs.disconnect(); } },
      { threshold }
    );
    obs.observe(el);
    return () => obs.disconnect();
  }, [ref, visible, threshold]);
  return visible;
}

function useWordTypewriter(text: string, active: boolean, speed = 180) {
  const [count, setCount] = useState(0);
  const words = text.split(" ");
  useEffect(() => {
    if (!active || !text) return;
    setCount(0);
    let i = 0;
    const id = setInterval(() => {
      i++;
      setCount(i);
      if (i >= words.length) clearInterval(id);
    }, speed);
    return () => clearInterval(id);
  }, [active, text, speed]);
  return { displayed: words.slice(0, count).join(" "), done: count >= words.length };
}

// ─── SectionTag sticky ───────────────────────────────────────────────────────
function SectionTag({ label }: { label: string }) {
  return (
    <div className="sticky top-0 z-10 flex items-center gap-2 border-b border-border bg-background/90 px-8 py-2 text-xs font-medium text-muted-foreground backdrop-blur-md md:px-14">
      <span className="h-1.5 w-1.5 rounded-full bg-primary" />
      {label}
    </div>
  );
}

// ─── Hero ─────────────────────────────────────────────────────────────────────
function HeroSection() {
  const [eyebrowVisible, setEyebrowVisible] = useState(false);
  const [titleVisible, setTitleVisible] = useState(false);
  const { displayed, done } = useWordTypewriter("Regras Internas", titleVisible, 200);

  useEffect(() => {
    const t1 = setTimeout(() => setEyebrowVisible(true), 200);
    const t2 = setTimeout(() => setTitleVisible(true), 500);
    return () => { clearTimeout(t1); clearTimeout(t2); };
  }, []);

  return (
    <section className="relative flex min-h-[60vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center">
      <div className="pointer-events-none absolute -right-24 -top-32 h-[400px] w-[400px] rounded-full blur-[100px]" style={{ background: "rgba(16,185,129,0.09)" }} />
      <div className="pointer-events-none absolute -bottom-24 -left-16 h-[320px] w-[320px] rounded-full blur-[80px]" style={{ background: "rgba(16,185,129,0.05)" }} />

      <div className="relative z-10 mx-auto w-full max-w-4xl px-6 sm:px-10 md:px-16">
        <div
          className="mb-6 flex items-center justify-center gap-2.5 text-primary transition-all duration-500"
          style={{ opacity: eyebrowVisible ? 1 : 0, transform: eyebrowVisible ? "translateY(0)" : "translateY(8px)" }}
        >
          <div className="h-px w-6 bg-primary" />
          <span className="text-xs font-semibold uppercase tracking-widest">Health Safety Tech</span>
          <div className="h-px w-6 bg-primary" />
        </div>

        <h1 className="break-words text-4xl font-extrabold leading-tight tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl">
          {titleVisible ? displayed : <span className="opacity-0">Regras Internas</span>}
          {titleVisible && !done && (
            <span className="ml-1 inline-block w-0.5 animate-pulse bg-primary align-middle" style={{ height: "0.85em" }} />
          )}
        </h1>

        <div className="mt-14 flex animate-bounce items-center justify-center gap-2 text-xs text-muted-foreground/40">
          <span>↓</span>
          <span>Role para ver as normas e diretrizes</span>
        </div>
      </div>
    </section>
  );
}

// ─── RuleSection ─────────────────────────────────────────────────────────────
function RuleSection({
  rule, index, isAdmin, onEdit,
}: {
  rule: InternalRule; index: number; isAdmin: boolean; onEdit: () => void;
}) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);
  const paragraphs = (rule.content ?? "").split("\n").filter(Boolean);

  return (
    <section ref={ref} className="relative flex min-h-[60vh] w-full flex-col justify-center border-b border-border px-8 py-16 md:px-16 lg:px-24">
      {isAdmin && (
        <div className="absolute right-6 top-4 z-20">
          <button
            onClick={onEdit}
            className="flex items-center gap-1.5 rounded-lg border border-border bg-background/80 px-3 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-sm transition-colors hover:text-foreground"
          >
            <Pencil className="h-3 w-3" /> Editar
          </button>
        </div>
      )}

      <div className="mx-auto w-full max-w-4xl">
        {/* Número + título */}
        <div
          className="mb-8 flex items-center gap-4 transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(12px)" }}
        >
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-bold text-primary">
            {index + 1}
          </span>
          <h2 className="text-2xl font-bold text-foreground md:text-3xl">{rule.title}</h2>
        </div>

        {/* Conteúdo */}
        <div className="space-y-4 pl-14">
          {paragraphs.map((p, pi) => (
            <p
              key={pi}
              className="text-base leading-relaxed text-muted-foreground text-justify transition-all duration-700"
              style={{
                opacity: visible ? 1 : 0,
                transform: visible ? "translateY(0)" : "translateY(12px)",
                transitionDelay: visible ? `${150 + pi * 100}ms` : "0ms",
              }}
            >
              {p}
            </p>
          ))}
        </div>
      </div>
    </section>
  );
}

// ─── Edit Form ────────────────────────────────────────────────────────────────
function EditForm({
  rules, setRules, onSave, onCancel, isSaving,
}: {
  rules: InternalRule[];
  setRules: React.Dispatch<React.SetStateAction<InternalRule[]>>;
  onSave: () => void;
  onCancel: () => void;
  isSaving: boolean;
}) {
  const addRule = () => setRules((r) => [...r, { title: "", content: "" }]);
  const removeRule = (i: number) => setRules((r) => r.filter((_, idx) => idx !== i));
  const updateRule = (i: number, field: keyof InternalRule, val: string) =>
    setRules((r) => r.map((item, idx) => (idx === i ? { ...item, [field]: val } : item)));

  return (
    <div className="min-h-screen pb-20">
      {/* Sticky header */}
      <div className="sticky top-0 z-20 flex items-center justify-between border-b border-border bg-background/95 px-6 py-4 backdrop-blur-sm md:px-10">
        <div>
          <p className="text-[10px] font-semibold uppercase tracking-widest text-primary">Regras Internas</p>
          <h2 className="text-base font-semibold text-foreground">Editar regras</h2>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={onCancel} disabled={isSaving}>
            <X className="h-4 w-4 mr-1" /> Cancelar
          </Button>
          <Button size="sm" onClick={onSave} disabled={isSaving}>
            <Check className="h-4 w-4 mr-1" /> {isSaving ? "Salvando..." : "Salvar"}
          </Button>
        </div>
      </div>

      {/* Body */}
      <div className="space-y-4 px-6 pt-8 md:px-10">
        {rules.length === 0 && (
          <p className="py-8 text-center text-sm italic text-muted-foreground">
            Nenhuma regra adicionada. Clique em "Adicionar seção".
          </p>
        )}
        {rules.map((rule, i) => (
          <Card key={i}>
            <CardContent className="space-y-3 p-4">
              <div className="flex items-center gap-2">
                <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-primary/10 text-xs font-bold text-primary">
                  {i + 1}
                </span>
                <Input
                  placeholder="Título da seção (ex: Horário de Trabalho)"
                  value={rule.title}
                  onChange={(e) => updateRule(i, "title", e.target.value)}
                  className="flex-1"
                />
                <button
                  onClick={() => removeRule(i)}
                  className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </button>
              </div>
              <Textarea
                rows={5}
                placeholder="Descreva as regras desta seção... (use Enter para separar parágrafos)"
                value={rule.content}
                onChange={(e) => updateRule(i, "content", e.target.value)}
              />
            </CardContent>
          </Card>
        ))}
        <Button variant="outline" className="w-full" onClick={addRule}>
          <Plus className="h-4 w-4 mr-2" /> Adicionar seção
        </Button>
      </div>
    </div>
  );
}

// ─── Page ─────────────────────────────────────────────────────────────────────
export default function RegrasInternasPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");

  const { data, isLoading } = useQuery({
    queryKey: ["internal-rules"],
    queryFn: companies.getInternalRules,
  });

  const [editing, setEditing] = useState(false);
  const [rules, setRules] = useState<InternalRule[]>([]);

  const startEdit = (fromIndex?: number) => {
    const all = data?.rules ?? [];
    setRules(all);
    setEditing(true);
    if (fromIndex !== undefined) {
      setTimeout(() => {
        const el = document.getElementById(`rule-edit-${fromIndex}`);
        el?.scrollIntoView({ behavior: "smooth" });
      }, 100);
    }
  };

  const mut = useMutation({
    mutationFn: () => companies.updateInternalRules(rules),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["internal-rules"] });
      setEditing(false);
      toast({ title: "Regras atualizadas" });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="-m-6 lg:-m-8">
          <div className="flex min-h-[60vh] items-center justify-center">
            <Skeleton className="h-16 w-64" />
          </div>
        </div>
      </AdminLayout>
    );
  }

  const currentRules = data?.rules ?? [];

  if (editing) {
    return (
      <AdminLayout>
        <div className="-m-6 lg:-m-8">
          <EditForm
            rules={rules}
            setRules={setRules}
            onSave={() => mut.mutate()}
            onCancel={() => setEditing(false)}
            isSaving={mut.isPending}
          />
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="-m-6 overflow-x-hidden lg:-m-8">
        <HeroSection />

        {isAdmin && (
          <div className="fixed bottom-6 right-6 z-50">
            <Button size="sm" onClick={() => startEdit()} className="shadow-lg">
              <Pencil className="h-4 w-4 mr-2" /> Editar regras
            </Button>
          </div>
        )}

        {currentRules.length === 0 ? (
          <div className="flex min-h-[40vh] flex-col items-center justify-center gap-4 border-t border-border">
            <ScrollText className="h-10 w-10 text-muted-foreground/40" />
            <p className="text-sm text-muted-foreground">Nenhuma regra cadastrada ainda.</p>
            {isAdmin && (
              <Button variant="outline" size="sm" onClick={() => startEdit()}>
                <Plus className="h-4 w-4 mr-2" /> Adicionar regras
              </Button>
            )}
          </div>
        ) : (
          currentRules.map((rule, i) => (
            <div key={i}>
              <SectionTag label={`${i + 1}. ${rule.title}`} />
              <RuleSection
                rule={rule}
                index={i}
                isAdmin={isAdmin}
                onEdit={() => startEdit(i)}
              />
            </div>
          ))
        )}
      </div>
    </AdminLayout>
  );
}
