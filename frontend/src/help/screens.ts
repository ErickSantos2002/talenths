import type { LucideIcon } from "lucide-react";
import {
  LayoutDashboard, Building2, Users, ClipboardList, ClipboardCheck, Grid3X3,
  GitBranch, UserPen, HeartHandshake, Target,
  BookOpen, GraduationCap, CalendarDays, Megaphone, ListChecks, BarChart2, CalendarOff,
  Gift, FileDown, Shield, DollarSign, Presentation, ScrollText, MessageSquare, FileText, Clock,
  Dices, Video, LifeBuoy,
} from "lucide-react";

export type AppRole = "master_admin" | "manager" | "user";
export type MenuGroup = "main" | "company" | "personal";

export interface Section {
  key: string;
  label: string;
  group: MenuGroup;
}

export interface Screen {
  /** react-router pattern, identical to App.tsx */
  path: string;
  /** used in "Abrindo X…" / "Vamos para X" */
  name: string;
  roles: AppRole[];
  requires?: "timeclock_enabled";
  /** Section.key; no section = not in the menu */
  section?: string;
  /** tour = value of the data-tour attribute */
  menu?: { title: string; icon: LucideIcon; tour: string };
}

export interface ScreenContext {
  roles: AppRole[];
  timeclockEnabled: boolean;
}

const ALL: AppRole[] = ["master_admin", "manager", "user"];
const ADMIN: AppRole[] = ["master_admin", "manager"];
const MASTER: AppRole[] = ["master_admin"];

export const SECTIONS: Section[] = [
  { key: "menu", label: "Menu", group: "main" },

  { key: "pessoas", label: "Pessoas", group: "company" },
  { key: "desempenho", label: "Desempenho", group: "company" },
  { key: "desenvolvimento", label: "Desenvolvimento", group: "company" },
  { key: "comunicacao", label: "Comunicação", group: "company" },
  { key: "rh", label: "Gestão de RH", group: "company" },
  { key: "sistema", label: "Sistema", group: "company" },

  { key: "meu-espaco", label: "Meu Espaço", group: "personal" },
  { key: "desempenho-pessoal", label: "Desempenho", group: "personal" },
  { key: "desenvolvimento-pessoal", label: "Desenvolvimento", group: "personal" },
  { key: "comunicacao-pessoal", label: "Comunicação", group: "personal" },
  { key: "rh-pessoal", label: "RH", group: "personal" },
];

// Menu items: the tour anchor is derived from the URL ("menu-" + last segment,
// with "admin-" for admin screens), so it is built by this helper.
function item(
  path: string,
  title: string,
  icon: LucideIcon,
  section: string,
  roles: AppRole[],
  extra?: Pick<Screen, "requires">,
  tour?: string,
): Screen {
  const last = path.split("/").filter(Boolean).pop()!;
  const derived = path.startsWith("/admin/") ? `menu-admin-${last}` : `menu-${last}`;
  return { path, name: title, roles, section, menu: { title, icon, tour: tour ?? derived }, ...extra };
}

// Screens without a menu entry (detail/print/edit pages).
function hidden(path: string, name: string, roles: AppRole[]): Screen {
  return { path, name, roles };
}

