# Quest Expiration & Retirement - SQL Updates

## Database Schema Changes

Run the following SQL in your Supabase SQL Editor to add expiration and retirement functionality:

```sql
-- Add expiration_date and is_retired columns to quests table
ALTER TABLE quests 
ADD COLUMN IF NOT EXISTS expiration_date TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS is_retired BOOLEAN DEFAULT FALSE;

-- Add daily XP limit tracking to profiles table
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS daily_task_xp_limit INT DEFAULT 50,
ADD COLUMN IF NOT EXISTS task_xp_earned_today INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS task_xp_reset_date DATE;

-- Create index on expiration_date for faster queries
CREATE INDEX IF NOT EXISTS idx_quests_expiration_date ON quests(expiration_date);
CREATE INDEX IF NOT EXISTS idx_quests_is_retired ON quests(is_retired);
CREATE INDEX IF NOT EXISTS idx_profiles_xp_reset_date ON profiles(task_xp_reset_date);

-- Update comments for documentation
COMMENT ON COLUMN quests.expiration_date IS 'Optional expiration date - quest becomes unavailable after this date';
COMMENT ON COLUMN quests.is_retired IS 'Admin-controlled retirement flag - hides quest from students';
COMMENT ON COLUMN profiles.daily_task_xp_limit IS 'Maximum XP user can earn from tasks per day (default 50)';
COMMENT ON COLUMN profiles.task_xp_earned_today IS 'XP earned from tasks today - resets daily';
COMMENT ON COLUMN profiles.task_xp_reset_date IS 'Date when task_xp_earned_today was last reset';
```

## Daily Task XP Limit System

The daily task XP limit prevents users from farming XP by creating and completing unlimited tasks. Here's how it works:

