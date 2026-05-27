import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { companies } from "@/lib/api";
import type { PresentationValue } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import {
  Check, X, Plus, Trash2, Pencil,
  ShieldCheck, Lightbulb, Heart, Zap,
} from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

// ─── Hook: dispara true uma vez quando o elemento entra na viewport ───────────
function useReveal(ref: React.RefObject<Element>, threshold = 0.15) {
  const [visible, setVisible] = useState(false);
  useEffect(() => {
    const el = ref.current;
    if (!el || visible) return;
    const obs = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) { setVisible(true); obs.disconnect(); }
      },
      { threshold }
    );
    obs.observe(el);
    return () => obs.disconnect();
  }, [ref, visible, threshold]);
  return visible;
}

// ─── Hook: typewriter char-by-char ───────────────────────────────────────────
function useTypewriter(text: string, active: boolean, speed = 22) {
  const [displayed, setDisplayed] = useState("");
  useEffect(() => {
    if (!active || !text) return;
    setDisplayed("");
    let i = 0;
    const id = setInterval(() => {
      i++;
      setDisplayed(text.substring(0, i));
      if (i >= text.length) clearInterval(id);
    }, speed);
    return () => clearInterval(id);
  }, [active, text, speed]);
  return displayed;
}

// ─── Hook: typewriter word-by-word ───────────────────────────────────────────
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
  return { displayed: words.slice(0, count).join(" "), done: count >= words.length, words };
}

// ─── SectionTag sticky ────────────────────────────────────────────────────────
function SectionTag({ label }: { label: string }) {
  return (
    <div className="sticky top-0 z-10 flex items-center gap-2 border-b border-border bg-background/90 px-8 py-2 text-xs font-medium text-muted-foreground backdrop-blur-md md:px-14">
      <span className="h-1.5 w-1.5 rounded-full bg-primary" />
      {label}
    </div>
  );
}

// ─── Hero ─────────────────────────────────────────────────────────────────────
function HeroSection({ name, cnpj }: { name: string; cnpj?: string | null }) {
  const [eyebrowVisible, setEyebrowVisible] = useState(false);
  const [nameActive, setNameActive] = useState(false);
  const [cnpjVisible, setCnpjVisible] = useState(false);
  const { displayed, done } = useWordTypewriter(name, nameActive, 200);

  useEffect(() => {
    const t1 = setTimeout(() => setEyebrowVisible(true), 200);
    const t2 = setTimeout(() => setNameActive(true), 500);
    const t3 = setTimeout(() => setCnpjVisible(true), 500 + name.split(" ").length * 200 + 400);
    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, [name]);

  return (
    <section className="relative flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center">
      {/* Blobs */}
      <div className="pointer-events-none absolute -right-24 -top-32 h-[400px] w-[400px] rounded-full blur-[100px]" style={{ background: "rgba(16,185,129,0.09)" }} />
      <div className="pointer-events-none absolute -bottom-24 -left-16 h-[320px] w-[320px] rounded-full blur-[80px]" style={{ background: "rgba(16,185,129,0.05)" }} />

      <div className="relative z-10 mx-auto w-full max-w-4xl px-6 sm:px-10 md:px-16">
        {/* Eyebrow */}
        <div
          className="mb-6 flex items-center justify-center gap-2.5 text-primary transition-all duration-500"
          style={{ opacity: eyebrowVisible ? 1 : 0, transform: eyebrowVisible ? "translateY(0)" : "translateY(8px)" }}
        >
          <div className="h-px w-6 bg-primary" />
          <span className="text-xs font-semibold uppercase tracking-widest">Bem-vindo à empresa</span>
          <div className="h-px w-6 bg-primary" />
        </div>

        {/* Nome word-by-word */}
        <h1 className="break-words text-4xl font-extrabold leading-tight tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl">
          {nameActive ? displayed : <span className="opacity-0">{name}</span>}
          {nameActive && !done && (
            <span className="ml-1 inline-block w-0.5 animate-pulse bg-primary align-middle" style={{ height: "0.85em" }} />
          )}
        </h1>

        {/* CNPJ */}
        {cnpj && (
          <p
            className="mt-5 text-sm text-muted-foreground transition-all duration-700"
            style={{ opacity: cnpjVisible ? 1 : 0, transform: cnpjVisible ? "translateY(0)" : "translateY(6px)" }}
          >
            CNPJ: {cnpj}
          </p>
        )}

        {/* Scroll hint */}
        <div className="mt-14 flex animate-bounce items-center justify-center gap-2 text-xs text-muted-foreground/40">
          <span>↓</span>
          <span>Role para conhecer nossa empresa</span>
        </div>
      </div>
    </section>
  );
}

// ─── TypewriterSection ────────────────────────────────────────────────────────
function TypewriterSection({
  sectionId,
  label,
  text,
  speed = 20,
  large = true,
}: {
  sectionId: string;
  label: string;
  text: string;
  speed?: number;
  large?: boolean;
}) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);
  const displayed = useTypewriter(text, visible, speed);
  const done = displayed.length >= text.length;

  return (
    <section
      id={sectionId}
      ref={ref}
      className="flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center"
    >
      <div className="mx-auto w-full max-w-5xl px-8 md:px-16">
        <p
          className="mb-6 text-xs font-bold uppercase tracking-widest text-primary transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          {label}
        </p>

        <div
          className={
            large
              ? "text-justify text-2xl font-bold leading-relaxed text-foreground md:text-3xl lg:text-4xl"
              : "text-justify text-lg font-normal leading-loose text-muted-foreground md:text-xl lg:text-2xl"
          }
        >
          {visible ? displayed : <span className="opacity-0">{text}</span>}
          {visible && !done && (
            <span className="ml-1 inline-block w-0.5 animate-pulse bg-primary align-middle" style={{ height: "0.85em" }} />
          )}
        </div>
      </div>
    </section>
  );
}

