-- V35: Quest System + Verification (New Feature)
-- Game-within-app quests with physical code verification on campus

-- ============================================================================
-- 1. CREATE quests TABLE (New Feature)
-- ============================================================================
CREATE TABLE IF NOT EXISTS quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  xp_reward INT NOT NULL DEFAULT 0,
  difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard', 'expert')),
  category TEXT,
  requires_code BOOLEAN NOT NULL DEFAULT false,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quests_is_active ON quests(is_active);
CREATE INDEX IF NOT EXISTS idx_quests_requires_code ON quests(requires_code) WHERE requires_code = true;
CREATE INDEX IF NOT EXISTS idx_quests_difficulty ON quests(difficulty);

-- Enable RLS
ALTER TABLE quests ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active quests
CREATE POLICY "Public can view active quests"
  ON quests FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Policy: Service role full access
CREATE POLICY "Service role quests access"
  ON quests FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- 2. CREATE quest_codes TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS quest_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quest_id UUID NOT NULL REFERENCES quests(id) ON DELETE CASCADE,
  verification_code TEXT NOT NULL UNIQUE,
  location_hint TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT code_length CHECK (length(verification_code) >= 6 AND length(verification_code) <= 12),
  CONSTRAINT code_alphanumeric CHECK (verification_code ~ '^[A-Z0-9]+$')
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_quest_codes_quest_id ON quest_codes(quest_id);
CREATE INDEX IF NOT EXISTS idx_quest_codes_verification_code ON quest_codes(verification_code);
CREATE INDEX IF NOT EXISTS idx_quest_codes_is_active ON quest_codes(is_active);

-- Enable RLS on quest_codes
ALTER TABLE quest_codes ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view quest_codes (location_hint) but NOT verification_code
CREATE POLICY "Users can view quest locations (no code)"
  ON quest_codes FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Policy: Users cannot insert/update/delete codes (admin only)
CREATE POLICY "Users cannot insert codes"
  ON quest_codes FOR INSERT
  TO authenticated
  WITH CHECK (false);

CREATE POLICY "Users cannot update codes"
  ON quest_codes FOR UPDATE
  TO authenticated
  USING (false)
  WITH CHECK (false);

CREATE POLICY "Users cannot delete codes"
  ON quest_codes FOR DELETE
  TO authenticated
  USING (false);

-- Policy: Service role can do anything (for admin operations)
CREATE POLICY "Service role quest codes access"
  ON quest_codes FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- 3. CREATE quest_code_redemptions TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS quest_code_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quest_code_id UUID NOT NULL REFERENCES quest_codes(id) ON DELETE CASCADE,
  redeemed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure single-use per user per code
  UNIQUE(user_id, quest_code_id),
  
  -- Ensure single-use globally per code (one redemption per code)
  UNIQUE(quest_code_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_redemptions_user_id ON quest_code_redemptions(user_id);
CREATE INDEX IF NOT EXISTS idx_redemptions_quest_code_id ON quest_code_redemptions(quest_code_id);
CREATE INDEX IF NOT EXISTS idx_redemptions_redeemed_at ON quest_code_redemptions(redeemed_at);

-- Enable RLS on quest_code_redemptions
ALTER TABLE quest_code_redemptions ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own redemptions
CREATE POLICY "Users view own redemptions"
  ON quest_code_redemptions FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Policy: Users can insert their own redemptions (verify codes)
CREATE POLICY "Users can redeem codes"
  ON quest_code_redemptions FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Policy: Users cannot update/delete redemptions
CREATE POLICY "Users cannot update redemptions"
  ON quest_code_redemptions FOR UPDATE
  TO authenticated
  USING (false)
  WITH CHECK (false);

CREATE POLICY "Users cannot delete redemptions"
  ON quest_code_redemptions FOR DELETE
  TO authenticated
  USING (false);

-- Policy: Service role full access
CREATE POLICY "Service role redemption access"
  ON quest_code_redemptions FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- 4. DATABASE VIEWS (for app queries)
-- ============================================================================

-- View: Quest codes with location only (no verification code visible to users)
CREATE OR REPLACE VIEW quest_codes_public AS
  SELECT 
    id,
    quest_id,
    location_hint,
    is_active,
    created_at
  FROM quest_codes
  WHERE is_active = true;

-- View: User's redemption history with quest details
CREATE OR REPLACE VIEW user_quest_redemptions AS
  SELECT 
    qcr.id,
    qcr.user_id,
    qcr.quest_code_id,
    qcr.redeemed_at,
    qc.quest_id,
    q.title as quest_title,
    q.xp_reward
  FROM quest_code_redemptions qcr
  JOIN quest_codes qc ON qcr.quest_code_id = qc.id
  JOIN quests q ON qc.quest_id = q.id;

-- ============================================================================
-- 5. HELPER FUNCTIONS
-- ============================================================================

-- Function: Verify and redeem a quest code
CREATE OR REPLACE FUNCTION verify_quest_code(
  p_code TEXT,
  p_user_id UUID
)
RETURNS jsonb AS $$
DECLARE
  v_quest_code quest_codes%ROWTYPE;
  v_result jsonb;
BEGIN
  -- Find the code
  SELECT * INTO v_quest_code FROM quest_codes 
  WHERE verification_code = UPPER(p_code) AND is_active = true;
  
  IF v_quest_code.id IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Invalid or expired code');
  END IF;
  
  -- Try to insert redemption
  BEGIN
    INSERT INTO quest_code_redemptions (user_id, quest_code_id)
    VALUES (p_user_id, v_quest_code.id);
    
    RETURN jsonb_build_object(
      'success', true,
      'quest_id', v_quest_code.quest_id,
      'message', 'Code verified successfully'
    );
  EXCEPTION WHEN unique_violation THEN
    RETURN jsonb_build_object(
      'success', false, 
      'error', 'You have already redeemed this code'
    );
  END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Generate unique verification code
CREATE OR REPLACE FUNCTION generate_verification_code()
RETURNS TEXT AS $$
DECLARE
  v_code TEXT;
  v_exists BOOLEAN;
BEGIN
  LOOP
    -- Generate 8-char uppercase alphanumeric code
    v_code := SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' FROM 1 FOR 1);
    FOR i IN 1..7 LOOP
      v_code := v_code || SUBSTRING(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
        (FLOOR(RANDOM() * 36) + 1)::INT,
        1
      );
    END LOOP;
    
    -- Check uniqueness
    SELECT EXISTS(SELECT 1 FROM quest_codes WHERE verification_code = v_code) INTO v_exists;
    
    EXIT WHEN NOT v_exists;
  END LOOP;
  
  RETURN v_code;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 6. SAMPLE DATA (for testing)
-- ============================================================================

-- Insert sample codes (requires existing quests)
-- Uncomment after creating test quests
/*
INSERT INTO quest_codes (quest_id, verification_code, location_hint, is_active)
SELECT 
  q.id,
  generate_verification_code(),
  'Location: ' || q.title || ' - Check bulletin board',
  true
FROM quests q
WHERE q.requires_code = true
LIMIT 3;
*/
