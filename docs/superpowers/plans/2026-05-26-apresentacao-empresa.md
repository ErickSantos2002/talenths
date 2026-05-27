# ApresentacaoEmpresaPage — Redesign Cinemático

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformar a página de apresentação da empresa em uma experiência cinematográfica com typewriter nas seções de texto e scroll reveal nos valores.

**Architecture:** O componente é dividido em dois modos — `ViewMode` (cinemático, para todos) e formulário de edição inline (só admins). Os hooks `useReveal` e `useTypewriter` são definidos no mesmo arquivo. Sem dependências externas novas — só Intersection Observer nativo + CSS transitions.

**Tech Stack:** React 18, TypeScript, Tailwind CSS, TanStack Query 5, Lucide React (ícones dos valores)

---

## Mapa de Arquivos

| Arquivo | Ação | Responsabilidade |
|---|---|---|
| `frontend/src/pages/ApresentacaoEmpresaPage.tsx` | Reescrever | Tudo — hooks, sub-componentes e export default |

Nenhum outro arquivo é alterado.

---

### Task 1: Hooks utilitários + esqueleto do componente

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Substituir o conteúdo inteiro do arquivo pelo esqueleto abaixo**

```tsx
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
import { Check, X, Plus, Trash2, Pencil,
         ShieldCheck, Lightbulb, Heart, Zap } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

// ─── Hook: dispara true uma vez quando o elemento entra na viewport ───────────
function useReveal(ref: React.RefObject<Element>, threshold = 0.25) {
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

// ─── Hook: typewriter — só começa quando active=true ─────────────────────────
function useTypewriter(text: string, active: boolean, speed = 28) {
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

  // ── Edit state ──────────────────────────────────────────────────────────────
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
      </AdminLayout>
    );
  }

  return (
    <AdminLayout>
      <ViewMode presentation={p} />
      {isAdmin && (
        <button
          onClick={startEdit}
          className="fixed bottom-6 right-6 z-50 flex items-center gap-2 rounded-xl bg-emerald-500 px-4 py-2.5 text-sm font-semibold text-white shadow-lg shadow-emerald-500/30 hover:bg-emerald-400 transition-colors"
        >
          <Pencil className="h-3.5 w-3.5" />
          Editar conteúdo
        </button>
      )}
    </AdminLayout>
  );
}

// ─── Placeholder dos componentes — serão preenchidos nas próximas tasks ───────
function ViewMode({ presentation }: { presentation: ReturnType<typeof companies.getPresentation> extends Promise<infer T> ? T : never }) {
  return <div className="p-8 text-muted-foreground">ViewMode em construção</div>;
}

function EditForm(_props: any) {
  return <div className="p-8 text-muted-foreground">EditForm em construção</div>;
}
```

- [ ] **Step 2: Rodar o servidor de desenvolvimento e confirmar que a página abre sem erros de compilação**

```bash
cd frontend && bun dev
```

Abrir `http://localhost:8080/apresentacao`. Esperado: página renderiza sem erros no console (pode mostrar "ViewMode em construção").

---

### Task 2: Componente EditForm

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Substituir a função `EditForm` placeholder pela versão real**

Localizar `function EditForm(_props: any) {` e substituir por:

