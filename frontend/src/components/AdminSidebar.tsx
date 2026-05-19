import { LayoutDashboard, Building2, Users, GitCompareArrows, ClipboardList, ClipboardCheck, Grid3X3, GitBranch, LogOut, Sun, Moon, Monitor, UserPen, HeartHandshake, Target, BookOpen, GraduationCap, CalendarDays, Megaphone, ListChecks, BarChart2 } from "lucide-react";
import { NavLink } from "@/components/NavLink";
import { useAuth } from "@/contexts/AuthContext";
import { useTheme } from "next-themes";
import { useSystemTheme } from "@/hooks/use-system-theme";
import { useNavigate } from "react-router-dom";
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
import { Button } from "@/components/ui/button";

const mainItems = [
  { title: "Dashboard", url: "/dashboard", icon: LayoutDashboard },
];

const adminCompanyItems = [
  { title: "Minha Empresa", url: "/admin/empresa", icon: Building2 },
  { title: "Colaboradores", url: "/admin/colaboradores", icon: Users },
  { title: "Testes", url: "/admin/testes", icon: ClipboardList },
  { title: "Metas", url: "/admin/metas", icon: Target },
  { title: "Avaliação", url: "/admin/avaliacao", icon: ClipboardList },
  { title: "Mapa 9Box", url: "/admin/9box", icon: Grid3X3 },
  { title: "Trilha de Carreira", url: "/admin/trilhas", icon: GitBranch },
  { title: "PDI da Equipe", url: "/admin/pdi", icon: BookOpen },
  { title: "Universidade", url: "/admin/universidade", icon: GraduationCap },
  { title: "Workshops", url: "/admin/workshops", icon: CalendarDays },
  { title: "Comunicação", url: "/admin/comunicados", icon: Megaphone },
  { title: "Onboarding", url: "/admin/onboarding", icon: ListChecks },
  { title: "Pesquisas", url: "/admin/pesquisas", icon: BarChart2 },
  { title: "Comparar Perfis", url: "/comparar-perfis", icon: GitCompareArrows },
  { title: "Análise de Equipe", url: "/admin/analise-equipe", icon: Grid3X3 },
];

const commonItems = [
  { title: "Comunicados", url: "/comunicados", icon: Megaphone },
  { title: "Meu Onboarding", url: "/meu-onboarding", icon: ListChecks },
  { title: "Pesquisas", url: "/pesquisas", icon: BarChart2 },
  { title: "Nossa Cultura", url: "/cultura", icon: HeartHandshake },
  { title: "Minha Avaliação", url: "/minha-avaliacao", icon: ClipboardCheck },
  { title: "Minha Trilha", url: "/minha-trilha", icon: GitBranch },
  { title: "Meu PDI", url: "/meu-pdi", icon: BookOpen },
  { title: "Minha Universidade", url: "/minha-universidade", icon: GraduationCap },
  { title: "Workshops", url: "/workshops", icon: CalendarDays },
  { title: "Meu Perfil", url: "/meu-perfil", icon: UserPen },
  { title: "Meu Histórico", url: "/meu-historico", icon: ClipboardList },
  { title: "Compatibilidade", url: "/meu-perfil/compatibilidade", icon: GitCompareArrows },
];

export function AdminSidebar() {
  const { hasRole, signOut } = useAuth();
  const { theme, setTheme } = useTheme();
  const systemTheme = useSystemTheme();
  const effectiveTheme = theme === "system" ? systemTheme : theme;
  const navigate = useNavigate();
  const isAdmin = hasRole("master_admin") || hasRole("manager");
  const companyItems = isAdmin ? adminCompanyItems : [];

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
          src="/logo.png"
          alt="TalentHS Logo"
          className="h-8 w-auto group-data-[collapsible=icon]:hidden"
        />
        <img
          src="/logo.png"
          alt="TalentHS"
          className="hidden h-6 w-auto group-data-[collapsible=icon]:block"
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
