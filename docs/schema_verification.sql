-- ============================================================================
-- SCHEMA VERIFICATION SQL for UniQuest
-- Validates database schema matches Project Plan Section 5.4.3.2
-- ============================================================================
-- 
-- Expected Tables:
-- - users (profiles)
-- - quests (missions)
-- - quest_progress (user_missions)
-- - achievements (achievement_defs)
-- - user_achievements
-- - cosmetics (cosmetic_defs)
-- - user_cosmetics
-- - map_markers
-- - leaderboard (leaderboard_cache)
--
-- Defense Talking Points:
-- - "Schema verification ensures implementation matches design"
-- - "Automated checks catch database migration issues"
-- - "Documents expected schema for team reference"

-- ============================================================================
-- SECTION 1: LIST ALL TABLES
-- ============================================================================

-- Get all user-defined tables in public schema
SELECT 
    schemaname,
    tablename,
    tableowner,
    CASE 
        WHEN tablename IN ('profiles', 'missions', 'user_missions', 
                           'achievement_defs', 'user_achievements',
                           'cosmetic_defs', 'user_cosmetics', 
                           'map_markers', 'leaderboard_cache')
        THEN '✓ Expected'
        ELSE '⚠️  Unexpected'
    END AS status
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT IN ('spatial_ref_sys') -- Exclude PostGIS tables
ORDER BY tablename;

-- Count total tables
SELECT COUNT(*) AS total_tables
FROM pg_tables
WHERE schemaname = 'public';

-- Check for missing expected tables
WITH expected_tables AS (
    SELECT unnest(ARRAY[
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    ]) AS table_name
),
existing_tables AS (
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public'
)
SELECT 
    e.table_name AS missing_table
FROM expected_tables e
LEFT JOIN existing_tables x ON e.table_name = x.tablename
WHERE x.tablename IS NULL;

-- ============================================================================
-- SECTION 2: CHECK COLUMNS FOR EACH TABLE
-- ============================================================================

-- View all columns for UniQuest tables
SELECT 
    table_name,
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
ORDER BY table_name, ordinal_position;

-- Get column count per table
SELECT 
    table_name,
    COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
GROUP BY table_name
ORDER BY table_name;

-- ----------------------------------------------------------------------------
-- TABLE: profiles (users)
-- Expected columns: id, created_at, username, xp, rank, task_streak, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'profiles'
ORDER BY ordinal_position;

-- Verify critical columns exist
SELECT 
    'profiles' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' AND column_name = 'id'
    ) THEN '✓' ELSE '✗' END AS has_id,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' AND column_name = 'xp'
    ) THEN '✓' ELSE '✗' END AS has_xp,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' AND column_name = 'rank'
    ) THEN '✓' ELSE '✗' END AS has_rank,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' AND column_name = 'task_streak'
    ) THEN '✓' ELSE '✗' END AS has_task_streak;

-- ----------------------------------------------------------------------------
-- TABLE: missions (quests)
-- Expected columns: mission_id, title, description, trigger, target_value, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'missions'
ORDER BY ordinal_position;

-- Verify critical columns exist
SELECT 
    'missions' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'missions' AND column_name = 'mission_id'
    ) THEN '✓' ELSE '✗' END AS has_mission_id,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'missions' AND column_name = 'title'
    ) THEN '✓' ELSE '✗' END AS has_title,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'missions' AND column_name = 'reward_points'
    ) THEN '✓' ELSE '✗' END AS has_reward_points;

-- ----------------------------------------------------------------------------
-- TABLE: user_missions (quest_progress)
-- Expected columns: user_id, mission_id, progress, completed, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'user_missions'
ORDER BY ordinal_position;

-- Verify critical columns exist
SELECT 
    'user_missions' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'user_missions' AND column_name = 'user_id'
    ) THEN '✓' ELSE '✗' END AS has_user_id,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'user_missions' AND column_name = 'mission_id'
    ) THEN '✓' ELSE '✗' END AS has_mission_id,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'user_missions' AND column_name = 'progress'
    ) THEN '✓' ELSE '✗' END AS has_progress,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'user_missions' AND column_name = 'completed'
    ) THEN '✓' ELSE '✗' END AS has_completed;

