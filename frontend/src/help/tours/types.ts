import type { AppRole } from "../screens";

export interface TourStep {
  route?: string;
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

// A tour bound to one screen: its steps never navigate.
export interface ScreenTour {
  id: string;
  version: number;
  screen: string;
  roles: AppRole[];
  steps: Omit<TourStep, "route" | "interact">[];
}

export type Audience = "collaborator" | "manager";
