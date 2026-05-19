import { useState, useEffect } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import { departments as departmentsApi, collaborators as collaboratorsApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription,
} from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { Users, Building2, Pencil, Trash2, Search, Plus, KeyRound } from "lucide-react";

type AppRole = "master_admin" | "manager" | "user";

interface Collaborator {
  id: string;
  user_id: string;
  name: string;
  email: string;
  cpf: string | null;
  phone: string | null;
  birth_date: string | null;
  hire_date: string | null;
  company_id: string | null;
  department_id: string | null;
  departmentName: string | null;
  role: AppRole;
  roleId: string | null;
  hasTest: boolean;
}

interface Department {
  id: string;
  name: string;
  company_id: string;
}

const ROLE_PRIORITY: AppRole[] = ["master_admin", "manager", "user"];

const ROLE_LABELS: Record<AppRole, string> = {
  master_admin: "Administrador",
  manager: "Gerente",
  user: "Colaborador",
};

const ROLE_COLORS: Record<AppRole, string> = {
  master_admin: "bg-destructive/15 text-destructive border-destructive/30",
  manager: "bg-primary/15 text-primary border-primary/30",
  user: "bg-muted text-muted-foreground border-border",
};

function formatCpf(value: string): string {
  const digits = value.replace(/\D/g, "").slice(0, 11);
  if (digits.length <= 3) return digits;
  if (digits.length <= 6) return `${digits.slice(0, 3)}.${digits.slice(3)}`;
  if (digits.length <= 9) return `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6)}`;
  return `${digits.slice(0, 3)}.${digits.slice(3, 6)}.${digits.slice(6, 9)}-${digits.slice(9)}`;
}

function formatPhone(value: string): string {
  const digits = value.replace(/\D/g, "").slice(0, 11);
  if (digits.length <= 2) return digits.length ? `(${digits}` : "";
  if (digits.length <= 7) return `(${digits.slice(0, 2)}) ${digits.slice(2)}`;
  return `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`;
}

