import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/repositories/base_repository.dart';

/// User Repository - Data Access for User Profiles
/// Handles all database operations for user profiles and settings
/// 
/// Manages profiles table:
/// - User profile data (username, avatar, bio)
/// - XP, level, rank progression
/// - Cosmetics and customization
/// - Streaks and statistics
/// 
/// Demonstrates:
/// - Repository Pattern for user data
/// - Clean separation from authentication logic
/// - Type-safe profile operations
class UserRepository extends BaseRepository<ProfilesRow> {
  UserRepository(super.supabase);

  @override
  String get tableName => 'profiles';

  @override
  ProfilesRow fromJson(Map<String, dynamic> json) {
    return ProfilesRow(json);
  }

  // ============================================================================
  // BASE REPOSITORY IMPLEMENTATION
  // ============================================================================

  @override
  Future<Result<List<ProfilesRow>>> getAll() async {
    try {
      final response = await supabase.from(tableName).select();
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all profiles: ${e.toString()}');
    }
  }

  @override
  Future<Result<ProfilesRow?>> getById(String id) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<Result<ProfilesRow>> insert(Map<String, dynamic> data) async {
    try {
      final response = await supabase
          .from(tableName)
          .insert(data)
          .select()
          .single();
      
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to insert profile: ${e.toString()}');
    }
  }

