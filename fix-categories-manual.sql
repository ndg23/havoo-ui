-- Supprimer et recréer manuellement les catégories
DELETE FROM public.service_professions;

-- Insérer des nouvelles catégories avec des emojis
INSERT INTO public.service_professions (id, name, icon, description) VALUES
(uuid_generate_v4(), 'Ménage', '🧹', 'Services de nettoyage et d''entretien'),
(uuid_generate_v4(), 'Jardinage', '🌱', 'Entretien et aménagement de jardins'),
(uuid_generate_v4(), 'Bricolage', '🔨', 'Petits travaux et réparations'),
(uuid_generate_v4(), 'Garde d''enfants', '👶', 'Services de garde et d''accompagnement d''enfants'),
(uuid_generate_v4(), 'Cours particuliers', '📚', 'Enseignement et soutien scolaire'),
(uuid_generate_v4(), 'Informatique', '💻', 'Assistance et dépannage informatique'); 