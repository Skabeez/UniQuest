import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/auth/supabase_auth/auth_util.dart';
import 'package:uni_quest/services/cache_service_impl.dart';
import '../core/result.dart';
import 'base_repository.dart';

/// Repository for Tasks following Repository Pattern
class TaskRepository extends SupabaseRepository<TasksRow> {
  static final TaskRepository _instance = TaskRepository._internal();
  final _cacheService = CacheServiceImpl();

  factory TaskRepository() => _instance;

  TaskRepository._internal();

  @override
  SupabaseTable<TasksRow> get table => TasksTable();

  @override
  Future<Result<List<TasksRow>>> getAll() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        ));
  }

  /// Get active (non-completed, non-archived) tasks for current user
  Future<Result<List<TasksRow>>> getActiveTasks() async {
    try {
      final result = await executeQuery(() => table.queryRows(
            queryFn: (q) => q
                .eqOrNull('is_completed', false)
                .eqOrNull('is_archived', false)
                .eqOrNull('user_id', currentUserUid)
                .order('created_at', ascending: false),
          ));

      // Cache on success
      if (result.isSuccess && result.data != null) {
        await _cacheTasks(currentUserUid, 'active', result.data!);
      }

      return result;
    } catch (e) {
      // Return cached data on failure
      final cached = await _getCachedTasks(currentUserUid, 'active');
      if (cached != null) return Success(cached);
      return Failure('Failed to get active tasks: ${e.toString()}');
    }
  }

  /// Get completed tasks for current user
  Future<Result<List<TasksRow>>> getCompletedTasks() async {
    try {
      final result = await executeQuery(() => table.queryRows(
            queryFn: (q) => q
                .eqOrNull('is_completed', true)
                .eqOrNull('is_archived', false)
                .eqOrNull('user_id', currentUserUid)
                .order('updated_at', ascending: false),
          ));

      // Cache on success
      if (result.isSuccess && result.data != null) {
        await _cacheTasks(currentUserUid, 'completed', result.data!);
      }

      return result;
    } catch (e) {
      // Return cached data on failure
      final cached = await _getCachedTasks(currentUserUid, 'completed');
      if (cached != null) return Success(cached);
      return Failure('Failed to get completed tasks: ${e.toString()}');
    }
  }

  /// Get archived tasks for current user
  Future<Result<List<TasksRow>>> getArchivedTasks() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q
              .eqOrNull('is_archived', true)
              .eqOrNull('user_id', currentUserUid)
              .order('updated_at', ascending: false),
        ));
  }

  @override
  Future<Result<TasksRow>> getById(String id) async {
    return executeSingleQuery(() async {
      final results = await table.querySingleRow(
        queryFn: (q) => q.eq('id', id),
      );
      if (results.isEmpty) {
        throw Exception('Task not found');
      }
      return results.first;
    });
  }

  @override
  Future<Result<TasksRow>> create(Map<String, dynamic> data) async {
    return executeSingleQuery(() => table.insert(data));
  }

  @override
  Future<Result<TasksRow>> update(String id, Map<String, dynamic> data) async {
    return executeSingleQuery(() async {
      final results = await table.update(
        data: data,
        matchingRows: (q) => q.eq('id', id),
        returnRows: true,
      );
      if (results.isEmpty) {
        throw Exception('Task not found');
      }
      return results.first;
    });
  }

  /// Toggle task completion status
  Future<Result<TasksRow>> toggleComplete(String id, bool isCompleted) async {
    return update(id, {
      'is_completed': isCompleted,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Archive task
  Future<Result<TasksRow>> archiveTask(String id) async {
    return update(id, {
      'is_archived': true,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<Result<bool>> delete(String id) async {
    try {
      await table.delete(matchingRows: (q) => q.eq('id', id));
      return const Success(true);
    } catch (e) {
      return handleError(e);
    }
  }

  // Offline support methods (to be implemented with cache layer)
  @override
  Future<bool> hasCachedData() async {
    try {
      final cached =
          await _cacheService.getString('tasks_${currentUserUid}_active');
      return cached != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Result<List<TasksRow>>> getCached() async {
    final cached = await _getCachedTasks(currentUserUid, 'active');
    if (cached != null) return Success(cached);
    return const Failure('No cached tasks available');
  }

  @override
  Future<void> clearCache() async {
    try {
      await _cacheService.clearCacheKey('tasks_${currentUserUid}_active');
      await _cacheService.clearCacheKey('tasks_${currentUserUid}_completed');
      await _cacheService.clearCacheKey('tasks_${currentUserUid}_archived');
    } catch (_) {
      // Ignore cache errors
    }
  }

  // ============================================================================
  // CACHE HELPERS
  // ============================================================================

  Future<void> _cacheTasks(
      String userId, String type, List<TasksRow> tasks) async {
    try {
      final data = tasks.map((t) => t.data).toList();
      await _cacheService.saveToCache('tasks_${userId}_$type', data);
    } catch (_) {
      // Ignore cache errors
    }
  }

  Future<List<TasksRow>?> _getCachedTasks(String userId, String type) async {
    try {
      final data = await _cacheService.getFromCache('tasks_${userId}_$type');
      if (data is List) {
        return data
            .map((json) => TasksRow(json as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Ignore cache errors
    }
    return null;
  }
}
