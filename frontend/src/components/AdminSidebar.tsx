import { useState } from "react";
import { ChangelogModal } from "@/components/ChangelogModal";
import {
  LayoutDashboard, Building2, Users, ClipboardList, ClipboardCheck, Grid3X3,
  GitBranch, LogOut, Sun, Moon, Monitor, UserPen, HeartHandshake, Target,
  BookOpen, GraduationCap, CalendarDays, Megaphone, ListChecks, BarChart2, CalendarOff,
  Gift, FileDown, Shield, ChevronRight, DollarSign, Presentation, ScrollText, MessageSquare, FileText, Clock,
  Dices,
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useTheme } from "next-themes";
import { useSystemTheme } from "@/hooks/use-system-theme";
import { useNavigate, useLocation } from "react-router-dom";
import {
  Sidebar, SidebarContent, SidebarFooter, SidebarGroup, SidebarGroupContent,
  SidebarMenu, SidebarMenuButton, SidebarMenuItem, SidebarTrigger, useSidebar,
} from "@/components/ui/sidebar";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

// ── Types ─────────────────────────────────────────────────────────────────────

interface NavItem {
  title: string;
  url: string;
  icon: React.ElementType;
}

interface NavSection {
  key: string;
  label: string;
  items: NavItem[];
}

// ── Admin sections ────────────────────────────────────────────────────────────

const adminSections: NavSection[] = [
  {
    key: "pessoas",
    label: "Pessoas",
    items: [
      { title: "Colaboradores", url: "/admin/colaboradores", icon: Users },
    ],
  },
  {
    key: "desempenho",
    label: "Desempenho",
    items: [
      { title: "Metas", url: "/admin/metas", icon: Target },
      { title: "Avaliação", url: "/admin/avaliacao", icon: ClipboardList },
      { title: "Mapa 9Box", url: "/admin/9box", icon: Grid3X3 },
      { title: "Testes", url: "/admin/testes", icon: ClipboardCheck },
    ],
  },
  {
    key: "desenvolvimento",
    label: "Desenvolvimento",
    items: [
      { title: "Trilha de Carreira", url: "/admin/trilhas", icon: GitBranch },
      { title: "PDI da Equipe", url: "/admin/pdi", icon: BookOpen },
      { title: "Universidade", url: "/admin/universidade", icon: GraduationCap },
      { title: "Workshops", url: "/admin/workshops", icon: CalendarDays },
    ],
  },
  {
    key: "comunicacao",
    label: "Comunicação",
    items: [
      { title: "Comunicados", url: "/admin/comunicados", icon: Megaphone },
      { title: "Onboarding", url: "/admin/onboarding", icon: ListChecks },
      { title: "Pesquisas", url: "/admin/pesquisas", icon: BarChart2 },
      { title: "Feedbacks", url: "/admin/feedbacks", icon: MessageSquare },
      { title: "Documentos", url: "/admin/documentos", icon: FileText },
      { title: "Bingo", url: "/admin/bingo", icon: Dices },
    ],
  },
  {
    key: "rh",
    label: "Gestão de RH",
    items: [
      { title: "Ausências", url: "/admin/ausencias", icon: CalendarOff },
      { title: "Benefícios", url: "/admin/beneficios", icon: Gift },
      { title: "Ponto Eletrônico", url: "/admin/ponto", icon: Clock },
      { title: "Tabela Salarial", url: "/admin/tabela-salarial", icon: DollarSign },
    ],
  },
  {
    key: "sistema",
    label: "Sistema",
    items: [
      { title: "Minha Empresa", url: "/admin/empresa", icon: Building2 },
      { title: "Relatórios", url: "/admin/relatorios", icon: FileDown },
    ],
  },
];

// Logs is added to "sistema" only for master_admin — handled at render time

// ── Personal sections ─────────────────────────────────────────────────────────

