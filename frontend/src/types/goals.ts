export interface Cycle {
  id: string;
  company_id: string;
  name: string;
  start_date: string;
  end_date: string;
  min_curve_value: number;
  max_progress_value: number;
  status: "draft" | "active" | "closed";
  created_at: string;
}

export interface Goal {
  id: string;
  cycle_id: string;
  department_id: string;
  company_id: string;
  responsible_user_id: string | null;
  responsible_name: string | null;
  department_name: string;
  title: string;
  objective: "increase" | "decrease";
  calculation_type: "sum" | "subtraction" | "average" | "repeat";
  result_type: "currency" | "percentage" | "value";
  weight: number;
  target_value: number;
  curve_v80: number | null;
  curve_v100: number | null;
  curve_v120: number | null;
  position: number;
  pct_month: number | null;
  pct_cumulative: number | null;
  pct_year: number | null;
  cum_actual: number;
  cum_planned: number;
}

export interface DepartmentOverview {
  department_id: string;
  department_name: string;
  weight_total: number;
  goals: Goal[];
  pct_month: number | null;
  pct_cumulative: number | null;
  pct_year: number | null;
}

export interface MonthlyPlan {
  month: number;
  planned_value: number;
}

export interface MonthlyActual {
  month: number;
  actual_value: number | null;
  comment: string | null;
  is_closed: boolean;
  updated_at: string | null;
}

export interface HistoryEntry {
  id: string;
  month: number;
  previous_value: number | null;
  new_value: number;
  comment: string | null;
  changed_at: string;
  changed_by_name: string | null;
}

export interface GoalDetail extends Goal {
  plans: MonthlyPlan[];
  actuals: MonthlyActual[];
  history: HistoryEntry[];
}

export interface GoalCommentAttachment {
  id: string;
  original_name: string;
  file_size: number;
  mime_type: string | null;
}

export interface GoalComment {
  id: string;
  author_name: string | null;
  body: string;
  created_at: string;
  attachments: GoalCommentAttachment[];
}

export type GoalCreate = {
  cycle_id: string;
  department_id: string;
  responsible_user_id?: string;
  title: string;
  objective: "increase" | "decrease";
  calculation_type: "sum" | "subtraction" | "average" | "repeat";
  result_type: "currency" | "percentage" | "value";
  weight: number;
  target_value: number;
  curve_v80?: number;
  curve_v100?: number;
  curve_v120?: number;
};

export const MONTHS = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];

export const CALC_TYPE_LABELS: Record<string, string> = {
  sum: "Soma",
  subtraction: "Subtração",
  average: "Média",
  repeat: "Repetir",
};

export const RESULT_TYPE_LABELS: Record<string, string> = {
  currency: "R$",
  percentage: "%",
  value: "Valor",
};

export function formatGoalValue(value: number, resultType: string): string {
  if (resultType === "currency") {
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
  }
  if (resultType === "percentage") {
    return `${value.toLocaleString("pt-BR", { maximumFractionDigits: 2 })}%`;
  }
  return value.toLocaleString("pt-BR", { maximumFractionDigits: 2 });
}
