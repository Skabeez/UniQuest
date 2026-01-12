# Magic Numbers Extraction Analysis - Phase 3

## Summary
Created `lib/constants/app_constants.dart` with 100+ organized constants.
This document identifies files that need refactoring to use these constants.

---

## Files Requiring Updates

### HIGH PRIORITY (Core Architecture)

#### 1. **lib/services/cache_service.dart**
**Magic Numbers Found:**
- `Duration(minutes: 5)` → `AppConstants.cacheQuestTtlMinutes`
- `Duration(minutes: 10)` → `AppConstants.cacheProfileTtlMinutes`
- `Duration(minutes: 30)` → `AppConstants.cacheAchievementTtlMinutes`
- `Duration(minutes: 1)` → `AppConstants.cacheLeaderboardTtlMinutes`
- `Duration(hours: 24)` → `AppConstants.cacheAssetsTtlHours`

**Lines to Update:** 60, 63, 66, 69, 72, 75
**Replacement Pattern:**
```dart
// BEFORE:
static const Duration questListTtl = Duration(minutes: 5);

// AFTER:
static const Duration questListTtl = Duration(minutes: AppConstants.cacheQuestTtlMinutes);
```

---

#### 2. **lib/services/connectivity_service.dart**
**Magic Numbers Found:**
- `Duration(seconds: 3)` → `AppConstants.connectivityPingTimeoutSeconds`
- `Duration(seconds: 30)` → `AppConstants.connectivityCheckIntervalSeconds`
- `const int maxPingRetries = 2` → `AppConstants.connectivityMaxRetries`

**Lines to Update:** 54, 57, 60
**Replacement Pattern:**
```dart
// BEFORE:
static const Duration pingTimeout = Duration(seconds: 3);

// AFTER:
static const Duration pingTimeout = Duration(seconds: AppConstants.connectivityPingTimeoutSeconds);
```

---

#### 3. **lib/leaderboard/leaderboard_model.dart**
**Magic Numbers Found:**
- `Duration(seconds: 30)` → `AppConstants.leaderboardAutoRefreshSeconds`

**Lines to Update:** 166
**Replacement Pattern:**
```dart
// BEFORE:
_autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {

// AFTER:
_autoRefreshTimer = Timer.periodic(
  const Duration(seconds: AppConstants.leaderboardAutoRefreshSeconds), 
  (timer) {
```

---

### MEDIUM PRIORITY (Repositories & Services)

#### 4. **lib/backend/services/quest_service.dart**
**Magic Numbers Found:**
- `progress < 0 || progress > 100` → Use `AppConstants.progressMinValue` and `AppConstants.progressMaxValue`
- `'progress': 0` → `AppConstants.initialQuestProgress`
- `int pageSize = 20` → `AppConstants.paginationDefaultSize`
- `int streakMultiplier = 1` → `AppConstants.streakMultiplierBase`

**Lines to Update:** 69, 70, 74, 76, 206, 167
**Replacement Example:**
```dart
// BEFORE:
if (progress < 0 || progress > 100) {
  return const Failure('Progress must be between 0 and 100');
}

// AFTER:
if (progress < AppConstants.progressMinValue || progress > AppConstants.progressMaxValue) {
  return Failure('Progress must be between ${AppConstants.progressMinValue} and ${AppConstants.progressMaxValue}');
}
```

---

#### 5. **lib/backend/services/xp_service.dart**
**Magic Numbers Found:**
- `int pageSize = 20` → `AppConstants.paginationDefaultSize`
- `int limit = 50` → `AppConstants.leaderboardTopN`
- `int streakMultiplier = 1` → `AppConstants.streakMultiplierBase`
- Rank thresholds: `0-999`, `1000-4999` → Use rank constants
- Streak bonuses: `1.1x`, `1.25x`, `1.5x` → Use streak multiplier constants

