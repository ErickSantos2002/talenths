import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Pencil, Trash2, Plus, X, Check, HeartHandshake,
  ShieldCheck, Lightbulb, Heart, Zap, Star, Flame, Leaf, Globe,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { culture as cultureApi } from "@/lib/api";

// ─── Hooks ───────────────────────────────────────────────────────────────────
function useReveal(ref: React.RefObject<Element>, threshold = 0.12) {
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

function useTypewriter(text: string, active: boolean, speed = 18) {
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

function useWordTypewriter(text: string, active: boolean, speed = 160) {
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
  const { displayed, done } = useWordTypewriter("Nossa Cultura", titleVisible, 220);

  useEffect(() => {
    const t1 = setTimeout(() => setEyebrowVisible(true), 200);
    const t2 = setTimeout(() => setTitleVisible(true), 500);
    return () => { clearTimeout(t1); clearTimeout(t2); };
  }, []);

  return (
    <section className="relative flex min-h-[70vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center">
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
          {titleVisible ? displayed : <span className="opacity-0">Nossa Cultura</span>}
          {titleVisible && !done && (
            <span className="ml-1 inline-block w-0.5 animate-pulse bg-primary align-middle" style={{ height: "0.85em" }} />
          )}
        </h1>

        <div className="mt-14 flex animate-bounce items-center justify-center gap-2 text-xs text-muted-foreground/40">
          <span>↓</span>
          <span>Role para conhecer nossa cultura</span>
        </div>
      </div>
    </section>
  );
}

// ─── TypewriterSection ───────────────────────────────────────────────────────
function TypewriterSection({
  label, text, large = true, editButton,
}: {
  label: string;
  text: string;
  large?: boolean;
  editButton?: React.ReactNode;
}) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);
  const displayed = useTypewriter(text, visible);
  const done = displayed.length >= text.length;

  return (
    <section ref={ref} className="relative flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border text-center">
      {editButton && (
        <div className="absolute right-6 top-4 z-20">{editButton}</div>
      )}
      <div className="mx-auto w-full max-w-5xl px-8 md:px-16">
        <p
          className="mb-6 text-xs font-bold uppercase tracking-widest text-primary transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          {label}
        </p>
        <div className={large
          ? "text-justify text-2xl font-bold leading-relaxed text-foreground md:text-3xl lg:text-4xl"
          : "text-justify text-lg font-normal leading-loose text-muted-foreground md:text-xl lg:text-2xl"
        }>
          {visible ? displayed : <span className="opacity-0">{text}</span>}
          {visible && !done && (
            <span className="ml-1 inline-block w-0.5 animate-pulse bg-primary align-middle" style={{ height: "0.85em" }} />
          )}
        </div>
      </div>
    </section>
  );
}

// ─── ManifestoSection ────────────────────────────────────────────────────────
function ManifestoSection({ text, editButton }: { text: string; editButton?: React.ReactNode }) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);

  const paragraphs = text.split("\n").filter(Boolean);

  return (
    <section ref={ref} className="relative flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border">
      {editButton && (
        <div className="absolute right-6 top-4 z-20">{editButton}</div>
      )}
      <div className="mx-auto w-full max-w-3xl px-8 md:px-16">
        <p
          className="mb-10 text-center text-xs font-bold uppercase tracking-widest text-primary transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          Manifesto
        </p>
        <blockquote className="border-l-4 border-primary pl-8 space-y-5">
          {paragraphs.map((p, i) => (
            <p
              key={i}
              className="text-base italic leading-relaxed text-foreground text-justify md:text-lg transition-all duration-700"
              style={{
                opacity: visible ? 1 : 0,
                transform: visible ? "translateY(0)" : "translateY(16px)",
                transitionDelay: visible ? `${200 + i * 150}ms` : "0ms",
              }}
            >
              {p}
            </p>
          ))}
        </blockquote>
      </div>
    </section>
  );
}

// ─── ValueCard ───────────────────────────────────────────────────────────────
const VALUE_ICONS = [
  <ShieldCheck className="h-5 w-5" />, <Lightbulb className="h-5 w-5" />,
  <Heart className="h-5 w-5" />, <Zap className="h-5 w-5" />,
  <Star className="h-5 w-5" />, <Flame className="h-5 w-5" />,
  <Leaf className="h-5 w-5" />, <Globe className="h-5 w-5" />,
];

