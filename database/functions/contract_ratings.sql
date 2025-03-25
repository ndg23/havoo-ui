-- Functions for handling contract ratings

-- Function to submit or update a contract rating
CREATE OR REPLACE FUNCTION submit_contract_rating(
  p_contract_id UUID,
  p_rating_data JSONB
) RETURNS BOOLEAN AS $$
DECLARE
  v_existing_rating_id UUID;
  v_role TEXT;
  v_other_has_rated BOOLEAN;
  v_deal_id UUID;
BEGIN
  -- Get the deal ID from the contract
  SELECT deal_id INTO v_deal_id
  FROM job_contracts
  WHERE id = p_contract_id;

  IF v_deal_id IS NULL THEN
    RAISE EXCEPTION 'Contract not found';
  END IF;

  -- Determine user role based on the fields in p_rating_data
  IF p_rating_data->>'client_has_rated' = 'true' THEN
    v_role := 'client';
  ELSE
    v_role := 'expert';
  END IF;
  
  -- Check if a rating record already exists for this contract
  SELECT id INTO v_existing_rating_id
  FROM contract_ratings
  WHERE contract_id = p_contract_id;
  
  IF v_existing_rating_id IS NULL THEN
    -- Create a new rating record if none exists
    INSERT INTO contract_ratings (
      contract_id,
      client_has_rated,
      expert_has_rated,
      overall_rating,
      communication_rating,
      quality_rating,
      reliability_rating,
      would_recommend,
      comment
    ) VALUES (
      p_contract_id,
      (v_role = 'client'),
      (v_role = 'expert'),
      (p_rating_data->>'overall_rating')::INTEGER,
      (p_rating_data->>'communication_rating')::INTEGER,
      CASE WHEN v_role = 'client' THEN (p_rating_data->>'quality_rating')::INTEGER ELSE NULL END,
      CASE WHEN v_role = 'expert' THEN (p_rating_data->>'reliability_rating')::INTEGER ELSE NULL END,
      (p_rating_data->>'would_recommend')::BOOLEAN,
      p_rating_data->>'comment'
    );
  ELSE
    -- Update the existing rating record with this user's ratings
    IF v_role = 'client' THEN
      UPDATE contract_ratings
      SET 
        client_has_rated = TRUE,
        overall_rating = (p_rating_data->>'overall_rating')::INTEGER,
        communication_rating = (p_rating_data->>'communication_rating')::INTEGER,
        quality_rating = (p_rating_data->>'quality_rating')::INTEGER,
        would_recommend = (p_rating_data->>'would_recommend')::BOOLEAN,
        comment = p_rating_data->>'comment'
      WHERE id = v_existing_rating_id;
      
      -- Check if expert has already rated
      SELECT expert_has_rated INTO v_other_has_rated
      FROM contract_ratings
      WHERE id = v_existing_rating_id;
    ELSE
      UPDATE contract_ratings
      SET 
        expert_has_rated = TRUE,
        expert_overall_rating = (p_rating_data->>'overall_rating')::INTEGER,
        expert_communication_rating = (p_rating_data->>'communication_rating')::INTEGER,
        reliability_rating = (p_rating_data->>'reliability_rating')::INTEGER,
        expert_would_recommend = (p_rating_data->>'would_recommend')::BOOLEAN,
        expert_comment = p_rating_data->>'comment'
      WHERE id = v_existing_rating_id;
      
      -- Check if client has already rated
      SELECT client_has_rated INTO v_other_has_rated
      FROM contract_ratings
      WHERE id = v_existing_rating_id;
    END IF;
  END IF;
  
  -- If both parties have now rated, create official reviews
  IF v_other_has_rated THEN
    PERFORM create_reviews_from_ratings(p_contract_id);
  END IF;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Function to create reviews directly from ratings
CREATE OR REPLACE FUNCTION create_reviews_from_ratings(p_contract_id UUID) RETURNS BOOLEAN AS $$
DECLARE
  v_ratings RECORD;
  v_client_id UUID;
  v_expert_id UUID;
  v_deal_id UUID;
BEGIN
  -- Get the deal ID and party IDs
  SELECT jc.deal_id, d.client_id, d.expert_id AS expert_id 
  INTO v_deal_id, v_client_id, v_expert_id
  FROM job_contracts jc
  JOIN deals d ON jc.deal_id = d.id
  WHERE jc.id = p_contract_id;
  
  IF v_deal_id IS NULL THEN
    RAISE EXCEPTION 'Contract not found';
  END IF;
  
  -- Get the contract ratings
  SELECT * INTO v_ratings
  FROM contract_ratings
  WHERE contract_id = p_contract_id;
  
  IF v_ratings IS NULL OR NOT (v_ratings.client_has_rated AND v_ratings.expert_has_rated) THEN
    -- Both parties have not yet rated, so don't create reviews
    RETURN FALSE;
  END IF;
  
  -- Create review from client to expert
  INSERT INTO reviews (
    reviewer_id,
    reviewed_id,
    contract_id,
    rating,
    communication_rating,
    quality_rating,
    comment,
    would_recommend
  ) VALUES (
    v_client_id,
    v_expert_id,
    p_contract_id,
    v_ratings.overall_rating,
    v_ratings.communication_rating,
    v_ratings.quality_rating,
    v_ratings.comment,
    v_ratings.would_recommend
  );
  
  -- Create review from expert to client
  INSERT INTO reviews (
    reviewer_id,
    reviewed_id,
    contract_id,
    rating,
    communication_rating,
    reliability_rating,
    comment,
    would_recommend
  ) VALUES (
    v_expert_id,
    v_client_id,
    p_contract_id,
    v_ratings.expert_overall_rating,
    v_ratings.expert_communication_rating,
    v_ratings.reliability_rating,
    v_ratings.expert_comment,
    v_ratings.expert_would_recommend
  );
  
  -- Update the contract ratings to indicate reviews have been created
  UPDATE contract_ratings
  SET reviews_generated = TRUE
  WHERE contract_id = p_contract_id;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Alternative simpler approach: Rate directly in the deals table
CREATE OR REPLACE FUNCTION rate_contract_simple(
  p_deal_id UUID,
  p_is_client BOOLEAN, -- TRUE if client is rating, FALSE if expert is rating
  p_rating INTEGER,
  p_comment TEXT
) RETURNS BOOLEAN AS $$
BEGIN
  -- Update the deal with the rating
  IF p_is_client THEN
    UPDATE deals
    SET 
      client_rating = p_rating,
      client_review = p_comment,
      client_has_rated = TRUE
    WHERE id = p_deal_id;
  ELSE
    UPDATE deals
    SET 
      expert_rating = p_rating,
      expert_review = p_comment,
      expert_has_rated = TRUE
    WHERE id = p_deal_id;
  END IF;
  
  -- Check if both have rated and update status if needed
  UPDATE deals
  SET ratings_complete = TRUE
  WHERE id = p_deal_id
    AND client_has_rated = TRUE
    AND expert_has_rated = TRUE;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;