```tsx
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
    <div className="space-y-6 p-6 max-w-2xl">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold">Editar Apresentação</h2>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={onCancel}>
            <X className="h-4 w-4 mr-1" /> Cancelar
          </Button>
          <Button size="sm" onClick={onSave} disabled={isSaving}>
            <Check className="h-4 w-4 mr-1" /> Salvar
          </Button>
        </div>
      </div>

      <div className="space-y-1">
        <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">URL da imagem de capa</p>
        <Input placeholder="https://..." value={coverUrl} onChange={(e) => setCoverUrl(e.target.value)} />
      </div>

      <div className="space-y-1">
        <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Missão</p>
        <Textarea rows={3} placeholder="Qual é a missão da empresa?" value={mission} onChange={(e) => setMission(e.target.value)} />
      </div>

      <div className="space-y-1">
        <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Visão</p>
        <Textarea rows={3} placeholder="Qual é a visão de futuro?" value={vision} onChange={(e) => setVision(e.target.value)} />
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Valores</p>
          <Button variant="ghost" size="sm" onClick={addValue}>
            <Plus className="h-4 w-4 mr-1" /> Adicionar
          </Button>
        </div>
        {values.length === 0 && (
          <p className="text-sm text-muted-foreground italic">Nenhum valor. Clique em "Adicionar".</p>
        )}
        {values.map((val, i) => (
          <div key={i} className="flex gap-2 items-start">
            <div className="flex-1 space-y-2">
              <Input placeholder="Título (ex: Integridade)" value={val.title} onChange={(e) => updateValue(i, "title", e.target.value)} />
              <Textarea rows={2} placeholder="Descrição..." value={val.description} onChange={(e) => updateValue(i, "description", e.target.value)} />
            </div>
            <Button variant="ghost" size="icon" className="text-destructive hover:bg-destructive/10 mt-1" onClick={() => removeValue(i)}>
              <Trash2 className="h-4 w-4" />
            </Button>
          </div>
        ))}
      </div>

      <div className="space-y-1">
        <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Nossa História</p>
        <Textarea rows={6} placeholder="Conte a história da empresa..." value={history} onChange={(e) => setHistory(e.target.value)} />
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Testar o formulário de edição**

No browser, clicar em "Editar conteúdo" (botão fixo no canto). Esperado: formulário aparece com campos preenchidos, Salvar e Cancelar funcionando.

---

### Task 3: Hero section

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Adicionar o componente `HeroSection` antes de `ViewMode`**

```tsx
function HeroSection({ name, cnpj }: { name: string; cnpj?: string | null }) {
  const [phase, setPhase] = useState(0);
  useEffect(() => {
    const t1 = setTimeout(() => setPhase(1), 150);
    const t2 = setTimeout(() => setPhase(2), 400);
    const t3 = setTimeout(() => setPhase(3), 750);
    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, []);

  return (
    <section className="relative min-h-[70vh] flex flex-col justify-center overflow-hidden px-8 md:px-14 py-16 border-b border-white/5">
      {/* Blobs decorativos */}
      <div className="pointer-events-none absolute -top-32 -right-24 w-[480px] h-[480px] rounded-full blur-[100px]" style={{ background: "rgba(16,185,129,0.08)" }} />
      <div className="pointer-events-none absolute -bottom-24 -left-16 w-[360px] h-[360px] rounded-full blur-[90px]" style={{ background: "rgba(16,185,129,0.05)" }} />

      {/* Eyebrow */}
      <div
        className="relative z-10 mb-4 flex items-center gap-2.5 text-emerald-400 transition-all duration-500"
        style={{ opacity: phase >= 1 ? 1 : 0, transform: phase >= 1 ? "translateY(0)" : "translateY(8px)" }}
      >
        <div className="h-px w-6 bg-emerald-400" />
        <span className="text-xs font-semibold uppercase tracking-widest">Bem-vindo à empresa</span>
      </div>

      {/* Nome */}
      <h1
        className="relative z-10 text-4xl md:text-6xl font-extrabold text-slate-50 leading-none tracking-tight transition-all duration-700"
        style={{ opacity: phase >= 2 ? 1 : 0, transform: phase >= 2 ? "translateY(0)" : "translateY(24px)" }}
      >
        {name}
      </h1>

      {/* CNPJ */}
      {cnpj && (
        <p
          className="relative z-10 mt-3 text-sm text-slate-500 transition-opacity duration-700"
          style={{ opacity: phase >= 3 ? 1 : 0 }}
        >
          CNPJ: {cnpj}
        </p>
      )}

      {/* Scroll hint */}
      <div className="relative z-10 mt-14 flex items-center gap-2 text-xs text-slate-600 animate-bounce">
        <span>↓</span>
        <span>Role para conhecer nossa empresa</span>
      </div>
    </section>
  );
}
```

- [ ] **Step 2: Verificar no browser que o hero anima corretamente ao carregar a página**

Recarregar `/apresentacao`. Esperado: nome da empresa aparece com animação suave em ~400ms.

---

### Task 4: TypewriterSection (Missão e Visão)

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Adicionar `SectionTag` e `TypewriterSection` antes de `HeroSection`**

```tsx
function SectionTag({ label }: { label: string }) {
  return (
    <div className="sticky top-0 z-10 flex items-center gap-2 border-b border-white/5 bg-[#0d1117]/90 px-8 md:px-14 py-2 text-xs font-medium text-slate-500 backdrop-blur-md">
      <span className="h-1.5 w-1.5 rounded-full bg-emerald-400" />
      {label}
    </div>
  );
}

function TypewriterSection({
  sectionId,
  label,
  text,
  speed = 28,
  className = "",
}: {
  sectionId: string;
  label: string;
  text: string;
  speed?: number;
  className?: string;
}) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);
  const displayed = useTypewriter(text, visible, speed);
  const done = displayed.length >= text.length;

  return (
    <section
      id={sectionId}
      ref={ref}
      className="min-h-[75vh] flex flex-col justify-center px-8 md:px-14 py-16 border-b border-white/5"
    >
      {/* Label */}
      <p
        className="mb-5 text-xs font-bold uppercase tracking-widest text-emerald-400 transition-all duration-500"
        style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
      >
        {label}
      </p>

      {/* Texto */}
      <div className={`max-w-2xl text-2xl md:text-3xl font-bold leading-snug text-slate-100 ${className}`}>
        {visible ? displayed : <span className="text-slate-800">{text}</span>}
        {visible && !done && (
          <span className="ml-0.5 inline-block h-6 w-0.5 animate-pulse bg-emerald-400 align-middle" />
        )}
      </div>
    </section>
  );
}
```

- [ ] **Step 2: Verificar que TypewriterSection não causa erros de TypeScript**

```bash
cd frontend && bun run tsc --noEmit 2>&1 | head -30
```

Esperado: sem erros relacionados a `TypewriterSection`.

---

### Task 5: Valores com scroll reveal

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Adicionar `ValoresSection` com ícones Lucide e stagger reveal**

```tsx
const VALUE_ICONS: Record<string, React.ReactNode> = {
  default0: <ShieldCheck className="h-5 w-5" />,
  default1: <Lightbulb className="h-5 w-5" />,
  default2: <Heart className="h-5 w-5" />,
  default3: <Zap className="h-5 w-5" />,
};

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
    const t = setTimeout(() => setShow(true), index * 130);
    return () => clearTimeout(t);
  }, [parentVisible, index]);

  const icon = VALUE_ICONS[`default${index % 4}`] ?? <ShieldCheck className="h-5 w-5" />;

  return (
    <div
      className="flex items-start gap-4 rounded-xl border border-white/5 bg-[#0d1623] p-5 transition-all duration-500"
      style={{ opacity: show ? 1 : 0, transform: show ? "translateY(0)" : "translateY(14px)" }}
    >
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
        {icon}
      </div>
      <div>
        <p className="text-sm font-semibold text-slate-100">{title}</p>
        <p className="mt-1 text-xs leading-relaxed text-slate-500">{description}</p>
      </div>
    </div>
  );
}

