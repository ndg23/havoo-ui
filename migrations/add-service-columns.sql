-- Ajout des colonnes location_type et duration à la table services
ALTER TABLE services 
ADD COLUMN IF NOT EXISTS location_type VARCHAR(20) DEFAULT 'remote' CHECK (location_type IN ('remote', 'onsite', 'hybrid')),
ADD COLUMN IF NOT EXISTS duration INTEGER; -- Durée en heures

-- Mise à jour des services existants avec des valeurs par défaut
UPDATE services 
SET 
  location_type = CASE 
    WHEN random() < 0.4 THEN 'remote'
    WHEN random() < 0.7 THEN 'onsite'
    ELSE 'hybrid'
  END,
  duration = FLOOR(random() * 40) + 1; -- Durée entre 1 et 40 heures

-- Ajout d'un index pour améliorer les performances des recherches par type de localisation
CREATE INDEX IF NOT EXISTS idx_services_location_type ON services(location_type); 