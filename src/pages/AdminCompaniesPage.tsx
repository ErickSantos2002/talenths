import { useState, useEffect } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import { supabase } from "@/integrations/supabase/client";
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
import { Building2, Plus, Pencil, Trash2, Search, Users, FolderTree } from "lucide-react";
import { format } from "date-fns";
import { ptBR } from "date-fns/locale";

interface Company {
  id: string;
  name: string;
  cnpj: string | null;
  status: string;
  created_at: string;
}

const statusMap: Record<string, { label: string; variant: "default" | "secondary" | "destructive" | "outline" }> = {
  active: { label: "Ativa", variant: "default" },
  inactive: { label: "Inativa", variant: "secondary" },
  suspended: { label: "Suspensa", variant: "destructive" },
};

function formatCnpj(value: string) {
  const digits = value.replace(/\D/g, "").slice(0, 14);
  return digits
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1/$2")
    .replace(/(\d{4})(\d)/, "$1-$2");
}

export default function AdminCompaniesPage() {
  const { toast } = useToast();
  const [companies, setCompanies] = useState<Company[]>([]);
  const [deptCounts, setDeptCounts] = useState<Record<string, number>>({});
  const [profileCounts, setProfileCounts] = useState<Record<string, number>>({});
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingCompany, setEditingCompany] = useState<Company | null>(null);
  const [companyName, setCompanyName] = useState("");
  const [companyCnpj, setCompanyCnpj] = useState("");
  const [companyStatus, setCompanyStatus] = useState("active");
  const [saving, setSaving] = useState(false);

  // Delete state
  const [deleteTarget, setDeleteTarget] = useState<Company | null>(null);
  const [deleting, setDeleting] = useState(false);

  const fetchData = async () => {
    setLoading(true);
    const [companiesRes, deptsRes, profilesRes] = await Promise.all([
      supabase.from("companies").select("*").order("created_at", { ascending: false }),
      supabase.from("departments").select("id, company_id"),
      supabase.from("profiles").select("id, company_id"),
    ]);

    if (companiesRes.error) {
      toast({ title: "Erro ao carregar empresas", description: companiesRes.error.message, variant: "destructive" });
    } else {
      setCompanies(companiesRes.data ?? []);
    }

    const dc: Record<string, number> = {};
    (deptsRes.data ?? []).forEach((d) => {
      dc[d.company_id] = (dc[d.company_id] || 0) + 1;
    });
    setDeptCounts(dc);

    const pc: Record<string, number> = {};
    (profilesRes.data ?? []).forEach((p) => {
      if (p.company_id) pc[p.company_id] = (pc[p.company_id] || 0) + 1;
    });
    setProfileCounts(pc);

    setLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const filtered = companies.filter((c) => {
    const matchesSearch =
      c.name.toLowerCase().includes(search.toLowerCase()) ||
      (c.cnpj && c.cnpj.includes(search.replace(/\D/g, "")));
    const matchesStatus = statusFilter === "all" || c.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const openCreate = () => {
    setEditingCompany(null);
    setCompanyName("");
    setCompanyCnpj("");
    setCompanyStatus("active");
    setDialogOpen(true);
  };

  const openEdit = (company: Company) => {
    setEditingCompany(company);
    setCompanyName(company.name);
    setCompanyCnpj(company.cnpj ? formatCnpj(company.cnpj) : "");
    setCompanyStatus(company.status);
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!companyName.trim()) return;
    const cnpjDigits = companyCnpj.replace(/\D/g, "") || null;
    if (cnpjDigits && cnpjDigits.length !== 14) {
      toast({ title: "CNPJ deve ter 14 dígitos", variant: "destructive" });
      return;
    }
    setSaving(true);

    const payload = { name: companyName.trim(), cnpj: cnpjDigits, status: companyStatus };

    if (editingCompany) {
      const { error } = await supabase.from("companies").update(payload).eq("id", editingCompany.id);
      if (error) {
        toast({ title: "Erro ao atualizar empresa", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Empresa atualizada com sucesso" });
      }
    } else {
      const { error } = await supabase.from("companies").insert(payload);
      if (error) {
        toast({ title: "Erro ao criar empresa", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Empresa criada com sucesso" });
      }
    }

    setSaving(false);
    setDialogOpen(false);
    fetchData();
  };

  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    const { error } = await supabase.rpc('delete_company_cascade' as any, { _company_id: deleteTarget.id });
    if (error) {
      toast({ title: "Erro ao excluir empresa", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Empresa excluída com sucesso" });
    }
    setDeleting(false);
    setDeleteTarget(null);
    fetchData();
  };

  return (
    <AdminLayout>
      <div className="animate-fade-in space-y-6">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
              <Building2 className="h-6 w-6 text-primary" />
              Gestão de Empresas
            </h1>
            <p className="text-sm text-muted-foreground mt-1">
              Gerencie as empresas cadastradas na plataforma
            </p>
          </div>
          <Button onClick={openCreate} className="gap-2">
            <Plus className="h-4 w-4" /> Nova Empresa
          </Button>
        </div>

        {/* Filters */}
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="relative max-w-sm flex-1">
            <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <Input
              placeholder="Buscar por nome ou CNPJ..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-9"
            />
          </div>
          <Select value={statusFilter} onValueChange={setStatusFilter}>
            <SelectTrigger className="w-full sm:w-[180px]">
              <SelectValue placeholder="Status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todos os status</SelectItem>
              <SelectItem value="active">Ativa</SelectItem>
              <SelectItem value="inactive">Inativa</SelectItem>
              <SelectItem value="suspended">Suspensa</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Table */}
        <Card>
          <CardContent className="p-0">
            {loading ? (
              <div className="space-y-4 p-6">
                {Array.from({ length: 4 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : filtered.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
                <Building2 className="h-12 w-12 mb-4 opacity-40" />
                <p className="text-lg font-medium">
                  {search || statusFilter !== "all" ? "Nenhuma empresa encontrada" : "Nenhuma empresa cadastrada"}
                </p>
                {!search && statusFilter === "all" && (
                  <p className="text-sm mt-1">Clique em "Nova Empresa" para começar</p>
                )}
              </div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Nome</TableHead>
                    <TableHead className="hidden md:table-cell">CNPJ</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="hidden sm:table-cell">
                      <span className="flex items-center gap-1"><FolderTree className="h-3.5 w-3.5" /> Deptos</span>
                    </TableHead>
                    <TableHead className="hidden sm:table-cell">
                      <span className="flex items-center gap-1"><Users className="h-3.5 w-3.5" /> Colab.</span>
                    </TableHead>
                    <TableHead className="hidden lg:table-cell">Criada em</TableHead>
                    <TableHead className="text-right">Ações</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filtered.map((company) => {
                    const st = statusMap[company.status] ?? { label: company.status, variant: "outline" as const };
                    return (
                      <TableRow key={company.id}>
                        <TableCell className="font-medium">{company.name}</TableCell>
                        <TableCell className="hidden md:table-cell text-muted-foreground text-sm font-mono">
                          {company.cnpj ? formatCnpj(company.cnpj) : "—"}
                        </TableCell>
                        <TableCell>
                          <Badge variant={st.variant}>{st.label}</Badge>
                        </TableCell>
                        <TableCell className="hidden sm:table-cell">{deptCounts[company.id] ?? 0}</TableCell>
                        <TableCell className="hidden sm:table-cell">{profileCounts[company.id] ?? 0}</TableCell>
                        <TableCell className="hidden lg:table-cell text-muted-foreground text-sm">
                          {format(new Date(company.created_at), "dd/MM/yyyy", { locale: ptBR })}
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex justify-end gap-1">
                            <Button variant="ghost" size="icon" onClick={() => openEdit(company)} title="Editar">
                              <Pencil className="h-4 w-4" />
                            </Button>
                            <Button variant="ghost" size="icon" onClick={() => setDeleteTarget(company)} title="Excluir" className="text-destructive hover:text-destructive">
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
      </div>

      {/* Create / Edit Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{editingCompany ? "Editar Empresa" : "Nova Empresa"}</DialogTitle>
            <DialogDescription>
              {editingCompany ? "Atualize os dados da empresa." : "Preencha os dados para criar uma nova empresa."}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-2">
              <Label>Nome da empresa</Label>
              <Input
                placeholder="Nome da empresa"
                value={companyName}
                onChange={(e) => setCompanyName(e.target.value)}
                maxLength={100}
              />
            </div>
            <div className="space-y-2">
              <Label>CNPJ</Label>
              <Input
                placeholder="00.000.000/0000-00"
                value={companyCnpj}
                onChange={(e) => setCompanyCnpj(formatCnpj(e.target.value))}
                maxLength={18}
                className="font-mono"
              />
            </div>
            <div className="space-y-2">
              <Label>Status</Label>
              <Select value={companyStatus} onValueChange={setCompanyStatus}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Ativa</SelectItem>
                  <SelectItem value="inactive">Inativa</SelectItem>
                  <SelectItem value="suspended">Suspensa</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Cancelar</Button>
            <Button onClick={handleSave} disabled={saving || !companyName.trim()}>
              {saving ? "Salvando..." : "Salvar"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation */}
      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir empresa</AlertDialogTitle>
            <AlertDialogDescription>
              Tem certeza que deseja excluir a empresa <strong>{deleteTarget?.name}</strong>? Todos os dados relacionados (usuários, departamentos, testes, conversas e notificações) serão excluídos permanentemente. Esta ação não pode ser desfeita.
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
