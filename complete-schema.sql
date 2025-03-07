-- ===============================
-- SCHÉMA SUPABASE COMPLET 
-- Version améliorée pour éviter les erreurs de relations
-- ===============================
\set ON_ERROR_STOP on
\set VERBOSITY verbose

-- Désactiver temporairement les contraintes pour permettre la réinitialisation
SET session_replication_role = 'replica';

-- ===============================
-- PARTIE 1: NETTOYAGE DES TABLES EXISTANTES
-- ===============================

-- Supprimer les triggers personnalisés
DROP TRIGGER IF EXISTS update_profiles_modtime ON public.profiles;
DROP TRIGGER IF EXISTS update_experts_modtime ON public.experts;
DROP TRIGGER IF EXISTS update_requests_modtime ON public.requests;
DROP TRIGGER IF EXISTS update_proposals_modtime ON public.proposals;
DROP TRIGGER IF EXISTS update_contracts_modtime ON public.contracts;
DROP TRIGGER IF EXISTS after_review_insert ON public.reviews;
DROP TRIGGER IF EXISTS after_review_delete ON public.reviews;
DROP TRIGGER IF EXISTS update_review_responses_updated_at ON public.review_responses;
DROP TRIGGER IF EXISTS update_expert_certifications_updated_at ON public.expert_certifications;
DROP TRIGGER IF EXISTS notify_after_proposal_accepted ON public.proposals;

-- Supprimer les fonctions personnalisées
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS update_expert_stats() CASCADE;
DROP FUNCTION IF EXISTS create_notification() CASCADE;
DROP FUNCTION IF EXISTS notify_proposal_accepted() CASCADE;
DROP FUNCTION IF EXISTS calculate_average_response_time() CASCADE;
DROP FUNCTION IF EXISTS generate_invitation_code() CASCADE;
DROP FUNCTION IF EXISTS create_expert_invitation() CASCADE;
DROP FUNCTION IF EXISTS validate_expert_invitation() CASCADE;
DROP FUNCTION IF EXISTS get_expert_earnings() CASCADE;
DROP FUNCTION IF EXISTS search_experts_by_skill_location() CASCADE;
DROP FUNCTION IF EXISTS get_expert_availability() CASCADE;

-- Supprimer les index problématiques
DROP INDEX IF EXISTS idx_public_reviews;
DROP INDEX IF EXISTS idx_reviews_expert_id;
DROP INDEX IF EXISTS idx_reviews_request_id;

-- Supprimer toutes les tables dans le bon ordre
DROP TABLE IF EXISTS public.review_reactions CASCADE;
DROP TABLE IF EXISTS public.review_responses CASCADE;
DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.payments CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.conversation_participants CASCADE;
DROP TABLE IF EXISTS public.conversations CASCADE;
DROP TABLE IF EXISTS public.contracts CASCADE;
DROP TABLE IF EXISTS public.proposals CASCADE;
DROP TABLE IF EXISTS public.requests CASCADE;
DROP TABLE IF EXISTS public.expert_certifications CASCADE;
DROP TABLE IF EXISTS public.expert_invitations CASCADE;
DROP TABLE IF EXISTS public.expert_services CASCADE;
DROP TABLE IF EXISTS public.expert_availability CASCADE;
DROP TABLE IF EXISTS public.expert_expertise CASCADE;
DROP TABLE IF EXISTS public.expert_profiles CASCADE;
DROP TABLE IF EXISTS public.experts CASCADE;
DROP TABLE IF EXISTS public.profile_skills CASCADE;
DROP TABLE IF EXISTS public.services CASCADE;
DROP TABLE IF EXISTS public.service_categories CASCADE;
DROP TABLE IF EXISTS public.skills CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
DROP TABLE IF EXISTS public.activities CASCADE;
DROP TABLE IF EXISTS public.favorites CASCADE;
DROP TABLE IF EXISTS public.app_settings CASCADE;

-- ===============================
-- PARTIE 2: ACTIVATION DES EXTENSIONS
-- ===============================

-- Activation des extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ===============================
-- PARTIE 3: CRÉATION DES TABLES
-- Phase 1 - Créer les tables sans contraintes de clé étrangère
-- ===============================

-- Table de base des utilisateurs
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'France',
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
    proof_address TEXT,
    rating DECIMAL(3,2),
    reviews_count INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compétences
CREATE TABLE IF NOT EXISTS public.skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Catégories de services
CREATE TABLE IF NOT EXISTS public.service_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Services
CREATE TABLE IF NOT EXISTS public.services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID,
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Experts
CREATE TABLE IF NOT EXISTS public.experts (
    id UUID PRIMARY KEY,
    bio TEXT,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    verification_status VARCHAR(50) DEFAULT 'pending',
    average_rating DECIMAL(3, 2),
    review_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Certifications d'experts
CREATE TABLE IF NOT EXISTS public.expert_certifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID,
    name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    issue_date DATE,
    expiry_date DATE,
    issuing_authority VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Demandes
CREATE TABLE IF NOT EXISTS public.requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category_id UUID,
    service_id UUID,
    budget DECIMAL(10, 2),
    location VARCHAR(255),
    deadline TIMESTAMPTZ,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'open',
    is_urgent BOOLEAN DEFAULT false,
    is_public BOOLEAN DEFAULT true,
    resolved_at TIMESTAMPTZ,
    rating INTEGER,
    review TEXT
);

