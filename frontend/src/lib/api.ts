const BASE_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000";

const TOKEN_KEY = "talenths_token";

export function getToken(): string | null {
  return localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string): void {
  localStorage.setItem(TOKEN_KEY, token);
}

export function clearToken(): void {
  localStorage.removeItem(TOKEN_KEY);
}

async function request<T>(
  method: string,
  path: string,
  body?: unknown,
  options: { public?: boolean } = {}
): Promise<T> {
  const headers: Record<string, string> = { "Content-Type": "application/json" };

  if (!options.public) {
    const token = getToken();
    if (token) headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(`${BASE_URL}${path}`, {
    method,
    headers,
    body: body != null ? JSON.stringify(body) : undefined,
  });

  if (res.status === 401) {
    clearToken();
    window.location.href = "/login";
    throw new Error("Sessão expirada");
  }

  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(err.detail ?? "Erro na requisição");
  }

  if (res.status === 204) return undefined as T;
  return res.json();
}

const get = <T>(path: string, opts?: { public?: boolean }) => request<T>("GET", path, undefined, opts);
const post = <T>(path: string, body?: unknown, opts?: { public?: boolean }) => request<T>("POST", path, body, opts);
const patch = <T>(path: string, body?: unknown) => request<T>("PATCH", path, body);
const put = <T>(path: string, body?: unknown) => request<T>("PUT", path, body);
const del = (path: string) => request<void>("DELETE", path);

// ── Auth ──────────────────────────────────────────────────────────────────────

export const auth = {
  login: (email: string, password: string) =>
    post<{ access_token: string; user: { id: string; email: string; name?: string } }>(
      "/auth/login", { email, password }, { public: true }
    ),
  register: (email: string, password: string, name: string) =>
    post<{ access_token: string; user: { id: string; email: string; name?: string } }>(
      "/auth/register", { email, password, name }, { public: true }
    ),
  registerInvite: (data: { token: string; name: string; email: string; password: string; phone?: string }) =>
    post<{ access_token: string; user: { id: string; email: string; name?: string } }>(
      "/auth/register-invite", data, { public: true }
    ),
  logout: () => post("/auth/logout"),
  me: () => get<{ id: string; email: string; profile: Record<string, unknown> | null; roles: { role: string; company_id: string }[] }>("/auth/me"),
  updatePassword: (password: string) => patch("/auth/password", { password }),
};

// ── Profiles ──────────────────────────────────────────────────────────────────

export const profiles = {
  me: () => get<Record<string, unknown>>("/profiles/me"),
  update: (data: Record<string, unknown>) => patch<Record<string, unknown>>("/profiles/me", data),
  list: (companyId?: string) =>
    get<Record<string, unknown>[]>(`/profiles${companyId ? `?company_id=${companyId}` : ""}`),
  get: (userId: string) => get<Record<string, unknown>>(`/profiles/${userId}`),
};

// ── Companies ─────────────────────────────────────────────────────────────────

export const companies = {
  list: () => get<Record<string, unknown>[]>("/companies"),
  create: (data: { name: string; cnpj?: string; status?: string }) =>
    post<Record<string, unknown>>("/companies", data),
  update: (id: string, data: Record<string, unknown>) =>
    patch<Record<string, unknown>>(`/companies/${id}`, data),
  delete: (id: string) => del(`/companies/${id}`),
};

// ── Departments ───────────────────────────────────────────────────────────────

export const departments = {
  list: (companyId?: string) =>
    get<Record<string, unknown>[]>(`/departments${companyId ? `?company_id=${companyId}` : ""}`),
  create: (data: { name: string; company_id: string }) =>
    post<Record<string, unknown>>("/departments", data),
  update: (id: string, data: Record<string, unknown>) =>
    patch<Record<string, unknown>>(`/departments/${id}`, data),
  delete: (id: string) => del(`/departments/${id}`),
};

// ── Collaborators ─────────────────────────────────────────────────────────────

