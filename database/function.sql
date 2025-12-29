
-- =========================================================================
-- FONCTIONS UTILITAIRES
-- =========================================================================

-- Fonction pour la navigation dans les catégories
CREATE OR REPLACE FUNCTION get_category_path(category_id UUID)
RETURNS TABLE (
  id UUID,
  name VARCHAR(255),
  level INTEGER
) AS $$
WITH RECURSIVE category_tree AS (
  SELECT c.id, c.name, c.level, ARRAY[c.id] as path
  FROM categories c
  WHERE c.id = category_id

  UNION ALL

  SELECT c.id, c.name, c.level, c.id || ct.path
  FROM categories c
  INNER JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT id, name, level
FROM category_tree
ORDER BY level;
$$ LANGUAGE sql;

-- =========================================================================
-- INDEX POUR LES PERFORMANCES
-- =========================================================================

CREATE INDEX idx_categories_parent ON categories(parent_id);
CREATE INDEX idx_categories_level ON categories(level);
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_provider_services_provider ON provider_services(provider_id);
CREATE INDEX idx_jobs_client ON jobs(client_id);
CREATE INDEX idx_proposals_job ON proposals(job_id);

-- =========================================================================
-- EXEMPLE DE DONNÉES
-- =========================================================================

-- Catégorie principale
INSERT INTO categories (name, slug, description, icon, level) VALUES
('Mécanique', 'mecanique', 'Services de mécanique', 'i-heroicons-wrench', 1);

-- Sous-catégories
WITH meca AS (SELECT id FROM categories WHERE slug = 'mecanique')
INSERT INTO categories (parent_id, name, slug, description, icon, level) VALUES
((SELECT id FROM meca), 'Mécanique Auto', 'mecanique-auto', 'Réparation automobile', 'i-heroicons-truck', 2),
((SELECT id FROM meca), 'Mécanique Moto', 'mecanique-moto', 'Réparation moto', 'i-heroicons-bolt', 2);

-- =========================================================================
-- ACTIVITIES TABLE AND TRACKING SYSTEM
-- =========================================================================

-- Table pour stocker les activités
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  action_type VARCHAR(50) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  entity_id UUID NOT NULL,
  details JSONB,
  ip_location VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour optimiser les performances
CREATE INDEX idx_activities_user_id ON activities(user_id);
CREATE INDEX idx_activities_action_type ON activities(action_type);
CREATE INDEX idx_activities_entity_type ON activities(entity_type);
CREATE INDEX idx_activities_entity_id ON activities(entity_id);
CREATE INDEX idx_activities_created_at ON activities(created_at);

-- Fonction pour enregistrer une activité
CREATE OR REPLACE FUNCTION log_activity(
  p_user_id UUID,
  p_action_type VARCHAR(50),
  p_entity_type VARCHAR(50),
  p_entity_id UUID,
  p_details JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_activity_id UUID;
BEGIN
  -- Vérifier que entity_type est valide
  IF p_entity_type NOT IN ('user', 'provider', 'job', 'proposal', 'service') THEN
    RAISE EXCEPTION 'Type d''entité non valide';
  END IF;

  INSERT INTO activities (
    user_id,
    action_type,
    entity_type,
    entity_id,
    details
  ) VALUES (
    p_user_id,
    p_action_type,
    p_entity_type,
    p_entity_id,
    p_details
  ) RETURNING id INTO v_activity_id;
  
  RETURN v_activity_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour le suivi des modifications des propositions
CREATE OR REPLACE FUNCTION track_proposal_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  -- Déterminer le type d'action
  IF TG_OP = 'INSERT' THEN
    v_action_type := 'create_proposal';
    v_details := jsonb_build_object(
      'job_id', NEW.job_id,
      'provider_id', NEW.provider_id,
      'price', NEW.price,
      'status', NEW.status
    );
    
    -- Enregistrer l'activité
    PERFORM log_activity(
      NEW.provider_id,
      v_action_type,
      'proposal',
      NEW.id,
      v_details
    );
    
    RETURN NEW;
    
  ELSIF TG_OP = 'UPDATE' THEN
    v_action_type := 'update_proposal';
    v_details := jsonb_build_object();
    
    -- Capturer uniquement les champs qui ont changé
    IF NEW.price IS DISTINCT FROM OLD.price THEN
      v_details := v_details || jsonb_build_object('price', NEW.price, 'previous_price', OLD.price);
    END IF;
    
    IF NEW.status IS DISTINCT FROM OLD.status THEN
      v_details := v_details || jsonb_build_object('status', NEW.status, 'previous_status', OLD.status);
      
      -- Définir des types d'action spécifiques pour les changements de statut
      CASE NEW.status
        WHEN 'accepted' THEN v_action_type := 'accept_proposal';
        WHEN 'rejected' THEN v_action_type := 'reject_proposal';
        WHEN 'withdrawn' THEN v_action_type := 'withdraw_proposal';
        ELSE v_action_type := 'update_proposal';
      END CASE;
    END IF;
    
    -- Si aucun champ pertinent n'a changé, retourner sans enregistrer d'activité
    IF v_details = '{}'::JSONB THEN
      RETURN NEW;
    END IF;
    
    -- Enregistrer l'activité
    PERFORM log_activity(
      NEW.provider_id,
      v_action_type,
      'proposal',
      NEW.id,
      v_details
    );
    
    RETURN NEW;
    
  ELSIF TG_OP = 'DELETE' THEN
    v_action_type := 'delete_proposal';
    v_details := jsonb_build_object(
      'job_id', OLD.job_id,
      'provider_id', OLD.provider_id,
      'price', OLD.price,
      'status', OLD.status
    );
    
    -- Enregistrer l'activité
    PERFORM log_activity(
      OLD.provider_id,
      v_action_type,
      'proposal',
      OLD.id,
      v_details
    );
    
    RETURN OLD;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger pour le suivi des propositions
DROP TRIGGER IF EXISTS track_proposal_changes_trigger ON proposals;
CREATE TRIGGER track_proposal_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON proposals
  FOR EACH ROW
  EXECUTE FUNCTION track_proposal_changes();

-- Vues pour l'analyse des activités
CREATE OR REPLACE VIEW recent_activities AS
SELECT 
  a.*,
  u.first_name,
  u.last_name,
  u.email
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE a.created_at > (NOW() - INTERVAL '30 days')
ORDER BY a.created_at DESC;

CREATE OR REPLACE VIEW proposal_activities AS
SELECT 
  a.*,
  p.job_id,
  p.provider_id,
  p.price,
  p.status AS proposal_status
FROM activities a
JOIN proposals p ON a.entity_id = p.id
WHERE a.entity_type = 'proposal'
ORDER BY a.created_at DESC;

-- RLS pour la table activities
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs peuvent voir leurs propres activités
CREATE POLICY "Users can view their own activities"
ON activities FOR SELECT
USING (auth.uid() = user_id);

-- Les administrateurs peuvent tout voir
CREATE POLICY "Admins can view all activities"
ON activities FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid() 
    AND role = 'admin'
  )
);