function CultureValueCard({
  title, description, index, parentVisible, canEdit, onEdit, onDelete,
}: {
  title: string; description: string | null; index: number; parentVisible: boolean;
  canEdit: boolean; onEdit: () => void; onDelete: () => void;
}) {
  const [show, setShow] = useState(false);
  useEffect(() => {
    if (!parentVisible) return;
    const t = setTimeout(() => setShow(true), index * 100);
    return () => clearTimeout(t);
  }, [parentVisible, index]);

  return (
    <div
      className="group relative flex flex-col items-center gap-3 rounded-xl border border-border bg-card p-5 text-center transition-all duration-500 hover:border-primary/20 hover:shadow-md"
      style={{ opacity: show ? 1 : 0, transform: show ? "translateY(0)" : "translateY(16px)" }}
    >
      {canEdit && (
        <div className="absolute right-2 top-2 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <button onClick={onEdit} title="Editar" className="flex h-6 w-6 items-center justify-center rounded-md bg-amber-500/15 text-amber-500 hover:bg-amber-500/25">
            <Pencil className="h-3 w-3" />
          </button>
          <button onClick={onDelete} title="Excluir" className="flex h-6 w-6 items-center justify-center rounded-md bg-destructive/15 text-destructive hover:bg-destructive/25">
            <Trash2 className="h-3 w-3" />
          </button>
        </div>
      )}
      <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
        {VALUE_ICONS[index % VALUE_ICONS.length]}
      </div>
      <div>
        <p className="text-sm font-semibold text-foreground">{title}</p>
        {description && <p className="mt-1 text-xs leading-relaxed text-muted-foreground">{description}</p>}
      </div>
    </div>
  );
}

function ValoresSection({
  values, canEdit, onAdd, onEdit, onDelete,
}: {
  values: CultureValue[];
  canEdit: boolean;
  onAdd: () => void;
  onEdit: (v: CultureValue) => void;
  onDelete: (id: string) => void;
}) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);

  return (
    <section ref={ref} className="relative flex min-h-[80vh] w-full flex-col items-center justify-center overflow-hidden border-b border-border">
      {canEdit && (
        <div className="absolute right-6 top-4 z-20">
          <button
            onClick={onAdd}
            className="flex items-center gap-1.5 rounded-lg bg-primary/10 px-3 py-1.5 text-xs font-medium text-primary transition-colors hover:bg-primary/20"
          >
            <Plus className="h-3.5 w-3.5" /> Adicionar Valor
          </button>
        </div>
      )}
      <div className="mx-auto w-full max-w-5xl px-8 md:px-14">
        <p
          className="mb-10 text-center text-xs font-bold uppercase tracking-widest text-primary transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          Nossos Valores
        </p>
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          {values.map((v, i) => (
            <CultureValueCard
              key={v.id}
              title={v.title}
              description={v.description}
              index={i}
              parentVisible={visible}
              canEdit={canEdit}
              onEdit={() => onEdit(v)}
              onDelete={() => onDelete(v.id)}
            />
          ))}
        </div>
      </div>
    </section>
  );
}

// ─── EditSection inline ───────────────────────────────────────────────────────
function EditButton({ onClick }: { onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="flex items-center gap-1.5 rounded-lg border border-border bg-background/80 px-3 py-1.5 text-xs font-medium text-muted-foreground backdrop-blur-sm transition-colors hover:text-foreground"
    >
      <Pencil className="h-3 w-3" /> Editar
    </button>
  );
}

// ─── Types ────────────────────────────────────────────────────────────────────
interface CultureValue {
  id: string;
  title: string;
  description: string | null;
  position: number;
}

interface CultureData {
  purpose: string | null;
  manifesto: string | null;
  updated_at: string | null;
  values: CultureValue[];
}

