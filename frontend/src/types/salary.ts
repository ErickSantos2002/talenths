export interface SalaryReference {
  id: string;
  name: string;
  market: string;
  region: string;
  reference_year: number;
  is_active: boolean;
  created_at: string;
}

export type SalaryBand = "abaixo_minimo" | "band_90" | "mediana" | "band_105" | "maximo_ou_acima";

export interface SalaryTableEntry {
  id: string;
  reference_id: string;
  job_family: string;
  seniority: string;
  band_90: number;
  band_95: number;
  band_100: number;
  band_105: number;
  band_110: number;
}

export interface SalaryPositioning {
  user_id: string;
  name: string;
  department?: string;
  job_family?: string;
  seniority?: string;
  current_salary?: number;
  band_90?: number;
  band_95?: number;
  band_100?: number;
  band_105?: number;
  band_110?: number;
  pct_of_median?: number;
  deviation?: number;
  band?: SalaryBand;
  is_above_max?: boolean;
  is_below_min?: boolean;
}
