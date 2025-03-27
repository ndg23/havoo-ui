-- Fonction pour vérifier si un email existe
CREATE OR REPLACE FUNCTION is_email_exist(p_email VARCHAR)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
BEGIN
  -- Vérifier dans la table auth.users
  RETURN EXISTS (
    SELECT 1 
    FROM auth.users 
    WHERE email = LOWER(p_email)
  );
END;
$$;

-- Autoriser l'accès public à la fonction
GRANT EXECUTE ON FUNCTION is_email_exist(VARCHAR) TO anon;

-- Fonction pour vérifier si un email existe et son statut de profil
CREATE OR REPLACE FUNCTION is_email_exist_with_status(p_email VARCHAR)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
STABLE
AS $$
DECLARE
  v_user_id UUID;
  v_has_profile BOOLEAN;
  v_result JSONB;
BEGIN
  -- Vérifier si l'email existe dans auth.users
  SELECT id INTO v_user_id
  FROM auth.users
  WHERE email = LOWER(p_email);
  
  -- Vérifier si un profil existe pour cet utilisateur
  IF v_user_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM profiles WHERE id = v_user_id
    ) INTO v_has_profile;
    
    v_result := jsonb_build_object(
      'exists', TRUE,
      'user_id', v_user_id,
      'has_profile', v_has_profile
    );
  ELSE
    v_result := jsonb_build_object(
      'exists', FALSE,
      'user_id', NULL,
      'has_profile', FALSE
    );
  END IF;
  
  RETURN v_result;
END;
$$;

-- Accorder les permissions nécessaires
GRANT USAGE ON SCHEMA auth TO postgres;
GRANT SELECT ON auth.users TO postgres;

-- Autoriser l'accès public à la fonction
GRANT EXECUTE ON FUNCTION is_email_exist_with_status(VARCHAR) TO anon;