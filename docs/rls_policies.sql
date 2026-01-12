-- ============================================================================
-- RLS (Row Level Security) Policy Management for UniQuest
-- ============================================================================
-- 
-- This file contains SQL queries to:
-- 1. Check RLS status on tables
-- 2. View existing policies
-- 3. Create RLS policies for user data protection
-- 
-- Defense Talking Points:
-- - "Implements Row Level Security for data protection"
-- - "Users can only access their own data"
-- - "Demonstrates database security best practices"
-- - "Prevents unauthorized data access at database level"

-- ============================================================================
-- SECTION 1: CHECK RLS STATUS ON ALL TABLES
-- ============================================================================

-- Check if RLS is enabled on all user-facing tables
SELECT 
    schemaname,
    tablename,
    rowsecurity AS rls_enabled,
    CASE 
        WHEN rowsecurity = true THEN '✓ Enabled'
        ELSE '✗ Disabled'
    END AS status
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename IN (
        'profiles',
        'missions',
        'user_missions',
        'achievement_defs',
        'user_achievements',
        'cosmetic_defs',
        'user_cosmetics',
        'leaderboard_cache'
    )
ORDER BY tablename;

-- Alternative: Check specific table
SELECT 
    relname AS table_name,
    relrowsecurity AS rls_enabled
FROM pg_class
WHERE relname = 'profiles'
    AND relnamespace = 'public'::regnamespace;

-- ============================================================================
-- SECTION 2: VIEW EXISTING RLS POLICIES
-- ============================================================================

-- View all policies for UniQuest tables
SELECT 
    schemaname,
    tablename,
    policyname AS policy_name,
    permissive,
    roles,
    cmd AS command,
    qual AS using_expression,
    with_check AS with_check_expression
FROM pg_policies
WHERE schemaname = 'public'
    AND tablename IN (
        'profiles',
        'user_missions',
        'user_achievements',
        'user_cosmetics',
        'leaderboard_cache'
    )
ORDER BY tablename, policyname;

-- View policies for specific table
SELECT 
    policyname AS policy_name,
    cmd AS applies_to,
    qual AS using_clause,
    with_check AS with_check_clause
FROM pg_policies
WHERE schemaname = 'public'
    AND tablename = 'profiles';

-- Count policies per table
SELECT 
    tablename,
    COUNT(*) AS policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY tablename;

-- ============================================================================
-- SECTION 3: ENABLE RLS ON TABLES
-- ============================================================================

-- Enable RLS on all user data tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_cosmetics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaderboard_cache ENABLE ROW LEVEL SECURITY;

-- Verify RLS is enabled (should all return true)
SELECT 
    'profiles' AS table_name,
    (SELECT relrowsecurity FROM pg_class WHERE relname = 'profiles') AS rls_enabled
UNION ALL
SELECT 
    'user_missions',
    (SELECT relrowsecurity FROM pg_class WHERE relname = 'user_missions')
UNION ALL
SELECT 
    'user_achievements',
    (SELECT relrowsecurity FROM pg_class WHERE relname = 'user_achievements')
UNION ALL
SELECT 
    'user_cosmetics',
    (SELECT relrowsecurity FROM pg_class WHERE relname = 'user_cosmetics')
UNION ALL
SELECT 
    'leaderboard_cache',
    (SELECT relrowsecurity FROM pg_class WHERE relname = 'leaderboard_cache');

-- ============================================================================
-- SECTION 4: DROP EXISTING POLICIES (if recreating)
-- ============================================================================

-- Drop all policies for profiles table (use before recreating)
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

-- Drop all policies for user_missions table
DROP POLICY IF EXISTS "Users can view own quests" ON public.user_missions;
DROP POLICY IF EXISTS "Users can insert own quests" ON public.user_missions;
DROP POLICY IF EXISTS "Users can update own quests" ON public.user_missions;

-- ============================================================================
-- SECTION 5: CREATE RLS POLICIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TABLE: profiles (users can SELECT/UPDATE own row only)
-- ----------------------------------------------------------------------------

-- Policy 1: Users can SELECT their own profile
CREATE POLICY "Users can view own profile"
ON public.profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Policy 2: Users can UPDATE their own profile
CREATE POLICY "Users can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Policy 3: Users can INSERT their own profile (signup)
CREATE POLICY "Users can insert own profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Policy 4: Service role can do anything (for admin operations)
CREATE POLICY "Service role has full access to profiles"
ON public.profiles
TO service_role
USING (true)
WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- TABLE: user_missions (quest progress)
-- Users: SELECT/INSERT/UPDATE own rows, no DELETE
-- ----------------------------------------------------------------------------

