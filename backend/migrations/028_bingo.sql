-- 028_bingo.sql — módulo de Bingo
CREATE TABLE IF NOT EXISTS public.bingo_games (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  name text NOT NULL,
  number_pool int NOT NULL,
  winners_target int NOT NULL,
  near_threshold int NOT NULL DEFAULT 2,
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','running','finished','cancelled')),
  pending_tiebreak jsonb,           -- {"card_ids":[...],"won_on_draw":N} quando pausado p/ desempate
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  started_at timestamptz,
  finished_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_bingo_games_company ON public.bingo_games(company_id);

CREATE TABLE IF NOT EXISTS public.bingo_cards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL REFERENCES public.bingo_games(id) ON DELETE CASCADE,
  company_id uuid NOT NULL,
  user_id uuid NOT NULL,
  code text NOT NULL,
  numbers int[] NOT NULL,
  layout jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (game_id, user_id),
  UNIQUE (game_id, code)
);
CREATE INDEX IF NOT EXISTS idx_bingo_cards_game ON public.bingo_cards(game_id);
CREATE INDEX IF NOT EXISTS idx_bingo_cards_user ON public.bingo_cards(user_id);

CREATE TABLE IF NOT EXISTS public.bingo_draws (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL REFERENCES public.bingo_games(id) ON DELETE CASCADE,
  company_id uuid NOT NULL,
  number int NOT NULL,
  draw_order int NOT NULL,
  drawn_at timestamptz NOT NULL DEFAULT now(),
  drawn_by uuid,
  UNIQUE (game_id, number),
  UNIQUE (game_id, draw_order)
);
CREATE INDEX IF NOT EXISTS idx_bingo_draws_game ON public.bingo_draws(game_id);

CREATE TABLE IF NOT EXISTS public.bingo_winners (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL REFERENCES public.bingo_games(id) ON DELETE CASCADE,
  company_id uuid NOT NULL,
  card_id uuid NOT NULL REFERENCES public.bingo_cards(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  place int NOT NULL,
  won_on_draw int,
  by_tiebreak boolean NOT NULL DEFAULT false,
  won_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (game_id, place),
  UNIQUE (game_id, card_id)
);
CREATE INDEX IF NOT EXISTS idx_bingo_winners_game ON public.bingo_winners(game_id);

CREATE TABLE IF NOT EXISTS public.bingo_tiebreak_rolls (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id uuid NOT NULL REFERENCES public.bingo_games(id) ON DELETE CASCADE,
  company_id uuid NOT NULL,
  card_id uuid NOT NULL REFERENCES public.bingo_cards(id) ON DELETE CASCADE,
  round int NOT NULL,
  roll int NOT NULL CHECK (roll BETWEEN 1 AND 20),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_bingo_tiebreak_game ON public.bingo_tiebreak_rolls(game_id);
