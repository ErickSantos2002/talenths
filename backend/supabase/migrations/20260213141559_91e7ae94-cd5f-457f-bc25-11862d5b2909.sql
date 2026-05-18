
-- Atomic claim_invitation function to prevent race conditions on used_count
CREATE OR REPLACE FUNCTION public.claim_invitation(token_param text)
RETURNS SETOF test_invitations
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  RETURN QUERY
  UPDATE test_invitations
  SET used_count = COALESCE(used_count, 0) + 1
  WHERE token = token_param
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > now())
    AND (max_uses IS NULL OR COALESCE(used_count, 0) < max_uses)
  RETURNING *;
END;
$$;
