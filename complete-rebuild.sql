-- ===========================================
-- SCRIPT DE RECONSTRUCTION COMPLÈTE 
-- Séparation en phases pour éviter les erreurs de relation
-- ===========================================
\set ON_ERROR_STOP on
\set VERBOSITY verbose

-- Désactiver temporairement les contraintes
SET session_replication_role = 'replica';

-- ===========================================
-- PHASE 0: NETTOYAGE COMPLET
-- ===========================================

-- Supprimer les triggers
DO $$ 
DECLARE
    trigger_rec RECORD;
BEGIN
    FOR trigger_rec IN (
        SELECT t.tgname, c.relname
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
        AND t.tgname NOT LIKE 'pg_%'
    ) LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON public.%I CASCADE', 
                     trigger_rec.tgname, trigger_rec.relname);
    END LOOP;
END $$;

-- Supprimer les fonctions
DO $$ 
DECLARE
    func_rec RECORD;
BEGIN
    FOR func_rec IN (
        SELECT p.proname, pg_get_function_identity_arguments(p.oid) AS args
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
    ) LOOP
        EXECUTE format('DROP FUNCTION IF EXISTS public.%I(%s) CASCADE', 
                     func_rec.proname, func_rec.args);
    END LOOP;
END $$;

-- Supprimer toutes les tables
DO $$ 
DECLARE
    table_rec RECORD;
BEGIN
    FOR table_rec IN (
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        ORDER BY tablename
    ) LOOP
        EXECUTE format('DROP TABLE IF EXISTS public.%I CASCADE', table_rec.tablename);
    END LOOP;
END $$;

-- ===========================================
-- PHASE 1: CRÉATION DES TABLES SANS CONTRAINTES FK
-- ===========================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- PROFILES - Table utilisateur de base
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    location TEXT,
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Sénégal',
    zip_code VARCHAR(20),
    birthdate DATE,
    gender VARCHAR(20),
    bio TEXT,
    profile_image_url TEXT,
    banner_image_url TEXT,
    avatar_url TEXT,
    role VARCHAR(20) DEFAULT 'client' NOT NULL,
    is_expert BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(20) DEFAULT 'pending',
    verification_notes TEXT,
    verified_at TIMESTAMPTZ,
    id_front TEXT,
    id_back TEXT,
    proof_location TEXT,
    rating DECIMAL(3,2),
    reviews_count INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- SKILLS - Compétences
CREATE TABLE public.skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PROFILE_SKILLS - Association profil-compétence
CREATE TABLE public.profile_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL,
    skill_id UUID NOT NULL,
    level VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- SERVICE_CATEGORIES - Catégories de services
CREATE TABLE public.service_professions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- SERVICES - Services
CREATE TABLE public.services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profession_id UUID,
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- EXPERTS
CREATE TABLE public.experts (
    id UUID PRIMARY KEY,
    bio TEXT,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    verification_status VARCHAR(50) DEFAULT 'pending',
    average_rating DECIMAL(3, 2),
    review_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- EXPERT_SERVICES
CREATE TABLE public.expert_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID NOT NULL,
    service_id UUID NOT NULL,
    hourly_rate DECIMAL(10, 2),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- EXPERT_CERTIFICATIONS
CREATE TABLE public.expert_certifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID,
    name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    issue_date DATE,
    expiry_date DATE,
    issuing_authority VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- REQUESTS - Demandes de service
CREATE TABLE public.missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    service_id UUID,
    profession_id UUID,
    location VARCHAR(255),
    budget DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'active',
    deadline DATE,
    is_urgent BOOLEAN DEFAULT FALSE,
    skills JSONB,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- PROPOSALS - Propositions des experts
CREATE TABLE public.proposals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mission_id UUID,
    expert_id UUID,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT NOT NULL,
    estimated_time INTEGER,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CONTRACTS - Contrats
CREATE TABLE public.contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mission_id UUID,
    proposal_id UUID,
    client_id UUID,
    expert_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- REVIEWS - Avis
CREATE TABLE public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID,
    mission_id UUID,
    client_id UUID,
    expert_id UUID,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    photos JSONB,
    is_public BOOLEAN DEFAULT TRUE,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- REVIEW_RESPONSES
CREATE TABLE public.review_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    review_id UUID NOT NULL,
    expert_id UUID NOT NULL,
    response TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- REVIEW_REACTIONS
CREATE TABLE public.review_reactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    review_id UUID NOT NULL,
    profile_id UUID NOT NULL,
    is_helpful BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- CONVERSATIONS
CREATE TABLE public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mission_id UUID,
    title VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CONVERSATION_PARTICIPANTS
CREATE TABLE public.conversation_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    profile_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- MESSAGES
CREATE TABLE public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- NOTIFICATIONS
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    related_id UUID,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PAYMENTS
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FAVORITES
CREATE TABLE public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL,
    expert_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(profile_id, expert_id)
);

