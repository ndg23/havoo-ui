-- Ajouter la colonne avatar_url
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- Ajouter la colonne role si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS role VARCHAR(20) DEFAULT 'user' NOT NULL;

-- Ajouter la colonne zip_code si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS zip_code VARCHAR(20);

-- Ajouter la colonne updated_at si elle n'existe pas déjà
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now(); 