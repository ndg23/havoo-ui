-- =============================================================================
-- SETUP COMPLET DU SYSTÈME DE VÉRIFICATION D'EXPERTS HAVOO-UI
-- 
-- Ce fichier configure l'ensemble du système de vérification d'experts, incluant :
-- 1. Définition et configuration des tables
-- 2. Politiques RLS pour la table verifications
-- 3. Politiques RLS pour le bucket de stockage documents
-- 4. Fonctions SQL pour la gestion des vérifications
-- 5. Configuration des triggers nécessaires
-- =============================================================================

-- Vérifier que l'extension UUID est disponible
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- 1. DÉFINITION ET CONFIGURATION DES TABLES
-- =============================================================================

-- Table de vérification des experts
CREATE TABLE IF NOT EXISTS verifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  documents JSONB, -- Stocke les URLs des documents au format JSON
  rejection_reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_by UUID REFERENCES profiles(id),
  reviewed_at TIMESTAMP WITH TIME ZONE
);

-- Ajout des index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_verifications_user_id ON verifications(user_id);
CREATE INDEX IF NOT EXISTS idx_verifications_status ON verifications(status);

-- =============================================================================
-- 2. POLITIQUES RLS POUR LA TABLE VERIFICATIONS
-- =============================================================================

-- Activer RLS sur la table verifications
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;

-- Supprimer les politiques existantes pour éviter les conflits
DROP POLICY IF EXISTS "Users can view their own verification" ON verifications;
DROP POLICY IF EXISTS "Users can create their own verification" ON verifications; 
DROP POLICY IF EXISTS "Users can update their own pending verification" ON verifications;
DROP POLICY IF EXISTS "Admins can manage all verifications" ON verifications;

-- Utilisateurs peuvent voir leur propre vérification
CREATE POLICY "Users can view their own verification" 
  ON verifications FOR SELECT USING (auth.uid() = user_id);
    
-- Utilisateurs peuvent créer leur propre vérification
CREATE POLICY "Users can create their own verification" 
  ON verifications FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Utilisateurs peuvent mettre à jour leur propre vérification si elle est en attente
CREATE POLICY "Users can update their own pending verification" 
  ON verifications FOR UPDATE 
  USING (auth.uid() = user_id AND status = 'pending')
  WITH CHECK (auth.uid() = user_id AND status = 'pending');
    
-- Admins peuvent gérer toutes les vérifications
CREATE POLICY "Admins can manage all verifications" 
  ON verifications 
  USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  ));

-- =============================================================================
-- 3. POLITIQUES RLS POUR LE BUCKET DE STOCKAGE DOCUMENTS
-- =============================================================================

-- S'assurer que le bucket documents existe
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- Supprimer les politiques existantes pour éviter les conflits
DROP POLICY IF EXISTS "Users can upload their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Admins can access all verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can delete verification documents" ON storage.objects;

-- Permettre aux utilisateurs de télécharger leurs propres documents de vérification
CREATE POLICY "Users can upload their own verification documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Permettre aux utilisateurs de voir leurs propres documents de vérification
CREATE POLICY "Users can view their own verification documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Permettre aux utilisateurs de mettre à jour leurs propres documents de vérification
CREATE POLICY "Users can update their own verification documents"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Permettre aux admins d'accéder à tous les documents de vérification
CREATE POLICY "Admins can access all verification documents"
ON storage.objects
TO authenticated
USING (
  bucket_id = 'documents' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND is_admin = true
  )
);

-- Seuls les admins peuvent supprimer des documents de vérification
CREATE POLICY "Only admins can delete verification documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'documents' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND is_admin = true
  )
);

-- Accorder les privilèges nécessaires
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT SELECT ON storage.buckets TO authenticated;
GRANT SELECT ON storage.buckets TO anon;
GRANT ALL ON storage.objects TO authenticated;
GRANT SELECT ON storage.objects TO anon;

-- =============================================================================
-- 4. FONCTIONS SQL POUR LA GESTION DES VÉRIFICATIONS
-- =============================================================================

