-- Supprimer les politiques RLS existantes (si applicable)
DROP POLICY IF EXISTS "Users can view their own verification" ON expert_verifications;
DROP POLICY IF EXISTS "Users can insert their own verification" ON expert_verifications;
DROP POLICY IF EXISTS "Admins can do everything" ON expert_verifications;

-- Désactiver RLS sur toutes les tables pertinentes
ALTER TABLE IF EXISTS expert_verifications DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS missions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS proposals DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS contracts DISABLE ROW LEVEL SECURITY;

-- Supprimer les triggers existants
DROP TRIGGER IF EXISTS update_profiles_timestamp ON profiles;
DROP TRIGGER IF EXISTS update_missions_timestamp ON missions;
DROP TRIGGER IF EXISTS update_proposals_timestamp ON proposals;
DROP TRIGGER IF EXISTS update_contracts_timestamp ON contracts;
DROP TRIGGER IF EXISTS update_services_timestamp ON services;
DROP TRIGGER IF EXISTS update_payments_timestamp ON payments;
DROP TRIGGER IF EXISTS update_expert_verifications_timestamp ON expert_verifications;
DROP TRIGGER IF EXISTS on_new_proposal ON proposals;
DROP TRIGGER IF EXISTS on_proposal_status_change ON proposals;
DROP TRIGGER IF EXISTS on_new_message ON messages;
DROP TRIGGER IF EXISTS on_expert_verification_update ON expert_verifications;

-- Supprimer les fonctions existantes
DROP FUNCTION IF EXISTS update_timestamp();
DROP FUNCTION IF EXISTS notify_new_proposal();
DROP FUNCTION IF EXISTS notify_proposal_status_change();
DROP FUNCTION IF EXISTS notify_new_message();
DROP FUNCTION IF EXISTS update_expert_status();

-- Supprimer les vues existantes
DROP VIEW IF EXISTS expert_profiles;
DROP VIEW IF EXISTS mission_details;
DROP VIEW IF EXISTS active_contracts;
DROP VIEW IF EXISTS expert_stats;
DROP VIEW IF EXISTS user_conversations;
DROP VIEW IF EXISTS unread_notifications;
DROP VIEW IF EXISTS expert_search;
DROP VIEW IF EXISTS admin_expert_verifications;

