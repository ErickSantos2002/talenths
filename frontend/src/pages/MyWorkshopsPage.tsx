import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { workshops as workshopsApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { useToast } from "@/hooks/use-toast";
import { CalendarDays } from "lucide-react";
import { WorkshopCard } from "./WorkshopsAdminPage";

export default function MyWorkshopsPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: list = [], isLoading } = useQuery({
    queryKey: ["workshops"],
    queryFn: workshopsApi.list,
  });

  const registerMutation = useMutation({
    mutationFn: (id: string) => workshopsApi.register(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["workshops"] });
      toast({ title: "Inscrição realizada com sucesso!" });
    },
    onError: (e: Error) => toast({ title: "Erro", description: e.message, variant: "destructive" }),
  });

  const unregisterMutation = useMutation({
    mutationFn: (id: string) => workshopsApi.unregister(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["workshops"] });
      toast({ title: "Inscrição cancelada" });
    },
    onError: () => toast({ title: "Erro ao cancelar inscrição", variant: "destructive" }),
  });

  const myRegistered = list.filter(w => w.user_registration_status);
  const openWorkshops = list.filter(w => w.status === "open" && !w.user_registration_status);

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <CalendarDays className="h-6 w-6" /> Programa de Desenvolvimento
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            Workshops e treinamentos disponíveis para você
          </p>
        </div>

        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : list.length === 0 ? (
          <div className="rounded-xl border border-dashed p-16 text-center">
            <CalendarDays className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum workshop disponível no momento.</p>
          </div>
        ) : (
          <div className="space-y-6">
            {myRegistered.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Meus workshops
                </h2>
                {myRegistered.map(w => (
                  <WorkshopCard
                    key={w.id}
                    workshop={w}
                    onUnregister={w.status === "open" ? () => unregisterMutation.mutate(w.id) : undefined}
                  />
                ))}
              </section>
            )}

            {openWorkshops.length > 0 && (
              <section className="space-y-3">
                <h2 className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Disponíveis para inscrição
                </h2>
                {openWorkshops.map(w => (
                  <WorkshopCard
                    key={w.id}
                    workshop={w}
                    onRegister={() => registerMutation.mutate(w.id)}
                  />
                ))}
              </section>
            )}
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
