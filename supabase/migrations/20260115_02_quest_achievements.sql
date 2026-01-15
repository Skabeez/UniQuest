-- V35: Quest Achievement Triggers
-- Add quest-related achievements

-- Insert quest achievement definitions
INSERT INTO achievement_defs (id, name, trigger_type, target_value, reward_xp, reward_type, image_url)
VALUES 
  (gen_random_uuid(), 'First Quest', 'quest_completed', 1, 50, 'xp', NULL),
  (gen_random_uuid(), 'Campus Explorer', 'quests_count', 5, 200, 'xp', NULL),
  (gen_random_uuid(), 'Quest Veteran', 'quests_count', 10, 500, 'xp', NULL),
  (gen_random_uuid(), 'Quest Master', 'quests_count', 25, 1000, 'xp', NULL);

-- Create function to update quest achievements when user completes quests
CREATE OR REPLACE FUNCTION update_quest_achievements()
RETURNS TRIGGER AS $$
BEGIN
  -- Update 'quest_completed' achievement (first quest)
  WITH first_quest_achievement AS (
    SELECT id FROM achievement_defs 
    WHERE trigger_type = 'quest_completed' AND target_value = 1 
    LIMIT 1
  )
  INSERT INTO user_achievements (user_id, achievement_id, progress, is_done)
  SELECT NEW.user_id, fqa.id, 1, true
  FROM first_quest_achievement fqa
  WHERE NOT EXISTS (
    SELECT 1 FROM user_achievements 
    WHERE user_id = NEW.user_id AND achievement_id = fqa.id
  );

  -- Update 'quests_count' achievements
  WITH quest_count AS (
    SELECT COUNT(*) as total
    FROM quest_code_redemptions
    WHERE user_id = NEW.user_id
  )
  INSERT INTO user_achievements (user_id, achievement_id, progress, is_done, unlocked_at)
  SELECT 
    NEW.user_id,
    ad.id,
    qc.total,
    qc.total >= ad.target_value,
    CASE WHEN qc.total >= ad.target_value THEN NOW() ELSE NULL END
  FROM achievement_defs ad
  CROSS JOIN quest_count qc
  WHERE ad.trigger_type = 'quests_count'
  ON CONFLICT (user_id, achievement_id) 
  DO UPDATE SET
    progress = EXCLUDED.progress,
    is_done = EXCLUDED.is_done,
    unlocked_at = CASE 
      WHEN EXCLUDED.is_done AND user_achievements.unlocked_at IS NULL 
      THEN NOW() 
      ELSE user_achievements.unlocked_at 
    END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_update_quest_achievements ON quest_code_redemptions;
CREATE TRIGGER trigger_update_quest_achievements
  AFTER INSERT ON quest_code_redemptions
  FOR EACH ROW
  EXECUTE FUNCTION update_quest_achievements();