-- =========================================================================
-- RATING SYSTEM
-- =========================================================================

-- Table pour les évaluations des prestataires
CREATE TABLE  IF NOT EXISTS provider_ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  provider_id UUID REFERENCES provider_profiles(id) ON DELETE CASCADE,
  client_id UUID REFERENCES users(id) ON DELETE CASCADE,
  job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  review TEXT,
  response TEXT,
  response_date TIMESTAMP WITH TIME ZONE,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(provider_id, client_id, job_id)
);

-- Index pour les performances
CREATE INDEX idx_provider_ratings_provider ON provider_ratings(provider_id);
CREATE INDEX idx_provider_ratings_client ON provider_ratings(client_id);
CREATE INDEX idx_provider_ratings_job ON provider_ratings(job_id);
CREATE INDEX idx_provider_ratings_created ON provider_ratings(created_at);

-- Vue pour les statistiques d'évaluation
CREATE OR REPLACE VIEW provider_rating_stats AS
SELECT 
  provider_id,
  COUNT(*) as total_ratings,
  ROUND(AVG(rating)::numeric, 2) as average_rating,
  COUNT(*) FILTER (WHERE rating = 5) as five_star_count,
  COUNT(*) FILTER (WHERE rating = 4) as four_star_count,
  COUNT(*) FILTER (WHERE rating = 3) as three_star_count,
  COUNT(*) FILTER (WHERE rating = 2) as two_star_count,
  COUNT(*) FILTER (WHERE rating = 1) as one_star_count,
  -- COUNT(*) FILTER (WHERE review IS NOT NULL) as review_count
