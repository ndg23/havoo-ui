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