export type ResponsibleRole = "user" | "manager";

export interface OnboardingTemplateTask {
  id: string;
  template_id: string;
  title: string;
  description?: string;
  responsible_role: ResponsibleRole;
  due_days: number;
  position: number;
}

export interface OnboardingTemplate {
  id: string;
  name: string;
  description?: string;
  created_at?: string;
  tasks: OnboardingTemplateTask[];
}

export interface OnboardingChecklistTask {
  id: string;
  checklist_id: string;
  title: string;
  description?: string;
  responsible_role: ResponsibleRole;
  due_date?: string;
  position: number;
  completed_at?: string;
  completed_by?: string;
}

export interface OnboardingChecklist {
  id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  template_id?: string;
  template_name?: string;
  started_at?: string;
  created_at?: string;
  progress: number;
  tasks_total: number;
  tasks_done: number;
  tasks: OnboardingChecklistTask[];
}
