export type BenefitCategory = "saude" | "alimentacao" | "transporte" | "financeiro" | "educacao" | "bem_estar" | "outro";
export type BenefitValueType = "fixed" | "variable" | "percentage" | "info";

export interface BenefitCatalogItem {
  id: string;
  name: string;
  category: BenefitCategory;
  description?: string;
  provider?: string;
  value_type: BenefitValueType;
  value?: number;
  active: boolean;
  created_at: string;
}

export interface EmployeeBenefit {
  id: string;
  user_id: string;
  user_name?: string;
  user_email?: string;
  department?: string;
  benefit_id: string;
  benefit_name?: string;
  benefit_category?: BenefitCategory;
  benefit_provider?: string;
  value_type?: BenefitValueType;
  value?: number;
  value_override?: number;
  start_date: string;
  end_date?: string;
  notes?: string;
  created_at: string;
}

export interface BenefitSummaryItem {
  benefit_id: string;
  benefit_name: string;
  benefit_category: BenefitCategory;
  employee_count: number;
}
