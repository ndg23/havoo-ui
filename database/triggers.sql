
-- =========================================================================
-- TRIGGER FUNCTIONS
-- =========================================================================

-- Fonction pour le suivi des propositions
CREATE OR REPLACE FUNCTION track_proposal_changes()
RETURNS TRIGGER AS $$
DECLARE
  v_details JSONB;
  v_action_type VARCHAR(50);
BEGIN
  IF (TG_OP = 'DELETE') THEN
    v_action_type := 'delete_proposal';
    v_details := jsonb_build_object(
      'job_id', OLD.job_id,
      'provider_id', OLD.provider_id,
      'price', OLD.price,
      'status', OLD.status
    );
    
    PERFORM log_activity(
      OLD.provider_id,
      v_action_type,
      'proposal',
      OLD.id,
      v_details
    );
    
    RETURN OLD;
  ELSIF (TG_OP = 'UPDATE') THEN
    v_action_type := 'update_proposal';
    v_details := jsonb_build_object();
    
    IF NEW.price IS DISTINCT FROM OLD.price THEN
      v_details := v_details || jsonb_build_object('price', NEW.price, 'previous_price', OLD.price);
    END IF;
    
    IF NEW.status IS DISTINCT FROM OLD.status THEN
      v_details := v_details || jsonb_build_object('status', NEW.status, 'previous_status', OLD.status);
      
      CASE NEW.status
        WHEN 'accepted' THEN v_action_type := 'accept_proposal';
        WHEN 'rejected' THEN v_action_type := 'reject_proposal';
        WHEN 'withdrawn' THEN v_action_type := 'withdraw_proposal';
        ELSE v_action_type := 'update_proposal';
      END CASE;
    END IF;
    
    IF v_details <> '{}'::JSONB THEN
      PERFORM log_activity(
        NEW.provider_id,
        v_action_type,
        'proposal',
        NEW.id,
        v_details
      );
    END IF;
    
    RETURN NEW;
  ELSIF (TG_OP = 'INSERT') THEN
    v_action_type := 'create_proposal';
    v_details := jsonb_build_object(
      'job_id', NEW.job_id,
      'provider_id', NEW.provider_id,
      'price', NEW.price,
      'status', NEW.status
    );
    
    PERFORM log_activity(
      NEW.provider_id,
      v_action_type,
      'proposal',
      NEW.id,
      v_details
    );
    
    RETURN NEW;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour la mise à jour des notes
CREATE OR REPLACE FUNCTION update_provider_rating()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    UPDATE provider_profiles
    SET 
      rating_average = COALESCE(
        (SELECT ROUND(AVG(rating)::numeric, 2)
         FROM provider_ratings
         WHERE provider_id = OLD.provider_id),
        0
      ),
      total_jobs = COALESCE(
        (SELECT COUNT(*)
         FROM provider_ratings
         WHERE provider_id = OLD.provider_id),
        0
      )
    WHERE id = OLD.provider_id;
    
    RETURN OLD;
  ELSE
    UPDATE provider_profiles
    SET 
      rating_average = COALESCE(
        (SELECT ROUND(AVG(rating)::numeric, 2)
         FROM provider_ratings
         WHERE provider_id = NEW.provider_id),
        0
      ),
      total_jobs = COALESCE(
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

-- =========================================================================
-- TRIGGER CREATION
-- =========================================================================

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS track_proposal_changes_trigger ON proposals;
DROP TRIGGER IF EXISTS update_provider_rating_trigger ON provider_ratings;

-- Create triggers
CREATE TRIGGER track_proposal_changes_trigger
  AFTER INSERT OR UPDATE OR DELETE ON proposals
  FOR EACH ROW
  EXECUTE FUNCTION track_proposal_changes();

CREATE TRIGGER update_provider_rating_trigger
  AFTER INSERT OR UPDATE OR DELETE ON provider_ratings
  FOR EACH ROW
  EXECUTE FUNCTION update_provider_rating();