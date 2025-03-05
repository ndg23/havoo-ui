-- Schéma SQL pour Supabase
-- Ce fichier contient toutes les tables nécessaires pour l'application

-- Activation de l'extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Configuration RLS (Row Level Security)
ALTER DATABASE postgres SET "app.jwt_secret" TO 'votre_secret_jwt';

-- ===============================
-- TABLES PRINCIPALES
-- ===============================

-- Table des utilisateurs (extension de auth.users)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    birthdate DATE,
    gender VARCHAR(20),
    bio TEXT,
    profile_image_url TEXT,
    banner_image_url TEXT,
    is_expert BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des compétences
CREATE TABLE public.skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table de liaison utilisateurs-compétences
CREATE TABLE public.profile_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES public.skills(id) ON DELETE CASCADE,
    level VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(profile_id, skill_id)
);

-- Table des catégories de services
CREATE TABLE public.service_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des services
CREATE TABLE public.services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES public.service_categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des experts (extension de profiles)
CREATE TABLE public.experts (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    bio TEXT,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    verification_status VARCHAR(50) DEFAULT 'pending',
    average_rating DECIMAL(3, 2),
    review_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table de liaison experts-services
CREATE TABLE public.expert_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES public.services(id) ON DELETE CASCADE,
    price_per_hour DECIMAL(10, 2),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(expert_id, service_id)
);

