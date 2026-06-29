import { useState, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Paperclip, Download, Trash2, Send, FileText } from "lucide-react";
import { goals as goalsApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Skeleton } from "@/components/ui/skeleton";
import type { GoalCommentAttachment } from "@/types/goals";

function formatSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}

async function downloadAttachment(att: GoalCommentAttachment) {
  const { url, token } = goalsApi.commentAttachmentUrl(att.id);
  const res = await fetch(url, { headers: token ? { Authorization: `Bearer ${token}` } : {} });
  const blob = await res.blob();
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = att.original_name;
  a.click();
  URL.revokeObjectURL(a.href);
}

export function GoalComments({ goalId, canEdit }: { goalId: string; canEdit: boolean }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [body, setBody] = useState("");
  const [files, setFiles] = useState<File[]>([]);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const { data: comments = [], isLoading } = useQuery({
    queryKey: ["goal-comments", goalId],
    queryFn: () => goalsApi.listComments(goalId),
  });

  const addMutation = useMutation({
    mutationFn: () => {
      const fd = new FormData();
      fd.append("body", body.trim());
      files.forEach((f) => fd.append("files", f));
      return goalsApi.addComment(goalId, fd);
    },
    onSuccess: () => {
      setBody("");
      setFiles([]);
      if (fileInputRef.current) fileInputRef.current.value = "";
      queryClient.invalidateQueries({ queryKey: ["goal-comments", goalId] });
    },
    onError: (e: Error) => toast({ title: "Erro ao comentar", description: e.message, variant: "destructive" }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => goalsApi.deleteComment(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goal-comments", goalId] });
      toast({ title: "Comentário removido" });
    },
    onError: (e: Error) => toast({ title: "Erro ao remover", description: e.message, variant: "destructive" }),
  });

  const canSubmit = (body.trim() !== "" || files.length > 0) && !addMutation.isPending;

  return (
    <div className="space-y-4">
      {canEdit && (
        <div className="space-y-2 rounded-lg border bg-card p-3">
          <Textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            placeholder="Escreva um comentário..."
            rows={2}
            className="resize-none"
          />
          {files.length > 0 && (
            <div className="flex flex-wrap gap-1.5">
              {files.map((f, i) => (
                <span key={i} className="inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-xs">
                  <FileText className="h-3 w-3" /> {f.name}
                  <button type="button" className="text-muted-foreground hover:text-destructive" onClick={() => setFiles(files.filter((_, j) => j !== i))}>×</button>
                </span>
              ))}
            </div>
          )}
          <div className="flex items-center justify-between">
            <input
              ref={fileInputRef}
              type="file"
              multiple
              className="hidden"
              onChange={(e) => setFiles([...files, ...Array.from(e.target.files ?? [])])}
            />
            <Button type="button" variant="ghost" size="sm" onClick={() => fileInputRef.current?.click()}>
              <Paperclip className="h-4 w-4 mr-1" /> Anexar
            </Button>
            <Button size="sm" onClick={() => addMutation.mutate()} disabled={!canSubmit}>
              <Send className="h-4 w-4 mr-1" /> {addMutation.isPending ? "Enviando..." : "Comentar"}
            </Button>
          </div>
        </div>
      )}

      {isLoading ? (
        <Skeleton className="h-16 w-full" />
      ) : comments.length === 0 ? (
        <p className="text-sm text-muted-foreground text-center py-4">Nenhum comentário ainda.</p>
      ) : (
        <div className="space-y-2">
          {comments.map((c) => (
            <div key={c.id} className="rounded-lg border bg-card p-3 space-y-2">
              <div className="flex items-center justify-between gap-2">
                <span className="text-sm font-medium">{c.author_name ?? "Usuário"}</span>
                <div className="flex items-center gap-2">
                  <span className="text-xs text-muted-foreground">
                    {new Date(c.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                  </span>
                  {canEdit && (
                    <button className="text-muted-foreground hover:text-destructive" onClick={() => deleteMutation.mutate(c.id)} title="Remover">
                      <Trash2 className="h-3.5 w-3.5" />
                    </button>
                  )}
                </div>
              </div>
              {c.body && <p className="text-sm text-foreground/80 whitespace-pre-wrap">{c.body}</p>}
              {c.attachments.length > 0 && (
                <div className="flex flex-wrap gap-1.5">
                  {c.attachments.map((a) => (
                    <button
                      key={a.id}
                      onClick={() => downloadAttachment(a)}
                      className="inline-flex items-center gap-1.5 rounded-md border px-2 py-1 text-xs hover:bg-muted/50 transition-colors"
                      title="Baixar"
                    >
                      <Download className="h-3.5 w-3.5 text-primary" />
                      <span className="max-w-[180px] truncate">{a.original_name}</span>
                      <span className="text-muted-foreground">({formatSize(a.file_size)})</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
