-- Storage bucket policies for Havoo UI

-- Make sure the documents bucket exists
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- Policies for documents bucket
-- Allow users to insert their own verification documents
CREATE POLICY "Users can upload their own verification documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Allow users to view their own verification documents
CREATE POLICY "Users can view their own verification documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Allow users to update their own verification documents
CREATE POLICY "Users can update their own verification documents"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'documents' AND
  (storage.foldername(name))[1] = 'verifications' AND
  (storage.foldername(name))[2] = auth.uid()::text
);

-- Allow admins to access all verification documents
CREATE POLICY "Admins can access all verification documents"
ON storage.objects
TO authenticated
USING (
  bucket_id = 'documents' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND is_admin = true
  )
);

-- Prevent deletion for all users (only admins can manage files)
CREATE POLICY "Only admins can delete verification documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'documents' AND
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND is_admin = true
  )
); 









-- Supprimer le bucket s'il existe déjà
drop policy if exists "Les avatars sont accessibles publiquement" on storage.objects;
drop policy if exists "Les utilisateurs peuvent uploader leur avatar" on storage.objects;
drop policy if exists "Les utilisateurs peuvent mettre à jour leur avatar" on storage.objects;
drop policy if exists "Les utilisateurs peuvent supprimer leur avatar" on storage.objects;

-- Créer le bucket
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Politiques de sécurité
create policy "Les avatars sont accessibles publiquement"
on storage.objects for select
using ( bucket_id = 'avatars' );

create policy "Les utilisateurs peuvent uploader leur avatar"
on storage.objects for insert
with check (
  bucket_id = 'avatars' AND
  auth.uid() = owner
);

create policy "Les utilisateurs peuvent mettre à jour leur avatar"
on storage.objects for update
using (
  bucket_id = 'avatars' AND
  auth.uid() = owner
);

create policy "Les utilisateurs peuvent supprimer leur avatar"
on storage.objects for delete
using (
  bucket_id = 'avatars' AND
  auth.uid() = owner
);