-- Core tables

-- User profiles
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
  role VARCHAR(20) DEFAULT 'client' NOT NULL, -- 'client' or 'expert'
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

-- Categories
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Skills linked to categories
CREATE TABLE skills (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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

-- Combined proposals and contracts into deals
CREATE TABLE deals (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  client_id UUID REFERENCES profiles(id),
  price DECIMAL(10, 2) NOT NULL,
  duration INTEGER NOT NULL, -- In days
  message TEXT,
  status VARCHAR(50) DEFAULT 'proposal' CHECK (status IN ('proposal', 'active', 'completed', 'rejected', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(request_id, expert_id)
);

-- Expert services
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES categories(id),
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  delivery_time INTEGER, -- In days
  is_active BOOLEAN DEFAULT TRUE,
  location_type VARCHAR(20) DEFAULT 'remote' CHECK (location_type IN ('remote', 'onsite', 'hybrid')),
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
  deal_id INTEGER REFERENCES deals(id) ON DELETE CASCADE,
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
  deal_id INTEGER REFERENCES deals(id) ON DELETE SET NULL,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
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

-- Simplified verification
CREATE TABLE verifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  documents JSONB, -- Stores document URLs in JSON format
  rejection_reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_by UUID REFERENCES profiles(id),
  reviewed_at TIMESTAMP WITH TIME ZONE
);

-- Indices for performance optimization
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

-- Row Level Security (RLS) policies
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own verification" 
  ON verifications FOR SELECT USING (auth.uid() = user_id);
    
CREATE POLICY "Users can create their own verification" 
  ON verifications FOR INSERT WITH CHECK (auth.uid() = user_id);
    
CREATE POLICY "Admins can manage all verifications" 
  ON verifications USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  ));

-- Triggers for automatic updates
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the update timestamp trigger to all relevant tables
CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_verifications_updated_at
  BEFORE UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Simplified profile completion calculation
CREATE OR REPLACE FUNCTION calculate_profile_completion()
RETURNS TRIGGER AS $$
DECLARE
  completed_fields INTEGER := 1; -- Start with 1 for required fields
  total_fields INTEGER := 5; -- Total number of profile completion fields
BEGIN
  -- Count completed optional fields
  IF NEW.phone IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.bio IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.avatar_url IS NOT NULL THEN completed_fields := completed_fields + 1; END IF;
  IF NEW.is_expert = TRUE THEN completed_fields := completed_fields + 1; END IF;
  
  -- Calculate percentage
  NEW.profile_completion_percentage := (completed_fields::FLOAT / total_fields::FLOAT * 100)::INTEGER;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_profile_completion_trigger
  BEFORE INSERT OR UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION calculate_profile_completion();

-- Expert status update on verification approval
CREATE OR REPLACE FUNCTION update_expert_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE profiles SET is_expert = true WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_expert_status_on_verification
  AFTER UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION update_expert_status();



  CREATE TABLE settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key TEXT NOT NULL UNIQUE,
  value JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Politiques RLS pour la sécurité
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Seuls les admins peuvent lire/modifier les paramètres
CREATE POLICY "Les admins peuvent tout faire" ON settings
  USING (auth.uid() IN (SELECT id FROM profiles WHERE role = 'admin'))
  WITH CHECK (auth.uid() IN (SELECT id FROM profiles WHERE role = 'admin'));

-- Index pour accélérer les recherches par clé
CREATE INDEX settings_key_idx ON settings (key);

-- Trigger pour mettre à jour le champ updated_at
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON settings
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at_timestamp();