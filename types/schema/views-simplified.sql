-- =============================================
-- VIEWS POUR LA RECHERCHE D'EXPERTS
-- =============================================

-- Vue complète des profils d'experts avec toutes les informations pertinentes
CREATE OR REPLACE VIEW expert_search_view AS
SELECT 
  p.id,
  p.first_name,
  p.last_name,
  p.first_name || ' ' || p.last_name AS full_name, -- Pour faciliter la recherche par nom
  p.bio,
  p.avatar_url,
  p.location,
  p.profile_completion_percentage,
  p.created_at,
  COALESCE(AVG(r.rating), 0) AS average_rating,
  COUNT(DISTINCT r.id) AS review_count,
  COUNT(DISTINCT s.id) AS service_count,
  array_agg(DISTINCT sk.name) FILTER (WHERE sk.name IS NOT NULL) AS skills,
  array_agg(DISTINCT c.name) FILTER (WHERE c.name IS NOT NULL) AS categories,
  -- Pour la recherche full-text
  to_tsvector('french', 
    p.first_name || ' ' || 
    p.last_name || ' ' || 
    COALESCE(p.bio, '') || ' ' || 
    COALESCE(array_to_string(array_agg(DISTINCT sk.name) FILTER (WHERE sk.name IS NOT NULL), ' '), '')
  ) AS search_document
FROM profiles p
LEFT JOIN user_skills us ON p.id = us.user_id
LEFT JOIN skills sk ON us.skill_id = sk.id
LEFT JOIN services s ON p.id = s.expert_id
LEFT JOIN categories c ON s.category_id = c.id
LEFT JOIN deals d ON p.id = d.expert_id
LEFT JOIN reviews r ON d.id = r.deal_id AND p.id = r.reviewee_id
WHERE p.is_expert = TRUE
GROUP BY p.id;

-- Vue pour les services avec recherche
CREATE OR REPLACE VIEW service_search_view AS
SELECT 
  s.id,
  s.title,
  s.description,
  s.price,
  s.delivery_time,
  s.is_active,
  s.location,
  s.created_at,
  c.id AS category_id,
  c.name AS category_name,
  p.id AS expert_id,
  p.first_name || ' ' || p.last_name AS expert_name,
  p.avatar_url AS expert_avatar,
  COALESCE(AVG(r.rating), 0) AS expert_rating,
  array_agg(DISTINCT sk.name) FILTER (WHERE sk.name IS NOT NULL) AS skills,
  to_tsvector('french', 
    s.title || ' ' || 
    s.description || ' ' || 
    c.name || ' ' || 
    p.first_name || ' ' || 
    p.last_name || ' ' || 
    COALESCE(array_to_string(array_agg(DISTINCT sk.name) FILTER (WHERE sk.name IS NOT NULL), ' '), '')
  ) AS search_document
FROM services s
JOIN profiles p ON s.expert_id = p.id
LEFT JOIN categories c ON s.category_id = c.id
LEFT JOIN service_skills ss ON s.id = ss.service_id
LEFT JOIN skills sk ON ss.skill_id = sk.id
LEFT JOIN deals d ON p.id = d.expert_id
LEFT JOIN reviews r ON d.id = r.deal_id AND p.id = r.reviewee_id
WHERE s.is_active = TRUE
GROUP BY s.id, c.id, c.name, p.id, p.first_name, p.last_name, p.avatar_url;

-- Vue pour les demandes avec recherche
CREATE OR REPLACE VIEW request_search_view AS
SELECT 
  r.id,
  r.title,
  r.description,
  r.budget,
  r.deadline,
  r.status,
  r.created_at,
  c.id AS category_id,
  c.name AS category_name,
  p.id AS client_id,
  p.first_name || ' ' || p.last_name AS client_name,
  p.avatar_url AS client_avatar,
  COUNT(d.id) FILTER (WHERE d.status = 'proposal') AS proposal_count,
  to_tsvector('french', 
    r.title || ' ' || 
    r.description || ' ' || 
    c.name
  ) AS search_document
FROM requests r
JOIN profiles p ON r.client_id = p.id
LEFT JOIN categories c ON r.category_id = c.id
LEFT JOIN deals d ON r.id = d.request_id
WHERE r.status = 'open'
GROUP BY r.id, c.id, c.name, p.id, p.first_name, p.last_name, p.avatar_url;

