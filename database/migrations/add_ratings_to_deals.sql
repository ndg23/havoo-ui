-- Add rating fields directly to the deals table for the simplified approach
ALTER TABLE deals 
ADD COLUMN IF NOT EXISTS client_rating INTEGER CHECK (client_rating BETWEEN 1 AND 5),
ADD COLUMN IF NOT EXISTS expert_rating INTEGER CHECK (expert_rating BETWEEN 1 AND 5),
ADD COLUMN IF NOT EXISTS client_review TEXT,
ADD COLUMN IF NOT EXISTS expert_review TEXT,
ADD COLUMN IF NOT EXISTS client_has_rated BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS expert_has_rated BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS ratings_complete BOOLEAN DEFAULT FALSE;

-- Create the contract_ratings table for more detailed ratings
CREATE TABLE IF NOT EXISTS contract_ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contract_id UUID NOT NULL,
  client_has_rated BOOLEAN DEFAULT FALSE,
  worker_has_rated BOOLEAN DEFAULT FALSE,
  
  -- Client ratings (client rating the worker)
  overall_rating INTEGER CHECK (overall_rating BETWEEN 1 AND 5),
  communication_rating INTEGER CHECK (communication_rating BETWEEN 1 AND 5),
  quality_rating INTEGER CHECK (quality_rating BETWEEN 1 AND 5),
  would_recommend BOOLEAN,
  comment TEXT,
  
  -- Worker ratings (worker rating the client)
  worker_overall_rating INTEGER CHECK (worker_overall_rating BETWEEN 1 AND 5),
  worker_communication_rating INTEGER CHECK (worker_communication_rating BETWEEN 1 AND 5),
  reliability_rating INTEGER CHECK (reliability_rating BETWEEN 1 AND 5),
  worker_would_recommend BOOLEAN,
  worker_comment TEXT,
  
  -- Indicates if official reviews have been generated from these ratings
  reviews_generated BOOLEAN DEFAULT FALSE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create an index on contract_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_contract_ratings_contract_id ON contract_ratings(contract_id);

-- Create a view for contract status including rating information
CREATE OR REPLACE VIEW contract_status_view AS
SELECT
  d.id AS contract_id,
  d.id AS deal_id,
  d.request_id,
  d.expert_id AS worker_id,
  d.client_id,
  d.status,
  d.price AS agreed_price,
  d.created_at AS start_date,
  -- For end_date we use created_at + duration days as an estimate
  (d.created_at + (d.duration || ' days')::interval) AS end_date,
  -- Use updated_at as completed_at when status is 'completed'
  CASE WHEN d.status = 'completed' THEN d.updated_at ELSE NULL END AS completed_at,
  d.created_at,
  COALESCE(cp.first_name, '') || ' ' || COALESCE(cp.last_name, '') AS client_name,
  COALESCE(wp.first_name, '') || ' ' || COALESCE(wp.last_name, '') AS worker_name,
  r.title AS job_title,
  r.description,
  CASE
    WHEN d.status = 'completed' AND NOT d.client_has_rated AND NOT d.expert_has_rated THEN 'Aucune évaluation'
    WHEN d.status = 'completed' AND d.client_has_rated AND d.expert_has_rated THEN 'Notations complétées'
    WHEN d.status = 'completed' AND d.client_has_rated AND NOT d.expert_has_rated THEN 'En attente de notation du travailleur'
    WHEN d.status = 'completed' AND NOT d.client_has_rated AND d.expert_has_rated THEN 'En attente de notation du client'
    WHEN d.status = 'completed' THEN 'En attente des deux évaluations'
    ELSE NULL
  END AS rating_status
FROM
  deals d
JOIN
  profiles cp ON d.client_id = cp.id
JOIN
  profiles wp ON d.expert_id = wp.id
LEFT JOIN
  requests r ON d.request_id = r.id
WHERE
  d.status IN ('active', 'completed'); 