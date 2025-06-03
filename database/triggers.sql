-- Fonction pour gérer la disponibilité des experts
CREATE OR REPLACE FUNCTION manage_expert_availability()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la proposition vient d'être acceptée (status devient 'active')
    IF NEW.status = 'active' AND OLD.status = 'proposal' THEN
        -- Marquer l'expert comme non disponible
        UPDATE profiles 
        SET is_available = false
        WHERE id = NEW.expert_id;
    
    -- Si la mission vient d'être terminée (status devient 'completed')
    ELSIF NEW.status = 'completed' AND OLD.status = 'active' THEN
        -- Marquer l'expert comme disponible
        UPDATE profiles 
        SET is_available = true
        WHERE id = NEW.expert_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger
CREATE TRIGGER trigger_manage_expert_availability
    AFTER UPDATE ON deals
    FOR EACH ROW
    WHEN (OLD.status IS DISTINCT FROM NEW.status)
    EXECUTE FUNCTION manage_expert_availability();

-- Fonction utilitaire pour vérifier la disponibilité d'un expert
CREATE OR REPLACE FUNCTION is_expert_available(expert_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_has_active_deal BOOLEAN;
BEGIN
    -- Vérifier si l'expert a une mission active
    SELECT EXISTS (
        SELECT 1 
        FROM deals 
        WHERE expert_id = $1 
        AND status = 'active'
    ) INTO v_has_active_deal;
    
    RETURN NOT v_has_active_deal;
END;
$$ LANGUAGE plpgsql;





-- =========================================================================
-- TRIGGERS POUR AUTOMATISATION DES STATUTS
-- =========================================================================

-- Trigger pour mettre à jour le statut de mission quand un deal change
CREATE OR REPLACE FUNCTION update_mission_status_on_deal_change()
RETURNS TRIGGER AS $$
BEGIN
  -- Si le deal passe de 'proposal' à 'active' (accepté)
  IF OLD.status = 'proposal' AND NEW.status = 'active' THEN
    -- Mettre à jour le statut de la mission associée
    UPDATE missions
    SET status = 'assigned'
    WHERE id = NEW.mission_id;
  
  -- Si le deal passe à 'completed'
  ELSIF NEW.status = 'completed' THEN
    -- Mettre à jour le statut de la mission associée
    UPDATE missions
    SET status = 'completed'
    WHERE id = NEW.mission_id;
  
  -- Si le deal est annulé et qu'il n'y a pas d'autres deals actifs
  ELSIF NEW.status = 'cancelled' AND OLD.status = 'active' THEN
    -- Vérifier s'il existe d'autres deals actifs pour cette mission
    IF NOT EXISTS (
      SELECT 1 FROM deals 
      WHERE mission_id = NEW.mission_id 
      AND status = 'active'
      AND id != NEW.id
    ) THEN
      -- Remettre la mission en statut 'open'
      UPDATE missions
      SET status = 'open'
      WHERE id = NEW.mission_id;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_mission_status_on_deal_change
  AFTER UPDATE ON deals
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status)
  EXECUTE FUNCTION update_mission_status_on_deal_change();

