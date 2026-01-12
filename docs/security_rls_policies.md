# RLS (Row Level Security) Implementation

## Overview

### What is RLS?
- Database-level security mechanism built into PostgreSQL/Supabase
- Enforces data access rules at the row level
- Prevents unauthorized access even if application code is compromised
- Applies to all database queries (SELECT, INSERT, UPDATE, DELETE)

### Why RLS for UniQuest?
- Protects user privacy (users can only see their own data)
- Prevents data manipulation attacks
- Enforces business rules at database level
- Demonstrates security-first architecture for SE defense
- Complements Supabase Auth for end-to-end security

### Implementation Approach
- Enable RLS on all user-facing tables
- Create policies using `auth.uid()` to match authenticated user
- Separate policies for different operations (SELECT, INSERT, UPDATE, DELETE)
- Service role bypass for admin/system operations
- Read-only policies for public data (leaderboard, definitions)

---

## Policy Summary Table

| Table | SELECT | INSERT | UPDATE | DELETE | Security Model |
|-------|--------|--------|--------|--------|----------------|
| **profiles** | Own row only (`auth.uid() = id`) | Own row (signup) | Own row | ❌ Blocked | User owns profile |
| **user_missions** | Own rows (`auth.uid() = user_id`) | Own rows | Own rows | ❌ Blocked | User owns quest progress |
| **user_achievements** | Own rows | ⚠️ Service role only | ⚠️ Service role only | ❌ Blocked | System-awarded |
| **user_cosmetics** | Own rows | Own rows | Own rows | ❌ Blocked | User owns cosmetics |
| **leaderboard_cache** | ✅ All rows | ⚠️ Service role only | ⚠️ Service role only | ⚠️ Service role only | Public read-only |
| **missions** | ✅ All rows | ⚠️ Admin only | ⚠️ Admin only | ⚠️ Admin only | Reference data |
| **achievement_defs** | ✅ All rows | ⚠️ Admin only | ⚠️ Admin only | ⚠️ Admin only | Reference data |
| **cosmetic_defs** | ✅ All rows | ⚠️ Admin only | ⚠️ Admin only | ⚠️ Admin only | Reference data |

### Policy Types

#### User-Owned Data Policies
- **Pattern:** `USING (auth.uid() = user_id)` + `WITH CHECK (auth.uid() = user_id)`
- **Tables:** profiles, user_missions, user_cosmetics
- **Purpose:** Users can only access/modify their own records
- **Example:** User A cannot read/write User B's quest progress

#### Read-Only Public Data Policies
- **Pattern:** `FOR SELECT USING (true)` + No INSERT/UPDATE/DELETE policies
- **Tables:** leaderboard_cache, missions, achievement_defs, cosmetic_defs
- **Purpose:** All users can view reference data, but cannot modify
- **Example:** Anyone can see leaderboard rankings, but only system updates them

#### System-Managed Data Policies
- **Pattern:** `TO service_role USING (true)`
- **Tables:** user_achievements (awards), leaderboard_cache (updates)
- **Purpose:** Only backend functions can create/modify system data
- **Example:** Achievements awarded via triggers, not direct user INSERT

---

## Security Guarantees

### Data Isolation
- **User A cannot access User B's data**
  - Profile information (XP, rank, cosmetics)
  - Quest progress and completion status
  - Achievement unlock timestamps
  - Cosmetic inventory
- **Enforced at database level** (not just application layer)
- **Applies to all queries** (API, direct DB access, SQL injections)

### Prevention of Unauthorized Modifications
- **Users cannot:**
  - Modify other users' profiles
  - Award themselves achievements
  - Alter leaderboard rankings
  - Change quest definitions
  - Delete their quest history (audit trail preserved)
- **System operations protected:**
  - Only service role can award achievements
  - Only service role can update leaderboard cache
  - Only admins can create/modify quests

### Read-Only Data Integrity
- **Leaderboard rankings** cannot be manipulated by users
- **Quest definitions** immutable to users (prevents cheating)
- **Achievement conditions** cannot be modified by users
- **Cosmetic prices/requirements** locked by RLS

### Audit Trail Protection
- **No DELETE policies on user data tables**
  - Quest history preserved forever (completions, attempts)
  - Achievement unlock records immutable
  - Profile changes logged (if triggers added)
- **Supports compliance and debugging**
  - Can trace user actions over time
  - Cannot hide suspicious activity by deletion

---

## Attack Scenarios Prevented

### 1. SQL Injection Attacks
- **Attack:** Malicious user injects SQL to view other users' data
- **Example:** `'; SELECT * FROM profiles WHERE id != auth.uid(); --`
- **Prevention:** RLS filters results even if injection succeeds
- **Result:** Attacker still only sees their own data

### 2. Privilege Escalation
- **Attack:** User tries to mark themselves as admin
- **Example:** `UPDATE profiles SET is_admin = true WHERE id = auth.uid()`
- **Prevention:** WITH CHECK clause validates updated values
- **Result:** Update fails policy check

### 3. Leaderboard Manipulation
- **Attack:** User tries to inflate their leaderboard ranking
- **Example:** `INSERT INTO leaderboard_cache (user_id, xp, rank) VALUES (auth.uid(), 999999, 1)`
- **Prevention:** No INSERT policy for authenticated users
- **Result:** INSERT blocked by RLS

