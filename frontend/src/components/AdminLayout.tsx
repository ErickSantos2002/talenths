import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AdminSidebar } from "@/components/AdminSidebar";

interface AdminLayoutProps {
  children: React.ReactNode;
}

export function AdminLayout({ children }: AdminLayoutProps) {
  return (
    <SidebarProvider>
      <div className="flex min-h-screen w-full">
        <AdminSidebar />
        <main className="flex-1 p-6 lg:p-8">{children}</main>
        {/* Mobile-only hamburger — sidebar is a hidden Sheet on small screens */}
        <div className="fixed left-3 top-3 z-50 md:hidden">
          <SidebarTrigger className="rounded-lg border border-border bg-background/90 shadow-sm backdrop-blur-sm" />
        </div>
      </div>
    </SidebarProvider>
  );
}
