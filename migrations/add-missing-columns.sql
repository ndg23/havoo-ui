-- Ajout des colonnes manquantes à la table profiles
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS birthdate DATE,
ADD COLUMN IF NOT EXISTS gender VARCHAR(20),
ADD COLUMN IF NOT EXISTS website VARCHAR(255),
ADD COLUMN IF NOT EXISTS hourly_rate DECIMAL(10, 2),
ADD COLUMN IF NOT EXISTS availability_status VARCHAR(20) DEFAULT 'available',
ADD COLUMN IF NOT EXISTS available_days VARCHAR(255),
ADD COLUMN IF NOT EXISTS available_hours VARCHAR(255),
ADD COLUMN IF NOT EXISTS email_notifications BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS push_notifications BOOLEAN DEFAULT TRUE;

-- Mise à jour de la fonction de calcul du pourcentage de complétion du profil
CREATE OR REPLACE FUNCTION update_profile_completion() RETURNS TRIGGER AS $$
BEGIN
  -- Start with base value for required fields
  NEW.profile_completion_percentage := 20;
  
  -- Add percentage points for each completed optional field
  IF NEW.phone IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.bio IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.avatar_url IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.city IS NOT NULL AND NEW.country IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.birthdate IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.website IS NOT NULL THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF NEW.is_expert = TRUE THEN 
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  IF EXISTS (
    SELECT 1 FROM user_skills 
    WHERE user_id = NEW.id
    LIMIT 1
  ) THEN
    NEW.profile_completion_percentage := NEW.profile_completion_percentage + 10;
  END IF;
  
  -- Ensure percentage doesn't exceed 100%
  IF NEW.profile_completion_percentage > 100 THEN 
    NEW.profile_completion_percentage := 100;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql; 