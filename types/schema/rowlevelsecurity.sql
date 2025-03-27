-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Requests policy examples
CREATE POLICY "Requests are viewable by everyone"
  ON missions FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own missions"
  ON missions FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Users can update own missions"
  ON missions FOR UPDATE
  USING (auth.uid() = client_id);

-- Activer RLS sur la table expert_verifications
ALTER TABLE expert_verifications ENABLE ROW LEVEL SECURITY;

-- Politique pour les utilisateurs réguliers (peuvent voir uniquement leurs propres vérifications)
CREATE POLICY "Users can view their own verification" 
ON expert_verifications FOR SELECT
USING (auth.uid() = user_id);

-- Politique pour les utilisateurs réguliers (peuvent insérer leurs propres vérifications)
CREATE POLICY "Users can insert their own verification" 
ON expert_verifications FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Politique pour les administrateurs (peuvent tout voir et tout modifier)
CREATE POLICY "Admins can do everything" 
ON expert_verifications
USING (EXISTS (
  SELECT 1 FROM profiles 
  WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
));

-- Demandes publiques: permettre à tous de voir uniquement les demandes ouvertes
CREATE POLICY "Demandes ouvertes visibles par tous" 
ON missions FOR SELECT
USING (status = 'open');

-- Profils publics: les profils experts vérifiés sont visibles par tous
CREATE POLICY "Profils experts vérifiés visibles par tous" 
ON profiles FOR SELECT
USING (is_expert = true AND is_verified = true);

-- Compétences et catégories: visibles par tous
CREATE POLICY "Compétences visibles par tous" 
ON skills FOR SELECT
USING (true);

-- Association compétences-utilisateurs: visible uniquement pour les experts vérifiés
CREATE POLICY "Compétences des experts vérifiées visibles par tous" 
ON user_skills FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE profiles.id = user_skills.user_id 
    AND profiles.is_expert = true 
    AND profiles.is_verified = true
  )
);

-- Les propositions ne sont pas visibles publiquement, seulement le nombre pour les demandes
CREATE POLICY "Comptage des propositions visible par tous" 
ON proposals FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM missions 
    WHERE missions.id = proposals.mission_id 
    AND missions.status = 'open'
  )
);




-- Enable RLS
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;

-- Policies for conversations
CREATE POLICY "Users can view conversations they are in" ON conversations
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM conversation_participants
      WHERE conversation_id = conversations.id
      AND profile_id = auth.uid()
    )
  );

-- Policies for messages
CREATE POLICY "Users can view messages in their conversations" ON messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM conversation_participants
      WHERE conversation_id = messages.conversation_id
      AND profile_id = auth.uid()
    )
  );