export const SCREENS: Screen[] = [
  // main
  item("/apresentacao", "Apresentação", Presentation, "menu", ALL),
  item("/dashboard", "Dashboard", LayoutDashboard, "menu", ALL),
  item("/ajuda", "Ajuda", LifeBuoy, "menu", ALL, undefined, "menu-help"),

  // company
  item("/admin/colaboradores", "Colaboradores", Users, "pessoas", ADMIN),

  item("/admin/metas", "Metas", Target, "desempenho", ADMIN),
  item("/admin/avaliacao", "Avaliação", ClipboardList, "desempenho", ADMIN),
  item("/admin/9box", "Mapa 9Box", Grid3X3, "desempenho", ADMIN),
  item("/admin/testes", "Testes", ClipboardCheck, "desempenho", ADMIN),
  hidden("/admin/testes/:testId/editar", "Editar teste", ADMIN),
  hidden("/admin/testes/:testId/tentativas", "Tentativas do teste", ADMIN),

  item("/admin/trilhas", "Trilha de Carreira", GitBranch, "desenvolvimento", ADMIN),
  item("/admin/pdi", "PDI da Equipe", BookOpen, "desenvolvimento", ADMIN),
  item("/admin/universidade", "Universidade", GraduationCap, "desenvolvimento", ADMIN),
  item("/admin/workshops", "Workshops", CalendarDays, "desenvolvimento", ADMIN),

  item("/admin/comunicados", "Comunicados", Megaphone, "comunicacao", ADMIN),
  item("/admin/onboarding", "Onboarding", ListChecks, "comunicacao", ADMIN),
  item("/admin/pesquisas", "Pesquisas", BarChart2, "comunicacao", ADMIN),
  item("/admin/feedbacks", "Feedbacks", MessageSquare, "comunicacao", ADMIN),
  item("/admin/documentos", "Documentos", FileText, "comunicacao", ADMIN),
  item("/admin/videos", "Vídeos", Video, "comunicacao", ADMIN),
  item("/admin/bingo", "Bingo", Dices, "comunicacao", ADMIN),
  hidden("/admin/bingo/:gameId/imprimir", "Impressão do bingo", ADMIN),

  item("/admin/ausencias", "Ausências", CalendarOff, "rh", ADMIN),
  item("/admin/beneficios", "Benefícios", Gift, "rh", ADMIN),
  item("/admin/ponto", "Ponto Eletrônico", Clock, "rh", ADMIN),
  item("/admin/tabela-salarial", "Tabela Salarial", DollarSign, "rh", ADMIN),

  item("/admin/empresa", "Minha Empresa", Building2, "sistema", ADMIN),
  item("/admin/relatorios", "Relatórios", FileDown, "sistema", ADMIN),
  item("/admin/logs", "Logs", Shield, "sistema", MASTER),

  // personal
  item("/meu-perfil", "Meu Perfil", UserPen, "meu-espaco", ALL),
  item("/cultura", "Nossa Cultura", HeartHandshake, "meu-espaco", ALL),
  item("/regras-internas", "Regras Internas", ScrollText, "meu-espaco", ALL),
  item("/calendario", "Calendário", CalendarDays, "meu-espaco", ALL),

  item("/minha-avaliacao", "Minha Avaliação", ClipboardCheck, "desempenho-pessoal", ALL),
  item("/meus-testes", "Meus Testes", ClipboardList, "desempenho-pessoal", ALL),
  hidden("/meus-testes/:testId/realizar", "Realizar teste", ALL),
  hidden("/meus-testes/tentativas/:attemptId", "Resultado do teste", ALL),

  item("/minha-trilha", "Minha Trilha", GitBranch, "desenvolvimento-pessoal", ALL),
  item("/meu-pdi", "Meu PDI", BookOpen, "desenvolvimento-pessoal", ALL),
  item("/minha-universidade", "Minha Universidade", GraduationCap, "desenvolvimento-pessoal", ALL),
  item("/workshops", "Workshops", CalendarDays, "desenvolvimento-pessoal", ALL),

  item("/comunicados", "Comunicados", Megaphone, "comunicacao-pessoal", ALL),
  item("/pesquisas", "Pesquisas", BarChart2, "comunicacao-pessoal", ALL),
  item("/meus-feedbacks", "Feedbacks", MessageSquare, "comunicacao-pessoal", ALL),
  item("/meus-documentos", "Documentos", FileText, "comunicacao-pessoal", ALL),
  item("/meus-videos", "Vídeos", Video, "comunicacao-pessoal", ALL),
  hidden("/videos/:id", "Vídeo", ALL),
  item("/bingo", "Bingo", Dices, "comunicacao-pessoal", ALL),

  item("/minhas-ausencias", "Minhas Ausências", CalendarOff, "rh-pessoal", ALL),
  item("/meus-beneficios", "Meus Benefícios", Gift, "rh-pessoal", ALL),
  item("/meu-onboarding", "Meu Onboarding", ListChecks, "rh-pessoal", ALL),
  item("/meu-ponto", "Meu Ponto", Clock, "rh-pessoal", ALL, { requires: "timeclock_enabled" }),
];

function allowed(screen: Screen, ctx: ScreenContext): boolean {
  if (!screen.roles.some((r) => ctx.roles.includes(r))) return false;
  if (screen.requires === "timeclock_enabled" && !ctx.timeclockEnabled) return false;
  return true;
}

export function screensFor(ctx: ScreenContext): Screen[] {
  return SCREENS.filter((s) => allowed(s, ctx));
}

export function canOpen(path: string, ctx: ScreenContext): boolean {
  const screen = SCREENS.find((s) => s.path === path);
  return !!screen && allowed(screen, ctx);
}

export function screenName(path: string): string {
  return SCREENS.find((s) => s.path === path)?.name ?? "esta tela";
}

export function menuSections(
  group: MenuGroup,
  ctx: ScreenContext,
): { section: Section; items: Screen[] }[] {
  const visible = screensFor(ctx).filter((s) => s.menu);
  return SECTIONS.filter((section) => section.group === group)
    .map((section) => ({ section, items: visible.filter((s) => s.section === section.key) }))
    .filter((entry) => entry.items.length > 0);
}