-- Propositions
CREATE TABLE IF NOT EXISTS public.proposals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID,
    expert_id UUID,
    price DECIMAL(10, 2) NOT NULL,
    message TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Contrats
CREATE TABLE IF NOT EXISTS public.contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID,
    proposal_id UUID,
    client_id UUID,
    expert_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'pending',
    terms_accepted BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Avis
CREATE TABLE IF NOT EXISTS public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID,
    expert_id UUID,
    client_id UUID,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    photos JSONB,
    is_public BOOLEAN DEFAULT true,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Réponses aux avis
CREATE TABLE IF NOT EXISTS public.review_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    review_id UUID,
    expert_id UUID,
    response TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Réactions aux avis
CREATE TABLE IF NOT EXISTS public.review_reactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    review_id UUID,
    profile_id UUID,
    is_helpful BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Favorites
CREATE TABLE IF NOT EXISTS public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID,
    expert_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    related_id UUID,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Liaisons profils-compétences
CREATE TABLE IF NOT EXISTS public.profile_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID,
    skill_id UUID,
    level VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Liaisons experts-services
CREATE TABLE IF NOT EXISTS public.expert_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID,
    service_id UUID,
    price_per_hour DECIMAL(10, 2),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversations
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Participants aux conversations
CREATE TABLE IF NOT EXISTS public.conversation_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID,
    profile_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID,
    sender_id UUID,
    content TEXT NOT NULL,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des paramètres d'application
CREATE TABLE IF NOT EXISTS public.app_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(255) NOT NULL UNIQUE,
    value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===============================
-- PARTIE 4: AJOUT DES CONTRAINTES DE CLÉ ÉTRANGÈRE
-- Phase 2 - Ajouter toutes les contraintes
-- ===============================

-- Contrainte profiles -> auth.users
ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_id_fkey 
FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Contraintes pour services
ALTER TABLE public.services
ADD CONSTRAINT services_category_id_fkey
FOREIGN KEY (category_id) REFERENCES public.service_categories(id) ON DELETE CASCADE;