function ValoresSection({ values }: { values: PresentationValue[] }) {
  const ref = useRef<HTMLElement>(null);
  const visible = useReveal(ref as React.RefObject<Element>);

  if (!values.length) return null;

  return (
    <>
      <SectionTag label="Valores" />
      <section
        id="valores"
        ref={ref}
        className="min-h-[75vh] flex flex-col justify-center px-8 md:px-14 py-16 border-b border-white/5"
      >
        <p
          className="mb-6 text-xs font-bold uppercase tracking-widest text-emerald-400 transition-all duration-500"
          style={{ opacity: visible ? 1 : 0, transform: visible ? "translateY(0)" : "translateY(8px)" }}
        >
          Nossos Valores
        </p>
        <div className="grid max-w-2xl grid-cols-1 gap-3 sm:grid-cols-2">
          {values.map((v, i) => (
            <ValueCard key={i} title={v.title} description={v.description} index={i} parentVisible={visible} />
          ))}
        </div>
      </section>
    </>
  );
}
```

- [ ] **Step 2: Confirmar que os ícones Lucide importados existem**

`ShieldCheck`, `Lightbulb`, `Heart`, `Zap` foram adicionados no import da Task 1. Verificar que o import no topo do arquivo contém todos eles.

---

### Task 6: Montar ViewMode completo

**Arquivo:**
- Modify: `frontend/src/pages/ApresentacaoEmpresaPage.tsx`

- [ ] **Step 1: Substituir a função `ViewMode` placeholder pela versão real**

Localizar `function ViewMode(` e substituir por:

```tsx
function ViewMode({ presentation }: {
  presentation: {
    name: string;
    cnpj?: string | null;
    presentation_mission?: string | null;
    presentation_vision?: string | null;
    presentation_history?: string | null;
    presentation_values?: PresentationValue[] | null;
  };
}) {
  const hasMission = !!presentation.presentation_mission;
  const hasVision = !!presentation.presentation_vision;
  const hasHistory = !!presentation.presentation_history;
  const hasValues = (presentation.presentation_values?.length ?? 0) > 0;

  return (
    <div className="min-h-screen" style={{ background: "#0d1117" }}>
      <HeroSection name={presentation.name} cnpj={presentation.cnpj} />

      {hasMission && (
        <>
          <SectionTag label="Missão" />
          <TypewriterSection
            sectionId="missao"
            label="Nossa Missão"
            text={presentation.presentation_mission!}
          />
        </>
      )}

      {hasVision && (
        <>
          <SectionTag label="Visão" />
          <TypewriterSection
            sectionId="visao"
            label="Nossa Visão"
            text={presentation.presentation_vision!}
          />
        </>
      )}

      {hasValues && (
        <ValoresSection values={presentation.presentation_values!} />
      )}

      {hasHistory && (
        <>
          <SectionTag label="Nossa História" />
          <TypewriterSection
            sectionId="historia"
            label="Nossa História"
            text={presentation.presentation_history!}
            speed={22}
            className="!text-lg !font-normal !text-slate-400 !leading-relaxed"
          />
        </>
      )}

      {!hasMission && !hasVision && !hasValues && !hasHistory && (
        <div className="flex min-h-[60vh] items-center justify-center text-slate-600 text-sm">
          Nenhuma apresentação configurada ainda.
        </div>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Ajustar o tipo da prop `presentation` em `ViewMode` para usar o tipo retornado pela query**

Verificar que `data!` em `<ViewMode presentation={p} />` não gera erro de TypeScript:

```bash
cd frontend && bun run tsc --noEmit 2>&1 | head -20
```

Se houver erro de tipo no `ViewMode`, ajustar a assinatura para usar `typeof data` diretamente:

```tsx
function ViewMode({ presentation }: { presentation: NonNullable<typeof data> }) {
```

Onde `data` é o tipo inferido pelo `useQuery`. Se isso criar problema de escopo, usar a assinatura explícita já definida acima — que cobre todos os campos necessários.

---

### Task 7: Verificação final e commit

- [ ] **Step 1: Rodar o linter**

```bash
cd frontend && bun lint 2>&1
```

Corrigir qualquer warning de `any` ou import não utilizado.

- [ ] **Step 2: Testar manualmente o fluxo completo**

1. Abrir `/apresentacao` — hero anima ao carregar
2. Rolar devagar — missão e visão digitam ao entrar na tela
3. Continuar rolando — cards de valores aparecem em cascata
4. Continuar — história digita em fonte menor
5. Clicar "Editar conteúdo" — formulário abre com dados preenchidos
6. Editar um campo, Salvar — toast "Apresentação atualizada" aparece, volta para view
7. Testar em mobile (DevTools, 375px) — layout responsivo, sem overflow

- [ ] **Step 3: Commit**

```bash
git add frontend/src/pages/ApresentacaoEmpresaPage.tsx docs/superpowers/
git commit -m "feat: redesign cinematico da pagina de apresentacao da empresa

- Hero com tipografia animada e blobs decorativos em emerald
- Missao e visao com efeito typewriter ativado por IntersectionObserver
- Valores com scroll reveal em cascata e icones Lucide
- Historia com typewriter mais lento em estilo narrativo
- Botao fixo de edicao visivel apenas para admin/manager
- Zero dependencias novas"
```
