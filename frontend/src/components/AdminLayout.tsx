import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AdminSidebar } from "@/components/AdminSidebar";
import { NotificationBell } from "@/components/NotificationBell";

interface AdminLayoutProps {
  children: React.ReactNode;
}

function getSidebarDefaultOpen(): boolean {
  const match = document.cookie.split("; ").find((c) => c.startsWith("sidebar:state="));
  if (!match) return true;
  return match.split("=")[1] === "true";
}

export function AdminLayout({ children }: AdminLayoutProps) {
  return (
    <SidebarProvider defaultOpen={getSidebarDefaultOpen()}>
      <div className="flex min-h-screen w-full">
        <AdminSidebar />
        <div className="flex min-w-0 flex-1 flex-col">
          <header className="sticky top-0 z-40 flex h-12 items-center justify-end border-b border-border bg-background/90 px-3 backdrop-blur-sm md:px-6 lg:px-8">
            <NotificationBell />
          </header>
          <main className="flex-1 overflow-x-hidden p-6 lg:p-8">{children}</main>
        </div>
        {/* Mobile-only hamburger — sidebar is a hidden Sheet on small screens */}
        <div className="fixed left-3 top-3 z-50 md:hidden">
          <SidebarTrigger className="rounded-lg border border-border bg-background/90 shadow-sm backdrop-blur-sm" />
        </div>
      </div>
    </SidebarProvider>
  );
}
