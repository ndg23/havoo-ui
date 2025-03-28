-- Fonction pour générer des missions de test
CREATE OR REPLACE FUNCTION generate_mock_missions(count INTEGER DEFAULT 20) 
RETURNS void AS $$
DECLARE
    v_client_ids UUID[];
    v_profession_ids UUID[];
    v_titles TEXT[] := ARRAY[
        'Développement site web e-commerce',
        'Logo pour startup',
        'Maintenance système informatique',
        'Création application mobile',
        'Design interface utilisateur',
        'Rédaction contenu web',
        'Configuration serveur',
        'Optimisation SEO',
        'Intégration API',
        'Formation équipe technique'
    ];
    v_descriptions TEXT[] := ARRAY[
        'Besoin d''un expert pour développer un site e-commerce moderne et responsive',
        'Recherche designer pour créer une identité visuelle forte et mémorable',
        'Maintenance et mise à jour de notre infrastructure IT',
        'Développement d''une application mobile native iOS et Android',
        'Design d''une interface intuitive pour notre plateforme SaaS',
        'Création de contenu SEO pour notre blog',
        'Configuration et sécurisation de nos serveurs cloud',
        'Amélioration du référencement de notre site web',
        'Intégration de diverses APIs pour notre plateforme',
        'Formation de notre équipe aux nouvelles technologies'
    ];
    v_statuses TEXT[] := ARRAY['open', 'assigned', 'completed', 'cancelled'];
    v_client_id UUID;
    v_profession_id UUID;
    i INTEGER;
BEGIN
    -- Récupérer les IDs des clients depuis la table profiles
    SELECT ARRAY_AGG(id) INTO v_client_ids
    FROM profiles
    WHERE role = 'client'
    LIMIT 10;

    -- Récupérer les IDs des professions
    SELECT ARRAY_AGG(id) INTO v_profession_ids
    FROM professions
    LIMIT 5;

    -- Générer les missions
    FOR i IN 1..count LOOP
        -- Sélectionner aléatoirement un client et une profession
        v_client_id := v_client_ids[1 + floor(random() * array_length(v_client_ids, 1))];
        v_profession_id := v_profession_ids[1 + floor(random() * array_length(v_profession_ids, 1))];

        INSERT INTO missions (
            client_id,
            profession_id,
            title,
            description,
            budget,
            deadline,
            status,
            created_at,
            updated_at
        ) VALUES (
            v_client_id,
            v_profession_id,
            v_titles[1 + floor(random() * array_length(v_titles, 1))],
            v_descriptions[1 + floor(random() * array_length(v_descriptions, 1))],
            (random() * 900000 + 100000)::INTEGER, -- Budget entre 100k et 1M FCFA
            NOW() + (random() * 30 || ' days')::INTERVAL, -- Deadline dans les 30 prochains jours
            v_statuses[1 + floor(random() * array_length(v_statuses, 1))],
            NOW() - (random() * 30 || ' days')::INTERVAL, -- Date de création dans les 30 derniers jours
            NOW() - (random() * 30 || ' days')::INTERVAL
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour générer des propositions de test
CREATE OR REPLACE FUNCTION generate_mock_deals(count INTEGER DEFAULT 30)
RETURNS void AS $$
DECLARE
    v_expert_ids UUID[];
    v_mission_ids UUID[];
    v_statuses TEXT[] := ARRAY['proposal', 'active', 'completed', 'rejected', 'cancelled'];
    v_expert_id UUID;
    v_mission_id UUID;
    v_attempts INTEGER;
    i INTEGER;
BEGIN
    -- Récupérer les IDs des experts
    SELECT ARRAY_AGG(id) INTO v_expert_ids
    FROM profiles
    WHERE role = 'expert'
    LIMIT 10;

    -- Récupérer les IDs des missions
    SELECT ARRAY_AGG(id) INTO v_mission_ids
    FROM missions
    WHERE status = 'open'
    LIMIT 20;

    -- Générer les propositions
    i := 1;
    v_attempts := 0;
    WHILE i <= count AND v_attempts < count * 2 LOOP
        -- Sélectionner aléatoirement un expert et une mission
        v_expert_id := v_expert_ids[1 + floor(random() * array_length(v_expert_ids, 1))];
        v_mission_id := v_mission_ids[1 + floor(random() * array_length(v_mission_ids, 1))];

        -- Vérifier si cette combinaison existe déjà
        IF NOT EXISTS (
            SELECT 1 
            FROM deals 
            WHERE mission_id = v_mission_id 
            AND expert_id = v_expert_id
        ) THEN
            -- Insérer nouvelle proposition
            INSERT INTO deals (
                mission_id,
                expert_id,
                price,
                duration,
                message,
                status,
                created_at,
                updated_at
            ) VALUES (
                v_mission_id,
                v_expert_id,
                (random() * 800000 + 200000)::INTEGER,
                (random() * 14 + 1)::INTEGER,
                'Je peux réaliser cette mission avec professionnalisme et dans les délais.',
                v_statuses[1 + floor(random() * array_length(v_statuses, 1))],
                NOW() - (random() * 20 || ' days')::INTERVAL,
                NOW() - (random() * 20 || ' days')::INTERVAL
            );
            i := i + 1;
        END IF;
        v_attempts := v_attempts + 1;
    END LOOP;

    -- Informer si on n'a pas pu générer toutes les propositions demandées
    IF i <= count THEN
        RAISE NOTICE 'Seulement % propositions générées sur % demandées', i-1, count;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Exécuter les fonctions pour générer les données
SELECT generate_mock_missions(20);  -- Générer 20 missions
SELECT generate_mock_deals(30);     -- Générer 30 propositions