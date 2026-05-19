import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { ThemeProvider } from "next-themes";
import { AuthProvider } from "@/contexts/AuthContext";
import { ProtectedRoute } from "@/components/ProtectedRoute";
import LoginPage from "./pages/LoginPage";
import DashboardPage from "./pages/DashboardPage";
import TestIntro from "./pages/TestIntro";
import ScenarioTest from "./pages/ScenarioTest";
import ResultPage from "./pages/ResultPage";
import CompareProfiles from "./pages/CompareProfiles";
import LeaderTeamPage from "./pages/LeaderTeamPage";
import LeaderGuidePage from "./pages/LeaderGuidePage";
import AdminCollaboratorsPage from "./pages/AdminCollaboratorsPage";
import InvitePage from "./pages/InvitePage";
import CompanyDashboardPage from "./pages/CompanyDashboardPage";
import TestHistoryPage from "./pages/TestHistoryPage";
import TeamAnalysisPage from "./pages/TeamAnalysisPage";
import LeaderCompatibilityPage from "./pages/LeaderCompatibilityPage";
import AdminTestsPage from "./pages/AdminTestsPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import ResetPasswordPage from "./pages/ResetPasswordPage";
import MyProfilePage from "./pages/MyProfilePage";
import CulturePage from "./pages/CulturePage";
import GoalsPage from "./pages/GoalsPage";
import EvaluationPage from "./pages/EvaluationPage";
import NineBoxPage from "./pages/NineBoxPage";
import MyEvaluationPage from "./pages/MyEvaluationPage";
import CareerTracksPage from "./pages/CareerTracksPage";
import MyCareerPage from "./pages/MyCareerPage";
import PdiTeamPage from "./pages/PdiTeamPage";
import MyPdiPage from "./pages/MyPdiPage";
import LearningAdminPage from "./pages/LearningAdminPage";
import MyLearningPage from "./pages/MyLearningPage";
import WorkshopsAdminPage from "./pages/WorkshopsAdminPage";
import MyWorkshopsPage from "./pages/MyWorkshopsPage";
import CommunicationsAdminPage from "./pages/CommunicationsAdminPage";
import ComunicadosPage from "./pages/ComunicadosPage";
import OnboardingAdminPage from "./pages/OnboardingAdminPage";
import MyOnboardingPage from "./pages/MyOnboardingPage";
import SurveysAdminPage from "./pages/SurveysAdminPage";
import MySurveysPage from "./pages/MySurveysPage";
import AbsencesAdminPage from "./pages/AbsencesAdminPage";
import MyAbsencesPage from "./pages/MyAbsencesPage";
import BenefitsAdminPage from "./pages/BenefitsAdminPage";
import MeusBeneficiosPage from "./pages/MeusBeneficiosPage";
import ReportsAdminPage from "./pages/ReportsAdminPage";
import CalendarPage from "./pages/CalendarPage";
import LogsAdminPage from "./pages/LogsAdminPage";
import NotFound from "./pages/NotFound";
import AuthCallback from "./pages/AuthCallback";
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
            <Route path="/" element={<Navigate to="/login" replace />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/auth/callback" element={<AuthCallback />} />
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
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <CompareProfiles />
                </ProtectedRoute>
              }
            />
            <Route
              path="/lider/equipe"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <LeaderTeamPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/lider/guia/:userId"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <LeaderGuidePage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/empresa"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <CompanyDashboardPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/colaboradores"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <AdminCollaboratorsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/testes"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <AdminTestsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/metas"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <GoalsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/avaliacao"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <EvaluationPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/9box"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <NineBoxPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/analise-equipe"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
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
            <Route
              path="/cultura"
              element={
                <ProtectedRoute>
                  <CulturePage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/minha-avaliacao"
              element={
                <ProtectedRoute>
                  <MyEvaluationPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/trilhas"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <CareerTracksPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/minha-trilha"
              element={
                <ProtectedRoute>
                  <MyCareerPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/pdi"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <PdiTeamPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meu-pdi"
              element={
                <ProtectedRoute>
                  <MyPdiPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/universidade"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <LearningAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/minha-universidade"
              element={
                <ProtectedRoute>
                  <MyLearningPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/workshops"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <WorkshopsAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/workshops"
              element={
                <ProtectedRoute>
                  <MyWorkshopsPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/comunicados"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <CommunicationsAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/comunicados"
              element={
                <ProtectedRoute>
                  <ComunicadosPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/onboarding"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <OnboardingAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meu-onboarding"
              element={
                <ProtectedRoute>
                  <MyOnboardingPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/pesquisas"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <SurveysAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/pesquisas"
              element={
                <ProtectedRoute>
                  <MySurveysPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/ausencias"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <AbsencesAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/minhas-ausencias"
              element={
                <ProtectedRoute>
                  <MyAbsencesPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/beneficios"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <BenefitsAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/meus-beneficios"
              element={
                <ProtectedRoute>
                  <MeusBeneficiosPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/relatorios"
              element={
                <ProtectedRoute requiredRoles={["master_admin", "manager"]}>
                  <ReportsAdminPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/calendario"
              element={
                <ProtectedRoute>
                  <CalendarPage />
                </ProtectedRoute>
              }
            />
            <Route
              path="/admin/logs"
              element={
                <ProtectedRoute requiredRoles={["master_admin"]}>
                  <LogsAdminPage />
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
