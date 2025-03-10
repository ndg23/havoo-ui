-- Création du schéma simplifié pour l'application de mise en relation de services

-- Fonction pour mettre à jour automatiquement la date de modification
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Table des utilisateurs (unifie profiles et experts)
CREATE TABLE users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    location TEXT,
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Sénégal',
    zip_code VARCHAR(20),
    birthdate DATE,
    gender VARCHAR(20),
    proof_address TEXT,
    rating DECIMAL(3,2),
    reviews_count INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10, 2),
    availability_status VARCHAR(50) DEFAULT 'available',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    role VARCHAR(20) NOT NULL DEFAULT 'client' CHECK (role IN ('client', 'expert', 'admin'));
);

-- Trigger pour mettre à jour la date de modification des utilisateurs
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des catégories de services
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour la date de modification des catégories
CREATE TRIGGER update_categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des services proposés
CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    price DECIMAL(10, 2) NOT NULL,
    price_type TEXT NOT NULL CHECK (price_type IN ('hourly', 'fixed')),
    location TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'draft', 'paused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour la date de modification des services
CREATE TRIGGER update_services_updated_at
BEFORE UPDATE ON services
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des demandes de services
CREATE TABLE requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    budget DECIMAL(10, 2),
    location TEXT,
    deadline DATE,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'completed', 'cancelled')),
    is_urgent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour la date de modification des demandes
CREATE TRIGGER update_requests_updated_at
BEFORE UPDATE ON requests
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des propositions des experts
CREATE TABLE proposals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    estimated_duration TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(request_id, expert_id)
);

-- Trigger pour mettre à jour la date de modification des propositions
CREATE TRIGGER update_proposals_updated_at
BEFORE UPDATE ON proposals
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des avis
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    request_id UUID REFERENCES requests(id) ON DELETE SET NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(client_id, expert_id, request_id)
);

