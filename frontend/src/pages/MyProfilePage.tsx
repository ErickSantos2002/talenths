import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useAuth } from "@/contexts/AuthContext";
import { profiles as profilesApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useToast } from "@/hooks/use-toast";
import { Loader2, UserPen, Mail, Building2, LayoutGrid } from "lucide-react";

const maskPhone = (value: string) => {
  return value
    .replace(/\D/g, "")
    .replace(/(\d{2})(\d)/, "($1) $2")
    .replace(/(\d{5})(\d)/, "$1-$2")
    .slice(0, 15);
};

const maskCPF = (value: string) => {
  return value
    .replace(/\D/g, "")
    .replace(/(\d{3})(\d)/, "$1.$2")
    .replace(/(\d{3})(\d)/, "$1.$2")
    .replace(/(\d{3})(\d{2})$/, "$1-$2")
    .slice(0, 14);
};

const profileSchema = z.object({
  name: z.string().trim().min(1, "Nome é obrigatório"),
  phone: z.string().refine((v) => !v || /^\d{11}$/.test(v.replace(/\D/g, "")), "Telefone deve ter 11 dígitos"),
  cpf: z.string().refine((v) => !v || /^\d{11}$/.test(v.replace(/\D/g, "")), "CPF deve ter 11 dígitos"),
});

type ProfileFormValues = z.infer<typeof profileSchema>;

export default function MyProfilePage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [readOnly, setReadOnly] = useState({ email: "", company: "", department: "" });

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileSchema),
    defaultValues: { name: "", phone: "", cpf: "" },
  });

  useEffect(() => {
    if (!user) return;
    (async () => {
      try {
        const data = await profilesApi.me() as any;

        form.reset({
          name: data.name ?? "",
          phone: data.phone ? maskPhone(data.phone) : "",
          cpf: data.cpf ? maskCPF(data.cpf) : "",
        });

        const companyName = data.company_name ?? data.companies?.name ?? "";
        const departmentName = data.department_name ?? data.departments?.name ?? "";

        setReadOnly({ email: data.email ?? "", company: companyName, department: departmentName });
      } catch {
        // leave form at defaults on error
      }
      setLoading(false);
    })();
  }, [user]);

  const onSubmit = async (values: ProfileFormValues) => {
    if (!user) return;
    setSaving(true);
    try {
      await profilesApi.update({
        name: values.name,
        phone: values.phone.replace(/\D/g, "") || null,
        cpf: values.cpf.replace(/\D/g, "") || null,
      });
      toast({ title: "Perfil atualizado com sucesso!" });
    } catch (err: any) {
      toast({ title: "Erro ao salvar", description: err.message, variant: "destructive" });
    } finally {
      setSaving(false);
    }
  };

  const name = form.watch("name");
  const initials = name
    ? name.trim().split(" ").filter(Boolean).slice(0, 2).map((w) => w[0].toUpperCase()).join("")
    : "?";

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <UserPen className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold">Meu Perfil</h1>
        </div>

        {loading ? (
          <div className="flex justify-center py-16">
            <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
          </div>
        ) : (
          <div className="grid gap-6 lg:grid-cols-3">
            {/* Left — identity card */}
            <Card className="lg:col-span-1 h-fit">
              <CardContent className="p-6 flex flex-col items-center text-center gap-4">
                <div className="h-20 w-20 rounded-full bg-primary/15 flex items-center justify-center text-2xl font-bold text-primary">
                  {initials}
                </div>
                <div>
                  <p className="font-semibold text-lg leading-tight">{name || "—"}</p>
                  <p className="text-xs text-muted-foreground mt-0.5">{readOnly.email}</p>
                </div>
                <div className="w-full border-t pt-4 space-y-3 text-left">
                  <div className="flex items-center gap-3">
                    <Mail className="h-4 w-4 text-muted-foreground shrink-0" />
                    <div className="min-w-0">
                      <p className="text-xs text-muted-foreground">Email</p>
                      <p className="text-sm truncate">{readOnly.email || "—"}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <Building2 className="h-4 w-4 text-muted-foreground shrink-0" />
                    <div className="min-w-0">
                      <p className="text-xs text-muted-foreground">Empresa</p>
                      <p className="text-sm truncate">{readOnly.company || "—"}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <LayoutGrid className="h-4 w-4 text-muted-foreground shrink-0" />
                    <div className="min-w-0">
                      <p className="text-xs text-muted-foreground">Departamento</p>
                      <p className="text-sm truncate">{readOnly.department || "—"}</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Right — editable form */}
            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle className="text-base">Informações pessoais</CardTitle>
              </CardHeader>
              <CardContent>
                <Form {...form}>
                  <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-5">
                    <FormField
                      control={form.control}
                      name="name"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Nome</FormLabel>
                          <FormControl>
                            <Input placeholder="Seu nome completo" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />

                    <div className="grid gap-4 sm:grid-cols-2">
                      <FormField
                        control={form.control}
                        name="phone"
                        render={({ field }) => (
                          <FormItem>
                            <FormLabel>Telefone</FormLabel>
                            <FormControl>
                              <Input
                                placeholder="(00) 00000-0000"
                                {...field}
                                onChange={(e) => field.onChange(maskPhone(e.target.value))}
                              />
                            </FormControl>
                            <FormMessage />
                          </FormItem>
                        )}
                      />

                      <FormField
                        control={form.control}
                        name="cpf"
                        render={({ field }) => (
                          <FormItem>
                            <FormLabel>CPF</FormLabel>
                            <FormControl>
                              <Input
                                placeholder="000.000.000-00"
                                {...field}
                                onChange={(e) => field.onChange(maskCPF(e.target.value))}
                              />
                            </FormControl>
                            <FormMessage />
                          </FormItem>
                        )}
                      />
                    </div>

                    <div className="flex justify-end pt-2">
                      <Button type="submit" disabled={saving}>
                        {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                        Salvar alterações
                      </Button>
                    </div>
                  </form>
                </Form>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