-- =============================================
-- INDEX POUR OPTIMISER LES RECHERCHES
-- =============================================

-- Index pour la recherche de texte intégral
CREATE INDEX idx_expert_search_document ON expert_search_view USING gin(search_document);
CREATE INDEX idx_service_search_document ON service_search_view USING gin(search_document);
CREATE INDEX idx_request_search_document ON request_search_view USING gin(search_document);

-- =============================================
-- FONCTIONS POUR LA RECHERCHE
-- =============================================

-- Fonction pour rechercher des experts avec filtres
CREATE OR REPLACE FUNCTION search_experts(
  search_query TEXT DEFAULT NULL,
  category_id INTEGER DEFAULT NULL,
  skill_ids INTEGER[] DEFAULT NULL,
  min_rating NUMERIC DEFAULT NULL,
  location_radius NUMERIC DEFAULT NULL,
  location_lat NUMERIC DEFAULT NULL,
  location_lng NUMERIC DEFAULT NULL,
  sort_by TEXT DEFAULT 'rating' -- 'rating', 'created_at', 'service_count'
)
RETURNS SETOF expert_search_view AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM expert_search_view e
  WHERE 
    -- Filtre de recherche textuelle
    (search_query IS NULL OR 
     search_document @@ to_tsquery('french', regexp_replace(search_query, '\s+', ':* & ', 'g') || ':*'))
    -- Filtre par catégorie
    AND (category_id IS NULL OR 
         category_id = ANY(SELECT c.id FROM categories c WHERE c.name = ANY(e.categories)))
    -- Filtre par compétences
    AND (skill_ids IS NULL OR 
         (SELECT COUNT(*) FROM user_skills us WHERE us.user_id = e.id AND us.skill_id = ANY(skill_ids)) = array_length(skill_ids, 1))
    -- Filtre par note minimale
    AND (min_rating IS NULL OR e.average_rating >= min_rating)
    -- Filtre par localisation si toutes les données nécessaires sont fournies
    AND (location_radius IS NULL OR location_lat IS NULL OR location_lng IS NULL OR
         (e.location->>'latitude')::NUMERIC IS NOT NULL AND 
         (e.location->>'longitude')::NUMERIC IS NOT NULL AND
         ST_DWithin(
           ST_SetSRID(ST_MakePoint((e.location->>'longitude')::NUMERIC, (e.location->>'latitude')::NUMERIC), 4326),
           ST_SetSRID(ST_MakePoint(location_lng, location_lat), 4326),
           location_radius
         )
    )
  ORDER BY
    CASE WHEN sort_by = 'rating' THEN e.average_rating END DESC NULLS LAST,
    CASE WHEN sort_by = 'created_at' THEN e.created_at END DESC NULLS LAST,
    CASE WHEN sort_by = 'service_count' THEN e.service_count END DESC NULLS LAST;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour rechercher des services avec filtres
CREATE OR REPLACE FUNCTION search_services(
  search_query TEXT DEFAULT NULL,
  category_id INTEGER DEFAULT NULL,
  skill_ids INTEGER[] DEFAULT NULL,
  min_price NUMERIC DEFAULT NULL,
  max_price NUMERIC DEFAULT NULL,
  max_delivery_time INTEGER DEFAULT NULL,
  sort_by TEXT DEFAULT 'price' -- 'price', 'rating', 'delivery_time'
)
RETURNS SETOF service_search_view AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM service_search_view s
  WHERE 
    -- Filtre de recherche textuelle
    (search_query IS NULL OR 
     search_document @@ to_tsquery('french', regexp_replace(search_query, '\s+', ':* & ', 'g') || ':*'))
    -- Filtre par catégorie
    AND (category_id IS NULL OR s.category_id = category_id)
    -- Filtre par compétences
    AND (skill_ids IS NULL OR 
         skill_ids <@ (SELECT array_agg(sk.id) FROM skills sk WHERE sk.name = ANY(s.skills)))
    -- Filtre par fourchette de prix
    AND (min_price IS NULL OR s.price >= min_price)
    AND (max_price IS NULL OR s.price <= max_price)
    -- Filtre par délai de livraison
    AND (max_delivery_time IS NULL OR s.delivery_time <= max_delivery_time)
  ORDER BY
    CASE WHEN sort_by = 'price' THEN s.price END ASC NULLS LAST,
    CASE WHEN sort_by = 'rating' THEN s.expert_rating END DESC NULLS LAST,
    CASE WHEN sort_by = 'delivery_time' THEN s.delivery_time END ASC NULLS LAST;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour rechercher des demandes avec filtres
