-- Migration vers le schéma simplifié
-- Ce script doit être exécuté avec précaution et après sauvegarde des données

BEGIN;

-- 1. Sauvegarde temporaire des données importantes
CREATE TEMP TABLE temp_profiles AS 
SELECT * FROM profiles;

CREATE TEMP TABLE temp_missions AS 
SELECT * FROM missions;

-- 2. Mise à jour de la table profiles pour y intégrer is_verified
ALTER TABLE profiles 
  ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT false;

-- Conversion des données de verification_status en booléen is_verified
UPDATE profiles
SET is_verified = (verification_status = 'approved')
WHERE verification_status IS NOT NULL;

-- 3. Nettoyage des tables 
-- Supprimer les colonnes obsolètes de la table profiles
ALTER TABLE profiles
  DROP COLUMN IF EXISTS verification_status,
  DROP COLUMN IF EXISTS verification_notes,
  DROP COLUMN IF EXISTS verified_at,
  DROP COLUMN IF EXISTS id_front,
  DROP COLUMN IF EXISTS id_back,
  DROP COLUMN IF EXISTS proof_location;

-- 4. Migrer les données des avis (si la table reviews existe)
DO $$ 
BEGIN
  IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'reviews') THEN
    -- Adapter les données des avis dans la table missions
    UPDATE missions r
    SET 
      review = rev.comment,
      rating = rev.rating
    FROM reviews rev
    WHERE r.id = rev.mission_id;
  END IF;
END $$;

-- 5. Supprimer les tables obsolètes
DROP TABLE IF EXISTS review_reactions;
DROP TABLE IF EXISTS review_responses;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS expert_certifications;

-- 6. Simplifier les champs dans missions
ALTER TABLE missions
  DROP COLUMN IF EXISTS photos,
  DROP COLUMN IF EXISTS is_public,
  DROP COLUMN IF EXISTS resolution_notes,
  DROP COLUMN IF EXISTS resolution_date;

-- 7. Créer la table app_settings si elle n'existe pas
CREATE TABLE IF NOT EXISTS app_settings (
  id VARCHAR(50) PRIMARY KEY,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Créer le trigger pour app_settings
DROP TRIGGER IF EXISTS update_app_settings_updated_at ON app_settings;
CREATE TRIGGER update_app_settings_updated_at
  BEFORE UPDATE ON app_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 9. Vérification d'intégrité
DO $$
DECLARE
  profile_count INT;
  mission_count INT;
BEGIN
  SELECT COUNT(*) INTO profile_count FROM profiles;
  SELECT COUNT(*) INTO mission_count FROM missions;
  
  IF profile_count != (SELECT COUNT(*) FROM temp_profiles) THEN
    RAISE EXCEPTION 'Erreur de migration: comptage de profils incorrect';
  END IF;
  
  IF mission_count != (SELECT COUNT(*) FROM temp_missions) THEN
    RAISE EXCEPTION 'Erreur de migration: comptage de requêtes incorrect';
  END IF;
END $$;

-- 10. Nettoyage des tables temporaires
DROP TABLE temp_profiles;
DROP TABLE temp_missions;

-- 11. Initialiser quelques paramètres d'application
INSERT INTO app_settings (id, value)
VALUES ('platform_fees', '{"percentage": 10, "minimum_fee": 500}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app_settings (id, value)
VALUES ('platform_currency', '{"code": "XOF", "symbol": "FCFA", "name": "Franc CFA"}')
ON CONFLICT (id) DO NOTHING;

COMMIT; 