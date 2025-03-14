-- Schéma principal de la base de données
CREATE SCHEMA IF NOT EXISTS public;

-- Activation des extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ========================
-- TABLES PRINCIPALES
-- ========================

-- Table des profils utilisateurs (associée à auth.users de Supabase)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  birth_date DATE,
  gender VARCHAR(20),
  address TEXT,
  city VARCHAR(100),
  zip_code VARCHAR(20),
  country VARCHAR(100),
  bio TEXT,
  avatar_url TEXT,
  banner_url TEXT,
  is_expert BOOLEAN DEFAULT FALSE,
  specialty VARCHAR(100),
  years_of_experience INTEGER,
  education TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  is_available BOOLEAN DEFAULT TRUE,
  profile_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des compétences des utilisateurs
CREATE TABLE user_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  skill VARCHAR(100) NOT NULL,
  UNIQUE (user_id, skill)
);

-- Table des catégories de services
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  icon VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des services proposés par les experts
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price_base DECIMAL(10, 2) NOT NULL,
  delivery_time INTEGER NOT NULL, -- En jours
  revision_count INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT TRUE,
  is_draft BOOLEAN DEFAULT FALSE,
  cover_image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des demandes publiées par les clients
CREATE TABLE requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget_min DECIMAL(10, 2),
  budget_max DECIMAL(10, 2),
  deadline DATE,
  is_urgent BOOLEAN DEFAULT FALSE,
  status VARCHAR(20) NOT NULL DEFAULT 'open', -- open, assigned, completed, cancelled
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des compétences requises pour les demandes
CREATE TABLE request_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
  skill VARCHAR(100) NOT NULL,
  UNIQUE (request_id, skill)
);

-- Table des fichiers attachés aux demandes
CREATE TABLE request_files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
  file_name VARCHAR(255) NOT NULL,
  file_size INTEGER NOT NULL,
  file_type VARCHAR(100) NOT NULL,
  file_url TEXT NOT NULL,
  uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des propositions faites par les experts sur des demandes
CREATE TABLE proposals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  price DECIMAL(10, 2) NOT NULL,
  delivery_time INTEGER NOT NULL, -- En jours
  description TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, accepted, rejected
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (request_id, expert_id)
);

-- Table des contrats entre clients et experts
CREATE TABLE contracts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id UUID REFERENCES requests(id),
  service_id UUID REFERENCES services(id),
  client_id UUID NOT NULL REFERENCES profiles(id),
  expert_id UUID NOT NULL REFERENCES profiles(id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  amount DECIMAL(10, 2) NOT NULL,
  start_date DATE NOT NULL,
  due_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, active, completed, cancelled
  terms TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (
    (request_id IS NOT NULL AND service_id IS NULL) OR
    (request_id IS NULL AND service_id IS NOT NULL)
  )
);

-- Table des livrables associés aux contrats
CREATE TABLE deliverables (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contract_id UUID NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  file_url TEXT,
  delivered_at TIMESTAMPTZ,
  is_approved BOOLEAN DEFAULT FALSE,
  approved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des conversations
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contract_id UUID REFERENCES contracts(id) ON DELETE SET NULL,
  request_id UUID REFERENCES requests(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des participants à une conversation
CREATE TABLE conversation_participants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (conversation_id, user_id)
);

-- Table des messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  attachment_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des avis/évaluations
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contract_id UUID NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,
  reviewer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reviewee_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (contract_id, reviewer_id)
);

-- Table des préférences de notification
CREATE TABLE notification_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  email_notifications BOOLEAN DEFAULT TRUE,
  sms_notifications BOOLEAN DEFAULT FALSE,
  push_notifications BOOLEAN DEFAULT TRUE,
  new_message_notify BOOLEAN DEFAULT TRUE,
  contract_updates_notify BOOLEAN DEFAULT TRUE,
  review_notify BOOLEAN DEFAULT TRUE,
  marketing_notify BOOLEAN DEFAULT FALSE,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id)
);

-- Table des préférences utilisateur
CREATE TABLE user_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  theme VARCHAR(20) DEFAULT 'system', -- light, dark, system
  locale VARCHAR(10) DEFAULT 'fr',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id)
);

-- ========================
-- VUES
-- ========================

-- Vue des services avec informations sur l'expert
CREATE VIEW service_details AS
SELECT 
  s.*,
  p.first_name,
  p.last_name,
  p.avatar_url,
  p.is_verified,
  c.name AS category_name
