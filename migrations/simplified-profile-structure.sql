-- Mise à jour de la structure des profils pour plus de simplicité
ALTER TABLE profiles 
DROP COLUMN IF EXISTS zip_code,
DROP COLUMN IF EXISTS website,
DROP COLUMN IF EXISTS banner_image_url,
DROP COLUMN IF EXISTS banner_url,
DROP COLUMN IF EXISTS gender,
DROP COLUMN IF EXISTS birthdate;

-- Modification des colonnes existantes pour plus de simplicité
ALTER TABLE profiles
ALTER COLUMN country SET DEFAULT 'Sénégal',
ALTER COLUMN role TYPE VARCHAR(20),
ALTER COLUMN role SET DEFAULT 'client',
ADD COLUMN IF NOT EXISTS whatsapp VARCHAR(50),
ADD COLUMN IF NOT EXISTS languages TEXT[] DEFAULT ARRAY['Français'],
ADD COLUMN IF NOT EXISTS profession VARCHAR(100),
ADD COLUMN IF NOT EXISTS education_level VARCHAR(50),
ADD COLUMN IF NOT EXISTS preferred_payment_method VARCHAR(50) DEFAULT 'mobile_money',
ADD COLUMN IF NOT EXISTS mobile_money_number VARCHAR(50),
ADD COLUMN IF NOT EXISTS availability_hours jsonb DEFAULT '{"weekdays": ["09:00-18:00"], "weekend": ["10:00-16:00"]}',
ADD COLUMN IF NOT EXISTS profile_completion_percentage INTEGER GENERATED ALWAYS AS (
  CASE 
    WHEN phone IS NOT NULL THEN 20 +
    CASE WHEN whatsapp IS NOT NULL THEN 20 ELSE 0 END +
    CASE WHEN avatar_url IS NOT NULL THEN 20 ELSE 0 END +
    CASE WHEN bio IS NOT NULL THEN 20 ELSE 0 END +
    CASE WHEN profession IS NOT NULL THEN 20 ELSE 0 END
    ELSE 20
  END
) STORED;

-- Ajout des contraintes de validation
ALTER TABLE profiles
ADD CONSTRAINT valid_phone_format CHECK (phone ~ '^\+?[0-9]{8,15}$'),
ADD CONSTRAINT valid_whatsapp_format CHECK (whatsapp ~ '^\+?[0-9]{8,15}$'),
ADD CONSTRAINT valid_mobile_money_format CHECK (mobile_money_number ~ '^\+?[0-9]{8,15}$'),
ADD CONSTRAINT valid_role CHECK (role IN ('client', 'expert', 'admin')),
ADD CONSTRAINT valid_education_level CHECK (education_level IN ('primaire', 'secondaire', 'supérieur', 'autodidacte')),
ADD CONSTRAINT valid_payment_method CHECK (preferred_payment_method IN ('mobile_money', 'bank_transfer', 'cash', 'wave', 'orange_money'));

-- Création d'un index pour améliorer les performances des recherches
CREATE INDEX IF NOT EXISTS idx_profiles_profession ON profiles (profession);
CREATE INDEX IF NOT EXISTS idx_profiles_location ON profiles (city, country);

-- Mise à jour de la vue des profils pour inclure les nouveaux champs
CREATE OR REPLACE VIEW view_complete_profiles AS
SELECT 
    p.id,
    p.first_name,
    p.last_name,
    p.email,
    p.phone,
    p.whatsapp,
    p.avatar_url,
    p.bio,
    p.city,
    p.country,
    p.profession,
    p.education_level,
    p.languages,
    p.preferred_payment_method,
    p.mobile_money_number,
    p.availability_hours,
    p.is_expert,
    p.is_verified,
    p.profile_completion_percentage,
    COALESCE(
        json_agg(
            json_build_object(
                'skill_id', s.id,
                'skill_name', s.name
            )
        ) FILTER (WHERE s.id IS NOT NULL),
        '[]'::json
    ) as skills
FROM 
    profiles p
LEFT JOIN 
    user_skills us ON p.id = us.user_id
LEFT JOIN 
    skills s ON us.skill_id = s.id
GROUP BY 
    p.id;

-- Commentaires explicatifs
COMMENT ON TABLE profiles IS 'Table des profils utilisateurs simplifiée pour le marché africain';
COMMENT ON COLUMN profiles.whatsapp IS 'Numéro WhatsApp pour la communication directe';
COMMENT ON COLUMN profiles.languages IS 'Langues parlées par l''utilisateur';
COMMENT ON COLUMN profiles.profession IS 'Métier ou domaine d''expertise principal';
COMMENT ON COLUMN profiles.education_level IS 'Niveau d''éducation simplifié';
COMMENT ON COLUMN profiles.preferred_payment_method IS 'Méthode de paiement préférée (mobile money, etc.)';
COMMENT ON COLUMN profiles.mobile_money_number IS 'Numéro pour les paiements mobile money';
COMMENT ON COLUMN profiles.availability_hours IS 'Heures de disponibilité en format JSON'; 