-- Nettoyer les données (supprimer dans l'ordre inverse des dépendances)
TRUNCATE TABLE IF EXISTS notifications CASCADE;
TRUNCATE TABLE IF EXISTS payments CASCADE;
TRUNCATE TABLE IF EXISTS reviews CASCADE;
TRUNCATE TABLE IF EXISTS messages CASCADE;
TRUNCATE TABLE IF EXISTS services CASCADE;
TRUNCATE TABLE IF EXISTS contracts CASCADE;
TRUNCATE TABLE IF EXISTS proposals CASCADE;
TRUNCATE TABLE IF EXISTS missions CASCADE;
TRUNCATE TABLE IF EXISTS user_skills CASCADE;
TRUNCATE TABLE IF EXISTS expert_verifications CASCADE;
TRUNCATE TABLE IF EXISTS skills CASCADE;
-- Note: Nous ne vidons pas complètement profiles car cela pourrait être lié à auth.users

-- Réinitialiser les séquences
ALTER SEQUENCE IF EXISTS skills_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS user_skills_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS missions_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS proposals_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS contracts_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS messages_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS services_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS reviews_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS payments_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS notifications_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS expert_verifications_id_seq RESTART WITH 1;

-- Fonction pour mettre à jour les timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour notifier quand une proposition est reçue
CREATE OR REPLACE FUNCTION notify_new_proposal()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notifications (user_id, title, content, type, reference_id, reference_type)
  SELECT 
    r.client_id, 
    'Nouvelle proposition', 
    'Vous avez reçu une nouvelle proposition sur votre demande: ' || r.title,
    'proposal',
    NEW.id,
    'proposal'
  FROM missions r
  WHERE r.id = NEW.mission_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour notifier quand le statut d'une proposition change
CREATE OR REPLACE FUNCTION notify_proposal_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status != OLD.status THEN
    INSERT INTO notifications (user_id, title, content, type, reference_id, reference_type)
    VALUES (
      NEW.expert_id,
      CASE 
        WHEN NEW.status = 'accepted' THEN 'Proposition acceptée'
        WHEN NEW.status = 'rejected' THEN 'Proposition refusée'
        ELSE 'Statut de proposition mis à jour'
      END,
      'Le statut de votre proposition a été mis à jour.',
      'proposal_status',
      NEW.id,
      'proposal'
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour notifier quand un message est reçu
CREATE OR REPLACE FUNCTION notify_new_message()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO notifications (user_id, title, content, type, reference_id, reference_type)
  VALUES (
    NEW.receiver_id,
    'Nouveau message',
    'Vous avez reçu un nouveau message',
    'message',
    NEW.id,
    'message'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour le statut d'expert
CREATE OR REPLACE FUNCTION update_expert_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE profiles 
    SET is_expert = TRUE, 
        is_verified = TRUE, 
        expert_status = 'approved',
        updated_at = NOW()
    WHERE id = NEW.user_id;
    
    INSERT INTO notifications (
      user_id, 
      title, 
      content, 
      type, 
      reference_id, 
      reference_type
    ) VALUES (
      NEW.user_id,
      'Félicitations ! Votre statut d''expert a été approuvé',
      'Votre demande de vérification a été approuvée. Vous pouvez maintenant proposer vos services sur la plateforme.',
      'expert_verification',
      NEW.id,
      'expert_verification'
    );
  
  ELSIF NEW.status = 'rejected' AND OLD.status != 'rejected' THEN
    UPDATE profiles 
    SET expert_status = 'rejected',
        updated_at = NOW()
    WHERE id = NEW.user_id;
    
    INSERT INTO notifications (
      user_id, 
      title, 
      content, 
      type, 
      reference_id, 
      reference_type
    ) VALUES (
      NEW.user_id,
      'Votre demande de vérification a été refusée',
      'Votre demande de vérification a été refusée. Raison: ' || COALESCE(NEW.rejection_reason, 'Non spécifiée'),
      'expert_verification',
      NEW.id,
      'expert_verification'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recréer les triggers
CREATE TRIGGER update_profiles_timestamp
BEFORE UPDATE ON profiles
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_missions_timestamp
BEFORE UPDATE ON missions
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_proposals_timestamp
BEFORE UPDATE ON proposals
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_contracts_timestamp
BEFORE UPDATE ON contracts
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_services_timestamp
BEFORE UPDATE ON services
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER update_payments_timestamp
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER on_new_proposal
AFTER INSERT ON proposals
FOR EACH ROW EXECUTE PROCEDURE notify_new_proposal();

CREATE TRIGGER on_proposal_status_change
AFTER UPDATE ON proposals
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE PROCEDURE notify_proposal_status_change();

CREATE TRIGGER on_new_message
AFTER INSERT ON messages
FOR EACH ROW EXECUTE PROCEDURE notify_new_message();

-- Recréer les vues
CREATE OR REPLACE VIEW expert_profiles AS
SELECT 
  p.id,
  p.first_name,
  p.last_name,
  p.email,
  p.avatar_url,
  p.profession,
  p.experience,
  p.bio,
  p.is_verified,
  p.is_available,
  array_agg(DISTINCT s.name) AS skills,
  COALESCE(AVG(r.rating), 0) AS average_rating,
  COUNT(DISTINCT r.id) AS reviews_count,
  COUNT(DISTINCT c.id) AS completed_contracts
FROM profiles p
LEFT JOIN user_skills us ON p.id = us.user_id
LEFT JOIN skills s ON us.skill_id = s.id
LEFT JOIN contracts c ON p.id = c.expert_id AND c.status = 'completed'
LEFT JOIN reviews r ON p.id = r.reviewee_id
WHERE p.is_expert = TRUE
GROUP BY p.id;

CREATE OR REPLACE VIEW mission_details AS
SELECT 
  r.id,
  r.title,
  r.description,
  r.budget,
  r.deadline,
  r.status,
  r.skills_required,
  r.created_at,
  p.id AS client_id,
  p.first_name AS client_first_name,
  p.last_name AS client_last_name,
  p.avatar_url AS client_avatar,
  COUNT(prop.id) AS proposals_count,
  MIN(prop.price) AS lowest_proposal_price,
  MAX(prop.price) AS highest_proposal_price
FROM missions r
JOIN profiles p ON r.client_id = p.id
LEFT JOIN proposals prop ON r.id = prop.mission_id
GROUP BY r.id, p.id;

CREATE OR REPLACE VIEW active_contracts AS
SELECT 
  c.id,
  c.title,
  c.description,
  c.price,
  c.start_date,
  c.end_date,
  c.status,
  c.created_at,
  c.mission_id,
  c.proposal_id,
  r.title AS mission_title,
  client.id AS client_id,
  client.first_name AS client_first_name,
  client.last_name AS client_last_name,
  client.avatar_url AS client_avatar,
  expert.id AS expert_id,
  expert.first_name AS expert_first_name,
  expert.last_name AS expert_last_name,
  expert.avatar_url AS expert_avatar,
  expert.profession AS expert_profession
FROM contracts c
JOIN missions r ON c.mission_id = r.id
JOIN profiles client ON c.client_id = client.id
JOIN profiles expert ON c.expert_id = expert.id
WHERE c.status = 'active';

CREATE OR REPLACE VIEW expert_search AS
SELECT 
  p.id,
  p.first_name,
  p.last_name,
  p.profession,
  p.avatar_url,
  p.bio,
  p.is_verified,
  p.is_available,
  array_agg(DISTINCT s.name) AS skills,
  array_agg(DISTINCT s.category) AS skill_professions,
  COALESCE(AVG(r.rating), 0) AS rating,
  COUNT(DISTINCT r.id) AS reviews_count,
  COUNT(DISTINCT CASE WHEN c.status = 'completed' THEN c.id END) AS completed_missions,
  MIN(ser.price) AS min_price
FROM profiles p
LEFT JOIN user_skills us ON p.id = us.user_id
LEFT JOIN skills s ON us.skill_id = s.id
LEFT JOIN contracts c ON p.id = c.expert_id
LEFT JOIN reviews r ON p.id = r.reviewee_id
LEFT JOIN services ser ON p.id = ser.expert_id AND ser.is_active = TRUE
WHERE p.is_expert = TRUE AND p.is_available = TRUE
GROUP BY p.id;

-- Insérer des données fictives pour les compétences
INSERT INTO skills (name, category) VALUES
('JavaScript', 'Développement web'),
('React', 'Développement web'),
('Vue.js', 'Développement web'),
('Node.js', 'Développement web'),
('Python', 'Développement web'),
('PHP', 'Développement web'),
('Laravel', 'Développement web'),
('WordPress', 'Développement web'),
('Photoshop', 'Design graphique'),
('Illustrator', 'Design graphique'),
('UI/UX Design', 'Design graphique'),
('Logo Design', 'Design graphique'),
('Web Design', 'Design graphique'),
('SEO', 'Marketing digital'),
('Google Ads', 'Marketing digital'),
('Content Marketing', 'Marketing digital'),
('Social Media', 'Marketing digital'),
('Email Marketing', 'Marketing digital'),
('Français', 'Traduction'),
('Anglais', 'Traduction'),
('Espagnol', 'Traduction'),
('Allemand', 'Traduction'),
('Arabe', 'Traduction'),
('Rédaction Web', 'Rédaction'),
('Copywriting', 'Rédaction'),
('Relecture', 'Rédaction'),
('Rédaction Technique', 'Rédaction'),
('Comptabilité', 'Finance'),
('Gestion de trésorerie', 'Finance'),
('Analyse financière', 'Finance'),
('Conseil juridique', 'Juridique'),
('Droit des contrats', 'Juridique'),
('Propriété intellectuelle', 'Juridique');

-- Insérer des données fictives pour les utilisateurs
-- Note: Dans un environnement réel, ces UUID doivent correspondre à ceux de auth.users
-- Portion from the original script continues here...
INSERT INTO profiles (id, first_name, last_name, email, phone, avatar_url, profession, experience, bio, is_expert, is_available, is_verified, created_at, updated_at, expert_status) VALUES
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 'Thomas', 'Dubois', 'thomas.dubois@example.com', '+33612345678', 'https://randomuser.me/api/portraits/men/32.jpg', 'Développeur Full-Stack', 8, 'Développeur passionné avec 8 ans d''expérience dans la création d''applications web et mobiles. Spécialisé en React, Vue.js et Node.js.', TRUE, TRUE, TRUE, NOW() - INTERVAL '60 days', NOW(), 'approved'),
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 'Émilie', 'Martin', 'emilie.martin@example.com', '+33623456789', 'https://randomuser.me/api/portraits/women/44.jpg', 'Designer UX/UI', 5, 'Designer passionnée par la création d''interfaces utilisateur intuitives et esthétiques. Expérience dans la conception de sites web et d''applications mobiles.', TRUE, TRUE, TRUE, NOW() - INTERVAL '55 days', NOW(), 'approved'),
('2a4c6e8d-b90f-4gh7-i152-j3k4l5m6n7o8', 'Sophie', 'Leclerc', 'sophie.leclerc@example.com', '+33634567890', 'https://randomuser.me/api/portraits/women/23.jpg', 'Traductrice', 10, 'Traductrice professionnelle avec 10 ans d''expérience en traduction technique et commerciale. Spécialisée en français, anglais et espagnol.', TRUE, TRUE, TRUE, NOW() - INTERVAL '50 days', NOW(), 'approved'),
('3b5d7f9h-c12e-4jk6-l345-m7n8p9q0r1s2', 'Marc', 'Petit', 'marc.petit@example.com', '+33645678901', 'https://randomuser.me/api/portraits/men/56.jpg', 'Expert SEO', 7, 'Expert en référencement naturel avec une solide expérience dans l''optimisation de sites web pour les moteurs de recherche. Spécialisé en SEO technique et content marketing.', TRUE, TRUE, TRUE, NOW() - INTERVAL '45 days', NOW(), 'approved'),
('4c6e8g0i-d23f-5lm7-n456-o8p9q0r1s2t3', 'Julie', 'Leroy', 'julie.leroy@example.com', '+33656789012', 'https://randomuser.me/api/portraits/women/72.jpg', 'Copywriter', 6, 'Rédactrice web spécialisée en copywriting et content marketing. Expertise en rédaction de contenu optimisé pour le SEO et les conversions.', TRUE, TRUE, TRUE, NOW() - INTERVAL '40 days', NOW(), 'approved'),
('5d7f9h1j-e34g-6no8-p567-q9r0s1t2u3v4', 'Antoine', 'Bernard', 'antoine.bernard@example.com', '+33667890123', 'https://randomuser.me/api/portraits/men/18.jpg', 'Développeur Mobile', 4, 'Développeur mobile spécialisé en applications iOS et Android natives. Passionné par l''UX et l''innovation technologique.', TRUE, TRUE, TRUE, NOW() - INTERVAL '35 days', NOW(), 'approved'),
('6e8g0i2k-f45h-7pq9-r678-s0t1u2v3w4x5', 'Céline', 'Durand', 'celine.durand@example.com', '+33678901234', 'https://randomuser.me/api/portraits/women/39.jpg', 'Consultante Marketing Digital', 9, 'Consultante en marketing digital avec une expertise en stratégie de contenu, SEO et publicité en ligne. Approche data-driven pour maximiser le ROI.', TRUE, TRUE, TRUE, NOW() - INTERVAL '30 days', NOW(), 'approved'),
('7f9h1j3l-g56i-8rs0-t789-u1v2w3x4y5z6', 'Nicolas', 'Moreau', 'nicolas.moreau@example.com', '+33689012345', 'https://randomuser.me/api/portraits/men/82.jpg', 'Avocat', 12, 'Avocat spécialisé en droit des contrats et propriété intellectuelle. Expérience en conseil juridique pour startups et entreprises technologiques.', TRUE, TRUE, TRUE, NOW() - INTERVAL '25 days', NOW(), 'approved'),
('8g0i2k4m-h67j-9tu1-v890-w2x3y4z5a6b7', 'Aurélie', 'Thomas', 'aurelie.thomas@example.com', '+33690123456', 'https://randomuser.me/api/portraits/women/60.jpg', 'Comptable', 8, 'Comptable certifiée avec expertise en gestion financière et fiscalité des entreprises. Spécialisée dans l''accompagnement des PME et indépendants.', TRUE, TRUE, TRUE, NOW() - INTERVAL '20 days', NOW(), 'approved'),
('9h1j3l5n-i78k-0vw2-x901-y3z4a5b6c7d8', 'Pierre', 'Robert', 'pierre.robert@example.com', '+33701234567', 'https://randomuser.me/api/portraits/men/41.jpg', 'Photographe', 15, 'Photographe professionnel spécialisé en portraits et photographie commerciale. Approche créative et attention aux détails.', TRUE, TRUE, TRUE, NOW() - INTERVAL '15 days', NOW(), 'approved'),
('0i2k4m6o-j89l-1wx3-y012-z4a5b6c7d8e9', 'Marie', 'Dubois', 'marie.dubois@example.com', '+33712345678', 'https://randomuser.me/api/portraits/women/11.jpg', 'Client', 0, 'Entrepreneuse à la recherche de professionnels pour développer son projet de site e-commerce.', FALSE, FALSE, FALSE, NOW() - INTERVAL '10 days', NOW(), NULL),
('1j3l5n7p-k90m-2xy4-z123-a5b6c7d8e9f0', 'David', 'Lefebvre', 'david.lefebvre@example.com', '+33723456789', 'https://randomuser.me/api/portraits/men/4.jpg', 'Client', 0, 'Directeur marketing à la recherche d''experts pour l''aider à optimiser sa stratégie digitale.', FALSE, FALSE, FALSE, NOW() - INTERVAL '5 days', NOW(), NULL);

-- Insérer des données fictives pour les compétences utilisateurs
INSERT INTO user_skills (user_id, skill_id) VALUES
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 1), -- Thomas - JavaScript
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 2), -- Thomas - React
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 3), -- Thomas - Vue.js
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 4), -- Thomas - Node.js
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 9), -- Émilie - Photoshop
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 10), -- Émilie - Illustrator
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 11), -- Émilie - UI/UX Design
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 13), -- Émilie - Web Design
('2a4c6e8d-b90f-4gh7-i152-j3k4l5m6n7o8', 19), -- Sophie - Français
('2a4c6e8d-b90f-4gh7-i152-j3k4l5m6n7o8', 20), -- Sophie - Anglais
('2a4c6e8d-b90f-4gh7-i152-j3k4l5m6n7o8', 21), -- Sophie - Espagnol
('3b5d7f9h-c12e-4jk6-l345-m7n8p9q0r1s2', 14), -- Marc - SEO
('3b5d7f9h-c12e-4jk6-l345-m7n8p9q0r1s2', 15), -- Marc - Google Ads
('3b5d7f9h-c12e-4jk6-l345-m7n8p9q0r1s2', 16), -- Marc - Content Marketing
('4c6e8g0i-d23f-5lm7-n456-o8p9q0r1s2t3', 24), -- Julie - Rédaction Web
('4c6e8g0i-d23f-5lm7-n456-o8p9q0r1s2t3', 25), -- Julie - Copywriting
('4c6e8g0i-d23f-5lm7-n456-o8p9q0r1s2t3', 26), -- Julie - Relecture
('5d7f9h1j-e34g-6no8-p567-q9r0s1t2u3v4', 1), -- Antoine - JavaScript
('5d7f9h1j-e34g-6no8-p567-q9r0s1t2u3v4', 2), -- Antoine - React
('5d7f9h1j-e34g-6no8-p567-q9r0s1t2u3v4', 5), -- Antoine - Python
('6e8g0i2k-f45h-7pq9-r678-s0t1u2v3w4x5', 14), -- Céline - SEO
('6e8g0i2k-f45h-7pq9-r678-s0t1u2v3w4x5', 17), -- Céline - Social Media
('6e8g0i2k-f45h-7pq9-r678-s0t1u2v3w4x5', 18), -- Céline - Email Marketing
('7f9h1j3l-g56i-8rs0-t789-u1v2w3x4y5z6', 31), -- Nicolas - Conseil juridique
('7f9h1j3l-g56i-8rs0-t789-u1v2w3x4y5z6', 32), -- Nicolas - Droit des contrats
('7f9h1j3l-g56i-8rs0-t789-u1v2w3x4y5z6', 33), -- Nicolas - Propriété intellectuelle
('8g0i2k4m-h67j-9tu1-v890-w2x3y4z5a6b7', 28), -- Aurélie - Comptabilité
('8g0i2k4m-h67j-9tu1-v890-w2x3y4z5a6b7', 29), -- Aurélie - Gestion de trésorerie
('8g0i2k4m-h67j-9tu1-v890-w2x3y4z5a6b7', 30); -- Aurélie - Analyse financière