FROM services s
JOIN profiles p ON s.user_id = p.id
JOIN categories c ON s.category_id = c.id
WHERE s.is_draft = FALSE AND s.is_active = TRUE;

-- Vue des demandes avec détails client et catégorie
CREATE VIEW request_details AS
SELECT 
  r.*,
  p.first_name,
  p.last_name,
  p.avatar_url,
  c.name AS category_name
FROM requests r
JOIN profiles p ON r.user_id = p.id
JOIN categories c ON r.category_id = c.id
WHERE r.status = 'open';

-- Vue des contrats avec détails clients et experts
CREATE VIEW contract_details AS
SELECT 
  c.*,
  pc.first_name AS client_first_name,
  pc.last_name AS client_last_name,
  pc.avatar_url AS client_avatar,
  pe.first_name AS expert_first_name,
  pe.last_name AS expert_last_name,
  pe.avatar_url AS expert_avatar,
  pe.is_verified AS expert_verified
FROM contracts c
JOIN profiles pc ON c.client_id = pc.id
JOIN profiles pe ON c.expert_id = pe.id;

-- Vue des conversations avec dernier message
CREATE VIEW conversation_with_last_message AS
SELECT 
  c.id AS conversation_id,
  c.contract_id,
  c.request_id,
  c.created_at,
  m.id AS last_message_id,
  m.sender_id,
  m.content AS last_message_content,
  m.created_at AS last_message_date,
  m.is_read
FROM conversations c
LEFT JOIN (
  SELECT DISTINCT ON (conversation_id) *
  FROM messages
  ORDER BY conversation_id, created_at DESC
) m ON c.id = m.conversation_id;

-- ========================
-- FONCTIONS
-- ========================

