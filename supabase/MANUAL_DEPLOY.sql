-- V35: Complete Quest System Deployment
-- Run this in Supabase SQL Editor if migrations fail

-- ============================================================================
-- 1. CREATE quests TABLE
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

CREATE INDEX IF NOT EXISTS idx_quests_is_active ON quests(is_active);
CREATE INDEX IF NOT EXISTS idx_quests_requires_code ON quests(requires_code) WHERE requires_code = true;

ALTER TABLE quests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view active quests" ON quests FOR SELECT
  TO authenticated USING (is_active = true);

CREATE POLICY "Service role quests access" ON quests FOR ALL
  TO service_role USING (true) WITH CHECK (true);

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
  CONSTRAINT code_length CHECK (length(verification_code) >= 6 AND length(verification_code) <= 12),
  CONSTRAINT code_alphanumeric CHECK (verification_code ~ '^[A-Z0-9]+$')
);

CREATE INDEX IF NOT EXISTS idx_quest_codes_quest_id ON quest_codes(quest_id);
CREATE INDEX IF NOT EXISTS idx_quest_codes_verification_code ON quest_codes(verification_code);

ALTER TABLE quest_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view quest locations" ON quest_codes FOR SELECT
  TO authenticated USING (is_active = true);

CREATE POLICY "Service role quest codes access" ON quest_codes FOR ALL
  TO service_role USING (true) WITH CHECK (true);

-- ============================================================================
-- 3. CREATE quest_code_redemptions TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS quest_code_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quest_code_id UUID NOT NULL REFERENCES quest_codes(id) ON DELETE CASCADE,
  redeemed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, quest_code_id),
  UNIQUE(quest_code_id)
);

CREATE INDEX IF NOT EXISTS idx_redemptions_user_id ON quest_code_redemptions(user_id);
CREATE INDEX IF NOT EXISTS idx_redemptions_quest_code_id ON quest_code_redemptions(quest_code_id);

ALTER TABLE quest_code_redemptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users view own redemptions" ON quest_code_redemptions FOR SELECT
  TO authenticated USING (user_id = auth.uid());

CREATE POLICY "Users can redeem codes" ON quest_code_redemptions FOR INSERT
  TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "Service role redemption access" ON quest_code_redemptions FOR ALL
  TO service_role USING (true) WITH CHECK (true);

-- ============================================================================
-- 4. HELPER FUNCTIONS
-- ============================================================================
CREATE OR REPLACE FUNCTION verify_quest_code_db(p_code TEXT, p_user_id UUID)
RETURNS jsonb AS $$
DECLARE
  v_quest_code quest_codes%ROWTYPE;
BEGIN
  SELECT * INTO v_quest_code FROM quest_codes 
  WHERE verification_code = UPPER(p_code) AND is_active = true;
  
  IF v_quest_code.id IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Invalid or expired code');
  END IF;
  
  BEGIN
    INSERT INTO quest_code_redemptions (user_id, quest_code_id)
    VALUES (p_user_id, v_quest_code.id);
    
    RETURN jsonb_build_object('success', true, 'quest_id', v_quest_code.quest_id);
  EXCEPTION WHEN unique_violation THEN
    RETURN jsonb_build_object('success', false, 'error', 'Already redeemed');
  END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION generate_verification_code()
RETURNS TEXT AS $$
DECLARE
  v_code TEXT;
  v_exists BOOLEAN;
BEGIN
  LOOP
    v_code := '';
    FOR i IN 1..8 LOOP
      v_code := v_code || SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
        (FLOOR(RANDOM() * 36) + 1)::INT, 1);
    END LOOP;
    
    SELECT EXISTS(SELECT 1 FROM quest_codes WHERE verification_code = v_code) INTO v_exists;
    EXIT WHEN NOT v_exists;
  END LOOP;
  
  RETURN v_code;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 5. QUEST ACHIEVEMENTS
-- ============================================================================
INSERT INTO achievement_defs (id, name, trigger_type, target_value, reward_xp, reward_type)
VALUES 
  (gen_random_uuid(), 'First Quest', 'quest_completed', 1, 50, 'xp'),
  (gen_random_uuid(), 'Campus Explorer', 'quests_count', 5, 200, 'xp'),
  (gen_random_uuid(), 'Quest Veteran', 'quests_count', 10, 500, 'xp'),
  (gen_random_uuid(), 'Quest Master', 'quests_count', 25, 1000, 'xp');

CREATE OR REPLACE FUNCTION update_quest_achievements()
RETURNS TRIGGER AS $$
BEGIN
  WITH quest_count AS (
    SELECT COUNT(*) as total FROM quest_code_redemptions WHERE user_id = NEW.user_id
  )
  INSERT INTO user_achievements (user_id, achievement_id, progress, is_done, unlocked_at)
  SELECT 
    NEW.user_id, ad.id, qc.total,
    qc.total >= ad.target_value,
    CASE WHEN qc.total >= ad.target_value THEN NOW() ELSE NULL END
  FROM achievement_defs ad
  CROSS JOIN quest_count qc
  WHERE ad.trigger_type IN ('quest_completed', 'quests_count')
  ON CONFLICT (user_id, achievement_id) 
  DO UPDATE SET
    progress = EXCLUDED.progress,
    is_done = EXCLUDED.is_done,
    unlocked_at = CASE WHEN EXCLUDED.is_done AND user_achievements.unlocked_at IS NULL 
                   THEN NOW() ELSE user_achievements.unlocked_at END;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_quest_achievements ON quest_code_redemptions;
CREATE TRIGGER trigger_update_quest_achievements
  AFTER INSERT ON quest_code_redemptions
  FOR EACH ROW EXECUTE FUNCTION update_quest_achievements();