-- Policy 1: Users can SELECT their own quest progress
CREATE POLICY "Users can view own quest progress"
ON public.user_missions
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Policy 2: Users can INSERT their own quest progress (start quest)
CREATE POLICY "Users can start own quests"
ON public.user_missions
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Policy 3: Users can UPDATE their own quest progress
CREATE POLICY "Users can update own quest progress"
ON public.user_missions
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policy 4: No DELETE for users (quests can be archived instead)
-- (No DELETE policy = users cannot delete)

-- Policy 5: Service role can manage quests (admin/system)
CREATE POLICY "Service role can manage all quests"
ON public.user_missions
TO service_role
USING (true)
WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- TABLE: leaderboard_cache (read-only for users)
-- Users: SELECT all, no INSERT/UPDATE/DELETE
-- ----------------------------------------------------------------------------

-- Policy 1: Users can SELECT all leaderboard entries
CREATE POLICY "Users can view leaderboard"
ON public.leaderboard_cache
FOR SELECT
TO authenticated
USING (true);

-- Policy 2: Only service role can INSERT/UPDATE/DELETE leaderboard
CREATE POLICY "Only service role can modify leaderboard"
ON public.leaderboard_cache
TO service_role
USING (true)
WITH CHECK (true);

-- Alternative: If you want users to see their own rank even when not logged in
CREATE POLICY "Public can view leaderboard"
ON public.leaderboard_cache
FOR SELECT
TO public
USING (true);

-- ----------------------------------------------------------------------------
-- TABLE: user_achievements (users can view, system inserts)
-- Users: SELECT own, INSERT system-only via triggers
-- ----------------------------------------------------------------------------

-- Policy 1: Users can SELECT their own achievements
CREATE POLICY "Users can view own achievements"
ON public.user_achievements
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Policy 2: Service role can INSERT achievements (system-awarded)
CREATE POLICY "Service role can award achievements"
ON public.user_achievements
FOR INSERT
TO service_role
WITH CHECK (true);

-- Policy 3: Service role can UPDATE achievement progress
CREATE POLICY "Service role can update achievement progress"
ON public.user_achievements
FOR UPDATE
TO service_role
USING (true)
WITH CHECK (true);

-- Policy 4: Users cannot DELETE achievements (permanent record)
-- (No DELETE policy = users cannot delete)

-- Alternative: Allow users to INSERT via function with validation
-- This would require a separate SECURITY DEFINER function

-- ----------------------------------------------------------------------------
-- TABLE: user_cosmetics (users can manage their own cosmetics)
-- Users: SELECT/INSERT/UPDATE own, no DELETE
-- ----------------------------------------------------------------------------

-- Policy 1: Users can SELECT their own cosmetics
CREATE POLICY "Users can view own cosmetics"
ON public.user_cosmetics
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Policy 2: Users can INSERT their own cosmetics (unlock/purchase)
CREATE POLICY "Users can unlock own cosmetics"
ON public.user_cosmetics
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Policy 3: Users can UPDATE their own cosmetics (equip/unequip)
CREATE POLICY "Users can update own cosmetics"
ON public.user_cosmetics
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policy 4: No DELETE for users (cosmetics are permanent)
-- (No DELETE policy = users cannot delete)

-- Policy 5: Service role has full access
CREATE POLICY "Service role can manage all cosmetics"
ON public.user_cosmetics
TO service_role
USING (true)
WITH CHECK (true);

-- ============================================================================
-- SECTION 6: TEST POLICIES
-- ============================================================================

-- Test 1: Check if user can see only their own profile
-- Run as authenticated user
SELECT * FROM public.profiles WHERE id = auth.uid();

-- Test 2: Try to select another user's profile (should return no rows)
SELECT * FROM public.profiles WHERE id != auth.uid();

-- Test 3: Check if user can view their own quests
SELECT * FROM public.user_missions WHERE user_id = auth.uid();

-- Test 4: Check leaderboard access (should see all entries)
SELECT * FROM public.leaderboard_cache LIMIT 10;

-- Test 5: Verify policy count per table
SELECT 
    tablename,
    COUNT(*) AS policy_count,
    STRING_AGG(policyname, ', ' ORDER BY policyname) AS policies
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY tablename;

-- ============================================================================
-- SECTION 7: GRANT PERMISSIONS
-- ============================================================================

-- Grant SELECT on reference tables to authenticated users
GRANT SELECT ON public.missions TO authenticated;
GRANT SELECT ON public.achievement_defs TO authenticated;
GRANT SELECT ON public.cosmetic_defs TO authenticated;

