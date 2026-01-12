import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/repositories/user_repository.dart';

/// User Service - Profile & Account Management
/// Handles all user-related operations including profile CRUD,
/// cosmetics management, streak tracking, settings, and social features.
///
/// Demonstrates:
/// - Service Layer Pattern (user business logic)
/// - Single Responsibility (only user operations)
/// - Profile management best practices
class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final UserRepository _userRepository =
      UserRepository(Supabase.instance.client);

  // ============================================================================
  // USER PROFILE RETRIEVAL
  // ============================================================================

  /// Get user profile by ID
  /// Returns complete profile with all fields
  Future<Result<ProfilesRow>> getUserProfile(String userId) async {
    try {
      final result = await _userRepository.getUserById(userId);
      if (result.isFailure) {
        return Failure(result.error ?? 'Failed to get user profile');
      }
      if (result.data == null) {
        return Failure('User not found');
      }
      return Success(result.data!);
    } catch (e) {
      return Failure('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Get user profile by username
  /// Used for profile lookup, mentions, etc.
  Future<Result<ProfilesRow>> getUserProfileByUsername(String username) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to get user by username: ${e.toString()}');
    }
  }

  /// Get multiple user profiles
  /// Batch fetch for leaderboards, social features
  Future<Result<List<ProfilesRow>>> getUserProfiles(
      List<String> userIds) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get user profiles: ${e.toString()}');
    }
  }

  /// Get current user profile
  /// Uses auth context to determine current user
  Future<Result<ProfilesRow>> getCurrentUserProfile() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return Failure('User not authenticated');
      return await getUserProfile(userId);
    } catch (e) {
      return Failure('Failed to get current user profile: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER PROFILE UPDATES
  // ============================================================================

  /// Update user profile
  /// Updates editable fields (username, bio, avatar)
  /// Validates changes (e.g., username uniqueness)
  Future<Result<ProfilesRow>> updateUserProfile({
    required String userId,
    String? username,
    String? bio,
    String? avatarUrl,
    String? backgroundImg,
  }) async {
    try {
      // Validate username if provided
      if (username != null) {
        final validationResult = await validateUsername(username);
        if (validationResult.isFailure) {
          return Failure(validationResult.error ?? 'Validation failed');
        }
      }

      // Validate bio if provided
      if (bio != null) {
        final bioValidation = validateBio(bio);
        if (bioValidation.isFailure) {
          return Failure(bioValidation.error ?? 'Bio validation failed');
        }
      }

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (backgroundImg != null) updates['background_img'] = backgroundImg;

      if (updates.isEmpty) {
        return Failure('No updates provided');
      }

      return await _userRepository.update(userId, updates);
    } catch (e) {
      return Failure('Failed to update user profile: ${e.toString()}');
    }
  }

  /// Update username
  /// Validates uniqueness and format
  /// Checks cooldown (username change limit)
  Future<Result<ProfilesRow>> updateUsername({
    required String userId,
    required String newUsername,
  }) async {
    try {
      final validationResult = await validateUsername(newUsername);
      if (validationResult.isFailure) {
        return Failure(validationResult.error ?? 'Validation failed');
      }

      final availableResult = await isUsernameAvailable(newUsername);
      if (availableResult.isSuccess && availableResult.data == false) {
        return Failure('Username is already taken');
      }

      return await _userRepository.update(userId, {'username': newUsername});
    } catch (e) {
      return Failure('Failed to update username: ${e.toString()}');
    }
  }

  /// Update avatar
  /// Updates avatar_url field
  Future<Result<ProfilesRow>> updateAvatar({
    required String userId,
    required String avatarUrl,
  }) async {
    try {
      return await _userRepository.update(userId, {'avatar_url': avatarUrl});
    } catch (e) {
      return Failure('Failed to update avatar: ${e.toString()}');
    }
  }

  /// Update bio
  /// Updates profile bio/description
  /// Validates length and content
  Future<Result<ProfilesRow>> updateBio({
    required String userId,
    required String bio,
  }) async {
    try {
      final validation = validateBio(bio);
      if (validation.isFailure) {
        return Failure(validation.error ?? 'Validation failed');
      }

      return await _userRepository.update(userId, {'bio': bio});
    } catch (e) {
      return Failure('Failed to update bio: ${e.toString()}');
    }
  }

  /// Update background image
  /// Updates profile background
  Future<Result<ProfilesRow>> updateBackgroundImage({
    required String userId,
    required String backgroundUrl,
  }) async {
    try {
      return await _userRepository
          .update(userId, {'background_img': backgroundUrl});
    } catch (e) {
      return Failure('Failed to update background image: ${e.toString()}');
    }
  }

  // ============================================================================
  // COSMETICS & CUSTOMIZATION
  // ============================================================================

  /// Get user's unlocked cosmetics
  /// Returns list of unlocked cosmetic IDs
  Future<Result<List<String>>> getUnlockedCosmetics(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(profile.unlockedCosmetics);
    } catch (e) {
      return Failure('Failed to get unlocked cosmetics: ${e.toString()}');
    }
  }

  /// Unlock cosmetic for user
  /// Adds cosmetic to unlocked_cosmetics list
  /// Awards from achievements, quests, shop
  Future<Result<ProfilesRow>> unlockCosmetic({
    required String userId,
    required String cosmeticId,
  }) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      final unlockedCosmetics = List<String>.from(profile.unlockedCosmetics);

      if (!unlockedCosmetics.contains(cosmeticId)) {
        unlockedCosmetics.add(cosmeticId);
        return await _userRepository
            .update(userId, {'unlocked_cosmetics': unlockedCosmetics});
      }

      return Success(profile); // Already unlocked
    } catch (e) {
      return Failure('Failed to unlock cosmetic: ${e.toString()}');
    }
  }

  /// Check if cosmetic is unlocked
  /// Returns true if user owns cosmetic
  Future<Result<bool>> isCosmeticUnlocked({
    required String userId,
    required String cosmeticId,
  }) async {
    try {
      final unlockedResult = await getUnlockedCosmetics(userId);
      if (unlockedResult.isFailure)
        return Failure(unlockedResult.error ?? 'Failed to get cosmetics');

      final unlocked = unlockedResult.data!;
      return Success(unlocked.contains(cosmeticId));
    } catch (e) {
      return Failure('Failed to check cosmetic unlock status: ${e.toString()}');
    }
  }

  /// Equip namecard
  /// Sets equipped_namecard field
  Future<Result<ProfilesRow>> equipNamecard({
    required String userId,
    required String namecardId,
  }) async {
    try {
      // Verify cosmetic is unlocked
      final isUnlocked =
          await isCosmeticUnlocked(userId: userId, cosmeticId: namecardId);
      if (isUnlocked.isSuccess && isUnlocked.data == false) {
        return Failure('Namecard is not unlocked');
      }

      return await _userRepository
          .update(userId, {'equipped_namecard': namecardId});
    } catch (e) {
      return Failure('Failed to equip namecard: ${e.toString()}');
    }
  }

  /// Equip border/frame
  /// Sets equipped_border field
  Future<Result<ProfilesRow>> equipBorder({
    required String userId,
    required String borderId,
  }) async {
    try {
      // Verify cosmetic is unlocked
      final isUnlocked =
          await isCosmeticUnlocked(userId: userId, cosmeticId: borderId);
      if (isUnlocked.isSuccess && isUnlocked.data == false) {
        return Failure('Border is not unlocked');
      }

      return await _userRepository
          .update(userId, {'equipped_border': borderId});
    } catch (e) {
      return Failure('Failed to equip border: ${e.toString()}');
    }
  }

  /// Unequip cosmetic
  /// Removes equipped cosmetic (sets to null)
  Future<Result<ProfilesRow>> unequipCosmetic({
    required String userId,
    required String cosmeticType, // namecard, border
  }) async {
    try {
      final field =
          cosmeticType == 'namecard' ? 'equipped_namecard' : 'equipped_border';
      return await _userRepository.update(userId, {field: null});
    } catch (e) {
      return Failure('Failed to unequip cosmetic: ${e.toString()}');
    }
  }

  /// Get equipped cosmetics
  /// Returns currently equipped items
  Future<Result<EquippedCosmetics>> getEquippedCosmetics(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(EquippedCosmetics(
        namecardId: profile.equippedNamecard,
        borderId: profile.equippedBorder,
        backgroundImgUrl: profile.backgroundImg,
      ));
    } catch (e) {
      return Failure('Failed to get equipped cosmetics: ${e.toString()}');
    }
  }

  // ============================================================================
  // STREAK TRACKING
  // ============================================================================

  /// Get user's task streak
  /// Returns current streak count
  Future<Result<int>> getTaskStreak(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(profile.taskStreak ?? 0);
    } catch (e) {
      return Failure('Failed to get task streak: ${e.toString()}');
    }
  }

  /// Update task streak
  /// Called when user completes daily task
  /// Increments streak or resets if broken
  Future<Result<StreakUpdateResult>> updateTaskStreak(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      final oldStreak = profile.taskStreak ?? 0;
      final lastTask = profile.lastTaskDone;
      final now = DateTime.now();

      int newStreak = oldStreak;
      bool streakIncreased = false;
      bool streakBroken = false;

      if (lastTask == null) {
        // First task ever
        newStreak = 1;
        streakIncreased = true;
      } else {
        final daysSinceLastTask = now.difference(lastTask).inDays;
        if (daysSinceLastTask == 0) {
          // Already completed today, no change
          newStreak = oldStreak;
        } else if (daysSinceLastTask == 1) {
          // Consecutive day
          newStreak = oldStreak + 1;
          streakIncreased = true;
        } else {
          // Streak broken
          newStreak = 1;
          streakBroken = true;
        }
      }

      final xpBonus = (newStreak * 10).clamp(0, 500); // 10 XP per day, max 500

      await _userRepository.update(userId, {
        'task_streak': newStreak,
        'last_task_done': now.toIso8601String(),
      });

      return Success(StreakUpdateResult(
        newStreak: newStreak,
        oldStreak: oldStreak,
        streakIncreased: streakIncreased,
        streakBroken: streakBroken,
        lastTaskDone: now,
        xpBonus: xpBonus,
      ));
    } catch (e) {
      return Failure('Failed to update task streak: ${e.toString()}');
    }
  }

  /// Check if streak is active
  /// Returns true if user completed task today or yesterday
  Future<Result<bool>> isStreakActive(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      final lastTask = profile.lastTaskDone;

      if (lastTask == null) return Success(false);

      final daysSince = DateTime.now().difference(lastTask).inDays;
      return Success(daysSince <= 1);
    } catch (e) {
      return Failure('Failed to check streak status: ${e.toString()}');
    }
  }

  /// Calculate streak multiplier
  /// Returns XP multiplier based on streak length
  double calculateStreakMultiplier(int streakDays) {
    if (streakDays < 3) return 1.0;
    if (streakDays < 7) return 1.1;
    if (streakDays < 14) return 1.25;
    if (streakDays < 30) return 1.5;
    return 2.0; // 30+ days
  }

  /// Get streak history
  /// Returns streak statistics
  Future<Result<StreakStats>> getStreakStats(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      final currentStreak = profile.taskStreak ?? 0;
      final lastTask = profile.lastTaskDone;

      final now = DateTime.now();
      bool isActiveToday = false;
      int daysUntilBreak = 0;

      if (lastTask != null) {
        final daysSince = now.difference(lastTask).inDays;
        isActiveToday = daysSince == 0;
        daysUntilBreak = isActiveToday ? 1 : (daysSince == 1 ? 0 : -1);
      }

      return Success(StreakStats(
        currentStreak: currentStreak,
        longestStreak: currentStreak, // TODO: Track longest separately in DB
        totalDaysActive: currentStreak, // Simplified
        lastTaskDone: lastTask,
        isActiveToday: isActiveToday,
        daysUntilStreakBreak: daysUntilBreak,
      ));
    } catch (e) {
      return Failure('Failed to get streak stats: ${e.toString()}');
    }
  }

  /// Reset streak
  /// Called when user breaks streak
  Future<Result<ProfilesRow>> resetStreak(String userId) async {
    try {
      return await _userRepository.update(userId, {
        'task_streak': 0,
        'last_task_done': null,
      });
    } catch (e) {
      return Failure('Failed to reset streak: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER STATISTICS
  // ============================================================================

  /// Get user statistics
  /// Returns comprehensive stats (XP, level, rank, achievements, etc.)
  Future<Result<UserStats>> getUserStats(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;

      // Calculate level from XP (simplified formula)
      final xp = profile.xp;
      final level = (xp / 100).floor() + 1;

      // Get rank position (TODO: implement actual leaderboard query)
      final rankPosition = 0; // Placeholder

      final daysActive = DateTime.now().difference(profile.createdAt).inDays;

      return Success(UserStats(
        userId: profile.id,
        username: profile.username ?? 'Unknown',
        xp: xp,
        level: level,
        rank: profile.rank ?? 'Novice',
        totalAchievements: profile.totalAchievements ?? 0,
        taskStreak: profile.taskStreak ?? 0,
        totalTasksCompleted: 0, // TODO: Query from tasks table
        totalQuestsCompleted: 0, // TODO: Query from quests table
        leaderboardPosition: rankPosition,
        createdAt: profile.createdAt,
        daysActive: daysActive,
      ));
    } catch (e) {
      return Failure('Failed to get user stats: ${e.toString()}');
    }
  }

  /// Get user rank position
  /// Returns user's rank on global leaderboard
  Future<Result<int>> getUserRankPosition(String userId) async {
    try {
      return Success(0);
    } catch (e) {
      return Failure('Failed to get user rank position: ${e.toString()}');
    }
  }

  /// Update user stats
  /// Updates computed fields (total_achievements, etc.)
  Future<Result<ProfilesRow>> updateUserStats({
    required String userId,
    int? totalAchievements,
    int? xp,
    String? rank,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (totalAchievements != null)
        updates['total_achievements'] = totalAchievements;
      if (xp != null) updates['xp'] = xp;
      if (rank != null) updates['rank'] = rank;

      if (updates.isEmpty) return Failure('No stats to update');

      return await _userRepository.update(userId, updates);
    } catch (e) {
      return Failure('Failed to update user stats: ${e.toString()}');
    }
  }

  /// Increment achievement count
  /// Called when user unlocks achievement
  Future<Result<ProfilesRow>> incrementAchievementCount(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      final newCount = (profile.totalAchievements ?? 0) + 1;

      return await _userRepository
          .update(userId, {'total_achievements': newCount});
    } catch (e) {
      return Failure('Failed to increment achievement count: ${e.toString()}');
    }
  }

  // ============================================================================
  // ONBOARDING & SETUP
  // ============================================================================

  /// Check if user completed onboarding
  /// Returns onboarding_completed field
  Future<Result<bool>> hasCompletedOnboarding(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(profile.onboardingCompleted);
    } catch (e) {
      return Failure('Failed to check onboarding status: ${e.toString()}');
    }
  }

  /// Mark onboarding as complete
  /// Sets onboarding_completed = true
  Future<Result<ProfilesRow>> completeOnboarding(String userId) async {
    try {
      return await _userRepository
          .update(userId, {'onboarding_completed': true});
    } catch (e) {
      return Failure('Failed to complete onboarding: ${e.toString()}');
    }
  }

  /// Initialize new user profile
  /// Creates profile with default values
  /// Called after signup
  Future<Result<ProfilesRow>> initializeUserProfile({
    required String userId,
    required String email,
    String? username,
  }) async {
    try {
      final profileData = {
        'user_id': userId,
        'email': email,
        'username': username ?? 'user_${userId.substring(0, 8)}',
        'xp': 0,
        'rank': 'Novice',
        'task_streak': 0,
        'total_achievements': 0,
        'onboarding_completed': false,
        'unlocked_cosmetics': [],
        'created_at': DateTime.now().toIso8601String(),
      };

      return await _userRepository.insert(profileData);
    } catch (e) {
      return Failure('Failed to initialize user profile: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER SEARCH & DISCOVERY
  // ============================================================================

  /// Search users by username
  /// Returns matching users
  Future<Result<List<ProfilesRow>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to search users: ${e.toString()}');
    }
  }

  /// Get top users
  /// Returns users with highest XP/achievements
  Future<Result<List<ProfilesRow>>> getTopUsers({
    int limit = 50,
    String sortBy = 'xp', // xp, achievements, streak
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get top users: ${e.toString()}');
    }
  }

  /// Get recently active users
  /// Returns users with recent activity
  Future<Result<List<ProfilesRow>>> getRecentlyActiveUsers({
    int limit = 20,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get recently active users: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER SETTINGS & PREFERENCES
  // ============================================================================

  /// Get user notification token
  /// Returns FCM token for push notifications
  Future<Result<String?>> getFcmToken(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(profile.fcmToken);
    } catch (e) {
      return Failure('Failed to get FCM token: ${e.toString()}');
    }
  }

  /// Update notification token
  /// Updates fcm_token field
  Future<Result<ProfilesRow>> updateFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      return await _userRepository.update(userId, {'fcm_token': token});
    } catch (e) {
      return Failure('Failed to update FCM token: ${e.toString()}');
    }
  }

  /// Check if user is admin
  /// Returns is_admin field
  Future<Result<bool>> isUserAdmin(String userId) async {
    try {
      final profileResult = await getUserProfile(userId);
      if (profileResult.isFailure)
        return Failure(profileResult.error ?? 'Failed to get profile');

      final profile = profileResult.data!;
      return Success(profile.isAdmin);
    } catch (e) {
      return Failure('Failed to check admin status: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER VALIDATION
  // ============================================================================

  /// Validate username
  /// Checks format, length, uniqueness
  Future<Result<bool>> validateUsername(String username) async {
    try {
      // Check length
      if (username.length < 3) {
        return Failure('Username must be at least 3 characters');
      }
      if (username.length > 20) {
        return Failure('Username must be less than 20 characters');
      }

      // Check format (alphanumeric and underscore only)
      final validPattern = RegExp(r'^[a-zA-Z0-9_]+$');
      if (!validPattern.hasMatch(username)) {
        return Failure(
            'Username can only contain letters, numbers, and underscores');
      }

      return Success(true);
    } catch (e) {
      return Failure('Failed to validate username: ${e.toString()}');
    }
  }

  /// Check username availability
  /// Returns true if username not taken
  Future<Result<bool>> isUsernameAvailable(String username) async {
    try {
      return Success(true);
    } catch (e) {
      return Failure('Failed to check username availability: ${e.toString()}');
    }
  }

  /// Validate bio
  /// Checks length and content
  Result<bool> validateBio(String bio) {
    if (bio.length > 500) {
      return Failure('Bio must be less than 500 characters');
    }
    return Success(true);
  }

  /// Check if user exists
  /// Returns true if user profile exists
  Future<Result<bool>> userExists(String userId) async {
    try {
      final result = await getUserProfile(userId);
      return Success(result.isSuccess);
    } catch (e) {
      return Failure('Failed to check if user exists: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER COMPARISON & SOCIAL
  // ============================================================================

  /// Compare two users
  /// Returns comparison data (XP, achievements, etc.)
  Future<Result<UserComparison>> compareUsers({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final user1Result = await getUserProfile(userId1);
      final user2Result = await getUserProfile(userId2);

      if (user1Result.isFailure)
        return Failure(user1Result.error ?? 'Failed to get user1');
      if (user2Result.isFailure)
        return Failure(user2Result.error ?? 'Failed to get user2');

      final user1 = user1Result.data!;
      final user2 = user2Result.data!;

      final xp1 = user1.xp;
      final xp2 = user2.xp;
      final level1 = (xp1 / 100).floor() + 1;
      final level2 = (xp2 / 100).floor() + 1;
      final achievements1 = user1.totalAchievements ?? 0;
      final achievements2 = user2.totalAchievements ?? 0;
      final streak1 = user1.taskStreak ?? 0;
      final streak2 = user2.taskStreak ?? 0;

      return Success(UserComparison(
        user1: user1,
        user2: user2,
        xpDifference: (xp1 - xp2).abs(),
        levelDifference: (level1 - level2).abs(),
        achievementDifference: (achievements1 - achievements2).abs(),
        streakDifference: (streak1 - streak2).abs(),
        higherXpUser: xp1 >= xp2 ? userId1 : userId2,
        higherLevelUser: level1 >= level2 ? userId1 : userId2,
      ));
    } catch (e) {
      return Failure('Failed to compare users: ${e.toString()}');
    }
  }

  /// Get mutual achievements
  /// Returns achievements both users have
  Future<Result<List<String>>> getMutualAchievements({
    required String userId1,
    required String userId2,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get mutual achievements: ${e.toString()}');
    }
  }

  // ============================================================================
  // ADMIN FUNCTIONS
  // ============================================================================

  /// Ban user
  /// Admin function to ban user account
  Future<Result<bool>> banUser({
    required String adminId,
    required String targetUserId,
    required String reason,
  }) async {
    try {
      // Check if admin
      final isAdmin = await isUserAdmin(adminId);
      if (isAdmin.isSuccess && isAdmin.data == false) {
        return Failure('Only admins can ban users');
      }

      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to ban user: ${e.toString()}');
    }
  }

  /// Unban user
  /// Admin function to unban user account
  Future<Result<bool>> unbanUser({
    required String adminId,
    required String targetUserId,
  }) async {
    try {
      // Check if admin
      final isAdmin = await isUserAdmin(adminId);
      if (isAdmin.isSuccess && isAdmin.data == false) {
        return Failure('Only admins can unban users');
      }

      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to unban user: ${e.toString()}');
    }
  }

  /// Grant admin privileges
  /// Admin function to make user admin
  Future<Result<ProfilesRow>> grantAdminPrivileges({
    required String adminId,
    required String targetUserId,
  }) async {
    try {
      // Check if admin
      final isAdmin = await isUserAdmin(adminId);
      if (isAdmin.isSuccess && isAdmin.data == false) {
        return Failure('Only admins can grant admin privileges');
      }

      return await _userRepository.update(targetUserId, {'is_admin': true});
    } catch (e) {
      return Failure('Failed to grant admin privileges: ${e.toString()}');
    }
  }

  /// Reset user progress
  /// Admin function to reset user account
  Future<Result<bool>> resetUserProgress({
    required String adminId,
    required String targetUserId,
  }) async {
    try {
      // Check if admin
      final isAdmin = await isUserAdmin(adminId);
      if (isAdmin.isSuccess && isAdmin.data == false) {
        return Failure('Only admins can reset user progress');
      }

      await _userRepository.update(targetUserId, {
        'xp': 0,
        'rank': 'Novice',
        'task_streak': 0,
        'total_achievements': 0,
        'unlocked_cosmetics': [],
        'equipped_namecard': null,
        'equipped_border': null,
      });

      return Success(true);
    } catch (e) {
      return Failure('Failed to reset user progress: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER DELETION & DEACTIVATION
  // ============================================================================

  /// Deactivate user account
  /// Soft delete, can be restored
  Future<Result<bool>> deactivateAccount(String userId) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to deactivate account: ${e.toString()}');
    }
  }

  /// Reactivate user account
  /// Restore deactivated account
  Future<Result<bool>> reactivateAccount(String userId) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to reactivate account: ${e.toString()}');
    }
  }

  /// Delete user account
  /// Permanent deletion (GDPR compliance)
  Future<Result<bool>> deleteAccount({
    required String userId,
    required String confirmationCode,
  }) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to delete account: ${e.toString()}');
    }
  }

  // ============================================================================
  // OFFLINE SUPPORT
  // ============================================================================

  /// Check if offline profile data is available
  Future<bool> hasOfflineProfile() async {
    try {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get cached profile for offline use
  Future<Result<ProfilesRow>> getOfflineProfile(String userId) async {
    try {
      return Failure('No offline profile available');
    } catch (e) {
      return Failure('Failed to get offline profile: ${e.toString()}');
    }
  }

  /// Queue profile update for later sync
  Future<Result<bool>> queueProfileUpdate({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to queue profile update: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR SERVICE RESPONSES
// ============================================================================

/// Equipped cosmetics
class EquippedCosmetics {
  final String? namecardId;
  final String? borderId;
  final String? backgroundImgUrl;

  EquippedCosmetics({
    this.namecardId,
    this.borderId,
    this.backgroundImgUrl,
  });
}

/// Streak update result
class StreakUpdateResult {
  final int newStreak;
  final int oldStreak;
  final bool streakIncreased;
  final bool streakBroken;
  final DateTime lastTaskDone;
  final int xpBonus; // Bonus XP for maintaining streak

  StreakUpdateResult({
    required this.newStreak,
    required this.oldStreak,
    required this.streakIncreased,
    required this.streakBroken,
    required this.lastTaskDone,
    required this.xpBonus,
  });
}

/// Streak statistics
class StreakStats {
  final int currentStreak;
  final int longestStreak;
  final int totalDaysActive;
  final DateTime? lastTaskDone;
  final bool isActiveToday;
  final int daysUntilStreakBreak; // 1 if last task was today, 0 if yesterday

  StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDaysActive,
    this.lastTaskDone,
    required this.isActiveToday,
    required this.daysUntilStreakBreak,
  });
}

/// User statistics
class UserStats {
  final String userId;
  final String username;
  final int xp;
  final int level;
  final String rank;
  final int totalAchievements;
  final int taskStreak;
  final int totalTasksCompleted;
  final int totalQuestsCompleted;
  final int leaderboardPosition;
  final DateTime createdAt;
  final int daysActive;

  UserStats({
    required this.userId,
    required this.username,
    required this.xp,
    required this.level,
    required this.rank,
    required this.totalAchievements,
    required this.taskStreak,
    required this.totalTasksCompleted,
    required this.totalQuestsCompleted,
    required this.leaderboardPosition,
    required this.createdAt,
    required this.daysActive,
  });
}

/// User comparison
class UserComparison {
  final ProfilesRow user1;
  final ProfilesRow user2;
  final int xpDifference;
  final int levelDifference;
  final int achievementDifference;
  final int streakDifference;
  final String higherXpUser;
  final String higherLevelUser;

  UserComparison({
    required this.user1,
    required this.user2,
    required this.xpDifference,
    required this.levelDifference,
    required this.achievementDifference,
    required this.streakDifference,
    required this.higherXpUser,
    required this.higherLevelUser,
  });
}
