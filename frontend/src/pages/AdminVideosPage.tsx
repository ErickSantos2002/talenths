import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { videos } from "@/lib/api";
import { formatDueDays, formatDuration } from "@/lib/videoFormat";
import { AdminLayout } from "@/components/AdminLayout";
import { TablePagination } from "@/components/TablePagination";
import { VideoDetailDialog } from "@/components/videos/VideoDetailDialog";
import { VideoFormDialog } from "@/components/videos/VideoFormDialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { usePageSize } from "@/hooks/use-page-size";
import { useToast } from "@/hooks/use-toast";
import { ArrowDown, ArrowUp, Plus, Video } from "lucide-react";

export default function AdminVideosPage() {
  const [showCreate, setShowCreate] = useState(false);
  const [detailId, setDetailId] = useState<string | null>(null);
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = usePageSize("admin-videos");

  const { toast } = useToast();
  const queryClient = useQueryClient();
  const { data: list = [], isLoading } = useQuery({
    queryKey: ["admin-videos"],
    queryFn: () => videos.listAdmin(),
  });
  const lastOrder = list.reduce((max, v) => Math.max(max, v.order ?? 0), 0);
  const move = useMutation({
    mutationFn: ({ id, direction }: { id: string; direction: "up" | "down" }) => videos.move(id, direction),
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ["admin-videos"] });
      queryClient.invalidateQueries({ queryKey: ["my-videos"] });
    },
    onError: () => toast({ title: "Não foi possível mudar a ordem", variant: "destructive" }),
  });

  const totalPages = Math.max(1, Math.ceil(list.length / pageSize));
  const currentPage = Math.min(page, totalPages);
  const startIdx = (currentPage - 1) * pageSize;
  const endIdx = Math.min(startIdx + pageSize, list.length);
  const rows = list.slice(startIdx, endIdx);

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between" data-tour="admin-videos">
          <div className="flex items-center gap-2">
            <Video className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-semibold">Vídeos</h1>
          </div>
          <Button onClick={() => setShowCreate(true)} data-tour="admin-videos-new">
            <Plus className="h-4 w-4 mr-2" /> Novo vídeo
          </Button>
        </div>

        {isLoading && <p className="text-muted-foreground text-sm">Carregando...</p>}
        {!isLoading && list.length === 0 && (
          <p className="text-muted-foreground text-sm">Nenhum vídeo cadastrado.</p>
        )}

        {list.length > 0 && (
          <Card data-tour="admin-videos-list">
            <CardContent className="p-0">
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead className="w-32" data-tour="admin-videos-order">Ordem</TableHead>
                      <TableHead>Título</TableHead>
                      <TableHead>Duração</TableHead>
                      <TableHead>Prazo</TableHead>
                      <TableHead>Concluídos</TableHead>
                      <TableHead>Atrasados</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody data-tour="admin-videos-rows">
                    {rows.map((v) => (
                      <TableRow key={v.id} className="cursor-pointer" onClick={() => setDetailId(v.id)}>
                        <TableCell onClick={(e) => e.stopPropagation()} className="cursor-default">
                          {v.order === null ? (
                            <span className="text-muted-foreground">—</span>
                          ) : (
                            <div className="flex items-center gap-1">
                              <span className="w-6 font-semibold tabular-nums">{v.order}º</span>
                              <Button
                                variant="ghost"
                                size="icon"
                                className="h-7 w-7"
                                aria-label={`Subir ${v.title}`}
                                disabled={v.order === 1 || move.isPending}
                                onClick={() => move.mutate({ id: v.id, direction: "up" })}
                              >
                                <ArrowUp className="h-4 w-4" />
                              </Button>
                              <Button
                                variant="ghost"
                                size="icon"
                                className="h-7 w-7"
                                aria-label={`Descer ${v.title}`}
                                disabled={v.order === lastOrder || move.isPending}
                                onClick={() => move.mutate({ id: v.id, direction: "down" })}
                              >
                                <ArrowDown className="h-4 w-4" />
                              </Button>
                            </div>
                          )}
                        </TableCell>
                        <TableCell className="font-medium">
                          {v.title}
                          {v.archived_at && <Badge variant="secondary" className="ml-2">Arquivado</Badge>}
                        </TableCell>
                        <TableCell>{formatDuration(v.duration_seconds)}</TableCell>
                        <TableCell>{formatDueDays(v.due_days)}</TableCell>
                        <TableCell>{v.completed_count} / {v.required_count}</TableCell>
                        <TableCell className={v.overdue_count > 0 ? "text-destructive font-semibold" : "text-muted-foreground"}>
                          {v.overdue_count}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
              <TablePagination
                currentPage={currentPage}
                totalPages={totalPages}
                totalItems={list.length}
                startIdx={startIdx}
                endIdx={endIdx}
                onPage={setPage}
                onPrev={() => setPage(Math.max(1, currentPage - 1))}
                onNext={() => setPage(Math.min(totalPages, currentPage + 1))}
                pageSize={pageSize}
                onPageSizeChange={(size) => { setPageSize(size); setPage(1); }}
                itemLabel="vídeos"
              />
            </CardContent>
          </Card>
        )}
      </div>

      <VideoFormDialog open={showCreate} onOpenChange={setShowCreate} />
      <VideoDetailDialog videoId={detailId} onClose={() => setDetailId(null)} />
    </AdminLayout>
  );
}