-- Grant appropriate permissions on user data tables
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.user_missions TO authenticated;
GRANT SELECT ON public.user_achievements TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.user_cosmetics TO authenticated;
GRANT SELECT ON public.leaderboard_cache TO authenticated;

-- Service role gets all permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;

-- ============================================================================
-- SECTION 8: SECURITY FUNCTIONS (Optional)
-- ============================================================================

-- Function to check if user owns a record
CREATE OR REPLACE FUNCTION public.is_owner(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT auth.uid() = user_id;
$$;

-- Function to award achievement (called by system)
CREATE OR REPLACE FUNCTION public.award_achievement(
    p_user_id uuid,
    p_achievement_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.user_achievements (user_id, achievement_id, unlocked_at)
    VALUES (p_user_id, p_achievement_id, NOW())
    ON CONFLICT (user_id, achievement_id) DO NOTHING;
END;
$$;

-- Function to unlock cosmetic (with validation)
CREATE OR REPLACE FUNCTION public.unlock_cosmetic(
    p_cosmetic_id uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_cost int;
    v_user_xp int;
BEGIN
    -- Get cosmetic cost
    SELECT cost INTO v_cost
    FROM public.cosmetic_defs
    WHERE cosmetic_id = p_cosmetic_id;

    -- Get user XP
    SELECT xp INTO v_user_xp
    FROM public.profiles
    WHERE id = auth.uid();

    -- Check if user can afford
    IF v_user_xp < v_cost THEN
        RAISE EXCEPTION 'Insufficient XP to unlock cosmetic';
    END IF;

    -- Unlock cosmetic
    INSERT INTO public.user_cosmetics (user_id, cosmetic_id, unlocked_at)
    VALUES (auth.uid(), p_cosmetic_id, NOW())
    ON CONFLICT DO NOTHING;

    -- Deduct XP
    UPDATE public.profiles
    SET xp = xp - v_cost
    WHERE id = auth.uid();
END;
$$;

-- ============================================================================
-- SECTION 9: AUDIT & MONITORING
-- ============================================================================

-- View recent policy violations (if logging enabled)
-- Note: Requires pgAudit extension
-- SELECT * FROM pgaudit.log WHERE error_severity = 'ERROR' AND message LIKE '%policy%';

-- Check for tables without RLS
SELECT 
    tablename,
    CASE 
        WHEN rowsecurity = false THEN '⚠️  RLS NOT ENABLED'
        ELSE '✓ RLS Enabled'
    END AS status
FROM pg_tables
WHERE schemaname = 'public'
    AND tablename NOT LIKE 'pg_%'
    AND tablename NOT IN ('spatial_ref_sys') -- PostGIS table
ORDER BY rowsecurity, tablename;

-- Check for tables with no policies (RLS enabled but no policies = no access)
SELECT 
    t.tablename,
    t.rowsecurity AS rls_enabled,
    COUNT(p.policyname) AS policy_count,
    CASE 
        WHEN t.rowsecurity = true AND COUNT(p.policyname) = 0 
        THEN '⚠️  NO POLICIES (no access)'
        WHEN t.rowsecurity = false 
        THEN '⚠️  RLS DISABLED'
        ELSE '✓ Protected'
    END AS security_status
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename AND t.schemaname = p.schemaname
WHERE t.schemaname = 'public'
GROUP BY t.tablename, t.rowsecurity
ORDER BY security_status, t.tablename;

-- ============================================================================
-- SECTION 10: POLICY TEMPLATES
-- ============================================================================

-- Template: Basic user-owned data
/*
CREATE POLICY "policy_name"
ON public.table_name
FOR SELECT|INSERT|UPDATE|DELETE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
*/

-- Template: Read-only reference table
/*
CREATE POLICY "Anyone can read"
ON public.table_name
FOR SELECT
TO authenticated
USING (true);
*/

-- Template: Admin-only modifications
/*
CREATE POLICY "Only admins can modify"
ON public.table_name
FOR ALL
TO authenticated
USING (
    auth.uid() IN (
        SELECT id FROM public.profiles WHERE is_admin = true
    )
);
*/

-- Template: Time-based access
/*
CREATE POLICY "Users can view recent data"
ON public.table_name
FOR SELECT
TO authenticated
USING (
    created_at > NOW() - INTERVAL '30 days'
    AND auth.uid() = user_id
);
*/

-- ============================================================================
-- END OF RLS POLICY MANAGEMENT
-- ============================================================================

-- To apply all policies in this file:
-- 1. Connect to Supabase database via SQL Editor or psql
-- 2. Run sections 3 (Enable RLS) and 5 (Create Policies)
-- 3. Run section 6 (Test Policies) to verify
-- 4. Check section 9 (Audit) to ensure no tables are unprotected