### Key Features:
- **Default Limit:** 500 XP per day from user-created tasks (configurable per user)
- **Quest XP:** Unlimited - admin-created quests are NOT affected by this limit
- **Daily Reset:** Counter resets at midnight (based on user's local date)
- **Partial Awards:** If a task would exceed the limit, users get partial XP (e.g., 10 XP remaining, 50 XP task = 10 XP awarded)
- **Transparent Feedback:** Users see clear messages about their daily progress and limit

### Database Fields:
- `daily_task_xp_limit` - Maximum XP from tasks per day (default 500)
- `task_xp_earned_today` - Running counter of XP earned from tasks today
- `task_xp_reset_date` - Date of last reset (used to detect new day)

### Client-Side Logic:
The Flutter app (`menu_task_widget.dart`) handles:
1. Checking current daily XP earned vs limit
2. Detecting date change and resetting counter
3. Calculating partial XP awards
4. Updating profile with new XP and reset date
5. Showing appropriate user feedback

### Example Scenarios:

**Scenario 1: Under Limit**
- User has earned 450/500 XP today
- Completes 30 XP task
- Result: Gets full 30 XP, now at 480/500
- Message: "Task completed! You earned +30 XP! Daily task XP: 480/500"

**Scenario 2: Partial Award**
- User has earned 490/500 XP today
- Completes 50 XP task
- Result: Gets 10 XP (remaining allowance), now at 500/500
- Message: "Task completed! You've reached your daily XP limit (500 XP/day). XP awarded: +10 XP. Quests still earn unlimited XP!"

**Scenario 3: Limit Reached**
- User has earned 500/500 XP today
- Completes 30 XP task
- Result: Gets 0 XP (task still marked complete)
- Message: "Task completed! You've reached your daily XP limit (500 XP/day). Quests still earn unlimited XP!"

**Scenario 4: New Day**
- User earned 500 XP yesterday
- Completes 20 XP task today
- Result: Counter resets, gets full 20 XP, now at 20/500
- Message: "Task completed! You earned +20 XP! Daily task XP: 20/500"

### Why This Design?

1. **Anti-Exploit:** Prevents users from creating 100 fake tasks worth 10 XP each to farm XP
2. **Fair Gameplay:** Keeps task-based XP earning reasonable and balanced
3. **Quest Priority:** Admin-created quests remain valuable and unlimited
4. **User-Friendly:** Transparent limits with clear feedback
5. **Configurable:** Admins can adjust per-user limits if needed



Replace your existing `process_quest_code_redemption()` function with this updated version that checks expiration:

```sql
CREATE OR REPLACE FUNCTION process_quest_code_redemption()
RETURNS TRIGGER AS $$
DECLARE
  v_quest_id UUID;
  v_max_uses INT;
  v_current_uses INT;
  v_xp_reward INT;
  v_user_xp INT;
  v_user_level INT;
  v_quest_title TEXT;
  v_expiration_date TIMESTAMPTZ;
  v_is_retired BOOLEAN;
BEGIN
  -- Get the quest_id and max_uses from quest_codes
  SELECT quest_id, max_uses 
  INTO v_quest_id, v_max_uses
  FROM quest_codes
  WHERE UPPER(TRIM(code)) = UPPER(TRIM(NEW.code))
  AND (max_uses IS NULL OR max_uses > 0);

  -- If code doesn't exist or has no uses left
  IF v_quest_id IS NULL THEN
    RAISE EXCEPTION 'Invalid or expired quest code';
  END IF;

  -- Get quest details including expiration and retirement status
  SELECT xp_reward, title, expiration_date, is_retired
  INTO v_xp_reward, v_quest_title, v_expiration_date, v_is_retired
  FROM quests
  WHERE id = v_quest_id
  AND is_active = true;

  -- Check if quest is retired
  IF v_is_retired = true THEN
    RAISE EXCEPTION 'This quest has been retired and is no longer available';
  END IF;

  -- Check if quest has expired
  IF v_expiration_date IS NOT NULL AND v_expiration_date < NOW() THEN
    RAISE EXCEPTION 'This quest has expired';
  END IF;

  -- Check if quest exists and is active
  IF v_xp_reward IS NULL THEN
    RAISE EXCEPTION 'Quest not found or inactive';
  END IF;

  -- Check if user already redeemed this code
  IF EXISTS (
    SELECT 1 FROM quest_code_redemptions 
    WHERE user_id = NEW.user_id 
    AND code = UPPER(TRIM(NEW.code))
  ) THEN
    RAISE EXCEPTION 'You have already redeemed this quest code';
  END IF;

  -- Check if max uses exceeded
  IF v_max_uses IS NOT NULL THEN
    SELECT COUNT(*) INTO v_current_uses
    FROM quest_code_redemptions
    WHERE code = UPPER(TRIM(NEW.code));

    IF v_current_uses >= v_max_uses THEN
      RAISE EXCEPTION 'This quest code has reached its maximum number of uses';
    END IF;
  END IF;

  -- Normalize the code
  NEW.code := UPPER(TRIM(NEW.code));
  NEW.quest_id := v_quest_id;
  NEW.redeemed_at := NOW();

  -- Update user XP and calculate level
  UPDATE profiles
  SET 
    xp = xp + v_xp_reward,
    level = FLOOR(((xp + v_xp_reward) / 100.0)) + 1
  WHERE uid = NEW.user_id
  RETURNING xp, level INTO v_user_xp, v_user_level;

  -- Create or update quest_progress
  INSERT INTO quest_progress (user_id, quest_id, status, completed_at)
  VALUES (NEW.user_id, v_quest_id, 'completed', NOW())
  ON CONFLICT (user_id, quest_id) 
  DO UPDATE SET 
    status = 'completed',
    completed_at = NOW();

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Ensure trigger is set up (recreate if exists)
DROP TRIGGER IF EXISTS on_quest_code_redemption ON quest_code_redemptions;
CREATE TRIGGER on_quest_code_redemption
  BEFORE INSERT ON quest_code_redemptions
  FOR EACH ROW
  EXECUTE FUNCTION process_quest_code_redemption();
```

## RLS Policy Updates (if needed)

Ensure admin can update expiration and retirement fields:

```sql
-- Update the admin update policy to include new fields
DROP POLICY IF EXISTS "Admins can update quests" ON quests;

CREATE POLICY "Admins can update quests"
ON quests
FOR UPDATE
TO authenticated
USING (
  (SELECT raw_user_meta_data->>'email' FROM auth.users WHERE id = auth.uid()) 
  = 'andreedave.teodoro@cvsu.edu.ph'
)
WITH CHECK (
  (SELECT raw_user_meta_data->>'email' FROM auth.users WHERE id = auth.uid()) 
  = 'andreedave.teodoro@cvsu.edu.ph'
);
```

## Testing Checklist

After running the SQL updates:

1. **Test Quest Creation**
   - Create a quest with no expiration date (should work normally)
   - Create a quest with future expiration date (should appear in quest list)
   - Create a quest with past expiration date (should NOT appear in student view)

2. **Test Quest Retirement**
   - Create an active quest
   - Edit it and mark as "Retired"
   - Verify it disappears from student quest list
   - Verify it still appears in admin dashboard

3. **Test Code Redemption**
   - Try redeeming code for expired quest (should fail with "This quest has expired")
   - Try redeeming code for retired quest (should fail with "This quest has been retired...")
   - Try redeeming valid quest code (should succeed)

4. **Test Quest Editing**
   - Edit existing quest to add expiration date
   - Edit existing quest to set retirement status
   - Clear expiration date (click X button in date picker)
   - Toggle retirement on/off

## Features Added

### Admin Capabilities:
- ✅ Set optional expiration date when creating quests
- ✅ Update expiration date on existing quests
- ✅ Mark quests as "Retired" to hide from students
- ✅ Toggle retirement status at any time
- ✅ Clear expiration dates

### Student Experience:
- ✅ Only see active, non-retired, non-expired quests
- ✅ Cannot redeem codes for expired quests
- ✅ Cannot redeem codes for retired quests
- ✅ Clear error messages explaining why redemption failed

### Automatic Behavior:
- ✅ Quests automatically hidden when expiration date passes
- ✅ Database trigger validates expiration before redemption
- ✅ Indexes optimize query performance
