-- Création de la table des likes pour les demandes
CREATE TABLE request_likes (
  id SERIAL PRIMARY KEY,
  request_id INTEGER REFERENCES requests(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Contrainte d'unicité pour éviter les doublons
  UNIQUE(request_id, user_id)
);

-- Index pour améliorer les performances des requêtes
CREATE INDEX idx_request_likes_request_id ON request_likes(request_id);
CREATE INDEX idx_request_likes_user_id ON request_likes(user_id);

-- Politique RLS pour les likes
-- Tout le monde peut voir les likes
CREATE POLICY "Anyone can view request likes" 
    ON request_likes 
    FOR SELECT 
    USING (true);

-- Les utilisateurs authentifiés peuvent ajouter des likes
CREATE POLICY "Authenticated users can add likes" 
    ON request_likes 
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- Les utilisateurs peuvent supprimer uniquement leurs propres likes
CREATE POLICY "Users can delete their own likes" 
    ON request_likes 
    FOR DELETE 
    USING (auth.uid() = user_id);

-- Activer RLS sur la table
ALTER TABLE request_likes ENABLE ROW LEVEL SECURITY;

-- Fonction pour compter les likes d'une demande
CREATE OR REPLACE FUNCTION get_request_likes_count(request_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) 
    FROM request_likes 
    WHERE request_likes.request_id = $1
  );
END;
$$ LANGUAGE plpgsql;

-- Fonction pour vérifier si un utilisateur a liké une demande
CREATE OR REPLACE FUNCTION has_user_liked_request(request_id INTEGER, user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM request_likes 
    WHERE request_likes.request_id = $1 
    AND request_likes.user_id = $2
  );
END;
$$ LANGUAGE plpgsql; 