// ─── Valores ──────────────────────────────────────────────────────────────────
const VALUE_ICONS = [
  <ShieldCheck className="h-5 w-5" />,
  <Lightbulb className="h-5 w-5" />,
  <Heart className="h-5 w-5" />,
  <Zap className="h-5 w-5" />,
];

function ValueCard({
  title,
  description,
  index,
  parentVisible,
}: {
  title: string;
  description: string;
  index: number;
  parentVisible: boolean;
}) {
  const [show, setShow] = useState(false);
  useEffect(() => {
    if (!parentVisible) return;
    const t = setTimeout(() => setShow(true), index * 120);
    return () => clearTimeout(t);
  }, [parentVisible, index]);

  return (
    <div
      className="flex flex-col items-center gap-3 rounded-xl border border-border bg-card p-5 text-center transition-all duration-500"
      style={{ opacity: show ? 1 : 0, transform: show ? "translateY(0)" : "translateY(16px)" }}
    >
      <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
        {VALUE_ICONS[index % VALUE_ICONS.length]}
      </div>
      <div>
        <p className="text-sm font-semibold text-foreground">{title}</p>
        <p className="mt-1 text-xs leading-relaxed text-muted-foreground">{description}</p>
      </div>
    </div>
  );
}

function ValoresSection({ values }: { values: PresentationValue[] }) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);

  return (
    <section
      id="valores"
      ref={ref}
      className="flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center"
    >
      <div className="mx-auto w-full max-w-5xl px-8 md:px-14">
        <p
          className="mb-10 text-xs font-bold uppercase tracking-widest text-primary transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          Nossos Valores
        </p>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          {values.map((v, i) => (
            <ValueCard key={i} title={v.title} description={v.description} index={i} parentVisible={visible} />
          ))}
        </div>
      </div>
    </section>
  );
}

// ─── ViewMode ─────────────────────────────────────────────────────────────────
type Presentation = NonNullable<Awaited<ReturnType<typeof companies.getPresentation>>>;

