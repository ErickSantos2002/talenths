import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { ThemeProvider } from "next-themes";
import { AuthProvider } from "@/contexts/AuthContext";
import { ProtectedRoute } from "@/components/ProtectedRoute";
import HomePage from "./pages/HomePage";
import LoginPage from "./pages/LoginPage";
import DashboardPage from "./pages/DashboardPage";
import TestIntro from "./pages/TestIntro";
import ScenarioTest from "./pages/ScenarioTest";
import ResultPage from "./pages/ResultPage";
import CompareProfiles from "./pages/CompareProfiles";
import LeaderTeamPage from "./pages/LeaderTeamPage";
import LeaderGuidePage from "./pages/LeaderGuidePage";
import AdminCompaniesPage from "./pages/AdminCompaniesPage";
import AdminCollaboratorsPage from "./pages/AdminCollaboratorsPage";
import AdminSettingsPage from "./pages/AdminSettingsPage";
import InvitePage from "./pages/InvitePage";
import CompanyDashboardPage from "./pages/CompanyDashboardPage";
import TestHistoryPage from "./pages/TestHistoryPage";
import TeamAnalysisPage from "./pages/TeamAnalysisPage";
import LeaderCompatibilityPage from "./pages/LeaderCompatibilityPage";
import AdminTestsPage from "./pages/AdminTestsPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import ResetPasswordPage from "./pages/ResetPasswordPage";
import MyProfilePage from "./pages/MyProfilePage";
import NotFound from "./pages/NotFound";
import { ChatWidget } from "./components/chat/ChatWidget";

const queryClient = new QueryClient();

const App = () => (
  <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/convite/:token" element={<InvitePage />} />
            <Route path="/forgot-password" element={<ForgotPasswordPage />} />
            <Route path="/reset-password" element={<ResetPasswordPage />} />
            <Route
              path="/dashboard"
              element={
                <ProtectedRoute>
                  <DashboardPage />
                </ProtectedRoute>
              }
            />
            <Route path="/teste" element={<TestIntro />} />
            <Route
              path="/teste/cenarios"
              element={
                <ProtectedRoute>
                  <ScenarioTest />
                </ProtectedRoute>
              }
            />
            <Route
              path="/resultado"
              element={
                <ProtectedRoute>
                  <ResultPage />
                </ProtectedRoute>
              }
            />
            <Route path="/resultado/compartilhado" element={<ResultPage />} />
            <Route
              path="/comparar-perfis"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "company_admin"]}>
                  <CompareProfiles />
                </ProtectedRoute>
              }
            />
            <Route
              path="/lider/equipe"
              element={
                <ProtectedRoute requiredRoles={["leader", "master_admin", "company_admin"]}>
                  <LeaderTeamPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/lider/guia/:userId"
              element={
                <ProtectedRoute requiredRoles={["leader", "master_admin", "company_admin"]}>
                  <LeaderGuidePage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/empresas"
              element={
                <ProtectedRoute requiredRoles={["master_admin"]}>
                  <AdminCompaniesPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/empresa"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "company_admin"]}>
                  <CompanyDashboardPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/colaboradores"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "company_admin"]}>
                  <AdminCollaboratorsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/testes"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "company_admin"]}>
                  <AdminTestsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/configuracoes"
              element={
                <ProtectedRoute requiredRoles={["master_admin"]}>
                  <AdminSettingsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/analise-equipe"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "company_admin"]}>
                  <TeamAnalysisPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meu-perfil"
              element={
                <ProtectedRoute>
                  <MyProfilePage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meu-historico"
              element={
                <ProtectedRoute>
                  <TestHistoryPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meu-perfil/compatibilidade"
              element={
                <ProtectedRoute>
                  <LeaderCompatibilityPage />
                </ProtectedRoute>
              }
            />
            {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
            <Route path="*" element={<NotFound />} />
          </Routes>
          <ChatWidget />
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
  </ThemeProvider>
);

export default App;