export default function AdminCollaboratorsPage() {
  const { toast } = useToast();
  const { roles: currentUserRoles, selectedCompanyId, profile: currentProfile } = useAuth();
  const isMasterAdmin = currentUserRoles.includes("master_admin");

  const [collaborators, setCollaborators] = useState<Collaborator[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [filterTestStatus, setFilterTestStatus] = useState<string>("all");

  // Edit dialog
  const [editOpen, setEditOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<Collaborator | null>(null);
  const [editName, setEditName] = useState("");
  const [editCpf, setEditCpf] = useState("");
  const [editPhone, setEditPhone] = useState("");
  const [editBirthDate, setEditBirthDate] = useState("");
  const [editHireDate, setEditHireDate] = useState("");
  const [editDeptId, setEditDeptId] = useState<string>("");
  const [editRole, setEditRole] = useState<AppRole>("user");
  const [saving, setSaving] = useState(false);

  // Add dialog
  const [addOpen, setAddOpen] = useState(false);
  const [addName, setAddName] = useState("");
  const [addCpf, setAddCpf] = useState("");
  const [addEmail, setAddEmail] = useState("");
  const [addPhone, setAddPhone] = useState("");
  const [addBirthDate, setAddBirthDate] = useState("");
  const [addHireDate, setAddHireDate] = useState("");
  const [addPassword, setAddPassword] = useState("");
  const [addDeptId, setAddDeptId] = useState("");
  const [addRole, setAddRole] = useState<AppRole>("user");
  const [adding, setAdding] = useState(false);

  // Reset password dialog
  const [resetTarget, setResetTarget] = useState<Collaborator | null>(null);
  const [resetPassword, setResetPassword] = useState("");
  const [resetting, setResetting] = useState(false);

  // Delete collaborator dialog
  const [deleteTarget, setDeleteTarget] = useState<Collaborator | null>(null);
  const [deleting, setDeleting] = useState(false);

  // ── Departments tab ──────────────────────────────────────────────────────────
  const [deptDialogOpen, setDeptDialogOpen] = useState(false);
  const [deptEditTarget, setDeptEditTarget] = useState<Department | null>(null);
  const [deptName, setDeptName] = useState("");
  const [deptSaving, setDeptSaving] = useState(false);
  const [deptDeleteTarget, setDeptDeleteTarget] = useState<Department | null>(null);
  const [deptDeleting, setDeptDeleting] = useState(false);

  const openAddDept = () => { setDeptEditTarget(null); setDeptName(""); setDeptDialogOpen(true); };
  const openEditDept = (d: Department) => { setDeptEditTarget(d); setDeptName(d.name); setDeptDialogOpen(true); };

  const handleSaveDept = async () => {
    if (!deptName.trim()) {
      toast({ title: "Nome do departamento é obrigatório", variant: "destructive" });
      return;
    }
    const companyId = selectedCompanyId ?? currentProfile?.company_id ?? null;
    if (!companyId) {
      toast({ title: "Empresa não identificada. Faça logout e entre novamente.", variant: "destructive" });
      return;
    }
    setDeptSaving(true);
    try {
      if (deptEditTarget) {
        await departmentsApi.update(deptEditTarget.id, { name: deptName.trim() });
        toast({ title: "Departamento atualizado" });
      } else {
        await departmentsApi.create({ name: deptName.trim(), company_id: companyId });
        toast({ title: "Departamento criado" });
      }
      setDeptDialogOpen(false);
      fetchData();
    } catch (err: any) {
      toast({ title: "Erro ao salvar departamento", description: err.message, variant: "destructive" });
    }
    setDeptSaving(false);
  };

  const handleDeleteDept = async () => {
    if (!deptDeleteTarget) return;
    setDeptDeleting(true);
    try {
      await departmentsApi.delete(deptDeleteTarget.id);
      toast({ title: "Departamento excluído" });
      fetchData();
    } catch (err: any) {
      toast({ title: "Erro ao excluir departamento", description: err.message, variant: "destructive" });
    }
    setDeptDeleting(false);
    setDeptDeleteTarget(null);
  };

  const fetchData = async () => {
    setLoading(true);
    try {
      const [collabsData, deptsData] = await Promise.all([
        collaboratorsApi.list(),
        departmentsApi.list(),
      ]);

      const typedDepts = (deptsData as Department[]) ?? [];
      const deptMap = new Map(typedDepts.map((d) => [d.id, d.name]));

      const collabs: Collaborator[] = (collabsData as any[]).map((p) => {
        const rolesList: { id: string; role: AppRole }[] = p.roles ?? [];
        const primaryRole =
          ROLE_PRIORITY.find((r) => rolesList.some((rl) => rl.role === r)) ?? "user";
        const primaryRoleId = rolesList.find((rl) => rl.role === primaryRole)?.id ?? null;

        return {
          id: p.id,
          user_id: p.user_id,
          name: p.name,
          email: p.email,
          cpf: p.cpf,
          phone: p.phone ?? null,
          birth_date: p.birth_date ?? null,
          hire_date: p.hire_date ?? null,
          company_id: p.company_id,
          department_id: p.department_id,
          departmentName: p.department_id ? deptMap.get(p.department_id) ?? null : null,
          role: primaryRole,
          roleId: primaryRoleId,
          hasTest: p.has_result ?? false,
        };
      });

      setCollaborators(collabs);
      setDepartments(typedDepts);
    } catch (err: any) {
      toast({ title: "Erro ao carregar colaboradores", description: err.message, variant: "destructive" });
    }
    setLoading(false);
  };

  useEffect(() => { fetchData(); }, []);

  const filtered = collaborators
    .filter((c) => {
      const matchesSearch =
        c.name.toLowerCase().includes(search.toLowerCase()) ||
        c.email.toLowerCase().includes(search.toLowerCase());
      const matchesTestStatus =
        filterTestStatus === "all" ||
        (filterTestStatus === "done" && c.hasTest) ||
        (filterTestStatus === "pending" && !c.hasTest);
      return matchesSearch && matchesTestStatus;
    })
    .sort((a, b) => ROLE_PRIORITY.indexOf(a.role) - ROLE_PRIORITY.indexOf(b.role));

  // --- Edit ---
  const openEdit = (collab: Collaborator) => {
    setEditTarget(collab);
    setEditName(collab.name);
    setEditCpf(collab.cpf ? formatCpf(collab.cpf) : "");
    setEditPhone(collab.phone ? formatPhone(collab.phone) : "");
    setEditBirthDate(collab.birth_date ? collab.birth_date.slice(0, 10) : "");
    setEditHireDate(collab.hire_date ? collab.hire_date.slice(0, 10) : "");
    setEditDeptId(collab.department_id ?? "");
    setEditRole(collab.role);
    setEditOpen(true);
  };

  const handleSave = async () => {
    if (!editTarget) return;
    const missingFields: string[] = [];
    if (!editName.trim()) missingFields.push("Nome");
    if (editCpf.trim() && editCpf.replace(/\D/g, "").length < 11) missingFields.push("CPF (deve ter 11 dígitos)");
    if (editPhone.trim() && editPhone.replace(/\D/g, "").length < 11) missingFields.push("Telefone (deve ter 11 dígitos)");
    if (missingFields.length > 0) {
      toast({ title: `Campos obrigatórios: ${missingFields.join(", ")}`, variant: "destructive" });
      return;
    }
    setSaving(true);
    try {
      await collaboratorsApi.update(editTarget.id, {
        name: editName,
        cpf: editCpf.replace(/\D/g, "") || null,
        phone: editPhone.replace(/\D/g, "") || null,
        birth_date: editBirthDate || null,
        hire_date: editHireDate || null,
        company_id: editTarget.company_id,
        department_id: editDeptId || null,
      });

      if (isMasterAdmin && editRole !== editTarget.role && editTarget.roleId) {
        await collaboratorsApi.updateRole(editTarget.roleId, editRole);
      }

      toast({ title: "Colaborador atualizado com sucesso" });
      setSaving(false);
      setEditOpen(false);
      fetchData();
    } catch (err: any) {
      toast({ title: "Erro ao atualizar colaborador", description: err.message, variant: "destructive" });
      setSaving(false);
    }
  };

  // --- Add ---
  const openAdd = () => {
    setAddName("");
    setAddCpf("");
    setAddEmail("");
    setAddPhone("");
    setAddBirthDate("");
    setAddHireDate("");
    setAddPassword("");
    setAddDeptId("");
    setAddRole("user");
    setAddOpen(true);
  };

  const handleAdd = async () => {
    const companyId = selectedCompanyId ?? currentProfile?.company_id ?? null;
    if (!companyId) {
      toast({ title: "Empresa não identificada. Faça logout e entre novamente.", variant: "destructive" });
      return;
    }
    const missingFields: string[] = [];
    if (!addName.trim()) missingFields.push("Nome");
    if (!addEmail.trim()) missingFields.push("Email");
    if (addCpf.trim() && addCpf.replace(/\D/g, "").length < 11) missingFields.push("CPF (deve ter 11 dígitos)");
    if (addPhone.trim() && addPhone.replace(/\D/g, "").length < 11) missingFields.push("Telefone (deve ter 11 dígitos)");
    if (missingFields.length > 0) {
      toast({ title: `Campos obrigatórios: ${missingFields.join(", ")}`, variant: "destructive" });
      return;
    }
    setAdding(true);
    try {
      await collaboratorsApi.create({
        email: addEmail.trim(),
        name: addName.trim(),
        company_id: companyId,
        department_id: addDeptId || null,
        cpf: addCpf.replace(/\D/g, "") || null,
        phone: addPhone.replace(/\D/g, "") || null,
        birth_date: addBirthDate || null,
        hire_date: addHireDate || null,
        password: addPassword.trim() || null,
        role: addRole,
        origin: window.location.origin,
      });
      toast({ title: "Colaborador criado com sucesso", description: addPassword.trim() ? "O colaborador pode fazer login com a senha definida." : "Um email de convite foi enviado para o colaborador definir sua senha." });
      setAdding(false);
      setAddOpen(false);
      fetchData();
    } catch (err: any) {
      toast({ title: "Erro ao criar colaborador", description: err.message, variant: "destructive" });
      setAdding(false);
    }
  };

  // --- Reset Password ---
  const openResetPassword = (collab: Collaborator) => {
    setResetTarget(collab);
    setResetPassword("");
    setResetting(false);
  };

  const handleResetPassword = async () => {
    if (!resetTarget || !resetPassword.trim()) return;
    setResetting(true);
    try {
      await collaboratorsApi.resetPassword(resetTarget.id, resetPassword.trim());
      toast({ title: "Senha redefinida com sucesso" });
      setResetTarget(null);
    } catch (err: any) {
      toast({ title: "Erro ao redefinir senha", description: err.message, variant: "destructive" });
    }
    setResetting(false);
  };

  // --- Delete ---
  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      await collaboratorsApi.delete(deleteTarget.id);
      toast({ title: "Colaborador excluído com sucesso" });
    } catch (err: any) {
      toast({ title: "Erro ao excluir colaborador", description: err.message, variant: "destructive" });
    }
    setDeleting(false);
    setDeleteTarget(null);
    fetchData();
  };

  const availableRoles: AppRole[] = ["manager", "user"];

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
            <Users className="h-6 w-6 text-primary" />
            Gestão de Colaboradores
          </h1>
          <p className="text-sm text-muted-foreground mt-1">
            Gerencie os colaboradores e departamentos da empresa
          </p>
        </div>

        <Tabs defaultValue="colaboradores">
          <TabsList>
            <TabsTrigger value="colaboradores" className="gap-2">
              <Users className="h-4 w-4" /> Colaboradores
            </TabsTrigger>
            <TabsTrigger value="departamentos" className="gap-2">
              <Building2 className="h-4 w-4" /> Departamentos
            </TabsTrigger>
          </TabsList>

          {/* ── Aba Colaboradores ─────────────────────────────────────────── */}
          <TabsContent value="colaboradores" className="space-y-4 mt-4">
            <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
                <div className="relative max-w-sm">
                  <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                  <Input
                    placeholder="Buscar por nome ou email..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    className="pl-9"
                  />
                </div>
                <Select value={filterTestStatus} onValueChange={setFilterTestStatus}>
                  <SelectTrigger className="w-full sm:w-[200px]">
                    <SelectValue placeholder="Status do teste" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os status</SelectItem>
                    <SelectItem value="done">Realizados</SelectItem>
                    <SelectItem value="pending">Pendentes</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <Button onClick={openAdd} className="gap-2 shrink-0">
                <Plus className="h-4 w-4" /> Adicionar Colaborador
              </Button>
            </div>

            <Card>
              <CardContent className="p-0">
                {loading ? (
                  <div className="space-y-4 p-6">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Skeleton key={i} className="h-12 w-full" />
                    ))}
                  </div>
                ) : filtered.length === 0 ? (
                  <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
                    <Users className="h-12 w-12 mb-4 opacity-40" />
                    <p className="text-lg font-medium">
                      {search ? "Nenhum colaborador encontrado" : "Nenhum colaborador cadastrado"}
                    </p>
                  </div>
                ) : (
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Nome</TableHead>
                        <TableHead className="hidden sm:table-cell">Email</TableHead>
                        <TableHead className="hidden lg:table-cell">Telefone</TableHead>
                        <TableHead className="hidden lg:table-cell">Departamento</TableHead>
                        <TableHead>Cargo</TableHead>
                        <TableHead className="hidden sm:table-cell">Teste</TableHead>
                        <TableHead className="text-right">Ações</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {filtered.map((collab) => (
                        <TableRow key={collab.id}>
                          <TableCell className="font-medium">{collab.name}</TableCell>
                          <TableCell className="hidden sm:table-cell text-muted-foreground text-sm">{collab.email}</TableCell>
                          <TableCell className="hidden lg:table-cell text-sm">{collab.phone ? formatPhone(collab.phone) : "—"}</TableCell>
                          <TableCell className="hidden lg:table-cell text-sm">{collab.departmentName ?? "—"}</TableCell>
                          <TableCell>
                            <Badge variant="outline" className={ROLE_COLORS[collab.role]}>
                              {ROLE_LABELS[collab.role]}
                            </Badge>
                          </TableCell>
                          <TableCell className="hidden sm:table-cell">
                            {collab.hasTest ? (
                              <Badge variant="outline" className="bg-chart-4/15 text-chart-4 border-chart-4/30">
                                Realizado
                              </Badge>
                            ) : (
                              <Badge variant="outline" className="bg-yellow-500/15 text-yellow-600 border-yellow-500/30">
                                Pendente
                              </Badge>
                            )}
                          </TableCell>
                          <TableCell className="text-right">
                            <div className="flex justify-end gap-1">
                              <Button variant="ghost" size="icon" onClick={() => openEdit(collab)} title="Editar">
                                <Pencil className="h-4 w-4" />
                              </Button>
                              <Button variant="ghost" size="icon" onClick={() => openResetPassword(collab)} title="Redefinir senha">
                                <KeyRound className="h-4 w-4" />
                              </Button>
                              {isMasterAdmin && (
                                <Button variant="ghost" size="icon" onClick={() => setDeleteTarget(collab)} title="Excluir" className="text-destructive hover:text-destructive">
                                  <Trash2 className="h-4 w-4" />
                                </Button>
                              )}
                            </div>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          {/* ── Aba Departamentos ─────────────────────────────────────────── */}
          <TabsContent value="departamentos" className="space-y-4 mt-4">
            <div className="flex justify-end">
              <Button onClick={openAddDept} className="gap-2">
                <Plus className="h-4 w-4" /> Novo Departamento
              </Button>
            </div>
            <Card>
              <CardContent className="p-0">
                {loading ? (
                  <div className="space-y-4 p-6">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <Skeleton key={i} className="h-12 w-full" />
                    ))}
                  </div>
                ) : departments.length === 0 ? (
                  <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
                    <Building2 className="h-12 w-12 mb-4 opacity-40" />
                    <p className="text-lg font-medium">Nenhum departamento cadastrado</p>
                    <p className="text-sm mt-1">Crie o primeiro departamento para organizar os colaboradores</p>
                  </div>
                ) : (
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Nome</TableHead>
                        <TableHead className="hidden sm:table-cell text-muted-foreground">Colaboradores</TableHead>
                        <TableHead className="text-right">Ações</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {departments.map((dept) => {
                        const count = collaborators.filter((c) => c.department_id === dept.id).length;
                        return (
                          <TableRow key={dept.id}>
                            <TableCell className="font-medium">{dept.name}</TableCell>
                            <TableCell className="hidden sm:table-cell text-muted-foreground text-sm">{count}</TableCell>
                            <TableCell className="text-right">
                              <div className="flex justify-end gap-1">
                                <Button variant="ghost" size="icon" onClick={() => openEditDept(dept)} title="Editar">
                                  <Pencil className="h-4 w-4" />
                                </Button>
                                <Button variant="ghost" size="icon" onClick={() => setDeptDeleteTarget(dept)} title="Excluir" className="text-destructive hover:text-destructive">
                                  <Trash2 className="h-4 w-4" />
                                </Button>
                              </div>
                            </TableCell>
                          </TableRow>
                        );
                      })}
                    </TableBody>
                  </Table>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>

      {/* Add Dialog */}
      <Dialog open={addOpen} onOpenChange={setAddOpen}>
        <DialogContent className="max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Adicionar Colaborador</DialogTitle>
            <DialogDescription>Preencha os dados do novo colaborador.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Nome *</Label>
              <Input value={addName} onChange={(e) => setAddName(e.target.value)} placeholder="Nome completo" />
            </div>
            <div className="space-y-2">
              <Label>Email *</Label>
              <Input value={addEmail} onChange={(e) => setAddEmail(e.target.value)} placeholder="email@exemplo.com" type="email" />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>CPF</Label>
                <Input value={addCpf} onChange={(e) => setAddCpf(formatCpf(e.target.value))} placeholder="000.000.000-00" />
              </div>
              <div className="space-y-2">
                <Label>Telefone</Label>
                <Input value={addPhone} onChange={(e) => setAddPhone(formatPhone(e.target.value))} placeholder="(00) 00000-0000" />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Data de Nascimento</Label>
                <Input type="date" value={addBirthDate} onChange={(e) => setAddBirthDate(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>Data de Admissão</Label>
                <Input type="date" value={addHireDate} onChange={(e) => setAddHireDate(e.target.value)} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Departamento</Label>
              <Select value={addDeptId || "none"} onValueChange={(v) => setAddDeptId(v === "none" ? "" : v)}>
                <SelectTrigger>
                  <SelectValue placeholder="Selecione o departamento" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {departments.map((d) => (
                    <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Senha</Label>
              <Input
                type="password"
                value={addPassword}
                onChange={(e) => setAddPassword(e.target.value)}
                placeholder="Deixe em branco para enviar convite por email"
              />
            </div>
            <div className="space-y-2">
              <Label>Cargo *</Label>
              <Select value={addRole} onValueChange={(v) => setAddRole(v as AppRole)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {availableRoles.map((r) => (
                    <SelectItem key={r} value={r}>{ROLE_LABELS[r]}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setAddOpen(false)}>Cancelar</Button>
            <Button onClick={handleAdd} disabled={adding}>
              {adding ? "Criando..." : "Criar Colaborador"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Edit Dialog */}
      <Dialog open={editOpen} onOpenChange={setEditOpen}>
        <DialogContent className="max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Editar Colaborador</DialogTitle>
            <DialogDescription>
              Altere os dados de <strong>{editTarget?.name}</strong>.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Nome *</Label>
              <Input value={editName} onChange={(e) => setEditName(e.target.value)} />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>CPF</Label>
                <Input value={editCpf} onChange={(e) => setEditCpf(formatCpf(e.target.value))} placeholder="000.000.000-00" />
              </div>
              <div className="space-y-2">
                <Label>Telefone</Label>
                <Input value={editPhone} onChange={(e) => setEditPhone(formatPhone(e.target.value))} placeholder="(00) 00000-0000" />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Data de Nascimento</Label>
                <Input type="date" value={editBirthDate} onChange={(e) => setEditBirthDate(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>Data de Admissão</Label>
                <Input type="date" value={editHireDate} onChange={(e) => setEditHireDate(e.target.value)} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Departamento</Label>
              <Select value={editDeptId || "none"} onValueChange={(v) => setEditDeptId(v === "none" ? "" : v)}>
                <SelectTrigger>
                  <SelectValue placeholder="Selecione o departamento" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {departments.map((d) => (
                    <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Cargo *</Label>
              {isMasterAdmin ? (
                <Select value={editRole} onValueChange={(v) => setEditRole(v as AppRole)}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {availableRoles.map((r) => (
                      <SelectItem key={r} value={r}>{ROLE_LABELS[r]}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              ) : (
                <div className="flex items-center gap-2 rounded-md border px-3 py-2 bg-muted/40">
                  <span className="text-sm">{ROLE_LABELS[editRole]}</span>
                  <span className="text-xs text-muted-foreground ml-auto">Apenas administradores podem alterar</span>
                </div>
              )}
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditOpen(false)}>Cancelar</Button>
            <Button onClick={handleSave} disabled={saving}>
              {saving ? "Salvando..." : "Salvar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Department Dialog (add / edit) */}
      <Dialog open={deptDialogOpen} onOpenChange={setDeptDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{deptEditTarget ? "Editar Departamento" : "Novo Departamento"}</DialogTitle>
            <DialogDescription>
              {deptEditTarget ? `Editando "${deptEditTarget.name}".` : "Preencha o nome do novo departamento."}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label>Nome *</Label>
            <Input
              value={deptName}
              onChange={(e) => setDeptName(e.target.value)}
              placeholder="Ex: Recursos Humanos"
              onKeyDown={(e) => e.key === "Enter" && handleSaveDept()}
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeptDialogOpen(false)}>Cancelar</Button>
            <Button onClick={handleSaveDept} disabled={deptSaving}>
              {deptSaving ? "Salvando..." : deptEditTarget ? "Salvar" : "Criar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Department Delete Confirmation */}
      <AlertDialog open={!!deptDeleteTarget} onOpenChange={(open) => !open && setDeptDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir departamento</AlertDialogTitle>
            <AlertDialogDescription>
              Tem certeza que deseja excluir <strong>{deptDeleteTarget?.name}</strong>? Os colaboradores vinculados ficarão sem departamento.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deptDeleting}>Cancelar</AlertDialogCancel>
            <AlertDialogAction onClick={handleDeleteDept} disabled={deptDeleting} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
              {deptDeleting ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Reset Password Dialog */}
      <Dialog open={!!resetTarget} onOpenChange={(open) => !open && setResetTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Redefinir Senha</DialogTitle>
            <DialogDescription>
              Defina uma nova senha para <strong>{resetTarget?.name}</strong>.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label>Nova senha *</Label>
            <Input
              type="password"
              value={resetPassword}
              onChange={(e) => setResetPassword(e.target.value)}
              placeholder="Digite a nova senha"
              onKeyDown={(e) => e.key === "Enter" && handleResetPassword()}
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setResetTarget(null)}>Cancelar</Button>
            <Button onClick={handleResetPassword} disabled={!resetPassword.trim() || resetting}>
              {resetting ? "Salvando..." : "Redefinir Senha"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Collaborator Delete Confirmation */}
      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir colaborador</AlertDialogTitle>
            <AlertDialogDescription>
              Tem certeza que deseja excluir <strong>{deleteTarget?.name}</strong>? Esta ação não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Cancelar</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete} disabled={deleting} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
              {deleting ? "Excluindo..." : "Excluir"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
}
