-- Ajout de contraintes nommées explicitement pour clarifier les relations
-- Cela permettra de spécifier précisément la relation à utiliser lors des requêtes

-- D'abord, supprimer les contraintes existantes
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_reviewer_id_fkey;
ALTER TABLE reviews DROP CONSTRAINT IF EXISTS reviews_reviewee_id_fkey;

-- Puis ajouter des contraintes avec des noms explicites
ALTER TABLE reviews 
  ADD CONSTRAINT reviews_reviewer_id_fkey 
  FOREIGN KEY (reviewer_id) 
  REFERENCES profiles(id) ON DELETE CASCADE;

ALTER TABLE reviews 
  ADD CONSTRAINT reviews_reviewee_id_fkey 
  FOREIGN KEY (reviewee_id) 
  REFERENCES profiles(id) ON DELETE CASCADE;

-- Créer des vues pour simplifier les requêtes
CREATE OR REPLACE VIEW reviews_as_reviewer AS
  SELECT 
    r.*,
    p.first_name as reviewee_first_name,
    p.last_name as reviewee_last_name,
    p.avatar_url as reviewee_avatar_url
  FROM reviews r
  JOIN profiles p ON r.reviewee_id = p.id;

CREATE OR REPLACE VIEW reviews_as_reviewee AS
  SELECT 
    r.*,
    p.first_name as reviewer_first_name,
    p.last_name as reviewer_last_name,
    p.avatar_url as reviewer_avatar_url
  FROM reviews r
  JOIN profiles p ON r.reviewer_id = p.id;

-- Fonction pour obtenir les avis reçus par un utilisateur
CREATE OR REPLACE FUNCTION get_user_received_reviews(user_id UUID)
RETURNS TABLE (
  id INTEGER,
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMPTZ,
  reviewer_id UUID,
  reviewer_first_name VARCHAR,
  reviewer_last_name VARCHAR,
  reviewer_avatar_url TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.id, 
    r.rating, 
    r.comment, 
    r.created_at,
    p.id as reviewer_id,
    p.first_name as reviewer_first_name,
    p.last_name as reviewer_last_name,
    p.avatar_url as reviewer_avatar_url
  FROM reviews r
  JOIN profiles p ON r.reviewer_id = p.id
  WHERE r.reviewee_id = user_id
  ORDER BY r.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour obtenir les avis donnés par un utilisateur
CREATE OR REPLACE FUNCTION get_user_given_reviews(user_id UUID)
RETURNS TABLE (
  id INTEGER,
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMPTZ,
  reviewee_id UUID,
  reviewee_first_name VARCHAR,
  reviewee_last_name VARCHAR,
  reviewee_avatar_url TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    r.id, 
    r.rating, 
    r.comment, 
    r.created_at,
    p.id as reviewee_id,
    p.first_name as reviewee_first_name,
    p.last_name as reviewee_last_name,
    p.avatar_url as reviewee_avatar_url
  FROM reviews r
  JOIN profiles p ON r.reviewee_id = p.id
  WHERE r.reviewer_id = user_id
  ORDER BY r.created_at DESC;
END;
$$ LANGUAGE plpgsql; 