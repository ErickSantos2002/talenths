import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useAuth } from "@/contexts/AuthContext";
import { supabase } from "@/integrations/supabase/client";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useToast } from "@/hooks/use-toast";
import { Loader2, UserPen } from "lucide-react";

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
      const { data, error } = await supabase
        .from("profiles")
        .select("name, phone, cpf, email, company_id, department_id, companies(name), departments(name)")
        .eq("user_id", user.id)
        .single();

      if (error || !data) {
        setLoading(false);
        return;
      }

      form.reset({
        name: data.name ?? "",
        phone: data.phone ? maskPhone(data.phone) : "",
        cpf: data.cpf ? maskCPF(data.cpf) : "",
      });

      const companyName = (data.companies as any)?.name ?? "";
      const departmentName = (data.departments as any)?.name ?? "";

      setReadOnly({ email: data.email, company: companyName, department: departmentName });
      setLoading(false);
    })();
  }, [user]);

  const onSubmit = async (values: ProfileFormValues) => {
    if (!user) return;
    setSaving(true);
    const { error } = await supabase
      .from("profiles")
      .update({ name: values.name, phone: values.phone.replace(/\D/g, "") || null, cpf: values.cpf.replace(/\D/g, "") || null })
      .eq("user_id", user.id);

    setSaving(false);
    if (error) {
      toast({ title: "Erro ao salvar", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Perfil atualizado com sucesso!" });
    }
  };

  return (
    <AdminLayout>
      <div className="mx-auto max-w-2xl space-y-6 p-4 md:p-6">
        <div className="flex items-center gap-3">
          <UserPen className="h-6 w-6 text-primary" />
          <h1 className="text-2xl font-bold">Meu Perfil</h1>
        </div>

        {loading ? (
          <div className="flex justify-center py-12">
            <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
          </div>
        ) : (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Informações pessoais</CardTitle>
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

                  <div className="space-y-4 rounded-md border border-border bg-muted/50 p-4">
                    <p className="text-xs font-medium uppercase tracking-wider text-muted-foreground">Informações da conta</p>
                    <div className="space-y-1">
                      <label className="text-sm font-medium text-muted-foreground">Email</label>
                      <Input value={readOnly.email} disabled className="bg-muted" />
                    </div>
                    <div className="space-y-1">
                      <label className="text-sm font-medium text-muted-foreground">Empresa</label>
                      <Input value={readOnly.company || "—"} disabled className="bg-muted" />
                    </div>
                    <div className="space-y-1">
                      <label className="text-sm font-medium text-muted-foreground">Departamento</label>
                      <Input value={readOnly.department || "—"} disabled className="bg-muted" />
                    </div>
                  </div>

                  <Button type="submit" disabled={saving} className="w-full">
                    {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    Salvar
                  </Button>
                </form>
              </Form>
            </CardContent>
          </Card>
        )}
      </div>
    </AdminLayout>
  );
}
