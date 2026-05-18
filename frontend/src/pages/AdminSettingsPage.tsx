import { useState, useEffect } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import { useAuth } from "@/contexts/AuthContext";
import { companies as companiesApi, departments as departmentsApi, profiles as profilesApi, auth as authApi } from "@/lib/api";
import { useToast } from "@/hooks/use-toast";
import { Settings, User, FolderTree, BarChart3, Plus, Pencil, Trash2, Lock } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";

interface Department {
  id: string;
  name: string;
  company_id: string;
  created_at: string;
  company_name: string;
}

interface Company {
  id: string;
  name: string;
}

interface PlatformStats {
  companies: number;
  collaborators: number;
  tests: number;
  departments: number;
}

export default function AdminSettingsPage() {
  const { user, profile, selectedCompanyId, hasRole } = useAuth();
  const isMasterAdmin = hasRole("master_admin");
  const effectiveCompanyId = isMasterAdmin ? selectedCompanyId : profile?.company_id;
  const { toast } = useToast();

  // Profile tab state
  const [profileName, setProfileName] = useState("");
  const [savingProfile, setSavingProfile] = useState(false);
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [savingPassword, setSavingPassword] = useState(false);

  // Departments tab state
  const [departments, setDepartments] = useState<Department[]>([]);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [loadingDepts, setLoadingDepts] = useState(true);
  const companyFilter = effectiveCompanyId ?? "all";
  const [deptDialogOpen, setDeptDialogOpen] = useState(false);
  const [editingDept, setEditingDept] = useState<Department | null>(null);
  const [deptName, setDeptName] = useState("");
  const [deptCompanyId, setDeptCompanyId] = useState("");
  const [savingDept, setSavingDept] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deletingDept, setDeletingDept] = useState<Department | null>(null);

  // Platform tab state
  const [stats, setStats] = useState<PlatformStats>({ companies: 0, collaborators: 0, tests: 0, departments: 0 });
  const [loadingStats, setLoadingStats] = useState(true);

  useEffect(() => {
    if (profile) setProfileName(profile.name);
  }, [profile]);

  useEffect(() => {
    fetchDepartments();
    fetchCompanies();
    fetchStats();
  }, []);

  const fetchDepartments = async () => {
    setLoadingDepts(true);
    try {
      const data = await departmentsApi.list();
      setDepartments(
        (data as Array<{ id: string; name: string; company_id: string; created_at: string; company_name?: string }>).map((d) => ({
          id: d.id,
          name: d.name,
          company_id: d.company_id,
          created_at: d.created_at,
          company_name: d.company_name ?? "—",
        }))
      );
    } catch {
      // silently fail — table will just be empty
    }
    setLoadingDepts(false);
  };

  const fetchCompanies = async () => {
    try {
      const data = await companiesApi.list();
      setCompanies(data as Company[]);
    } catch {
      // silently fail
    }
  };

  const fetchStats = async () => {
    setLoadingStats(true);
    try {
      const [companiesData, profilesData, deptsData] = await Promise.all([
        companiesApi.list(),
        profilesApi.list(),
        departmentsApi.list(),
      ]);
      // tests count comes from the profiles endpoint — approximate via available data
      setStats({
        companies: (companiesData as unknown[]).length,
        collaborators: (profilesData as unknown[]).length,
        tests: 0, // test_results count not directly available; set 0 or extend api if needed
        departments: (deptsData as unknown[]).length,
      });
    } catch {
      // silently fail
    }
    setLoadingStats(false);
  };

  // --- Profile handlers ---
  const handleSaveName = async () => {
    if (!profile || !profileName.trim()) return;
    setSavingProfile(true);
    try {
      await profilesApi.update({ name: profileName.trim() });
      toast({ title: "Nome atualizado com sucesso" });
    } catch (err: any) {
      toast({ title: "Erro ao salvar nome", description: err.message, variant: "destructive" });
    }
    setSavingProfile(false);
  };

  const handleChangePassword = async () => {
    if (!newPassword || newPassword.length < 6) {
      toast({ title: "A nova senha deve ter pelo menos 6 caracteres", variant: "destructive" });
      return;
    }
    if (newPassword !== confirmPassword) {
      toast({ title: "As senhas não coincidem", variant: "destructive" });
      return;
    }
    setSavingPassword(true);
    try {
      await authApi.updatePassword(newPassword);
      toast({ title: "Senha alterada com sucesso" });
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err: any) {
      toast({ title: "Erro ao alterar senha", description: err.message, variant: "destructive" });
    }
    setSavingPassword(false);
  };

  // --- Department handlers ---
  const openNewDept = () => {
    setEditingDept(null);
    setDeptName("");
    setDeptCompanyId(companies[0]?.id ?? "");
    setDeptDialogOpen(true);
  };

  const openEditDept = (dept: Department) => {
    setEditingDept(dept);
    setDeptName(dept.name);
    setDeptCompanyId(dept.company_id);
    setDeptDialogOpen(true);
  };

  const handleSaveDept = async () => {
    if (!deptName.trim() || !deptCompanyId) return;
    setSavingDept(true);
    try {
      if (editingDept) {
        await departmentsApi.update(editingDept.id, { name: deptName.trim(), company_id: deptCompanyId });
        toast({ title: "Departamento atualizado" });
      } else {
        await departmentsApi.create({ name: deptName.trim(), company_id: deptCompanyId });
        toast({ title: "Departamento criado" });
      }
    } catch (err: any) {
      toast({
        title: editingDept ? "Erro ao atualizar" : "Erro ao criar",
        description: err.message,
        variant: "destructive",
      });
    }
    setSavingDept(false);
    setDeptDialogOpen(false);
    fetchDepartments();
  };

  const handleDeleteDept = async () => {
    if (!deletingDept) return;
    try {
      await departmentsApi.delete(deletingDept.id);
      toast({ title: "Departamento excluído" });
    } catch (err: any) {
      toast({ title: "Erro ao excluir", description: err.message, variant: "destructive" });
    }
    setDeleteDialogOpen(false);
    setDeletingDept(null);
    fetchDepartments();
  };

  const filteredDepts = companyFilter === "all"
    ? departments
    : departments.filter((d) => d.company_id === companyFilter);

  const statCards = [
    { label: "Empresas", value: stats.companies, color: "text-primary" },
    { label: "Colaboradores", value: stats.collaborators, color: "text-primary" },
    { label: "Testes Realizados", value: stats.tests, color: "text-primary" },
    { label: "Departamentos", value: stats.departments, color: "text-primary" },
  ];

  return (
    <AdminLayout>
      <div className="space-y-6 animate-fade-in">
        <div className="flex items-center gap-3">
          <Settings className="h-7 w-7 text-primary" />
          <h1 className="text-2xl font-bold text-foreground">Configurações</h1>
        </div>

        <Tabs defaultValue="profile" className="w-full">
          <TabsList className="grid w-full grid-cols-3">
            <TabsTrigger value="profile" className="flex items-center gap-2">
              <User className="h-4 w-4" /> Perfil
            </TabsTrigger>
            <TabsTrigger value="departments" className="flex items-center gap-2">
              <FolderTree className="h-4 w-4" /> Departamentos
            </TabsTrigger>
            <TabsTrigger value="platform" className="flex items-center gap-2">
              <BarChart3 className="h-4 w-4" /> Plataforma
            </TabsTrigger>
          </TabsList>

          {/* ========== ABA PERFIL ========== */}
          <TabsContent value="profile" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="text-lg">Informações Pessoais</CardTitle>
                <CardDescription>Atualize seu nome de exibição</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Email</Label>
                  <Input value={profile?.email ?? ""} disabled />
                </div>
                <div className="space-y-2">
                  <Label>Nome</Label>
                  <Input
                    value={profileName}
                    onChange={(e) => setProfileName(e.target.value)}
                    placeholder="Seu nome"
                    maxLength={100}
                  />
                </div>
                <Button onClick={handleSaveName} disabled={savingProfile}>
                  {savingProfile ? "Salvando..." : "Salvar Nome"}
                </Button>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Lock className="h-4 w-4" /> Alterar Senha
                </CardTitle>
                <CardDescription>Defina uma nova senha para sua conta</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Nova Senha</Label>
                  <Input
                    type="password"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="Mínimo 6 caracteres"
                  />
                </div>
                <div className="space-y-2">
                  <Label>Confirmar Nova Senha</Label>
                  <Input
                    type="password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    placeholder="Repita a nova senha"
                  />
                </div>
                <Button onClick={handleChangePassword} disabled={savingPassword} variant="outline">
                  {savingPassword ? "Alterando..." : "Alterar Senha"}
                </Button>
              </CardContent>
            </Card>
          </TabsContent>

          {/* ========== ABA DEPARTAMENTOS ========== */}
          <TabsContent value="departments" className="space-y-4">
            <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
              <Button onClick={openNewDept} className="flex items-center gap-2">
                <Plus className="h-4 w-4" /> Novo Departamento
              </Button>
            </div>

            <Card>
              <CardContent className="p-0">
                {loadingDepts ? (
                  <div className="space-y-2 p-6">
                    {[1, 2, 3].map((i) => <Skeleton key={i} className="h-10 w-full" />)}
                  </div>
                ) : filteredDepts.length === 0 ? (
                  <p className="p-6 text-center text-muted-foreground">Nenhum departamento encontrado.</p>
                ) : (
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Nome</TableHead>
                        <TableHead>Empresa</TableHead>
                        <TableHead>Criado em</TableHead>
                        <TableHead className="text-right">Ações</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {filteredDepts.map((dept) => (
                        <TableRow key={dept.id}>
                          <TableCell className="font-medium">{dept.name}</TableCell>
                          <TableCell>
                            <Badge variant="outline">{dept.company_name}</Badge>
                          </TableCell>
                          <TableCell className="text-muted-foreground">
                            {new Date(dept.created_at).toLocaleDateString("pt-BR")}
                          </TableCell>
                          <TableCell className="text-right">
                            <div className="flex justify-end gap-2">
                              <Button size="icon" variant="ghost" onClick={() => openEditDept(dept)}>
                                <Pencil className="h-4 w-4" />
                              </Button>
                              <Button
                                size="icon"
                                variant="ghost"
                                className="text-destructive"
                                onClick={() => { setDeletingDept(dept); setDeleteDialogOpen(true); }}
                              >
                                <Trash2 className="h-4 w-4" />
                              </Button>
                            </div>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </CardContent>
            </Card>

            {/* Dialog criar/editar departamento */}
            <Dialog open={deptDialogOpen} onOpenChange={setDeptDialogOpen}>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>{editingDept ? "Editar Departamento" : "Novo Departamento"}</DialogTitle>
                  <DialogDescription>
                    {editingDept ? "Altere os dados do departamento." : "Preencha os dados para criar um novo departamento."}
                  </DialogDescription>
                </DialogHeader>
                <div className="space-y-4 py-2">
                  <div className="space-y-2">
                    <Label>Nome</Label>
                    <Input value={deptName} onChange={(e) => setDeptName(e.target.value)} placeholder="Nome do departamento" maxLength={100} />
                  </div>
                  <div className="space-y-2">
                    <Label>Empresa</Label>
                    <Select value={deptCompanyId} onValueChange={setDeptCompanyId}>
                      <SelectTrigger>
                        <SelectValue placeholder="Selecione a empresa" />
                      </SelectTrigger>
                      <SelectContent>
                        {companies.map((c) => (
                          <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <DialogFooter>
                  <Button onClick={handleSaveDept} disabled={savingDept || !deptName.trim() || !deptCompanyId}>
                    {savingDept ? "Salvando..." : "Salvar"}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* AlertDialog excluir */}
            <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
              <AlertDialogContent>
                <AlertDialogHeader>
                  <AlertDialogTitle>Excluir departamento</AlertDialogTitle>
                  <AlertDialogDescription>
                    Tem certeza que deseja excluir o departamento "{deletingDept?.name}"? Esta ação não pode ser desfeita.
                  </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                  <AlertDialogCancel>Cancelar</AlertDialogCancel>
                  <AlertDialogAction onClick={handleDeleteDept} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                    Excluir
                  </AlertDialogAction>
                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>
          </TabsContent>

          {/* ========== ABA PLATAFORMA ========== */}
          <TabsContent value="platform" className="space-y-4">
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
              {loadingStats
                ? [1, 2, 3, 4].map((i) => (
                    <Card key={i}>
                      <CardContent className="p-6">
                        <Skeleton className="mb-2 h-4 w-24" />
                        <Skeleton className="h-8 w-16" />
                      </CardContent>
                    </Card>
                  ))
                : statCards.map((s) => (
                    <Card key={s.label}>
                      <CardContent className="p-6">
                        <p className="text-sm text-muted-foreground">{s.label}</p>
                        <p className={`text-3xl font-bold ${s.color}`}>{s.value}</p>
                      </CardContent>
                    </Card>
                  ))}
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </AdminLayout>
  );
}
