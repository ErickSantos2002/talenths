export type SurveyStatus = "draft" | "active" | "closed";
export type QuestionType = "scale" | "text" | "choice";

export interface SurveyQuestion {
  id: string;
  survey_id: string;
  text: string;
  type: QuestionType;
  options?: string[];
  position: number;
}

export interface Survey {
  id: string;
  title: string;
  description?: string;
  anonymous: boolean;
  status: SurveyStatus;
  starts_at?: string;
  ends_at?: string;
  created_at?: string;
  questions: SurveyQuestion[];
  response_count: number;
  user_responded: boolean;
}

export interface SurveyAnswer {
  question_id: string;
  scale_value?: number;
  text_value?: string;
  choice_value?: string;
}

export interface QuestionResult {
  question_id: string;
  text: string;
  type: QuestionType;
  average?: number;
  distribution?: Record<string, number>;
  count?: number;
  answers?: string[];
  counts?: Record<string, number>;
}

export interface SurveyResults {
  survey_id: string;
  title: string;
  anonymous: boolean;
  response_count: number;
  results: QuestionResult[];
}

export const SURVEY_STATUS_LABELS: Record<SurveyStatus, string> = {
  draft: "Rascunho",
  active: "Ativa",
  closed: "Encerrada",
};

export const SURVEY_STATUS_COLORS: Record<SurveyStatus, string> = {
  draft: "text-muted-foreground",
  active: "text-emerald-600",
  closed: "text-blue-600",
};
