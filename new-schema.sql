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

-- Créer un index sur la colonne 'status' de la table 'payments'
CREATE INDEX idx_payments_status ON payments(status);

-- Table des paiements
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    fee DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(255),
    invoice_number VARCHAR(100),
    payment_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour mettre à jour la date de modification des paiements
CREATE TRIGGER update_payments_updated_at
BEFORE UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table de disponibilité des experts
CREATE TABLE expert_availability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    expert_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour la disponibilité des experts
CREATE TRIGGER update_availability_updated_at
BEFORE UPDATE ON expert_availability
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Table des notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('info', 'success', 'warning', 'error')),
    is_read BOOLEAN DEFAULT FALSE,
    entity_type VARCHAR(50),
    entity_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des favoris (experts favoris des clients)
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expert_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(client_id, expert_id)
);

-- Table des paramètres de l'application
CREATE TABLE app_settings (
    id INTEGER PRIMARY KEY CHECK (id = 1), -- Une seule ligne pour les paramètres globaux
    settings JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger pour les paramètres
CREATE TRIGGER update_app_settings_updated_at
BEFORE UPDATE ON app_settings
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Fonction pour créer une notification
CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID,
    p_title VARCHAR(255),
    p_content TEXT,
    p_type VARCHAR(50),
    p_entity_type VARCHAR(50) DEFAULT NULL,
    p_entity_id UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    new_id UUID;
BEGIN
    INSERT INTO notifications (
        user_id, title, content, type, entity_type, entity_id
    ) VALUES (
        p_user_id, p_title, p_content, p_type, p_entity_type, p_entity_id
    ) RETURNING id INTO new_id;
    
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour notifier l'expert quand sa proposition est acceptée
CREATE OR REPLACE FUNCTION notify_on_proposal_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
        PERFORM create_notification(
            NEW.expert_id,
            'Proposition acceptée',
            'Votre proposition a été acceptée par le client.',
            'success',
            'proposal',
            NEW.id
        );
        
        -- Notifier aussi le client
        PERFORM create_notification(
            (SELECT client_id FROM requests WHERE id = NEW.request_id),
            'Confirmation d''expert',
            'Vous avez accepté une proposition d''expert.',
            'info',
            'proposal',
            NEW.id
        );
    ELSIF NEW.status = 'rejected' AND OLD.status != 'rejected' THEN
        PERFORM create_notification(
            NEW.expert_id,
            'Proposition refusée',
            'Votre proposition n''a pas été retenue par le client.',
            'warning',
            'proposal',
            NEW.id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER proposal_status_notification_trigger
AFTER UPDATE OF status ON proposals
FOR EACH ROW
EXECUTE FUNCTION notify_on_proposal_status_change();

-- Index pour optimiser les recherches supplémentaires
CREATE INDEX idx_payments_request ON payments(request_id);
CREATE INDEX idx_payments_client ON payments(client_id);
CREATE INDEX idx_payments_expert ON payments(expert_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_expert_availability_expert ON expert_availability(expert_id);
CREATE INDEX idx_favorites_client ON favorites(client_id);
CREATE INDEX idx_favorites_expert ON favorites(expert_id);

-- Suppression des données de test explicites avec IDs et restructuration

-- Insertion de quelques catégories
INSERT INTO categories (name, description, icon) VALUES
('Ménage', 'Services de nettoyage et d''entretien', 'mdi-broom'),
('Bricolage', 'Petits travaux de réparation et d''amélioration', 'mdi-hammer'),
('Jardinage', 'Entretien et aménagement d''espaces verts', 'mdi-flower'),
('Informatique', 'Assistance et dépannage informatique', 'mdi-laptop'),
('Cours particuliers', 'Enseignement et soutien scolaire', 'mdi-school');

-- Définir une fonction temporaire pour insérer des utilisateurs
-- Note: Pour les utilisateurs, vous devrez d'abord les créer via auth.users puis obtenir leurs IDs

-- Fonction pour créer des utilisateurs de test (pour un environnement de développement uniquement)
CREATE OR REPLACE FUNCTION create_test_users() 
RETURNS VOID AS $$
DECLARE
    admin_id UUID;
    expert1_id UUID;
    expert2_id UUID;
    expert3_id UUID;
    client1_id UUID;
    client2_id UUID;
    menage_id UUID;
    bricolage_id UUID;
    jardinage_id UUID;
    informatique_id UUID;
    cours_id UUID;
    nettoyage_skill_id UUID;
    repassage_skill_id UUID;
    peinture_skill_id UUID;
    plomberie_skill_id UUID;
    tonte_skill_id UUID;
    request1_id UUID;
    request2_id UUID;
    request3_id UUID;
BEGIN
    -- Création des utilisateurs (dans un environnement réel, ils seraient créés via auth.users)
    -- Simulation pour le développement uniquement
    INSERT INTO auth.users (email) VALUES 
        ('admin@example.com'),
        ('expert1@example.com'),
        ('expert2@example.com'),
        ('expert3@example.com'),
        ('client1@example.com'),
        ('client2@example.com')
    RETURNING id INTO admin_id;
    
    -- Récupérer leurs IDs (en pratique, il faudrait les récupérer après création)
    SELECT id INTO admin_id FROM auth.users WHERE email = 'admin@example.com';
    SELECT id INTO expert1_id FROM auth.users WHERE email = 'expert1@example.com';
    SELECT id INTO expert2_id FROM auth.users WHERE email = 'expert2@example.com';
    SELECT id INTO expert3_id FROM auth.users WHERE email = 'expert3@example.com';
    SELECT id INTO client1_id FROM auth.users WHERE email = 'client1@example.com';
    SELECT id INTO client2_id FROM auth.users WHERE email = 'client2@example.com';
    
    -- Insérer les profils
    INSERT INTO users (id, email, first_name, last_name, role, avatar_url, bio, phone, location, city, country, reviews_count, hourly_rate) VALUES
    (admin_id, 'admin@example.com', 'Admin', 'Système', 'admin', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', 'Administrateur du système', '+221 77 123 45 67', 'Dakar', 'Dakar', 'Sénégal', 0, NULL),
    (expert1_id, 'expert1@example.com', 'Moussa', 'Diop', 'expert', 'https://api.dicebear.com/7.x/avataaars/svg?seed=expert1', 'Expert en nettoyage et entretien avec 5 ans d''expérience', '+221 77 234 56 78', 'Dakar', 'Dakar', 'Sénégal', 12, 5000),
    (expert2_id, 'expert2@example.com', 'Fatou', 'Ndiaye', 'expert', 'https://api.dicebear.com/7.x/avataaars/svg?seed=expert2', 'Spécialiste en bricolage et réparations', '+221 77 345 67 89', 'Thiès', 'Thiès', 'Sénégal', 8, 6500),
    (expert3_id, 'expert3@example.com', 'Amadou', 'Sow', 'expert', 'https://api.dicebear.com/7.x/avataaars/svg?seed=expert3', 'Jardinier professionnel depuis plus de 10 ans', '+221 77 456 78 90', 'Saint-Louis', 'Saint-Louis', 'Sénégal', 15, 4500),
    (client1_id, 'client1@example.com', 'Omar', 'Samb', 'client', 'https://api.dicebear.com/7.x/avataaars/svg?seed=client1', NULL, '+221 77 567 89 01', 'Dakar', 'Dakar', 'Sénégal', 0, NULL),
    (client2_id, 'client2@example.com', 'Aïda', 'Fall', 'client', 'https://api.dicebear.com/7.x/avataaars/svg?seed=client2', NULL, '+221 77 678 90 12', 'Mbour', 'Mbour', 'Sénégal', 0, NULL);
    
    -- Récupérer les IDs des catégories
    SELECT id INTO menage_id FROM categories WHERE name = 'Ménage';
    SELECT id INTO bricolage_id FROM categories WHERE name = 'Bricolage';
    SELECT id INTO jardinage_id FROM categories WHERE name = 'Jardinage';
    SELECT id INTO informatique_id FROM categories WHERE name = 'Informatique';
    SELECT id INTO cours_id FROM categories WHERE name = 'Cours particuliers';
    
    -- Insertion des compétences
    INSERT INTO skills (name, description, category_id) VALUES
    ('Nettoyage maison', 'Nettoyage complet de maison ou appartement', menage_id) RETURNING id INTO nettoyage_skill_id;
    INSERT INTO skills (name, description, category_id) VALUES
    ('Repassage', 'Service de repassage de vêtements', menage_id) RETURNING id INTO repassage_skill_id;
    INSERT INTO skills (name, description, category_id) VALUES
    ('Peinture', 'Travaux de peinture intérieure et extérieure', bricolage_id) RETURNING id INTO peinture_skill_id;
    INSERT INTO skills (name, description, category_id) VALUES
    ('Plomberie', 'Réparation et installation de plomberie', bricolage_id) RETURNING id INTO plomberie_skill_id;
INSERT INTO skills (name, description, category_id) VALUES
    ('Tonte de pelouse', 'Entretien régulier de pelouse', jardinage_id) RETURNING id INTO tonte_skill_id;

-- Associer des compétences aux experts
INSERT INTO user_skills (user_id, skill_id, level) VALUES
    (expert1_id, nettoyage_skill_id, 5),
    (expert1_id, repassage_skill_id, 4),
    (expert2_id, peinture_skill_id, 5),
    (expert2_id, plomberie_skill_id, 4),
    (expert3_id, tonte_skill_id, 5);

-- Insérer des services proposés par les experts
    INSERT INTO services (title, description, category_id, user_id, price, price_type, location, status) VALUES
    ('Nettoyage complet maison/appartement', 'Service de nettoyage approfondi incluant toutes les pièces de vie, cuisine et sanitaires', menage_id, expert1_id, 3500, 'hourly', 'Dakar', 'active'),
    ('Repassage à domicile', 'Service de repassage professionnel pour tous types de vêtements', menage_id, expert1_id, 2000, 'hourly', 'Dakar', 'active'),
    ('Peinture intérieure', 'Travaux de peinture intérieure pour toutes les pièces de votre logement', bricolage_id, expert2_id, 6000, 'hourly', 'Thiès', 'active'),
    ('Réparation plomberie', 'Réparation de fuites, remplacement de robinets et autres problèmes de plomberie', bricolage_id, expert2_id, 7500, 'fixed', 'Thiès', 'active'),
    ('Entretien jardin complet', 'Service d''entretien complet de jardin : tonte, taille, désherbage', jardinage_id, expert3_id, 4000, 'hourly', 'Saint-Louis', 'active');

-- Insérer des demandes de services
    INSERT INTO requests (title, description, client_id, category_id, budget, location, deadline, status, is_urgent) VALUES
    ('Besoin de nettoyage après déménagement', 'Je viens d''emménager et j''ai besoin d''un nettoyage complet de l''appartement', client1_id, menage_id, 15000, 'Dakar', '2023-12-15', 'open', TRUE) RETURNING id INTO request1_id;
    INSERT INTO requests (title, description, client_id, category_id, budget, location, deadline, status, is_urgent) VALUES
    ('Réparation fuite lavabo', 'Fuite importante sous le lavabo de la salle de bain', client2_id, bricolage_id, 8000, 'Mbour', '2023-12-10', 'open', TRUE) RETURNING id INTO request2_id;
    INSERT INTO requests (title, description, client_id, category_id, budget, location, deadline, status, is_urgent) VALUES
    ('Tonte de pelouse hebdomadaire', 'Recherche jardinier pour entretien régulier de mon jardin', client1_id, jardinage_id, 5000, 'Dakar', '2023-12-20', 'open', FALSE) RETURNING id INTO request3_id;
    
    -- Le reste des insertions suit la même logique...
END;
$$ LANGUAGE plpgsql;

-- Ajouter des données à app_settings sans ID 
INSERT INTO app_settings (settings) VALUES
('{
  "app_name": "ExpertConnect",
  "app_url": "https://expertconnect.sn",
  "contact_email": "contact@expertconnect.sn",
  "platform_fee_percentage": 10,
  "minimum_hourly_rate": 1500,
  "enable_instant_booking": true,
  "max_file_upload_size": 5,
  "enable_notifications": true,
  "default_currency": "XOF",
  "allowed_payment_methods": ["carte", "mobile_money", "cash"],
  "maintenance_mode": false
}');

-- Note: Pour utiliser cette fonction en développement
-- SELECT create_test_users();
