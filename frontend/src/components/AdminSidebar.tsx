import { useState } from "react";
import { ChangelogModal } from "@/components/ChangelogModal";
import { ChevronRight, LogOut, Sun, Moon, Monitor } from "lucide-react";
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
import { menuSections, type Screen, type Section } from "@/help/screens";

// ── Types ─────────────────────────────────────────────────────────────────────

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

function NavItem({ item }: { item: Screen }) {
  const navigate = useNavigate();
  const location = useLocation();
  const { title, icon: Icon, tour } = item.menu!;
  const isActive = location.pathname === item.path || location.pathname.startsWith(item.path + "/");

  return (
    <SidebarMenuItem>
      <SidebarMenuButton
        tooltip={title}
        data-tour={tour}
        isActive={isActive}
        onClick={() => navigate(item.path)}
        className={cn(
          "flex items-center gap-3 text-sm font-medium text-sidebar-foreground/80 transition-all",
          isActive && "bg-primary/10 text-primary font-semibold shadow-[inset_-2px_0_0_hsl(var(--primary))]"
        )}
      >
        <Icon className="h-4 w-4 shrink-0" />
        <span className="truncate">{title}</span>
      </SidebarMenuButton>
    </SidebarMenuItem>
  );
}

// ── CollapsibleSection component ──────────────────────────────────────────────

function CollapsibleSection({
  section,
  items,
  isOpen,
  onToggle,
  collapsed,
}: {
  section: Section;
  items: Screen[];
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
            {items.map((item) => <NavItem key={item.path} item={item} />)}
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
              {items.map((item) => <NavItem key={item.path} item={item} />)}
            </SidebarMenu>
          </SidebarGroupContent>
        </CollapsibleContent>
      </SidebarGroup>
    </Collapsible>
  );
}

// ── Main component ────────────────────────────────────────────────────────────

export function AdminSidebar() {
  const { roles, signOut, profile } = useAuth();
  const { theme, setTheme } = useTheme();
  const systemTheme = useSystemTheme();
  const effectiveTheme = theme === "system" ? systemTheme : theme;
  const navigate = useNavigate();
  const { state: sidebarState } = useSidebar();
  const collapsed = sidebarState === "collapsed";

  const [openSections, setOpenSections] = useState<Record<string, boolean>>(loadSectionState);
  const [changelogOpen, setChangelogOpen] = useState(false);

  const toggleSection = (key: string) => {
    setOpenSections((prev) => {
      const next = { ...prev, [key]: !prev[key] };
      saveSectionState(next);
      return next;
    });
  };

  const ctx = {
    roles,
    timeclockEnabled: !!profile?.timeclock_enabled,
  };
  const mainSections = menuSections("main", ctx);
  const companySections = menuSections("company", ctx);
  const personalSections = menuSections("personal", ctx);

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

      <SidebarContent className="gap-0" data-tour="menu">
        {/* Dashboard */}
        <SidebarGroup className={collapsed ? undefined : "pb-1"}>
          {!collapsed && (
            <p className="px-3 pt-3 pb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 select-none">
              Menu
            </p>
          )}
          <SidebarGroupContent>
            <SidebarMenu>
              {mainSections.flatMap(({ items }) => items).map((item) => (
                <NavItem key={item.path} item={item} />
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        {/* Admin sections */}
        {companySections.length > 0 && (
          <div data-tour="menu-company">
            {!collapsed && (
              <div className="mx-3 my-1 border-t border-sidebar-border" />
            )}
            {!collapsed && (
              <p className="px-3 pt-3 pb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 select-none">
                Empresa
              </p>
            )}
            {companySections.map(({ section, items }) => (
              <CollapsibleSection
                key={section.key}
                section={section}
                items={items}
                isOpen={!!openSections[section.key]}
                onToggle={() => toggleSection(section.key)}
                collapsed={collapsed}
              />
            ))}
          </div>
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
        {personalSections.map(({ section, items }) => (
          <CollapsibleSection
            key={section.key}
            section={section}
            items={items}
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
            <p className="text-xs font-semibold text-muted-foreground/60 leading-tight hover:text-muted-foreground transition-colors">TalentHS v1.13.0</p>
            <p className="text-[10px] text-muted-foreground/35 leading-tight">© 2026 Health & Safety Tech</p>
          </button>
        </div>
        <ChangelogModal open={changelogOpen} onOpenChange={setChangelogOpen} />
      </SidebarFooter>
    </Sidebar>
  );
}