-- Table des messages
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    request_id UUID REFERENCES requests(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des compétences
CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour la date de modification des compétences
CREATE TRIGGER update_skills_updated_at
BEFORE UPDATE ON skills
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table de jonction entre utilisateurs et compétences
CREATE TABLE user_skills (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    level INTEGER CHECK (level BETWEEN 1 AND 5), -- Niveau optionnel de compétence (1-5)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (user_id, skill_id)
);

-- Index pour améliorer les performances des recherches par compétence
CREATE INDEX idx_user_skills_user ON user_skills(user_id);
CREATE INDEX idx_user_skills_skill ON user_skills(skill_id);

-- Création des index pour améliorer les performances
CREATE INDEX idx_services_user ON services(user_id);
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_requests_client ON requests(client_id);
CREATE INDEX idx_requests_category ON requests(category_id);
CREATE INDEX idx_requests_status ON requests(status);
CREATE INDEX idx_proposals_request ON proposals(request_id);
CREATE INDEX idx_proposals_expert ON proposals(expert_id);
CREATE INDEX idx_reviews_expert ON reviews(expert_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_receiver ON messages(receiver_id);
CREATE INDEX idx_messages_request ON messages(request_id);

-- Vue pour afficher les détails des demandes avec les informations du client et de la catégorie
CREATE OR REPLACE VIEW request_details AS
SELECT 
    r.id,
    r.title,
    r.description,
    r.budget,
    r.location,
    r.deadline,
    r.status,
    r.is_urgent,
    r.created_at,
    r.updated_at,
    u.id AS client_id,
    u.first_name || ' ' || u.last_name AS client_name,
    u.avatar_url AS client_avatar,
    c.id AS category_id,
    c.name AS category_name,
    c.icon AS category_icon,
    (SELECT COUNT(*) FROM proposals p WHERE p.request_id = r.id) AS proposals_count
FROM 
    requests r
JOIN 
    users u ON r.client_id = u.id
JOIN 
    categories c ON r.category_id = c.id;

-- Vue pour afficher les profils des experts avec leurs compétences
CREATE OR REPLACE VIEW expert_profiles AS
SELECT 
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    u.avatar_url,
    u.bio,
    u.phone,
    u.location,
    u.hourly_rate,
    u.created_at,
    (SELECT COUNT(*) FROM services s WHERE s.user_id = u.id) AS services_count,
    (SELECT COUNT(*) FROM proposals p WHERE p.expert_id = u.id) AS proposals_count,
    (SELECT COUNT(*) FROM proposals p WHERE p.expert_id = u.id AND p.status = 'accepted') AS accepted_proposals_count,
    (SELECT AVG(r.rating) FROM reviews r WHERE r.expert_id = u.id) AS average_rating,
    (SELECT COUNT(*) FROM reviews r WHERE r.expert_id = u.id) AS reviews_count,
    (SELECT COUNT(*) FROM user_skills us WHERE us.user_id = u.id) AS skills_count,
    (SELECT array_agg(s.name) FROM skills s JOIN user_skills us ON s.id = us.skill_id WHERE us.user_id = u.id) AS skills
FROM 
    users u
WHERE 
    u.role = 'expert';

-- Fonction pour calculer la note moyenne d'un expert
CREATE OR REPLACE FUNCTION get_expert_rating(expert_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    avg_rating DECIMAL;
BEGIN
    SELECT AVG(rating) INTO avg_rating
    FROM reviews
    WHERE expert_id = $1;
    
    RETURN COALESCE(avg_rating, 0);
END;
$$ LANGUAGE plpgsql;

-- Fonction améliorée pour rechercher des experts par compétence et localisation
CREATE OR REPLACE FUNCTION search_experts(search_term TEXT, location_filter TEXT, skill_id UUID DEFAULT NULL)
RETURNS TABLE (
    id UUID,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    location TEXT,
    hourly_rate DECIMAL,
    average_rating DECIMAL,
    services_count BIGINT,
    skills_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.first_name,
        u.last_name,
        u.avatar_url,
        u.bio,
        u.location,
        u.hourly_rate,
        get_expert_rating(u.id) AS average_rating,
        (SELECT COUNT(*) FROM services s WHERE s.user_id = u.id) AS services_count,
        (SELECT COUNT(*) FROM user_skills us WHERE us.user_id = u.id) AS skills_count
    FROM 
        users u
    WHERE 
        u.role = 'expert'
        AND (
            search_term IS NULL 
            OR u.bio ILIKE '%' || search_term || '%'
            OR EXISTS (
                SELECT 1 FROM services s 
                WHERE s.user_id = u.id 
                AND (s.title ILIKE '%' || search_term || '%' OR s.description ILIKE '%' || search_term || '%')
            )
        )
        AND (
            location_filter IS NULL
            OR u.location ILIKE '%' || location_filter || '%'
        )
        AND (
            skill_id IS NULL
            OR EXISTS (
                SELECT 1 FROM user_skills us 
                WHERE us.user_id = u.id AND us.skill_id = skill_id
            )
        )
    ORDER BY 
        average_rating DESC;
END;
$$ LANGUAGE plpgsql;

-- Table pour suivre les vues de services/demandes
CREATE TABLE views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    service_id UUID REFERENCES services(id) ON DELETE CASCADE,
    request_id UUID REFERENCES requests(id) ON DELETE CASCADE,
    viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CHECK ((service_id IS NULL) != (request_id IS NULL)) -- Soit service_id, soit request_id doit être non-null
);

-- Ajouter des index GIN pour la recherche textuelle
CREATE INDEX idx_services_fulltext ON services USING gin(to_tsvector('french', title || ' ' || description));
CREATE INDEX idx_requests_fulltext ON requests USING gin(to_tsvector('french', title || ' ' || description));

-- Créer un index sur le rôle pour des recherches efficaces
CREATE INDEX idx_users_role ON users(role);