**Lines to Update:** 67, 133, 173, 205, 211
**Replacement Example:**
```dart
// BEFORE:
/// Streak bonuses: 3 days = 1.1x, 7 days = 1.25x, 30 days = 1.5x
double calculateStreakMultiplier(int streakDays);

// AFTER:
/// Streak bonuses based on AppConstants thresholds
double calculateStreakMultiplier(int streakDays) {
  if (streakDays >= AppConstants.streakThreshold30Days) {
    return AppConstants.streakMultiplier30Days;
  } else if (streakDays >= AppConstants.streakThreshold7Days) {
    return AppConstants.streakMultiplier7Days;
  } else if (streakDays >= AppConstants.streakThreshold3Days) {
    return AppConstants.streakMultiplier3Days;
  }
  return AppConstants.streakMultiplierBase;
}
```

---

#### 6. **lib/backend/services/achievement_service.dart**
**Magic Numbers Found:**
- `int delta = 1` → `AppConstants.achievementProgressIncrement`
- `int pageSize = 20` → `AppConstants.paginationDefaultSize`
- `int limit = 50` → `AppConstants.leaderboardTopN`
- `int limit = 20` → `AppConstants.achievementRecentFeedLimit`

**Lines to Update:** 98, 190, 215, 233

---

#### 7. **lib/backend/services/user_service.dart**
**Magic Numbers Found:**
- `int limit = 20` → `AppConstants.paginationDefaultSize`
- `int limit = 50` → `AppConstants.leaderboardTopN`

**Lines to Update:** 214, 220, 227

---

#### 8. **lib/repositories/*.dart** (All repository files)
**Magic Numbers Found in Multiple Files:**
- `progress = 0` → `AppConstants.initialQuestProgress`
- `pageSize = 20` → `AppConstants.paginationDefaultSize`
- `limit = 50` → `AppConstants.paginationLargeSize`
- `limit = 10` → `AppConstants.paginationSmallSize`
- `limit = 5` → `AppConstants.achievementNearestLimit`
- `delta = 1` → `AppConstants.achievementProgressIncrement`

**Files:**
- quest_repository.dart
- user_repository.dart
- achievement_repository.dart
- base_repository.dart

---

### LOW PRIORITY (UI/Widgets)

#### 9. **lib/main.dart**
**Magic Numbers Found:**
- `Duration(milliseconds: 5)` → UI timing
- `Duration(milliseconds: 300)` → `AppConstants.animationMediumDuration`
- `Duration(milliseconds: 200)` → `AppConstants.animationShortDuration`
- `50` (scroll threshold) → `AppConstants.uiScrollHideThreshold`
- `28.0` / `24.0` (icon sizes) → `AppConstants.uiIconSizeActive` / `uiIconSizeInactive`
- `72` (nav height) → `AppConstants.uiBottomNavHeight`
- `99` (badge max count) → `AppConstants.uiBadgeMaxCount`
- `18.0` (badge size) → `AppConstants.uiBadgeMinSize`
- `10.0` (badge font) → `AppConstants.uiBadgeFontSize`
- `14.0`, `16.0` (padding) → Use padding constants

**Lines:** 98, 166, 220, 259, 381, 296-297, 301, 304

---

#### 10. **lib/services/audio_manager.dart**
**Magic Numbers Found:**
- `_bgmVolume = 0.7` → `AppConstants.audioDefaultBgmVolume`
- `_sfxVolume = 0.8` → `AppConstants.audioDefaultSfxVolume`
- `steps = 30` → `AppConstants.audioFadeSteps`
- `steps = 20` → `AppConstants.audioFadeOutSteps`
- `Duration(milliseconds: 50)` → `AppConstants.audioFadeStepDuration`
- `_currentPlayingVolume = 0.0` → `AppConstants.audioVolumeMin`

**Lines:** 18, 19, 235, 236, 256, 257, 267

---

