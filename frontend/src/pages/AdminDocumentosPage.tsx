import { useRef, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { documents, departments, collaborators } from "@/lib/api";
import type { Document } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { FileText, Plus, Download, Trash2 } from "lucide-react";

type TargetFilter = "all" | "general" | "department" | "individual";

type UploadForm = {
  title: string;
  target_type: string;
  target_department_id: string;
  target_user_id: string;
  file: File | null;
};

const emptyForm: UploadForm = {
  title: "",
  target_type: "general",
  target_department_id: "",
  target_user_id: "",
  file: null,
};

function formatSize(bytes: number) {
  if (bytes < 1024) return bytes + " B";
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB";
  return (bytes / (1024 * 1024)).toFixed(1) + " MB";
}

async function downloadDocument(doc: Document) {
  const { url, token } = documents.downloadUrl(doc.id);
  const res = await fetch(url, { headers: token ? { Authorization: `Bearer ${token}` } : {} });
  const blob = await res.blob();
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = doc.original_name;
  a.click();
  URL.revokeObjectURL(a.href);
}

export default function AdminDocumentosPage() {
  const qc = useQueryClient();
  const { toast } = useToast();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [showUpload, setShowUpload] = useState(false);
  const [form, setForm] = useState<UploadForm>(emptyForm);
  const [filter, setFilter] = useState<TargetFilter>("all");

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["admin-documents"],
    queryFn: () => documents.list(),
  });

  const { data: deptList = [] } = useQuery({
    queryKey: ["departments"],
    queryFn: () => departments.list(),
    enabled: form.target_type === "department",
  });

  const { data: collabList = [] } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaborators.list(),
    enabled: form.target_type === "individual",
  });

  const uploadMut = useMutation({
    mutationFn: (data: UploadForm) => {
      const fd = new FormData();
      fd.append("title", data.title);
      fd.append("target_type", data.target_type);
      if (data.target_type === "department" && data.target_department_id)
        fd.append("target_department_id", data.target_department_id);
      if (data.target_type === "individual" && data.target_user_id)
        fd.append("target_user_id", data.target_user_id);
      fd.append("file", data.file!);
      return documents.upload(fd);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-documents"] });
      setShowUpload(false);
      setForm(emptyForm);
      toast({ title: "Documento enviado com sucesso" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const deleteMut = useMutation({
    mutationFn: (id: string) => documents.delete(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-documents"] });
      toast({ title: "Documento excluído" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const filtered = filter === "all" ? list : list.filter((d) => d.target_type === filter);

  function targetBadge(doc: Document) {
    if (doc.target_type === "general") return <Badge variant="secondary">Geral</Badge>;
    if (doc.target_type === "department")
      return <Badge variant="outline">{doc.target_name ?? "Departamento"}</Badge>;
    return <Badge variant="outline">{doc.target_name ?? "Colaborador"}</Badge>;
  }

  const canSubmit =
    !!form.title &&
    !!form.file &&
    (form.target_type !== "department" || !!form.target_department_id) &&
    (form.target_type !== "individual" || !!form.target_user_id);

  return (
    <AdminLayout>
      <div className="p-6 max-w-5xl mx-auto space-y-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <FileText className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-semibold">Documentos</h1>
          </div>
          <Button onClick={() => setShowUpload(true)}>
            <Plus className="h-4 w-4 mr-2" /> Enviar Documento
          </Button>
        </div>

        <div className="flex gap-2 flex-wrap">
          {(["all", "general", "department", "individual"] as TargetFilter[]).map((f) => (
            <Button
              key={f}
              variant={filter === f ? "default" : "outline"}
              size="sm"
              onClick={() => setFilter(f)}
            >
              {f === "all" ? "Todos" : f === "general" ? "Geral" : f === "department" ? "Por Departamento" : "Por Colaborador"}
            </Button>
          ))}
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}

        {!isLoading && filtered.length === 0 && (
          <p className="text-muted-foreground text-sm">Nenhum documento encontrado.</p>
        )}

        <div className="space-y-3">
          {filtered.map((doc) => (
            <Card key={doc.id}>
              <CardContent className="p-4 flex items-start justify-between gap-4">
                <div className="flex-1 space-y-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <FileText className="h-4 w-4 shrink-0 text-muted-foreground" />
                    <span className="font-medium">{doc.title}</span>
                    {targetBadge(doc)}
                  </div>
                  <p className="text-sm text-muted-foreground truncate">{doc.original_name}</p>
                  <p className="text-xs text-muted-foreground">
                    {formatSize(doc.file_size)} · {doc.uploaded_by_name} ·{" "}
                    {new Date(doc.created_at).toLocaleDateString("pt-BR")}
                  </p>
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => downloadDocument(doc)}
                  >
                    <Download className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="text-destructive hover:text-destructive hover:bg-destructive/10"
                    onClick={() => deleteMut.mutate(doc.id)}
                    disabled={deleteMut.isPending}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <Dialog open={showUpload} onOpenChange={(open) => { setShowUpload(open); if (!open) setForm(emptyForm); }}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Enviar Documento</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-1.5">
              <Label>Título</Label>
              <Input
                value={form.title}
                onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
                placeholder="Nome do documento"
              />
            </div>
            <div className="space-y-1.5">
              <Label>Destinatário</Label>
              <Select
                value={form.target_type}
                onValueChange={(v) =>
                  setForm((f) => ({ ...f, target_type: v, target_department_id: "", target_user_id: "" }))
                }
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="general">Todos os colaboradores</SelectItem>
                  <SelectItem value="department">Por departamento</SelectItem>
                  <SelectItem value="individual">Colaborador específico</SelectItem>
                </SelectContent>
              </Select>
            </div>
            {form.target_type === "department" && (
              <div className="space-y-1.5">
                <Label>Departamento</Label>
                <Select
                  value={form.target_department_id}
                  onValueChange={(v) => setForm((f) => ({ ...f, target_department_id: v }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar departamento" />
                  </SelectTrigger>
                  <SelectContent>
                    {(deptList as { id: string; name: string }[]).map((d) => (
                      <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            {form.target_type === "individual" && (
              <div className="space-y-1.5">
                <Label>Colaborador</Label>
                <Select
                  value={form.target_user_id}
                  onValueChange={(v) => setForm((f) => ({ ...f, target_user_id: v }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecionar colaborador" />
                  </SelectTrigger>
                  <SelectContent>
                    {(collabList as { user_id: string; name: string }[]).map((c) => (
                      <SelectItem key={c.user_id} value={c.user_id}>{c.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            <div className="space-y-1.5">
              <Label>Arquivo</Label>
              <input
                ref={fileInputRef}
                type="file"
                className="hidden"
                onChange={(e) => setForm((f) => ({ ...f, file: e.target.files?.[0] ?? null }))}
              />
              <div className="flex items-center gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => fileInputRef.current?.click()}
                >
                  Escolher arquivo
                </Button>
                <span className="text-sm text-muted-foreground truncate">
                  {form.file ? form.file.name : "Nenhum arquivo selecionado"}
                </span>
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setShowUpload(false); setForm(emptyForm); }}>
              Cancelar
            </Button>
            <Button
              onClick={() => uploadMut.mutate(form)}
              disabled={uploadMut.isPending || !canSubmit}
            >
              {uploadMut.isPending ? "Enviando..." : "Enviar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