FROM provider_ratings
GROUP BY provider_id;

-- Fonction pour mettre à jour la note moyenne du prestataire
CREATE OR REPLACE FUNCTION update_provider_rating()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    -- Mettre à jour les statistiques après suppression
    UPDATE provider_profiles
    SET 
      rating_average = COALESCE(
        (SELECT ROUND(AVG(rating)::numeric, 2)
         FROM provider_ratings
         WHERE provider_id = OLD.provider_id),
        0
      ),
      total_ratings = COALESCE(
        (SELECT COUNT(*)
         FROM provider_ratings
         WHERE provider_id = OLD.provider_id),
        0
      )
    WHERE id = OLD.provider_id;
    
    RETURN OLD;
  ELSE
    -- Mettre à jour les statistiques après insertion ou mise à jour
    UPDATE provider_profiles
    SET 
      rating_average = COALESCE(
        (SELECT ROUND(AVG(rating)::numeric, 2)
         FROM provider_ratings
         WHERE provider_id = NEW.provider_id),
        0
      ),
      total_ratings = COALESCE(
        (SELECT COUNT(*)
         FROM provider_ratings
         WHERE provider_id = NEW.provider_id),
        0
      )
    WHERE id = NEW.provider_id;
    
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger pour la mise à jour des notes
DROP TRIGGER IF EXISTS update_provider_rating_trigger ON provider_ratings;
CREATE TRIGGER update_provider_rating_trigger
  AFTER INSERT OR UPDATE OR DELETE ON provider_ratings
  FOR EACH ROW
  EXECUTE FUNCTION update_provider_rating();

-- RLS pour les évaluations
ALTER TABLE provider_ratings ENABLE ROW LEVEL SECURITY;

-- Politiques d'accès aux évaluations
CREATE POLICY "Public can view ratings"
  ON provider_ratings FOR SELECT
  USING (TRUE);

CREATE POLICY "Clients can create ratings"
  ON provider_ratings FOR INSERT
  WITH CHECK (
    auth.uid() = client_id
    AND EXISTS (
      SELECT 1 FROM jobs
      WHERE id = job_id
      AND client_id = auth.uid()
      AND status = 'completed'
    )
  );

CREATE POLICY "Clients can update their own ratings"
  ON provider_ratings FOR UPDATE
  USING (auth.uid() = client_id)
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Providers can respond to their ratings"
  ON provider_ratings FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM provider_profiles
      WHERE id = provider_id
      AND user_id = auth.uid()
    )
  )
  WITH CHECK (
    OLD.response IS NULL
    AND NEW.rating = OLD.rating
    AND NEW.review = OLD.review
    AND NEW.client_id = OLD.client_id
    AND NEW.provider_id = OLD.provider_id
    AND NEW.job_id = OLD.job_id
  );