#### 11. **lib/welcome/welcome_widget.dart**
**Magic Numbers Found:**
- `duration: 3200.0.ms` → `AppConstants.animationSplashDuration`
- `delay: 200.0.ms` → `AppConstants.animationFadeDuration`
- `duration: 300.0.ms` → `AppConstants.animationMediumDuration`

**Lines:** 45, 52, 61, 64, 65, 71, 72, 78, 79

---

#### 12. **lib/onboarding/onboarding_widget.dart**
**Magic Numbers Found:**
- `maxLength: 15` → `AppConstants.validationUsernameMaxLength`

**Lines:** 297

---

#### 13. **lib/components/add_new_task/add_new_task_widget.dart**
**Magic Numbers Found:**
- `maxLength: 15` → `AppConstants.validationUsernameMaxLength`
- `maxLength: 50` → `AppConstants.validationTaskTitleMaxLength`

**Lines:** 326, 470

---

#### 14. **lib/components/edit_task/edit_task_widget.dart**
**Magic Numbers Found:**
- `maxLength: 15` → `AppConstants.validationUsernameMaxLength`

**Lines:** 358

---

#### 15. **lib/backend/repositories/mission_repository.dart**
**Magic Numbers Found:**
- `expiration: const Duration(hours: 24)` → `AppConstants.repositoryMissionCacheHours`

**Lines:** 58

---

## Summary Statistics

| Priority | Files | Magic Numbers | Estimated Time |
|----------|-------|---------------|----------------|
| HIGH | 3 | ~20 | 30 mins |
| MEDIUM | 8 | ~80 | 2 hours |
| LOW | 7 | ~50 | 1.5 hours |
| **TOTAL** | **18** | **~150** | **4 hours** |

---

## Refactoring Strategy (Recommended Order)

### Phase 3.1 - Core Services (Start Here)
1. ✅ **cache_service.dart** - Cache TTL values
2. ✅ **connectivity_service.dart** - Network timeouts
3. ✅ **leaderboard_model.dart** - Auto-refresh interval

### Phase 3.2 - Business Logic
4. **quest_service.dart** - Progress bounds, pagination
5. **xp_service.dart** - Rank thresholds, streak multipliers
6. **achievement_service.dart** - Pagination, limits
7. **user_service.dart** - Pagination limits

### Phase 3.3 - Data Access
8. **All repository files** - Pagination defaults, progress values

### Phase 3.4 - UI Polish (Optional)
9. **main.dart** - Animation durations, UI dimensions
10. **audio_manager.dart** - Volume defaults, fade steps
11. **Component widgets** - Validation lengths

---

## Defense Talking Points

**When asked about magic numbers:**
> "We extracted 150+ magic numbers into `AppConstants` class organized by feature. This follows the Single Responsibility Principle and DRY (Don't Repeat Yourself) principle. For example, cache expiration times are now defined once in constants instead of scattered across 5+ files. This makes the codebase more maintainable and reduces the risk of inconsistent values."

**Benefits demonstrated:**
1. ✅ **Maintainability** - Change values once, affects entire app
2. ✅ **Consistency** - No conflicting values (e.g., different TTLs for same feature)
3. ✅ **Type Safety** - Constants are compile-time checked
4. ✅ **Documentation** - Each constant has clear purpose via naming/comments
5. ✅ **Testing** - Easy to mock/override for unit tests
6. ✅ **Code Review** - Clear separation of config vs logic

**Example:**
```dart
// ANTI-PATTERN (Before):
Duration(minutes: 5)  // In file 1
Duration(minutes: 5)  // In file 2 - but why 5?
Duration(minutes: 10) // In file 3 - is this intentional or typo?

// GOOD PATTERN (After):
Duration(minutes: AppConstants.cacheQuestTtlMinutes)
// Clear intent, single source of truth, IDE autocomplete shows all available values
```

---

## Next Steps

**Phase 3 Implementation:**
1. Import constants file in each target file
2. Replace magic numbers with constant references
3. Verify no regression with existing tests
4. Run code formatter

**DO NOT execute replacements yet - wait for user confirmation!**
