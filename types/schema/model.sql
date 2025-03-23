-- Core user profiles
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50),
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  is_admin BOOLEAN DEFAULT FALSE,

  bio TEXT,
  avatar_url TEXT,
  role VARCHAR(20) DEFAULT 'client' NOT NULL, -- 'client' or 'expert'
  is_expert BOOLEAN DEFAULT FALSE,
  city VARCHAR(255),
  zip_code VARCHAR(255),
  country VARCHAR(255),
  address TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  profile_completion_percentage INTEGER DEFAULT 20
);

-- Simple categories
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

-- Skills linked to categories
CREATE TABLE skills (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL
);

-- User skills
CREATE TABLE user_skills (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, skill_id)
);

-- Client requests
CREATE TABLE requests (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget DECIMAL(10, 2),
  deadline DATE,
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'completed', 'cancelled')),
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Expert proposals
CREATE TABLE proposals (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  price DECIMAL(10, 2) NOT NULL,
  duration INTEGER NOT NULL, -- In days
  message TEXT NOT NULL,
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(request_id, expert_id),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Contracts
CREATE TABLE contracts (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id),
  proposal_id INTEGER REFERENCES proposals(id),
  client_id UUID REFERENCES profiles(id),
  expert_id UUID REFERENCES profiles(id),
  title VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Expert services
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  delivery_time INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  location_type VARCHAR(255),
  location_latitude DECIMAL(10, 8),
  location_longitude DECIMAL(11, 8),

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service skills
CREATE TABLE service_skills (
  service_id INTEGER REFERENCES services(id) ON DELETE CASCADE,
  skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (service_id, skill_id)
);

-- Reviews
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE CASCADE,
  reviewer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  reviewee_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversations
CREATE TABLE conversations (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id) ON DELETE SET NULL,
  contract_id INTEGER REFERENCES contracts(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversation participants
CREATE TABLE conversation_participants (
  conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  PRIMARY KEY (conversation_id, profile_id)
);

-- Messages
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table pour les vérifications d'identité des experts
CREATE TABLE verifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    id_document_url TEXT,
    selfie_url TEXT,
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    reviewed_by UUID REFERENCES profiles(id),
    reviewed_at TIMESTAMP WITH TIME ZONE
);
ALTER TABLE conversations 
ADD COLUMN last_message TEXT,
ADD COLUMN last_message_at TIMESTAMP WITH TIME ZONE;

CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
CREATE INDEX idx_conversations_last_message_at ON conversations(last_message_at);

-- Index pour accélérer les recherches par user_id
CREATE INDEX idx_verifications_user_id ON verifications(user_id);

-- Index pour filtrer par statut
CREATE INDEX idx_verifications_status ON verifications(status);

-- Politique RLS pour les vérifications
-- Les utilisateurs peuvent voir uniquement leur propre vérification
CREATE POLICY "Users can view their own verification" 
    ON verifications 
    FOR SELECT 
    USING (auth.uid() = user_id);

-- Les utilisateurs peuvent créer leur propre vérification
CREATE POLICY "Users can create their own verification" 
    ON verifications 
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Les utilisateurs peuvent mettre à jour uniquement leur propre vérification
CREATE POLICY "Users can update their own verification" 
    ON verifications 
    FOR UPDATE 
    USING (auth.uid() = user_id);
ALTER TABLE profiles ADD COLUMN is_admin BOOLEAN DEFAULT FALSE;

-- Seuls les administrateurs peuvent approuver/rejeter les vérifications
CREATE POLICY "Admins can manage all verifications" 
    ON verifications 
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- Activer RLS sur la table
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;
-- Trigger pour mettre à jour le champ updated_at
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON verifications
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();

-- Trigger pour mettre à jour le statut expert dans profiles
CREATE OR REPLACE FUNCTION update_expert_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
        UPDATE profiles
        SET is_expert = true
        WHERE id = NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_expert_status_on_verification
AFTER UPDATE ON verifications
FOR EACH ROW
EXECUTE FUNCTION update_expert_status();

-- Basic indices for performance
CREATE INDEX idx_requests_client_id ON requests (client_id);
CREATE INDEX idx_proposals_expert_id ON proposals (expert_id);
CREATE INDEX idx_contracts_request_id ON contracts (request_id);
CREATE INDEX idx_services_expert_id ON services (expert_id);
CREATE INDEX idx_user_skills_user_id ON user_skills (user_id);
CREATE INDEX idx_messages_conversation_id ON messages (conversation_id);

-- Function to calculate profile completion percentage
CREATE OR REPLACE FUNCTION update_profile_completion() RETURNS TRIGGER AS $$
BEGIN
  -- Start with base value for required fields
  NEW.profile_completion_percentage := 20;
  
  -- Add percentage points for each completed optional field
  IF NEW.phone IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 20;
  END IF;
  
  IF NEW.bio IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 20;
  END IF;
  
  IF NEW.avatar_url IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 20;
  END IF;
  
  IF NEW.is_expert = TRUE THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 20;
  END IF;
  
  -- Ensure percentage doesn't exceed 100%
  IF NEW.profile_completion_percentage > 100 THEN 
    NEW.profile_completion_percentage := 100;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update profile completion
CREATE TRIGGER trigger_update_profile_completion
BEFORE INSERT OR UPDATE ON profiles
FOR EACH ROW EXECUTE FUNCTION update_profile_completion();