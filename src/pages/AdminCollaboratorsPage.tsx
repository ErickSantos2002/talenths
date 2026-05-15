import { useState, useEffect } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
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
import { Users, Pencil, Trash2, Search, CheckCircle, XCircle, Plus } from "lucide-react";
import type { Database } from "@/integrations/supabase/types";

type AppRole = Database["public"]["Enums"]["app_role"];

interface Collaborator {
  id: string;
  user_id: string;
  name: string;
  email: string;
  cpf: string | null;
  phone: string | null;
  company_id: string | null;
  department_id: string | null;
  companyName: string | null;
  departmentName: string | null;
  role: AppRole;
  roleId: string | null;
  hasTest: boolean;
}

interface Company {
  id: string;
  name: string;
}

interface Department {
  id: string;
  name: string;
  company_id: string;
}

const ROLE_LABELS: Record<AppRole, string> = {
  master_admin: "Master Admin",
  company_admin: "Admin Empresa",
  leader: "Líder",
  user: "Colaborador",
};

const ROLE_COLORS: Record<AppRole, string> = {
  master_admin: "bg-destructive/15 text-destructive border-destructive/30",
  company_admin: "bg-primary/15 text-primary border-primary/30",
  leader: "bg-chart-4/15 text-chart-4 border-chart-4/30",
  user: "bg-muted text-muted-foreground border-border",
};

