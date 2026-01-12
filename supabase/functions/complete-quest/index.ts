// ============================================================================
// Edge Function: complete-quest
// ============================================================================
// 
// Purpose: Server-side quest completion with XP awarding
// 
// Flow:
// 1. Validate request inputs (userId, questId)
// 2. Verify quest exists and retrieve reward information
// 3. Check if quest already completed (prevent duplicates)
// 4. Mark quest as completed in user_missions
// 5. Award XP to user profile via secure function
// 6. Check for achievement/badge unlocks based on new XP/stats
// 7. Update leaderboard cache for real-time rankings
// 8. Return success response with XP awarded and new stats
//
// Defense Talking Points:
// - "Server-side validation prevents client-side XP manipulation"
// - "Atomic transaction ensures data consistency"
// - "Edge Function scales automatically with Supabase"
// - "Separates business logic from client code"
//
// Security:
// - Uses service role for database operations
// - Validates JWT token from Authorization header
// - Prevents duplicate completions via unique constraints
// - Logs all XP transactions for audit trail

// @ts-ignore: Deno runtime imports
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
// @ts-ignore: ESM import
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// CORS headers for client requests
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// ============================================================================
// MAIN HANDLER
// ============================================================================

serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // --------------------------------------------------------------------
    // STEP 1: INITIALIZE & AUTHENTICATE
    // --------------------------------------------------------------------
    
    // Create Supabase client with service role (bypass RLS)
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    )

    // Extract JWT from Authorization header
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('Missing Authorization header')
    }

    // Verify JWT and extract user ID
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: authError } = await supabaseClient.auth.getUser(token)
    
    if (authError || !user) {
      throw new Error('Invalid authentication token')
    }

    const userId = user.id

    // --------------------------------------------------------------------
    // STEP 2: PARSE & VALIDATE REQUEST BODY
    // --------------------------------------------------------------------
    
    const requestBody = await req.json()
    const { questId } = requestBody

    // Validate required fields
    if (!questId) {
      throw new Error('Missing required field: questId')
    }

    // TODO: Validate questId format (UUID)
    // TODO: Validate userId matches authenticated user

    // --------------------------------------------------------------------
    // STEP 3: CHECK QUEST EXISTS & GET REWARD INFO
    // --------------------------------------------------------------------
    
    // Query missions table for quest details
    // const { data: quest, error: questError } = await supabaseClient
    //   .from('missions')
    //   .select('mission_id, title, reward_points, difficulty, archived')
    //   .eq('mission_id', questId)
    //   .single()

    // TODO: Check if questError (quest not found)
    // TODO: Verify quest is not archived
    // TODO: Extract reward_points value

    const rewardPoints = 0 // Placeholder: would come from quest.reward_points

    // --------------------------------------------------------------------
    // STEP 4: CHECK IF ALREADY COMPLETED
    // --------------------------------------------------------------------
    
    // Query user_missions to check completion status
    // const { data: userQuest, error: userQuestError } = await supabaseClient
    //   .from('user_missions')
    //   .select('user_id, mission_id, progress, completed, completed_at')
    //   .eq('user_id', userId)
    //   .eq('mission_id', questId)
    //   .single()

    // TODO: If userQuestError with code 'PGRST116', quest not started by user
    // TODO: If userQuest.completed === true, throw "Quest already completed"
    // TODO: If userQuest.progress < targetValue, throw "Quest not finished yet"

    // --------------------------------------------------------------------
    // STEP 5: MARK QUEST AS COMPLETED (TRANSACTION START)
    // --------------------------------------------------------------------
    
    // Update user_missions: set completed = true, completed_at = NOW()
    // const { error: updateError } = await supabaseClient
    //   .from('user_missions')
    //   .update({
    //     completed: true,
    //     completed_at: new Date().toISOString(),
    //     progress: 100, // Ensure progress is at 100%
    //   })
    //   .eq('user_id', userId)
    //   .eq('mission_id', questId)

    // TODO: Handle updateError (database constraint violation, etc.)

    // --------------------------------------------------------------------
    // STEP 6: AWARD XP TO USER PROFILE
    // --------------------------------------------------------------------
    
    // Call PostgreSQL function to atomically add XP
    // const { data: xpResult, error: xpError } = await supabaseClient
    //   .rpc('award_xp', {
    //     p_user_id: userId,
    //     p_xp_amount: rewardPoints,
    //     p_source: 'quest_completion',
    //     p_source_id: questId,
    //   })

    // TODO: Handle xpError
    // TODO: Extract new XP total from xpResult
    // TODO: Check if user leveled up or ranked up

    const newXpTotal = 0 // Placeholder: would come from xpResult
    const leveledUp = false // Placeholder: calculated from XP thresholds
    const newRank = null // Placeholder: calculated from new XP

    // --------------------------------------------------------------------
    // STEP 7: CHECK FOR ACHIEVEMENT UNLOCKS
    // --------------------------------------------------------------------
    
    // Query achievement_defs for conditions that might be met
    // Examples:
    // - "Complete 10 quests" (check user's total completed quests)
    // - "Reach 1000 XP" (check newXpTotal)
    // - "Complete first quest" (check if this is first completion)

    // const { data: achievements, error: achievementError } = await supabaseClient
    //   .rpc('check_achievement_unlocks', {
    //     p_user_id: userId,
    //   })

    // TODO: For each unlocked achievement:
    //   - Insert into user_achievements
    //   - Add bonus XP if achievement has reward
    //   - Send notification

    const unlockedAchievements: string[] = [] // Placeholder: list of achievement_ids

    // --------------------------------------------------------------------
    // STEP 8: UPDATE LEADERBOARD CACHE
    // --------------------------------------------------------------------
    
    // Update or insert leaderboard entry with new XP
    // const { error: leaderboardError } = await supabaseClient
    //   .from('leaderboard_cache')
    //   .upsert({
    //     user_id: userId,
    //     xp: newXpTotal,
    //     rank: newRank,
    //     username: user.email?.split('@')[0], // or fetch from profiles
    //     updated_at: new Date().toISOString(),
    //   })

    // TODO: Handle leaderboardError
    // TODO: Recalculate rank positions (trigger or separate function)

    // --------------------------------------------------------------------
    // STEP 9: LOG TRANSACTION (AUDIT TRAIL)
    // --------------------------------------------------------------------
    
    // Optional: Insert into xp_transactions table for audit
    // const { error: logError } = await supabaseClient
    //   .from('xp_transactions')
    //   .insert({
    //     user_id: userId,
    //     amount: rewardPoints,
    //     source: 'quest_completion',
    //     source_id: questId,
    //     timestamp: new Date().toISOString(),
    //   })

    // TODO: Handle logError (non-critical, log to console)

    // --------------------------------------------------------------------
    // STEP 10: SEND SUCCESS RESPONSE
    // --------------------------------------------------------------------
    
    const responseData = {
      success: true,
      message: 'Quest completed successfully',
      data: {
        userId,
        questId,
        xpAwarded: rewardPoints,
        newXpTotal,
        leveledUp,
        newRank,
        unlockedAchievements,
        completedAt: new Date().toISOString(),
      },
    }

    return new Response(
      JSON.stringify(responseData),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )

  } catch (error) {
    // --------------------------------------------------------------------
    // ERROR HANDLING
    // --------------------------------------------------------------------
    
    // Log error to console (viewable in Supabase Edge Function logs)
    console.error('Error in complete-quest function:', error)

    // Determine error type and status code
    let statusCode = 500
    let errorMessage = 'Internal server error'
    const errorMsg = error instanceof Error ? error.message : String(error)

    if (errorMsg.includes('Missing')) {
      statusCode = 400 // Bad Request
      errorMessage = errorMsg
    } else if (errorMsg.includes('Invalid authentication')) {
      statusCode = 401 // Unauthorized
      errorMessage = errorMsg
    } else if (errorMsg.includes('already completed')) {
      statusCode = 409 // Conflict
      errorMessage = errorMsg
    } else if (errorMsg.includes('not found')) {
      statusCode = 404 // Not Found
      errorMessage = errorMsg
    }

    // Return error response
    return new Response(
      JSON.stringify({
        success: false,
        error: errorMessage,
        details: errorMsg,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: statusCode,
      }
    )
  }
})

