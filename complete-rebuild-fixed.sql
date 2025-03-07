-- ===========================================
-- SCRIPT DE RECONSTRUCTION COMPLÈTE CORRIGÉ
-- ===========================================
\set ON_ERROR_STOP on
\set VERBOSITY verbose

-- Désactiver temporairement les contraintes
SET session_replication_role = 'replica';

-- ===========================================
-- PHASE 0: NETTOYAGE COMPLET
-- ===========================================

-- Supprimer les triggers
DO $$ 
DECLARE
    trigger_rec RECORD;
BEGIN
    FOR trigger_rec IN (
        SELECT t.tgname, c.relname
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
        AND t.tgname NOT LIKE 'pg_%'
    ) LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON public.%I CASCADE', 
                     trigger_rec.tgname, trigger_rec.relname);
    END LOOP;
END $$;

-- Supprimer les fonctions définies par l'utilisateur (et non celles des extensions)
DO $$ 
DECLARE
    func_rec RECORD;
BEGIN
    FOR func_rec IN (
        SELECT p.proname, pg_get_function_identity_arguments(p.oid) AS args
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        LEFT JOIN pg_depend d ON d.objid = p.oid AND d.deptype = 'e'
        LEFT JOIN pg_extension ext ON ext.oid = d.refobjid
        WHERE n.nspname = 'public'
        AND ext.extname IS NULL -- Exclure les fonctions des extensions
    ) LOOP
        BEGIN
            EXECUTE format('DROP FUNCTION IF EXISTS public.%I(%s) CASCADE', 
                         func_rec.proname, func_rec.args);
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Erreur lors de la suppression de la fonction %(%): %', 
                        func_rec.proname, func_rec.args, SQLERRM;
        END;
    END LOOP;
END $$;

-- Supprimer toutes les tables
DO $$ 
DECLARE
    table_rec RECORD;
BEGIN
    FOR table_rec IN (
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        ORDER BY tablename
    ) LOOP
        EXECUTE format('DROP TABLE IF EXISTS public.%I CASCADE', table_rec.tablename);
    END LOOP;
END $$;

-- Supprimer puis recréer les extensions
DROP EXTENSION IF EXISTS "pg_trgm" CASCADE;
DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;

-- ===========================================
-- PHASE 1: CRÉATION DES EXTENSIONS
-- ===========================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Reste du script identique... 