-- Contraintes pour experts
ALTER TABLE public.experts
ADD CONSTRAINT experts_id_fkey
FOREIGN KEY (id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour expert_certifications
ALTER TABLE public.expert_certifications
ADD CONSTRAINT expert_certifications_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour requests
ALTER TABLE public.requests
ADD CONSTRAINT requests_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.requests
ADD CONSTRAINT requests_service_id_fkey
FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE SET NULL;

ALTER TABLE public.requests
ADD CONSTRAINT requests_category_id_fkey
FOREIGN KEY (category_id) REFERENCES public.service_categories(id) ON DELETE SET NULL;

-- Contraintes pour proposals
ALTER TABLE public.proposals
ADD CONSTRAINT proposals_request_id_fkey
FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE CASCADE;

ALTER TABLE public.proposals
ADD CONSTRAINT proposals_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour contracts
ALTER TABLE public.contracts
ADD CONSTRAINT contracts_request_id_fkey
FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE SET NULL;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_proposal_id_fkey
FOREIGN KEY (proposal_id) REFERENCES public.proposals(id) ON DELETE SET NULL;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.contracts
ADD CONSTRAINT contracts_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour reviews
ALTER TABLE public.reviews
ADD CONSTRAINT reviews_request_id_fkey
FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE SET NULL;

ALTER TABLE public.reviews
ADD CONSTRAINT reviews_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.reviews
ADD CONSTRAINT reviews_client_id_fkey
FOREIGN KEY (client_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour review_responses
ALTER TABLE public.review_responses
ADD CONSTRAINT review_responses_review_id_fkey
FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;

ALTER TABLE public.review_responses
ADD CONSTRAINT review_responses_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour review_reactions
ALTER TABLE public.review_reactions
ADD CONSTRAINT review_reactions_review_id_fkey
FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE CASCADE;

ALTER TABLE public.review_reactions
ADD CONSTRAINT review_reactions_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour favorites
ALTER TABLE public.favorites
ADD CONSTRAINT favorites_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.favorites
ADD CONSTRAINT favorites_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour notifications
ALTER TABLE public.notifications
ADD CONSTRAINT notifications_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour profile_skills
ALTER TABLE public.profile_skills
ADD CONSTRAINT profile_skills_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.profile_skills
ADD CONSTRAINT profile_skills_skill_id_fkey
FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;

ALTER TABLE public.profile_skills
ADD CONSTRAINT profile_skills_unique_constraint
UNIQUE (profile_id, skill_id);

-- Contraintes pour expert_services
ALTER TABLE public.expert_services
ADD CONSTRAINT expert_services_expert_id_fkey
FOREIGN KEY (expert_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.expert_services
ADD CONSTRAINT expert_services_service_id_fkey
FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;

ALTER TABLE public.expert_services
ADD CONSTRAINT expert_services_unique_constraint
UNIQUE (expert_id, service_id);

-- Contraintes pour conversation_participants
ALTER TABLE public.conversation_participants
ADD CONSTRAINT conversation_participants_conversation_id_fkey
FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;

ALTER TABLE public.conversation_participants
ADD CONSTRAINT conversation_participants_profile_id_fkey
FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- Contraintes pour messages
ALTER TABLE public.messages
ADD CONSTRAINT messages_conversation_id_fkey
FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;

ALTER TABLE public.messages
ADD CONSTRAINT messages_sender_id_fkey
FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- ===============================
-- PARTIE 5: FONCTIONS ET TRIGGERS
-- ===============================

-- Fonction pour mettre à jour le champ updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour les statistiques d'expert
CREATE OR REPLACE FUNCTION update_expert_stats()
RETURNS TRIGGER AS $$
DECLARE
    v_expert_id UUID;
    v_avg_rating DECIMAL(3,2);
    v_review_count INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_expert_id := OLD.expert_id;
    ELSE
        v_expert_id := NEW.expert_id;
    END IF;
    
    -- Calculer la note moyenne
    SELECT AVG(rating)::DECIMAL(3,2), COUNT(*)
    INTO v_avg_rating, v_review_count
    FROM public.reviews
    WHERE expert_id = v_expert_id AND is_public = true;
    
    -- Mettre à jour le profil de l'expert
    UPDATE public.profiles
    SET rating = v_avg_rating,
        reviews_count = v_review_count
    WHERE id = v_expert_id;
    
    -- Mettre à jour la table experts si elle existe
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'experts') THEN
        UPDATE public.experts
        SET average_rating = v_avg_rating,
            review_count = v_review_count
        WHERE id = v_expert_id;
    END IF;
    
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

-- ===============================
-- PARTIE 6: TRIGGERS
-- ===============================

-- Trigger pour updated_at sur profiles
CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON public.profiles
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

-- Trigger pour updated_at sur reviews
CREATE TRIGGER update_reviews_updated_at
BEFORE UPDATE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour updated_at sur review_responses
CREATE TRIGGER update_review_responses_updated_at
BEFORE UPDATE ON public.review_responses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour updated_at sur expert_certifications
CREATE TRIGGER update_expert_certifications_updated_at
BEFORE UPDATE ON public.expert_certifications
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour updated_at sur app_settings
CREATE TRIGGER update_app_settings_updated_at
BEFORE UPDATE ON public.app_settings
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ===============================
-- PARTIE 7: INDEXATION
-- ===============================

-- Index pour les recherches fréquentes
CREATE INDEX idx_reviews_expert_id ON reviews(expert_id);
CREATE INDEX idx_reviews_request_id ON reviews(request_id);
CREATE INDEX idx_public_reviews ON reviews(is_public) WHERE is_public = true;

-- Index pour la recherche d'experts par compétence
CREATE INDEX idx_profile_skills_skill ON profile_skills(skill_id);
CREATE INDEX idx_profile_skills_profile ON profile_skills(profile_id);

-- Index pour les recherches de services
CREATE INDEX idx_services_category ON services(category_id);

-- ===============================
-- PARTIE 8: POLITIQUES DE SÉCURITÉ (RLS)
-- ===============================

-- Activer RLS sur toutes les tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.experts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expert_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- ==============================================
-- Politique pour les profils
-- ==============================================

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

-- Politique pour les profils
CREATE POLICY "Les profils sont visibles par tous les utilisateurs authentifiés"
ON public.profiles FOR SELECT
USING (auth.role() = 'authenticated');

-- Politique pour les paramètres publics
CREATE POLICY "Les paramètres publics sont lisibles par tous"
ON public.app_settings FOR SELECT
USING (is_public = true);

CREATE POLICY "Les administrateurs peuvent gérer tous les paramètres"
ON public.app_settings
USING (auth.jwt() ->> 'role' = 'service_role' OR auth.jwt() ->> 'role' = 'admin');

-- ===============================
-- PARTIE 9: DONNÉES INITIALES
-- ===============================

-- Réactiver les contraintes
SET session_replication_role = 'origin';

-- Insertion des catégories de services initiales
INSERT INTO public.service_categories (id, name, icon, description)
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
    SELECT 1 FROM public.service_categories WHERE name = data.name
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
('default_request_duration_days', '30', 'Durée par défaut pour les demandes (jours)', true),
('featured_categories', '["1", "2", "3"]', 'IDs des catégories mises en avant', true),
('max_proposal_count', '5', 'Nombre maximum de propositions par expert par jour', false)
ON CONFLICT (key) DO NOTHING; 