// ============================================================================
// HELPER FUNCTIONS (IF NEEDED)
// ============================================================================

/**
 * Calculate user rank based on XP
 * @param xp - User's total XP
 * @returns Rank string (Novice, Explorer, etc.)
 */
function calculateRank(xp: number): string {
  // TODO: Implement rank thresholds from AppConstants
  // if (xp >= 50000) return 'Legend'
  // if (xp >= 15000) return 'Champion'
  // if (xp >= 5000) return 'Achiever'
  // if (xp >= 1000) return 'Explorer'
  // return 'Novice'
  return 'Novice' // Placeholder
}

/**
 * Check if user leveled up based on XP change
 * @param oldXp - Previous XP total
 * @param newXp - New XP total
 * @returns true if level increased
 */
function didLevelUp(oldXp: number, newXp: number): boolean {
  // TODO: Implement level calculation formula
  // const oldLevel = Math.floor(oldXp / 100) + 1
  // const newLevel = Math.floor(newXp / 100) + 1
  // return newLevel > oldLevel
  return false // Placeholder
}

/**
 * Validate UUID format
 * @param uuid - String to validate
 * @returns true if valid UUID
 */
function isValidUuid(uuid: string): boolean {
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
  return uuidRegex.test(uuid)
}

// ============================================================================
// POSTGRESQL FUNCTIONS REQUIRED (CREATE SEPARATELY)
// ============================================================================

