-- =========================================================================
-- SCHÉMA COMPLET POUR HAVOO-UI
-- =========================================================================
-- Ce fichier regroupe l'ensemble de la définition de la base de données Havoo-UI,
-- incluant les tables, fonctions, déclencheurs et politiques de sécurité.
-- Auteur: Havoo Team
-- Date: Juin 2024
-- Version: 1.0.0
-- =========================================================================

-- Activer l'extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- DÉFINITION DES TABLES
-- =========================================================================

-- Profils utilisateurs
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50),
  bio TEXT,
  avatar_url TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  is_admin BOOLEAN DEFAULT FALSE,
  role VARCHAR(20) DEFAULT 'client' NOT NULL, -- 'client' ou 'expert'
  is_expert BOOLEAN DEFAULT FALSE,
  city VARCHAR(255),
  zip_code VARCHAR(255),
  country VARCHAR(255),
  address TEXT,
  birthdate DATE,
  website VARCHAR(255),
  hourly_rate DECIMAL(10, 2),
  availability_status VARCHAR(20) DEFAULT 'available',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  profile_completion_percentage INTEGER DEFAULT 20
);

-- Catégories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compétences liées aux catégories
CREATE TABLE skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compétences des utilisateurs
CREATE TABLE user_skills (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, skill_id)
);

-- Demandes des clients
CREATE TABLE requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget DECIMAL(10, 2),
  deadline DATE,
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'completed', 'cancelled')),
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deals (propositions et contrats combinés)
CREATE TABLE deals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  client_id UUID REFERENCES profiles(id),
  price DECIMAL(10, 2) NOT NULL,
  duration INTEGER NOT NULL, -- En jours
  message TEXT,
  status VARCHAR(50) DEFAULT 'proposal' CHECK (status IN ('proposal', 'active', 'completed', 'rejected', 'cancelled')),
  client_rating INTEGER CHECK (client_rating BETWEEN 1 AND 5),
  expert_rating INTEGER CHECK (expert_rating BETWEEN 1 AND 5),
  client_review TEXT,
  expert_review TEXT,
  client_has_rated BOOLEAN DEFAULT FALSE,
  expert_has_rated BOOLEAN DEFAULT FALSE,
  ratings_complete BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(request_id, expert_id)
);

-- Services proposés par les experts
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  category_id UUID REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  delivery_time INTEGER, -- En jours
  is_active BOOLEAN DEFAULT TRUE,
  location_type VARCHAR(20) DEFAULT 'remote' CHECK (location_type IN ('remote', 'onsite', 'hybrid')),
  location_latitude DECIMAL(10, 8),
  location_longitude DECIMAL(11, 8),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compétences des services
CREATE TABLE service_skills (
  service_id UUID REFERENCES services(id) ON DELETE CASCADE,
  skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (service_id, skill_id)
);

-- Avis
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  deal_id UUID REFERENCES deals(id) ON DELETE CASCADE,
  reviewer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  reviewee_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversations
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID REFERENCES requests(id) ON DELETE SET NULL,
  deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Participants aux conversations
CREATE TABLE conversation_participants (
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  PRIMARY KEY (conversation_id, profile_id)
);

-- Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(50),
  action_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vérifications d'experts
