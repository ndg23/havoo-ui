-- =========================================================================
-- EXTENSION POUR LE SCHÉMA HAVOO-UI : ACTIVITÉS
-- =========================================================================
-- Ce fichier contient la définition de la table d'activités et les fonctions
-- et triggers associés pour suivre les actions des utilisateurs dans l'application.
-- Auteur: Havoo Team
-- Date: Juin 2024
-- Version: 1.0.0
-- =========================================================================

-- =========================================================================
-- DÉFINITION DE LA TABLE D'ACTIVITÉS
-- =========================================================================

-- Table activités pour suivre les actions des utilisateurs
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  action_type VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete', 'login', 'logout', etc.
  entity_type VARCHAR(50) NOT NULL, -- 'profile', 'mission', 'deal', 'service', etc.
  entity_id UUID, -- ID de l'objet concerné
  details JSONB, -- Détails supplémentaires sur l'action
  ip_location VARCHAR(45), -- Pour suivre l'adresse IP (IPv4/IPv6)
  user_agent TEXT, -- Pour suivre le navigateur/appareil
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour optimiser les performances
CREATE INDEX idx_activities_user_id ON activities(user_id);
CREATE INDEX idx_activities_action_type ON activities(action_type);
CREATE INDEX idx_activities_entity_type ON activities(entity_type);
CREATE INDEX idx_activities_entity_id ON activities(entity_id);
CREATE INDEX idx_activities_created_at ON activities(created_at);

-- =========================================================================
-- FONCTIONS POUR LA GESTION DES ACTIVITÉS
-- =========================================================================