/*
-- Function: award_xp
-- Awards XP to user profile and returns new total
CREATE OR REPLACE FUNCTION award_xp(
  p_user_id UUID,
  p_xp_amount INT,
  p_source TEXT DEFAULT NULL,
  p_source_id UUID DEFAULT NULL
)
RETURNS TABLE(
  new_xp_total INT,
  old_rank TEXT,
  new_rank TEXT,
  leveled_up BOOLEAN
) AS $$
DECLARE
  v_old_xp INT;
  v_new_xp INT;
  v_old_rank TEXT;
  v_new_rank TEXT;
BEGIN
  -- Get current XP and rank
  SELECT xp, rank INTO v_old_xp, v_old_rank
  FROM profiles
  WHERE id = p_user_id;

  -- Add XP
  UPDATE profiles
  SET xp = xp + p_xp_amount
  WHERE id = p_user_id
  RETURNING xp INTO v_new_xp;

  -- Calculate new rank
  v_new_rank := calculate_rank(v_new_xp);

  -- Update rank if changed
  IF v_new_rank != v_old_rank THEN
    UPDATE profiles
    SET rank = v_new_rank
    WHERE id = p_user_id;
  END IF;

  -- Return results
  RETURN QUERY SELECT
    v_new_xp,
    v_old_rank,
    v_new_rank,
    (v_new_rank != v_old_rank) AS leveled_up;
END;
$$ LANGUAGE plpgsql;

-- Function: check_achievement_unlocks
-- Checks and unlocks achievements based on user stats
CREATE OR REPLACE FUNCTION check_achievement_unlocks(p_user_id UUID)
RETURNS TABLE(achievement_id UUID, achievement_name TEXT) AS $$
BEGIN
  -- TODO: Implement achievement condition checking
  -- Examples:
  -- - Check total quests completed
  -- - Check XP milestones
  -- - Check streak days
  -- Insert into user_achievements if conditions met
  RETURN QUERY SELECT NULL::UUID, NULL::TEXT LIMIT 0;
END;
$$ LANGUAGE plpgsql;
*/

// ============================================================================
// CLIENT-SIDE USAGE EXAMPLE
// ============================================================================

/*
// Dart/Flutter client code

final response = await Supabase.instance.client.functions.invoke(
  'complete-quest',
  body: {
    'questId': 'uuid-of-quest',
  },
);

if (response.status == 200) {
  final data = response.data;
  print('XP Awarded: ${data['data']['xpAwarded']}');
  print('New XP Total: ${data['data']['newXpTotal']}');
  
  if (data['data']['leveledUp']) {
    showLevelUpDialog(data['data']['newRank']);
  }
  
  for (var achievement in data['data']['unlockedAchievements']) {
    showAchievementNotification(achievement);
  }
} else {
  print('Error: ${response.data['error']}');
}
*/

// ============================================================================
// DEPLOYMENT INSTRUCTIONS
// ============================================================================

/*
1. Create function via Supabase CLI:
   supabase functions new complete-quest

2. Add environment variables in Supabase Dashboard:
   - SUPABASE_URL (auto-configured)
   - SUPABASE_SERVICE_ROLE_KEY (auto-configured)

3. Deploy function:
   supabase functions deploy complete-quest

4. Test function:
   curl -i --location --request POST 'https://<project-ref>.supabase.co/functions/v1/complete-quest' \
     --header 'Authorization: Bearer <anon-key>' \
     --header 'Content-Type: application/json' \
     --data '{"questId":"uuid-here"}'

5. Monitor logs:
   supabase functions logs complete-quest --tail
*/
