
-- Fonction pour mettre à jour les timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER update_proposals_timestamp
BEFORE UPDATE ON proposals
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_contracts_timestamp
BEFORE UPDATE ON contracts
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_services_timestamp
BEFORE UPDATE ON services
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_payments_timestamp
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();



-- Application des triggers pour les timestamps
CREATE TRIGGER update_profiles_timestamp
BEFORE UPDATE ON profiles
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_requests_timestamp
BEFORE UPDATE ON requests
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

-- Trigger pour notifier quand une proposition est reçue
CREATE OR REPLACE FUNCTION notify_new_proposal()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notifications (user_id, title, content, type, reference_id, reference_type)
  SELECT 
    r.client_id, 
    'Nouvelle proposition', 
    'Vous avez reçu une nouvelle proposition sur votre demande: ' || r.title,
    'proposal',
    NEW.id,
    'proposal'
  FROM requests r
  WHERE r.id = NEW.request_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_new_proposal
AFTER INSERT ON proposals
FOR EACH ROW EXECUTE PROCEDURE notify_new_proposal();


-- Pour notification d'acceptation de proposition
CREATE OR REPLACE FUNCTION notify_proposal_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status != OLD.status THEN
    INSERT INTO notifications (user_id, title, content, type, reference_id, reference_type)
    VALUES (
      NEW.expert_id,
      CASE 
        WHEN NEW.status = 'accepted' THEN 'Proposition acceptée'
        WHEN NEW.status = 'rejected' THEN 'Proposition refusée'
        ELSE 'Statut de proposition mis à jour'
      END,
      'Le statut de votre proposition a été mis à jour.',
      'proposal_status',
      NEW.id,
      'proposal'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_proposal_status_change
AFTER UPDATE ON proposals
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE PROCEDURE notify_proposal_status_change();



-- Fonction pour mettre à jour le statut d'expert sur le profil
CREATE OR REPLACE FUNCTION update_expert_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    -- Mettre à jour le profil pour marquer l'utilisateur comme expert vérifié
    UPDATE profiles 
    SET is_expert = TRUE, 
        is_verified = TRUE, 
        expert_status = 'approved',
        updated_at = NOW()
    WHERE id = NEW.user_id;
    
    -- Ajouter une notification pour l'utilisateur
    INSERT INTO notifications (
      user_id, 
      title, 
      content, 
      type, 
      reference_id, 
      reference_type
    ) VALUES (
      NEW.user_id,
      'Félicitations ! Votre statut d''expert a été approuvé',
      'Votre demande de vérification a été approuvée. Vous pouvez maintenant proposer vos services sur la plateforme.',
      'expert_verification',
      NEW.id,
      'expert_verification'
    );
  
  ELSIF NEW.status = 'rejected' AND OLD.status != 'rejected' THEN
    -- Mettre à jour le profil pour indiquer le rejet
    UPDATE profiles 
    SET expert_status = 'rejected',
        updated_at = NOW()
    WHERE id = NEW.user_id;
    
    -- Ajouter une notification pour l'utilisateur
    INSERT INTO notifications (
      user_id, 
      title, 
      content, 
      type, 
      reference_id, 
      reference_type
    ) VALUES (
      NEW.user_id,
      'Votre demande de vérification a été refusée',
      'Votre demande de vérification a été refusée. Raison: ' || COALESCE(NEW.rejection_reason, 'Non spécifiée'),
      'expert_verification',
      NEW.id,
      'expert_verification'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour mettre à jour le statut d'expert
CREATE TRIGGER on_expert_verification_update
AFTER UPDATE ON expert_verifications
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE PROCEDURE update_expert_status();

-- Trigger pour mettre à jour le timestamp de la table expert_verifications
CREATE TRIGGER update_expert_verifications_timestamp
BEFORE UPDATE ON expert_verifications
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();