-- Insérer des données fictives pour les vérifications d'experts
INSERT INTO expert_verifications (user_id, document_url, document_type, status, verified_at, rejection_reason, created_at, updated_at) VALUES
('8d7a7fbb-e14c-4dfa-955c-9b242e32a9a4', 'https://example.com/docs/thomas_cv.pdf', 'CV', 'approved', NOW() - INTERVAL '58 days', NULL, NOW() - INTERVAL '60 days', NOW() - INTERVAL '58 days'),
('6f8c7d9b-a10e-4ef9-b155-c7a2c34b0bef', 'https://example.com/docs/emilie_diploma.pdf', 'Diplôme', 'approved', NOW() - INTERVAL '53 days', NULL, NOW() - INTERVAL '55 days', NOW() - INTERVAL '53 days'),
('2a4c6e8d-b90f-4gh7-i152-j3k4l5m6n7o8', 'https://example.com/docs/sophie_certification.pdf', 'Certification', 'approved', NOW() - INTERVAL '48 days', NULL, NOW() - INTERVAL '50 days', NOW() - INTERVAL '48 days'),
('3b5d7f9h-c12e-4jk6-l345-m7n8p9q0r1s2', 'https://example.com/docs/marc_portfolio.pdf', 'Portfolio', 'approved', NOW() - INTERVAL '43 days', NULL, NOW() - INTERVAL '45 days', NOW() - INTERVAL '43 days'),
('4c6e8g0i-d23f-5lm7-n456-o8p9q0r1s2t3', 'https://example.com/docs/julie_samples.pdf', 'Échantillons', 'approved', NOW() - INTERVAL '38 days', NULL, NOW() - INTERVAL '40 days', NOW() - INTERVAL '38 days'),
('5d7f9h1j-e34g-6no8-p567-q9r0s1t2u3v4', 'https://example.com/docs/antoine_missions.pdf', 'Projets', 'approved', NOW() - INTERVAL '33 days', NULL, NOW() - INTERVAL '35 days', NOW() - INTERVAL '33 days'),
('6e8g0i2k-f45h-7pq9-r678-s0t1u2v3w4x5', 'https://example.com/docs/celine_certifications.pdf', 'Certifications', 'approved', NOW() - INTERVAL '28 days', NULL, NOW() - INTERVAL '30 days', NOW() - INTERVAL '28 days'),
('7f9h1j3l-g56i-8rs0-t789-u1v2w3x4y5z6', 'https://example.com/docs/nicolas_diploma.pdf', 'Diplôme', 'approved', NOW() - INTERVAL '23 days', NULL, NOW() - INTERVAL '25 days', NOW() - INTERVAL '23 days'))