CREATE TABLE verifications (
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

-- Paramètres
CREATE TABLE settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key TEXT NOT NULL UNIQUE,
  value JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =========================================================================
-- ACTIVITÉS - SUIVI DES ACTIONS UTILISATEURS
-- =========================================================================

-- Table activités pour suivre les actions des utilisateurs
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  action_type VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete', 'login', 'logout', etc.
  entity_type VARCHAR(50) NOT NULL, -- 'profile', 'request', 'deal', 'service', etc.
  entity_id UUID, -- ID de l'objet concerné
  details JSONB, -- Détails supplémentaires sur l'action
  ip_address VARCHAR(45), -- Pour suivre l'adresse IP (IPv4/IPv6)
  user_agent TEXT, -- Pour suivre le navigateur/appareil
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour optimiser les performances
CREATE INDEX idx_activities_user_id ON activities(user_id);
CREATE INDEX idx_activities_action_type ON activities(action_type);
CREATE INDEX idx_activities_entity_type ON activities(entity_type);
CREATE INDEX idx_activities_entity_id ON activities(entity_id);
CREATE INDEX idx_activities_created_at ON activities(created_at);

-- Fonction pour enregistrer une activité
CREATE OR REPLACE FUNCTION log_activity(
  p_user_id UUID,
  p_action_type VARCHAR(50),
  p_entity_type VARCHAR(50),
  p_entity_id UUID,
  p_details JSONB DEFAULT NULL,
  p_ip_address VARCHAR(45) DEFAULT NULL,
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
    ip_address,
    user_agent
  ) VALUES (
    p_user_id,
    p_action_type,
    p_entity_type,
    p_entity_id,
    p_details,
    p_ip_address,
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
    request.header('X-Forwarded-For'),
    request.header('User-Agent')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

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

-- Fonction pour le trigger de suivi des demandes
CREATE OR REPLACE FUNCTION track_request_changes()
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
      'category_id', NEW.category_id,
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
        v_action_type := 'assign_request';
      ELSIF NEW.status = 'completed' AND OLD.status = 'assigned' THEN
        v_action_type := 'complete_request';
      ELSIF NEW.status = 'cancelled' THEN
        v_action_type := 'cancel_request';
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
    'request',
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    v_details
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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
      'request_id', NEW.request_id,
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
      'request_id', OLD.request_id,
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

-- RLS pour la table activités
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

-- Vues pour l'analyse des activités
CREATE OR REPLACE VIEW user_recent_activities AS
SELECT a.*
FROM activities a
JOIN profiles p ON a.user_id = p.id
WHERE a.created_at > (NOW() - INTERVAL '30 days')
ORDER BY a.created_at DESC;

CREATE OR REPLACE VIEW deal_activities AS
SELECT a.*, d.request_id, d.client_id, d.expert_id, d.status AS deal_status
FROM activities a
JOIN deals d ON a.entity_id = d.id
WHERE a.entity_type = 'deal'
ORDER BY a.created_at DESC;

CREATE OR REPLACE VIEW verification_activities AS
SELECT a.*, v.user_id AS verified_user_id, v.status AS verification_status
FROM activities a
JOIN verifications v ON a.entity_id = v.id
WHERE a.entity_type = 'verification'
ORDER BY a.created_at DESC;

CREATE OR REPLACE VIEW recent_system_activities AS
SELECT *
FROM activities
WHERE created_at > (NOW() - INTERVAL '7 days')
ORDER BY created_at DESC;

-- Triggers pour le suivi automatique des activités
CREATE TRIGGER track_profile_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION track_profile_changes();

CREATE TRIGGER track_verification_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION track_verification_changes();

CREATE TRIGGER track_request_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON requests
  FOR EACH ROW
  EXECUTE FUNCTION track_request_changes();

CREATE TRIGGER track_deal_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON deals
  FOR EACH ROW
  EXECUTE FUNCTION track_deal_changes();

-- =========================================================================
-- INDEX POUR L'OPTIMISATION DES PERFORMANCES
-- =========================================================================

CREATE INDEX idx_requests_client_id ON requests(client_id);
CREATE INDEX idx_deals_expert_id ON deals(expert_id);
CREATE INDEX idx_deals_request_id ON deals(request_id);
CREATE INDEX idx_services_expert_id ON services(expert_id);
CREATE INDEX idx_user_skills_user_id ON user_skills(user_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
CREATE INDEX idx_conversations_last_message_at ON conversations(last_message_at);
CREATE INDEX idx_verifications_user_id ON verifications(user_id);
CREATE INDEX idx_verifications_status ON verifications(status);
CREATE INDEX idx_notifications_profile_id ON notifications(profile_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX settings_key_idx ON settings(key);

-- =========================================================================
-- FONCTIONS
-- =========================================================================

-- Fonction pour la mise à jour automatique des timestamps
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour le calcul du pourcentage de complétion du profil
CREATE OR REPLACE FUNCTION calculate_profile_completion()
RETURNS TRIGGER AS $$
DECLARE
  completed_fields INTEGER := 1; -- Commencer avec 1 pour les champs obligatoires
  total_fields INTEGER := 5; -- Nombre total de champs pour le calcul du pourcentage
BEGIN
  -- Compter les champs optionnels complétés
  IF NEW.phone IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.bio IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.avatar_url IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.is_expert = TRUE THEN completed_fields := completed_fields + 1; END IF;
  
  -- Calculer le pourcentage
  NEW.profile_completion_percentage := (completed_fields::FLOAT / total_fields::FLOAT * 100)::INTEGER;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour la mise à jour du statut d'expert
CREATE OR REPLACE FUNCTION update_expert_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE profiles SET is_expert = true, is_verified = true WHERE id = NEW.user_id;

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

-- Fonction pour la demande de vérification expert
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

-- Fonction pour la vérification d'expert par les administrateurs
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

-- Fonction pour noter un contrat (simplifiée)
CREATE OR REPLACE FUNCTION rate_contract_simple(
  p_deal_id UUID,
  p_is_client BOOLEAN, -- TRUE si le client note, FALSE si l'expert note
  p_rating INTEGER,
  p_comment TEXT
) RETURNS BOOLEAN AS $$
BEGIN
  -- Mettre à jour le deal avec la notation
  IF p_is_client THEN
    UPDATE deals
    SET 
      client_rating = p_rating,
      client_review = p_comment,
      client_has_rated = TRUE
    WHERE id = p_deal_id;
  ELSE
    UPDATE deals
    SET 
      expert_rating = p_rating,
      expert_review = p_comment,
      expert_has_rated = TRUE
    WHERE id = p_deal_id;
  END IF;
  
  -- Vérifier si les deux ont noté et mettre à jour le statut si nécessaire
  UPDATE deals
  SET ratings_complete = TRUE
  WHERE id = p_deal_id
    AND client_has_rated = TRUE
    AND expert_has_rated = TRUE;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour marquer un contrat comme terminé
CREATE OR REPLACE FUNCTION complete_contract(
  p_contract_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_deal RECORD;
  v_is_client BOOLEAN;
BEGIN
  -- Obtenir les informations du deal
  SELECT * INTO v_deal FROM deals 
  WHERE id = p_contract_id;
  
  IF v_deal IS NULL THEN
    RAISE EXCEPTION 'Contrat introuvable';
  END IF;
  
  -- Vérifier si l'utilisateur est le client pour ce deal
  v_is_client := (v_deal.client_id = p_user_id);
  
  -- Seul le client peut marquer un contrat comme terminé
  IF NOT v_is_client THEN
    RAISE EXCEPTION 'Seul le client peut marquer un contrat comme terminé';
  END IF;
  
  -- Marquer comme terminé
  UPDATE deals
  SET 
    status = 'completed',
    updated_at = NOW()
  WHERE id = p_contract_id;
  
  -- Notifier les deux parties
  -- Notifier l'expert
  INSERT INTO notifications (
    profile_id, 
    title, 
    content, 
    type, 
    action_url
  ) VALUES (
    v_deal.expert_id,
    'Contrat terminé',
    'Un contrat a été marqué comme terminé. Veuillez évaluer votre expérience.',
    'contract_completed',
    '/account/contracts/' || p_contract_id || '/rate'
  );
  
  -- Notifier le client
  INSERT INTO notifications (
    profile_id, 
    title, 
    content, 
    type, 
    action_url
  ) VALUES (
    v_deal.client_id,
    'Contrat terminé',
    'Vous avez marqué un contrat comme terminé. Veuillez évaluer votre expérience avec l''expert.',
    'contract_completed',
    '/account/contracts/' || p_contract_id || '/rate'
  );
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour mettre à jour le dernier message d'une conversation
CREATE OR REPLACE FUNCTION update_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE conversations
  SET 
    last_message = NEW.content,
    last_message_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================================================
-- TRIGGERS
-- =========================================================================

-- Triggers pour la mise à jour automatique des timestamps
CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_skills_updated_at
  BEFORE UPDATE ON skills
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_requests_updated_at
  BEFORE UPDATE ON requests
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_deals_updated_at
  BEFORE UPDATE ON deals
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_services_updated_at
  BEFORE UPDATE ON services
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_reviews_updated_at
  BEFORE UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_conversations_updated_at
  BEFORE UPDATE ON conversations
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_messages_updated_at
  BEFORE UPDATE ON messages
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_verifications_updated_at
  BEFORE UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_settings_updated_at
  BEFORE UPDATE ON settings
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Trigger pour le calcul du pourcentage de complétion du profil
CREATE TRIGGER calculate_profile_completion_trigger
  BEFORE INSERT OR UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION calculate_profile_completion();

-- Trigger pour la mise à jour du statut d'expert lors de l'approbation de la vérification
CREATE TRIGGER update_expert_status_on_verification
  AFTER UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION update_expert_status();

-- Trigger pour la mise à jour du dernier message d'une conversation
CREATE TRIGGER update_conversation_last_message_trigger
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();

-- =========================================================================
-- POLITIQUES DE SÉCURITÉ (ROW LEVEL SECURITY)
-- =========================================================================

-- Activer RLS sur les tables critiques
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Politiques pour les profils
CREATE POLICY "Users can read their own profile"
ON profiles FOR SELECT
USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
ON profiles FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can manage all profiles"
ON profiles
USING (
  EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  )
);

-- Politiques pour les vérifications
CREATE POLICY "Users can view their own verification" 
ON verifications FOR SELECT 
USING (auth.uid() = user_id);
    
CREATE POLICY "Users can create their own verification" 
ON verifications FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own pending verification" 
ON verifications FOR UPDATE 
USING (auth.uid() = user_id AND status = 'pending')
WITH CHECK (auth.uid() = user_id AND status = 'pending');
    
CREATE POLICY "Admins can manage all verifications" 
ON verifications 
USING (
  EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  )
);

-- Politiques pour les paramètres
CREATE POLICY "Les admins peuvent tout faire" ON settings
USING (auth.uid() IN (SELECT id FROM profiles WHERE is_admin = true))
WITH CHECK (auth.uid() IN (SELECT id FROM profiles WHERE is_admin = true));

-- =========================================================================
-- CONFIGURATION DU STOCKAGE
-- =========================================================================

-- S'assurer que le bucket documents existe
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- Politiques de stockage pour les documents de vérification
CREATE POLICY "Users can upload their own verification documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

CREATE POLICY "Users can view their own verification documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

CREATE POLICY "Users can update their own verification documents"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

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

-- =========================================================================
-- FINALISATION
-- =========================================================================

-- Journaliser la fin de l'initialisation
DO $$
BEGIN
  RAISE NOTICE 'Schéma de base de données créé avec succès!';
END $$; 