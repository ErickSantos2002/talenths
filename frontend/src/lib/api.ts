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
  delete: (profileId: string) => del(`/collaborators/${profileId}`),
};

// ── Tests ─────────────────────────────────────────────────────────────────────

export const tests = {
  scenarios: () =>
    get<Record<string, unknown>[]>("/tests/scenarios", { public: true }),
  submitResponses: (responses: { block_number: number; most_option: string; least_option: string }[]) =>
    post("/tests/responses", { responses }),
  calculate: () => post<Record<string, unknown>>("/tests/calculate"),
  results: () => get<Record<string, unknown>[]>("/tests/results"),
  result: (id: string) => get<Record<string, unknown>>(`/tests/results/${id}`),
  sharedResult: (shareToken: string) =>
    get<Record<string, unknown>>(`/tests/results/shared/${shareToken}`, { public: true }),
  deleteResult: (id: string) => del(`/tests/results/${id}`),
  reprocess: (id: string) => post<Record<string, unknown>>(`/tests/results/${id}/reprocess`),
};

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

// ── Comparisons ───────────────────────────────────────────────────────────────

export const comparisons = {
  list: () => get<Record<string, unknown>[]>("/comparisons"),
  create: (user1_id: string, user2_id: string, comparison_type = "peer_to_peer") =>
    post<Record<string, unknown>>("/comparisons", { user1_id, user2_id, comparison_type }),
  delete: (id: string) => del(`/comparisons/${id}`),
};

// ── Chat ──────────────────────────────────────────────────────────────────────

export const chat = {
  conversations: () => get<Record<string, unknown>[]>("/chat/conversations"),
  createConversation: (title?: string) =>
    post<Record<string, unknown>>("/chat/conversations", { title }),
  deleteConversation: (id: string) => del(`/chat/conversations/${id}`),
  messages: (conversationId: string) =>
    get<Record<string, unknown>[]>(`/chat/conversations/${conversationId}/messages`),
  sendMessage: (conversationId: string, content: string) =>
    post<Record<string, unknown>>(`/chat/conversations/${conversationId}/messages`, { content }),
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

// ── Notifications ─────────────────────────────────────────────────────────────

export const notifications = {
  list: () => get<Record<string, unknown>[]>("/notifications"),
  markRead: (id: string) => patch(`/notifications/${id}/read`),
  delete: (id: string) => del(`/notifications/${id}`),
};