export const collaborators = {
  list: (companyId?: string) =>
    get<Record<string, unknown>[]>(`/collaborators${companyId ? `?company_id=${companyId}` : ""}`),
  create: (data: Record<string, unknown>) =>
    post<Record<string, unknown>>("/collaborators", data),
  update: (profileId: string, data: Record<string, unknown>) =>
    patch<Record<string, unknown>>(`/collaborators/${profileId}`, data),
  updateRole: (roleId: string, role: string) =>
    patch<Record<string, unknown>>(`/collaborators/${roleId}/role`, { role }),
  resetPassword: (profileId: string, password: string) =>
    patch<void>(`/collaborators/${profileId}/password`, { password }),
  delete: (profileId: string) => del(`/collaborators/${profileId}`),
};

// ── Tests ─────────────────────────────────────────────────────────────────────

// ── Invitations ───────────────────────────────────────────────────────────────

export const invitations = {
  list: (companyId?: string) =>
    get<Record<string, unknown>[]>(`/invitations${companyId ? `?company_id=${companyId}` : ""}`),
  byToken: (token: string) =>
    get<Record<string, unknown>>(`/invitations/token/${token}`, { public: true }),
  create: (data: Record<string, unknown>) =>
    post<Record<string, unknown>>("/invitations", data),
  update: (id: string, data: Record<string, unknown>) =>
    patch<Record<string, unknown>>(`/invitations/${id}`, data),
};

// ── Culture ───────────────────────────────────────────────────────────────────

export const culture = {
  get: () => get<{ purpose: string | null; manifesto: string | null; updated_at: string | null; values: { id: string; title: string; description: string | null; position: number }[] }>("/culture"),
  update: (data: { purpose?: string; manifesto?: string }) => put<{ purpose: string | null; manifesto: string | null; updated_at: string | null }>("/culture", data),
  createValue: (data: { title: string; description?: string }) => post<{ id: string; title: string; description: string | null; position: number }>("/culture/values", data),
  updateValue: (id: string, data: { title?: string; description?: string }) => put<{ id: string; title: string; description: string | null; position: number }>(`/culture/values/${id}`, data),
  deleteValue: (id: string) => del(`/culture/values/${id}`),
};

// ── Evaluations ───────────────────────────────────────────────────────────────

import type { EvalCycle, TeamMemberStatus, ScoreItem, NineBoxEntry } from "@/types/evaluations";

export const evaluations = {
  listCycles: () => get<EvalCycle[]>("/evaluations/cycles"),
  createCycle: (data: Partial<EvalCycle> & { name: string }) => post<EvalCycle>("/evaluations/cycles", data),
  updateCycle: (id: string, data: Partial<EvalCycle>) => put<EvalCycle>(`/evaluations/cycles/${id}`, data),
  submitEvaluation: (data: { eval_cycle_id: string; evaluated_user_id: string; eval_type: string; scores: ScoreItem[] }) =>
    post<{ ok: boolean; evaluation_id: string }>("/evaluations/submit", data),
  myEvaluation: (cycleId: string) =>
    get<{ submitted: boolean; submitted_at: string | null; scores: ScoreItem[] }>(`/evaluations/my?cycle_id=${cycleId}`),
  teamStatus: (cycleId: string) => get<TeamMemberStatus[]>(`/evaluations/team-status?cycle_id=${cycleId}`),
  scores: (cycleId: string, evaluatedUserId: string) =>
    get<{ eval_type: string; submitted_at: string | null; scores: ScoreItem[] }[]>(`/evaluations/scores?cycle_id=${cycleId}&evaluated_user_id=${evaluatedUserId}`),
  consolidate: (cycleId: string) => post<{ ok: boolean; updated: number }>(`/evaluations/cycles/${cycleId}/consolidate`),
  calibrate: (cycleId: string, data: { user_id: string; nine_box_x: number; nine_box_y: number; calibration_note?: string }) =>
    put<{ ok: boolean; quadrant: string }>(`/evaluations/cycles/${cycleId}/calibrate`, data),
  nineBox: (cycleId: string) =>
    get<{ grid: Record<string, NineBoxEntry[]>; total: number }>(`/evaluations/9box?cycle_id=${cycleId}`),
};

