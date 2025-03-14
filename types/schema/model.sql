-- Table des profils utilisateurs (extension de auth.users géré par Supabase)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50),
  bio TEXT,
  avatar_url TEXT,
  role VARCHAR(20) DEFAULT 'client' NOT NULL, -- 'client' ou 'expert'
  is_expert BOOLEAN DEFAULT FALSE,
  expert_status VARCHAR(50) DEFAULT NULL CHECK (expert_status IN (NULL, 'pending', 'approved', 'rejected')),
  location VARCHAR(255),
  timezone VARCHAR(50),
  language VARCHAR(50) DEFAULT 'fr',
  notification_preferences JSONB DEFAULT '{"email": true, "push": true, "sms": false}'::jsonb,
  last_login_at TIMESTAMP WITH TIME ZONE,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table pour les évaluations et avis
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE CASCADE,
  reviewer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  reviewee_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(contract_id, reviewer_id)
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  parent_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  icon_url TEXT,
  slug VARCHAR(255) UNIQUE,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE skills (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Demandes publiées par les clients
CREATE TABLE requests (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget DECIMAL(10, 2),
  budget_type VARCHAR(20) DEFAULT 'fixed' CHECK (budget_type IN ('fixed', 'hourly', 'range')),
  budget_max DECIMAL(10, 2), -- Pour les budgets de type 'range'
  deadline DATE,
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'completed', 'cancelled')),
  skills_required TEXT[], -- Tableau de compétences requises
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  location_type VARCHAR(20) DEFAULT 'remote' CHECK (location_type IN ('remote', 'onsite', 'hybrid')),
  location VARCHAR(255),
  visibility VARCHAR(20) DEFAULT 'public' CHECK (visibility IN ('public', 'private', 'invite_only')),
  attachments JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Propositions faites par les experts
CREATE TABLE proposals (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  price DECIMAL(10, 2) NOT NULL,
  price_type VARCHAR(20) DEFAULT 'fixed' CHECK (price_type IN ('fixed', 'hourly')),
  duration INTEGER NOT NULL, -- En jours
  message TEXT NOT NULL,
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'withdrawn')),
  attachments JSONB,
  cover_letter TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(request_id, expert_id)
);

-- Contrats entre clients et experts
CREATE TABLE contracts (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id),
  proposal_id INTEGER REFERENCES proposals(id),
  client_id UUID REFERENCES profiles(id),
  expert_id UUID REFERENCES profiles(id),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  price_type VARCHAR(20) DEFAULT 'fixed' CHECK (price_type IN ('fixed', 'hourly')),
  start_date DATE,
  end_date DATE,
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'cancelled', 'disputed')),
  payment_status VARCHAR(50) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'partial', 'refunded')),
  terms_conditions TEXT,
  milestones JSONB,
  attachments JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages entre utilisateurs
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  receiver_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP WITH TIME ZONE,
  attachments JSONB,
  message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text', 'file', 'system')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversations pour regrouper les messages
CREATE TABLE conversations (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  request_id INTEGER REFERENCES requests(id) ON DELETE SET NULL,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE SET NULL,
  last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table de jonction pour les participants aux conversations
CREATE TABLE conversation_participants (
  conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  is_muted BOOLEAN DEFAULT FALSE,
  last_read_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (conversation_id, profile_id)
);

-- Mise à jour de la table messages pour référencer les conversations
ALTER TABLE messages ADD COLUMN conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE;

CREATE TABLE user_skills (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  years_experience INTEGER,
  proficiency_level VARCHAR(20) CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (user_id, skill_id)
);

CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  price_type VARCHAR(20) DEFAULT 'fixed' CHECK (price_type IN ('fixed', 'hourly')),
  delivery_time INTEGER, -- En jours
  revision_limit INTEGER DEFAULT 1,
  is_featured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  attachments JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table pour les paiements
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE SET NULL,
  payer_id UUID REFERENCES profiles(id),
  payee_id UUID REFERENCES profiles(id),
  amount DECIMAL(10, 2) NOT NULL,
  payment_method VARCHAR(50),
  transaction_id VARCHAR(255),
  status VARCHAR(50) CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  payment_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table pour les notifications
CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(50),
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP WITH TIME ZONE,
  action_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indices pour optimiser les requêtes
CREATE INDEX idx_requests_client_id ON requests (client_id);
CREATE INDEX idx_proposals_expert_id ON proposals (expert_id);
CREATE INDEX idx_contracts_request_id ON contracts (request_id);
CREATE INDEX idx_skills_category_id ON skills (category_id);
CREATE INDEX idx_messages_conversation_id ON messages (conversation_id);
CREATE INDEX idx_messages_sender_receiver ON messages (sender_id, receiver_id);
CREATE INDEX idx_notifications_profile_id ON notifications (profile_id);
CREATE INDEX idx_reviews_reviewee_id ON reviews (reviewee_id);
CREATE INDEX idx_services_expert_id ON services (expert_id);
CREATE INDEX idx_user_skills_user_id ON user_skills (user_id);

-- Modifier la table profiles pour rendre certains champs optionnels
ALTER TABLE profiles ALTER COLUMN phone DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN bio DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN avatar_url DROP NOT NULL;

-- Ajouter un champ pour suivre la complétion du profil
ALTER TABLE profiles ADD COLUMN profile_completion_percentage INTEGER DEFAULT 20;

-- Ajouter une fonction pour calculer automatiquement le pourcentage de complétion du profil
CREATE OR REPLACE FUNCTION update_profile_completion() RETURNS TRIGGER AS $$
DECLARE
  completion INTEGER := 20; -- Valeur de base pour les champs obligatoires
BEGIN
  -- Ajouter des points pour chaque champ complété
  IF NEW.phone IS NOT NULL THEN completion := completion + 10; END IF;
  IF NEW.bio IS NOT NULL AND LENGTH(NEW.bio) > 10 THEN completion := completion + 15; END IF;
  IF NEW.avatar_url IS NOT NULL THEN completion := completion + 15; END IF;
  IF NEW.location IS NOT NULL THEN completion := completion + 10; END IF;
  IF NEW.is_verified = TRUE THEN completion := completion + 10; END IF;
  
  -- Limiter à 100%
  IF completion > 100 THEN completion := 100; END IF;
  
  NEW.profile_completion_percentage := completion;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_profile_completion
BEFORE INSERT OR UPDATE ON profiles
FOR EACH ROW EXECUTE FUNCTION update_profile_completion();