function ViewMode({ presentation }: { presentation: Presentation }) {
  const hasMission = !!presentation.presentation_mission;
  const hasVision = !!presentation.presentation_vision;
  const hasHistory = !!presentation.presentation_history;
  const hasValues = (presentation.presentation_values?.length ?? 0) > 0;
  const isEmpty = !hasMission && !hasVision && !hasValues && !hasHistory;

  return (
    <div className="min-h-screen overflow-x-hidden bg-background">
      <HeroSection name={presentation.name} cnpj={presentation.cnpj} />

      {hasMission && (
        <>
          <SectionTag label="Missão" />
          <TypewriterSection sectionId="missao" label="Nossa Missão" text={presentation.presentation_mission!} />
        </>
      )}

      {hasVision && (
        <>
          <SectionTag label="Visão" />
          <TypewriterSection sectionId="visao" label="Nossa Visão" text={presentation.presentation_vision!} />
        </>
      )}

      {hasValues && (
        <>
          <SectionTag label="Valores" />
          <ValoresSection values={presentation.presentation_values!} />
        </>
      )}

      {hasHistory && (
        <>
          <SectionTag label="Nossa História" />
          <TypewriterSection
            sectionId="historia"
            label="Nossa História"
            text={presentation.presentation_history!}
            speed={20}
            large={false}
          />
        </>
      )}

      {isEmpty && (
        <div className="flex min-h-[60vh] items-center justify-center text-sm text-muted-foreground">
          Nenhuma apresentação configurada ainda.
        </div>
      )}
    </div>
  );
}

// ─── EditForm ─────────────────────────────────────────────────────────────────
function EditForm({
  mission, setMission,
  vision, setVision,
  history, setHistory,
  coverUrl, setCoverUrl,
  values, addValue, removeValue, updateValue,
  onCancel, onSave, isSaving,
}: {
  mission: string; setMission: (v: string) => void;
  vision: string; setVision: (v: string) => void;
  history: string; setHistory: (v: string) => void;
  coverUrl: string; setCoverUrl: (v: string) => void;
  values: PresentationValue[];
  addValue: () => void;
  removeValue: (i: number) => void;
  updateValue: (i: number, field: keyof PresentationValue, val: string) => void;
  onCancel: () => void;
  onSave: () => void;
  isSaving: boolean;
}) {
  return (
    <div className="min-h-screen pb-20">
      {/* Sticky header */}
      <div className="sticky top-0 z-20 flex items-center justify-between border-b border-border bg-background/95 px-6 py-4 backdrop-blur-sm md:px-10">
        <div>
          <p className="text-[10px] font-semibold uppercase tracking-widest text-primary">Apresentação</p>
          <h2 className="text-base font-semibold text-foreground">Editar conteúdo</h2>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={onCancel} disabled={isSaving}>
            <X className="mr-1.5 h-3.5 w-3.5" /> Cancelar
          </Button>
          <Button size="sm" onClick={onSave} disabled={isSaving}>
            <Check className="mr-1.5 h-3.5 w-3.5" /> {isSaving ? "Salvando…" : "Salvar"}
          </Button>
        </div>
      </div>

      {/* Body */}
      <div className="space-y-8 px-6 pt-8 md:px-10">

        {/* Missão */}
        <div className="space-y-2">
          <label className="block text-[10px] font-bold uppercase tracking-widest text-primary">
            Missão
          </label>
          <Textarea
            rows={4}
            placeholder="Qual é a missão da empresa?"
            value={mission}
            onChange={(e) => setMission(e.target.value)}
            className="resize-none text-sm leading-relaxed"
          />
        </div>

        {/* Visão */}
        <div className="space-y-2">
          <label className="block text-[10px] font-bold uppercase tracking-widest text-primary">
            Visão
          </label>
          <Textarea
            rows={4}
            placeholder="Qual é a visão de futuro?"
            value={vision}
            onChange={(e) => setVision(e.target.value)}
            className="resize-none text-sm leading-relaxed"
          />
        </div>

        {/* Valores */}
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <label className="text-[10px] font-bold uppercase tracking-widest text-primary">
              Valores
            </label>
            <Button variant="outline" size="sm" onClick={addValue} className="h-7 gap-1.5 text-xs">
              <Plus className="h-3.5 w-3.5" /> Adicionar valor
            </Button>
          </div>

          {values.length === 0 && (
            <div className="rounded-lg border border-dashed border-border py-8 text-center text-sm text-muted-foreground">
              Nenhum valor cadastrado. Clique em "Adicionar valor".
            </div>
          )}

          <div className="space-y-3">
            {values.map((val, i) => (
              <div key={i} className="flex gap-3 rounded-xl border border-border bg-card p-4">
                <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-primary/10 text-xs font-bold text-primary">
                  {i + 1}
                </div>
                <div className="flex-1 space-y-2">
                  <Input
                    placeholder="Título (ex: Integridade)"
                    value={val.title}
                    onChange={(e) => updateValue(i, "title", e.target.value)}
                    className="h-8 text-sm font-medium"
                  />
                  <Textarea
                    rows={2}
                    placeholder="Descrição breve do valor…"
                    value={val.description}
                    onChange={(e) => updateValue(i, "description", e.target.value)}
                    className="resize-none text-sm leading-relaxed"
                  />
                </div>
                <Button
                  variant="ghost"
                  size="icon"
                  className="h-7 w-7 shrink-0 text-muted-foreground hover:text-destructive"
                  onClick={() => removeValue(i)}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              </div>
            ))}
          </div>
        </div>

        {/* Nossa História */}
        <div className="space-y-2">
          <label className="block text-[10px] font-bold uppercase tracking-widest text-primary">
            Nossa História
          </label>
          <Textarea
            rows={7}
            placeholder="Conte a história da empresa…"
            value={history}
            onChange={(e) => setHistory(e.target.value)}
            className="resize-none text-sm leading-relaxed"
          />
        </div>

        {/* URL de capa — campo discreto no rodapé */}
        <div className="space-y-2 border-t border-border pt-6">
          <label className="block text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
            URL da imagem de capa (opcional)
          </label>
          <Input
            placeholder="https://..."
            value={coverUrl}
            onChange={(e) => setCoverUrl(e.target.value)}
            className="text-sm"
          />
        </div>

      </div>
    </div>
  );
}

