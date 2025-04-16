-- Fonction pour gérer l'acceptation d'une proposition
CREATE OR REPLACE FUNCTION handle_proposal_acceptance()
RETURNS TRIGGER AS $$
BEGIN
  -- Si le statut change vers 'accepted'
  IF NEW.status = 'accepted' AND OLD.status = 'proposal' THEN
    -- 1. Mettre à jour la mission
    UPDATE missions 
    SET 
      status = 'in_progress',
      expert_id = NEW.expert_id,
      accepted_deal_id = NEW.id
    WHERE id = NEW.mission_id;

    -- 2. Refuser automatiquement les autres propositions
    UPDATE deals 
    SET status = 'rejected'
    WHERE 
      mission_id = NEW.mission_id 
      AND id != NEW.id 
      AND status = 'proposal';

    -- 3. Enregistrer la date d'acceptation
    NEW.accepted_at = NOW();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger
CREATE TRIGGER on_proposal_accepted
  BEFORE UPDATE ON deals
  FOR EACH ROW
  EXECUTE FUNCTION handle_proposal_acceptance(); 