// ── Goals ─────────────────────────────────────────────────────────────────────

import type { Cycle, Goal, GoalDetail, GoalCreate, DepartmentOverview, MonthlyPlan } from "@/types/goals";

export const goals = {
  listCycles: () => get<Cycle[]>("/goals/cycles"),
  createCycle: (data: { name: string; start_date: string; end_date: string; min_curve_value?: number; max_progress_value?: number; status?: string }) =>
    post<Cycle>("/goals/cycles", data),
  updateCycle: (id: string, data: Partial<{ name: string; start_date: string; end_date: string; min_curve_value: number; max_progress_value: number; status: string }>) =>
    put<Cycle>(`/goals/cycles/${id}`, data),
  overview: (cycleId: string) => get<DepartmentOverview[]>(`/goals/overview?cycle_id=${cycleId}`),
  create: (data: GoalCreate) => post<Goal & { weight_warning: boolean }>("/goals", data),
  get: (id: string) => get<GoalDetail>(`/goals/${id}`),
  update: (id: string, data: Partial<GoalCreate>) => put<Goal>(`/goals/${id}`, data),
  delete: (id: string) => del(`/goals/${id}`),
  updatePlans: (goalId: string, plans: MonthlyPlan[]) => put<MonthlyPlan[]>(`/goals/${goalId}/plans`, { plans }),
  updateActual: (goalId: string, month: number, data: { actual_value: number; comment?: string }) =>
    put<{ ok: boolean }>(`/goals/${goalId}/actuals/${month}`, data),
  closeMonth: (goalId: string, month: number) => post<{ ok: boolean }>(`/goals/${goalId}/close/${month}`),
};

// ── Career ────────────────────────────────────────────────────────────────────

import type { CareerTrack, TeamCareerEntry, MyCareer } from "@/types/career";

export const career = {
  listTracks: () => get<CareerTrack[]>("/career/tracks"),
  createTrack: (data: { name: string; description?: string }) => post<CareerTrack>("/career/tracks", data),
  updateTrack: (id: string, data: { name: string; description?: string }) => put<CareerTrack>(`/career/tracks/${id}`, data),
  deleteTrack: (id: string) => del(`/career/tracks/${id}`),
  createLevel: (trackId: string, data: object) => post<object>(`/career/tracks/${trackId}/levels`, data),
  updateLevel: (levelId: string, data: object) => put<object>(`/career/levels/${levelId}`, data),
  deleteLevel: (levelId: string) => del(`/career/levels/${levelId}`),
  team: () => get<TeamCareerEntry[]>("/career/team"),
  my: () => get<MyCareer | null>("/career/my"),
  setEmployeeCareer: (userId: string, data: object) => put<{ ok: boolean }>(`/career/employee/${userId}`, data),
};

// ── PDI ───────────────────────────────────────────────────────────────────────

import type { PdiPlan, PdiAction } from "@/types/pdi";

export const pdi = {
  my: () => get<PdiPlan[]>("/pdi/my"),
  team: () => get<PdiPlan[]>("/pdi/team"),
  createPlan: (data: object) => post<PdiPlan>("/pdi/plans", data),
  updatePlan: (id: string, data: object) => put<PdiPlan>(`/pdi/plans/${id}`, data),
  deletePlan: (id: string) => del(`/pdi/plans/${id}`),
  addAction: (planId: string, data: object) => post<PdiAction>(`/pdi/plans/${planId}/actions`, data),
  updateAction: (actionId: string, data: object) => put<PdiAction>(`/pdi/actions/${actionId}`, data),
  deleteAction: (actionId: string) => del(`/pdi/actions/${actionId}`),
};

