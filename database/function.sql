-- Fonction pour promouvoir un utilisateur en admin
CREATE OR REPLACE FUNCTION promote_to_admin(user_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE profiles
  SET 
    is_admin = true,
    role = 'admin'
  WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour révoquer les droits admin
CREATE OR REPLACE FUNCTION revoke_admin(user_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE profiles
  SET 
    is_admin = false,
    role = 'client'
  WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;

-- Exemple d'utilisation :
-- SELECT promote_to_admin('user-id-here');
-- SELECT revoke_admin('user-id-here');
-- Politique permettant aux admins de tout voir
CREATE POLICY "Les admins peuvent tout voir"
ON profiles
FOR ALL
USING (
  auth.uid() IN (
    SELECT id FROM profiles WHERE is_admin = true
  )
);