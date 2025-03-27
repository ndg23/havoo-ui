-- Function for simplified expert verification
-- Allows admins to easily verify experts with minimal steps

CREATE OR REPLACE FUNCTION admin_verify_expert(
  p_user_id UUID,
  p_approved BOOLEAN,
  p_rejection_reason TEXT DEFAULT NULL,
  p_admin_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_exists BOOLEAN;
  v_is_admin BOOLEAN;
  v_status TEXT;
BEGIN
  -- Check if admin user exists and has admin rights
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) INTO v_is_admin;
  
  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'Only administrators can verify experts';
  END IF;
  
  -- Check if user exists
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_user_id) INTO v_user_exists;
  
  IF NOT v_user_exists THEN
    RAISE EXCEPTION 'User not found';
  END IF;
  
  -- Determine verification status
  v_status := CASE WHEN p_approved THEN 'approved' ELSE 'rejected' END;
  
  -- Check if a verification record already exists
  IF EXISTS(SELECT 1 FROM verifications WHERE user_id = p_user_id) THEN
    -- Update existing verification record
    UPDATE verifications
    SET 
      status = v_status,
      rejection_reason = CASE WHEN NOT p_approved THEN p_rejection_reason ELSE NULL END,
      reviewed_by = p_admin_id,
      reviewed_at = NOW(),
      updated_at = NOW()
    WHERE user_id = p_user_id;
  ELSE
    -- Create new verification record
    INSERT INTO verifications (
      user_id,
      status,
      rejection_reason,
      reviewed_by,
      reviewed_at
    ) VALUES (
      p_user_id,
      v_status,
      CASE WHEN NOT p_approved THEN p_rejection_reason ELSE NULL END,
      p_admin_id,
      NOW()
    );
  END IF;
  
  -- The expert_verification_trigger will handle setting is_expert and is_verified flags
  -- and creating notifications for the user
  
  -- If rejected, create a notification explaining why
  IF NOT p_approved AND p_rejection_reason IS NOT NULL THEN
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      p_user_id,
      'Verification Rejected',
      'Your expert verification was rejected: ' || p_rejection_reason,
      'verification',
      '/account/verification'
    );
  END IF;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function for experts to mission verification
CREATE OR REPLACE FUNCTION mission_expert_verification(
  p_documents JSONB -- JSON array of document URLs/metadata (supports both Supabase paths and Cloudinary URLs)
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID;
  v_user_exists BOOLEAN;
BEGIN
  -- Get the authenticated user ID
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'You must be logged in to mission verification';
  END IF;
  
  -- Check if user exists
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = v_user_id) INTO v_user_exists;
  
  IF NOT v_user_exists THEN
    RAISE EXCEPTION 'User profile not found';
  END IF;
  
  -- Check if a verification is already in progress
  IF EXISTS(SELECT 1 FROM verifications WHERE user_id = v_user_id AND status = 'pending') THEN
    RAISE EXCEPTION 'You already have a pending verification mission';
  END IF;
  
  -- Validate document format (Cloudinary or Supabase Storage)
  IF (p_documents->>'identity_document') IS NULL THEN
    RAISE EXCEPTION 'Identity document is required';
  END IF;
  
  -- Check if we're using Cloudinary URLs
  IF (p_documents->'identity_document'->>'url') IS NOT NULL 
      AND (p_documents->'identity_document'->>'url') NOT LIKE '%supabase%' THEN
    -- Validate Cloudinary URL format
    IF (p_documents->'identity_document'->>'url') NOT LIKE 'https://res.cloudinary.com/%' THEN
      RAISE EXCEPTION 'Invalid Cloudinary URL format';
    END IF;
  -- Check if we're using Supabase Storage paths
  ELSIF (p_documents->'identity_document'->>'path') IS NOT NULL THEN
    -- Legacy format - continue
    NULL;
  ELSE
    RAISE EXCEPTION 'Invalid document format - must contain either Cloudinary URL or Supabase Storage path';
  END IF;
  
  -- Create or update verification mission
  IF EXISTS(SELECT 1 FROM verifications WHERE user_id = v_user_id) THEN
    UPDATE verifications
    SET 
      status = 'pending',
      documents = p_documents,
      rejection_reason = NULL,
      reviewed_by = NULL,
      reviewed_at = NULL,
      updated_at = NOW()
    WHERE user_id = v_user_id;
  ELSE
    INSERT INTO verifications (
      user_id,
      status,
      documents
    ) VALUES (
      v_user_id,
      'pending',
      p_documents
    );
  END IF;
  
  -- Notify administrators about the new verification mission
  INSERT INTO notifications (
    profile_id,
    title,
    content,
    type,
    action_url
  )
  SELECT 
    id,
    'New Expert Verification Request',
    'A user has missioned expert verification. Please review their documents.',
    'admin_verification',
    '/admin/verifications'
  FROM profiles
  WHERE is_admin = TRUE;
  
  -- Notify the user that their mission is being processed
  INSERT INTO notifications (
    profile_id,
    title,
    content,
    type,
    action_url
  ) VALUES (
    v_user_id,
    'Verification Requested',
    'Your expert verification mission has been submitted and is pending review.',
    'verification',
    '/account/verification'
  );
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 