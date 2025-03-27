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
  rating DECIMAL(3, 2),
  completed_missions INTEGER DEFAULT 0,
  city VARCHAR(255),
  zip_code VARCHAR(255),
  country VARCHAR(255),
  location TEXT,
  birthdate DATE,
  website VARCHAR(255),
  hourly_rate DECIMAL(10, 2),
  availability_status VARCHAR(20) DEFAULT 'available',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  profile_completion_percentage INTEGER DEFAULT 20
);

-- Categories
CREATE TABLE professions (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Skills linked to professions
CREATE TABLE skills (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT TRUE,
  name VARCHAR(255) NOT NULL UNIQUE,
  profession_id INTEGER REFERENCES professions(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User skills
CREATE TABLE user_skills (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, skill_id)
);

-- Client missions
CREATE TABLE missions (
  id SERIAL PRIMARY KEY,
  client_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  budget DECIMAL(10, 2),
  deadline DATE,
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'completed', 'cancelled')),
  profession_id INTEGER REFERENCES professions(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Combined proposals and contracts into deals
CREATE TABLE deals (
  id SERIAL PRIMARY KEY,
  mission_id INTEGER REFERENCES missions(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  client_id UUID REFERENCES profiles(id),
  price DECIMAL(10, 2) NOT NULL,
  duration INTEGER NOT NULL, -- In days
  message TEXT,
  start_date DATE,
  end_date DATE,
  status VARCHAR(50) DEFAULT 'proposal' CHECK (status IN ('proposal', 'active', 'completed', 'rejected', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(mission_id, expert_id)
);

-- Expert services
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  profession_id INTEGER REFERENCES professions(id),
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
  mission_id INTEGER REFERENCES missions(id) ON DELETE SET NULL,
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

-- Notifications
CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(50),
  action_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payments
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  deal_id INTEGER REFERENCES deals(id) ON DELETE SET NULL,
  payer_id UUID REFERENCES profiles(id),
  payee_id UUID REFERENCES profiles(id),
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled', 'refunded')),
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
CREATE INDEX idx_missions_client_id ON missions(client_id);
CREATE INDEX idx_deals_expert_id ON deals(expert_id);
CREATE INDEX idx_deals_mission_id ON deals(mission_id);
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
CREATE INDEX idx_payments_deal_id ON payments(deal_id);

-- Row Level Security (RLS) policies
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;

-- Users can view their own verification
CREATE POLICY "Users can view their own verification" 
  ON verifications FOR SELECT USING (auth.uid() = user_id);
    
-- Users can create their own verification
CREATE POLICY "Users can create their own verification" 
  ON verifications FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own verification if it's in 'pending' status
CREATE POLICY "Users can update their own pending verification" 
  ON verifications FOR UPDATE USING (auth.uid() = user_id AND status = 'pending')
  WITH CHECK (auth.uid() = user_id AND status = 'pending');
    
-- Admins can manage all verifications
CREATE POLICY "Admins can manage all verifications" 
  ON verifications USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  ));

-- Core triggers and functions for Havoo UI
-- Make sure UUID extension is available
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE TRIGGER set_professions_updated_at
  BEFORE UPDATE ON professions
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_skills_updated_at
  BEFORE UPDATE ON skills
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_missions_updated_at
  BEFORE UPDATE ON missions
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

-- SIMPLIFIED EXPERT VERIFICATION PROCESS
-- This function handles expert verification in a simple way
CREATE OR REPLACE FUNCTION verify_expert()
RETURNS TRIGGER AS $$
BEGIN
  -- If verification is approved, automatically set the user as an expert
  IF NEW.status = 'approved' AND (OLD IS NULL OR OLD.status != 'approved') THEN
    UPDATE profiles 
    SET 
      is_expert = TRUE,
      is_verified = TRUE
    WHERE id = NEW.user_id;
    
    -- Optionally create a notification for the user
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.user_id,
      'Verification Approved',
      'Your expert verification has been approved. You can now offer services and respond to missions.',
      'verification',
      '/account/profile'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER expert_verification_trigger
  AFTER INSERT OR UPDATE ON verifications
  FOR EACH ROW
  EXECUTE FUNCTION verify_expert();

-- Update mission status when deal is activated
CREATE OR REPLACE FUNCTION update_mission_status_on_deal_acceptance()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'active' AND OLD.status = 'proposal' THEN
    UPDATE missions
    SET status = 'assigned'
    WHERE id = NEW.mission_id;
    
    -- Create a notification for the expert
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.expert_id,
      'Proposal Accepted',
      'Your proposal has been accepted. The job is now assigned to you.',
      'deal_accepted',
      '/account/contracts/' || NEW.id
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deal_accepted_trigger
  AFTER UPDATE OF status ON deals
  FOR EACH ROW
  WHEN (NEW.status = 'active' AND OLD.status = 'proposal')
  EXECUTE FUNCTION update_mission_status_on_deal_acceptance();

-- Check for unique deals
CREATE OR REPLACE FUNCTION check_unique_deal()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM deals 
    WHERE mission_id = NEW.mission_id 
    AND expert_id = NEW.expert_id 
    AND id != NEW.id
  ) THEN
    RAISE EXCEPTION 'A proposal already exists for this mission and expert.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_deal_trigger
  BEFORE INSERT ON deals
  FOR EACH ROW
  EXECUTE FUNCTION check_unique_deal();

-- Update expert rating when a review is added
CREATE OR REPLACE FUNCTION update_expert_rating_on_review()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles 
  SET rating = (
    SELECT AVG(rating)::numeric(3,2)
    FROM reviews 
    WHERE reviewee_id = NEW.reviewee_id
  )
  WHERE id = NEW.reviewee_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER expert_rating_update_trigger
  AFTER INSERT OR UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_expert_rating_on_review();

-- Create notification when a new deal is proposed
CREATE OR REPLACE FUNCTION create_notification_on_deal_proposal()
RETURNS TRIGGER AS $$
DECLARE
  mission_title TEXT;
  client_id UUID;
BEGIN
  -- Get mission info
  SELECT title, client_id INTO mission_title, client_id
  FROM missions
  WHERE id = NEW.mission_id;
  
  -- Create notification
  INSERT INTO notifications (
    profile_id, 
    title, 
    content, 
    type, 
    action_url
  ) VALUES (
    client_id, 
    'New proposal', 
    'An expert has made a proposal for your mission "' || mission_title || '"',
    'proposal',
    '/requests/' || NEW.mission_id
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deal_proposal_notification_trigger
  AFTER INSERT ON deals
  FOR EACH ROW
  WHEN (NEW.status = 'proposal')
  EXECUTE FUNCTION create_notification_on_deal_proposal();

-- Update expert completed missions count
CREATE OR REPLACE FUNCTION update_expert_completed_missions()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status <> 'completed' THEN
    -- Update completed_missions counter
    UPDATE profiles
    SET completed_missions = COALESCE(completed_missions, 0) + 1
    WHERE id = NEW.expert_id;
    
    -- Setup for ratings - add default values to enable ratings
    UPDATE deals
    SET 
      client_has_rated = FALSE,
      expert_has_rated = FALSE,
      ratings_complete = FALSE
    WHERE id = NEW.id;
    
    -- Notify both parties
    -- Notify expert
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.expert_id,
      'Contract Completed',
      'A contract has been marked as completed. Please rate your experience.',
      'contract_completed',
      '/account/contracts/' || NEW.id || '/rate'
    );
    
    -- Notify client
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.client_id,
      'Contract Completed',
      'You have marked a contract as completed. Please rate your experience with the expert.',
      'contract_completed',
      '/account/contracts/' || NEW.id || '/rate'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deal_completion_trigger
  AFTER UPDATE OF status ON deals
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status <> 'completed')
  EXECUTE FUNCTION update_expert_completed_missions();

-- Check for approaching deadlines
CREATE OR REPLACE FUNCTION check_approaching_deadlines()
RETURNS TRIGGER AS $$
BEGIN
  -- Create notification for deals approaching their deadline
  IF NEW.end_date IS NOT NULL AND NEW.end_date - CURRENT_DATE <= 3 AND NEW.status = 'active' THEN
    -- Notification for the expert
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.expert_id, 
      'Approaching deadline', 
      'A contract is approaching its deadline in 3 days or less',
      'deadline',
      '/account/contracts/' || NEW.id
    );
    
    -- Notification for the client
    INSERT INTO notifications (
      profile_id, 
      title, 
      content, 
      type, 
      action_url
    ) VALUES (
      NEW.client_id, 
      'Approaching deadline', 
      'One of your contracts is approaching its deadline in 3 days or less',
      'deadline',
      '/account/contracts/' || NEW.id
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deadline_notification_trigger
  AFTER INSERT OR UPDATE OF end_date ON deals
  FOR EACH ROW
  EXECUTE FUNCTION check_approaching_deadlines();

-- Update conversation last message
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

CREATE TRIGGER trigger_update_conversation_last_message
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();

-- Search function for experts
CREATE OR REPLACE FUNCTION search_experts(
  search_term TEXT DEFAULT NULL,
  profession_id_filter UUID DEFAULT NULL,
  skill_ids_filter UUID[] DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  first_name VARCHAR,
  last_name VARCHAR,
  bio TEXT,
  avatar_url TEXT,
  rating DECIMAL,
  completed_missions INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.first_name,
    p.last_name,
    p.bio,
    p.avatar_url,
    p.rating,
    p.completed_missions
  FROM profiles p
  WHERE p.is_expert = TRUE
    AND (search_term IS NULL OR
      p.first_name ILIKE '%' || search_term || '%' OR
      p.last_name ILIKE '%' || search_term || '%' OR
      p.bio ILIKE '%' || search_term || '%')
    AND (profession_id_filter IS NULL OR EXISTS (
      SELECT 1
      FROM skills s
      WHERE s.profession_id = profession_id_filter
        AND EXISTS (
          SELECT 1
          FROM user_skills us
          WHERE us.user_id = p.id
            AND us.skill_id = s.id
        )
    ))
    AND (skill_ids_filter IS NULL OR EXISTS (
      SELECT 1
      FROM user_skills us
      WHERE us.user_id = p.id
        AND us.skill_id = ANY(skill_ids_filter)
    ));
END;
$$ LANGUAGE plpgsql;

-- Search function for services
CREATE OR REPLACE FUNCTION search_services(
  search_term TEXT DEFAULT NULL,
  profession_id_filter UUID DEFAULT NULL,
  skill_ids_filter UUID[] DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  title VARCHAR,
  description TEXT,
  price DECIMAL,
  expert_id UUID,
  expert_name VARCHAR,
  expert_rating DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.title,
    s.description,
    s.price,
    s.expert_id,
    (p.first_name || ' ' || p.last_name) AS expert_name,
    p.rating
  FROM services s
  JOIN profiles p ON s.expert_id = p.id
  WHERE s.is_active = TRUE
    AND (search_term IS NULL OR
      s.title ILIKE '%' || search_term || '%' OR
      s.description ILIKE '%' || search_term || '%')
    AND (profession_id_filter IS NULL OR s.profession_id = profession_id_filter)
    AND (skill_ids_filter IS NULL OR EXISTS (
      SELECT 1
      FROM service_skills ss
      WHERE ss.service_id = s.id
        AND ss.skill_id = ANY(skill_ids_filter)
    ));
END;
$$ LANGUAGE plpgsql;

-- Function to mark a contract as completed (simplified)
CREATE OR REPLACE FUNCTION complete_contract(
  p_contract_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_deal RECORD;
  v_is_client BOOLEAN;
BEGIN
  -- Get deal info
  SELECT * INTO v_deal FROM deals 
  WHERE id = p_contract_id;
  
  IF v_deal IS NULL THEN
    RAISE EXCEPTION 'Contract not found';
  END IF;
  
  -- Check if user is the client for this deal
  v_is_client := (v_deal.client_id = p_user_id);
  
  -- Only client can mark contract as completed
  IF NOT v_is_client THEN
    RAISE EXCEPTION 'Only the client can mark a contract as completed';
  END IF;
  
  -- Mark as completed
  UPDATE deals
  SET 
    status = 'completed',
    updated_at = NOW()
  WHERE id = p_contract_id;
  
  -- The deal_completion_trigger will handle notifications and setup for ratings
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;