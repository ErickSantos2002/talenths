export type ActionStatus = "pending" | "in_progress" | "done";

export interface PdiAction {
  id: string;
  plan_id: string;
  title: string;
  description?: string;
  how?: string;
  due_date?: string;
  status: ActionStatus;
  completed_at?: string;
  position: number;
  created_at?: string;
}

export interface PdiPlan {
  id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  eval_cycle_id?: string;
  eval_cycle_name?: string;
  title: string;
  description?: string;
  status: "active" | "closed";
  created_at?: string;
  updated_at?: string;
  progress: number;
  actions_total: number;
  actions_done: number;
  actions: PdiAction[];
}

export const ACTION_STATUS_LABELS: Record<ActionStatus, string> = {
  pending: "Pendente",
  in_progress: "Em andamento",
  done: "Concluído",
};

export const ACTION_STATUS_COLORS: Record<ActionStatus, string> = {
  pending: "text-muted-foreground",
  in_progress: "text-amber-500",
  done: "text-emerald-500",
};
