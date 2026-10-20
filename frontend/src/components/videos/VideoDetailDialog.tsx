import { useRef, useState } from "react";
import { Link } from "react-router-dom";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { videos } from "@/lib/api";
import type { ViewerRow, ViewerStatus } from "@/lib/api";
import { uploadVideoFile } from "@/lib/videoUpload";
import { formatDueDays, formatDuration } from "@/lib/videoFormat";
import { VideoFormDialog } from "./VideoFormDialog";
import { VideoStatusBadge } from "./VideoStatusBadge";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Progress } from "@/components/ui/progress";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/hooks/use-toast";

type Props = { videoId: string | null; onClose: () => void };

const STATUS_OPTIONS: Array<{ value: ViewerStatus; label: string }> = [
  { value: "concluido", label: "Concluído" },
  { value: "atrasado", label: "Atrasado" },
  { value: "em_andamento", label: "Em andamento" },
  { value: "pendente", label: "Pendente" },
];

const NO_DEPARTMENT = "__none__";

function formatDateTime(iso: string | null) {
  return iso ? new Date(iso).toLocaleString("pt-BR") : "—";
}

export function VideoDetailDialog({ videoId, onClose }: Props) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const fileRef = useRef<HTMLInputElement>(null);
  const abortRef = useRef<AbortController | null>(null);

  const [statusFilter, setStatusFilter] = useState("all");
  const [deptFilter, setDeptFilter] = useState("all");
  const [editOpen, setEditOpen] = useState(false);
  const [pendingFile, setPendingFile] = useState<File | null>(null);
  const [uploadProgress, setUploadProgress] = useState<number | null>(null);
  const [removeTarget, setRemoveTarget] = useState<ViewerRow | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const { data, isLoading } = useQuery({
    queryKey: ["admin-video", videoId],
    queryFn: () => videos.getAdmin(videoId!),
    enabled: !!videoId,
  });

  const refresh = () => {
    qc.invalidateQueries({ queryKey: ["admin-videos"] });
    qc.invalidateQueries({ queryKey: ["admin-video", videoId] });
  };
  const onError = (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" });

  const archiveMut = useMutation({
    mutationFn: (archive: boolean) => (archive ? videos.archive(videoId!) : videos.unarchive(videoId!)),
    onSuccess: (_, archive) => {
      refresh();
      toast({ title: archive ? "Vídeo arquivado" : "Vídeo reativado" });
    },
    onError,
  });

  const deleteMut = useMutation({
    mutationFn: () => videos.remove(videoId!),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["admin-videos"] });
      toast({ title: "Vídeo excluído" });
      setDeleteOpen(false);
      onClose();
    },
    onError,
  });

  const removeMut = useMutation({
    mutationFn: (userId: string) => videos.removeViewer(videoId!, userId),
    onSuccess: () => {
      refresh();
      toast({ title: "Pessoa removida do vídeo" });
      setRemoveTarget(null);
    },
    onError,
  });

  const replaceMut = useMutation({
    mutationFn: async ({ file, mode }: { file: File; mode: "keep_completed" | "reset_all" }) => {
      const controller = new AbortController();
      abortRef.current = controller;
      setUploadProgress(0);
      try {
        const { upload_id } = await uploadVideoFile(file, {
          onProgress: setUploadProgress,
          signal: controller.signal,
        });
        try {
          return await videos.replaceFile(videoId!, upload_id, mode);
        } catch (e) {
          videos.cancel(upload_id).catch(() => undefined);
          throw e;
        }
      } finally {
        abortRef.current = null;
        setUploadProgress(null);
      }
    },
    onSuccess: () => {
      refresh();
      toast({ title: "Arquivo trocado" });
    },
    onError: (e: Error) => {
      if (e instanceof DOMException && e.name === "AbortError") return;
      onError(e);
    },
  });

  const handleClose = () => {
    abortRef.current?.abort();
    setStatusFilter("all");
    setDeptFilter("all");
    onClose();
  };

  const startReplace = (mode: "keep_completed" | "reset_all") => {
    if (pendingFile) replaceMut.mutate({ file: pendingFile, mode });
    setPendingFile(null);
  };

  const video = data?.video;
  const allRows = data ? [...data.required, ...data.voluntary, ...data.former] : [];
  const departments = Array.from(new Set(allRows.map((r) => r.department ?? NO_DEPARTMENT)));

  const filterRows = (rows: ViewerRow[]) =>
    rows.filter(
      (r) =>
        (statusFilter === "all" || r.status === statusFilter) &&
        (deptFilter === "all" || (r.department ?? NO_DEPARTMENT) === deptFilter),
    );

  function renderTable(rows: ViewerRow[], canRemove: boolean) {
    const filtered = filterRows(rows);
    if (filtered.length === 0) {
      return <p className="text-sm text-muted-foreground py-4">Nenhuma pessoa encontrada.</p>;
    }
    return (
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Nome</TableHead>
              <TableHead>Departamento</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Progresso</TableHead>
              <TableHead>Prazo</TableHead>
              <TableHead>Concluído em</TableHead>
              {canRemove && <TableHead />}
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((r, i) => (
              <TableRow key={r.user_id ?? `former-${i}`}>
                <TableCell>{r.name ?? "—"}</TableCell>
                <TableCell>{r.department ?? "—"}</TableCell>
                <TableCell><VideoStatusBadge status={r.status} /></TableCell>
                <TableCell>{Math.round(r.progress_pct)}%</TableCell>
                <TableCell>{r.due_at ? new Date(r.due_at).toLocaleDateString("pt-BR") : "—"}</TableCell>
                <TableCell>{formatDateTime(r.completed_at)}</TableCell>
                {canRemove && (
                  <TableCell>
                    {r.user_id && (
                      <Button variant="ghost" size="sm" onClick={() => setRemoveTarget(r)}>
                        Tirar
                      </Button>
                    )}
                  </TableCell>
                )}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    );
  }

  return (
    <>
      <Dialog open={!!videoId} onOpenChange={(o) => !o && handleClose()}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{video?.title ?? "Vídeo"}</DialogTitle>
            <DialogDescription>
              {video
                ? `${formatDuration(video.duration_seconds)} · Prazo: ${formatDueDays(video.due_days)}`
                : "Carregando..."}
            </DialogDescription>
          </DialogHeader>

          {isLoading && <p className="text-sm text-muted-foreground">Carregando...</p>}

          {data && video && (
            <div className="space-y-4">
              {video.archived_at && <Badge variant="secondary">Arquivado</Badge>}
              {video.description && <p className="text-sm whitespace-pre-line">{video.description}</p>}

              <div className="flex flex-wrap gap-2">
                <Button asChild variant="outline" size="sm">
                  <Link to={`/videos/${video.id}`}>Assistir</Link>
                </Button>
                <Button variant="outline" size="sm" onClick={() => setEditOpen(true)}>
                  Editar
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  disabled={replaceMut.isPending}
                  onClick={() => fileRef.current?.click()}
                >
                  Trocar arquivo
                </Button>
                <input
                  ref={fileRef}
                  type="file"
                  accept="video/mp4,.mp4"
                  className="hidden"
                  onChange={(e) => {
                    setPendingFile(e.target.files?.[0] ?? null);
                    e.target.value = "";
                  }}
                />
                <Button
                  variant="outline"
                  size="sm"
                  disabled={archiveMut.isPending}
                  onClick={() => archiveMut.mutate(!video.archived_at)}
                >
                  {video.archived_at ? "Reativar" : "Arquivar"}
                </Button>
                <Button variant="destructive" size="sm" onClick={() => setDeleteOpen(true)}>
                  Excluir
                </Button>
              </div>

              {uploadProgress !== null && (
                <div className="space-y-1">
                  <Progress value={uploadProgress} />
                  <div className="flex items-center justify-between text-xs text-muted-foreground">
                    <span>Enviando novo arquivo... {Math.round(uploadProgress)}%</span>
                    <Button variant="ghost" size="sm" onClick={() => abortRef.current?.abort()}>
                      Cancelar envio
                    </Button>
                  </div>
                </div>
              )}

              <div className="flex flex-wrap gap-2">
                <Select value={statusFilter} onValueChange={setStatusFilter}>
                  <SelectTrigger className="w-44"><SelectValue placeholder="Status" /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os status</SelectItem>
                    {STATUS_OPTIONS.map((o) => (
                      <SelectItem key={o.value} value={o.value}>{o.label}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <Select value={deptFilter} onValueChange={setDeptFilter}>
                  <SelectTrigger className="w-52"><SelectValue placeholder="Departamento" /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os departamentos</SelectItem>
                    {departments.map((d) => (
                      <SelectItem key={d} value={d}>{d === NO_DEPARTMENT ? "Sem departamento" : d}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <Tabs defaultValue="required">
                <TabsList>
                  <TabsTrigger value="required">Obrigatórios ({data.required.length})</TabsTrigger>
                  <TabsTrigger value="voluntary">Voluntários ({data.voluntary.length})</TabsTrigger>
                  <TabsTrigger value="former">Ex-colaboradores ({data.former.length})</TabsTrigger>
                </TabsList>
                <TabsContent value="required">{renderTable(data.required, true)}</TabsContent>
                <TabsContent value="voluntary">{renderTable(data.voluntary, false)}</TabsContent>
                <TabsContent value="former">{renderTable(data.former, false)}</TabsContent>
              </Tabs>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {video && (
        <VideoFormDialog
          open={editOpen}
          onOpenChange={setEditOpen}
          video={{
            id: video.id,
            title: video.title,
            description: video.description,
            due_days: video.due_days,
            rules: data!.rules,
          }}
        />
      )}

      <AlertDialog open={!!pendingFile} onOpenChange={(o) => !o && setPendingFile(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Trocar o arquivo do vídeo</AlertDialogTitle>
            <AlertDialogDescription>
              Como tratar quem já assistiu? Quem concluiu pode continuar concluído, ou todos
              voltam a pendente e precisam assistir de novo. O arquivo antigo será apagado.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter className="sm:flex-wrap">
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction onClick={() => startReplace("keep_completed")}>
              Manter quem já concluiu
            </AlertDialogAction>
            <AlertDialogAction onClick={() => startReplace("reset_all")}>
              Todos precisam assistir de novo
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog open={!!removeTarget} onOpenChange={(o) => !o && setRemoveTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Tirar {removeTarget?.name ?? "pessoa"} deste vídeo?</AlertDialogTitle>
            <AlertDialogDescription>
              A pessoa deixa de ser obrigada a assistir e o progresso dela neste vídeo é apagado.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              onClick={(e) => {
                e.preventDefault();
                if (removeTarget?.user_id) removeMut.mutate(removeTarget.user_id);
              }}
            >
              Tirar
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog open={deleteOpen} onOpenChange={setDeleteOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir "{video?.title}"?</AlertDialogTitle>
            <AlertDialogDescription>
              O arquivo e todo o histórico de quem assistiu serão apagados de vez. Não dá para
              desfazer. Se quiser apenas esconder o vídeo, use Arquivar.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              onClick={(e) => {
                e.preventDefault();
                deleteMut.mutate();
              }}
            >
              Excluir
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