-- Fonction pour que les experts demandent une vérification
CREATE OR REPLACE FUNCTION request_expert_verification(
  p_documents JSONB -- Format JSON avec les URLs des documents
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID;
  v_user_exists BOOLEAN;
BEGIN
  -- Récupérer l'ID de l'utilisateur authentifié
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Vous devez être connecté pour demander une vérification';
  END IF;
  
  -- Vérifier si l'utilisateur existe
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = v_user_id) INTO v_user_exists;
  
  IF NOT v_user_exists THEN
    RAISE EXCEPTION 'Profil utilisateur introuvable';
  END IF;
  
  -- Vérifier si une demande est déjà en cours
  IF EXISTS(SELECT 1 FROM verifications WHERE user_id = v_user_id AND status = 'pending') THEN
    RAISE EXCEPTION 'Vous avez déjà une demande de vérification en cours';
  END IF;
  
  -- Créer ou mettre à jour la demande de vérification
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
  
  -- Notifier les administrateurs de la nouvelle demande
  INSERT INTO notifications (
    profile_id,
    title,
    content,
    type,
    action_url
  )
  SELECT 
    id,
    'Nouvelle demande de vérification expert',
    'Un utilisateur a demandé une vérification expert. Veuillez examiner ses documents.',
    'admin_verification',
    '/admin/verifications'
  FROM profiles
  WHERE is_admin = TRUE;
  
  -- Notifier l'utilisateur que sa demande est en cours de traitement
  INSERT INTO notifications (
    profile_id,
    title,
    content,
    type,
    action_url
  ) VALUES (
    v_user_id,
    'Demande de vérification soumise',
    'Votre demande de vérification expert a été soumise et est en cours d''examen.',
    'verification',
    '/account/verification'
  );
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour que les administrateurs vérifient les experts
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
  -- Vérifier si l'administrateur existe et a les droits d'administration
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) INTO v_is_admin;
  
  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'Seuls les administrateurs peuvent vérifier les experts';
  END IF;
  
  -- Vérifier si l'utilisateur existe
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_user_id) INTO v_user_exists;
  
  IF NOT v_user_exists THEN
    RAISE EXCEPTION 'Utilisateur introuvable';
  END IF;
  
  -- Déterminer le statut de vérification
  v_status := CASE WHEN p_approved THEN 'approved' ELSE 'rejected' END;
  
  -- Vérifier si un enregistrement de vérification existe déjà
  IF EXISTS(SELECT 1 FROM verifications WHERE user_id = p_user_id) THEN
    -- Mettre à jour l'enregistrement existant
    UPDATE verifications
    SET 
      status = v_status,
      rejection_reason = CASE WHEN NOT p_approved THEN p_rejection_reason ELSE NULL END,
      reviewed_by = p_admin_id,
      reviewed_at = NOW(),
      updated_at = NOW()
    WHERE user_id = p_user_id;
  ELSE
    -- Créer un nouvel enregistrement de vérification
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
  
  -- Si rejeté, créer une notification expliquant pourquoi
  IF NOT p_approved AND p_rejection_reason IS NOT NULL THEN
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      p_user_id,
      'Vérification rejetée',
      'Votre vérification expert a été rejetée: ' || p_rejection_reason,
      'verification',
      '/account/verification'
    );
  END IF;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction simplifiée pour que les administrateurs traitent les vérifications
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
  -- Vérifier si l'utilisateur est administrateur
  SELECT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) INTO v_is_admin;
  
  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'Seuls les administrateurs peuvent approuver/rejeter les vérifications';
  END IF;
  
  -- Obtenir l'ID utilisateur de la vérification
  SELECT user_id INTO v_user_id FROM verifications WHERE id = p_verification_id;
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Vérification introuvable';
  END IF;
  
  -- Mettre à jour le statut de vérification
  UPDATE verifications
  SET 
    status = CASE WHEN p_approved THEN 'approved' ELSE 'rejected' END,
    rejection_reason = CASE WHEN NOT p_approved THEN p_rejection_reason ELSE NULL END,
    reviewed_by = p_admin_id,
    reviewed_at = NOW(),
    updated_at = NOW()
  WHERE id = p_verification_id;
  
  -- Générer les notifications appropriées
  IF p_approved THEN
    -- Notifier l'utilisateur qu'il a été approuvé
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      v_user_id,
      'Vérification expert approuvée',
      'Votre vérification expert a été approuvée. Vous pouvez maintenant proposer des services et répondre aux demandes.',
      'verification',
      '/account/profile'
    );
  ELSE
    -- Notifier l'utilisateur qu'il a été rejeté
    INSERT INTO notifications (
      profile_id,
      title,
      content,
      type,
      action_url
    ) VALUES (
      v_user_id,
      'Vérification expert rejetée',
      'Votre vérification expert a été rejetée' || 
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

-- Fonction pour que les administrateurs listent les vérifications
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
  -- Vérifier si l'utilisateur est administrateur
  IF NOT EXISTS(SELECT 1 FROM profiles WHERE id = p_admin_id AND is_admin = TRUE) THEN
    RAISE EXCEPTION 'Accès non autorisé';
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

-- =============================================================================
-- 5. TRIGGERS NÉCESSAIRES
-- =============================================================================

-- Trigger pour mettre à jour automatiquement le timestamp
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger de mise à jour du timestamp à la table verifications
DROP TRIGGER IF EXISTS set_verifications_updated_at ON verifications;
CREATE TRIGGER set_verifications_updated_at
  BEFORE UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Trigger pour mettre à jour le statut d'expert lors de l'approbation de la vérification
CREATE OR REPLACE FUNCTION verify_expert()
RETURNS TRIGGER AS $$
BEGIN
  -- Si la vérification est approuvée, automatiquement définir l'utilisateur comme expert
  IF NEW.status = 'approved' AND (OLD IS NULL OR OLD.status != 'approved') THEN
    UPDATE profiles 
    SET 
      is_expert = TRUE,
      is_verified = TRUE
    WHERE id = NEW.user_id;
    
    -- Créer une notification pour l'utilisateur
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.user_id,
      'Vérification approuvée',
      'Votre vérification expert a été approuvée. Vous pouvez maintenant offrir des services et répondre aux demandes.',
      'verification',
      '/account/profile'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger de vérification expert
DROP TRIGGER IF EXISTS expert_verification_trigger ON verifications;
CREATE TRIGGER expert_verification_trigger
  AFTER INSERT OR UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION verify_expert();

-- =============================================================================
-- NOTICE DE FIN
-- =============================================================================

-- Journaliser la fin de l'initialisation
DO $$
BEGIN
  RAISE NOTICE 'Configuration du système de vérification des experts terminée avec succès!';
  RAISE NOTICE 'Les utilisateurs peuvent maintenant télécharger des documents et demander une vérification expert.';
  RAISE NOTICE 'Les administrateurs peuvent approuver ou rejeter les demandes de vérification.';
END $$; 