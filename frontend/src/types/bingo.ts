export interface BingoGame {
  id: string; name: string; number_pool: number; winners_target: number;
  near_threshold: number; status: "draft" | "running" | "finished" | "cancelled";
  created_at?: string; started_at?: string | null; finished_at?: string | null;
  participants?: number; draws?: number; winners?: number;
  pending_tiebreak?: { card_ids: string[]; won_on_draw: number } | null;
}

export interface BingoCard {
  id: string; user_id: string; user_name?: string; code: string;
  numbers: number[]; layout: (number | null)[][]; marked?: number[];
}

export interface BingoWinner {
  card_id: string; user_id: string; user_name?: string; code?: string;
  place: number; won_on_draw: number | null; by_tiebreak: boolean;
}

export interface BingoNear { card_id: string; user_name?: string; missing: number; }

export interface BingoGameDetail {
  game: BingoGame;
  cards: BingoCard[];
  draws: { number: number; draw_order: number }[];
  winners: BingoWinner[];
  near: BingoNear[];
}

export interface BingoMyGameSummary {
  id: string; name: string; status: string; number_pool: number; winners_target: number;
}

export interface BingoMyGame {
  game: { id: string; name: string; status: string; number_pool: number; winners_target: number };
  card: { code: string; numbers: number[]; layout: (number | null)[][] };
  drawn: number[]; marked: number[]; missing: number; my_place: number | null;
}

export interface DrawResult {
  number: number;
  tiebreak: { card_ids: string[]; won_on_draw: number } | null;
}

export interface TiebreakResult {
  rolls: { card_id: string; round: number; roll: number }[];
  order: string[];
  placed: { card_id: string; place: number }[];
}