// ─── Page ─────────────────────────────────────────────────────────────────────
export default function ApresentacaoEmpresaPage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const isAdmin = hasRole("master_admin") || hasRole("manager");
  const [editing, setEditing] = useState(false);

  const { data, isLoading } = useQuery({
    queryKey: ["company-presentation"],
    queryFn: companies.getPresentation,
  });

  const [mission, setMission] = useState("");
  const [vision, setVision] = useState("");
  const [history, setHistory] = useState("");
  const [coverUrl, setCoverUrl] = useState("");
  const [values, setValues] = useState<PresentationValue[]>([]);

  const startEdit = () => {
    setMission(data?.presentation_mission ?? "");
    setVision(data?.presentation_vision ?? "");
    setHistory(data?.presentation_history ?? "");
    setCoverUrl(data?.presentation_cover_url ?? "");
    setValues(data?.presentation_values ?? []);
    setEditing(true);
  };

  const mut = useMutation({
    mutationFn: () =>
      companies.updatePresentation({
        presentation_mission: mission || null,
        presentation_vision: vision || null,
        presentation_history: history || null,
        presentation_cover_url: coverUrl || null,
        presentation_values: values,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["company-presentation"] });
      setEditing(false);
      toast({ title: "Apresentação atualizada" });
    },
    onError: (e: Error) =>
      toast({ title: "Erro ao salvar", description: e.message, variant: "destructive" }),
  });

  const addValue = () => setValues((v) => [...v, { title: "", description: "" }]);
  const removeValue = (i: number) => setValues((v) => v.filter((_, idx) => idx !== i));
  const updateValue = (i: number, field: keyof PresentationValue, val: string) =>
    setValues((v) => v.map((item, idx) => (idx === i ? { ...item, [field]: val } : item)));

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="space-y-4 p-6">
          <Skeleton className="h-10 w-72" />
          <Skeleton className="h-48 w-full" />
          <Skeleton className="h-48 w-full" />
        </div>
      </AdminLayout>
    );
  }

  const p = data!;

  if (editing) {
    return (
      <AdminLayout>
        <div className="-m-6 lg:-m-8">
          <EditForm
            mission={mission} setMission={setMission}
            vision={vision} setVision={setVision}
            history={history} setHistory={setHistory}
            coverUrl={coverUrl} setCoverUrl={setCoverUrl}
            values={values}
            addValue={addValue} removeValue={removeValue} updateValue={updateValue}
            onCancel={() => setEditing(false)}
            onSave={() => mut.mutate()}
            isSaving={mut.isPending}
          />
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="-m-6 overflow-x-hidden lg:-m-8">
        <ViewMode presentation={p} />
      </div>
      {isAdmin && (
        <button
          onClick={startEdit}
          className="fixed bottom-6 right-6 z-50 flex items-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground shadow-lg transition-colors hover:bg-primary/90"
          style={{ boxShadow: "var(--shadow-brand)" }}
        >
          <Pencil className="h-3.5 w-3.5" />
          Editar conteúdo
        </button>
      )}
    </AdminLayout>
  );
}
