import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { documents } from "@/lib/api";
import type { Document } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { DocumentPreviewDialog, downloadDocument } from "@/components/DocumentPreviewDialog";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import { FileText, Download, Eye } from "lucide-react";

function formatSize(bytes: number) {
  if (bytes < 1024) return bytes + " B";
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB";
  return (bytes / (1024 * 1024)).toFixed(1) + " MB";
}

export default function MeusDocumentosPage() {
  const { toast } = useToast();
  const [previewDoc, setPreviewDoc] = useState<Document | null>(null);

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["my-documents"],
    queryFn: () => documents.listMy(),
  });

  function targetBadge(doc: Document) {
    if (doc.target_type === "general") return <Badge variant="secondary">Geral</Badge>;
    if (doc.target_type === "department") return <Badge variant="outline">Meu departamento</Badge>;
    return <Badge variant="outline">Para mim</Badge>;
  }

  async function handleDownload(doc: Document) {
    try {
      await downloadDocument(doc);
    } catch {
      toast({ title: "Erro ao baixar documento", variant: "destructive" });
    }
  }

  return (
    <AdminLayout>
      <div className="p-6 max-w-4xl mx-auto space-y-6">
        <div className="flex items-center gap-2">
          <FileText className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-semibold">Documentos</h1>
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}

        {!isLoading && list.length === 0 && (
          <p className="text-muted-foreground text-sm">Nenhum documento disponível para você.</p>
        )}

        <div className="space-y-3">
          {list.map((doc) => (
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
                  <Button variant="ghost" size="sm" onClick={() => setPreviewDoc(doc)}>
                    <Eye className="h-4 w-4" />
                  </Button>
                  <Button variant="outline" size="sm" onClick={() => handleDownload(doc)}>
                    <Download className="h-4 w-4" />
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <DocumentPreviewDialog doc={previewDoc} onClose={() => setPreviewDoc(null)} />
    </AdminLayout>
  );
}
