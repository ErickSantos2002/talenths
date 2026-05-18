
CREATE OR REPLACE FUNCTION public.delete_company_cascade(_company_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  _user_ids uuid[];
BEGIN
  -- Only master admins can execute
  IF NOT is_master_admin() THEN
    RAISE EXCEPTION 'Permission denied: only master admins can delete companies';
  END IF;

  -- Collect user_ids belonging to this company
  SELECT array_agg(user_id) INTO _user_ids
  FROM profiles WHERE company_id = _company_id;

  -- If there are users, delete their related data
  IF _user_ids IS NOT NULL AND array_length(_user_ids, 1) > 0 THEN
    -- 1. hr_messages via hr_conversations
    DELETE FROM hr_messages WHERE conversation_id IN (
      SELECT id FROM hr_conversations WHERE user_id = ANY(_user_ids)
    );
    -- 2. hr_conversations
    DELETE FROM hr_conversations WHERE user_id = ANY(_user_ids);
    -- 3. notifications
    DELETE FROM notifications WHERE user_id = ANY(_user_ids);
    -- 4. profile_comparisons
    DELETE FROM profile_comparisons WHERE user1_id = ANY(_user_ids) OR user2_id = ANY(_user_ids);
    -- 5. test_responses
    DELETE FROM test_responses WHERE user_id = ANY(_user_ids);
    -- 6. test_results
    DELETE FROM test_results WHERE user_id = ANY(_user_ids);
    -- 7. user_managers
    DELETE FROM user_managers WHERE user_id = ANY(_user_ids) OR manager_id = ANY(_user_ids);
    -- 8. user_roles
    DELETE FROM user_roles WHERE user_id = ANY(_user_ids);
  END IF;

  -- 9. test_invitations (linked to company directly)
  DELETE FROM test_invitations WHERE company_id = _company_id;
  -- 10. profiles
  DELETE FROM profiles WHERE company_id = _company_id;
  -- 11. departments
  DELETE FROM departments WHERE company_id = _company_id;
  -- 12. company
  DELETE FROM companies WHERE id = _company_id;
END;
$$;
