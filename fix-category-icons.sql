-- Mise à jour des icônes de catégories pour utiliser des emojis 
UPDATE public.service_professions
SET icon = CASE 
    WHEN name = 'Ménage' THEN '🧹'
    WHEN name = 'Jardinage' THEN '🌱'
    WHEN name = 'Bricolage' THEN '🔨'
    WHEN name = 'Garde d''enfants' THEN '👶'
    WHEN name = 'Cours particuliers' THEN '📚'
    WHEN name = 'Informatique' THEN '💻'
    ELSE '📦'
END; 