// ── Surveys ───────────────────────────────────────────────────────────────────

import type { Survey, SurveyAnswer, SurveyResults } from "@/types/surveys";

export const surveys = {
  list: () => get<Survey[]>("/surveys"),
  create: (data: object) => post<Survey>("/surveys", data),
  update: (id: string, data: object) => put<Survey>(`/surveys/${id}`, data),
  delete: (id: string) => del(`/surveys/${id}`),
  addQuestion: (surveyId: string, data: object) => post<Survey>(`/surveys/${surveyId}/questions`, data),
  updateQuestion: (questionId: string, data: object) => put<Survey>(`/surveys/questions/${questionId}`, data),
  deleteQuestion: (questionId: string) => del(`/surveys/questions/${questionId}`),
  respond: (surveyId: string, answers: SurveyAnswer[]) =>
    post<{ ok: boolean }>(`/surveys/${surveyId}/respond`, { answers }),
  results: (surveyId: string) => get<SurveyResults>(`/surveys/${surveyId}/results`),
};

// ── Onboarding ────────────────────────────────────────────────────────────────

import type { OnboardingTemplate, OnboardingTemplateTask, OnboardingChecklist, OnboardingChecklistTask } from "@/types/onboarding";

export const onboarding = {
  listTemplates: () => get<OnboardingTemplate[]>("/onboarding/templates"),
  createTemplate: (data: object) => post<OnboardingTemplate>("/onboarding/templates", data),
  updateTemplate: (id: string, data: object) => put<OnboardingTemplate>(`/onboarding/templates/${id}`, data),
  deleteTemplate: (id: string) => del(`/onboarding/templates/${id}`),
  addTemplateTask: (templateId: string, data: object) => post<OnboardingTemplateTask>(`/onboarding/templates/${templateId}/tasks`, data),
  updateTemplateTask: (taskId: string, data: object) => put<OnboardingTemplateTask>(`/onboarding/template-tasks/${taskId}`, data),
  deleteTemplateTask: (taskId: string) => del(`/onboarding/template-tasks/${taskId}`),
  team: () => get<OnboardingChecklist[]>("/onboarding/team"),
  my: () => get<OnboardingChecklist | null>("/onboarding/my"),
  assign: (data: { user_id: string; template_id?: string; started_at?: string }) =>
    post<OnboardingChecklist>("/onboarding/assign", data),
  deleteChecklist: (id: string) => del(`/onboarding/checklists/${id}`),
  completeTask: (taskId: string) => put<OnboardingChecklistTask>(`/onboarding/checklist-tasks/${taskId}/complete`),
  addChecklistTask: (data: object) => post<OnboardingChecklistTask>("/onboarding/checklist-tasks", data),
};

// ── Communications ────────────────────────────────────────────────────────────

import type { Announcement, BirthdayEntry, MilestoneEntry } from "@/types/communications";

export const communications = {
  listAnnouncements: () => get<Announcement[]>("/communications/announcements"),
  createAnnouncement: (data: { title: string; content: string; category: string; status: string }) =>
    post<Announcement>("/communications/announcements", data),
  updateAnnouncement: (id: string, data: { title: string; content: string; category: string; status: string }) =>
    put<Announcement>(`/communications/announcements/${id}`, data),
  deleteAnnouncement: (id: string) => del(`/communications/announcements/${id}`),
  birthdays: () => get<BirthdayEntry[]>("/communications/birthdays"),
  milestones: () => get<MilestoneEntry[]>("/communications/milestones"),
};

// ── Workshops ─────────────────────────────────────────────────────────────────

import type { Workshop, WorkshopRegistration } from "@/types/workshops";

