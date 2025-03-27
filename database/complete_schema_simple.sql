-- Supprimer les éléments s'ils existent
-- DROP TRIGGER IF EXISTS set_notifications_updated_at ON notifications;
-- DROP POLICY IF EXISTS "Users can view their own notifications" ON notifications;
-- DROP POLICY IF EXISTS "Users can mark their notifications as read" ON notifications;
-- DROP TABLE IF EXISTS notifications;

-- Mettre à jour la fonction update_expert_status_simple sans notifications
CREATE OR REPLACE FUNCTION update_expert_status_simple()
RETURNS TRIGGER AS $$
BEGIN
  -- Pour le MVP, on permet simplement de définir is_expert directement
  -- Sans notifications
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Mettre à jour la fonction complete_contract sans notifications
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
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Schéma MVP final
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE professions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- Tables principales
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  profession_id UUID REFERENCES professions(id) ON DELETE SET NULL,
  avatar_url TEXT,
  is_expert BOOLEAN DEFAULT FALSE,
  role VARCHAR(20) DEFAULT 'client' NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);



CREATE TABLE skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  profession_id UUID REFERENCES professions(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE user_skills (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, skill_id)
);

CREATE TABLE missions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget DECIMAL(10, 2),
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'completed')),
  profession_id UUID REFERENCES professions(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE deals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mission_id UUID REFERENCES missions(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  client_id UUID REFERENCES profiles(id),
  price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'proposal' CHECK (status IN ('proposal', 'active', 'completed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mission_id UUID REFERENCES missions(id) ON DELETE SET NULL,
  deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index essentiels
CREATE INDEX idx_missions_client_id ON missions(client_id);
CREATE INDEX idx_missions_profession_id ON missions(profession_id);
CREATE INDEX idx_deals_mission_id ON deals(mission_id);
CREATE INDEX idx_deals_expert_id ON deals(expert_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);