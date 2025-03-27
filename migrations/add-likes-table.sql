-- Création de la table des likes pour les demandes
CREATE TABLE mission_likes (
  id SERIAL PRIMARY KEY,
  mission_id INTEGER REFERENCES missions(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Contrainte d'unicité pour éviter les doublons
  UNIQUE(mission_id, user_id)
);

-- Index pour améliorer les performances des requêtes
CREATE INDEX idx_mission_likes_mission_id ON mission_likes(mission_id);
CREATE INDEX idx_mission_likes_user_id ON mission_likes(user_id);

-- Politique RLS pour les likes
-- Tout le monde peut voir les likes
CREATE POLICY "Anyone can view mission likes" 
    ON mission_likes 
    FOR SELECT 
    USING (true);

-- Les utilisateurs authentifiés peuvent ajouter des likes
CREATE POLICY "Authenticated users can add likes" 
    ON mission_likes 
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Les utilisateurs peuvent supprimer uniquement leurs propres likes
CREATE POLICY "Users can delete their own likes" 
    ON mission_likes 
    FOR DELETE 
    USING (auth.uid() = user_id);

-- Activer RLS sur la table
ALTER TABLE mission_likes ENABLE ROW LEVEL SECURITY;

-- Fonction pour compter les likes d'une demande
CREATE OR REPLACE FUNCTION get_mission_likes_count(mission_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) 
    FROM mission_likes 
    WHERE mission_likes.mission_id = $1
  );
END;
$$ LANGUAGE plpgsql;

-- Fonction pour vérifier si un utilisateur a liké une demande
CREATE OR REPLACE FUNCTION has_user_liked_mission(mission_id INTEGER, user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM mission_likes 
    WHERE mission_likes.mission_id = $1 
    AND mission_likes.user_id = $2
  );
END;
$$ LANGUAGE plpgsql; 