export const workshops = {
  list: () => get<Workshop[]>("/workshops"),
  create: (data: object) => post<Workshop>("/workshops", data),
  update: (id: string, data: object) => put<Workshop>(`/workshops/${id}`, data),
  delete: (id: string) => del(`/workshops/${id}`),
  register: (id: string) => post<{ ok: boolean }>(`/workshops/${id}/register`),
  unregister: (id: string) => del(`/workshops/${id}/register`),
  registrations: (id: string) => get<WorkshopRegistration[]>(`/workshops/${id}/registrations`),
  markAttendance: (id: string, attendance: { user_id: string; attended: boolean }[]) =>
    put<{ ok: boolean; updated: number }>(`/workshops/${id}/attendance`, { attendance }),
};

// ── Learning ──────────────────────────────────────────────────────────────────

import type { CourseCatalogItem, EmployeeCourse } from "@/types/learning";

export const learning = {
  catalog: () => get<CourseCatalogItem[]>("/learning/catalog"),
  createCatalogItem: (data: { title: string; area: string; description?: string; duration_hours?: number }) =>
    post<CourseCatalogItem>("/learning/catalog", data),
  updateCatalogItem: (id: string, data: { title: string; area: string; description?: string; duration_hours?: number }) =>
    put<CourseCatalogItem>(`/learning/catalog/${id}`, data),
  deleteCatalogItem: (id: string) => del(`/learning/catalog/${id}`),
  my: () => get<EmployeeCourse[]>("/learning/my"),
  team: () => get<EmployeeCourse[]>("/learning/team"),
  addEmployeeCourse: (userId: string, data: { course_title: string; area: string; hours: number; completed_at: string; catalog_id?: string }) =>
    post<EmployeeCourse>(`/learning/employee/${userId}`, data),
  deleteEmployeeCourse: (courseId: string) => del(`/learning/employee/course/${courseId}`),
  importCsv: (file: File) => {
    const token = getToken();
    const form = new FormData();
    form.append("file", file);
    return fetch(`${BASE_URL}/learning/import-csv`, {
      method: "POST",
      headers: token ? { Authorization: `Bearer ${token}` } : {},
      body: form,
    }).then(r => r.json()) as Promise<{ inserted: number; errors: string[] }>;
  },
};

// ── Absences ──────────────────────────────────────────────────────────────────

import type { AbsenceType, AbsenceRequest } from "@/types/absences";

export const absences = {
  types: () => get<AbsenceType[]>("/absences/types"),
  createType: (data: object) => post<AbsenceType>("/absences/types", data),
  updateType: (id: string, data: object) => put<AbsenceType>(`/absences/types/${id}`, data),
  deleteType: (id: string) => del(`/absences/types/${id}`),
  my: () => get<AbsenceRequest[]>("/absences/my"),
  team: () => get<AbsenceRequest[]>("/absences/team"),
  calendar: () => get<AbsenceRequest[]>("/absences/calendar"),
  request: (data: object) => post<AbsenceRequest>("/absences/request", data),
  approve: (id: string, note?: string) => put<AbsenceRequest>(`/absences/${id}/approve`, { note }),
  reject: (id: string, note?: string) => put<AbsenceRequest>(`/absences/${id}/reject`, { note }),
  delete: (id: string) => del(`/absences/${id}`),
};

// ── Logs ──────────────────────────────────────────────────────────────────────

export interface AuditLog {
  id: number;
  user_id?: string;
  user_name?: string;
  method: string;
  path: string;
  action?: string;
  status_code?: number;
  ip_address?: string;
  created_at: string;
}

export interface LogsPage {
  total: number;
  page: number;
  limit: number;
  pages: number;
  items: AuditLog[];
}

export const logs = {
  list: (params: { page?: number; limit?: number; q?: string; method?: string; status?: string }) => {
    const qs = new URLSearchParams();
    if (params.page) qs.set("page", String(params.page));
    if (params.limit) qs.set("limit", String(params.limit));
    if (params.q) qs.set("q", params.q);
    if (params.method) qs.set("method", params.method);
    if (params.status) qs.set("status", params.status);
    return get<LogsPage>(`/logs?${qs}`);
  },
};

// ── Calendar ──────────────────────────────────────────────────────────────────

