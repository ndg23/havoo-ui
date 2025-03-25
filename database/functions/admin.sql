-- Admin functions for Havoo UI

-- Function for listing pending expert verifications
CREATE OR REPLACE FUNCTION admin_list_verifications(
  p_admin_id UUID,
  p_status TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  user_name TEXT,
  user_email TEXT,
  status TEXT,
  created_at TIMESTAMP WITH TIME ZONE,
  documents JSONB
) AS $$
BEGIN
  -- Check if user is admin
  IF NOT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) THEN
    RAISE EXCEPTION 'Unauthorized access';
  END IF;
  
  RETURN QUERY
  SELECT 
    v.id,
    v.user_id,
    (p.first_name || ' ' || p.last_name) AS user_name,
    p.email AS user_email,
    v.status,
    v.created_at,
    v.documents
  FROM verifications v
  JOIN profiles p ON v.user_id = p.id
  WHERE (p_status IS NULL OR v.status = p_status)
  ORDER BY v.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function for admin to approve/reject expert verification with simplified interface
CREATE OR REPLACE FUNCTION admin_process_verification(
  p_admin_id UUID,
  p_verification_id UUID,
  p_approved BOOLEAN,
  p_rejection_reason TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID;
  v_is_admin BOOLEAN;
BEGIN
  -- Check if user is admin
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) INTO v_is_admin;
  
  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'Only administrators can approve/reject verifications';
  END IF;
  
  -- Get user_id from verification
  SELECT user_id INTO v_user_id FROM verifications WHERE id = p_verification_id;
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Verification not found';
  END IF;
  
  -- Update verification status
  UPDATE verifications
  SET 
    status = CASE WHEN p_approved THEN 'approved' ELSE 'rejected' END,
    rejection_reason = CASE WHEN NOT p_approved THEN p_rejection_reason ELSE NULL END,
    reviewed_by = p_admin_id,
    reviewed_at = NOW(),
    updated_at = NOW()
  WHERE id = p_verification_id;
  
  -- The expert_verification_trigger will automatically update the user's expert status
  
  -- Generate appropriate notifications
  IF p_approved THEN
    -- Notify the user that they've been approved
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      v_user_id,
      'Expert Verification Approved',
      'Your expert verification has been approved. You can now offer services and respond to requests.',
      'verification',
      '/account/profile'
    );
  ELSE
    -- Notify the user that they've been rejected
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      v_user_id,
      'Expert Verification Rejected',
      'Your expert verification was rejected' || 
      CASE 
        WHEN p_rejection_reason IS NOT NULL THEN ': ' || p_rejection_reason
        ELSE ''
      END,
      'verification',
      '/account/verification'
    );
  END IF;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function for admin to get platform statistics
CREATE OR REPLACE FUNCTION admin_get_stats(
  p_admin_id UUID
)
RETURNS JSON AS $$
DECLARE
  v_is_admin BOOLEAN;
  v_result JSON;
BEGIN
  -- Check if user is admin
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) INTO v_is_admin;
  
  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'Unauthorized access';
  END IF;
  
  -- Gather statistics
  SELECT json_build_object(
    'users', (
      SELECT json_build_object(
        'total', (SELECT COUNT(*) FROM profiles),
        'experts', (SELECT COUNT(*) FROM profiles WHERE is_expert = TRUE),
        'clients', (SELECT COUNT(*) FROM profiles WHERE is_expert = FALSE),
        'pending_verifications', (SELECT COUNT(*) FROM verifications WHERE status = 'pending')
      )
    ),
    'contracts', (
      SELECT json_build_object(
        'total', (SELECT COUNT(*) FROM deals),
        'active', (SELECT COUNT(*) FROM deals WHERE status = 'active'),
        'completed', (SELECT COUNT(*) FROM deals WHERE status = 'completed'),
        'value_completed', (SELECT COALESCE(SUM(price), 0) FROM deals WHERE status = 'completed')
      )
    ),
    'requests', (
      SELECT json_build_object(
        'total', (SELECT COUNT(*) FROM requests),
        'open', (SELECT COUNT(*) FROM requests WHERE status = 'open'),
        'assigned', (SELECT COUNT(*) FROM requests WHERE status = 'assigned'),
        'completed', (SELECT COUNT(*) FROM requests WHERE status = 'completed')
      )
    ),
    'services', (
      SELECT COUNT(*) FROM services
    )
  ) INTO v_result;
  
  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 