// ─── Page ─────────────────────────────────────────────────────────────────────
export default function CulturePage() {
  const { hasRole } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const canEdit = hasRole("master_admin") || hasRole("manager");

  const [editingPurpose, setEditingPurpose] = useState(false);
  const [editingManifesto, setEditingManifesto] = useState(false);
  const [purposeDraft, setPurposeDraft] = useState("");
  const [manifestoDraft, setManifestoDraft] = useState("");

  const [valueDialog, setValueDialog] = useState<{ open: boolean; editing: CultureValue | null }>({ open: false, editing: null });
  const [valueTitle, setValueTitle] = useState("");
  const [valueDescription, setValueDescription] = useState("");
  const [deleteTarget, setDeleteTarget] = useState<string | null>(null);

  const { data, isLoading } = useQuery<CultureData>({
    queryKey: ["culture"],
    queryFn: () => cultureApi.get(),
  });

  const updateCultureMutation = useMutation({
    mutationFn: (payload: { purpose?: string; manifesto?: string }) => cultureApi.update(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Salvo com sucesso" });
    },
    onError: (err: Error) => toast({ title: "Erro ao salvar", description: err.message, variant: "destructive" }),
  });

  const createValueMutation = useMutation({
    mutationFn: (payload: { title: string; description?: string }) => cultureApi.createValue(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor criado" });
      setValueDialog({ open: false, editing: null });
    },
    onError: (err: Error) => toast({ title: "Erro ao criar valor", description: err.message, variant: "destructive" }),
  });

  const updateValueMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: { title?: string; description?: string } }) =>
      cultureApi.updateValue(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor atualizado" });
      setValueDialog({ open: false, editing: null });
    },
    onError: (err: Error) => toast({ title: "Erro ao atualizar valor", description: err.message, variant: "destructive" }),
  });

  const deleteValueMutation = useMutation({
    mutationFn: (id: string) => cultureApi.deleteValue(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["culture"] });
      toast({ title: "Valor removido" });
      setDeleteTarget(null);
    },
    onError: (err: Error) => toast({ title: "Erro ao remover valor", description: err.message, variant: "destructive" }),
  });

  const savePurpose = () => {
    updateCultureMutation.mutate({ purpose: purposeDraft });
    setEditingPurpose(false);
  };

  const saveManifesto = () => {
    updateCultureMutation.mutate({ manifesto: manifestoDraft });
    setEditingManifesto(false);
  };

  const openCreateValue = () => {
    setValueTitle(""); setValueDescription("");
    setValueDialog({ open: true, editing: null });
  };

  const openEditValue = (v: CultureValue) => {
    setValueTitle(v.title); setValueDescription(v.description ?? "");
    setValueDialog({ open: true, editing: v });
  };

  const submitValueDialog = () => {
    if (!valueTitle.trim()) return;
    if (valueDialog.editing) {
      updateValueMutation.mutate({ id: valueDialog.editing.id, data: { title: valueTitle.trim(), description: valueDescription.trim() || undefined } });
    } else {
      createValueMutation.mutate({ title: valueTitle.trim(), description: valueDescription.trim() || undefined });
    }
  };

  if (isLoading) {
    return (
      <AdminLayout>
        <div className="-m-6 lg:-m-8">
          <div className="flex min-h-[70vh] items-center justify-center">
            <Skeleton className="h-16 w-64" />
          </div>
        </div>
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <div className="-m-6 overflow-x-hidden lg:-m-8">

        <HeroSection />

        {/* Propósito */}
        {editingPurpose ? (
          <section className="flex min-h-[60vh] w-full flex-col items-center justify-center border-b border-border px-8 md:px-16">
            <div className="w-full max-w-3xl space-y-4">
              <p className="text-xs font-bold uppercase tracking-widest text-primary">Propósito</p>
              <Textarea value={purposeDraft} onChange={(e) => setPurposeDraft(e.target.value)} rows={5} placeholder="Descreva o propósito da empresa..." className="resize-none text-lg" />
              <div className="flex gap-2">
                <Button size="sm" onClick={savePurpose} disabled={updateCultureMutation.isPending}><Check className="h-4 w-4 mr-2" />Salvar</Button>
                <Button size="sm" variant="ghost" onClick={() => setEditingPurpose(false)}><X className="h-4 w-4 mr-2" />Cancelar</Button>
              </div>
            </div>
          </section>
        ) : data?.purpose ? (
          <>
            <SectionTag label="Propósito" />
            <TypewriterSection
              label="Nosso Propósito"
              text={data.purpose}
              editButton={canEdit ? <EditButton onClick={() => { setPurposeDraft(data.purpose ?? ""); setEditingPurpose(true); }} /> : undefined}
            />
          </>
        ) : canEdit ? (
          <section className="flex min-h-[40vh] w-full flex-col items-center justify-center border-b border-border gap-4">
            <p className="text-muted-foreground">Propósito não definido</p>
            <Button size="sm" onClick={() => { setPurposeDraft(""); setEditingPurpose(true); }}><Plus className="h-4 w-4 mr-2" />Adicionar Propósito</Button>
          </section>
        ) : null}

        {/* Manifesto */}
        {editingManifesto ? (
          <section className="flex min-h-[60vh] w-full flex-col items-center justify-center border-b border-border px-8 md:px-16">
            <div className="w-full max-w-3xl space-y-4">
              <p className="text-xs font-bold uppercase tracking-widest text-primary">Manifesto</p>
              <Textarea value={manifestoDraft} onChange={(e) => setManifestoDraft(e.target.value)} rows={8} placeholder="Escreva o manifesto da empresa..." className="resize-none" />
              <div className="flex gap-2">
                <Button size="sm" onClick={saveManifesto} disabled={updateCultureMutation.isPending}><Check className="h-4 w-4 mr-2" />Salvar</Button>
                <Button size="sm" variant="ghost" onClick={() => setEditingManifesto(false)}><X className="h-4 w-4 mr-2" />Cancelar</Button>
              </div>
            </div>
          </section>
        ) : data?.manifesto ? (
          <>
            <SectionTag label="Manifesto" />
            <ManifestoSection
              text={data.manifesto}
              editButton={canEdit ? <EditButton onClick={() => { setManifestoDraft(data.manifesto ?? ""); setEditingManifesto(true); }} /> : undefined}
            />
          </>
        ) : canEdit ? (
          <section className="flex min-h-[40vh] w-full flex-col items-center justify-center border-b border-border gap-4">
            <p className="text-muted-foreground">Manifesto não definido</p>
            <Button size="sm" onClick={() => { setManifestoDraft(""); setEditingManifesto(true); }}><Plus className="h-4 w-4 mr-2" />Adicionar Manifesto</Button>
          </section>
        ) : null}

        {/* Valores */}
        {(data?.values && data.values.length > 0) || canEdit ? (
          <>
            <SectionTag label="Nossos Valores" />
            <ValoresSection
              values={data?.values ?? []}
              canEdit={canEdit}
              onAdd={openCreateValue}
              onEdit={openEditValue}
              onDelete={(id) => setDeleteTarget(id)}
            />
          </>
        ) : null}

      </div>

      {/* Dialogs */}
      <Dialog open={valueDialog.open} onOpenChange={(open) => !open && setValueDialog({ open: false, editing: null })}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{valueDialog.editing ? "Editar Valor" : "Novo Valor"}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <label className="text-sm font-medium">Título</label>
              <Input value={valueTitle} onChange={(e) => setValueTitle(e.target.value)} placeholder="Ex: Integridade" />
            </div>
            <div className="space-y-1.5">
              <label className="text-sm font-medium">Descrição</label>
              <Textarea value={valueDescription} onChange={(e) => setValueDescription(e.target.value)} placeholder="Descreva o que esse valor significa para a empresa..." rows={3} className="resize-none" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="ghost" onClick={() => setValueDialog({ open: false, editing: null })}>Cancelar</Button>
            <Button onClick={submitValueDialog} disabled={!valueTitle.trim() || createValueMutation.isPending || updateValueMutation.isPending}>
              {valueDialog.editing ? "Salvar" : "Criar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Remover valor</AlertDialogTitle>
            <AlertDialogDescription>Tem certeza que deseja remover este valor? Essa ação não pode ser desfeita.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => deleteTarget && deleteValueMutation.mutate(deleteTarget)}
              disabled={deleteValueMutation.isPending}
            >
              Remover
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
}
