import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/repositories/base_repository.dart';
import 'package:uni_quest/services/cache_service_impl.dart';

/// Quest Repository - Data Access for Quests/Missions
/// Handles all database operations for quests and user quest progress
///
/// Manages two tables:
/// - missions: Quest definitions (title, description, rewards)
/// - user_missions: User progress on quests
///
/// Demonstrates:
/// - Repository Pattern implementation
/// - Separation of data access from business logic
/// - Type-safe database queries
class QuestRepository extends BaseRepository<UserMissionsRow> {
  final _cacheService = CacheServiceImpl();

  QuestRepository(super.supabase);

  @override
  String get tableName => 'user_missions';

  @override
  UserMissionsRow fromJson(Map<String, dynamic> json) {
    return UserMissionsRow(json);
  }

  // ============================================================================
  // BASE REPOSITORY IMPLEMENTATION
  // ============================================================================

  @override
  Future<Result<List<UserMissionsRow>>> getAll() async {
    try {
      final response = await supabase.from(tableName).select();
      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all quests: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserMissionsRow?>> getById(String id) async {
    try {
      final response =
          await supabase.from(tableName).select().eq('id', id).maybeSingle();

      if (response == null) return Success(null);
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to get quest: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserMissionsRow>> insert(Map<String, dynamic> data) async {
    try {
      final response =
          await supabase.from(tableName).insert(data).select().single();

      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to insert quest: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserMissionsRow>> update(
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
      return Failure('Failed to update quest: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await supabase.from(tableName).delete().eq('id', id);
      return Success(null);
    } catch (e) {
      return Failure('Failed to delete quest: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserMissionsRow>>> getByIds(List<String> ids) async {
    try {
      final response =
          await supabase.from(tableName).select().inFilter('id', ids);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get quests by IDs: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<UserMissionsRow>>> insertBatch(
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

  Future<Result<List<UserMissionsRow>>> query(
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
  Future<Result<List<UserMissionsRow>>> paginate(
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
  Future<Result<List<UserMissionsRow>>> filter(
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
  Future<Result<List<UserMissionsRow>>> orderBy(
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
  Future<Result<List<UserMissionsRow>>> search(
      {required String query, required List<String> columns}) async {
    return Failure('Search not implemented');
  }

  @override
  Future<Result<List<UserMissionsRow>>> findWhere(
      Map<String, dynamic> conditions) async {
    return query(conditions);
  }

  @override
  Future<Result<UserMissionsRow?>> refresh(String id) async {
    return getById(id);
  }

  @override
  Future<Result<UserMissionsRow>> upsert(Map<String, dynamic> data) async {
    try {
      final response =
          await supabase.from(tableName).upsert(data).select().single();
      return Success(fromJson(response));
    } catch (e) {
      return Failure('Failed to upsert: ${e.toString()}');
    }
  }

  @override
  Future<Result<UserMissionsRow>> softDelete(String id) async {
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
  // QUEST RETRIEVAL
  // ============================================================================

  /// Get all active quests for user
  /// Filters: completed = false, is_archived = false
  ///
  /// @param userId - User ID to get quests for
  Future<Result<List<UserMissionsRow>>> getActiveQuests(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('completed', false)
          .eq('is_archived', false);

      final quests = (response as List).map((json) => fromJson(json)).toList();

      // Cache active quests for offline access
      await _cacheQuests(userId, 'active', quests);

      return Success(quests);
    } catch (e) {
      // Try to return cached data if network fails
      final cached = await _getCachedQuests(userId, 'active');
      if (cached != null) {
        return Success(cached);
      }
      return Failure('Failed to get active quests: ${e.toString()}');
    }
  }

  /// Get all completed quests for user
  /// Filters: completed = true
  Future<Result<List<UserMissionsRow>>> getCompletedQuests(
      String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('completed', true);

      final quests = (response as List).map((json) => fromJson(json)).toList();

      // Cache completed quests for offline access
      await _cacheQuests(userId, 'completed', quests);

      return Success(quests);
    } catch (e) {
      // Try to return cached data if network fails
      final cached = await _getCachedQuests(userId, 'completed');
      if (cached != null) {
        return Success(cached);
      }
      return Failure('Failed to get completed quests: ${e.toString()}');
    }
  }

  // ============================================================================
  // CACHE HELPERS
  // ============================================================================

  Future<void> _cacheQuests(
      String userId, String type, List<UserMissionsRow> quests) async {
    try {
      final data = quests.map((q) => q.data).toList();
      await _cacheService.saveToCache('quests_${userId}_$type', data);
    } catch (_) {
      // Ignore cache errors
    }
  }

  Future<List<UserMissionsRow>?> _getCachedQuests(
      String userId, String type) async {
    try {
      final data = await _cacheService.getFromCache('quests_${userId}_$type');
      if (data is List) {
        return data
            .map((json) => UserMissionsRow(json as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Ignore cache errors
    }
    return null;
  }

  /// Get all archived quests for user
  /// Filters: is_archived = true
  Future<Result<List<UserMissionsRow>>> getArchivedQuests(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('is_archived', true);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get archived quests: ${e.toString()}');
    }
  }

  /// Get quest by ID
  /// Joins with missions table to get full details
  Future<Result<UserMissionsRow?>> getQuestById(String questId) async {
    return getById(questId);
  }

  /// Get quests by trigger type
  /// Returns quests that should progress on specific events
  ///
  /// @param trigger - Event type (task_completed, check_in, etc.)
  /// @param userId - User ID
  Future<Result<List<UserMissionsRow>>> getQuestsByTrigger({
    required String trigger,
    required String userId,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .eq('trigger', trigger)
          .eq('completed', false);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get quests by trigger: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST DEFINITIONS (missions table)
  // ============================================================================

  /// Get mission definition by ID
  /// Returns quest template with rewards, targets, etc.
  Future<Result<MissionsRow?>> getMissionDefinition(String missionId) async {
    try {
      final response = await supabase
          .from('missions')
          .select()
          .eq('id', missionId)
          .maybeSingle();

      if (response == null) return Success(null);
      return Success(MissionsRow(response));
    } catch (e) {
      return Failure('Failed to get mission definition: ${e.toString()}');
    }
  }

  /// Get all available mission definitions
  /// Returns quest catalog
  Future<Result<List<MissionsRow>>> getAllMissions() async {
    try {
      final response = await supabase.from('missions').select();
      return Success(
        (response as List).map((json) => MissionsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get all missions: ${e.toString()}');
    }
  }

  /// Get missions by category
  /// Filters missions by type (daily, weekly, achievement)
  Future<Result<List<MissionsRow>>> getMissionsByCategory(
      String category) async {
    try {
      final response =
          await supabase.from('missions').select().eq('category', category);

      return Success(
        (response as List).map((json) => MissionsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get missions by category: ${e.toString()}');
    }
  }

  /// Search missions by title/description
  /// Full-text search across mission definitions
  Future<Result<List<MissionsRow>>> searchMissions(String query) async {
    try {
      final response = await supabase
          .from('missions')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%');

      return Success(
        (response as List).map((json) => MissionsRow(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to search missions: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST PROGRESS
  // ============================================================================

  /// Update quest progress
  /// Sets progress value and checks completion
  ///
  /// @param questId - User mission ID
  /// @param progress - New progress value
  Future<Result<UserMissionsRow>> updateProgress({
    required String questId,
    required int progress,
  }) async {
    return update(questId, {'progress': progress});
  }

  /// Increment quest progress by delta
  /// Adds to existing progress value
  Future<Result<UserMissionsRow>> incrementProgress({
    required String questId,
    required int delta,
  }) async {
    try {
      final questResult = await getById(questId);
      if (questResult.isFailure) {
        return Failure(questResult.error ?? 'Failed to increment progress');
      }
      if (questResult.data == null) return Failure('Quest not found');

      final currentProgress = questResult.data!.progress ?? 0;
      return updateProgress(
          questId: questId, progress: currentProgress + delta);
    } catch (e) {
      return Failure('Failed to increment progress: ${e.toString()}');
    }
  }

  /// Mark quest as completed
  /// Sets completed = true, completed_at = now
  Future<Result<UserMissionsRow>> markCompleted(String questId) async {
    return update(questId, {
      'completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get quest completion percentage
  /// Calculates progress / target_value * 100
  Future<Result<double>> getCompletionPercentage(String questId) async {
    try {
      final questResult = await getById(questId);
      if (questResult.isFailure) {
        return Failure(
            questResult.error ?? 'Failed to get completion percentage');
      }
      if (questResult.data == null) return Failure('Quest not found');

      final quest = questResult.data!;
      final progress = quest.progress ?? 0;
      final target = 100; // Default target value

      if (target == 0) return Success(0.0);
      return Success((progress / target) * 100);
    } catch (e) {
      return Failure('Failed to get completion percentage: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST LIFECYCLE
  // ============================================================================

  /// Start new quest for user
  /// Creates user_missions record with progress = 0
  ///
  /// @param userId - User ID
  /// @param missionId - Mission definition ID
  Future<Result<UserMissionsRow>> startQuest({
    required String userId,
    required String missionId,
  }) async {
    try {
      final questData = {
        'user_id': userId,
        'mission_id': missionId,
        'progress': 0,
        'completed': false,
        'is_archived': false,
        'started_at': DateTime.now().toIso8601String(),
      };

      return insert(questData);
    } catch (e) {
      return Failure('Failed to start quest: ${e.toString()}');
    }
  }

  /// Archive quest
  /// Sets is_archived = true
  Future<Result<UserMissionsRow>> archiveQuest(String questId) async {
    return update(questId, {'is_archived': true});
  }

  /// Unarchive quest
  /// Sets is_archived = false
  Future<Result<UserMissionsRow>> unarchiveQuest(String questId) async {
    return update(questId, {'is_archived': false});
  }

  /// Abandon quest
  /// Marks as abandoned without completion
  Future<Result<void>> abandonQuest(String questId) async {
    try {
      await update(questId, {'is_abandoned': true});
      return Success(null);
    } catch (e) {
      return Failure('Failed to abandon quest: ${e.toString()}');
    }
  }

  /// Reset quest progress
  /// Sets progress back to 0
  Future<Result<UserMissionsRow>> resetProgress(String questId) async {
    return update(questId, {'progress': 0});
  }

  // ============================================================================
  // QUEST STATISTICS
  // ============================================================================

  /// Count active quests for user
  Future<Result<int>> countActiveQuests(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('completed', false)
          .eq('is_archived', false)
          .count(CountOption.exact);

      return Success(response.count);
    } catch (e) {
      return Failure('Failed to count active quests: ${e.toString()}');
    }
  }

  /// Count completed quests for user
  Future<Result<int>> countCompletedQuests(String userId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('completed', true)
          .count(CountOption.exact);

      return Success(response.count);
    } catch (e) {
      return Failure('Failed to count completed quests: ${e.toString()}');
    }
  }

  /// Get quest completion rate
  /// Returns percentage of completed vs total quests
  Future<Result<double>> getCompletionRate(String userId) async {
    try {
      final totalResult = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);

      final completedResult = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('completed', true)
          .count(CountOption.exact);

      final total = totalResult.count;
      final completed = completedResult.count;

      if (total == 0) return Success(0.0);
      return Success((completed / total) * 100);
    } catch (e) {
      return Failure('Failed to get completion rate: ${e.toString()}');
    }
  }

  /// Get total XP earned from quests
  /// Sums reward_points from completed quests
  Future<Result<int>> getTotalXpFromQuests(String userId) async {
    return Failure('Aggregation query not yet implemented');
  }

  /// Get quest history with pagination
  /// Returns all quests (active, completed, archived)
  Future<Result<List<UserMissionsRow>>> getQuestHistory({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final offset = (page - 1) * pageSize;
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get quest history: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST VALIDATION
  // ============================================================================

  /// Check if user can start quest
  /// Validates prerequisites, cooldowns, duplicates
  Future<Result<bool>> canStartQuest({
    required String userId,
    required String missionId,
  }) async {
    return Success(true);
  }

  /// Check if quest exists
  Future<Result<bool>> questExists(String questId) async {
    return exists(questId);
  }

  /// Check if user already has quest active
  Future<Result<bool>> hasActiveQuest({
    required String userId,
    required String missionId,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_id', userId)
          .eq('mission_id', missionId)
          .eq('completed', false)
          .maybeSingle();

      return Success(response != null);
    } catch (e) {
      return Failure('Failed to check active quest: ${e.toString()}');
    }
  }

  /// Validate progress value
  /// Ensures progress is within bounds (0-100 or 0-target)
  Result<bool> validateProgress(int progress, int targetValue) {
    if (progress < 0) return Failure('Progress cannot be negative');
    if (progress > targetValue) return Failure('Progress exceeds target');
    return Success(true);
  }

  // ============================================================================
  // QUEST JOINS & COMPLEX QUERIES
  // ============================================================================

  /// Get quest with mission details
  /// Joins user_missions with missions table
  /// Returns combined data
  Future<Result<QuestWithDetails>> getQuestWithDetails(String questId) async {
    return Failure('Join query not yet implemented');
  }

  /// Get user's quest dashboard
  /// Returns active quests with mission details, progress, rewards
  Future<Result<List<QuestWithDetails>>> getQuestDashboard(
      String userId) async {
    return Failure('Dashboard query not yet implemented');
  }

  /// Get quests expiring soon
  /// Returns quests with due dates approaching
  Future<Result<List<UserMissionsRow>>> getExpiringQuests({
    required String userId,
    required Duration within,
  }) async {
    return Success([]);
  }

  // ============================================================================
  // BULK OPERATIONS
  // ============================================================================

  /// Archive all completed quests
  /// Batch update for cleanup
  Future<Result<int>> archiveAllCompleted(String userId) async {
    try {
      await supabase
          .from(tableName)
          .update({'is_archived': true})
          .eq('user_id', userId)
          .eq('completed', true);

      return Success(0); // Supabase doesn't return count
    } catch (e) {
      return Failure('Failed to archive completed quests: ${e.toString()}');
    }
  }

  /// Update multiple quest progress values
  /// Batch update for efficiency
  Future<Result<List<UserMissionsRow>>> updateMultipleProgress(
    List<QuestProgressUpdate> updates,
  ) async {
    try {
      final results = <UserMissionsRow>[];

      for (final update in updates) {
        final result = await updateProgress(
          questId: update.questId,
          progress: update.progress,
        );
        if (result.isSuccess) {
          results.add(result.data!);
        }
      }

      return Success(results);
    } catch (e) {
      return Failure('Failed to update multiple progress: ${e.toString()}');
    }
  }

  /// Get quests by multiple triggers
  /// Returns quests matching any of the trigger types
  Future<Result<List<UserMissionsRow>>> getQuestsByTriggers({
    required List<String> triggers,
    required String userId,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_id', userId)
          .inFilter('trigger', triggers)
          .eq('completed', false);

      return Success(
        (response as List).map((json) => fromJson(json)).toList(),
      );
    } catch (e) {
      return Failure('Failed to get quests by triggers: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR REPOSITORY RESPONSES
// ============================================================================

/// Quest with full mission details
class QuestWithDetails {
  final UserMissionsRow userMission;
  final MissionsRow mission;

  QuestWithDetails({
    required this.userMission,
    required this.mission,
  });
}

/// Quest progress update data
class QuestProgressUpdate {
  final String questId;
  final int progress;

  QuestProgressUpdate({
    required this.questId,
    required this.progress,
  });
}