-- Table des paramètres d'application
CREATE TABLE public.app_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(255) NOT NULL UNIQUE,
    value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ===========================================
-- PHASE 2: AJOUT DES CONTRAINTES DE CLÉ ÉTRANGÈRE
-- ===========================================

-- Relation PROFILES avec AUTH.USERS
ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_id_fkey 
FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Relations PROFILE_SKILLS
ALTER TABLE public.profile_skills
ADD CONSTRAINT profile_skills_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.profile_skills
ADD CONSTRAINT profile_skills_skill_id_fkey
FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;

-- Relation SERVICES avec CATEGORIES
ALTER TABLE public.services
ADD CONSTRAINT services_profession_id_fkey
FOREIGN KEY (profession_id) REFERENCES public.service_professions(id) ON DELETE SET NULL;

-- Relation EXPERTS avec PROFILES
ALTER TABLE public.experts
ADD CONSTRAINT experts_id_fkey
FOREIGN KEY (id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Relations EXPERT_SERVICES
ALTER TABLE public.expert_services
ADD CONSTRAINT expert_services_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

ALTER TABLE public.expert_services
ADD CONSTRAINT expert_services_service_id_fkey
FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;

-- Relations EXPERT_CERTIFICATIONS
ALTER TABLE public.expert_certifications
ADD CONSTRAINT expert_certifications_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- Relations REQUESTS
ALTER TABLE public.missions
ADD CONSTRAINT missions_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.missions
ADD CONSTRAINT missions_service_id_fkey
FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE SET NULL;

ALTER TABLE public.missions
ADD CONSTRAINT missions_profession_id_fkey
FOREIGN KEY (profession_id) REFERENCES public.service_professions(id) ON DELETE SET NULL;

-- Relations PROPOSALS
ALTER TABLE public.proposals
ADD CONSTRAINT proposals_mission_id_fkey
FOREIGN KEY (mission_id) REFERENCES public.missions(id) ON DELETE CASCADE;

ALTER TABLE public.proposals
ADD CONSTRAINT proposals_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- Relations CONTRACTS
ALTER TABLE public.contracts
ADD CONSTRAINT contracts_mission_id_fkey
FOREIGN KEY (mission_id) REFERENCES public.missions(id) ON DELETE SET NULL;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_proposal_id_fkey
FOREIGN KEY (proposal_id) REFERENCES public.proposals(id) ON DELETE SET NULL;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- Relations REVIEWS
ALTER TABLE public.reviews
ADD CONSTRAINT reviews_contract_id_fkey
FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE CASCADE;

ALTER TABLE public.reviews
ADD CONSTRAINT reviews_mission_id_fkey
FOREIGN KEY (mission_id) REFERENCES public.missions(id) ON DELETE CASCADE;

ALTER TABLE public.reviews
ADD CONSTRAINT reviews_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.reviews
ADD CONSTRAINT reviews_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- Relations REVIEW_RESPONSES
ALTER TABLE public.review_responses
ADD CONSTRAINT review_responses_review_id_fkey
FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;

ALTER TABLE public.review_responses
ADD CONSTRAINT review_responses_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- Relations REVIEW_REACTIONS
ALTER TABLE public.review_reactions
ADD CONSTRAINT review_reactions_review_id_fkey
FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;

ALTER TABLE public.review_reactions
ADD CONSTRAINT review_reactions_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Relations CONVERSATIONS
ALTER TABLE public.conversations
ADD CONSTRAINT conversations_mission_id_fkey
FOREIGN KEY (mission_id) REFERENCES public.missions(id) ON DELETE SET NULL;

-- Relations CONVERSATION_PARTICIPANTS
ALTER TABLE public.conversation_participants
ADD CONSTRAINT conversation_participants_conversation_id_fkey
FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;

ALTER TABLE public.conversation_participants
ADD CONSTRAINT conversation_participants_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Relations MESSAGES
ALTER TABLE public.messages
ADD CONSTRAINT messages_conversation_id_fkey
FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;

ALTER TABLE public.messages
ADD CONSTRAINT messages_sender_id_fkey
FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Relations NOTIFICATIONS
ALTER TABLE public.notifications
ADD CONSTRAINT notifications_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Relations PAYMENTS
ALTER TABLE public.payments
ADD CONSTRAINT payments_contract_id_fkey
FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE CASCADE;

-- Relations FAVORITES
ALTER TABLE public.favorites
ADD CONSTRAINT favorites_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.favorites
ADD CONSTRAINT favorites_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.experts(id) ON DELETE CASCADE;

-- ===========================================
-- PHASE 3: FONCTIONS, TRIGGERS ET INDEXES
-- ===========================================

-- Fonction pour mettre à jour le champ updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour les statistiques expert
CREATE OR REPLACE FUNCTION update_expert_stats()
RETURNS TRIGGER AS $$
DECLARE
    v_expert_id UUID;
    v_avg_rating DECIMAL(3,2);
    v_review_count INTEGER;
BEGIN
    -- Déterminer l'expert_id
    IF TG_OP = 'DELETE' THEN
        v_expert_id := OLD.expert_id;
    ELSE
        v_expert_id := NEW.expert_id;
    END IF;
    
    -- Calculer la note moyenne
    SELECT AVG(rating)::DECIMAL(3,2), COUNT(*)
    INTO v_avg_rating, v_review_count
    FROM public.reviews
    WHERE expert_id = v_expert_id AND is_public = TRUE;
    
    -- Mettre à jour le profil de l'expert
    UPDATE public.profiles
    SET rating = v_avg_rating,
        reviews_count = v_review_count
    WHERE id = v_expert_id;
    
    -- Mettre à jour la table experts
    UPDATE public.experts
    SET average_rating = v_avg_rating,
        review_count = v_review_count
    WHERE id = v_expert_id;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer une notification
CREATE OR REPLACE FUNCTION create_notification()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.notifications (
        profile_id,
        type,
        title,
        content,
        related_id
    ) VALUES (
        NEW.expert_id,
        'proposal_accepted',
        'Votre proposition a été acceptée',
        'Un client a accepté votre proposition. Un contrat a été créé.',
        NEW.id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer les triggers
CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at
BEFORE UPDATE ON public.services
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_service_professions_updated_at
BEFORE UPDATE ON public.service_professions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_experts_updated_at
BEFORE UPDATE ON public.experts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_missions_updated_at
BEFORE UPDATE ON public.missions
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_proposals_updated_at
BEFORE UPDATE ON public.proposals
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contracts_updated_at
BEFORE UPDATE ON public.contracts
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at
BEFORE UPDATE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_review_responses_updated_at
BEFORE UPDATE ON public.review_responses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_conversations_updated_at
BEFORE UPDATE ON public.conversations
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour les avis
CREATE TRIGGER after_review_insert
AFTER INSERT OR UPDATE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION update_expert_stats();

CREATE TRIGGER after_review_delete
AFTER DELETE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION update_expert_stats();

-- Créer les index
CREATE INDEX idx_profile_skills_profile ON public.profile_skills (profile_id);
CREATE INDEX idx_profile_skills_skill ON public.profile_skills (skill_id);
CREATE INDEX idx_services_category ON public.services (profession_id);
CREATE INDEX idx_missions_client ON public.missions (client_id);
CREATE INDEX idx_missions_service ON public.missions (service_id);
CREATE INDEX idx_missions_category ON public.missions (profession_id);
CREATE INDEX idx_proposals_mission ON public.proposals (mission_id);
CREATE INDEX idx_proposals_expert ON public.proposals (expert_id);
CREATE INDEX idx_contracts_mission ON public.contracts (mission_id);
CREATE INDEX idx_contracts_client ON public.contracts (client_id);
CREATE INDEX idx_contracts_expert ON public.contracts (expert_id);
CREATE INDEX idx_reviews_expert ON public.reviews (expert_id);
CREATE INDEX idx_reviews_client ON public.reviews (client_id);
CREATE INDEX idx_reviews_mission ON public.reviews (mission_id);
CREATE INDEX idx_reviews_contract ON public.reviews (contract_id);
CREATE INDEX idx_public_reviews ON public.reviews (is_public) WHERE is_public = TRUE;
CREATE INDEX idx_messages_conversation ON public.messages (conversation_id);
CREATE INDEX idx_notifications_profile ON public.notifications (profile_id);

-- ===========================================
-- PHASE 4: SÉCURITÉ (RLS)
-- ===========================================

-- Activer RLS sur toutes les tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_professions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.experts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- Exemples de politiques RLS basiques (à adapter selon vos besoins)
CREATE POLICY "Lecture publique des profils"
ON public.profiles FOR SELECT
USING (auth.role() = 'authenticated');

CREATE POLICY "Modification de son propre profil"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "Lecture publique des services"
ON public.services FOR SELECT
USING (true);

CREATE POLICY "Lecture publique des catégories"
ON public.service_professions FOR SELECT
USING (true);

-- Permettre à un utilisateur authentifié de créer son propre profil
CREATE POLICY "Users can create their own profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Permettre à un utilisateur de lire son propre profil
CREATE POLICY "Users can read their own profile"
ON public.profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Permettre à un utilisateur de mettre à jour son propre profil
CREATE POLICY "Users can update their own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id);

-- Créer des politiques pour les app_settings
CREATE POLICY "Les paramètres publics sont lisibles par tous"
ON public.app_settings FOR SELECT
USING (is_public = true);

CREATE POLICY "Les administrateurs peuvent gérer tous les paramètres"
ON public.app_settings
USING (auth.jwt() ->> 'role' = 'service_role' OR auth.jwt() ->> 'role' = 'admin');
-- Ajouter cette politique si elle n'existe pas déjà
CREATE POLICY "Les compétences sont visibles par tous" 
ON public.skills 
FOR SELECT 
USING (true);

---VUE---

-- Création de la vue mission_details pour l'administration
CREATE OR REPLACE VIEW mission_details AS
SELECT 
    r.id,
    r.title,
    r.description,
    r.budget,
    r.deadline,
    r.location,
    r.is_urgent,
    r.created_at,
    r.updated_at,
    r.status,
    r.profession_id,
    r.client_id,
    
    -- Informations sur le client
    p.first_name AS client_first_name,
    p.last_name AS client_last_name,
    p.avatar_url AS client_avatar_url,
    CONCAT(p.first_name, ' ', p.last_name) AS client_name,
    u.email AS client_email,
    
    -- Informations sur la catégorie
    c.name AS category_name,
    c.icon AS category_icon,
    c.color AS category_color,
    
    -- Statistiques
    (SELECT COUNT(*) FROM proposals WHERE mission_id = r.id) AS proposals_count,
    
    -- Compétences requises (si stockées en JSON)
    r.skills,
    
    -- Statuts calculés
    CASE 
        WHEN r.deadline < NOW() AND r.status = 'open' THEN true
        ELSE false
    END AS is_expired,
    
    -- Temps restant
    CASE
        WHEN r.deadline > NOW() THEN 
            EXTRACT(DAY FROM r.deadline - NOW())
        ELSE 0
    END AS days_remaining
FROM 
    missions r
LEFT JOIN 
    profiles p ON r.client_id = p.id
LEFT JOIN 
    auth.users u ON p.id = u.id
LEFT JOIN 
    service_professions c ON r.profession_id = c.id;

-- Ajouter les autorisations nécessaires
ALTER VIEW mission_details OWNER TO postgres;
GRANT SELECT ON mission_details TO service_role;
GRANT SELECT ON mission_details TO anon;
GRANT SELECT ON mission_details TO authenticated;

-- ===========================================
-- PHASE 5: DONNÉES INITIALES
-- ===========================================

-- Réactiver les contraintes
SET session_replication_role = 'origin';

-- Insertion des catégories de services initiales
INSERT INTO public.service_professions (id, name, icon, description)
SELECT uuid_generate_v4(), name, icon, description
FROM (VALUES
    ('Ménage', '🧹', 'Services de nettoyage et d''entretien'),
    ('Jardinage', '🌱', 'Entretien et aménagement de jardins'),
    ('Bricolage', '🔨', 'Petits travaux et réparations'),
    ('Garde d''enfants', '👶', 'Services de garde et d''accompagnement d''enfants'),
    ('Cours particuliers', '📚', 'Enseignement et soutien scolaire'),
    ('Informatique', '💻', 'Assistance et dépannage informatique')
) AS data(name, icon, description)
WHERE NOT EXISTS (
    SELECT 1 FROM public.service_professions WHERE name = data.name
);

-- Insertion des compétences initiales
INSERT INTO public.skills (id, name, icon) 
SELECT uuid_generate_v4(), name, icon
FROM (VALUES
    ('Informatique', '💻'),
    ('Photographie', '📷'),
    ('Cuisine', '🍳'),
    ('Jardinage', '🌱'),
    ('Bricolage', '🔨'),
    ('Langues étrangères', '🌍'),
    ('Musique', '🎵'),
    ('Sport', '🏃‍♂️'),
    ('Art', '🎨'),
    ('Enseignement', '📚')
) AS data(name, icon)
WHERE NOT EXISTS (
    SELECT 1 FROM public.skills WHERE name = data.name
);

-- Insertion des paramètres d'application
INSERT INTO public.app_settings (key, value, description, is_public)
VALUES
('site_name', '"Sénégal Services"', 'Nom du site', true),
('contact_email', '"contact@senegal-services.com"', 'Email de contact', true),
('maintenance_mode', 'false', 'Mode maintenance du site', true),
('currency', '"XOF"', 'Devise par défaut', true),
('platform_fee_percent', '5', 'Pourcentage de commission de la plateforme', false),
('default_mission_duration_days', '30', 'Durée par défaut pour les demandes (jours)', true),
('featured_professions', '["1", "2", "3"]', 'IDs des catégories mises en avant', true),
('max_proposal_count', '5', 'Nombre maximum de propositions par expert par jour', false)
ON CONFLICT (key) DO NOTHING; 

-- Insertion des services courants
INSERT INTO public.services (id, name, description, profession_id, icon) 
SELECT 
  uuid_generate_v4(), 
  name, 
  description, 
  (SELECT id FROM service_professions WHERE name = category_name LIMIT 1),
  icon
FROM (VALUES
  ('Ménage complet', 'Nettoyage complet de votre domicile, incluant sols, surfaces et salle de bain', 'Ménage', '🧹'),
  ('Repassage', 'Service de repassage de vos vêtements et linges de maison', 'Ménage', '👕'),
  ('Entretien jardin', 'Tonte, taille et entretien général de votre jardin', 'Jardinage', '🌱'),
  ('Plomberie', 'Réparation et installation de robinetterie et canalisations', 'Bricolage', '🚿'),
  ('Électricité', 'Installation et dépannage électrique', 'Bricolage', '💡'),
  ('Peinture', 'Travaux de peinture intérieure et extérieure', 'Bricolage', '🎨'),
  ('Garde d''enfants', 'Garde d''enfants à votre domicile', 'Garde d''enfants', '👶'),
  ('Soutien scolaire', 'Aide aux devoirs et cours particuliers', 'Cours particuliers', '📚'),
  ('Assistance informatique', 'Dépannage et configuration de vos appareils', 'Informatique', '💻'),
  ('Montage de meubles', 'Assemblage de meubles en kit', 'Bricolage', '🪑')
) AS data(name, description, category_name, icon);

-- Insertion des compétences initiales avec UUID généré
INSERT INTO public.skills (id, name, icon) VALUES
  (uuid_generate_v4(), 'Ménage', '🧹'),
  (uuid_generate_v4(), 'Repassage', '👕'),
  (uuid_generate_v4(), 'Jardinage', '🌱'),
  (uuid_generate_v4(), 'Tonte de pelouse', '🌿'),
  (uuid_generate_v4(), 'Bricolage', '🔨'),
  (uuid_generate_v4(), 'Plomberie', '🚿'),
  (uuid_generate_v4(), 'Électricité', '💡'),
  (uuid_generate_v4(), 'Peinture', '🎨'),
  (uuid_generate_v4(), 'Garde d''enfants', '👶'),
  (uuid_generate_v4(), 'Cours particuliers', '📚'),
  (uuid_generate_v4(), 'Aide aux devoirs', '📝'),
  (uuid_generate_v4(), 'Assistance informatique', '💻'),
  (uuid_generate_v4(), 'Réparation smartphone', '📱'),
  (uuid_generate_v4(), 'Montage de meubles', '🪑'),
  (uuid_generate_v4(), 'Déménagement', '📦'),
  (uuid_generate_v4(), 'Aide administrative', '📋'),
  (uuid_generate_v4(), 'Cuisine', '🍳'),
  (uuid_generate_v4(), 'Cours de langue', '🗣️'),
  (uuid_generate_v4(), 'Photographie', '📷'),
  (uuid_generate_v4(), 'Coiffure à domicile', '💇');

-- Politique pour la table experts
CREATE POLICY "Les experts peuvent créer leur propre profil expert" 
ON public.experts 
FOR INSERT 
WITH CHECK (auth.uid() = id);

CREATE POLICY "Les utilisateurs peuvent voir tous les experts" 
ON public.experts 
FOR SELECT 
USING (true);

CREATE POLICY "Les experts peuvent modifier leur propre profil" 
ON public.experts 
FOR UPDATE 
USING (auth.uid() = id);

-- Politique pour profile_skills
CREATE POLICY "Les utilisateurs peuvent gérer leurs propres compétences" 
ON public.profile_skills 
FOR ALL 
USING (auth.uid() = profile_id);

-- Politique pour expert_services
CREATE POLICY "Les experts peuvent gérer leurs propres services" 
ON public.expert_services 
FOR ALL 
USING (auth.uid() = expert_id);