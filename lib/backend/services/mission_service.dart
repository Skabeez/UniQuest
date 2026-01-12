import 'package:uni_quest/backend/repositories/mission_repository.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import '../core/result.dart';

/// Service layer for Mission business logic
/// Demonstrates:
/// - Facade Pattern (simplifies complex repository operations)
/// - Business Logic Layer (keeps business rules separate from UI)
/// - Single Responsibility (handles mission-related business logic)
class MissionService {
  final MissionRepository _repository;

  static final MissionService _instance = MissionService._internal(
    MissionRepository(),
  );

  factory MissionService() => _instance;

  MissionService._internal(this._repository);

  /// Get all active missions for the current user
  /// Returns missions that are not completed and not archived
  Future<Result<List<UserMissionsRow>>> getActiveMissions() async {
    return await _repository.getActiveMissions();
  }

  /// Get all completed missions
  Future<Result<List<UserMissionsRow>>> getCompletedMissions() async {
    return await _repository.getCompletedMissions();
  }

  /// Get all archived missions
  Future<Result<List<UserMissionsRow>>> getArchivedMissions() async {
    return await _repository.getArchivedMissions();
  }

  /// Get a specific mission by ID
  Future<Result<UserMissionsRow>> getMissionById(String id) async {
    return await _repository.getById(id);
  }

  /// Create a new mission
  Future<Result<UserMissionsRow>> createMission({
    required String userId,
    required String missionId,
    required String title,
    required String description,
  }) async {
    final data = {
      'user_id': userId,
      'mission_id': missionId,
      'mission_title': title,
      'mission_description': description,
      'progress': 0,
      'completed': false,
      'is_archived': false,
      'updated_at': DateTime.now().toIso8601String(),
    };

    return await _repository.create(data);
  }

  /// Update mission progress and auto-complete if progress reaches 100
  Future<Result<UserMissionsRow>> updateMissionProgress(
    String id,
    int progress,
  ) async {
    // Business logic: Validate progress range
    if (progress < 0 || progress > 100) {
      return const Failure('Progress must be between 0 and 100');
    }

    // Business logic: Auto-complete if progress is 100
    if (progress >= 100) {
      return await _repository.update(id, {
        'progress': 100,
        'completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }

    return await _repository.updateProgress(id, progress);
  }

  /// Mark mission as completed
  Future<Result<UserMissionsRow>> completeMission(String id) async {
    return await _repository.completeMission(id);
  }

  /// Archive a mission
  Future<Result<UserMissionsRow>> archiveMission(String id) async {
    return await _repository.archiveMission(id);
  }

  /// Delete a mission
  Future<Result<bool>> deleteMission(String id) async {
    return await _repository.delete(id);
  }

  /// Get mission statistics for the current user
  Future<Result<MissionStats>> getMissionStats() async {
    final activeResult = await _repository.getActiveMissions();
    final completedResult = await _repository.getCompletedMissions();

    if (activeResult.isFailure) {
      return Failure(activeResult.error!);
    }
    if (completedResult.isFailure) {
      return Failure(completedResult.error!);
    }

    final activeMissions = activeResult.data!;
    final completedMissions = completedResult.data!;

    final stats = MissionStats(
      totalActive: activeMissions.length,
      totalCompleted: completedMissions.length,
      completionRate: (completedMissions.length + activeMissions.length) > 0
          ? (completedMissions.length /
                  (completedMissions.length + activeMissions.length)) *
              100
          : 0.0,
    );

    return Success(stats);
  }

  /// Check if offline data is available
  Future<bool> hasOfflineData() async {
    return await _repository.hasCachedData();
  }

  /// Get cached missions for offline use
  Future<Result<List<UserMissionsRow>>> getOfflineMissions() async {
    return await _repository.getCached();
  }
}

/// Mission statistics model
class MissionStats {
  final int totalActive;
  final int totalCompleted;
  final double completionRate;

  MissionStats({
    required this.totalActive,
    required this.totalCompleted,
    required this.completionRate,
  });
}
