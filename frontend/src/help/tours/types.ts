export interface TourStep {
  route: string;
  element?: string;
  title: string;
  text: string;
  interact?: boolean;
  since?: number;
}

export interface Tour {
  id: string;
  version: number;
  steps: TourStep[];
}

export type Audience = "collaborator" | "manager";