CREATE OR REPLACE FUNCTION search_requests(
  search_query TEXT DEFAULT NULL,
  category_id INTEGER DEFAULT NULL,
  min_budget NUMERIC DEFAULT NULL,
  max_budget NUMERIC DEFAULT NULL,
  days_remaining INTEGER DEFAULT NULL,
  sort_by TEXT DEFAULT 'created_at' -- 'created_at', 'budget', 'deadline'
)
RETURNS SETOF request_search_view AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM request_search_view r
  WHERE 
    -- Filtre de recherche textuelle
    (search_query IS NULL OR 
     search_document @@ to_tsquery('french', regexp_replace(search_query, '\s+', ':* & ', 'g') || ':*'))
    -- Filtre par catégorie
    AND (category_id IS NULL OR r.category_id = category_id)
    -- Filtre par fourchette de budget
    AND (min_budget IS NULL OR r.budget >= min_budget)
    AND (max_budget IS NULL OR r.budget <= max_budget)
    -- Filtre par délai restant
    AND (days_remaining IS NULL OR 
         (r.deadline IS NOT NULL AND r.deadline >= CURRENT_DATE AND r.deadline <= CURRENT_DATE + days_remaining))
  ORDER BY
    CASE WHEN sort_by = 'created_at' THEN r.created_at END DESC NULLS LAST,
    CASE WHEN sort_by = 'budget' THEN r.budget END DESC NULLS LAST,
    CASE WHEN sort_by = 'deadline' THEN r.deadline END ASC NULLS LAST;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- TRIGGERS POUR LA MAINTENANCE DES RECHERCHES
-- =============================================

-- Fonction pour mettre à jour les recherches après modification des compétences d'un expert
CREATE OR REPLACE FUNCTION refresh_search_after_user_skills_change()
RETURNS TRIGGER AS $$
BEGIN
  -- Le rafraîchissement serait fait ici si nous utilisions des vues matérialisées
  -- Pour les vues classiques, pas d'action nécessaire car elles sont toujours à jour
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_search_on_user_skills_change
AFTER INSERT OR UPDATE OR DELETE ON user_skills
FOR EACH STATEMENT EXECUTE FUNCTION refresh_search_after_user_skills_change();

-- Fonction pour notifier les experts lorsqu'une demande correspond à leurs compétences
CREATE OR REPLACE FUNCTION notify_matching_experts()
RETURNS TRIGGER AS $$
DECLARE
  matching_expert_id UUID;
  request_category_id INTEGER;
BEGIN
  -- Récupérer la catégorie de la demande
  SELECT category_id INTO request_category_id FROM requests WHERE id = NEW.id;
  
  -- Trouver les experts qui correspondent à cette catégorie
  FOR matching_expert_id IN
    SELECT DISTINCT p.id
    FROM profiles p
    JOIN user_skills us ON p.id = us.user_id
    JOIN skills s ON us.skill_id = s.id
    WHERE p.is_expert = TRUE
    AND s.category_id = request_category_id
  LOOP
    -- Ici vous pourriez insérer une notification dans une table de notifications
    -- ou envoyer un email via une fonction externe
    -- INSERT INTO notifications (user_id, type, content, related_id)
    -- VALUES (matching_expert_id, 'new_matching_request', 'Une nouvelle demande correspond à vos compétences', NEW.id);
    
    -- Pour l'exemple, nous allons juste placer un message dans les logs PostgreSQL
    RAISE NOTICE 'Une demande (%) correspond aux compétences de l''expert (%)', NEW.id, matching_expert_id;
  END LOOP;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_experts_on_new_request
AFTER INSERT ON requests
FOR EACH ROW
EXECUTE FUNCTION notify_matching_experts();