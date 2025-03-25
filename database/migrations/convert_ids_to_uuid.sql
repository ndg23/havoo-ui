-- Convert all INT primary and foreign keys to UUID
-- Migration script to standardize ID formats across the application

-- Make sure UUID extension is available
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Function to help with ID conversions
CREATE OR REPLACE FUNCTION migrate_to_uuid() RETURNS VOID AS $$
DECLARE
    table_record RECORD;
    column_record RECORD;
BEGIN
    -- Log the start of the migration
    RAISE NOTICE 'Starting migration of INTEGER IDs to UUID';
    
    -- Create a temporary mapping table for all IDs that need conversion
    CREATE TEMP TABLE IF NOT EXISTS id_mappings (
        table_name TEXT NOT NULL,
        column_name TEXT NOT NULL,
        old_id INTEGER NOT NULL,
        new_id UUID NOT NULL DEFAULT uuid_generate_v4(),
        PRIMARY KEY (table_name, column_name, old_id)
    );
    
    -- Convert categories table IDs if needed
    IF EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_name = 'categories' AND column_name = 'id' AND data_type = 'integer'
    ) THEN
        RAISE NOTICE 'Converting categories table';
        
        -- Create mapping from old to new IDs
        INSERT INTO id_mappings (table_name, column_name, old_id)
        SELECT 'categories', 'id', id FROM categories;
        
        -- Backup the original table
        CREATE TABLE categories_backup AS SELECT * FROM categories;
        
        -- Create a new table with UUID id
        CREATE TABLE categories_new (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name TEXT NOT NULL,
            description TEXT,
            icon TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        
        -- Insert data with new UUIDs
        INSERT INTO categories_new (id, name, description, icon, created_at, updated_at)
        SELECT m.new_id, c.name, c.description, c.icon, c.created_at, c.updated_at
        FROM categories c
        JOIN id_mappings m ON m.table_name = 'categories' AND m.column_name = 'id' AND m.old_id = c.id;
        
        -- Drop original and rename new table
        DROP TABLE categories;
        ALTER TABLE categories_new RENAME TO categories;
    END IF;
    
    -- Convert skills table IDs if needed
    IF EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_name = 'skills' AND column_name = 'id' AND data_type = 'integer'
    ) THEN
        RAISE NOTICE 'Converting skills table';
        
        -- Create mapping from old to new IDs
        INSERT INTO id_mappings (table_name, column_name, old_id)
        SELECT 'skills', 'id', id FROM skills;
        
        -- Backup the original table
        CREATE TABLE skills_backup AS SELECT * FROM skills;
        
        -- Create a new table with UUID id
        CREATE TABLE skills_new (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name TEXT NOT NULL,
            description TEXT,
            category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        
        -- Insert data with new UUIDs and update foreign keys
        INSERT INTO skills_new (id, name, description, category_id, created_at, updated_at)
        SELECT 
            m.new_id, 
            s.name, 
            s.description, 
            (SELECT new_id FROM id_mappings WHERE table_name = 'categories' AND column_name = 'id' AND old_id = s.category_id),
            s.created_at, 
            s.updated_at
        FROM skills s
        JOIN id_mappings m ON m.table_name = 'skills' AND m.column_name = 'id' AND m.old_id = s.id;
        
        -- Drop original and rename new table
        DROP TABLE skills;
        ALTER TABLE skills_new RENAME TO skills;
    END IF;
    
    -- Convert user_skills table if needed
    IF EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_name = 'user_skills' AND column_name = 'skill_id' AND data_type = 'integer'
    ) THEN
        RAISE NOTICE 'Converting user_skills table';
        
        -- Backup the original table
        CREATE TABLE user_skills_backup AS SELECT * FROM user_skills;
        
        -- Create a new table with UUID references
        CREATE TABLE user_skills_new (
            user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
            skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
            level INTEGER DEFAULT 1,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            PRIMARY KEY (user_id, skill_id)
        );
        
        -- Insert data with new UUIDs
        INSERT INTO user_skills_new (user_id, skill_id, level, created_at)
        SELECT 
            us.user_id, 
            (SELECT new_id FROM id_mappings WHERE table_name = 'skills' AND column_name = 'id' AND old_id = us.skill_id),
            us.level, 
            us.created_at
        FROM user_skills us;
        
        -- Drop original and rename new table
        DROP TABLE user_skills;
        ALTER TABLE user_skills_new RENAME TO user_skills;
    END IF;
    
    -- Convert requests table if category_id is INTEGER
    IF EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_name = 'requests' AND column_name = 'category_id' AND data_type = 'integer'
    ) THEN
        RAISE NOTICE 'Updating requests table category_id to UUID';
        
        -- Add temporary column for the new UUID
        ALTER TABLE requests ADD COLUMN category_id_uuid UUID;
        
        -- Update with the mapped UUIDs
        UPDATE requests
        SET category_id_uuid = (
            SELECT new_id 
            FROM id_mappings 
            WHERE table_name = 'categories' AND column_name = 'id' AND old_id = requests.category_id
        );
        
        -- Drop the old column and rename the new one
        ALTER TABLE requests DROP COLUMN category_id;
        ALTER TABLE requests RENAME COLUMN category_id_uuid TO category_id;
        
        -- Add the foreign key constraint
        ALTER TABLE requests ADD CONSTRAINT requests_category_id_fkey 
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;
    END IF;
    
    -- Convert deals table if request_id is INTEGER
    IF EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_name = 'deals' AND column_name = 'request_id' AND data_type = 'integer'
    ) THEN
        RAISE NOTICE 'Updating deals table request_id to UUID';
        
        -- Add temporary column for the new UUID
        ALTER TABLE deals ADD COLUMN request_id_uuid UUID;
        
        -- Update with the mapped UUIDs
        UPDATE deals
        SET request_id_uuid = (
            SELECT new_id 
            FROM id_mappings 
            WHERE table_name = 'requests' AND column_name = 'id' AND old_id = deals.request_id
        );
        
        -- Drop the old column and rename the new one
        ALTER TABLE deals DROP COLUMN request_id;
        ALTER TABLE deals RENAME COLUMN request_id_uuid TO request_id;
        
        -- Add the foreign key constraint
        ALTER TABLE deals ADD CONSTRAINT deals_request_id_fkey 
        FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE;
    END IF;
    
    -- Add similar blocks for other tables that need conversion
    -- (likes, views, services, etc.)
    
    -- Log the end of migration
    RAISE NOTICE 'ID migration completed successfully';
END;
$$ LANGUAGE plpgsql;

-- Execute the migration function
SELECT migrate_to_uuid();

-- Clean up
DROP FUNCTION migrate_to_uuid();
DROP TABLE IF EXISTS id_mappings;

-- Update sequences if needed for any remaining INTEGER columns
-- For example:
-- ALTER SEQUENCE categories_id_seq RESTART WITH 1000;

-- Add a note in the schema_migrations table if it exists
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'schema_migrations') THEN
        INSERT INTO schema_migrations (version, name, executed_at)
        VALUES (
            (SELECT COALESCE(MAX(version), 0) + 1 FROM schema_migrations), 
            'convert_ids_to_uuid', 
            NOW()
        );
    END IF;
END $$; 