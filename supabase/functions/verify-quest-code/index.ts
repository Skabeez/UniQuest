// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface VerifyQuestRequest {
  userId: string
  questId: string
  userInputCode: string
}

interface VerifyQuestResponse {
  success: boolean
  message?: string
  error?: string
  xpAwarded?: number
  questTitle?: string
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Initialize Supabase client with service role (admin access)
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // Parse request
    const { userId, questId, userInputCode }: VerifyQuestRequest = await req.json()

    // Validate inputs
    if (!userId || !questId || !userInputCode) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: 'Missing required fields: userId, questId, or userInputCode' 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // 1. Check if quest exists and requires code
    const { data: quest, error: questError } = await supabaseClient
      .from('quests')
      .select('id, title, xp_reward, requires_code, is_active')
      .eq('id', questId)
      .single()

    if (questError || !quest) {
      return new Response(
        JSON.stringify({ success: false, error: 'Quest not found' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    if (!quest.is_active) {
      return new Response(
        JSON.stringify({ success: false, error: 'Quest is no longer active' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    if (!quest.requires_code) {
      return new Response(
        JSON.stringify({ success: false, error: 'This quest does not require a code' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // 2. Lookup code in quest_codes
    const { data: questCode, error: codeError } = await supabaseClient
      .from('quest_codes')
      .select('id, verification_code, quest_id')
      .eq('quest_id', questId)
      .eq('is_active', true)
      .single()

    if (codeError || !questCode) {
      return new Response(
        JSON.stringify({ success: false, error: 'Verification code not found for this quest' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // 3. Validate userInputCode == verification_code (case-insensitive)
    if (questCode.verification_code.toUpperCase() !== userInputCode.toUpperCase()) {
      return new Response(
        JSON.stringify({ success: false, error: 'Invalid verification code' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // 4. Check if user already redeemed this code
    const { data: existingRedemption, error: redemptionCheckError } = await supabaseClient
      .from('quest_code_redemptions')
      .select('id')
      .eq('user_id', userId)
      .eq('quest_code_id', questCode.id)
      .maybeSingle()

    if (existingRedemption) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: 'You have already completed this quest' 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // 5. Valid and not redeemed - Insert redemption record
    const { error: insertError } = await supabaseClient
      .from('quest_code_redemptions')
      .insert({
        user_id: userId,
        quest_code_id: questCode.id,
        redeemed_at: new Date().toISOString()
      })

    if (insertError) {
      console.error('Insert error:', insertError)
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: 'Failed to record quest completion' 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
      )
    }

    // 6. Award XP to user profile
    const { error: xpError } = await supabaseClient.rpc('add_user_xp', {
      p_user_id: userId,
      p_xp_amount: quest.xp_reward
    })

    if (xpError) {
      console.error('XP award error:', xpError)
      // Don't fail the request, just log it
    }

    // Success response
    return new Response(
      JSON.stringify({
        success: true,
        message: `Quest "${quest.title}" completed successfully!`,
        xpAwarded: quest.xp_reward,
        questTitle: quest.title
      } as VerifyQuestResponse),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message || 'Internal server error' 
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