-- Table des demandes de service
CREATE TABLE public.requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES public.services(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location TEXT NOT NULL,
    date DATE,
    time TIME,
    duration INTEGER, -- en minutes
    budget DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'active', -- active, pending, completed, cancelled
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des propositions (réponses aux demandes)
CREATE TABLE public.proposals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID NOT NULL REFERENCES public.requests(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    price DECIMAL(10, 2) NOT NULL,
    message TEXT,
    status VARCHAR(50) DEFAULT 'pending', -- pending, accepted, rejected
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(request_id, expert_id)
);

-- Table des contrats
CREATE TABLE public.contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID NOT NULL REFERENCES public.requests(id) ON DELETE CASCADE,
    proposal_id UUID NOT NULL REFERENCES public.proposals(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, active, completed, cancelled
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des paiements
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID NOT NULL REFERENCES public.contracts(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending', -- pending, completed, failed, refunded
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des avis
CREATE TABLE public.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID NOT NULL REFERENCES public.contracts(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(contract_id)
);

-- Table des favoris
CREATE TABLE public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES public.experts(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(client_id, expert_id)
);

-- ===============================
-- TABLES SECONDAIRES
-- ===============================

-- Table des conversations
CREATE TABLE public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.requests(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des participants aux conversations
CREATE TABLE public.conversation_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(conversation_id, profile_id)
);

-- Table des messages
CREATE TABLE public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- message, proposal, review, payment, etc.
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    related_id UUID, -- ID de l'objet lié (message, demande, etc.)
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des activités
CREATE TABLE public.activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- request, favorite, message, payment, review, etc.
    description TEXT NOT NULL,
    related_id UUID, -- ID de l'objet lié
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des sessions
CREATE TABLE public.sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    device VARCHAR(255),
    browser VARCHAR(255),
    ip_address VARCHAR(50),
    location VARCHAR(255),
    last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des paramètres utilisateur
CREATE TABLE public.user_settings (
    id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    email_notifications BOOLEAN DEFAULT TRUE,
    push_notifications BOOLEAN DEFAULT TRUE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    language VARCHAR(10) DEFAULT 'fr',
    theme VARCHAR(20) DEFAULT 'light',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===============================
-- VUES
-- ===============================

-- Vue des experts avec leurs services
CREATE VIEW public.expert_profiles AS
SELECT 
    p.id,
    p.first_name,
    p.last_name,
    p.email,
    p.phone,
    p.address,
    p.city,
    p.country,
    p.profile_image_url,
    e.bio,
    e.hourly_rate,
    e.availability_status,
    e.verification_status,
    e.average_rating,
    e.review_count,
    ARRAY_AGG(DISTINCT s.id) AS service_ids,
    ARRAY_AGG(DISTINCT s.name) AS service_names,
    ARRAY_AGG(DISTINCT sk.id) AS skill_ids,
    ARRAY_AGG(DISTINCT sk.name) AS skill_names
FROM 
    public.profiles p
JOIN 
    public.experts e ON p.id = e.id
LEFT JOIN 
    public.expert_services es ON e.id = es.expert_id
LEFT JOIN 
    public.services s ON es.service_id = s.id
LEFT JOIN 
    public.profile_skills ps ON p.id = ps.profile_id
LEFT JOIN 
    public.skills sk ON ps.skill_id = sk.id
GROUP BY 
    p.id, e.id;

-- Vue des demandes avec détails
CREATE VIEW public.request_details AS
SELECT 
    r.id,
    r.title,
    r.description,
    r.location,
    r.date,
    r.time,
    r.duration,
    r.budget,
    r.status,
    r.created_at,
    s.id AS service_id,
    s.name AS service_name,
    s.icon AS service_icon,
    p.id AS client_id,
    p.first_name AS client_first_name,
    p.last_name AS client_last_name,
    p.profile_image_url AS client_image,
    COUNT(pr.id) AS proposal_count
FROM 
    public.requests r
JOIN 
    public.services s ON r.service_id = s.id
JOIN 
    public.profiles p ON r.client_id = p.id
LEFT JOIN 
    public.proposals pr ON r.id = pr.request_id
GROUP BY 
    r.id, s.id, p.id;

-- ===============================
-- FONCTIONS
-- ===============================

-- Fonction pour mettre à jour la note moyenne d'un expert
CREATE OR REPLACE FUNCTION update_expert_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.experts
    SET 
        average_rating = (
            SELECT AVG(rating)::DECIMAL(3,2)
            FROM public.reviews
            WHERE expert_id = NEW.expert_id
        ),
        review_count = (
            SELECT COUNT(*)
            FROM public.reviews
            WHERE expert_id = NEW.expert_id
        ),
        updated_at = NOW()
    WHERE id = NEW.expert_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer une activité
CREATE OR REPLACE FUNCTION create_activity(
    p_profile_id UUID,
    p_type VARCHAR,
    p_description TEXT,
    p_related_id UUID
)
RETURNS UUID AS $$
DECLARE
    v_activity_id UUID;
BEGIN
    INSERT INTO public.activities (profile_id, type, description, related_id)
    VALUES (p_profile_id, p_type, p_description, p_related_id)
    RETURNING id INTO v_activity_id;
    
    RETURN v_activity_id;
END;
$$ LANGUAGE plpgsql;

-- ===============================
-- TRIGGERS
-- ===============================

-- Trigger pour mettre à jour la note moyenne après un avis
CREATE TRIGGER after_review_insert_or_update
AFTER INSERT OR UPDATE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION update_expert_rating();

-- Trigger pour mettre à jour la date de modification
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger de mise à jour à toutes les tables pertinentes
CREATE TRIGGER update_profiles_modtime
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_experts_modtime
BEFORE UPDATE ON public.experts
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_requests_modtime
BEFORE UPDATE ON public.requests
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_proposals_modtime
BEFORE UPDATE ON public.proposals
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_contracts_modtime
BEFORE UPDATE ON public.contracts
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- ===============================
-- POLITIQUES RLS (Row Level Security)
-- ===============================

-- Activer RLS sur toutes les tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.experts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Politique pour les profils (chaque utilisateur peut voir son profil)
CREATE POLICY profiles_select_policy ON public.profiles
FOR SELECT USING (
    auth.uid() = id OR
    auth.uid() IN (SELECT id FROM public.profiles WHERE is_expert = true) OR
    auth.uid() IN (SELECT id FROM auth.users WHERE auth.role() = 'authenticated')
);

CREATE POLICY profiles_update_policy ON public.profiles
FOR UPDATE USING (auth.uid() = id);

-- Politique pour les demandes
CREATE POLICY requests_select_policy ON public.requests
FOR SELECT USING (
    auth.uid() = client_id OR
    auth.uid() IN (SELECT id FROM public.experts) OR
    auth.uid() IN (SELECT id FROM auth.users WHERE auth.role() = 'authenticated')
);

CREATE POLICY requests_insert_policy ON public.requests
FOR INSERT WITH CHECK (auth.uid() = client_id);

CREATE POLICY requests_update_policy ON public.requests
FOR UPDATE USING (auth.uid() = client_id);

CREATE POLICY requests_delete_policy ON public.requests
FOR DELETE USING (auth.uid() = client_id);

-- Politique pour les propositions
CREATE POLICY proposals_select_policy ON public.proposals
FOR SELECT USING (
    auth.uid() = expert_id OR
    auth.uid() IN (
        SELECT client_id FROM public.requests
        WHERE id = request_id
    )
);

CREATE POLICY proposals_insert_policy ON public.proposals
FOR INSERT WITH CHECK (
    auth.uid() = expert_id AND
    (SELECT status FROM public.requests WHERE id = request_id) = 'active'
);

-- ===============================
-- DONNÉES INITIALES
-- ===============================

-- Insertion des catégories de services
INSERT INTO public.service_categories (name, icon, description) VALUES
('Ménage', '🧹', 'Services de nettoyage et d''entretien'),
('Jardinage', '🌱', 'Entretien et aménagement de jardins'),
('Bricolage', '🔨', 'Petits travaux et réparations'),
('Garde d''enfants', '👶', 'Services de garde et d''accompagnement d''enfants'),
('Cours particuliers', '📚', 'Enseignement et soutien scolaire'),
('Informatique', '💻', 'Assistance et dépannage informatique');

-- Insertion des services
INSERT INTO public.services (category_id, name, icon, description) VALUES
((SELECT id FROM public.service_categories WHERE name = 'Ménage'), 'Ménage régulier', '🧹', 'Nettoyage régulier de votre domicile'),
((SELECT id FROM public.service_categories WHERE name = 'Ménage'), 'Nettoyage ponctuel', '🧽', 'Nettoyage complet pour une occasion spéciale'),
((SELECT id FROM public.service_categories WHERE name = 'Jardinage'), 'Tonte de pelouse', '🌿', 'Tonte et entretien de votre pelouse'),
((SELECT id FROM public.service_categories WHERE name = 'Jardinage'), 'Taille de haies', '✂️', 'Taille et mise en forme de vos haies et arbustes'),
((SELECT id FROM public.service_categories WHERE name = 'Bricolage'), 'Plomberie', '🚿', 'Réparation et installation de plomberie'),
((SELECT id FROM public.service_categories WHERE name = 'Bricolage'), 'Électricité', '💡', 'Installation et dépannage électrique'),
((SELECT id FROM public.service_categories WHERE name = 'Garde d''enfants'), 'Garde régulière', '👶', 'Garde d''enfants à domicile'),
((SELECT id FROM public.service_categories WHERE name = 'Garde d''enfants'), 'Garde occasionnelle', '🧸', 'Garde ponctuelle pour vos sorties');

-- Insertion des compétences
INSERT INTO public.skills (name, icon) VALUES
('Informatique', '💻'),
('Photographie', '📷'),
('Cuisine', '🍳'),
('Jardinage', '🌱'),
('Bricolage', '🔨'),
('Langues étrangères', '🌍'),
('Musique', '🎵'),
('Sport', '🏃‍♂️'),
('Art', '🎨'),
('Enseignement', '📚'); 