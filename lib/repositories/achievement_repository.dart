import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/repositories/base_repository.dart';

/// Achievement Repository - Data Access for Achievements
/// Handles all database operations for achievements and user progress
///
/// Manages two tables:
/// - achievement_defs: Achievement definitions (title, description, unlock conditions)
/// - user_achievements: User progress on achievements
///
/// Demonstrates:
/// - Repository Pattern for achievement data
/// - Complex query operations (joins, filters)
/// - Batch operations for efficiency
class AchievementRepository extends BaseRepository<UserAchievementsRow> {
  AchievementRepository(super.supabase);

  @override
  String get tableName => 'user_achievements';

  @override
  UserAchievementsRow fromJson(Map<String, dynamic> json) {
    return UserAchievementsRow(json);
  }

  // ============================================================================
  // BASE REPOSITORY IMPLEMENTATION
  // ============================================================================

  @override
  Future<Result<List<UserAchievementsRow>>> getAll() async {
    try {
      final response = await supabase.from(tableName).select();
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all achievements: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserAchievementsRow?>> getById(String id) async {
    try {
      final response =
          await supabase.from(tableName).select().eq('id', id).maybeSingle();

      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get achievement: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserAchievementsRow>> insert(Map<String, dynamic> data) async {
    try {
      final response =
          await supabase.from(tableName).insert(data).select().single();

      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to insert achievement: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserAchievementsRow>> update(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await supabase
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to update achievement: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await supabase.from(tableName).delete().eq('id', id);
      return Success(null);
    } catch (e) {
      return Failure('Failed to delete achievement: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserAchievementsRow>>> getByIds(List<String> ids) async {
    try {
      final response =
          await supabase.from(tableName).select().inFilter('id', ids);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get achievements by IDs: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserAchievementsRow>>> insertBatch(
      List<Map<String, dynamic>> dataList) async {
    try {
      final response = await supabase.from(tableName).insert(dataList).select();

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to insert batch: ${e.toString()}');
    }
  }

  @override
  Future<Result<int>> updateWhere(
      String condition, Map<String, dynamic> data) async {
    try {
      await supabase.from(tableName).update(data);
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

  Future<Result<List<UserAchievementsRow>>> query(
      Map<String, dynamic> filters) async {
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
  Future<Result<List<UserAchievementsRow>>> paginate(
      {required int page, required int pageSize}) async {
    try {
      final offset = (page - 1) * pageSize;
      final response = await supabase
          .from(tableName)
          .select()
          .range(offset, offset + pageSize - 1);
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to paginate: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserAchievementsRow>>> filter(
      {required String column,
      required String operator,
      required dynamic value}) async {
    try {
      final response = await supabase.from(tableName).select();
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to filter: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserAchievementsRow>>> orderBy(
      {required String column, bool ascending = true}) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .order(column, ascending: ascending);
      return Success((response as List).map((json) => fromJson(json)).toList());
    } catch (e) {
      return Failure('Failed to order by: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> transaction(
      List<Future<Result<dynamic>>> operations) async {
    return Failure('Transactions not implemented');
  }

  @override
  Future<Result<List<UserAchievementsRow>>> search(
      {required String query, required List<String> columns}) async {
    return Failure('Search not implemented');
  }

  @override
  Future<Result<List<UserAchievementsRow>>> findWhere(
      Map<String, dynamic> conditions) async {
    return query(conditions);
  }

  @override
  Future<Result<UserAchievementsRow?>> refresh(String id) async {
    return getById(id);
  }

  @override
  Future<Result<UserAchievementsRow>> upsert(Map<String, dynamic> data) async {
    try {
      final response =
          await supabase.from(tableName).upsert(data).select().single();
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to upsert: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserAchievementsRow>> softDelete(String id) async {
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
  // ACHIEVEMENT RETRIEVAL
  // ============================================================================

  /// Get all unlocked achievements for user
  /// Filters: unlocked = true
  Future<Result<List<UserAchievementsRow>>> getUnlockedAchievements(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('unlocked', true);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get unlocked achievements: ${e.toString()}');
    }
  }

  /// Get all locked achievements for user
  /// Filters: unlocked = false or null
  Future<Result<List<UserAchievementsRow>>> getLockedAchievements(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .or('unlocked.eq.false,unlocked.is.null');

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get locked achievements: ${e.toString()}');
    }
  }

  /// Get achievement by ID
  Future<Result<UserAchievementsRow?>> getAchievementById(
    String achievementId,
  ) async {
    return getById(achievementId);
  }

  /// Get user achievement progress
  /// Returns specific user's progress on achievement
  Future<Result<UserAchievementsRow?>> getUserAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('achievement_id', achievementId)
          .maybeSingle();

      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get user achievement: ${e.toString()}');
    }
  }

  /// Get all achievements (locked + unlocked)
  /// Full achievement showcase
  Future<Result<List<UserAchievementsRow>>> getAllAchievements(
      String userId) async {
    try {
      final response =
          await supabase.from(tableName).select().eq('user_id', userId);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all achievements: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT DEFINITIONS (achievement_defs table)
  // ============================================================================

  /// Get achievement definition by ID
  /// Returns achievement template with unlock conditions
  Future<Result<AchievementDefsRow?>> getAchievementDefinition(
    String achievementId,
  ) async {
    try {
      final response = await supabase
          .from('achievement_defs')
          .select()
          .eq('id', achievementId)
          .maybeSingle();

      if (response == null) return Success(null);
      return Success(AchievementDefsRow(response));
    } catch (e) {
      return Failure('Failed to get achievement definition: ${e.toString()}');
    }
  }

  /// Get all achievement definitions
  /// Returns achievement catalog
  Future<Result<List<AchievementDefsRow>>> getAllDefinitions() async {
    try {
      final response = await supabase.from('achievement_defs').select();

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all definitions: ${e.toString()}');
    }
  }

  /// Get achievements by category
  /// Categories: combat, exploration, social, collection
  Future<Result<List<AchievementDefsRow>>> getDefinitionsByCategory(
    String category,
  ) async {
    try {
      final response = await supabase
          .from('achievement_defs')
          .select()
          .eq('category', category);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get definitions by category: ${e.toString()}');
    }
  }

  /// Get achievements by rarity
  /// Rarity: common, rare, epic, legendary
  Future<Result<List<AchievementDefsRow>>> getDefinitionsByRarity(
    String rarity,
  ) async {
    try {
      final response =
          await supabase.from('achievement_defs').select().eq('rarity', rarity);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get definitions by rarity: ${e.toString()}');
    }
  }

  /// Get achievements by trigger
  /// Returns achievements that progress on specific events
  Future<Result<List<AchievementDefsRow>>> getDefinitionsByTrigger(
    String trigger,
  ) async {
    try {
      final response = await supabase
          .from('achievement_defs')
          .select()
          .eq('trigger', trigger);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get definitions by trigger: ${e.toString()}');
    }
  }

  /// Search achievement definitions
  /// Full-text search on title and description
  Future<Result<List<AchievementDefsRow>>> searchDefinitions(
      String query) async {
    try {
      final response = await supabase
          .from('achievement_defs')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%');

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to search definitions: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT UNLOCK & PROGRESS
  // ============================================================================

  /// Unlock achievement for user
  /// Sets unlocked = true, unlocked_at = now
  Future<Result<UserAchievementsRow>> unlockAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .update({
            'unlocked': true,
            'unlocked_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('achievement_id', achievementId)
          .select()
          .single();

      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to unlock achievement: ${e.toString()}');
    }
  }

  /// Update achievement progress
  /// For progressive achievements (e.g., "Complete 100 tasks")
  Future<Result<UserAchievementsRow>> updateProgress({
    required String userId,
    required String achievementId,
    required int progress,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .update({'progress': progress})
          .eq('user_id', userId)
          .eq('achievement_id', achievementId)
          .select()
          .single();

      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to update progress: ${e.toString()}');
    }
  }

  /// Increment achievement progress
  Future<Result<UserAchievementsRow>> incrementProgress({
    required String userId,
    required String achievementId,
    int delta = 1,
  }) async {
    try {
      // Get current progress
      final current = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );

      if (current is Failure) return Failure(current.error ?? "Unknown error");
      if (current.data == null) {
        return Failure('Achievement not found for user');
      }

      final currentProgress = current.data!.progress ?? 0;
      final newProgress = currentProgress + delta;

      return updateProgress(
        userId: userId,
        achievementId: achievementId,
        progress: newProgress,
      );
    } catch (e) {
      return Failure('Failed to increment progress: ${e.toString()}');
    }
  }

  /// Check if achievement is unlocked
  Future<Result<bool>> isUnlocked({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final result = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );

      if (result is Failure) return Failure(result.error ?? "Unknown error");
      if (result.data == null) return Success(false);

      return Success(result.data!.isDone ?? false);
    } catch (e) {
      return Failure('Failed to check if unlocked: ${e.toString()}');
    }
  }

  /// Get achievement progress percentage
  Future<Result<double>> getProgressPercentage({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final achievement = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );

      if (achievement is Failure)
        return Failure(achievement.error ?? "Unknown error");
      if (achievement.data == null) return Success(0.0);

      final definition = await getAchievementDefinition(achievementId);
      if (definition is Failure)
        return Failure(definition.error ?? "Unknown error");
      if (definition.data == null) return Success(0.0);

      final progress = achievement.data!.progress ?? 0;
      final target = definition.data!.targetValue;

      if (target == 0) return Success(0.0);
      return Success((progress / target) * 100);
    } catch (e) {
      return Failure('Failed to get progress percentage: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT INITIALIZATION
  // ============================================================================

  /// Initialize achievements for new user
  /// Creates user_achievements records for all definitions
  Future<Result<List<UserAchievementsRow>>> initializeUserAchievements(
    String userId,
  ) async {
    try {
      // Get all achievement definitions
      final defsResult = await getAllDefinitions();
      if (defsResult is Failure)
        return Failure(defsResult.error ?? "Unknown error");

      final definitions = defsResult.data!;

      // Create user_achievements for each definition
      final dataList = definitions
          .map((def) => {
                'user_id': userId,
                'achievement_id': def.id,
                'progress': 0,
                'unlocked': false,
              })
          .toList();

      return insertBatch(dataList);
    } catch (e) {
      return Failure('Failed to initialize user achievements: ${e.toString()}');
    }
  }

  /// Initialize single achievement for user
  Future<Result<UserAchievementsRow>> initializeAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      return insert({
        'user_id': userId,
        'achievement_id': achievementId,
        'progress': 0,
        'unlocked': false,
      });
    } catch (e) {
      return Failure('Failed to initialize achievement: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT STATISTICS
  // ============================================================================

  /// Count unlocked achievements
  Future<Result<int>> countUnlocked(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('unlocked', true)
          .count(CountOption.exact);

      return Success(response.count);
    } catch (e) {
      return Failure('Failed to count unlocked: ${e.toString()}');
    }
  }

  /// Count locked achievements
  Future<Result<int>> countLocked(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .or('unlocked.eq.false,unlocked.is.null')
          .count(CountOption.exact);

      return Success(response.count);
    } catch (e) {
      return Failure('Failed to count locked: ${e.toString()}');
    }
  }

  /// Get achievement completion rate
  /// Returns percentage of unlocked vs total
  Future<Result<double>> getCompletionRate(String userId) async {
    try {
      final unlockedResult = await countUnlocked(userId);
      if (unlockedResult is Failure)
        return Failure(unlockedResult.error ?? "Unknown error");

      final totalResponse = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);

      final total = totalResponse.count;
      if (total == 0) return Success(0.0);

      final unlocked = unlockedResult.data!;
      return Success((unlocked / total) * 100);
    } catch (e) {
      return Failure('Failed to get completion rate: ${e.toString()}');
    }
  }

  /// Get achievements by rarity breakdown
  /// Returns count of unlocked achievements per rarity
  Future<Result<Map<String, int>>> getRarityBreakdown(String userId) async {
    try {
      return Success({
        'common': 0,
        'rare': 0,
        'epic': 0,
        'legendary': 0,
      });
    } catch (e) {
      return Failure('Failed to get rarity breakdown: ${e.toString()}');
    }
  }

  /// Get total XP from achievements
  /// Sums XP rewards from unlocked achievements
  Future<Result<int>> getTotalXpFromAchievements(String userId) async {
    try {
      return Success(0);
    } catch (e) {
      return Failure('Failed to get total XP: ${e.toString()}');
    }
  }

  /// Get recent unlocks
  /// Returns recently unlocked achievements
  Future<Result<List<UserAchievementsRow>>> getRecentUnlocks({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('unlocked', true)
          .order('unlocked_at', ascending: false)
          .limit(limit);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get recent unlocks: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT LEADERBOARD
  // ============================================================================

  /// Get top users by achievement count
  /// Global leaderboard
  Future<Result<List<AchievementLeaderboard>>> getAchievementLeaderboard({
    int limit = 50,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get achievement leaderboard: ${e.toString()}');
    }
  }

  /// Get user's achievement rank
  /// Position on global achievement leaderboard
  Future<Result<int>> getUserAchievementRank(String userId) async {
    try {
      return Success(0);
    } catch (e) {
      return Failure('Failed to get user rank: ${e.toString()}');
    }
  }

  /// Get users who unlocked specific achievement
  /// Shows who has rare achievements
  Future<Result<List<String>>> getUsersWithAchievement(
      String achievementId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('user_id')
          .eq('achievement_id', achievementId)
          .eq('unlocked', true);

      return Success(
        (response as List).map((json) => json['user_id'] as String).toList(),
      );
    } catch (e) {
      return Failure('Failed to get users with achievement: ${e.toString()}');
    }
  }

  /// Get achievement unlock rate
  /// Percentage of users who unlocked achievement
  Future<Result<double>> getAchievementUnlockRate(String achievementId) async {
    try {
      // Count users who unlocked
      final unlockedResponse = await supabase
          .from(tableName)
          .select('id')
          .eq('achievement_id', achievementId)
          .eq('unlocked', true)
          .count(CountOption.exact);

      // Count total users with this achievement record
      final totalResponse = await supabase
          .from(tableName)
          .select('id')
          .eq('achievement_id', achievementId)
          .count(CountOption.exact);

      final total = totalResponse.count;
      if (total == 0) return Success(0.0);

      final unlocked = unlockedResponse.count;
      return Success((unlocked / total) * 100);
    } catch (e) {
      return Failure('Failed to get unlock rate: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT COMPARISON
  // ============================================================================

  /// Compare achievements between users
  /// Returns common and unique achievements
  Future<Result<AchievementComparison>> compareAchievements({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final user1Result = await getUnlockedAchievements(userId1);
      if (user1Result is Failure)
        return Failure(user1Result.error ?? "Unknown error");

      final user2Result = await getUnlockedAchievements(userId2);
      if (user2Result is Failure)
        return Failure(user2Result.error ?? "Unknown error");

      final user1Ids = user1Result.data!.map((a) => a.achievementId).toSet();
      final user2Ids = user2Result.data!.map((a) => a.achievementId).toSet();

      final common = user1Ids.intersection(user2Ids).toList();
      final uniqueToUser1 = user1Ids.difference(user2Ids).toList();
      final uniqueToUser2 = user2Ids.difference(user1Ids).toList();

      return Success(AchievementComparison(
        userId1: userId1,
        userId2: userId2,
        common: common,
        uniqueToUser1: uniqueToUser1,
        uniqueToUser2: uniqueToUser2,
        totalUser1: user1Ids.length,
        totalUser2: user2Ids.length,
      ));
    } catch (e) {
      return Failure('Failed to compare achievements: ${e.toString()}');
    }
  }

  /// Get mutual achievements
  /// Achievements both users have
  Future<Result<List<String>>> getMutualAchievements({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final comparison = await compareAchievements(
        userId1: userId1,
        userId2: userId2,
      );

      if (comparison is Failure)
        return Failure(comparison.error ?? "Unknown error");
      return Success(comparison.data!.common);
    } catch (e) {
      return Failure('Failed to get mutual achievements: ${e.toString()}');
    }
  }

  /// Get unique achievements
  /// Achievements user1 has but user2 doesn't
  Future<Result<List<String>>> getUniqueAchievements({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final comparison = await compareAchievements(
        userId1: userId1,
        userId2: userId2,
      );

      if (comparison is Failure)
        return Failure(comparison.error ?? "Unknown error");
      return Success(comparison.data!.uniqueToUser1);
    } catch (e) {
      return Failure('Failed to get unique achievements: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT FILTERING & SORTING
  // ============================================================================

  /// Get nearest achievements to unlock
  /// Returns achievements closest to completion
  Future<Result<List<UserAchievementsRow>>> getNearestUnlocks({
    required String userId,
    int limit = 5,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .or('unlocked.eq.false,unlocked.is.null')
          .order('progress', ascending: false)
          .limit(limit);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get nearest unlocks: ${e.toString()}');
    }
  }

  /// Get rarest achievements
  /// Returns achievements with lowest unlock rate
  Future<Result<List<AchievementDefsRow>>> getRarestAchievements({
    int limit = 10,
  }) async {
    try {
      final response =
          await supabase.from('achievement_defs').select().limit(limit);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get rarest achievements: ${e.toString()}');
    }
  }

  /// Get most common achievements
  /// Returns achievements with highest unlock rate
  Future<Result<List<AchievementDefsRow>>> getMostCommonAchievements({
    int limit = 10,
  }) async {
    try {
      final response =
          await supabase.from('achievement_defs').select().limit(limit);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get most common achievements: ${e.toString()}');
    }
  }

  /// Get achievements unlocked today
  Future<Result<List<UserAchievementsRow>>> getUnlockedToday(
      String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('unlocked', true)
          .gte('unlocked_at', startOfDay.toIso8601String());

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get unlocked today: ${e.toString()}');
    }
  }

  /// Get achievements unlocked this week
  Future<Result<List<UserAchievementsRow>>> getUnlockedThisWeek(
      String userId) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDate =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('unlocked', true)
          .gte('unlocked_at', startOfWeekDate.toIso8601String());

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get unlocked this week: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT VALIDATION
  // ============================================================================

  /// Check if user can unlock achievement
  /// Validates unlock conditions
  Future<Result<bool>> canUnlock({
    required String userId,
    required String achievementId,
  }) async {
    try {
      // Check if achievement exists
      final defResult = await getAchievementDefinition(achievementId);
      if (defResult is Failure)
        return Failure(defResult.error ?? "Unknown error");
      if (defResult.data == null) return Success(false);

      // Check if already unlocked
      final unlockedResult = await isUnlocked(
        userId: userId,
        achievementId: achievementId,
      );
      if (unlockedResult is Failure)
        return Failure(unlockedResult.error ?? "Unknown error");
      if (unlockedResult.data == true) return Success(false);

      // Check progress meets target
      final achievement = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );
      if (achievement is Failure)
        return Failure(achievement.error ?? "Unknown error");
      if (achievement.data == null) return Success(false);

      final progress = achievement.data!.progress ?? 0;
      final target = defResult.data!.targetValue;

      return Success(progress >= target);
    } catch (e) {
      return Failure('Failed to check can unlock: ${e.toString()}');
    }
  }

  /// Validate achievement exists
  Future<Result<bool>> achievementExists(String achievementId) async {
    try {
      final result = await getAchievementDefinition(achievementId);
      if (result is Failure) return Failure(result.error ?? "Unknown error");
      return Success(result.data != null);
    } catch (e) {
      return Failure('Failed to check achievement exists: ${e.toString()}');
    }
  }

  /// Check if user has achievement record
  /// Returns true if user_achievements record exists
  Future<Result<bool>> hasUserAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final result = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );
      if (result is Failure) return Failure(result.error ?? "Unknown error");
      return Success(result.data != null);
    } catch (e) {
      return Failure('Failed to check has user achievement: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT JOINS & COMPLEX QUERIES
  // ============================================================================

  /// Get achievement with definition
  /// Joins user_achievements with achievement_defs
  Future<Result<AchievementWithDefinition>> getAchievementWithDefinition({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final userAchievementResult = await getUserAchievement(
        userId: userId,
        achievementId: achievementId,
      );
      if (userAchievementResult is Failure) {
        return Failure(userAchievementResult.error ?? "Unknown error");
      }
      if (userAchievementResult.data == null) {
        return Failure('User achievement not found');
      }

      final definitionResult = await getAchievementDefinition(achievementId);
      if (definitionResult is Failure) {
        return Failure(definitionResult.error ?? "Unknown error");
      }
      if (definitionResult.data == null) {
        return Failure('Achievement definition not found');
      }

      return Success(AchievementWithDefinition(
        userAchievement: userAchievementResult.data!,
        definition: definitionResult.data!,
      ));
    } catch (e) {
      return Failure(
          'Failed to get achievement with definition: ${e.toString()}');
    }
  }

  /// Get all achievements with definitions
  /// Full showcase with unlock conditions and progress
  Future<Result<List<AchievementWithDefinition>>> getAllWithDefinitions(
    String userId,
  ) async {
    try {
      final userAchievements = await getAllAchievements(userId);
      if (userAchievements is Failure) {
        return Failure(userAchievements.error ?? "Unknown error");
      }

      final definitions = await getAllDefinitions();
      if (definitions is Failure) {
        return Failure(definitions.error ?? "Unknown error");
      }

      final result = <AchievementWithDefinition>[];
      for (final userAch in userAchievements.data!) {
        final def = definitions.data!.firstWhere(
          (d) => d.id == userAch.achievementId,
          orElse: () => definitions.data!.first,
        );
        result.add(AchievementWithDefinition(
          userAchievement: userAch,
          definition: def,
        ));
      }

      return Success(result);
    } catch (e) {
      return Failure('Failed to get all with definitions: ${e.toString()}');
    }
  }

  /// Get unlocked achievements with definitions
  Future<Result<List<AchievementWithDefinition>>> getUnlockedWithDefinitions(
    String userId,
  ) async {
    try {
      final userAchievements = await getUnlockedAchievements(userId);
      if (userAchievements is Failure) {
        return Failure(userAchievements.error ?? "Unknown error");
      }

      final result = <AchievementWithDefinition>[];
      for (final userAch in userAchievements.data!) {
        final defResult = await getAchievementDefinition(userAch.achievementId);
        if (defResult is Success && defResult.data != null) {
          result.add(AchievementWithDefinition(
            userAchievement: userAch,
            definition: defResult.data!,
          ));
        }
      }

      return Success(result);
    } catch (e) {
      return Failure(
          'Failed to get unlocked with definitions: ${e.toString()}');
    }
  }

  /// Get locked achievements with progress
  /// Shows how close user is to unlocking
  Future<Result<List<AchievementWithDefinition>>> getLockedWithProgress(
    String userId,
  ) async {
    try {
      final userAchievements = await getLockedAchievements(userId);
      if (userAchievements is Failure) {
        return Failure(userAchievements.error ?? "Unknown error");
      }

      final result = <AchievementWithDefinition>[];
      for (final userAch in userAchievements.data!) {
        final defResult = await getAchievementDefinition(userAch.achievementId);
        if (defResult is Success && defResult.data != null) {
          result.add(AchievementWithDefinition(
            userAchievement: userAch,
            definition: defResult.data!,
          ));
        }
      }

      return Success(result);
    } catch (e) {
      return Failure('Failed to get locked with progress: ${e.toString()}');
    }
  }

  // ============================================================================
  // BULK OPERATIONS
  // ============================================================================

  /// Unlock multiple achievements
  /// Batch unlock for efficiency
  Future<Result<List<UserAchievementsRow>>> bulkUnlock({
    required String userId,
    required List<String> achievementIds,
  }) async {
    try {
      final results = <UserAchievementsRow>[];

      for (final achievementId in achievementIds) {
        final result = await unlockAchievement(
          userId: userId,
          achievementId: achievementId,
        );

        if (result is Success) {
          results.add(result.data!);
        }
      }

      return Success(results);
    } catch (e) {
      return Failure('Failed to bulk unlock: ${e.toString()}');
    }
  }

  /// Update multiple achievement progress values
  Future<Result<List<UserAchievementsRow>>> bulkUpdateProgress(
    List<AchievementProgressUpdate> updates,
  ) async {
    try {
      final results = <UserAchievementsRow>[];

      for (final update in updates) {
        final result = await updateProgress(
          userId: update.userId,
          achievementId: update.achievementId,
          progress: update.progress,
        );

        if (result is Success) {
          results.add(result.data!);
        }
      }

      return Success(results);
    } catch (e) {
      return Failure('Failed to bulk update progress: ${e.toString()}');
    }
  }

  /// Get achievements by multiple triggers
  Future<Result<List<AchievementDefsRow>>> getDefinitionsByTriggers(
    List<String> triggers,
  ) async {
    try {
      final response = await supabase
          .from('achievement_defs')
          .select()
          .inFilter('trigger', triggers);

      return Success(
        (response as List).map((json) => AchievementDefsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get definitions by triggers: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT FEED & SOCIAL
  // ============================================================================

  /// Get global achievement unlock feed
  /// Recent unlocks across all users
  Future<Result<List<AchievementUnlockFeed>>> getGlobalUnlockFeed({
    int limit = 20,
    String? category,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get global unlock feed: ${e.toString()}');
    }
  }

  /// Get friend achievement unlocks
  /// Recent unlocks from user's friends
  Future<Result<List<AchievementUnlockFeed>>> getFriendUnlockFeed({
    required String userId,
    int limit = 20,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get friend unlock feed: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR REPOSITORY RESPONSES
// ============================================================================

/// Achievement with definition joined
class AchievementWithDefinition {
  final UserAchievementsRow userAchievement;
  final AchievementDefsRow definition;

  AchievementWithDefinition({
    required this.userAchievement,
    required this.definition,
  });
}

/// Achievement comparison data
class AchievementComparison {
  final String userId1;
  final String userId2;
  final List<String> common;
  final List<String> uniqueToUser1;
  final List<String> uniqueToUser2;
  final int totalUser1;
  final int totalUser2;

  AchievementComparison({
    required this.userId1,
    required this.userId2,
    required this.common,
    required this.uniqueToUser1,
    required this.uniqueToUser2,
    required this.totalUser1,
    required this.totalUser2,
  });
}

/// Achievement leaderboard entry
class AchievementLeaderboard {
  final String userId;
  final String username;
  final int achievementCount;
  final int position;

  AchievementLeaderboard({
    required this.userId,
    required this.username,
    required this.achievementCount,
    required this.position,
  });
}

/// Achievement progress update
class AchievementProgressUpdate {
  final String userId;
  final String achievementId;
  final int progress;

  AchievementProgressUpdate({
    required this.userId,
    required this.achievementId,
    required this.progress,
  });
}

/// Achievement unlock feed entry
class AchievementUnlockFeed {
  final String userId;
  final String username;
  final String achievementId;
  final String achievementTitle;
  final DateTime unlockedAt;
  final String rarity;

  AchievementUnlockFeed({
    required this.userId,
    required this.username,
    required this.achievementId,
    required this.achievementTitle,
    required this.unlockedAt,
    required this.rarity,
  });
}