  @override
  Future<Result<ProfilesRow>> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await supabase
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await supabase.from(tableName).delete().eq('id', id);
      return Success(null);
    } catch (e) {
      return Failure('Failed to delete profile: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<ProfilesRow>>> getByIds(List<String> ids) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .inFilter('id', ids);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get profiles by IDs: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<ProfilesRow>>> insertBatch(List<Map<String, dynamic>> dataList) async {
    try {
      final response = await supabase
          .from(tableName)
          .insert(dataList)
          .select();
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to insert batch: ${e.toString()}');
    }
  }

  @override
  Future<Result<int>> updateWhere(String condition, Map<String, dynamic> data) async {
    try {
      await supabase.from(tableName).update(data);
      // Note: Supabase doesn't return count for updates, return 0 for now
      return Success(0);
    } catch (e) {
      return Failure('Failed to update where: ${e.toString()}');
    }
  }

  @override
  Future<Result<int>> deleteBatch(List<String> ids) async {
    try {
      await supabase.from(tableName).delete().inFilter('id', ids);
      return Success(ids.length);
    } catch (e) {
      return Failure('Failed to delete batch: ${e.toString()}');
    }
  }

  @override
  Future<Result<int>> count([String? column]) async {
    try {
      final response = await supabase
          .from(tableName)
          .select(column ?? 'id')
          .count(CountOption.exact);
      return Success(response.count);
    } catch (e) {
      return Failure('Failed to count: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> exists(String id) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('id', id)
          .maybeSingle();
      
      return Success(response != null);
    } catch (e) {
      return Failure('Failed to check existence: ${e.toString()}');
    }
  }

  Future<Result<List<ProfilesRow>>> query(Map<String, dynamic> filters) async {
    try {
      var query = supabase.from(tableName).select();
      
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
      
      final response = await query;
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to query: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<ProfilesRow>>> paginate({required int page, required int pageSize}) async {
    try {
      final offset = (page - 1) * pageSize;
      final response = await supabase.from(tableName).select().range(offset, offset + pageSize - 1);
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to paginate: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<ProfilesRow>>> filter({required String column, required String operator, required dynamic value}) async {
    try {
      final response = await supabase.from(tableName).select();
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to filter: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<ProfilesRow>>> orderBy({required String column, bool ascending = true}) async {
    try {
      final response = await supabase.from(tableName).select().order(column, ascending: ascending);
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to order by: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> transaction(List<Future<Result<dynamic>>> operations) async {
    return Failure('Transactions not implemented');
  }

  @override
  Future<Result<List<ProfilesRow>>> search({required String query, required List<String> columns}) async {
    return Failure('Search not implemented');
  }

  @override
  Future<Result<List<ProfilesRow>>> findWhere(Map<String, dynamic> conditions) async {
    return query(conditions);
  }

  @override
  Future<Result<ProfilesRow?>> refresh(String id) async {
    return getById(id);
  }

  @override
  Future<Result<ProfilesRow>> upsert(Map<String, dynamic> data) async {
    try {
      final response = await supabase.from(tableName).upsert(data).select().single();
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to upsert: ${e.toString()}');
    }
  }

  @override
  Future<Result<ProfilesRow>> softDelete(String id) async {
    return update(id, {'deleted_at': DateTime.now().toIso8601String()});
  }

  @override
  Result<T> handleError<T>(Object error) {
    return Failure('Error: ${error.toString()}');
  }

  @override
  List<String> validate(Map<String, dynamic> data) {
    return [];
  }

  // ============================================================================
  // USER PROFILE RETRIEVAL
  // ============================================================================

  /// Get user profile by ID
  /// Primary lookup method
  Future<Result<ProfilesRow?>> getUserById(String userId) async {
    return getById(userId);
  }

  /// Get user profile by username
  /// Used for search, mentions, profile lookup
  Future<Result<ProfilesRow?>> getUserByUsername(String username) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('username', username)
          .maybeSingle();
      
      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get user by username: ${e.toString()}');
    }
  }

  /// Get user profile by email
  /// Used for account recovery, admin lookups
  Future<Result<ProfilesRow?>> getUserByEmail(String email) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('email', email)
          .maybeSingle();
      
      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get user by email: ${e.toString()}');
    }
  }

  /// Get multiple users by IDs
  /// Batch fetch for leaderboards, social features
  Future<Result<List<ProfilesRow>>> getUsersByIds(List<String> userIds) async {
    return getByIds(userIds);
  }

  /// Get current authenticated user
  /// Uses supabase.auth.currentUser
  Future<Result<ProfilesRow?>> getCurrentUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return Success(null);
      
      return getUserById(user.id);
    } catch (e) {
      return Failure('Failed to get current user: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER PROFILE UPDATES
  // ============================================================================

  /// Update user profile fields
  /// Generic update for any profile field
  Future<Result<ProfilesRow>> updateProfile({
    required String userId,
    Map<String, dynamic>? updates,
  }) async {
    if (updates == null || updates.isEmpty) {
      return Failure('No updates provided');
    }
    return update(userId, updates);
  }

  /// Update username
  /// Validates uniqueness
  Future<Result<ProfilesRow>> updateUsername({
    required String userId,
    required String username,
  }) async {
    return update(userId, {'username': username});
  }

  /// Update avatar URL
  Future<Result<ProfilesRow>> updateAvatar({
    required String userId,
    required String avatarUrl,
  }) async {
    return update(userId, {'avatar_url': avatarUrl});
  }

  /// Update bio/description
  Future<Result<ProfilesRow>> updateBio({
    required String userId,
    required String bio,
  }) async {
    return update(userId, {'bio': bio});
  }

  /// Update background image
  Future<Result<ProfilesRow>> updateBackgroundImage({
    required String userId,
    required String backgroundUrl,
  }) async {
    return update(userId, {'background_image_url': backgroundUrl});
  }

  // ============================================================================
  // XP & PROGRESSION
  // ============================================================================

  /// Get user's current XP
  Future<Result<int>> getUserXp(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Failure(result.error ?? 'Failed to get XP');
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.xp);
    } catch (e) {
      return Failure('Failed to get user XP: ${e.toString()}');
    }
  }

  /// Update user XP
  /// Sets XP to specific value
  Future<Result<ProfilesRow>> updateXp({
    required String userId,
    required int xp,
  }) async {
    return update(userId, {'xp': xp});
  }

  /// Add XP to user
  /// Increments XP by amount
  Future<Result<ProfilesRow>> addXp({
    required String userId,
    required int xpAmount,
  }) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error ?? 'Failed to add XP');
      
      final currentXp = xpResult.data!;
      return updateXp(userId: userId, xp: currentXp + xpAmount);
    } catch (e) {
      return Failure('Failed to add XP: ${e.toString()}');
    }
  }

  /// Get user's rank
  Future<Result<String?>> getUserRank(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Failure(result.error ?? 'Failed to get rank');
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.rank);
    } catch (e) {
      return Failure('Failed to get user rank: ${e.toString()}');
    }
  }

  /// Update user rank
  Future<Result<ProfilesRow>> updateRank({
    required String userId,
    required String rank,
  }) async {
    return update(userId, {'rank': rank});
  }

  // ============================================================================
  // COSMETICS & CUSTOMIZATION
  // ============================================================================

  /// Get unlocked cosmetics list
  Future<Result<List<String>>> getUnlockedCosmetics(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Failure(result.error ?? 'Failed to get cosmetics');
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.unlockedCosmetics);
    } catch (e) {
      return Failure('Failed to get unlocked cosmetics: ${e.toString()}');
    }
  }

  /// Add cosmetic to unlocked list
  /// Appends to unlocked_cosmetics array
  Future<Result<ProfilesRow>> unlockCosmetic({
    required String userId,
    required String cosmeticId,
  }) async {
    try {
      final cosmeticsResult = await getUnlockedCosmetics(userId);
      if (cosmeticsResult.isFailure) {
        return Failure(cosmeticsResult.error ?? 'Failed to unlock cosmetic');
      }
      
      final cosmetics = cosmeticsResult.data!;
      if (!cosmetics.contains(cosmeticId)) {
        cosmetics.add(cosmeticId);
      }
      
      return update(userId, {'unlocked_cosmetics': cosmetics});
    } catch (e) {
      return Failure('Failed to unlock cosmetic: ${e.toString()}');
    }
  }

  /// Remove cosmetic from unlocked list
  Future<Result<ProfilesRow>> removeCosmetic({
    required String userId,
    required String cosmeticId,
  }) async {
    try {
      final cosmeticsResult = await getUnlockedCosmetics(userId);
      if (cosmeticsResult.isFailure) {
        return Failure(cosmeticsResult.error ?? 'Failed to remove cosmetic');
      }
      
      final cosmetics = cosmeticsResult.data!;
      cosmetics.remove(cosmeticId);
      
      return update(userId, {'unlocked_cosmetics': cosmetics});
    } catch (e) {
      return Failure('Failed to remove cosmetic: ${e.toString()}');
    }
  }

  /// Check if cosmetic is unlocked
  Future<Result<bool>> isCosmeticUnlocked({
    required String userId,
    required String cosmeticId,
  }) async {
    try {
      final cosmeticsResult = await getUnlockedCosmetics(userId);
      if (cosmeticsResult.isFailure) return Success(false);
      
      return Success(cosmeticsResult.data!.contains(cosmeticId));
    } catch (e) {
      return Failure('Failed to check cosmetic: ${e.toString()}');
    }
  }

  /// Equip namecard
  Future<Result<ProfilesRow>> equipNamecard({
    required String userId,
    required String namecardId,
  }) async {
    return update(userId, {'equipped_namecard': namecardId});
  }

  /// Equip border
  Future<Result<ProfilesRow>> equipBorder({
    required String userId,
    required String borderId,
  }) async {
    return update(userId, {'equipped_border': borderId});
  }

  /// Unequip cosmetic
  /// Sets equipped field to null
  Future<Result<ProfilesRow>> unequipCosmetic({
    required String userId,
    required String cosmeticType,
  }) async {
    final Map<String, dynamic> updates = {};
    
    if (cosmeticType == 'namecard') {
      updates['equipped_namecard'] = null;
    } else if (cosmeticType == 'border') {
      updates['equipped_border'] = null;
    }
    
    if (updates.isEmpty) return Failure('Invalid cosmetic type');
    return update(userId, updates);
  }

  // ============================================================================
  // STREAK TRACKING
  // ============================================================================

  /// Get user's task streak
  Future<Result<int>> getTaskStreak(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Failure(result.error ?? 'Failed to get streak');
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.taskStreak ?? 0);
    } catch (e) {
      return Failure('Failed to get task streak: ${e.toString()}');
    }
  }

  /// Update task streak
  Future<Result<ProfilesRow>> updateTaskStreak({
    required String userId,
    required int streak,
  }) async {
    return update(userId, {'task_streak': streak});
  }

  /// Increment task streak
  Future<Result<ProfilesRow>> incrementTaskStreak(String userId) async {
    try {
      final streakResult = await getTaskStreak(userId);
      if (streakResult.isFailure) {
        return Failure(streakResult.error ?? 'Failed to increment streak');
      }
      
      final currentStreak = streakResult.data!;
      return updateTaskStreak(userId: userId, streak: currentStreak + 1);
    } catch (e) {
      return Failure('Failed to increment streak: ${e.toString()}');
    }
  }

  /// Reset task streak to 0
  Future<Result<ProfilesRow>> resetTaskStreak(String userId) async {
    return updateTaskStreak(userId: userId, streak: 0);
  }

  /// Get last task done timestamp
  Future<Result<DateTime?>> getLastTaskDone(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) {
        return Failure(result.error ?? 'Failed to get last task done');
      }
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.lastTaskDone);
    } catch (e) {
      return Failure('Failed to get last task done: ${e.toString()}');
    }
  }

  /// Update last task done timestamp
  Future<Result<ProfilesRow>> updateLastTaskDone({
    required String userId,
    required DateTime timestamp,
  }) async {
    return update(userId, {'last_task_done': timestamp.toIso8601String()});
  }

  /// Check if streak is active
  /// Returns true if last task was today or yesterday
  Future<Result<bool>> isStreakActive(String userId) async {
    try {
      final lastTaskResult = await getLastTaskDone(userId);
      if (lastTaskResult.isFailure) return Success(false);
      if (lastTaskResult.data == null) return Success(false);
      
      final lastTask = lastTaskResult.data!;
      final now = DateTime.now();
      final difference = now.difference(lastTask).inDays;
      
      return Success(difference <= 1);
    } catch (e) {
      return Failure('Failed to check streak: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENTS & STATISTICS
  // ============================================================================

  /// Get total achievements count
  Future<Result<int>> getTotalAchievements(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) {
        return Failure(result.error ?? 'Failed to get achievements');
      }
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.totalAchievements ?? 0);
    } catch (e) {
      return Failure('Failed to get total achievements: ${e.toString()}');
    }
  }

  /// Update total achievements
  Future<Result<ProfilesRow>> updateTotalAchievements({
    required String userId,
    required int count,
  }) async {
    return update(userId, {'total_achievements': count});
  }

  /// Increment achievement count
  Future<Result<ProfilesRow>> incrementAchievements(String userId) async {
    try {
      final achievementsResult = await getTotalAchievements(userId);
      if (achievementsResult.isFailure) {
        return Failure(achievementsResult.error ?? 'Failed to increment achievements');
      }
      
      final currentCount = achievementsResult.data!;
      return updateTotalAchievements(userId: userId, count: currentCount + 1);
    } catch (e) {
      return Failure('Failed to increment achievements: ${e.toString()}');
    }
  }

  /// Get user statistics
  /// Returns XP, achievements, streak, rank
  Future<Result<UserStatistics>> getUserStatistics(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) {
        return Failure(result.error ?? 'Failed to get statistics');
      }
      if (result.data == null) return Failure('User not found');
      
      final profile = result.data!;
      return Success(UserStatistics(
        xp: profile.xp,
        rank: profile.rank,
        totalAchievements: profile.totalAchievements ?? 0,
        taskStreak: profile.taskStreak ?? 0,
        lastTaskDone: profile.lastTaskDone,
        unlockedCosmeticsCount: profile.unlockedCosmetics.length,
      ));
    } catch (e) {
      return Failure('Failed to get user statistics: ${e.toString()}');
    }
  }

  // ============================================================================
  // ONBOARDING & SETUP
  // ============================================================================

  /// Check if onboarding completed
  Future<Result<bool>> hasCompletedOnboarding(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Success(false);
      if (result.data == null) return Success(false);
      
      return Success(result.data!.onboardingCompleted);
    } catch (e) {
      return Failure('Failed to check onboarding: ${e.toString()}');
    }
  }

  /// Mark onboarding as complete
  Future<Result<ProfilesRow>> completeOnboarding(String userId) async {
    return update(userId, {'onboarding_completed': true});
  }

  /// Initialize new user profile
  /// Creates profile with default values
  Future<Result<ProfilesRow>> initializeProfile({
    required String userId,
    required String email,
    String? username,
  }) async {
    try {
      final profileData = {
        'id': userId,
        'email': email,
        if (username != null) 'username': username,
        'xp': 0,
        'task_streak': 0,
        'total_achievements': 0,
        'unlocked_cosmetics': [],
        'onboarding_completed': false,
        'is_admin': false,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      return insert(profileData);
    } catch (e) {
      return Failure('Failed to initialize profile: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER SEARCH & DISCOVERY
  // ============================================================================

  /// Search users by username
  /// Partial match, case-insensitive
  Future<Result<List<ProfilesRow>>> searchUsersByUsername(String query) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .ilike('username', '%$query%')
          .limit(50);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to search users: ${e.toString()}');
    }
  }

  /// Get top users by XP
  /// Leaderboard query
  Future<Result<List<ProfilesRow>>> getTopUsersByXp({
    int limit = 50,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('xp', ascending: false)
          .limit(limit);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get top users by XP: ${e.toString()}');
    }
  }

  /// Get top users by achievements
  Future<Result<List<ProfilesRow>>> getTopUsersByAchievements({
    int limit = 50,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('total_achievements', ascending: false)
          .limit(limit);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get top users by achievements: ${e.toString()}');
    }
  }

  /// Get top users by streak
  Future<Result<List<ProfilesRow>>> getTopUsersByStreak({
    int limit = 50,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('task_streak', ascending: false)
          .limit(limit);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get top users by streak: ${e.toString()}');
    }
  }

  /// Get recently active users
  /// Sorted by updated_at
  Future<Result<List<ProfilesRow>>> getRecentlyActiveUsers({
    int limit = 20,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order('updated_at', ascending: false)
          .limit(limit);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get recently active users: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER VALIDATION
  // ============================================================================

  /// Check if username exists
  Future<Result<bool>> usernameExists(String username) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('username', username)
          .maybeSingle();
      
      return Success(response != null);
    } catch (e) {
      return Failure('Failed to check username: ${e.toString()}');
    }
  }

  /// Check if email exists
  Future<Result<bool>> emailExists(String email) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('email', email)
          .maybeSingle();
      
      return Success(response != null);
    } catch (e) {
      return Failure('Failed to check email: ${e.toString()}');
    }
  }

  /// Check if user exists
  Future<Result<bool>> userExists(String userId) async {
    return exists(userId);
  }

  /// Validate username format
  /// Checks length, characters, reserved words
  Result<bool> validateUsername(String username) {
    if (username.length < 3) return Failure('Username too short');
    if (username.length > 20) return Failure('Username too long');
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return Failure('Username contains invalid characters');
    }
    
    final reservedWords = ['admin', 'root', 'system', 'moderator'];
    if (reservedWords.contains(username.toLowerCase())) {
      return Failure('Username is reserved');
    }
    
    return Success(true);
  }

  /// Validate bio length
  Result<bool> validateBio(String bio) {
    if (bio.length > 500) return Failure('Bio too long');
    return Success(true);
  }

  // ============================================================================
  // NOTIFICATIONS & SETTINGS
  // ============================================================================

  /// Get FCM token for push notifications
  Future<Result<String?>> getFcmToken(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) {
        return Failure(result.error ?? 'Failed to get FCM token');
      }
      if (result.data == null) return Failure('User not found');
      
      return Success(result.data!.fcmToken);
    } catch (e) {
      return Failure('Failed to get FCM token: ${e.toString()}');
    }
  }

  /// Update FCM token
  Future<Result<ProfilesRow>> updateFcmToken({
    required String userId,
    required String token,
  }) async {
    return update(userId, {'fcm_token': token});
  }

  /// Remove FCM token (logout/opt-out)
  Future<Result<ProfilesRow>> removeFcmToken(String userId) async {
    return update(userId, {'fcm_token': null});
  }

  // ============================================================================
  // ADMIN & MODERATION
  // ============================================================================

  /// Check if user is admin
  Future<Result<bool>> isAdmin(String userId) async {
    try {
      final result = await getUserById(userId);
      if (result.isFailure) return Success(false);
      if (result.data == null) return Success(false);
      
      return Success(result.data!.isAdmin);
    } catch (e) {
      return Failure('Failed to check admin status: ${e.toString()}');
    }
  }

  /// Grant admin privileges
  Future<Result<ProfilesRow>> grantAdminPrivileges(String userId) async {
    return update(userId, {'is_admin': true});
  }

  /// Revoke admin privileges
  Future<Result<ProfilesRow>> revokeAdminPrivileges(String userId) async {
    return update(userId, {'is_admin': false});
  }

  /// Get all admin users
  Future<Result<List<ProfilesRow>>> getAdminUsers() async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('is_admin', true);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get admin users: ${e.toString()}');
    }
  }

  // ============================================================================
  // USER COMPARISON
  // ============================================================================

  /// Compare two users
  /// Returns XP difference, achievement difference, etc.
  Future<Result<UserComparison>> compareUsers({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final user1Result = await getUserById(userId1);
      final user2Result = await getUserById(userId2);
      
      if (user1Result.isFailure) {
        return Failure(user1Result.error ?? 'Failed to get user 1');
      }
      if (user2Result.isFailure) {
        return Failure(user2Result.error ?? 'Failed to get user 2');
      }
      if (user1Result.data == null || user2Result.data == null) {
        return Failure('User not found');
      }
      
      final user1 = user1Result.data!;
      final user2 = user2Result.data!;
      
      return Success(UserComparison(
        user1: user1,
        user2: user2,
        xpDifference: user1.xp - user2.xp,
        achievementDifference: (user1.totalAchievements ?? 0) - (user2.totalAchievements ?? 0),
        streakDifference: (user1.taskStreak ?? 0) - (user2.taskStreak ?? 0),
      ));
    } catch (e) {
      return Failure('Failed to compare users: ${e.toString()}');
    }
  }

  /// Get user rank position
  /// Returns position on XP leaderboard
  Future<Result<int>> getUserRankPosition(String userId) async {
    try {
      final userResult = await getUserById(userId);
      if (userResult.isFailure) {
        return Failure(userResult.error ?? 'Failed to get rank position');
      }
      if (userResult.data == null) return Failure('User not found');
      
      final userXp = userResult.data!.xp;
      
      final response = await supabase
          .from(tableName)
          .select('id')
          .gt('xp', userXp)
          .count(CountOption.exact);
      
      return Success(response.count + 1);
    } catch (e) {
      return Failure('Failed to get rank position: ${e.toString()}');
    }
  }

  // ============================================================================
  // BULK OPERATIONS
  // ============================================================================

  /// Bulk update XP for multiple users
  /// Used for event rewards, corrections
  Future<Result<List<ProfilesRow>>> bulkUpdateXp(
    List<XpUpdate> updates,
  ) async {
    try {
      final results = <ProfilesRow>[];
      
      for (final update in updates) {
        final result = await addXp(
          userId: update.userId,
          xpAmount: update.xpAmount,
        );
        if (result.isSuccess) {
          results.add(result.data!);
        }
      }
      
      return Success(results);
    } catch (e) {
      return Failure('Failed to bulk update XP: ${e.toString()}');
    }
  }

  /// Get users by rank tier
  /// Returns all users with specific rank
  Future<Result<List<ProfilesRow>>> getUsersByRank(String rank) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('rank', rank);
      
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get users by rank: ${e.toString()}');
    }
  }

  /// Update multiple profiles
  /// Batch update for efficiency
  Future<Result<List<ProfilesRow>>> bulkUpdateProfiles(
    List<ProfileUpdate> updates,
  ) async {
    try {
      final results = <ProfilesRow>[];
      
      for (final update in updates) {
        final result = await this.update(update.userId, update.updates);
        if (result.isSuccess) {
          results.add(result.data!);
        }
      }
      
      return Success(results);
    } catch (e) {
      return Failure('Failed to bulk update profiles: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR REPOSITORY RESPONSES
// ============================================================================

/// User statistics aggregate
class UserStatistics {
  final int xp;
  final String? rank;
  final int totalAchievements;
  final int taskStreak;
  final DateTime? lastTaskDone;
  final int unlockedCosmeticsCount;

  UserStatistics({
    required this.xp,
    this.rank,
    required this.totalAchievements,
    required this.taskStreak,
    this.lastTaskDone,
    required this.unlockedCosmeticsCount,
  });
}

/// User comparison data
class UserComparison {
  final ProfilesRow user1;
  final ProfilesRow user2;
  final int xpDifference;
  final int achievementDifference;
  final int streakDifference;

  UserComparison({
    required this.user1,
    required this.user2,
    required this.xpDifference,
    required this.achievementDifference,
    required this.streakDifference,
  });
}

/// XP update for bulk operations
class XpUpdate {
  final String userId;
  final int xpAmount;

  XpUpdate({
    required this.userId,
    required this.xpAmount,
  });
}

/// Profile update for bulk operations
class ProfileUpdate {
  final String userId;
  final Map<String, dynamic> updates;

  ProfileUpdate({
    required this.userId,
    required this.updates,
  });
}
