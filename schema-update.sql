-- Ajouter la colonne avatar_url
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- Ajouter la colonne role si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS role VARCHAR(20) DEFAULT 'user' NOT NULL;

-- Ajouter la colonne zip_code si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS zip_code VARCHAR(20);

-- Ajouter la colonne updated_at si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();

-- Ajouter les colonnes pour la vérification des experts
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS verification_status VARCHAR(20) DEFAULT 'pending';
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS verification_notes TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS id_front TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS id_back TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS proof_address TEXT;

-- Créer une table pour les certifications
CREATE TABLE IF NOT EXISTS expert_certifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  expert_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  file_url TEXT NOT NULL,
  issue_date DATE,
  expiry_date DATE,
  issuing_authority VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_expert_certifications_updated_at
  BEFORE UPDATE ON expert_certifications
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Ajouter les colonnes pour la résolution des demandes
ALTER TABLE requests ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;
ALTER TABLE requests ADD COLUMN IF NOT EXISTS rating INTEGER CHECK (rating >= 1 AND rating <= 5);
ALTER TABLE requests ADD COLUMN IF NOT EXISTS review TEXT;

-- Ajouter les colonnes pour les notes des experts
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS rating DECIMAL(3,2);
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS reviews_count INTEGER DEFAULT 0;

-- Mettre à jour la table requests pour les nouvelles fonctionnalités de résolution
ALTER TABLE requests 
  ADD COLUMN IF NOT EXISTS photos JSONB,
  ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT true,
  ADD COLUMN IF NOT EXISTS resolution_notes TEXT,
  ADD COLUMN IF NOT EXISTS resolution_date TIMESTAMPTZ;

-- Créer une table dédiée pour les avis
CREATE TABLE IF NOT EXISTS reviews (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  request_id UUID REFERENCES requests(id) ON DELETE CASCADE,
  expert_id UUID REFERENCES profiles(id),
  client_id UUID REFERENCES profiles(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  photos JSONB,
  is_public BOOLEAN DEFAULT true,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ajouter un index pour les recherches fréquentes
CREATE INDEX IF NOT EXISTS idx_reviews_expert_id ON reviews(expert_id);
CREATE INDEX IF NOT EXISTS idx_reviews_request_id ON reviews(request_id);
CREATE INDEX IF NOT EXISTS idx_public_reviews ON reviews(is_public) WHERE is_public = true;

-- Créer une table pour les réactions aux avis
CREATE TABLE IF NOT EXISTS review_reactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  review_id UUID REFERENCES reviews(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  reaction_type VARCHAR(20) CHECK (reaction_type IN ('helpful', 'not_helpful', 'report')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(review_id, user_id, reaction_type)
);

-- Créer une table pour les réponses aux avis
CREATE TABLE IF NOT EXISTS review_responses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  review_id UUID REFERENCES reviews(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Trigger pour mettre à jour les statistiques de l'expert
CREATE OR REPLACE FUNCTION update_expert_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- Mettre à jour les statistiques de l'expert
    UPDATE profiles
    SET 
      reviews_count = reviews_count + 1,
      rating = (
        (COALESCE(rating, 0) * COALESCE(reviews_count, 0) + NEW.rating) / 
        (COALESCE(reviews_count, 0) + 1)
      )::DECIMAL(3,2)
    WHERE id = NEW.expert_id;
  ELSIF TG_OP = 'DELETE' THEN
    -- Recalculer la moyenne si un avis est supprimé
    UPDATE profiles
    SET 
      reviews_count = reviews_count - 1,
      rating = (
        CASE 
          WHEN reviews_count - 1 = 0 THEN NULL
          ELSE (
            (COALESCE(rating, 0) * COALESCE(reviews_count, 0) - OLD.rating) / 
            (COALESCE(reviews_count, 0) - 1)
          )::DECIMAL(3,2)
        END
      )
    WHERE id = OLD.expert_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Créer les triggers pour la mise à jour automatique
CREATE TRIGGER after_review_insert
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_expert_stats();

CREATE TRIGGER after_review_delete
  AFTER DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_expert_stats();

-- Trigger pour updated_at
CREATE TRIGGER update_review_responses_updated_at
  BEFORE UPDATE ON review_responses
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Ajouter des politiques de sécurité Row Level Security (RLS)
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_responses ENABLE ROW LEVEL SECURITY;

-- Politiques pour les avis
CREATE POLICY "Les avis publics sont visibles par tous"
  ON reviews FOR SELECT
  USING (is_public = true);

CREATE POLICY "Les utilisateurs peuvent voir leurs propres avis"
  ON reviews FOR SELECT
  USING (client_id = auth.uid() OR expert_id = auth.uid());

CREATE POLICY "Les clients peuvent créer des avis pour leurs demandes"
  ON reviews FOR INSERT
  WITH CHECK (client_id = auth.uid());

-- Politiques pour les réactions
CREATE POLICY "Les utilisateurs peuvent réagir aux avis publics"
  ON review_reactions FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM reviews 
      WHERE id = review_id 
      AND is_public = true
    )
  );

-- Politiques pour les réponses
CREATE POLICY "Les experts peuvent répondre à leurs avis"
  ON review_responses FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM reviews 
      WHERE id = review_id 
      AND expert_id = auth.uid()
    )
  );