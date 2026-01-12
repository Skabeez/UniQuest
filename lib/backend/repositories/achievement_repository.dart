import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/auth/supabase_auth/auth_util.dart';
import '../core/result.dart';
import 'base_repository.dart';

/// Repository for User Achievements
class AchievementRepository extends SupabaseRepository<UserAchievementsRow> {
  static final AchievementRepository _instance = AchievementRepository._internal();

  factory AchievementRepository() => _instance;

  AchievementRepository._internal();

  @override
  SupabaseTable<UserAchievementsRow> get table => UserAchievementsTable();

  @override
  Future<Result<List<UserAchievementsRow>>> getAll() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        ));
  }

  /// Get unlocked achievements for current user
  Future<Result<List<UserAchievementsRow>>> getUnlockedAchievements() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q
              .eqOrNull('unlocked', true)
              .eqOrNull('user_id', currentUserUid)
              .order('unlocked_at', ascending: false),
        ));
  }

  /// Get locked (not yet unlocked) achievements for current user
  Future<Result<List<UserAchievementsRow>>> getLockedAchievements() async {
    return executeQuery(() => table.queryRows(
          queryFn: (q) => q
              .eqOrNull('unlocked', false)
              .eqOrNull('user_id', currentUserUid),
        ));
  }

  @override
  Future<Result<UserAchievementsRow>> getById(String id) async {
    return executeSingleQuery(() async {
      final results = await table.querySingleRow(
        queryFn: (q) => q.eq('id', id),
      );
      if (results.isEmpty) {
        throw Exception('Achievement not found');
      }
      return results.first;
    });
  }

  @override
  Future<Result<UserAchievementsRow>> create(
      Map<String, dynamic> data) async {
    return executeSingleQuery(() => table.insert(data));
  }

  @override
  Future<Result<UserAchievementsRow>> update(
      String id, Map<String, dynamic> data) async {
    return executeSingleQuery(() async {
      final results = await table.update(
        data: data,
        matchingRows: (q) => q.eq('id', id),
        returnRows: true,
      );
      if (results.isEmpty) {
        throw Exception('Achievement not found');
      }
      return results.first;
    });
  }

  /// Unlock an achievement
  Future<Result<UserAchievementsRow>> unlockAchievement(String id) async {
    return update(id, {
      'unlocked': true,
      'unlocked_at': DateTime.now().toIso8601String(),
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
    return false;
  }

  @override
  Future<Result<List<UserAchievementsRow>>> getCached() async {
    return const Failure('Cache not implemented yet');
  }

  @override
  Future<void> clearCache() async {}
}