-- Trigger pour finaliser automatiquement les évaluations
CREATE OR REPLACE FUNCTION complete_deal_ratings()
RETURNS TRIGGER AS $$
BEGIN
  -- Si les deux parties ont noté, marquer les évaluations comme complètes
  IF NEW.client_has_rated = TRUE AND NEW.expert_has_rated = TRUE THEN
    NEW.ratings_complete := TRUE;
    
    -- Insérer une activité pour le suivi
    PERFORM log_activity(
      NEW.client_id, 
      'complete_ratings',
      'deal',
      NEW.id,
      jsonb_build_object(
        'client_rating', NEW.client_rating,
        'expert_rating', NEW.expert_rating
      )
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER complete_deal_ratings
  BEFORE UPDATE ON deals
  FOR EACH ROW
  WHEN (NEW.client_has_rated = TRUE AND NEW.expert_has_rated = TRUE)
  EXECUTE FUNCTION complete_deal_ratings();

-- Trigger pour une mission "en_cours" quand le travail commence
CREATE OR REPLACE FUNCTION start_mission_work()
RETURNS TRIGGER AS $$
BEGIN
  -- Si le statut passe d'assigned à in_progress
  IF OLD.status = 'assigned' AND NEW.status = 'in_progress' THEN
    -- Mettre à jour tous les deals actifs associés
    UPDATE deals
    SET status = 'in_progress'
    WHERE mission_id = NEW.id AND status = 'active';
    
    -- Journaliser l'événement
    PERFORM log_activity(
      COALESCE(auth.uid(), NEW.client_id),
      'start_work',
      'mission',
      NEW.id,
      jsonb_build_object('start_date', NOW()::date)
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mission_work_started
  AFTER UPDATE ON missions
  FOR EACH ROW
  WHEN (OLD.status = 'assigned' AND NEW.status = 'in_progress')
  EXECUTE FUNCTION start_mission_work();

-- Trigger pour vérifier automatiquement le délai de mission
CREATE OR REPLACE FUNCTION check_mission_deadlines()
RETURNS TRIGGER AS $$
BEGIN
  -- Vérifier si la deadline est dépassée
  IF NEW.deadline < CURRENT_DATE AND NEW.status IN ('open', 'assigned') THEN
    -- Ajouter une indication que la deadline est dépassée
    PERFORM log_activity(
      NEW.client_id,
      'deadline_passed',
      'mission',
      NEW.id,
      jsonb_build_object('deadline', NEW.deadline)
    );
    
    -- Optionnellement, vous pourriez mettre à jour un champ pour indiquer visuellement cet état
    -- NEW.status := 'deadline_passed';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_mission_deadline
  BEFORE UPDATE ON missions
  FOR EACH ROW
  EXECUTE FUNCTION check_mission_deadlines();

-- Trigger pour mise à jour du statut expert basée sur les évaluations
CREATE OR REPLACE FUNCTION check_expert_eligibility()
RETURNS TRIGGER AS $$
DECLARE
  avg_rating DECIMAL;
  rating_count INTEGER;
BEGIN
  -- Calculer la note moyenne et le nombre d'évaluations
  SELECT AVG(client_rating), COUNT(*)
  INTO avg_rating, rating_count
  FROM deals
  WHERE expert_id = NEW.expert_id
  AND client_has_rated = TRUE;
  
  -- Si l'utilisateur a au moins 5 évaluations avec une moyenne >= 4.5, le rendre éligible au statut d'expert
  IF rating_count >= 5 AND avg_rating >= 4.5 THEN
    -- Mettre à jour un champ dans le profil pour indiquer l'éligibilité
    UPDATE profiles
    SET role = 'expert'
    WHERE id = NEW.expert_id AND role = 'client';
    
    -- Journaliser l'événement
    PERFORM log_activity(
      NEW.expert_id,
      'expert_eligibility',
      'profile',
      NEW.expert_id,
      jsonb_build_object(
        'avg_rating', avg_rating,
        'rating_count', rating_count
      )
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_expert_status_eligibility
  AFTER UPDATE ON deals
  FOR EACH ROW
  WHEN (NEW.client_has_rated = TRUE AND OLD.client_has_rated = FALSE)
  EXECUTE FUNCTION check_expert_eligibility();

-- =========================================================================
-- MODIFICATION DU SCHÉMA : AJOUT DE CHAMPS UTILES
-- =========================================================================

-- Ajout d'un champ pour suivre l'état de la deadline dans la table missions
ALTER TABLE missions ADD COLUMN IF NOT EXISTS deadline_status VARCHAR(20) 
  DEFAULT 'on_time' CHECK (deadline_status IN ('on_time', 'approaching', 'overdue'));

-- Ajout d'un champ pour suivre l'avancement dans les deals
ALTER TABLE deals ADD COLUMN IF NOT EXISTS progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage BETWEEN 0 AND 100);

-- Ajout d'un champ pour le temps estimé restant
ALTER TABLE deals ADD COLUMN IF NOT EXISTS estimated_time_remaining INTEGER;

-- Ajout d'un champ pour stocker des horodatages importants
ALTER TABLE deals ADD COLUMN IF NOT EXISTS timeline JSONB DEFAULT '{}'::jsonb;

-- =========================================================================
-- AJOUT DE VUES POUR LES PAGES MISSIONS/INDEX ET MISSIONS/ACCOUNT
-- =========================================================================

-- Vue pour la page missions/index
CREATE OR REPLACE VIEW public_available_missions AS
SELECT 
  m.id,
  m.title,
  m.description,
  m.budget,
  m.deadline,
  m.status,
  m.work_type,
  m.created_at,
  m.updated_at,
  p.id AS client_id,
  p.first_name AS client_first_name,
  p.last_name AS client_last_name,
  p.avatar_url AS client_avatar,
  prof.name AS profession_name,
  COALESCE(
    (SELECT AVG(d.expert_rating) 
     FROM deals d 
     WHERE d.client_id = p.id AND d.expert_has_rated = TRUE),
    0
  ) AS client_avg_rating,
  COALESCE(
    (SELECT COUNT(*) 
     FROM deals d 
     WHERE d.client_id = p.id AND d.status = 'completed'),
    0
  ) AS client_completed_missions,
  (SELECT COUNT(*) FROM deals d WHERE d.mission_id = m.id AND d.status = 'proposal') AS proposal_count
FROM 
  missions m
JOIN 
  profiles p ON m.client_id = p.id
LEFT JOIN 
  professions prof ON m.profession_id = prof.id
WHERE 
  m.status = 'open';

-- Vue pour la page missions/account (missions de l'utilisateur)
CREATE OR REPLACE VIEW user_missions AS
SELECT 
  m.id,
  m.title,
  m.description,
  m.budget,
  m.deadline,
  m.status,
  m.work_type,
  m.created_at,
  m.updated_at,
  m.client_id,
  CASE 
    WHEN m.client_id = auth.uid() THEN 'owner' 
    ELSE 'participant' 
  END AS relationship,
  (SELECT COUNT(*) FROM deals d WHERE d.mission_id = m.id AND d.status = 'proposal') AS proposal_count,
  (
    SELECT json_agg(
      json_build_object(
        'id', d.id,
        'status', d.status,
        'expert_id', d.expert_id,
        'expert_first_name', p.first_name,
        'expert_last_name', p.last_name,
        'price', d.price,
        'duration', d.duration,
        'created_at', d.created_at
      )
    )
    FROM deals d
    JOIN profiles p ON d.expert_id = p.id
    WHERE d.mission_id = m.id
  ) AS deals
FROM 
  missions m
WHERE 
  m.client_id = auth.uid() 
  OR EXISTS (
    SELECT 1 FROM deals d WHERE d.mission_id = m.id AND d.expert_id = auth.uid()
  );

-- Vue pour les notifications
CREATE OR REPLACE VIEW user_mission_notifications AS
SELECT
  m.id AS mission_id,
  m.title AS mission_title,
  d.id AS deal_id,
  d.status AS deal_status,
  d.created_at AS notification_date,
  CASE
    WHEN d.status = 'proposal' AND m.client_id = auth.uid() THEN 
      'new_proposal'
    WHEN d.status = 'active' AND d.expert_id = auth.uid() THEN
      'proposal_accepted'
    WHEN d.status = 'completed' AND m.client_id = auth.uid() THEN
      'service_completed'
    WHEN d.status = 'completed' AND d.expert_id = auth.uid() THEN
      'feedback_requested'
    WHEN d.ratings_complete = TRUE AND (m.client_id = auth.uid() OR d.expert_id = auth.uid()) THEN
      'ratings_complete'
    ELSE
      'status_update'
  END AS notification_type,
  CASE
    WHEN m.client_id = auth.uid() THEN d.expert_id
    ELSE m.client_id
  END AS other_party_id,
  p.first_name AS other_party_first_name,
  p.last_name AS other_party_last_name,
  p.avatar_url AS other_party_avatar
FROM
  deals d
JOIN
  missions m ON d.mission_id = m.id
JOIN
  profiles p ON (
    CASE
      WHEN m.client_id = auth.uid() THEN d.expert_id
      ELSE m.client_id
    END = p.id
  )
WHERE
  (m.client_id = auth.uid() OR d.expert_id = auth.uid())
  AND d.created_at > (NOW() - INTERVAL '30 days')
ORDER BY
  d.created_at DESC;