// --- Masks ---
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
  const { roles: currentUserRoles, profile: currentProfile, selectedCompanyId: globalCompanyId } = useAuth();
  const isMasterAdmin = currentUserRoles.includes("master_admin");
  const isCompanyAdmin = currentUserRoles.includes("company_admin");

  const [collaborators, setCollaborators] = useState<Collaborator[]>([]);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [allDepartments, setAllDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const filterCompany = isMasterAdmin ? (globalCompanyId ?? "all") : "all";
  const [filterTestStatus, setFilterTestStatus] = useState<string>("all");

  // Edit dialog
  const [editOpen, setEditOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<Collaborator | null>(null);
  const [editName, setEditName] = useState("");
  const [editCpf, setEditCpf] = useState("");
  const [editPhone, setEditPhone] = useState("");
  const [editCompanyId, setEditCompanyId] = useState<string>("");
  const [editDeptId, setEditDeptId] = useState<string>("");
  const [editRole, setEditRole] = useState<AppRole>("user");
  const [saving, setSaving] = useState(false);

  // Add dialog
  const [addOpen, setAddOpen] = useState(false);
  const [addName, setAddName] = useState("");
  const [addCpf, setAddCpf] = useState("");
  const [addEmail, setAddEmail] = useState("");
  const [addPhone, setAddPhone] = useState("");
  const [addCompanyId, setAddCompanyId] = useState("");
  const [addDeptId, setAddDeptId] = useState("");
  const [addRole, setAddRole] = useState<AppRole>("user");
  const [adding, setAdding] = useState(false);

  // Delete dialog
  const [deleteTarget, setDeleteTarget] = useState<Collaborator | null>(null);
  const [deleting, setDeleting] = useState(false);

  const fetchData = async () => {
    setLoading(true);

    const [profilesRes, companiesRes, deptsRes, rolesRes, testsRes] = await Promise.all([
      supabase.from("profiles").select("*"),
      supabase.from("companies").select("id, name").order("name"),
      supabase.from("departments").select("id, name, company_id"),
      supabase.from("user_roles").select("id, user_id, role"),
      supabase.from("test_results").select("user_id"),
    ]);

    if (profilesRes.error) {
      toast({ title: "Erro ao carregar colaboradores", description: profilesRes.error.message, variant: "destructive" });
      setLoading(false);
      return;
    }

    const companyMap = new Map((companiesRes.data ?? []).map((c) => [c.id, c.name]));
    const deptMap = new Map((deptsRes.data ?? []).map((d) => [d.id, d.name]));
    const roleMap = new Map<string, { role: AppRole; id: string }>();
    (rolesRes.data ?? []).forEach((r) => roleMap.set(r.user_id, { role: r.role, id: r.id }));
    const testSet = new Set((testsRes.data ?? []).map((t) => t.user_id));

    const collabs: Collaborator[] = (profilesRes.data ?? []).map((p) => {
      const roleEntry = roleMap.get(p.user_id);
      return {
        id: p.id,
        user_id: p.user_id,
        name: p.name,
        email: p.email,
        cpf: p.cpf,
        phone: (p as any).phone ?? null,
        company_id: p.company_id,
        department_id: p.department_id,
        companyName: p.company_id ? companyMap.get(p.company_id) ?? null : null,
        departmentName: p.department_id ? deptMap.get(p.department_id) ?? null : null,
        role: roleEntry?.role ?? "user",
        roleId: roleEntry?.id ?? null,
        hasTest: testSet.has(p.user_id),
      };
    });

    setCollaborators(collabs);
    setCompanies(companiesRes.data ?? []);
    setAllDepartments(deptsRes.data ?? []);
    setLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const filtered = collaborators.filter((c) => {
    const matchesSearch =
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      c.email.toLowerCase().includes(search.toLowerCase());
    const matchesCompany = filterCompany === "all" || c.company_id === filterCompany;
    const matchesTestStatus =
      filterTestStatus === "all" ||
      (filterTestStatus === "done" && c.hasTest) ||
      (filterTestStatus === "pending" && !c.hasTest);
    return matchesSearch && matchesCompany && matchesTestStatus;
  });

  // --- Edit ---
  const openEdit = (collab: Collaborator) => {
    setEditTarget(collab);
    setEditName(collab.name);
    setEditCpf(collab.cpf ? formatCpf(collab.cpf) : "");
    setEditPhone(collab.phone ? formatPhone(collab.phone) : "");
    setEditCompanyId(collab.company_id ?? "");
    setEditDeptId(collab.department_id ?? "");
    setEditRole(collab.role);
    setEditOpen(true);
  };

  const editFilteredDepts = allDepartments.filter((d) => d.company_id === editCompanyId);

  const handleSave = async () => {
    if (!editTarget) return;
    const missingFields: string[] = [];
    if (!editName.trim()) missingFields.push("Nome");
    if (editCpf.trim() && editCpf.replace(/\D/g, "").length < 11) missingFields.push("CPF (deve ter 11 dígitos)");
    if (!editPhone.trim() || editPhone.replace(/\D/g, "").length < 11) missingFields.push("Telefone");
    if (isMasterAdmin && !editCompanyId) missingFields.push("Empresa");
    if (missingFields.length > 0) {
      toast({ title: `Campos obrigatórios: ${missingFields.join(", ")}`, variant: "destructive" });
      return;
    }
    setSaving(true);

    const finalDeptId = editCompanyId && editFilteredDepts.some((d) => d.id === editDeptId) ? editDeptId : null;

    const { error: profileErr } = await supabase
      .from("profiles")
      .update({
        name: editName,
        cpf: editCpf.replace(/\D/g, "") || null,
        phone: editPhone.replace(/\D/g, "") || null,
        company_id: editCompanyId || null,
        department_id: finalDeptId,
      } as any)
      .eq("id", editTarget.id);

    if (profileErr) {
      toast({ title: "Erro ao atualizar perfil", description: profileErr.message, variant: "destructive" });
      setSaving(false);
      return;
    }

    if (editTarget.roleId) {
      const { error: roleErr } = await supabase
        .from("user_roles")
        .update({ role: editRole })
        .eq("id", editTarget.roleId);
      if (roleErr) {
        toast({ title: "Erro ao atualizar cargo", description: roleErr.message, variant: "destructive" });
        setSaving(false);
        return;
      }
    }

    toast({ title: "Colaborador atualizado com sucesso" });
    setSaving(false);
    setEditOpen(false);
    fetchData();
  };

  // --- Add ---
  const openAdd = () => {
    setAddName("");
    setAddCpf("");
    setAddEmail("");
    setAddPhone("");
    setAddCompanyId(isMasterAdmin ? (globalCompanyId ?? "") : (currentProfile?.company_id ?? ""));
    setAddDeptId("");
    setAddRole("user");
    setAddOpen(true);
  };

  const addFilteredDepts = allDepartments.filter((d) => d.company_id === addCompanyId);

  const handleAdd = async () => {
    const missingFields: string[] = [];
    if (!addName.trim()) missingFields.push("Nome");
    if (!addEmail.trim()) missingFields.push("Email");
    if (addCpf.trim() && addCpf.replace(/\D/g, "").length < 11) missingFields.push("CPF (deve ter 11 dígitos)");
    if (!addPhone.trim() || addPhone.replace(/\D/g, "").length < 11) missingFields.push("Telefone");
    if (missingFields.length > 0) {
      toast({ title: `Campos obrigatórios: ${missingFields.join(", ")}`, variant: "destructive" });
      return;
    }

    const companyId = isMasterAdmin ? addCompanyId : (currentProfile?.company_id ?? "");
    if (!companyId) {
      toast({ title: "Selecione uma empresa", variant: "destructive" });
      return;
    }

    setAdding(true);

    const finalDeptId = companyId && addFilteredDepts.some((d) => d.id === addDeptId) ? addDeptId : null;

    const { data, error } = await supabase.functions.invoke("create-collaborator", {
      body: {
        email: addEmail.trim(),
        name: addName.trim(),
        company_id: companyId,
        department_id: finalDeptId,
        cpf: addCpf.replace(/\D/g, "") || null,
        phone: addPhone.replace(/\D/g, "") || null,
        role: addRole,
        origin: window.location.origin,
      },
    });

    if (error || data?.error) {
      toast({ title: "Erro ao criar colaborador", description: data?.error || error?.message, variant: "destructive" });
      setAdding(false);
      return;
    }

    toast({ title: "Colaborador criado com sucesso", description: "Um email de convite foi enviado para o colaborador definir sua senha." });
    setAdding(false);
    setAddOpen(false);
    fetchData();
  };

  // --- Delete ---
  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    const uid = deleteTarget.user_id;

    try {
      // 1. Respostas de teste
      await supabase.from("test_responses").delete().eq("user_id", uid);
      // 2. Resultados de teste
      await supabase.from("test_results").delete().eq("user_id", uid);
      // 3. Comparações de perfil
      await supabase.from("profile_comparisons").delete().or(`user1_id.eq.${uid},user2_id.eq.${uid}`);
      // 4. Relações de gestor
      await supabase.from("user_managers").delete().or(`user_id.eq.${uid},manager_id.eq.${uid}`);
      // 5. Roles
      await supabase.from("user_roles").delete().eq("user_id", uid);
      // 6. Perfil
      const { error } = await supabase.from("profiles").delete().eq("id", deleteTarget.id);

      if (error) {
        toast({ title: "Erro ao excluir colaborador", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Colaborador excluído com sucesso" });
      }
    } catch (err: any) {
      toast({ title: "Erro ao excluir colaborador", description: err.message, variant: "destructive" });
    }

    setDeleting(false);
    setDeleteTarget(null);
    fetchData();
  };

  const availableRoles: AppRole[] = isMasterAdmin
    ? ["company_admin", "leader", "user"]
    : ["company_admin", "leader", "user"];

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
              <Users className="h-6 w-6 text-primary" />
              Gestão de Colaboradores
            </h1>
            <p className="text-sm text-muted-foreground mt-1">
              Gerencie os colaboradores da plataforma
            </p>
          </div>
          {(isMasterAdmin || isCompanyAdmin) && (
            <Button onClick={openAdd} className="gap-2">
              <Plus className="h-4 w-4" />
              Adicionar Colaborador
            </Button>
          )}
        </div>

        {/* Filters */}
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="relative flex-1 max-w-sm">
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

        {/* Table */}
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
                  {search || filterCompany !== "all" ? "Nenhum colaborador encontrado" : "Nenhum colaborador cadastrado"}
                </p>
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Nome</TableHead>
                    <TableHead className="hidden sm:table-cell">Email</TableHead>
                    <TableHead className="hidden lg:table-cell">Telefone</TableHead>
                    {isMasterAdmin && <TableHead className="hidden md:table-cell">Empresa</TableHead>}
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
                      {isMasterAdmin && <TableCell className="hidden md:table-cell text-sm">{collab.companyName ?? "—"}</TableCell>}
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
              <Label>CPF *</Label>
                <Input value={addCpf} onChange={(e) => setAddCpf(formatCpf(e.target.value))} placeholder="000.000.000-00" />
              </div>
              <div className="space-y-2">
                <Label>Telefone *</Label>
                <Input value={addPhone} onChange={(e) => setAddPhone(formatPhone(e.target.value))} placeholder="(00) 00000-0000" />
              </div>
            </div>
            {isMasterAdmin && (
              <div className="space-y-2">
                <Label>Empresa *</Label>
                <Select value={addCompanyId || "none"} onValueChange={(v) => { setAddCompanyId(v === "none" ? "" : v); setAddDeptId(""); }}>
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione a empresa" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="none">Selecione...</SelectItem>
                    {companies.map((c) => (
                      <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            <div className="space-y-2">
              <Label>Departamento</Label>
              <Select value={addDeptId || "none"} onValueChange={(v) => setAddDeptId(v === "none" ? "" : v)} disabled={!addCompanyId && isMasterAdmin}>
                <SelectTrigger>
                  <SelectValue placeholder={addCompanyId || !isMasterAdmin ? "Selecione o departamento" : "Selecione uma empresa primeiro"} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {addFilteredDepts.map((d) => (
                    <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
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
                <Label>CPF *</Label>
                <Input value={editCpf} onChange={(e) => setEditCpf(formatCpf(e.target.value))} placeholder="000.000.000-00" />
              </div>
              <div className="space-y-2">
                <Label>Telefone *</Label>
                <Input value={editPhone} onChange={(e) => setEditPhone(formatPhone(e.target.value))} placeholder="(00) 00000-0000" />
              </div>
            </div>
            {isMasterAdmin && (
              <div className="space-y-2">
                <Label>Empresa *</Label>
                <Select
                  value={editCompanyId || "none"}
                  onValueChange={(v) => { setEditCompanyId(v === "none" ? "" : v); setEditDeptId(""); }}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione a empresa" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="none">Sem empresa</SelectItem>
                    {companies.map((c) => (
                      <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            <div className="space-y-2">
              <Label>Departamento</Label>
              <Select
                value={editDeptId || "none"}
                onValueChange={(v) => setEditDeptId(v === "none" ? "" : v)}
                disabled={!editCompanyId && isMasterAdmin}
              >
                <SelectTrigger>
                  <SelectValue placeholder={editCompanyId || !isMasterAdmin ? "Selecione o departamento" : "Selecione uma empresa primeiro"} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="none">Sem departamento</SelectItem>
                  {editFilteredDepts.map((d) => (
                    <SelectItem key={d.id} value={d.id}>{d.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Cargo *</Label>
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

      {/* Delete Confirmation */}
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
