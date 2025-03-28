-- Création de la fonction trigger
CREATE OR REPLACE FUNCTION create_contract_on_deal_accept()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier si le statut passe à 'active'
    IF NEW.status = 'active' THEN
        -- Insérer un nouveau contrat
        INSERT INTO contracts (
            mission_id,
            expert_id,
            client_id,
            deal_id,
            price,
            duration,
            status,
            created_at,
            updated_at
        )
        SELECT 
            d.mission_id,
            d.expert_id,
            m.client_id,
            d.id AS deal_id,
            d.price,
            d.duration,
            'pending' AS status,
            NOW() AS created_at,
            NOW() AS updated_at
        FROM deals d
        JOIN missions m ON m.id = d.mission_id
        WHERE d.id = NEW.id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Création du trigger
CREATE TRIGGER trigger_create_contract_on_deal_accept
    AFTER UPDATE ON deals
    FOR EACH ROW
    WHEN (OLD.status != 'active' AND NEW.status = 'active')
    EXECUTE FUNCTION create_contract_on_deal_accept();