-- ----------------------------------------------------------------------------
-- TABLE: achievement_defs (achievements)
-- Expected columns: achievement_id, name, description, condition, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'achievement_defs'
ORDER BY ordinal_position;

-- ----------------------------------------------------------------------------
-- TABLE: user_achievements
-- Expected columns: user_id, achievement_id, unlocked_at, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'user_achievements'
ORDER BY ordinal_position;

-- ----------------------------------------------------------------------------
-- TABLE: cosmetic_defs (cosmetics)
-- Expected columns: cosmetic_id, name, type, rarity, cost, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'cosmetic_defs'
ORDER BY ordinal_position;

-- ----------------------------------------------------------------------------
-- TABLE: user_cosmetics
-- Expected columns: user_id, cosmetic_id, unlocked_at, equipped, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'user_cosmetics'
ORDER BY ordinal_position;

-- ----------------------------------------------------------------------------
-- TABLE: map_markers
-- Expected columns: marker_id, location, name, type, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'map_markers'
ORDER BY ordinal_position;

-- ----------------------------------------------------------------------------
-- TABLE: leaderboard_cache (leaderboard)
-- Expected columns: user_id, xp, rank, username, updated_at, etc.
-- ----------------------------------------------------------------------------

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'leaderboard_cache'
ORDER BY ordinal_position;

-- ============================================================================
-- SECTION 3: CHECK INDEXES EXIST
-- ============================================================================

-- List all indexes on UniQuest tables
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
    AND tablename IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
ORDER BY tablename, indexname;

-- Count indexes per table
SELECT 
    tablename,
    COUNT(*) AS index_count
FROM pg_indexes
WHERE schemaname = 'public'
    AND tablename IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
GROUP BY tablename
ORDER BY tablename;

-- Check for critical indexes
-- Primary key indexes (should exist)
SELECT 
    'profiles' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'profiles' AND indexname LIKE '%pkey'
    ) THEN '✓ PK Index' ELSE '✗ Missing PK' END AS primary_key_index;

-- Check for foreign key indexes (performance)
SELECT 
    'user_missions' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'user_missions' AND indexdef LIKE '%user_id%'
    ) THEN '✓ user_id indexed' ELSE '⚠️  No user_id index' END AS user_id_index,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'user_missions' AND indexdef LIKE '%mission_id%'
    ) THEN '✓ mission_id indexed' ELSE '⚠️  No mission_id index' END AS mission_id_index;

-- Check for leaderboard performance indexes
SELECT 
    'leaderboard_cache' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'leaderboard_cache' AND indexdef LIKE '%xp%'
    ) THEN '✓ XP indexed' ELSE '⚠️  No XP index' END AS xp_index,
    CASE WHEN EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'leaderboard_cache' AND indexdef LIKE '%rank%'
    ) THEN '✓ Rank indexed' ELSE '⚠️  No Rank index' END AS rank_index;

-- ============================================================================
-- SECTION 4: CHECK FOREIGN KEYS
-- ============================================================================

-- List all foreign key constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
    AND tc.table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
ORDER BY tc.table_name, tc.constraint_name;

-- Count foreign keys per table
SELECT 
    table_name,
    COUNT(*) AS foreign_key_count
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY'
    AND table_schema = 'public'
    AND table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
GROUP BY table_name
ORDER BY table_name;

-- Verify critical foreign keys exist
-- user_missions should reference profiles and missions
SELECT 
    'user_missions' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_missions'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'user_id'
            AND ccu.table_name = 'profiles'
    ) THEN '✓ FK to profiles' ELSE '✗ Missing FK to profiles' END AS fk_to_profiles,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_missions'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'mission_id'
            AND ccu.table_name = 'missions'
    ) THEN '✓ FK to missions' ELSE '✗ Missing FK to missions' END AS fk_to_missions;

-- user_achievements should reference profiles and achievement_defs
SELECT 
    'user_achievements' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_achievements'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'user_id'
            AND ccu.table_name = 'profiles'
    ) THEN '✓ FK to profiles' ELSE '✗ Missing FK to profiles' END AS fk_to_profiles,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_achievements'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'achievement_id'
            AND ccu.table_name = 'achievement_defs'
    ) THEN '✓ FK to achievement_defs' ELSE '✗ Missing FK to achievement_defs' END AS fk_to_achievement_defs;

