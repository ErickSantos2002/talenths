import { LayoutDashboard, Building2, Settings, Users, GitCompareArrows, UsersRound, ClipboardList, Grid3X3, LogOut, Sun, Moon, Monitor, UserPen } from "lucide-react";
import { NavLink } from "@/components/NavLink";
import { useAuth } from "@/contexts/AuthContext";
import { useTheme } from "next-themes";
import { useSystemTheme } from "@/hooks/use-system-theme";
import { useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarTrigger,
} from "@/components/ui/sidebar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";

const adminMainItems = [
  { title: "Dashboard", url: "/dashboard", icon: LayoutDashboard },
  { title: "Empresas", url: "/admin/empresas", icon: Building2 },
];

const adminCompanyItems = [
  { title: "Gestão Empresa", url: "/admin/empresa", icon: Building2 },
  { title: "Colaboradores", url: "/admin/colaboradores", icon: Users },
  { title: "Testes", url: "/admin/testes", icon: ClipboardList },
  { title: "Comparar Perfis", url: "/comparar-perfis", icon: GitCompareArrows },
  { title: "Análise de Equipe", url: "/admin/analise-equipe", icon: Grid3X3 },
  { title: "Configurações", url: "/admin/configuracoes", icon: Settings },
];

const companyMainItems = [
  { title: "Dashboard", url: "/dashboard", icon: LayoutDashboard },
];

const companyCompanyItems = [
  { title: "Minha Empresa", url: "/admin/empresa", icon: Building2 },
  { title: "Colaboradores", url: "/admin/colaboradores", icon: Users },
  { title: "Testes", url: "/admin/testes", icon: ClipboardList },
  { title: "Comparar Perfis", url: "/comparar-perfis", icon: GitCompareArrows },
  { title: "Análise de Equipe", url: "/admin/analise-equipe", icon: Grid3X3 },
];

const leaderItems = [
  { title: "Dashboard", url: "/dashboard", icon: LayoutDashboard },
  { title: "Minha Equipe", url: "/lider/equipe", icon: UsersRound },
];

const commonItems = [
  { title: "Meu Perfil", url: "/meu-perfil", icon: UserPen },
  { title: "Meu Histórico", url: "/meu-historico", icon: ClipboardList },
  { title: "Compatibilidade", url: "/meu-perfil/compatibilidade", icon: GitCompareArrows },
];

export function AdminSidebar() {
  const { hasRole, signOut, selectedCompanyId, setSelectedCompanyId } = useAuth();
  const { theme, setTheme } = useTheme();
  const systemTheme = useSystemTheme();
  const effectiveTheme = theme === "system" ? systemTheme : theme;
  const navigate = useNavigate();
  const isMasterAdmin = hasRole("master_admin");
  const isCompanyAdmin = hasRole("company_admin");
  const isLeader = hasRole("leader");
  const mainItems = isMasterAdmin ? adminMainItems : isCompanyAdmin ? companyMainItems : isLeader ? leaderItems : [];
  const companyItems = isMasterAdmin ? adminCompanyItems : isCompanyAdmin ? companyCompanyItems : [];

  const { data: companies } = useQuery({
    queryKey: ["companies-selector"],
    queryFn: async () => {
      const { data, error } = await supabase.from("companies").select("id, name").order("name");
      if (error) throw error;
      return data;
    },
    enabled: isMasterAdmin,
  });

  const ThemeIcon = effectiveTheme === "dark" ? Moon : Sun;
  const themeLabel = theme === "dark" ? "Escuro" : theme === "light" ? "Claro" : "Sistema";

  const handleLogout = async () => {
    await signOut();
    navigate("/login");
  };

  return (
    <Sidebar collapsible="icon" className="border-r border-sidebar-border">
      <div className="flex flex-col items-center gap-2 border-b border-sidebar-border px-4 py-3 group-data-[collapsible=icon]:px-2">
        <img
          src="/logo-dark.svg"
          alt="talentIA Logo"
          className="h-8 w-auto group-data-[collapsible=icon]:hidden dark:hidden"
        />
        <img
          src="/logo.svg"
          alt="talentIA Logo"
          className="hidden h-8 w-auto group-data-[collapsible=icon]:hidden dark:block"
        />
        <img
          src={effectiveTheme === "dark" ? "/icone_branco.svg" : "/icone_preto.svg"}
          alt="talentIA"
          className="hidden h-6 w-6 group-data-[collapsible=icon]:block"
        />
        <SidebarTrigger />
      </div>

      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Menu
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {mainItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild>
                    <NavLink
                      to={item.url}
                      end
                      className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-sidebar-foreground transition-colors hover:bg-sidebar-accent"
                      activeClassName="bg-primary/10 text-primary font-semibold"
                    >
                      <item.icon className="h-4 w-4" />
                      <span>{item.title}</span>
                    </NavLink>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        {companyItems.length > 0 && (
          <SidebarGroup>
            <SidebarGroupLabel className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
              Empresa
            </SidebarGroupLabel>
            {isMasterAdmin && (
              <div className="px-3 pb-2 group-data-[collapsible=icon]:hidden">
                <Select
                  value={selectedCompanyId ?? "all"}
                  onValueChange={(v) => setSelectedCompanyId(v === "all" ? null : v)}
                >
                  <SelectTrigger className="w-full bg-background">
                    <Building2 className="mr-2 h-4 w-4 shrink-0 text-muted-foreground" />
                    <SelectValue placeholder="Todas as empresas" />
                  </SelectTrigger>
                  <SelectContent className="z-50 bg-popover">
                    <SelectItem value="all">Todas as empresas</SelectItem>
                    {companies?.map((c) => (
                      <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            <SidebarGroupContent>
              <SidebarMenu>
                {companyItems.map((item) => (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton asChild>
                      <NavLink
                        to={item.url}
                        end
                        className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-sidebar-foreground transition-colors hover:bg-sidebar-accent"
                        activeClassName="bg-primary/10 text-primary font-semibold"
                      >
                        <item.icon className="h-4 w-4" />
                        <span>{item.title}</span>
                      </NavLink>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                ))}
              </SidebarMenu>
            </SidebarGroupContent>
          </SidebarGroup>
        )}

        <SidebarGroup>
          <SidebarGroupLabel className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Pessoal
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {commonItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild>
                    <NavLink
                      to={item.url}
                      end
                      className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-sidebar-foreground transition-colors hover:bg-sidebar-accent"
                      activeClassName="bg-primary/10 text-primary font-semibold"
                    >
                      <item.icon className="h-4 w-4" />
                      <span>{item.title}</span>
                    </NavLink>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter className="border-t border-sidebar-border p-3">
        <div className="flex items-center justify-center gap-2 group-data-[collapsible=icon]:flex-col">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-9 w-9 text-sidebar-foreground hover:bg-sidebar-accent">
                <ThemeIcon className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent side="top" align="start">
              <DropdownMenuItem onClick={() => setTheme("light")}>
                <Sun className="mr-2 h-4 w-4" /> Claro
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => setTheme("dark")}>
                <Moon className="mr-2 h-4 w-4" /> Escuro
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => setTheme("system")}>
                <Monitor className="mr-2 h-4 w-4" /> Sistema
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>

          <Button
            variant="ghost"
            size="icon"
            className="h-9 w-9 text-destructive hover:bg-destructive/10 hover:text-destructive"
            onClick={handleLogout}
          >
            <LogOut className="h-4 w-4" />
          </Button>
        </div>
      </SidebarFooter>
    </Sidebar>
  );
}