const personalSections: NavSection[] = [
  {
    key: "meu-espaco",
    label: "Meu Espaço",
    items: [
      { title: "Meu Perfil", url: "/meu-perfil", icon: UserPen },
      { title: "Nossa Cultura", url: "/cultura", icon: HeartHandshake },
      { title: "Regras Internas", url: "/regras-internas", icon: ScrollText },
      { title: "Calendário", url: "/calendario", icon: CalendarDays },
    ],
  },
  {
    key: "desempenho-pessoal",
    label: "Desempenho",
    items: [
      { title: "Minha Avaliação", url: "/minha-avaliacao", icon: ClipboardCheck },
      { title: "Meus Testes", url: "/meus-testes", icon: ClipboardList },
    ],
  },
  {
    key: "desenvolvimento-pessoal",
    label: "Desenvolvimento",
    items: [
      { title: "Minha Trilha", url: "/minha-trilha", icon: GitBranch },
      { title: "Meu PDI", url: "/meu-pdi", icon: BookOpen },
      { title: "Minha Universidade", url: "/minha-universidade", icon: GraduationCap },
      { title: "Workshops", url: "/workshops", icon: CalendarDays },
    ],
  },
  {
    key: "comunicacao-pessoal",
    label: "Comunicação",
    items: [
      { title: "Comunicados", url: "/comunicados", icon: Megaphone },
      { title: "Pesquisas", url: "/pesquisas", icon: BarChart2 },
      { title: "Feedbacks", url: "/meus-feedbacks", icon: MessageSquare },
      { title: "Documentos", url: "/meus-documentos", icon: FileText },
      { title: "Bingo", url: "/bingo", icon: Dices },
    ],
  },
  {
    key: "rh-pessoal",
    label: "RH",
    items: [
      { title: "Minhas Ausências", url: "/minhas-ausencias", icon: CalendarOff },
      { title: "Meus Benefícios", url: "/meus-beneficios", icon: Gift },
      { title: "Meu Onboarding", url: "/meu-onboarding", icon: ListChecks },
    ],
  },
];

// ── State helpers ─────────────────────────────────────────────────────────────

const STORAGE_KEY = "talenths-sidebar-sections";

function loadSectionState(): Record<string, boolean> {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) return JSON.parse(raw);
  } catch {}
  // Defaults: first section of each group open
  return { pessoas: true, "meu-espaco": true };
}

function saveSectionState(state: Record<string, boolean>) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch {}
}

// ── NavItem component ─────────────────────────────────────────────────────────

function NavItem({ item }: { item: NavItem }) {
  const navigate = useNavigate();
  const location = useLocation();
  const isActive = location.pathname === item.url || location.pathname.startsWith(item.url + "/");

  return (
    <SidebarMenuItem>
      <SidebarMenuButton
        tooltip={item.title}
        isActive={isActive}
        onClick={() => navigate(item.url)}
        className={cn(
          "flex items-center gap-3 text-sm font-medium text-sidebar-foreground/80 transition-all",
          isActive && "bg-primary/10 text-primary font-semibold shadow-[inset_-2px_0_0_hsl(var(--primary))]"
        )}
      >
        <item.icon className="h-4 w-4 shrink-0" />
        <span className="truncate">{item.title}</span>
      </SidebarMenuButton>
    </SidebarMenuItem>
  );
}

// ── CollapsibleSection component ──────────────────────────────────────────────

function CollapsibleSection({
  section,
  isOpen,
  onToggle,
  collapsed,
}: {
  section: NavSection;
  isOpen: boolean;
  onToggle: () => void;
  collapsed: boolean;
}) {
  // In icon mode: render items directly without collapsible wrapper
  if (collapsed) {
    return (
      <SidebarGroup>
        <SidebarGroupContent>
          <SidebarMenu>
            {section.items.map((item) => <NavItem key={item.url} item={item} />)}
          </SidebarMenu>
        </SidebarGroupContent>
      </SidebarGroup>
    );
  }

  return (
    <Collapsible open={isOpen} onOpenChange={onToggle}>
      <SidebarGroup className="py-0">
        <CollapsibleTrigger asChild>
          <button
            className={cn(
              "flex w-full items-center justify-between px-3 py-1.5 text-[10px] font-semibold uppercase tracking-widest transition-colors rounded-md",
              "text-muted-foreground/50 hover:text-muted-foreground"
            )}
          >
            <span>{section.label}</span>
            <ChevronRight
              className={cn(
                "h-3.5 w-3.5 transition-transform duration-200",
                isOpen && "rotate-90"
              )}
            />
          </button>
        </CollapsibleTrigger>
        <CollapsibleContent>
          <SidebarGroupContent className="pt-0.5 pb-1">
            <SidebarMenu>
              {section.items.map((item) => <NavItem key={item.url} item={item} />)}
            </SidebarMenu>
          </SidebarGroupContent>
        </CollapsibleContent>
      </SidebarGroup>
    </Collapsible>
  );
}

// ── Main component ────────────────────────────────────────────────────────────

