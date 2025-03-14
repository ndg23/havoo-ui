CREATE OR REPLACE FUNCTION update_request_status_on_proposal_acceptance()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'accepted' THEN
    UPDATE requests
    SET status = 'assigned'
    WHERE id = NEW.request_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER proposal_accepted_trigger
AFTER UPDATE OF status ON proposals
FOR EACH ROW
WHEN (NEW.status = 'accepted' AND OLD.status <> 'accepted')
EXECUTE FUNCTION update_request_status_on_proposal_acceptance();


CREATE OR REPLACE FUNCTION create_contract_on_proposal_acceptance()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'accepted' THEN
    INSERT INTO contracts (request_id, proposal_id, client_id, expert_id, title, description, price, start_date, end_date)
    SELECT r.id, NEW.id, r.client_id, NEW.expert_id, r.title, r.description, NEW.price, NULL, NULL -- Vous pouvez ajouter des dates de début/fin par défaut ou les laisser NULL
    FROM requests r
    WHERE r.id = NEW.request_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contract_creation_trigger
AFTER UPDATE OF status ON proposals
FOR EACH ROW
WHEN (NEW.status = 'accepted' AND OLD.status <> 'accepted')
EXECUTE FUNCTION create_contract_on_proposal_acceptance();



CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquez ce trigger à toutes les tables pertinentes
CREATE TRIGGER profiles_updated_at_trigger
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER requests_updated_at_trigger
BEFORE UPDATE ON requests
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER proposals_updated_at_trigger
BEFORE UPDATE ON proposals
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER contracts_updated_at_trigger
BEFORE UPDATE ON contracts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER categories_updated_at_trigger
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER skills_updated_at_trigger
BEFORE UPDATE ON skills
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();



CREATE OR REPLACE FUNCTION check_unique_proposal()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM proposals WHERE request_id = NEW.request_id AND expert_id = NEW.expert_id) THEN
    RAISE EXCEPTION 'Une proposition existe déjà pour cette demande et cet expert.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_proposal_trigger
BEFORE INSERT ON proposals
FOR EACH ROW
EXECUTE FUNCTION check_unique_proposal();



CREATE OR REPLACE FUNCTION search_experts(
  search_term TEXT DEFAULT NULL,
  category_id_filter INTEGER DEFAULT NULL,
  skill_ids_filter INTEGER[] DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  first_name VARCHAR,
  last_name VARCHAR,
  bio TEXT,
  avatar_url TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.first_name,
    p.last_name,
    p.bio,
    p.avatar_url
  FROM profiles p
  WHERE p.is_expert = TRUE
    AND (search_term IS NULL OR
      p.first_name ILIKE '%' || search_term || '%' OR
      p.last_name ILIKE '%' || search_term || '%' OR
      p.bio ILIKE '%' || search_term || '%')
    AND (category_id_filter IS NULL OR EXISTS (
      SELECT 1
      FROM skills s
      WHERE s.category_id = category_id_filter
        AND EXISTS (
          SELECT 1
          FROM user_skills us
          WHERE us.user_id = p.id
            AND us.skill_id = s.id
        )
    ))
    AND (skill_ids_filter IS NULL OR EXISTS (
      SELECT 1
      FROM user_skills us
      WHERE us.user_id = p.id
        AND us.skill_id = ANY(skill_ids_filter)
    ));
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_services(
  search_term TEXT DEFAULT NULL,
  category_id_filter INTEGER DEFAULT NULL,
  skill_ids_filter INTEGER[] DEFAULT NULL
)
RETURNS TABLE (
  id INTEGER,
  title VARCHAR,
  description TEXT,
  price DECIMAL,
  expert_id UUID
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.title,
    s.description,
    s.price,
    s.expert_id
  FROM services s
  WHERE s.is_active = TRUE
    AND (search_term IS NULL OR
      s.title ILIKE '%' || search_term || '%' OR
      s.description ILIKE '%' || search_term || '%')
    AND (category_id_filter IS NULL OR s.category_id = category_id_filter)
    AND (skill_ids_filter IS NULL OR EXISTS (
      SELECT 1
      FROM user_skills us
      WHERE us.user_id = s.expert_id
        AND us.skill_id = ANY(skill_ids_filter)
    ));
END;
$$ LANGUAGE plpgsql;