### 4. Achievement Fraud
- **Attack:** User tries to unlock achievements without meeting conditions
- **Example:** `INSERT INTO user_achievements (user_id, achievement_id) VALUES (auth.uid(), 'rare-achievement')`
- **Prevention:** Only service role has INSERT permission
- **Result:** INSERT blocked, achievements only awarded by system triggers

### 5. Quest Progress Tampering
- **Attack:** User tries to complete quests instantly
- **Example:** `UPDATE user_missions SET progress = 100, completed = true WHERE mission_id = 'hard-quest'`
- **Prevention:** Business logic in service layer validates progress increments
- **Result:** Even if RLS allows UPDATE, backend validation rejects invalid progress

### 6. Data Exfiltration
- **Attack:** Compromised API key used to dump all user data
- **Example:** `SELECT * FROM profiles; SELECT * FROM user_missions;`
- **Prevention:** RLS limits results to authenticated user's data only
- **Result:** Only single user's data exposed, not entire database

### 7. Cosmetic Theft
- **Attack:** User tries to unlock premium cosmetics without XP cost
- **Example:** `INSERT INTO user_cosmetics (user_id, cosmetic_id) VALUES (auth.uid(), 'legendary-skin')`
- **Prevention:** Service layer validates XP balance before unlock
- **Result:** INSERT requires security-definer function that checks balance

### 8. Cross-Account Quest Completion
- **Attack:** User A tries to complete User B's quests
- **Example:** `UPDATE user_missions SET completed = true WHERE user_id = 'user-b-id'`
- **Prevention:** USING clause filters to only own user_id
- **Result:** UPDATE affects 0 rows (User B's quests not visible to User A)

### 9. Historical Data Deletion
- **Attack:** User tries to hide failed quest attempts
- **Example:** `DELETE FROM user_missions WHERE completed = false`
- **Prevention:** No DELETE policy for authenticated users
- **Result:** DELETE blocked, audit trail preserved

### 10. Leaderboard Rank Inflation
- **Attack:** User tries to view and copy top player's XP
- **Example:** `SELECT xp FROM profiles WHERE rank = 'Legend'`
- **Prevention:** Users can only SELECT their own profile row
- **Result:** Query returns 0 rows (cannot see other profiles)

---

## Defense Talking Points

### For SE Project Defense

#### "How do you ensure data security?"
- **Answer:** "Implemented Row Level Security at the database level using Supabase's RLS policies. Even if application code is compromised, users can only access their own data due to database-enforced policies."

#### "What if someone bypasses your API?"
- **Answer:** "RLS policies apply to all database queries, not just API calls. Direct database access still respects auth.uid() checks, preventing unauthorized access regardless of entry point."

#### "Can users cheat by manipulating their XP?"
- **Answer:** "No. XP is stored in the profiles table with UPDATE policy requiring auth.uid() = id. Additionally, XP modifications go through service layer validation and achievements are system-awarded via service role."

#### "How do you prevent SQL injection?"
- **Answer:** "We use Supabase's parameterized queries, but even if injection occurs, RLS filters results to only the authenticated user's data. An attacker cannot see other users' information."

#### "Why not just do validation in the app?"
- **Answer:** "Defense in depth. Application validation can be bypassed, but database-level RLS cannot be circumvented. RLS is the last line of defense if application security fails."

### Key Security Principles Demonstrated

#### 1. Defense in Depth
- Application layer validation (Flutter/Dart)
- Service layer business rules (quest_service, xp_service)
- Database layer enforcement (RLS policies)

#### 2. Principle of Least Privilege
- Users can only access their own data
- No DELETE permissions on user tables
- Read-only access to reference data
- Service role for system operations only

#### 3. Separation of Concerns
- Authentication handled by Supabase Auth
- Authorization enforced by RLS policies
- Business logic in service layer
- Data persistence in database

#### 4. Fail-Safe Defaults
- RLS enabled = no access by default
- Explicit policies grant specific permissions
- Missing policies = denied (not allowed)

#### 5. Complete Mediation
- Every database query checked by RLS
- No bypass mechanisms for users
- Admin operations via service role only

---

## Testing & Verification

### RLS Status Check
- SQL query to verify RLS enabled on all tables
- Check for tables without policies (security gaps)
- Count policies per table (coverage verification)

### Policy Testing Approach
- **Test 1:** User can read own data
- **Test 2:** User cannot read other user's data
- **Test 3:** User cannot update other user's data
- **Test 4:** User cannot delete their own data (preserved audit trail)
- **Test 5:** User can read public/reference data
- **Test 6:** User cannot modify public/reference data

### Security Audit Queries
- Identify tables with RLS disabled
- Find tables with no policies
- List all policies per table
- Verify service role has necessary access

---

## Future Enhancements

### Potential Additions
- **Admin policies:** Separate is_admin flag with elevated permissions
- **Time-based policies:** Access restrictions based on timestamps
- **Conditional policies:** Different rules for premium users
- **Audit logging:** Track all policy violations for monitoring
- **Rate limiting policies:** Prevent abuse via excessive queries
- **Geofencing policies:** Campus-only access for certain features

### Scalability Considerations
- RLS performance impact minimal for indexed columns (user_id)
- Policies evaluated per query (not cached between sessions)
- Complex policies may require query optimization
- Consider materialized views for complex policy logic
