import { useEffect, useState } from "react";
import { documents } from "@/lib/api";
import type { Document } from "@/lib/api";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Download, Loader2, FileX } from "lucide-react";

export async function downloadDocument(doc: Document) {
  const { url, token } = documents.downloadUrl(doc.id);
  const res = await fetch(url, { headers: token ? { Authorization: `Bearer ${token}` } : {} });
  const blob = await res.blob();
  const a = window.document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = doc.original_name;
  a.click();
  URL.revokeObjectURL(a.href);
}

function isPreviewable(mimeType: string) {
  return mimeType.startsWith("image/") || mimeType === "application/pdf";
}

export function DocumentPreviewDialog({
  doc,
  onClose,
}: {
  doc: Document | null;
  onClose: () => void;
}) {
  const [blobUrl, setBlobUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!doc) return;

    setBlobUrl(null);

    if (!isPreviewable(doc.mime_type)) return;

    setLoading(true);
    const { url, token } = documents.downloadUrl(doc.id);
    fetch(url, { headers: token ? { Authorization: `Bearer ${token}` } : {} })
      .then((res) => res.blob())
      .then((blob) => {
        setBlobUrl(URL.createObjectURL(blob));
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [doc?.id]);

  useEffect(() => {
    return () => {
      if (blobUrl) URL.revokeObjectURL(blobUrl);
    };
  }, [blobUrl]);

  if (!doc) return null;

  return (
    <Dialog open={!!doc} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-w-4xl flex flex-col gap-4">
        <DialogHeader className="flex-row items-center justify-between pr-6">
          <DialogTitle className="truncate pr-4">{doc.title}</DialogTitle>
          <Button variant="outline" size="sm" onClick={() => downloadDocument(doc)}>
            <Download className="h-4 w-4 mr-2" /> Baixar
          </Button>
        </DialogHeader>

        <div className="overflow-hidden rounded-md border bg-muted/30">
          {loading && (
            <div className="flex h-64 items-center justify-center">
              <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
            </div>
          )}

          {!loading && blobUrl && doc.mime_type.startsWith("image/") && (
            <img
              src={blobUrl}
              alt={doc.title}
              className="max-h-[70vh] w-full object-contain"
            />
          )}

          {!loading && blobUrl && doc.mime_type === "application/pdf" && (
            <iframe
              src={blobUrl}
              title={doc.title}
              className="h-[70vh] w-full"
            />
          )}

          {!loading && !blobUrl && (
            <div className="flex h-64 flex-col items-center justify-center gap-3 text-muted-foreground">
              <FileX className="h-10 w-10" />
              <p className="text-sm">Visualização não disponível para este tipo de arquivo.</p>
              <Button variant="outline" size="sm" onClick={() => downloadDocument(doc)}>
                <Download className="h-4 w-4 mr-2" /> Baixar arquivo
              </Button>
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