-- Fonction pour enregistrer une activité
CREATE OR REPLACE FUNCTION log_activity(
  p_user_id UUID,
  p_action_type VARCHAR(50),
  p_entity_type VARCHAR(50),
  p_entity_id UUID,
  p_details JSONB DEFAULT NULL,
  p_ip_location VARCHAR(45) DEFAULT NULL,
  p_user_agent TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_activity_id UUID;
BEGIN
  INSERT INTO activities (
    user_id,
    action_type,
    entity_type,
    entity_id,
    details,
    ip_location,
    user_agent
  ) VALUES (
    p_user_id,
    p_action_type,
    p_entity_type,
    p_entity_id,
    p_details,
    p_ip_location,
    p_user_agent
  ) RETURNING id INTO v_activity_id;
  
  RETURN v_activity_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction simplifiée pour les opérations quotidiennes (utilise l'utilisateur authentifié)
CREATE OR REPLACE FUNCTION log_user_activity(
  p_action_type VARCHAR(50),
  p_entity_type VARCHAR(50),
  p_entity_id UUID,
  p_details JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_user_id UUID;
BEGIN
  -- Récupérer l'ID de l'utilisateur authentifié
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Utilisateur non authentifié';
  END IF;
  
  -- Appeler la fonction principale
  RETURN log_activity(
    v_user_id,
    p_action_type,
    p_entity_type,
    p_entity_id,
    p_details,
    mission.header('X-Forwarded-For'),
    mission.header('User-Agent')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =========================================================================
-- TRIGGERS POUR AUTOMATISER LE SUIVI DES ACTIVITÉS
-- =========================================================================

-- Fonction pour le trigger de suivi des modifications des profils
CREATE OR REPLACE FUNCTION track_profile_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  -- Déterminer le type d'action
  IF TG_OP = 'INSERT' THEN
    v_action_type := 'create';
    v_details := jsonb_build_object(
      'first_name', NEW.first_name,
      'last_name', NEW.last_name,
      'email', NEW.email
    );
  ELSIF TG_OP = 'UPDATE' THEN
    v_action_type := 'update';
    v_details := jsonb_build_object();
    
    -- Capturer uniquement les champs qui ont changé
    IF NEW.first_name IS DISTINCT FROM OLD.first_name THEN
      v_details := v_details || jsonb_build_object('first_name', NEW.first_name, 'previous_first_name', OLD.first_name);
    END IF;
    
    IF NEW.last_name IS DISTINCT FROM OLD.last_name THEN
      v_details := v_details || jsonb_build_object('last_name', NEW.last_name, 'previous_last_name', OLD.last_name);
    END IF;
    
    IF NEW.email IS DISTINCT FROM OLD.email THEN
      v_details := v_details || jsonb_build_object('email', NEW.email, 'previous_email', OLD.email);
    END IF;
    
    IF NEW.is_expert IS DISTINCT FROM OLD.is_expert THEN
      v_details := v_details || jsonb_build_object('is_expert', NEW.is_expert, 'previous_is_expert', OLD.is_expert);
    END IF;
    
    IF NEW.is_verified IS DISTINCT FROM OLD.is_verified THEN
      v_details := v_details || jsonb_build_object('is_verified', NEW.is_verified, 'previous_is_verified', OLD.is_verified);
    END IF;
    
    -- Si aucun champ pertinent n'a changé, ne pas enregistrer d'activité
    IF v_details = '{}'::JSONB THEN
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    v_action_type := 'delete';
    v_details := jsonb_build_object(
      'first_name', OLD.first_name,
      'last_name', OLD.last_name,
      'email', OLD.email
    );
  END IF;
  
  -- Enregistrer l'activité
  PERFORM log_activity(
    COALESCE(auth.uid(), CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END),
    v_action_type,
    'profile',
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    v_details
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour suivre les modifications des profils
CREATE TRIGGER track_profile_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION track_profile_changes();

-- Fonction pour le trigger de suivi des vérifications
CREATE OR REPLACE FUNCTION track_verification_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  -- Déterminer le type d'action
  IF TG_OP = 'INSERT' THEN
    v_action_type := 'create';
    v_details := jsonb_build_object(
      'status', NEW.status,
      'user_id', NEW.user_id
    );
  ELSIF TG_OP = 'UPDATE' THEN
    v_action_type := 'update';
    v_details := jsonb_build_object();
    
    -- Capturer uniquement les champs qui ont changé
    IF NEW.status IS DISTINCT FROM OLD.status THEN
      v_details := v_details || jsonb_build_object('status', NEW.status, 'previous_status', OLD.status);
      
      -- Ajouter des informations supplémentaires pour les changements de statut importants
      IF NEW.status = 'approved' AND OLD.status = 'pending' THEN
        v_action_type := 'approve_verification';
      ELSIF NEW.status = 'rejected' AND OLD.status = 'pending' THEN
        v_action_type := 'reject_verification';
        IF NEW.rejection_reason IS NOT NULL THEN
          v_details := v_details || jsonb_build_object('rejection_reason', NEW.rejection_reason);
        END IF;
      END IF;
    END IF;
    
    -- Si aucun champ pertinent n'a changé, ne pas enregistrer d'activité
    IF v_details = '{}'::JSONB THEN
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    v_action_type := 'delete';
    v_details := jsonb_build_object(
      'status', OLD.status,
      'user_id', OLD.user_id
    );
  END IF;
  
  -- Enregistrer l'activité
  PERFORM log_activity(
    COALESCE(auth.uid(), NEW.reviewed_by),
    v_action_type,
    'verification',
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    v_details
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour suivre les modifications des vérifications
CREATE TRIGGER track_verification_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION track_verification_changes();

-- Fonction pour le trigger de suivi des demandes
CREATE OR REPLACE FUNCTION track_mission_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  -- Déterminer le type d'action
  IF TG_OP = 'INSERT' THEN
    v_action_type := 'create';
    v_details := jsonb_build_object(
      'title', NEW.title,
      'client_id', NEW.client_id,
      'profession_id', NEW.profession_id,
      'status', NEW.status
    );
  ELSIF TG_OP = 'UPDATE' THEN
    v_action_type := 'update';
    v_details := jsonb_build_object();
    
    -- Capturer uniquement les champs qui ont changé
    IF NEW.title IS DISTINCT FROM OLD.title THEN
      v_details := v_details || jsonb_build_object('title', NEW.title, 'previous_title', OLD.title);
    END IF;
    
    IF NEW.status IS DISTINCT FROM OLD.status THEN
      v_details := v_details || jsonb_build_object('status', NEW.status, 'previous_status', OLD.status);
      
      -- Ajouter des informations supplémentaires pour les changements de statut importants
      IF NEW.status = 'assigned' AND OLD.status = 'open' THEN
        v_action_type := 'assign_mission';
      ELSIF NEW.status = 'completed' AND OLD.status = 'assigned' THEN
        v_action_type := 'complete_mission';
      ELSIF NEW.status = 'cancelled' THEN
        v_action_type := 'cancel_mission';
      END IF;
    END IF;
    
    -- Si aucun champ pertinent n'a changé, ne pas enregistrer d'activité
    IF v_details = '{}'::JSONB THEN
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    v_action_type := 'delete';
    v_details := jsonb_build_object(
      'title', OLD.title,
      'client_id', OLD.client_id,
      'status', OLD.status
    );
  END IF;
  
  -- Enregistrer l'activité
  PERFORM log_activity(
    COALESCE(auth.uid(), CASE WHEN TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN OLD.client_id ELSE NEW.client_id END),
    v_action_type,
    'mission',
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    v_details
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour suivre les modifications des demandes
CREATE TRIGGER track_mission_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON missions
  FOR EACH ROW
  EXECUTE FUNCTION track_mission_changes();

-- Fonction pour le trigger de suivi des deals
CREATE OR REPLACE FUNCTION track_deal_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  -- Déterminer le type d'action
  IF TG_OP = 'INSERT' THEN
    v_action_type := 'create';
    v_details := jsonb_build_object(
      'mission_id', NEW.mission_id,
      'expert_id', NEW.expert_id,
      'client_id', NEW.client_id,
      'price', NEW.price,
      'status', NEW.status
    );
    
    -- Si c'est une proposition, ajuster le type d'action
    IF NEW.status = 'proposal' THEN
      v_action_type := 'propose_deal';
    END IF;
  ELSIF TG_OP = 'UPDATE' THEN
    v_action_type := 'update';
    v_details := jsonb_build_object();
    
    -- Capturer uniquement les champs qui ont changé
    IF NEW.status IS DISTINCT FROM OLD.status THEN
      v_details := v_details || jsonb_build_object('status', NEW.status, 'previous_status', OLD.status);
      
      -- Ajouter des informations supplémentaires pour les changements de statut importants
      IF NEW.status = 'active' AND OLD.status = 'proposal' THEN
        v_action_type := 'accept_deal';
      ELSIF NEW.status = 'completed' AND OLD.status = 'active' THEN
        v_action_type := 'complete_deal';
      ELSIF NEW.status = 'rejected' THEN
        v_action_type := 'reject_deal';
      END IF;
    END IF;
    
    -- Si les évaluations ont changé
    IF NEW.client_has_rated IS DISTINCT FROM OLD.client_has_rated AND NEW.client_has_rated = TRUE THEN
      v_details := v_details || jsonb_build_object(
        'client_rating', NEW.client_rating,
        'client_review', NEW.client_review
      );
      
      -- Si cette fonction est appelée juste pour l'évaluation, ajuster le type d'action
      IF v_action_type = 'update' THEN
        v_action_type := 'rate_deal';
      END IF;
    END IF;
    
    IF NEW.expert_has_rated IS DISTINCT FROM OLD.expert_has_rated AND NEW.expert_has_rated = TRUE THEN
      v_details := v_details || jsonb_build_object(
        'expert_rating', NEW.expert_rating,
        'expert_review', NEW.expert_review
      );
      
      -- Si cette fonction est appelée juste pour l'évaluation, ajuster le type d'action
      IF v_action_type = 'update' THEN
        v_action_type := 'rate_deal';
      END IF;
    END IF;
    
    -- Si aucun champ pertinent n'a changé, ne pas enregistrer d'activité
    IF v_details = '{}'::JSONB THEN
      RETURN NEW;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    v_action_type := 'delete';
    v_details := jsonb_build_object(
      'mission_id', OLD.mission_id,
      'expert_id', OLD.expert_id,
      'client_id', OLD.client_id,
      'status', OLD.status
    );
  END IF;
  
  -- Enregistrer l'activité
  PERFORM log_activity(
    COALESCE(auth.uid(), CASE 
      WHEN TG_OP = 'DELETE' THEN OLD.client_id
      WHEN TG_OP = 'INSERT' AND NEW.status = 'proposal' THEN NEW.expert_id
      WHEN TG_OP = 'UPDATE' AND NEW.status = 'active' AND OLD.status = 'proposal' THEN NEW.client_id
      WHEN TG_OP = 'UPDATE' AND NEW.status = 'completed' AND OLD.status = 'active' THEN NEW.client_id
      WHEN TG_OP = 'UPDATE' AND NEW.client_has_rated IS DISTINCT FROM OLD.client_has_rated AND NEW.client_has_rated = TRUE THEN NEW.client_id
      WHEN TG_OP = 'UPDATE' AND NEW.expert_has_rated IS DISTINCT FROM OLD.expert_has_rated AND NEW.expert_has_rated = TRUE THEN NEW.expert_id
      ELSE COALESCE(NEW.client_id, NEW.expert_id)
    END),
    v_action_type,
    'deal',
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    v_details
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour suivre les modifications des deals
CREATE TRIGGER track_deal_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON deals
  FOR EACH ROW
  EXECUTE FUNCTION track_deal_changes();

-- =========================================================================
-- POLITIQUES DE SÉCURITÉ (ROW LEVEL SECURITY)
-- =========================================================================

-- Activer RLS sur la table activités
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs peuvent voir leurs propres activités
CREATE POLICY "Users can view their own activities"
ON activities FOR SELECT
USING (auth.uid() = user_id);

-- Les administrateurs peuvent voir toutes les activités
CREATE POLICY "Admins can view all activities"
ON activities
USING (
  EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  )
);

-- Seul le système peut créer des activités via les fonctions de journalisation
CREATE POLICY "System can create activities"
ON activities FOR INSERT
WITH CHECK (TRUE);

-- =========================================================================
-- VUES POUR SIMPLIFIER LES REQUÊTES
-- =========================================================================

-- Vue pour les dernières activités par utilisateur
CREATE OR REPLACE VIEW user_recent_activities AS
SELECT a.*
FROM activities a
JOIN profiles p ON a.user_id = p.id
WHERE a.created_at > (NOW() - INTERVAL '30 days')
ORDER BY a.created_at DESC;

-- Vue pour les activités liées aux deals
CREATE OR REPLACE VIEW deal_activities AS
SELECT a.*, d.mission_id, d.client_id, d.expert_id, d.status AS deal_status
FROM activities a
JOIN deals d ON a.entity_id = d.id
WHERE a.entity_type = 'deal'
ORDER BY a.created_at DESC;

-- Vue pour les activités liées aux vérifications
CREATE OR REPLACE VIEW verification_activities AS
SELECT a.*, v.user_id AS verified_user_id, v.status AS verification_status
FROM activities a
JOIN verifications v ON a.entity_id = v.id
WHERE a.entity_type = 'verification'
ORDER BY a.created_at DESC;

-- Vue pour les activités récentes du système (toutes entités confondues)
CREATE OR REPLACE VIEW recent_system_activities AS
SELECT *
FROM activities
WHERE created_at > (NOW() - INTERVAL '7 days')
ORDER BY created_at DESC; 