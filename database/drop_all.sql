-- =========================================================================
-- SCRIPT TO DROP ALL DATABASE OBJECTS
-- =========================================================================

-- Disable row level security temporarily
ALTER TABLE IF EXISTS activities DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS provider_ratings DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS proposals DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS jobs DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS provider_services DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS provider_profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS users DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS services DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS categories DISABLE ROW LEVEL SECURITY;

-- Drop all views
DROP VIEW IF EXISTS provider_period_stats;
DROP VIEW IF EXISTS top_categories_by_revenue;
DROP VIEW IF EXISTS recent_platform_activity;
DROP VIEW IF EXISTS category_stats_view;
DROP VIEW IF EXISTS platform_stats_view;
DROP VIEW IF EXISTS detailed_proposals_view;
DROP VIEW IF EXISTS job_stats_view;
DROP VIEW IF EXISTS provider_detailed_view;
DROP VIEW IF EXISTS provider_rating_stats;
DROP VIEW IF EXISTS recent_activities;
DROP VIEW IF EXISTS proposal_activities;

-- Drop all triggers
DROP TRIGGER IF EXISTS track_proposal_changes_trigger ON proposals;
DROP TRIGGER IF EXISTS update_provider_rating_trigger ON provider_ratings;
DROP TRIGGER IF EXISTS track_profile_changes_trigger ON profiles;
DROP TRIGGER IF EXISTS track_deal_changes_trigger ON deals;

-- Drop all functions
DROP FUNCTION IF EXISTS track_proposal_changes();
DROP FUNCTION IF EXISTS update_provider_rating();
DROP FUNCTION IF EXISTS track_profile_changes();
DROP FUNCTION IF EXISTS track_deal_changes();
DROP FUNCTION IF EXISTS log_activity(UUID, VARCHAR, VARCHAR, UUID, JSONB);
DROP FUNCTION IF EXISTS can_rate_provider(UUID, UUID, UUID);
DROP FUNCTION IF EXISTS get_category_path(UUID);

-- Drop all tables (in correct order to handle dependencies)
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS provider_ratings CASCADE;
DROP TABLE IF EXISTS proposals CASCADE;
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS provider_services CASCADE;
DROP TABLE IF EXISTS provider_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- Drop all policies
DROP POLICY IF EXISTS "Public can view ratings" ON provider_ratings;
DROP POLICY IF EXISTS "Clients can create ratings" ON provider_ratings;
DROP POLICY IF EXISTS "Clients can update their own ratings" ON provider_ratings;
DROP POLICY IF EXISTS "Providers can respond to their ratings" ON provider_ratings;
DROP POLICY IF EXISTS "Users can view their own activities" ON activities;
DROP POLICY IF EXISTS "Admins can view all activities" ON activities;
DROP POLICY IF EXISTS "System can create activities" ON activities;

-- Drop all indexes (though they will be dropped with their tables)
DROP INDEX IF EXISTS idx_activities_user_id;
DROP INDEX IF EXISTS idx_activities_action_type;
DROP INDEX IF EXISTS idx_activities_entity_type;
DROP INDEX IF EXISTS idx_activities_entity_id;
DROP INDEX IF EXISTS idx_activities_created_at;
DROP INDEX IF EXISTS idx_provider_ratings_provider;
DROP INDEX IF EXISTS idx_provider_ratings_client;
DROP INDEX IF EXISTS idx_provider_ratings_job;
DROP INDEX IF EXISTS idx_provider_ratings_created;
DROP INDEX IF EXISTS idx_categories_parent;
DROP INDEX IF EXISTS idx_categories_level;
DROP INDEX IF EXISTS idx_services_category;
DROP INDEX IF EXISTS idx_provider_services_provider;
DROP INDEX IF EXISTS idx_jobs_client;
DROP INDEX IF EXISTS idx_proposals_job;

-- Optional: Drop extensions (uncomment if needed)
-- DROP EXTENSION IF EXISTS "uuid-ossp";

-- Verify all objects are dropped
DO $$ 
DECLARE 
    schema_name text := 'public';
BEGIN 
    RAISE NOTICE 'Checking for remaining objects in schema %', schema_name;
    
    -- Check for remaining tables
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = schema_name 
        AND table_type = 'BASE TABLE'
    ) THEN
        RAISE NOTICE 'Some tables still exist in schema %', schema_name;
    END IF;
    
    -- Check for remaining views
    IF EXISTS (
        SELECT FROM information_schema.views 
        WHERE table_schema = schema_name
    ) THEN
        RAISE NOTICE 'Some views still exist in schema %', schema_name;
    END IF;
    
    -- Check for remaining functions
    IF EXISTS (
        SELECT FROM information_schema.routines 
        WHERE routine_schema = schema_name
    ) THEN
        RAISE NOTICE 'Some functions still exist in schema %', schema_name;
    END IF;
END $$; 