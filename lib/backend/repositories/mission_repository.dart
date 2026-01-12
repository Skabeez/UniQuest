import 'dart:convert';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/auth/supabase_auth/auth_util.dart';
import 'package:uni_quest/backend/services/cache_manager.dart';
import 'package:uni_quest/backend/services/connectivity_manager.dart';
import '../core/result.dart';
import 'base_repository.dart';

/// Repository for User Missions following Repository Pattern
/// Demonstrates:
/// - Single Responsibility Principle (only handles mission data)
/// - Dependency Inversion (depends on abstractions)
/// - Separation of Concerns (UI doesn't know about Supabase)
/// - Offline-First Architecture (cache + network)
class MissionRepository extends SupabaseRepository<UserMissionsRow> {
  static final MissionRepository _instance = MissionRepository._internal();

  factory MissionRepository() => _instance;

  MissionRepository._internal();

  final CacheManager _cache = CacheManager();
  final ConnectivityManager _connectivity = ConnectivityManager();

  @override
  SupabaseTable<UserMissionsRow> get table => UserMissionsTable();

  @override
  Future<Result<List<UserMissionsRow>>> getAll() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        ));
  }

  /// Get active (non-completed, non-archived) missions for current user
  /// Uses cache-first strategy for offline support
  Future<Result<List<UserMissionsRow>>> getActiveMissions() async {
    final cacheKey = CacheKeys.userMissions(currentUserUid);

    // Try network first if online
    if (_connectivity.isOnline) {
      try {
        final result = await executeQuery(() => table.queryRows(
              queryFn: (q) => q
                  .eqOrNull('completed', false)
                  .eqOrNull('is_archived', false)
                  .eqOrNull('user_id', currentUserUid),
            ));

        if (result.isSuccess) {
          // Cache successful network response
          final jsonData = result.data!
              .map((mission) => mission.data)
              .toList();
          await _cache.save(
            cacheKey,
            jsonEncode(jsonData),
            expiration: const Duration(hours: 24),
          );
        }

        return result;
      } catch (e) {
        // Network failed, fall back to cache
        print('Network request failed, trying cache: $e');
      }
    }

    // Use cache if offline or network failed
    return await getCached();
  }

  /// Get completed missions for current user
  Future<Result<List<UserMissionsRow>>> getCompletedMissions() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q
              .eqOrNull('completed', true)
              .eqOrNull('user_id', currentUserUid),
        ));
  }

  /// Get archived missions for current user
  Future<Result<List<UserMissionsRow>>> getArchivedMissions() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q
              .eqOrNull('is_archived', true)
              .eqOrNull('user_id', currentUserUid),
        ));
  }

  @override
  Future<Result<UserMissionsRow>> getById(String id) async {
    return executeSingleQuery(() async {
      final results = await table.querySingleRow(
        queryFn: (q) => q.eq('id', id),
      );
      if (results.isEmpty) {
        throw Exception('Mission not found');
      }
      return results.first;
    });
  }

  @override
  Future<Result<UserMissionsRow>> create(Map<String, dynamic> data) async {
    return executeSingleQuery(() => table.insert(data));
  }

  @override
  Future<Result<UserMissionsRow>> update(
      String id, Map<String, dynamic> data) async {
    return executeSingleQuery(() async {
      final results = await table.update(
        data: data,
        matchingRows: (q) => q.eq('id', id),
        returnRows: true,
      );
      if (results.isEmpty) {
        throw Exception('Mission not found');
      }
      return results.first;
    });
  }

  /// Update mission progress
  Future<Result<UserMissionsRow>> updateProgress(
      String id, int progress) async {
    return update(id, {'progress': progress, 'updated_at': DateTime.now().toIso8601String()});
  }

  /// Mark mission as completed
  Future<Result<UserMissionsRow>> completeMission(String id) async {
    return update(id, {'completed': true, 'updated_at': DateTime.now().toIso8601String()});
  }

  /// Archive mission
  Future<Result<UserMissionsRow>> archiveMission(String id) async {
    return update(id, {'is_archived': true, 'updated_at': DateTime.now().toIso8601String()});
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

  // Offline support methods
  @override
  Future<bool> hasCachedData() async {
    final cacheKey = CacheKeys.userMissions(currentUserUid);
    return await _cache.has(cacheKey);
  }

  @override
  Future<Result<List<UserMissionsRow>>> getCached() async {
    try {
      final cacheKey = CacheKeys.userMissions(currentUserUid);
      final cachedJson = await _cache.get<String>(cacheKey);

      if (cachedJson == null) {
        return const Failure('No cached data available');
      }

      final List<dynamic> jsonList = jsonDecode(cachedJson);
      final missions = jsonList
          .map((json) => UserMissionsRow(json as Map<String, dynamic>))
          .toList();

      return Success(missions);
    } catch (e) {
      return Failure('Error loading cached data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    final cacheKey = CacheKeys.userMissions(currentUserUid);
    await _cache.delete(cacheKey);
  }
}
