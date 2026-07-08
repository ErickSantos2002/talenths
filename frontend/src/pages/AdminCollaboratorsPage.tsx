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
import { Combobox } from "@/components/Combobox";
import { Switch } from "@/components/ui/switch";
import { TablePagination } from "@/components/TablePagination";
import { usePageSize } from "@/hooks/use-page-size";
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
  job_title: string | null;
  timeclock_enabled: boolean;
  daily_work_hours: number;
  role: AppRole;
  roleId: string | null;
}

interface Department {
  id: string;
  name: string;
  company_id: string;
}

// ─── Pagination ───────────────────────────────────────────────────────────────
const PAGE_SIZE = 10;

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
  const [collabPage, setCollabPage] = useState(1);
  const [collabPageSize, setCollabPageSize] = usePageSize("collaborators", PAGE_SIZE);

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
  const [editJobTitle, setEditJobTitle] = useState("");
  const [editTimeclockEnabled, setEditTimeclockEnabled] = useState(false);
  const [editDailyHours, setEditDailyHours] = useState("8.5");
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
  const [addJobTitle, setAddJobTitle] = useState("");
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
          job_title: p.job_title ?? null,
          timeclock_enabled: p.timeclock_enabled ?? false,
          daily_work_hours: p.daily_work_hours != null ? Number(p.daily_work_hours) : 8.5,
          role: primaryRole,
          roleId: primaryRoleId,
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
    .filter((c) =>
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.email.toLowerCase().includes(search.toLowerCase())
    )
    .sort((a, b) => ROLE_PRIORITY.indexOf(a.role) - ROLE_PRIORITY.indexOf(b.role));

  // Reset page when search changes
  useEffect(() => { setCollabPage(1); }, [search]);

  const totalCollabPages = Math.ceil(filtered.length / collabPageSize);
  const collabStartIdx = (collabPage - 1) * collabPageSize;
  const collabEndIdx = Math.min(collabStartIdx + collabPageSize, filtered.length);
  const paginated = filtered.slice(collabStartIdx, collabEndIdx);

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
    setEditJobTitle(collab.job_title ?? "");
    setEditTimeclockEnabled(collab.timeclock_enabled);
    setEditDailyHours(String(collab.daily_work_hours ?? 8.5));
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
        job_title: editJobTitle.trim() || null,
        timeclock_enabled: editTimeclockEnabled,
        daily_work_hours: parseFloat(editDailyHours) || 8.5,
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
    setAddJobTitle("");
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
        job_title: addJobTitle.trim() || null,
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
      <div className="animate-fade-in space-y-5">

        {/* Header */}
        <div>
          <h1 className="flex items-center gap-2 text-2xl font-bold text-foreground">
            <Users className="h-6 w-6 text-primary" /> Gestão de Colaboradores
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Gerencie os colaboradores e departamentos da empresa
          </p>
        </div>

        <Tabs defaultValue="colaboradores">
          <TabsList className="h-auto w-full justify-start rounded-none border-b bg-transparent p-0">
            <TabsTrigger value="colaboradores" className="h-11 gap-2 rounded-none border-b-2 border-transparent px-4 font-medium text-muted-foreground data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:text-foreground">
              <Users className="h-4 w-4" /> Colaboradores
            </TabsTrigger>
            <TabsTrigger value="departamentos" className="h-11 gap-2 rounded-none border-b-2 border-transparent px-4 font-medium text-muted-foreground data-[state=active]:border-primary data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:text-foreground">
              <Building2 className="h-4 w-4" /> Departamentos
            </TabsTrigger>
          </TabsList>

          {/* ── Aba Colaboradores ─────────────────────────────────────────── */}
          <TabsContent value="colaboradores" className="mt-4 space-y-3">
            {/* Search + button */}
            <div className="flex flex-col gap-2 sm:flex-row">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input
                  placeholder="Buscar por nome ou email..."
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  className="w-full pl-9"
                />
              </div>
              <Button onClick={openAdd} className="w-full gap-2 sm:w-auto">
                <Plus className="h-4 w-4" /> Adicionar Colaborador
              </Button>
            </div>

            {!loading && (
              <p className="text-xs text-muted-foreground">
                {filtered.length === collaborators.length
                  ? `${collaborators.length} colaborador${collaborators.length !== 1 ? "es" : ""}`
                  : `${filtered.length} de ${collaborators.length} colaborador${collaborators.length !== 1 ? "es" : ""}`}
              </p>
            )}

            {/* Card — overflow-hidden contém o scroll horizontal dentro */}
            <Card className="overflow-hidden">
              <CardContent className="p-0">
                {loading ? (
                  <div className="space-y-4 p-6">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Skeleton key={i} className="h-12 w-full" />
                    ))}
                  </div>
                ) : filtered.length === 0 ? (
                  <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
                    <Users className="mb-4 h-12 w-12 opacity-40" />
                    <p className="text-lg font-medium">
                      {search ? "Nenhum colaborador encontrado" : "Nenhum colaborador cadastrado"}
                    </p>
                  </div>
                ) : (
                  <>
                    <div className="overflow-x-auto">
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>Nome</TableHead>
                            <TableHead className="hidden sm:table-cell">Email</TableHead>
                            <TableHead className="hidden lg:table-cell">Telefone</TableHead>
                            <TableHead className="hidden lg:table-cell">Departamento</TableHead>
                            <TableHead className="hidden lg:table-cell">Cargo</TableHead>
                            <TableHead>Função</TableHead>
                            <TableHead className="text-right">Ações</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {paginated.map((collab) => (
                            <TableRow key={collab.id} className="transition-colors hover:bg-muted/40">
                              <TableCell className="font-medium">{collab.name}</TableCell>
                              <TableCell className="hidden text-sm text-muted-foreground sm:table-cell">{collab.email}</TableCell>
                              <TableCell className="hidden text-sm lg:table-cell">{collab.phone ? formatPhone(collab.phone) : "—"}</TableCell>
                              <TableCell className="hidden text-sm lg:table-cell">{collab.departmentName ?? "—"}</TableCell>
                              <TableCell className="hidden text-sm lg:table-cell">{collab.job_title ?? "—"}</TableCell>
                              <TableCell>
                                <Badge variant="outline" className={ROLE_COLORS[collab.role]}>
                                  {ROLE_LABELS[collab.role]}
                                </Badge>
                              </TableCell>
                              <TableCell className="text-right">
                                <div className="flex justify-end gap-1.5">
                                  <button
                                    onClick={() => openEdit(collab)}
                                    title="Editar"
                                    className="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25"
                                  >
                                    <Pencil className="h-3.5 w-3.5" />
                                  </button>
                                  <button
                                    onClick={() => openResetPassword(collab)}
                                    title="Redefinir senha"
                                    className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-500/15 text-blue-500 transition-colors hover:bg-blue-500/25"
                                  >
                                    <KeyRound className="h-3.5 w-3.5" />
                                  </button>
                                  {isMasterAdmin && (
                                    <button
                                      onClick={() => setDeleteTarget(collab)}
                                      title="Excluir"
                                      className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                                    >
                                      <Trash2 className="h-3.5 w-3.5" />
                                    </button>
                                  )}
                                </div>
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </div>
                    <TablePagination
                      currentPage={collabPage}
                      totalPages={totalCollabPages}
                      totalItems={filtered.length}
                      startIdx={collabStartIdx}
                      endIdx={collabEndIdx}
                      onPage={setCollabPage}
                      onPrev={() => setCollabPage((p) => Math.max(1, p - 1))}
                      onNext={() => setCollabPage((p) => Math.min(totalCollabPages, p + 1))}
                      pageSize={collabPageSize}
                      onPageSizeChange={(size) => { setCollabPageSize(size); setCollabPage(1); }}
                      itemLabel="colaboradores"
                    />
                  </>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          {/* ── Aba Departamentos ─────────────────────────────────────────── */}
          <TabsContent value="departamentos" className="mt-4 space-y-3">
            <div>
              <Button onClick={openAddDept} className="w-full gap-2 sm:w-auto">
                <Plus className="h-4 w-4" /> Novo Departamento
              </Button>
            </div>
            <Card className="overflow-hidden">
              <CardContent className="p-0">
                {loading ? (
                  <div className="space-y-4 p-6">
                    {Array.from({ length: 3 }).map((_, i) => (
                      <Skeleton key={i} className="h-12 w-full" />
                    ))}
                  </div>
                ) : departments.length === 0 ? (
                  <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
                    <Building2 className="mb-4 h-12 w-12 opacity-40" />
                    <p className="text-lg font-medium">Nenhum departamento cadastrado</p>
                    <p className="mt-1 text-sm">Crie o primeiro departamento para organizar os colaboradores</p>
                  </div>
                ) : (
                  <div className="overflow-x-auto">
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
                              <TableCell className="hidden text-sm text-muted-foreground sm:table-cell">{count}</TableCell>
                              <TableCell className="text-right">
                                <div className="flex justify-end gap-1.5">
                                  <button
                                    onClick={() => openEditDept(dept)}
                                    title="Editar"
                                    className="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/15 text-amber-500 transition-colors hover:bg-amber-500/25"
                                  >
                                    <Pencil className="h-3.5 w-3.5" />
                                  </button>
                                  <button
                                    onClick={() => setDeptDeleteTarget(dept)}
                                    title="Excluir"
                                    className="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/15 text-destructive transition-colors hover:bg-destructive/25"
                                  >
                                    <Trash2 className="h-3.5 w-3.5" />
                                  </button>
                                </div>
                              </TableCell>
                            </TableRow>
                          );
                        })}
                      </TableBody>
                    </Table>
                  </div>
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
              <Combobox
                options={[{ value: "none", label: "Sem departamento" }, ...departments.map((d) => ({ value: d.id, label: d.name }))]}
                value={addDeptId || "none"}
                onChange={(v) => setAddDeptId(!v || v === "none" ? "" : v)}
                placeholder="Selecione o departamento"
                searchPlaceholder="Buscar departamento..."
                emptyText="Nenhum departamento encontrado."
              />
            </div>
            <div className="space-y-2">
              <Label>Cargo</Label>
              <Input value={addJobTitle} onChange={(e) => setAddJobTitle(e.target.value)} placeholder="Ex: Analista de RH Pleno" />
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
              <Label>Função *</Label>
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
        <DialogContent className="max-w-md max-h-[90vh] overflow-y-auto">
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
              <Combobox
                options={[{ value: "none", label: "Sem departamento" }, ...departments.map((d) => ({ value: d.id, label: d.name }))]}
                value={editDeptId || "none"}
                onChange={(v) => setEditDeptId(!v || v === "none" ? "" : v)}
                placeholder="Selecione o departamento"
                searchPlaceholder="Buscar departamento..."
                emptyText="Nenhum departamento encontrado."
              />
            </div>
            <div className="space-y-2">
              <Label>Cargo</Label>
              <Input value={editJobTitle} onChange={(e) => setEditJobTitle(e.target.value)} placeholder="Ex: Analista de RH Pleno" />
            </div>
            <div className="rounded-lg border p-3 space-y-3">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <Label htmlFor="edit-timeclock">Bater ponto pelo sistema</Label>
                  <p className="text-xs text-muted-foreground">Habilita o registro de ponto para este colaborador.</p>
                </div>
                <Switch id="edit-timeclock" checked={editTimeclockEnabled} onCheckedChange={setEditTimeclockEnabled} />
              </div>
              {editTimeclockEnabled && (
                <div className="space-y-1.5">
                  <Label>Jornada diária (horas)</Label>
                  <Input
                    type="number"
                    step="0.5"
                    value={editDailyHours}
                    onChange={(e) => setEditDailyHours(e.target.value)}
                    className="w-32"
                    placeholder="8.5"
                  />
                </div>
              )}
            </div>
            <div className="space-y-2">
              <Label>Função *</Label>
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
