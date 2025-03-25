-- Initialize security policies for Havoo UI
-- Run this script to ensure all necessary RLS policies are correctly configured

-- Enable RLS on critical tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;

-- Clear existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can read their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can manage all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can view their own verification" ON verifications;
DROP POLICY IF EXISTS "Users can create their own verification" ON verifications;
DROP POLICY IF EXISTS "Users can update their own pending verification" ON verifications;
DROP POLICY IF EXISTS "Admins can manage all verifications" ON verifications;

-- PROFILES POLICIES
-- Users can read their own profile
CREATE POLICY "Users can read their own profile"
ON profiles FOR SELECT
USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile"
ON profiles FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Admins can manage all profiles
CREATE POLICY "Admins can manage all profiles"
ON profiles
USING (
  EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  )
);

-- VERIFICATIONS POLICIES
-- Users can view their own verification
CREATE POLICY "Users can view their own verification" 
ON verifications FOR SELECT 
USING (auth.uid() = user_id);
    
-- Users can create their own verification
CREATE POLICY "Users can create their own verification" 
ON verifications FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Users can update their own verification if it's in 'pending' status
CREATE POLICY "Users can update their own pending verification" 
ON verifications FOR UPDATE 
USING (auth.uid() = user_id AND status = 'pending')
WITH CHECK (auth.uid() = user_id AND status = 'pending');
    
-- Admins can manage all verifications
CREATE POLICY "Admins can manage all verifications" 
ON verifications 
USING (
  EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true
  )
);

-- Ensure storage bucket exists
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- STORAGE POLICIES
-- Clear existing policies
DROP POLICY IF EXISTS "Users can upload their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can view their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Admins can access all verification documents" ON storage.objects;
DROP POLICY IF EXISTS "Only admins can delete verification documents" ON storage.objects;

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

-- Grant necessary privileges
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT SELECT ON storage.buckets TO authenticated;
GRANT SELECT ON storage.buckets TO anon;
GRANT ALL ON storage.objects TO authenticated;
GRANT SELECT ON storage.objects TO anon;

-- Optional: Log successful completion
DO $$
BEGIN
  RAISE NOTICE 'Security policies initialized successfully';
END $$; 