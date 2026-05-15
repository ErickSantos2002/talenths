import { useState, useEffect } from "react";
import { format } from "date-fns";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Users, ClipboardList, Building2, Link2, TrendingUp, Plus, Copy, Loader2, Power, Pencil } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { toast } from "@/hooks/use-toast";

export default function CompanyDashboardPage() {
  const { profile, hasRole } = useAuth();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({ collaborators: 0, tests: 0, pending: 0, departments: 0 });
  const [departments, setDepartments] = useState<any[]>([]);
  const [deptCompatibility, setDeptCompatibility] = useState<Record<string, { score: number | null; testedCount: number }>>({});
  const [invitations, setInvitations] = useState<any[]>([]);
  const [inviteOpen, setInviteOpen] = useState(false);
  const [inviteDeptId, setInviteDeptId] = useState("");
  const [inviteMaxUses, setInviteMaxUses] = useState("");
  const [inviteDescription, setInviteDescription] = useState("");
  const [creating, setCreating] = useState(false);
  const [editInvite, setEditInvite] = useState<any>(null);
  const [editDescription, setEditDescription] = useState("");
  const [editMaxUses, setEditMaxUses] = useState("");
  const [editDeptId, setEditDeptId] = useState("");

  const isMasterAdmin = hasRole("master_admin");
  const { selectedCompanyId } = useAuth();

  const companyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;

  useEffect(() => {
    if (!companyId) return;
    fetchAll();
  }, [companyId]);

  const fetchAll = async () => {
    if (!companyId) return;
    setLoading(true);

    const [profilesRes, deptsRes, invitesRes] = await Promise.all([
      supabase.from("profiles").select("user_id, department_id", { count: "exact" }).eq("company_id", companyId),
      supabase.from("departments").select("*").eq("company_id", companyId).order("name"),
      supabase.from("test_invitations" as any).select("*").eq("company_id", companyId).order("created_at", { ascending: false }),
    ]);

    const allProfiles = profilesRes.data ?? [];
    const userIds = allProfiles.map((p) => p.user_id);
    const testsRes = userIds.length > 0
      ? await supabase.from("test_results").select("id", { count: "exact" }).in("user_id", userIds)
      : { count: 0 };

    const collabCount = profilesRes.count ?? 0;
    const testCount = (testsRes as any).count ?? 0;

    setStats({
      collaborators: collabCount,
      tests: testCount,
      pending: collabCount - testCount,
      departments: deptsRes.data?.length ?? 0,
    });
    setDepartments(deptsRes.data ?? []);
    setInvitations((invitesRes.data as any[]) ?? []);

    // Batch fetch all test_results for company users with department
    const deptUserIds = allProfiles.filter((p: any) => p.department_id).map((p: any) => p.user_id);
    let allTestResults: any[] = [];
    if (deptUserIds.length > 0) {
      const { data: trData } = await supabase
        .from("test_results")
        .select("user_id, disc_natural, completed_at")
        .in("user_id", deptUserIds)
        .order("completed_at", { ascending: false });
      allTestResults = trData ?? [];
    }

    // Group latest test per user
    const latestTestByUser: Record<string, { D: number; I: number; S: number; C: number }> = {};
    for (const tr of allTestResults) {
      if (!latestTestByUser[tr.user_id]) {
        const disc = tr.disc_natural as any;
        if (disc && typeof disc.D === "number") {
          latestTestByUser[tr.user_id] = disc;
        }
      }
    }

    // Calculate compatibility per department
    const deptCompat: Record<string, { score: number | null; testedCount: number }> = {};
    for (const dept of (deptsRes.data ?? [])) {
      const deptProfiles = allProfiles.filter((p: any) => p.department_id === dept.id);
      const deptDiscs = deptProfiles
        .map((p: any) => latestTestByUser[p.user_id])
        .filter(Boolean);

      if (deptDiscs.length < 2) {
        deptCompat[dept.id] = { score: null, testedCount: deptDiscs.length };
      } else {
        let totalScore = 0;
        let pairCount = 0;
        for (let i = 0; i < deptDiscs.length; i++) {
          for (let j = i + 1; j < deptDiscs.length; j++) {
            const d1 = deptDiscs[i];
            const d2 = deptDiscs[j];
            const avgDiff = (Math.abs(d1.D - d2.D) + Math.abs(d1.I - d2.I) + Math.abs(d1.S - d2.S) + Math.abs(d1.C - d2.C)) / 4;
            totalScore += 100 - avgDiff;
            pairCount++;
          }
        }
        deptCompat[dept.id] = { score: Math.round(totalScore / pairCount), testedCount: deptDiscs.length };
      }
    }
    setDeptCompatibility(deptCompat);

    setLoading(false);
  };

  const handleCreateInvite = async () => {
    if (!companyId || !profile) return;
    setCreating(true);

    const { error } = await supabase.from("test_invitations" as any).insert({
      company_id: companyId,
      department_id: inviteDeptId || null,
      invited_by: profile.user_id,
      max_uses: inviteMaxUses ? parseInt(inviteMaxUses) : null,
      description: inviteDescription.trim() || null,
    } as any);

    if (error) {
      toast({ title: "Erro ao criar convite", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Convite criado com sucesso!" });
      setInviteOpen(false);
      setInviteDeptId("");
      setInviteMaxUses("");
      setInviteDescription("");
      fetchAll();
    }
    setCreating(false);
  };

  const copyLink = (token: string) => {
    const url = `${window.location.origin}/convite/${token}`;
    navigator.clipboard.writeText(url);
    toast({ title: "Link copiado!" });
  };

  const toggleInvite = async (inviteId: string, currentActive: boolean) => {
    const { error } = await supabase
      .from("test_invitations" as any)
      .update({ is_active: !currentActive } as any)
      .eq("id", inviteId);
    if (error) {
      toast({ title: "Erro ao atualizar convite", description: error.message, variant: "destructive" });
    } else {
      toast({ title: currentActive ? "Convite desativado" : "Convite reativado" });
      fetchAll();
    }
  };

  const handleEditInvite = (inv: any) => {
    setEditInvite(inv);
    setEditDescription(inv.description || "");
    setEditMaxUses(inv.max_uses ? String(inv.max_uses) : "");
    setEditDeptId(inv.department_id || "");
  };

  const handleSaveEdit = async () => {
    if (!editInvite) return;
    setCreating(true);
    const { error } = await supabase
      .from("test_invitations" as any)
      .update({
        description: editDescription.trim() || null,
        max_uses: editMaxUses ? parseInt(editMaxUses) : null,
        department_id: editDeptId || null,
      } as any)
      .eq("id", editInvite.id);
    if (error) {
      toast({ title: "Erro ao editar convite", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Convite atualizado!" });
      setEditInvite(null);
      fetchAll();
    }
    setCreating(false);
  };

  const statCards = [
    { title: "Colaboradores", value: stats.collaborators, icon: Users, color: "text-primary" },
    { title: "Testes Realizados", value: stats.tests, icon: ClipboardList, color: "text-chart-4" },
    { title: "Pendentes", value: stats.pending, icon: TrendingUp, color: "text-destructive" },
    { title: "Departamentos", value: stats.departments, icon: Building2, color: "text-brand-red" },
  ];

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
         <div className="flex items-center justify-between gap-4">
          <h1 className="text-2xl font-bold text-foreground">
            {isMasterAdmin ? "Gestão de Empresa" : "Minha Empresa"}
          </h1>
        </div>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {statCards.map((s) => (
            <Card key={s.title} className="shadow-card">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">{s.title}</CardTitle>
                <s.icon className={`h-5 w-5 ${s.color}`} />
              </CardHeader>
              <CardContent>
                {loading ? <Skeleton className="h-9 w-12" /> : <div className="text-3xl font-bold text-card-foreground">{s.value}</div>}
              </CardContent>
            </Card>
          ))}
        </div>

        <Tabs defaultValue="invites">
          <TabsList>
            <TabsTrigger value="departments">Departamentos</TabsTrigger>
            <TabsTrigger value="invites">Convites</TabsTrigger>
          </TabsList>

          <TabsContent value="departments" className="mt-4">
            <Card>
              <CardContent className="p-6">
                {loading ? (
                  <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
                ) : departments.length === 0 ? (
                  <p className="text-center text-muted-foreground py-8">Nenhum departamento cadastrado.</p>
                ) : (
                  <div className="space-y-2">
                    {departments.map((d) => {
                      const compat = deptCompatibility[d.id];
                      const score = compat?.score;
                      const testedCount = compat?.testedCount ?? 0;
                      const colorClass = score == null ? "" : score >= 75 ? "bg-chart-4/15 text-chart-4 border-chart-4/30" : score >= 50 ? "bg-yellow-500/15 text-yellow-600 border-yellow-500/30" : "bg-destructive/15 text-destructive border-destructive/30";
                      return (
                        <div key={d.id} className="flex items-center justify-between rounded-lg border border-border p-3">
                          <span className="font-medium text-foreground">{d.name}</span>
                          <div className="flex items-center gap-3">
                            <span className="text-xs text-muted-foreground">{testedCount} com teste</span>
                            {score != null ? (
                              <Badge variant="outline" className={`${colorClass} text-xs`}>
                                Compatibilidade: {score}%
                              </Badge>
                            ) : (
                              <Badge variant="outline" className="text-xs text-muted-foreground">Sem dados</Badge>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="invites" className="mt-4 space-y-4">
            <div className="flex justify-end">
              <Button onClick={() => setInviteOpen(true)} className="gap-2">
                <Plus className="h-4 w-4" />
                Gerar Convite
              </Button>
            </div>
            <Card>
              <CardContent className="p-6">
                {loading ? (
                  <div className="space-y-3">{[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}</div>
                ) : invitations.length === 0 ? (
                  <p className="text-center text-muted-foreground py-8">Nenhum convite criado.</p>
                ) : (
                  <div className="space-y-3">
                    {invitations.map((inv: any) => (
                      <div key={inv.id} className="flex items-center justify-between gap-4 rounded-lg border border-border p-3">
                        <div className="min-w-0 flex-1">
                          <div className="flex items-center gap-2">
                            <Link2 className="h-4 w-4 text-primary shrink-0" />
                            <code className="text-xs truncate text-muted-foreground">{`${window.location.origin}/convite/${inv.token}`}</code>
                          </div>
                          {inv.description && (
                            <p className="mt-1 text-sm text-foreground">{inv.description}</p>
                          )}
                          <div className="mt-1 flex flex-wrap gap-2 text-xs text-muted-foreground">
                            <span>Criado em: {format(new Date(inv.created_at), "dd/MM/yyyy HH:mm")}</span>
                            <span>Usos: {inv.used_count}{inv.max_uses ? `/${inv.max_uses}` : ""}</span>
                            {inv.is_active ? (
                              <Badge variant="outline" className="bg-chart-4/15 text-chart-4 border-chart-4/30 text-[10px]">Ativo</Badge>
                            ) : (
                              <Badge variant="outline" className="text-[10px]">Inativo</Badge>
                            )}
                          </div>
                        </div>
                        <div className="flex items-center gap-1">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => toggleInvite(inv.id, !!inv.is_active)}
                            title={inv.is_active ? "Desativar convite" : "Reativar convite"}
                            className={inv.is_active ? "text-destructive hover:text-destructive" : "text-chart-4 hover:text-chart-4"}
                          >
                            <Power className="h-4 w-4" />
                          </Button>
                          <Button size="sm" variant="ghost" onClick={() => copyLink(inv.token)}>
                            <Copy className="h-4 w-4" />
                          </Button>
                          <Button size="sm" variant="ghost" onClick={() => handleEditInvite(inv)} title="Editar convite">
                            <Pencil className="h-4 w-4" />
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>

      <Dialog open={inviteOpen} onOpenChange={setInviteOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Gerar Convite</DialogTitle>
            <DialogDescription>Crie um link de convite para novos colaboradores.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Departamento (opcional)</Label>
              <Select value={inviteDeptId || "none"} onValueChange={(v) => setInviteDeptId(v === "none" ? "" : v)}>
                <SelectTrigger><SelectValue placeholder="Sem departamento" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {departments.map((d) => <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Limite de usos (opcional)</Label>
              <Input type="number" value={inviteMaxUses} onChange={(e) => setInviteMaxUses(e.target.value)} placeholder="Ilimitado" />
            </div>
            <div className="space-y-2">
              <Label>Descrição (opcional)</Label>
              <Input value={inviteDescription} onChange={(e) => setInviteDescription(e.target.value)} placeholder="Ex: Convite para equipe de vendas" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setInviteOpen(false)}>Cancelar</Button>
            <Button onClick={handleCreateInvite} disabled={creating}>
              {creating ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
              Criar Convite
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!editInvite} onOpenChange={(open) => { if (!open) setEditInvite(null); }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Editar Convite</DialogTitle>
            <DialogDescription>Altere os campos do convite.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Departamento (opcional)</Label>
              <Select value={editDeptId || "none"} onValueChange={(v) => setEditDeptId(v === "none" ? "" : v)}>
                <SelectTrigger><SelectValue placeholder="Sem departamento" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {departments.map((d) => <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Limite de usos (opcional)</Label>
              <Input type="number" value={editMaxUses} onChange={(e) => setEditMaxUses(e.target.value)} placeholder="Ilimitado" />
            </div>
            <div className="space-y-2">
              <Label>Descrição (opcional)</Label>
              <Input value={editDescription} onChange={(e) => setEditDescription(e.target.value)} placeholder="Ex: Convite para equipe de vendas" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditInvite(null)}>Cancelar</Button>
            <Button onClick={handleSaveEdit} disabled={creating}>
              {creating ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
              Salvar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
}
