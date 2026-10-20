import { useEffect, useRef, useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { videos } from "@/lib/api";
import type { VideoRules } from "@/lib/api";
import { uploadVideoFile } from "@/lib/videoUpload";
import { isEmptyAudience } from "@/lib/videoFormat";
import { AudiencePicker } from "./AudiencePicker";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Progress } from "@/components/ui/progress";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";

export type EditableVideo = {
  id: string;
  title: string;
  description: string | null;
  due_days: number | null;
  rules: VideoRules;
};

type Props = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Quando informado, o diálogo edita os dados e as regras (sem trocar o arquivo). */
  video?: EditableVideo;
};

const EMPTY_RULES: VideoRules = { all: false, department_ids: [], user_ids: [] };

export function VideoFormDialog({ open, onOpenChange, video }: Props) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const fileRef = useRef<HTMLInputElement>(null);
  const abortRef = useRef<AbortController | null>(null);

  const [file, setFile] = useState<File | null>(null);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [dueDays, setDueDays] = useState("");
  const [rules, setRules] = useState<VideoRules>(EMPTY_RULES);
  const [progress, setProgress] = useState(0);
  const [uploading, setUploading] = useState(false);

  useEffect(() => {
    if (!open) return;
    setFile(null);
    setProgress(0);
    setUploading(false);
    setTitle(video?.title ?? "");
    setDescription(video?.description ?? "");
    setDueDays(video?.due_days != null ? String(video.due_days) : "");
    setRules(video?.rules ?? EMPTY_RULES);
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reset only when opening or switching video, not on parent re-renders
  }, [open, video?.id]);

  useEffect(() => () => abortRef.current?.abort(), []);

  const dueNumber = dueDays.trim() === "" ? null : Number(dueDays);
  const dueInvalid = dueNumber !== null && (!Number.isInteger(dueNumber) || dueNumber < 1);

  const refresh = () => {
    qc.invalidateQueries({ queryKey: ["admin-videos"] });
    if (video) qc.invalidateQueries({ queryKey: ["admin-video", video.id] });
  };

  const saveMut = useMutation({
    mutationFn: async () => {
      const payload = {
        title: title.trim(),
        description: description.trim() || null,
        due_days: dueNumber,
        rules,
      };
      if (video) return videos.update(video.id, payload);
      const controller = new AbortController();
      abortRef.current = controller;
      setUploading(true);
      setProgress(0);
      try {
        const { upload_id } = await uploadVideoFile(file!, {
          onProgress: setProgress,
          signal: controller.signal,
        });
        try {
          return await videos.create({ upload_id, ...payload });
        } catch (e) {
          videos.cancel(upload_id).catch(() => undefined);
          throw e;
        }
      } finally {
        abortRef.current = null;
        setUploading(false);
      }
    },
    onSuccess: () => {
      refresh();
      toast({ title: video ? "Vídeo atualizado" : "Vídeo criado" });
      onOpenChange(false);
    },
    onError: (e: Error) => {
      if (e instanceof DOMException && e.name === "AbortError") return;
      toast({ title: "Erro", description: e.message, variant: "destructive" });
    },
  });

  const busy = saveMut.isPending;
  const canSubmit =
    !!title.trim() && !dueInvalid && (!!video || (!isEmptyAudience(rules) && !!file)) && !busy;

  const handleOpenChange = (next: boolean) => {
    if (!next) abortRef.current?.abort();
    onOpenChange(next);
  };

  return (
    <Dialog open={open} onOpenChange={handleOpenChange}>
      <DialogContent className="max-w-xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{video ? "Editar vídeo" : "Novo vídeo"}</DialogTitle>
          <DialogDescription>
            {video
              ? "Altere os dados e quem deve assistir. Para trocar o arquivo, use o detalhe do vídeo."
              : "Envie um arquivo MP4 de até 2 GB e escolha quem deve assisti-lo."}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4">
          {!video && (
            <div className="space-y-2">
              <Label htmlFor="video-file">Arquivo (MP4)</Label>
              <Input
                id="video-file"
                ref={fileRef}
                type="file"
                accept="video/mp4,.mp4"
                disabled={busy}
                onChange={(e) => setFile(e.target.files?.[0] ?? null)}
              />
              {uploading && (
                <div className="space-y-1">
                  <Progress value={progress} />
                  <p className="text-xs text-muted-foreground">Enviando... {Math.round(progress)}%</p>
                </div>
              )}
            </div>
          )}

          <div className="space-y-2">
            <Label htmlFor="video-title">Título</Label>
            <Input id="video-title" value={title} maxLength={200} onChange={(e) => setTitle(e.target.value)} />
          </div>

          <div className="space-y-2">
            <Label htmlFor="video-desc">Descrição (opcional)</Label>
            <Textarea id="video-desc" value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>

          <div className="space-y-2">
            <Label htmlFor="video-due">Prazo em dias (opcional)</Label>
            <Input
              id="video-due"
              type="number"
              min={1}
              placeholder="Sem prazo"
              value={dueDays}
              onChange={(e) => setDueDays(e.target.value)}
            />
            {dueInvalid && <p className="text-xs text-destructive">Informe um número inteiro maior que zero.</p>}
          </div>

          <div className="space-y-2">
            <Label>Quem deve assistir</Label>
            <AudiencePicker value={rules} onChange={setRules} />
            {video && (
              <p className="text-xs text-muted-foreground">
                Desmarcar um grupo ou pessoa não retira quem já recebeu o vídeo. Para tirar alguém, use “Tirar” no detalhe do vídeo.
              </p>
            )}
            {!video && isEmptyAudience(rules) && (
              <p className="text-xs text-muted-foreground">Selecione ao menos um grupo ou pessoa.</p>
            )}
          </div>
        </div>

        <DialogFooter>
          {uploading && (
            <Button variant="outline" onClick={() => abortRef.current?.abort()}>
              Cancelar envio
            </Button>
          )}
          <Button variant="outline" onClick={() => handleOpenChange(false)}>
            Cancelar
          </Button>
          <Button disabled={!canSubmit} onClick={() => saveMut.mutate()}>
            {busy ? (uploading ? "Enviando..." : "Salvando...") : "Salvar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