import type { CalendarEvent, FeedEntry } from "@/types/calendar";

export const calendar = {
  events: () => get<CalendarEvent[]>("/calendar/events"),
  createEvent: (data: object) => post<CalendarEvent>("/calendar/events", data),
  updateEvent: (id: string, data: object) => put<CalendarEvent>(`/calendar/events/${id}`, data),
  deleteEvent: (id: string) => del(`/calendar/events/${id}`),
  feed: () => get<FeedEntry[]>("/calendar/feed"),
};

// ── Reports ───────────────────────────────────────────────────────────────────

async function downloadReport(path: string, filename: string): Promise<void> {
  const token = getToken();
  const res = await fetch(`${BASE_URL}${path}`, {
    headers: token ? { Authorization: `Bearer ${token}` } : {},
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(err.detail ?? "Erro ao gerar relatório");
  }
  const blob = await res.blob();
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

export const reports = {
  collaborators: () => downloadReport("/reports/collaborators", "colaboradores.csv"),
  absences: () => downloadReport("/reports/absences", "ausencias.csv"),
  benefits: () => downloadReport("/reports/benefits", "beneficios.csv"),
  pdi: () => downloadReport("/reports/pdi", "pdi.csv"),
  learning: () => downloadReport("/reports/learning", "treinamentos.csv"),
};

// ── Benefits ──────────────────────────────────────────────────────────────────

import type { BenefitCatalogItem, EmployeeBenefit, BenefitSummaryItem } from "@/types/benefits";

export const benefits = {
  catalog: () => get<BenefitCatalogItem[]>("/benefits/catalog"),
  createCatalogItem: (data: object) => post<BenefitCatalogItem>("/benefits/catalog", data),
  updateCatalogItem: (id: string, data: object) => put<BenefitCatalogItem>(`/benefits/catalog/${id}`, data),
  deleteCatalogItem: (id: string) => del(`/benefits/catalog/${id}`),
  summary: () => get<BenefitSummaryItem[]>("/benefits/summary"),
  team: () => get<EmployeeBenefit[]>("/benefits/team"),
  employee: (userId: string) => get<EmployeeBenefit[]>(`/benefits/employee/${userId}`),
  my: () => get<EmployeeBenefit[]>("/benefits/my"),
  assign: (data: object) => post<EmployeeBenefit>("/benefits/assign", data),
  updateAssignment: (id: string, data: object) => put<EmployeeBenefit>(`/benefits/assignment/${id}`, data),
  deleteAssignment: (id: string) => del(`/benefits/assignment/${id}`),
};

// ── Salary ────────────────────────────────────────────────────────────────────

import type { SalaryReference, SalaryTableEntry, SalaryPositioning } from "@/types/salary";

export const salary = {
  references: () => get<SalaryReference[]>("/salary/references"),
  createReference: (data: object) => post<SalaryReference>("/salary/references", data),
  updateReference: (id: string, data: object) => put<SalaryReference>(`/salary/references/${id}`, data),
  deleteReference: (id: string) => del(`/salary/references/${id}`),
  table: (referenceId: string) => get<SalaryTableEntry[]>(`/salary/table?reference_id=${referenceId}`),
  upsertTable: (data: object) => post<SalaryTableEntry[]>("/salary/table", data),
  updateEntry: (id: string, data: object) => put<SalaryTableEntry>(`/salary/table/${id}`, data),
  positioning: (referenceId: string) => get<SalaryPositioning[]>(`/salary/positioning?reference_id=${referenceId}`),
  updateEmployee: (profileId: string, data: object) => patch<{ ok: boolean }>(`/salary/employee/${profileId}`, data),
};

// ── Notifications ─────────────────────────────────────────────────────────────

export const notifications = {
  list: () => get<Record<string, unknown>[]>("/notifications"),
  markRead: (id: string) => patch(`/notifications/${id}/read`),
  delete: (id: string) => del(`/notifications/${id}`),
};