-- Fonction pour vérifier si un client peut évaluer
CREATE OR REPLACE FUNCTION can_rate_provider(
  p_client_id UUID,
  p_provider_id UUID,
  p_job_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM jobs
    WHERE id = p_job_id
    AND client_id = p_client_id
    AND status = 'completed'
    AND NOT EXISTS (
      SELECT 1 FROM provider_ratings
      WHERE provider_id = p_provider_id
      AND client_id = p_client_id
      AND job_id = p_job_id
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =========================================================================
-- IMPORTANT VIEWS FOR ANALYTICS AND REPORTING
-- =========================================================================

-- Vue détaillée des prestataires avec leurs statistiques
CREATE OR REPLACE VIEW provider_detailed_view AS
SELECT 
  p.id,
  u.first_name,
  u.last_name,
  u.email,
  u.phone,
  p.bio,
  p.hourly_rate,
  p.rating_average,
  p.total_jobs,
  COALESCE(rs.total_ratings, 0) as total_ratings,
  COALESCE(rs.five_star_count, 0) as five_star_ratings,
  COALESCE(rs.review_count, 0) as review_count,
  (
    SELECT COUNT(*)
    FROM provider_services ps
    WHERE ps.provider_id = p.id
  ) as services_count,
  (
    SELECT COUNT(*)
    FROM proposals pr
    WHERE pr.provider_id = p.id
    AND pr.status = 'pending'
  ) as active_proposals,
  (
    SELECT COUNT(*)
    FROM jobs j
    WHERE j.id IN (
      SELECT job_id 
      FROM proposals 
      WHERE provider_id = p.id 
      AND status = 'accepted'
    )
    AND j.status = 'in_progress'
  ) as active_jobs,
  p.created_at,
  u.is_verified
FROM provider_profiles p
JOIN users u ON p.user_id = u.id
LEFT JOIN provider_rating_stats rs ON p.id = rs.provider_id;

-- Vue des missions avec statistiques de propositions
CREATE OR REPLACE VIEW job_stats_view AS
SELECT 
  j.*,
  u.first_name as client_first_name,
  u.last_name as client_last_name,
  s.name as service_name,
  c.name as category_name,
  (
    SELECT COUNT(*)
    FROM proposals p
    WHERE p.job_id = j.id
  ) as total_proposals,
  (
    SELECT COUNT(*)
    FROM proposals p
    WHERE p.job_id = j.id
    AND p.status = 'pending'
  ) as pending_proposals,
  (
    SELECT MIN(price)
    FROM proposals p
    WHERE p.job_id = j.id
    AND p.status = 'pending'
  ) as min_proposal_price,
  (
    SELECT MAX(price)
    FROM proposals p
    WHERE p.job_id = j.id
    AND p.status = 'pending'
  ) as max_proposal_price,
  (
    SELECT AVG(price)
    FROM proposals p
    WHERE p.job_id = j.id
    AND p.status = 'pending'
  ) as avg_proposal_price
FROM jobs j
JOIN users u ON j.client_id = u.id
JOIN services s ON j.service_id = s.id
JOIN categories c ON s.category_id = c.id;

-- Vue des propositions détaillées
CREATE OR REPLACE VIEW detailed_proposals_view AS
SELECT 
  p.*,
  j.title as job_title,
  j.status as job_status,
  j.budget as job_budget,
  u.first_name as provider_first_name,
  u.last_name as provider_last_name,
  pp.rating_average as provider_rating,
  pp.total_jobs as provider_completed_jobs,
  c.first_name as client_first_name,
  c.last_name as client_last_name
FROM proposals p
JOIN jobs j ON p.job_id = j.id
JOIN provider_profiles pp ON p.provider_id = pp.id
JOIN users u ON pp.user_id = u.id
JOIN users c ON j.client_id = c.id;

-- Vue des statistiques globales de la plateforme
CREATE OR REPLACE VIEW platform_stats_view AS
SELECT
  (SELECT COUNT(*) FROM users WHERE role = 'client') as total_clients,
  (SELECT COUNT(*) FROM users WHERE role = 'provider') as total_providers,
  (SELECT COUNT(*) FROM jobs) as total_jobs,
  (SELECT COUNT(*) FROM jobs WHERE status = 'open') as open_jobs,
  (SELECT COUNT(*) FROM jobs WHERE status = 'in_progress') as active_jobs,
  (SELECT COUNT(*) FROM jobs WHERE status = 'completed') as completed_jobs,
  (SELECT COUNT(*) FROM proposals) as total_proposals,
  (SELECT AVG(rating_average) FROM provider_profiles WHERE rating_average > 0) as platform_rating,
  (SELECT COUNT(*) FROM provider_ratings) as total_reviews,
  (SELECT COUNT(DISTINCT category_id) FROM services) as total_categories,
  (SELECT COUNT(*) FROM services) as total_services,
  (
    SELECT ROUND(AVG(
      CASE 
        WHEN status = 'completed' 
        THEN EXTRACT(EPOCH FROM (updated_at - created_at))/3600 
      END
    )::numeric, 2)
    FROM jobs 
    WHERE status = 'completed'
  ) as avg_job_completion_hours;

-- Vue des catégories avec statistiques
CREATE OR REPLACE VIEW category_stats_view AS
SELECT 
  c.*,
  (
    SELECT COUNT(*)
    FROM services s
    WHERE s.category_id = c.id
  ) as services_count,
  (
    SELECT COUNT(*)
    FROM jobs j
    JOIN services s ON j.service_id = s.id
    WHERE s.category_id = c.id
  ) as total_jobs,
  (
    SELECT COUNT(*)
    FROM jobs j
    JOIN services s ON j.service_id = s.id
    WHERE s.category_id = c.id
    AND j.status = 'completed'
  ) as completed_jobs,
  (
    SELECT COUNT(DISTINCT p.provider_id)
    FROM provider_services p
    JOIN services s ON p.service_id = s.id
    WHERE s.category_id = c.id
  ) as active_providers,
  (
    SELECT ROUND(AVG(j.budget)::numeric, 2)
    FROM jobs j
    JOIN services s ON j.service_id = s.id
    WHERE s.category_id = c.id
    AND j.status = 'completed'
  ) as avg_job_price
FROM categories c;

-- Vue des activités récentes de la plateforme
CREATE OR REPLACE VIEW recent_platform_activity AS
SELECT 
  a.*,
  CASE 
    WHEN a.entity_type = 'job' THEN (
      SELECT title FROM jobs WHERE id = a.entity_id
    )
    WHEN a.entity_type = 'proposal' THEN (
      SELECT j.title 
      FROM proposals p 
      JOIN jobs j ON p.job_id = j.id 
      WHERE p.id = a.entity_id
    )
    WHEN a.entity_type = 'provider' THEN (
      SELECT CONCAT(u.first_name, ' ', u.last_name)
      FROM provider_profiles pp
      JOIN users u ON pp.user_id = u.id
      WHERE pp.id = a.entity_id
    )
    ELSE NULL
  END as entity_name,
  u.first_name as user_first_name,
  u.last_name as user_last_name,
  u.role as user_role
FROM activities a
JOIN users u ON a.user_id = u.id
WHERE a.created_at > (NOW() - INTERVAL '7 days')
ORDER BY a.created_at DESC;

-- Vue des meilleures catégories par revenu
CREATE OR REPLACE VIEW top_categories_by_revenue AS
SELECT 
  c.id,
  c.name,
  COUNT(DISTINCT j.id) as total_jobs,
  COUNT(DISTINCT j.client_id) as unique_clients,
  COUNT(DISTINCT p.provider_id) as unique_providers,
  ROUND(AVG(j.budget)::numeric, 2) as avg_job_value,
  SUM(j.budget) as total_revenue
FROM categories c
JOIN services s ON s.category_id = c.id
JOIN jobs j ON j.service_id = s.id
LEFT JOIN proposals p ON p.job_id = j.id AND p.status = 'accepted'
WHERE j.status = 'completed'
GROUP BY c.id, c.name
ORDER BY total_revenue DESC;

-- Vue des statistiques des prestataires par période
CREATE OR REPLACE VIEW provider_period_stats AS
WITH monthly_stats AS (
  SELECT 
    pp.id as provider_id,
    DATE_TRUNC('month', j.created_at) as period,
    COUNT(DISTINCT j.id) as jobs_count,
    SUM(j.budget) as total_earnings,
    AVG(pr.rating) as avg_rating,
    COUNT(DISTINCT j.client_id) as unique_clients
  FROM provider_profiles pp
  JOIN proposals p ON p.provider_id = pp.id AND p.status = 'accepted'
  JOIN jobs j ON p.job_id = j.id AND j.status = 'completed'
  LEFT JOIN provider_ratings pr ON pr.provider_id = pp.id 
    AND pr.job_id = j.id
  GROUP BY pp.id, DATE_TRUNC('month', j.created_at)
)
SELECT 
  ms.*,
  u.first_name,
  u.last_name,
  u.email,
  LAG(jobs_count) OVER (PARTITION BY provider_id ORDER BY period) as prev_month_jobs,
  LAG(total_earnings) OVER (PARTITION BY provider_id ORDER BY period) as prev_month_earnings,
  ROUND(
    (total_earnings - LAG(total_earnings) OVER (PARTITION BY provider_id ORDER BY period)) / 
    NULLIF(LAG(total_earnings) OVER (PARTITION BY provider_id ORDER BY period), 0) * 100
  , 2) as earnings_growth
FROM monthly_stats ms
JOIN provider_profiles pp ON ms.provider_id = pp.id
JOIN users u ON pp.user_id = u.id
ORDER BY period DESC, total_earnings DESC; 