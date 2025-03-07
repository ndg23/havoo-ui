-- 1. Identifions les IDs à conserver (les premiers de chaque catégorie)
WITH ranked_categories AS (
  SELECT 
    id,
    name,
    icon,
    ROW_NUMBER() OVER (PARTITION BY name ORDER BY id) as row_num
  FROM public.service_categories
)
-- 2. Créons une table temporaire pour stocker les mappings ID
CREATE TEMP TABLE category_id_mapping AS
SELECT
  id as old_id,
  (SELECT id FROM ranked_categories 
   WHERE name = rc.name AND row_num = 1) as new_id
FROM ranked_categories rc
WHERE row_num > 1;

-- 3. Mettons à jour les références dans les services
UPDATE public.services
SET category_id = mapping.new_id
FROM category_id_mapping mapping
WHERE category_id = mapping.old_id;

-- 4. Mettons à jour les références dans les requests (si elles existent)
UPDATE public.requests
SET category_id = mapping.new_id
FROM category_id_mapping mapping
WHERE category_id = mapping.old_id;

-- 5. Supprimons les catégories en double
DELETE FROM public.service_categories
WHERE id IN (SELECT old_id FROM category_id_mapping);

-- 6. Supprimons la table temporaire
DROP TABLE category_id_mapping; 