-- Fonction pour obtenir toutes les conversations d'un utilisateur avec leur dernier message
CREATE OR REPLACE FUNCTION get_conversations_with_last_message(p_user_id UUID)
RETURNS TABLE (
  conversation_id UUID,
  other_user_id UUID,
  other_user_name TEXT,
  other_user_avatar TEXT,
  related_to TEXT,
  last_message_content TEXT,
  last_message_date TIMESTAMPTZ,
  is_from_me BOOLEAN,
  unread_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  WITH user_conversations AS (
    SELECT 
      cp.conversation_id
    FROM conversation_participants cp
    WHERE cp.user_id = p_user_id
  ),
  other_participants AS (
    SELECT 
      cp.conversation_id,
      cp.user_id AS other_user_id
    FROM conversation_participants cp
    JOIN user_conversations uc ON cp.conversation_id = uc.conversation_id
    WHERE cp.user_id != p_user_id
  ),
  unread_counts AS (
    SELECT 
      m.conversation_id,
      COUNT(*) AS count
    FROM messages m
    JOIN user_conversations uc ON m.conversation_id = uc.conversation_id
    WHERE m.sender_id != p_user_id AND m.is_read = FALSE
    GROUP BY m.conversation_id
  ),
  last_messages AS (
    SELECT DISTINCT ON (m.conversation_id)
      m.conversation_id,
      m.content,
      m.created_at,
      m.sender_id = p_user_id AS is_from_me
    FROM messages m
    JOIN user_conversations uc ON m.conversation_id = uc.conversation_id
    ORDER BY m.conversation_id, m.created_at DESC
  )
  SELECT 
    c.id AS conversation_id,
    op.other_user_id,
    (p.first_name || ' ' || p.last_name) AS other_user_name,
    p.avatar_url AS other_user_avatar,
    COALESCE(
      (SELECT title FROM contracts WHERE id = c.contract_id),
      (SELECT title FROM requests WHERE id = c.request_id),
      'Discussion'
    ) AS related_to,
    lm.content AS last_message_content,
    lm.created_at AS last_message_date,
    lm.is_from_me,
    COALESCE(uc.count, 0) AS unread_count
  FROM conversations c
  JOIN user_conversations uc2 ON c.id = uc2.conversation_id
  JOIN other_participants op ON c.id = op.conversation_id
  JOIN profiles p ON op.other_user_id = p.id
  LEFT JOIN last_messages lm ON c.id = lm.conversation_id
  LEFT JOIN unread_counts uc ON c.id = uc.conversation_id
  ORDER BY lm.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ========================
-- DÉCLENCHEURS
-- ========================

-- Déclencheur pour mettre à jour le timestamp updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le déclencheur aux tables appropriées
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_requests_updated_at BEFORE UPDATE ON requests
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_proposals_updated_at BEFORE UPDATE ON proposals
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contracts_updated_at BEFORE UPDATE ON contracts
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Déclencheur pour créer automatiquement une conversation lors de la création d'une proposition
CREATE OR REPLACE FUNCTION create_proposal_conversation()
RETURNS TRIGGER AS $$
DECLARE
  v_conversation_id UUID;
  v_request_client_id UUID;
BEGIN
  -- Obtenir l'ID du client qui a créé la demande
  SELECT user_id INTO v_request_client_id FROM requests WHERE id = NEW.request_id;
  
  -- Créer une nouvelle conversation
  INSERT INTO conversations (request_id) VALUES (NEW.request_id) RETURNING id INTO v_conversation_id;
  
  -- Ajouter le client comme participant
  INSERT INTO conversation_participants (conversation_id, user_id) VALUES (v_conversation_id, v_request_client_id);
  
  -- Ajouter l'expert comme participant
  INSERT INTO conversation_participants (conversation_id, user_id) VALUES (v_conversation_id, NEW.expert_id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_proposal_created
AFTER INSERT ON proposals
FOR EACH ROW EXECUTE FUNCTION create_proposal_conversation();

-- Déclencheur pour créer automatiquement une conversation lors de la création d'un contrat
CREATE OR REPLACE FUNCTION create_contract_conversation()
RETURNS TRIGGER AS $$
DECLARE
  v_conversation_id UUID;
BEGIN
  -- Créer une nouvelle conversation
  INSERT INTO conversations (contract_id) VALUES (NEW.id) RETURNING id INTO v_conversation_id;
  
  -- Ajouter le client comme participant
  INSERT INTO conversation_participants (conversation_id, user_id) VALUES (v_conversation_id, NEW.client_id);
  
  -- Ajouter l'expert comme participant
  INSERT INTO conversation_participants (conversation_id, user_id) VALUES (v_conversation_id, NEW.expert_id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_contract_created
AFTER INSERT ON contracts
FOR EACH ROW EXECUTE FUNCTION create_contract_conversation();

-- ========================
-- POLITIQUES RLS (Row Level Security)
-- ========================

-- Activer RLS sur toutes les tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE request_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE request_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverables ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- Exemples de politiques (à compléter selon vos besoins de sécurité)
CREATE POLICY "Les utilisateurs peuvent voir leurs propres profils"
ON profiles FOR SELECT
USING (id = auth.uid());

CREATE POLICY "Les utilisateurs peuvent mettre à jour leurs propres profils"
ON profiles FOR UPDATE
USING (id = auth.uid());

CREATE POLICY "Les utilisateurs peuvent voir tous les services actifs"
ON services FOR SELECT
USING (is_active = TRUE AND is_draft = FALSE);

CREATE POLICY "Les experts peuvent gérer leurs propres services"
ON services FOR ALL
USING (user_id = auth.uid());

CREATE POLICY "Les utilisateurs peuvent voir toutes les demandes ouvertes"
ON requests FOR SELECT
USING (status = 'open');

CREATE POLICY "Les clients peuvent gérer leurs propres demandes"
ON requests FOR ALL
USING (user_id = auth.uid());

-- ========================
-- DONNÉES INITIALES
-- ========================

-- Insertion des catégories initiales
INSERT INTO categories (name, description, icon) VALUES
('Développement Web', 'Création de sites web et applications', 'code'),
('Design Graphique', 'Logos, illustrations et identité visuelle', 'palette'),
('Rédaction & Traduction', 'Contenu de qualité dans différentes langues', 'file-text'),
('Marketing Digital', 'SEO, réseaux sociaux et publicité en ligne', 'trending-up'),
('Audio & Vidéo', 'Production et édition audiovisuelle', 'film'),
('Business & Conseil', 'Stratégie, finance et développement d''affaires', 'briefcase');

-- Supprimer la table des milestones si elle existe
DROP TABLE IF EXISTS contract_milestones;

-- Modifier la table des contrats pour retirer les références aux milestones
ALTER TABLE contracts
DROP COLUMN IF EXISTS has_milestones,
DROP COLUMN IF EXISTS milestones_count,
DROP COLUMN IF EXISTS current_milestone;

-- Si vous avez des contraintes de clé étrangère liées aux milestones, les supprimer
-- Par exemple:
ALTER TABLE payments
DROP CONSTRAINT IF EXISTS fk_payment_milestone;