-- user_cosmetics should reference profiles and cosmetic_defs
SELECT 
    'user_cosmetics' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_cosmetics'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'user_id'
            AND ccu.table_name = 'profiles'
    ) THEN '✓ FK to profiles' ELSE '✗ Missing FK to profiles' END AS fk_to_profiles,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.table_name = 'user_cosmetics'
            AND tc.constraint_type = 'FOREIGN KEY'
            AND kcu.column_name = 'cosmetic_id'
            AND ccu.table_name = 'cosmetic_defs'
    ) THEN '✓ FK to cosmetic_defs' ELSE '✗ Missing FK to cosmetic_defs' END AS fk_to_cosmetic_defs;

-- ============================================================================
-- SECTION 5: CHECK PRIMARY KEYS
-- ============================================================================

-- List all primary key constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    kcu.column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
    AND tc.table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
ORDER BY tc.table_name;

-- Verify each expected table has a primary key
WITH expected_tables AS (
    SELECT unnest(ARRAY[
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    ]) AS table_name
)
SELECT 
    e.table_name,
    CASE WHEN tc.constraint_name IS NOT NULL 
        THEN '✓ Has PK' 
        ELSE '✗ No PK' 
    END AS primary_key_status,
    kcu.column_name AS pk_column
FROM expected_tables e
LEFT JOIN information_schema.table_constraints tc
    ON e.table_name = tc.table_name
    AND tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
LEFT JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
ORDER BY e.table_name;

-- ============================================================================
-- SECTION 6: CHECK UNIQUE CONSTRAINTS
-- ============================================================================

-- List all unique constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    kcu.column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'UNIQUE'
    AND tc.table_schema = 'public'
    AND tc.table_name IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'map_markers',
        'leaderboard_cache'
    )
ORDER BY tc.table_name, tc.constraint_name;

-- Check for critical unique constraints
-- Username should be unique in profiles
SELECT 
    'profiles' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        WHERE tc.table_name = 'profiles'
            AND tc.constraint_type = 'UNIQUE'
            AND kcu.column_name = 'username'
    ) THEN '✓ Username unique' ELSE '⚠️  Username not unique' END AS username_unique;

-- user_missions should have unique (user_id, mission_id) combination
SELECT 
    'user_missions' AS table_name,
    CASE WHEN EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints tc
        WHERE tc.table_name = 'user_missions'
            AND tc.constraint_type = 'UNIQUE'
            AND tc.constraint_name LIKE '%user_id%mission_id%'
    ) THEN '✓ Unique user+mission' ELSE '⚠️  No composite unique' END AS composite_unique;

-- ============================================================================
-- SECTION 7: COMPREHENSIVE SCHEMA REPORT
-- ============================================================================

-- Generate comprehensive schema validation report
WITH table_check AS (
    SELECT 
        'profiles' AS expected_table,
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'profiles') 
            THEN '✓' ELSE '✗' END AS exists
    UNION ALL SELECT 'missions', 
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'missions') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'user_missions',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'user_missions') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'achievement_defs',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'achievement_defs') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'user_achievements',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'user_achievements') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'cosmetic_defs',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'cosmetic_defs') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'user_cosmetics',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'user_cosmetics') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'map_markers',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'map_markers') 
            THEN '✓' ELSE '✗' END
    UNION ALL SELECT 'leaderboard_cache',
        CASE WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'leaderboard_cache') 
            THEN '✓' ELSE '✗' END
)
SELECT * FROM table_check;

-- Summary statistics
SELECT 
    'Schema Verification Summary' AS report_section,
    (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public') AS total_tables,
    (SELECT COUNT(*) FROM information_schema.table_constraints 
        WHERE constraint_type = 'PRIMARY KEY' AND table_schema = 'public') AS total_primary_keys,
    (SELECT COUNT(*) FROM information_schema.table_constraints 
        WHERE constraint_type = 'FOREIGN KEY' AND table_schema = 'public') AS total_foreign_keys,
    (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public') AS total_indexes;

-- ============================================================================
-- END OF SCHEMA VERIFICATION
-- ============================================================================