export function AdminSidebar() {
  const { hasRole, signOut, profile } = useAuth();
  const { theme, setTheme } = useTheme();
  const systemTheme = useSystemTheme();
  const effectiveTheme = theme === "system" ? systemTheme : theme;
  const navigate = useNavigate();
  const { state: sidebarState } = useSidebar();
  const collapsed = sidebarState === "collapsed";

  const isAdmin = hasRole("master_admin") || hasRole("manager");
  const isMasterAdmin = hasRole("master_admin");

  const [openSections, setOpenSections] = useState<Record<string, boolean>>(loadSectionState);
  const [changelogOpen, setChangelogOpen] = useState(false);

  const toggleSection = (key: string) => {
    setOpenSections((prev) => {
      const next = { ...prev, [key]: !prev[key] };
      saveSectionState(next);
      return next;
    });
  };

  // Build admin sections with conditional Logs item
  const builtAdminSections: NavSection[] = adminSections.map((section) => {
    if (section.key === "sistema" && isMasterAdmin) {
      return {
        ...section,
        items: [...section.items, { title: "Logs", url: "/admin/logs", icon: Shield }],
      };
    }
    return section;
  });

  // "Meu Ponto" só aparece para quem o RH habilitou
  const builtPersonalSections: NavSection[] = personalSections.map((section) => {
    if (section.key === "rh-pessoal" && profile?.timeclock_enabled) {
      return {
        ...section,
        items: [...section.items, { title: "Meu Ponto", url: "/meu-ponto", icon: Clock }],
      };
    }
    return section;
  });

  const ThemeIcon = effectiveTheme === "dark" ? Moon : Sun;

  const handleLogout = async () => {
    await signOut();
    navigate("/login");
  };

  return (
    <Sidebar collapsible="icon" className="border-r border-sidebar-border">
      {/* Logo + trigger */}
      <div className="border-b border-sidebar-border">
        {/* Expanded state */}
        <div className="flex items-center justify-between px-3 py-3 group-data-[collapsible=icon]:hidden">
          <div className="flex items-center gap-3 min-w-0">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-primary/10 ring-1 ring-primary/20">
              <img
                src="/logo-sem-nome.png"
                alt="TalentHS"
                className="h-6 w-6 object-contain"
              />
            </div>
            <div className="min-w-0">
              <p className="text-sm font-semibold leading-tight text-sidebar-foreground truncate">TalentHS</p>
              <p className="text-[11px] leading-tight text-muted-foreground/70 truncate">Gestão de Pessoas</p>
            </div>
          </div>
          <SidebarTrigger className="shrink-0" />
        </div>
        {/* Collapsed state */}
        <div className="hidden flex-col items-center gap-2 py-3 group-data-[collapsible=icon]:flex">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 ring-1 ring-primary/20">
            <img
              src="/logo-sem-nome.png"
              alt="TalentHS"
              className="h-5 w-5 object-contain"
            />
          </div>
          <SidebarTrigger />
        </div>
      </div>

      <SidebarContent className="gap-0">
        {/* Dashboard */}
        <SidebarGroup className={collapsed ? undefined : "pb-1"}>
          {!collapsed && (
            <p className="px-3 pt-3 pb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 select-none">
              Menu
            </p>
          )}
          <SidebarGroupContent>
            <SidebarMenu>
              <NavItem item={{ title: "Apresentação", url: "/apresentacao", icon: Presentation }} />
              <NavItem item={{ title: "Dashboard", url: "/dashboard", icon: LayoutDashboard }} />
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        {/* Admin sections */}
        {isAdmin && (
          <>
            {!collapsed && (
              <div className="mx-3 my-1 border-t border-sidebar-border" />
            )}
            {!collapsed && (
              <p className="px-3 pt-3 pb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 select-none">
                Empresa
              </p>
            )}
            {builtAdminSections.map((section) => (
              <CollapsibleSection
                key={section.key}
                section={section}
                isOpen={!!openSections[section.key]}
                onToggle={() => toggleSection(section.key)}
                collapsed={collapsed}
              />
            ))}
          </>
        )}

        {/* Personal sections */}
        {!collapsed && (
          <div className="mx-3 my-1 border-t border-sidebar-border" />
        )}
        {!collapsed && (
          <p className="px-3 pt-3 pb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 select-none">
            Pessoal
          </p>
        )}
        {builtPersonalSections.map((section) => (
          <CollapsibleSection
            key={section.key}
            section={section}
            isOpen={!!openSections[section.key]}
            onToggle={() => toggleSection(section.key)}
            collapsed={collapsed}
          />
        ))}
      </SidebarContent>

      {/* Footer */}
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
        {/* Version info */}
        <div className="mt-2 group-data-[collapsible=icon]:hidden">
          <button
            onClick={() => setChangelogOpen(true)}
            className="w-full rounded-md px-2 py-1.5 text-center transition-colors hover:bg-sidebar-accent"
          >
            <p className="text-xs font-semibold text-muted-foreground/60 leading-tight hover:text-muted-foreground transition-colors">TalentHS v1.8.0</p>
            <p className="text-[10px] text-muted-foreground/35 leading-tight">© 2026 Health & Safety Tech</p>
          </button>
        </div>
        <ChangelogModal open={changelogOpen} onOpenChange={setChangelogOpen} />
      </SidebarFooter>
    </Sidebar>
  );
}
