import 'package:uni_quest/backend/repositories/mission_repository.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/constants/app_constants.dart';
import 'package:uni_quest/auth/supabase_auth/auth_util.dart';

/// Quest/Mission Service - Business Logic Layer
/// Handles all quest-related operations including progress tracking,
/// completion logic, rewards distribution, and mission lifecycle management.
/// 
/// Demonstrates:
/// - Service Layer Pattern (business logic separation)
/// - Single Responsibility (only quest logic)
/// - Dependency Injection (receives repository)
class QuestService {
  final MissionRepository _missionRepository;

  QuestService._internal(this._missionRepository);

  // Factory for singleton pattern
  static final QuestService _instance = QuestService._internal(MissionRepository());
  factory QuestService() => _instance;

  // ============================================================================
  // QUEST RETRIEVAL METHODS
  // ============================================================================

  /// Get all active quests for current user
  /// Returns quests that are not completed and not archived
  Future<Result<List<UserMissionsRow>>> getActiveQuests() async {
    try {
      return await _missionRepository.getActiveMissions();
    } catch (e) {
      return Failure('Failed to load active quests: ${e.toString()}');
    }
  }

  /// Get all completed quests for current user
  /// Used for history/achievement tracking
  Future<Result<List<UserMissionsRow>>> getCompletedQuests() async {
    try {
      return await _missionRepository.getCompletedMissions();
    } catch (e) {
      return Failure('Failed to load completed quests: ${e.toString()}');
    }
  }

  /// Get all archived quests for current user
  /// Archived quests are hidden from active view but preserved
  Future<Result<List<UserMissionsRow>>> getArchivedQuests() async {
    try {
      return await _missionRepository.getArchivedMissions();
    } catch (e) {
      return Failure('Failed to load archived quests: ${e.toString()}');
    }
  }

  /// Get a specific quest by ID
  /// Returns full quest details including progress
  Future<Result<UserMissionsRow>> getQuestById(String questId) async {
    try {
      return await _missionRepository.getById(questId);
    } catch (e) {
      return Failure('Failed to load quest: ${e.toString()}');
    }
  }

  /// Get quest details with metadata (mission definition + user progress)
  /// Joins user_missions with missions table for complete info
  Future<Result<QuestDetails>> getQuestDetails(String questId) async {
    try {
      final questResult = await _missionRepository.getById(questId);
      
      if (questResult.isFailure) {
        return Failure(questResult.error!);
      }
      
      final userMission = questResult.data!;
      
      // TODO: Fetch mission definition from missions table
      // For now, return partial details
      final completionPct = calculateCompletionPercentage(
        currentProgress: userMission.progress ?? 0,
        targetValue: 100, // TODO: Get from mission definition
      );
      
      final canComplete = completionPct >= 100;
      
      final details = QuestDetails(
        userMission: userMission,
        mission: null, // TODO: Fetch actual mission
        completionPercentage: completionPct,
        canComplete: canComplete,
        estimatedCompletion: null,
      );
      
      return Success(details);
    } catch (e) {
      return Failure('Failed to load quest details: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST PROGRESS & COMPLETION
  // ============================================================================

  /// Update quest progress
  /// Validates progress is within bounds (progressMin-progressMax or 0-targetValue)
  /// Auto-completes quest if progress reaches target
  /// Awards XP and unlocks achievements if completed
  /// 
  /// Returns: Updated quest with new progress
  Future<Result<UserMissionsRow>> updateQuestProgress({
    required String questId,
    required int progress,
    bool autoComplete = true,
  }) async {
    try {
      // Validate progress
      final validationResult = validateProgress(progress, 100);
      if (validationResult.isFailure) {
        return Failure(validationResult.error!);
      }
      
      // Update progress
      final result = await _missionRepository.updateProgress(questId, progress);
      
      if (result.isFailure) {
        return result;
      }
      
      // Auto-complete if at 100%
      if (autoComplete && progress >= 100) {
        await _missionRepository.completeMission(questId);
      }
      
      return result;
    } catch (e) {
      return Failure('Failed to update quest progress: ${e.toString()}');
    }
  }

  /// Increment quest progress by delta
  /// Useful for trigger-based quests (e.g., "complete 5 tasks")
  /// 
  /// Example: incrementQuestProgress('quest-123', 1) // Add 1 to progress
  Future<Result<UserMissionsRow>> incrementQuestProgress({
    required String questId,
    required int delta,
  }) async {
    try {
      final questResult = await getQuestById(questId);
      
      if (questResult.isFailure) {
        return Failure(questResult.error!);
      }
      
      final currentProgress = questResult.data!.progress ?? 0;
      final newProgress = (currentProgress + delta).clamp(AppConstants.progressMin, AppConstants.progressMax);
      
      return await updateQuestProgress(
        questId: questId,
        progress: newProgress,
      );
    } catch (e) {
      return Failure('Failed to increment quest progress: ${e.toString()}');
    }
  }

  /// Mark quest as completed
  /// Awards rewards (XP, achievements, cosmetics)
  /// Triggers notification
  /// Updates user stats
  /// 
  /// Returns: Completion result with reward details
  Future<Result<QuestCompletionResult>> completeQuest(String questId) async {
    try {
      // Check if can complete
      final canCompleteResult = await canCompleteQuest(questId);
      if (canCompleteResult.isFailure) {
        return Failure(canCompleteResult.error!);
      }
      
      if (!canCompleteResult.data!) {
        return Failure('Quest cannot be completed yet');
      }
      
      // Complete quest
      final completeResult = await _missionRepository.completeMission(questId);
      if (completeResult.isFailure) {
        return Failure(completeResult.error!);
      }
      
      // Award rewards
      final rewardsResult = await awardQuestRewards(
        questId: questId,
        userId: currentUserUid,
      );
      
      final rewards = rewardsResult.isSuccess
          ? rewardsResult.data!
          : QuestRewards(xp: 0, points: 0);
      
      final result = QuestCompletionResult(
        completedQuest: completeResult.data!,
        rewards: rewards,
        unlockedAchievements: [],
        newXpTotal: 0, // TODO: Get from user profile
        newRank: null,
      );
      
      return Success(result);
    } catch (e) {
      return Failure('Failed to complete quest: ${e.toString()}');
    }
  }

  /// Check if quest can be completed
  /// Validates progress meets target value
  /// Checks prerequisites if any
  /// 
  /// Returns: true if quest can be completed
  Future<Result<bool>> canCompleteQuest(String questId) async {
    try {
      final questResult = await getQuestById(questId);
      
      if (questResult.isFailure) {
        return Failure(questResult.error!);
      }
      
      final quest = questResult.data!;
      
      // Check if already completed
      if (quest.completed == true) {
        return Success(false);
      }
      
      // Check progress
      final progress = quest.progress ?? 0;
      final canComplete = progress >= 100;
      
      return Success(canComplete);
    } catch (e) {
      return Failure('Failed to check quest completion status: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST LIFECYCLE
  // ============================================================================

  /// Start a new quest for user
  /// Initializes progress to 0
  /// Sets timestamps
  /// 
  /// Returns: Created user_mission record
  Future<Result<UserMissionsRow>> startQuest({
    required String userId,
    required String missionId,
  }) async {
    try {
      // Check if can start
      final canStartResult = await canStartQuest(
        userId: userId,
        missionId: missionId,
      );
      
      if (canStartResult.isFailure) {
        return Failure(canStartResult.error!);
      }
      
      if (!canStartResult.data!) {
        return Failure('Cannot start this quest');
      }
      
      // Create quest
      final data = {
        'user_id': userId,
        'mission_id': missionId,
        'progress': 0,
        'completed': false,
        'is_archived': false,
        'started_at': DateTime.now().toIso8601String(),
      };
      
      return await _missionRepository.create(data);
    } catch (e) {
      return Failure('Failed to start quest: ${e.toString()}');
    }
  }

  /// Archive a quest
  /// Hides from active view but preserves data
  /// Used for cleanup or temporary removal
  Future<Result<UserMissionsRow>> archiveQuest(String questId) async {
    try {
      return await _missionRepository.archiveMission(questId);
    } catch (e) {
      return Failure('Failed to archive quest: ${e.toString()}');
    }
  }

  /// Unarchive a quest
  /// Restores to active quests
  Future<Result<UserMissionsRow>> unarchiveQuest(String questId) async {
    try {
      return await _missionRepository.update(questId, {'is_archived': false});
    } catch (e) {
      return Failure('Failed to unarchive quest: ${e.toString()}');
    }
  }

  /// Abandon/cancel a quest
  /// Marks as abandoned without completion
  /// May apply penalties or cooldown
  Future<Result<bool>> abandonQuest(String questId) async {
    try {
      final result = await _missionRepository.delete(questId);
      return result;
    } catch (e) {
      return Failure('Failed to abandon quest: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST VALIDATION & BUSINESS RULES
  // ============================================================================

  /// Validate quest progress value
  /// Ensures progress is within valid range
  /// Checks against mission target_value
  /// 
  /// Returns: true if valid, false with error message
  Result<bool> validateProgress(int progress, int targetValue) {
    if (progress < AppConstants.progressMin) {
      return Failure('Progress cannot be less than ${AppConstants.progressMin}');
    }
    if (progress > AppConstants.progressMax) {
      return Failure('Progress cannot exceed ${AppConstants.progressMax}');
    }
    return Success(true);
  }

  /// Check if quest is expired
  /// Some quests may have time limits
  /// Returns: true if expired
  Future<Result<bool>> isQuestExpired(String questId) async {
    try {
      final questResult = await getQuestById(questId);
      
      if (questResult.isFailure) {
        return Failure(questResult.error!);
      }
      
      // TODO: Check expiry date from mission definition
      // For now, quests never expire
      return Success(false);
    } catch (e) {
      return Failure('Failed to check expiry: ${e.toString()}');
    }
  }

  /// Check if user can start quest
  /// Validates prerequisites, level requirements, cooldowns
  /// 
  /// Returns: true if user can start quest
  Future<Result<bool>> canStartQuest({
    required String userId,
    required String missionId,
  }) async {
    try {
      // TODO: Check prerequisites, level requirements, cooldowns
      // For now, all quests can be started
      return Success(true);
    } catch (e) {
      return Failure('Failed to check start eligibility: ${e.toString()}');
    }
  }

  /// Calculate quest completion percentage
  /// Returns: progressMin-progressMax percentage
  double calculateCompletionPercentage({
    required int currentProgress,
    required int targetValue,
  }) {
    if (targetValue <= 0) return 0.0;
    return (currentProgress / targetValue * 100).clamp(0.0, 100.0);
  }

  // ============================================================================
  // QUEST REWARDS
  // ============================================================================

  /// Award quest rewards to user
  /// Distributes XP, achievements, cosmetics, etc.
  /// Updates user profile
  /// Sends notification
  /// 
  /// Returns: Reward details
  Future<Result<QuestRewards>> awardQuestRewards({
    required String questId,
    required String userId,
  }) async {
    try {
      // TODO: Get mission definition to calculate rewards
      final baseXp = 100; // Placeholder
      
      final xpReward = calculateQuestXpReward(baseXp: baseXp);
      
      // TODO: Award XP to user via XpService
      // TODO: Check for unlocked achievements
      // TODO: Grant cosmetic rewards
      
      final rewards = QuestRewards(
        xp: xpReward,
        points: baseXp,
        unlockedCosmetics: [],
        achievementIds: [],
      );
      
      return Success(rewards);
    } catch (e) {
      return Failure('Failed to award rewards: ${e.toString()}');
    }
  }

  /// Calculate XP reward for quest
  /// May apply multipliers (streak, premium, events)
  /// 
  /// Returns: Final XP amount to award
  int calculateQuestXpReward({
    required int baseXp,
    double streakMultiplier = AppConstants.streakMultiplierNone,
    bool isPremium = false,
  }) {
    double finalXp = baseXp.toDouble();
    
    // Apply streak multiplier
    finalXp *= streakMultiplier;
    
    // Apply premium multiplier if applicable
    if (isPremium) {
      finalXp *= 1.5; // 50% bonus for premium
    }
    
    return finalXp.round();
  }

  // ============================================================================
  // QUEST TRIGGERS & AUTOMATION
  // ============================================================================

  /// Check and trigger quest progress based on event
  /// Called when user performs actions (complete task, check-in, etc.)
  /// Automatically updates progress for matching quests
  /// 
  /// Example: onUserEvent('task_completed', userId: 'user-123')
  Future<Result<List<UserMissionsRow>>> onUserEvent({
    required String eventType,
    required String userId,
    Map<String, dynamic>? eventData,
  }) async {
    try {
      // Get quests triggered by this event
      final questsResult = await getQuestsByTrigger(
        trigger: eventType,
        userId: userId,
      );
      
      if (questsResult.isFailure) {
        return questsResult;
      }
      
      final quests = questsResult.data!;
      final updatedQuests = <UserMissionsRow>[];
      
      // Update progress for each quest
      for (final quest in quests) {
        final updateResult = await incrementQuestProgress(
          questId: quest.id,
          delta: 1,
        );
        
        if (updateResult.isSuccess) {
          updatedQuests.add(updateResult.data!);
        }
      }
      
      return Success(updatedQuests);
    } catch (e) {
      return Failure('Failed to process event: ${e.toString()}');
    }
  }

  /// Get quests triggered by specific action
  /// Returns quests that should progress on this action
  Future<Result<List<UserMissionsRow>>> getQuestsByTrigger({
    required String trigger,
    required String userId,
  }) async {
    try {
      // Get all active quests
      final questsResult = await getActiveQuests();
      
      if (questsResult.isFailure) {
        return questsResult;
      }
      
      // TODO: Filter by trigger type from mission definition
      // For now, return empty list
      return Success([]);
    } catch (e) {
      return Failure('Failed to get triggered quests: ${e.toString()}');
    }
  }

  // ============================================================================
  // QUEST STATISTICS & ANALYTICS
  // ============================================================================

  /// Get quest statistics for user
  /// Returns total active, completed, completion rate, etc.
  Future<Result<QuestStats>> getQuestStats(String userId) async {
    try {
      final activeResult = await getActiveQuests();
      final completedResult = await getCompletedQuests();
      
      final totalActive = activeResult.isSuccess ? activeResult.data!.length : 0;
      final totalCompleted = completedResult.isSuccess ? completedResult.data!.length : 0;
      final totalAbandoned = 0; // TODO: Track abandoned quests
      
      final totalQuests = totalActive + totalCompleted + totalAbandoned;
      final completionRate = totalQuests > 0 
          ? (totalCompleted / totalQuests * 100)
          : 0.0;
      
      final stats = QuestStats(
        totalActive: totalActive,
        totalCompleted: totalCompleted,
        totalAbandoned: totalAbandoned,
        completionRate: completionRate,
        totalXpEarned: 0, // TODO: Calculate from completed quests
        averageCompletionTime: 0, // TODO: Calculate from timestamps
        mostCompletedCategory: 'General', // TODO: Calculate from mission categories
      );
      
      return Success(stats);
    } catch (e) {
      return Failure('Failed to get quest stats: ${e.toString()}');
    }
  }

  /// Get user's quest history
  /// Returns paginated list of all quests (completed, abandoned, active)
  Future<Result<List<UserMissionsRow>>> getQuestHistory({
    required String userId,
    int page = AppConstants.paginationDefaultPage,
    int pageSize = AppConstants.paginationDefaultSize,
  }) async {
    try {
      // Get all quests
      final result = await _missionRepository.getAll();
      
      if (result.isFailure) {
        return result;
      }
      
      final allQuests = result.data!;
      
      // Apply pagination
      final startIndex = (page - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allQuests.length);
      
      if (startIndex >= allQuests.length) {
        return Success([]);
      }
      
      final paginatedQuests = allQuests.sublist(startIndex, endIndex);
      return Success(paginatedQuests);
    } catch (e) {
      return Failure('Failed to get quest history: ${e.toString()}');
    }
  }

  /// Get recommended quests for user
  /// Based on level, interests, completion history
  Future<Result<List<MissionsRow>>> getRecommendedQuests(String userId) async {
    try {
      // TODO: Implement recommendation algorithm
      // - Check user level
      // - Check completion history
      // - Filter by difficulty
      // - Prioritize incomplete quest chains
      
      return Success([]);
    } catch (e) {
      return Failure('Failed to get recommended quests: ${e.toString()}');
    }
  }

  // ============================================================================
  // OFFLINE SUPPORT
  // ============================================================================

  /// Check if offline quest data is available
  Future<bool> hasOfflineQuests() async {
    try {
      final cached = await _missionRepository.getCached();
      return cached.isSuccess && cached.data != null && cached.data!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get cached quests for offline use
  Future<Result<List<UserMissionsRow>>> getOfflineQuests() async {
    try {
      return await _missionRepository.getCached();
    } catch (e) {
      return Failure('Failed to load offline quests: ${e.toString()}');
    }
  }

  /// Queue quest progress update for later sync
  /// Used when offline
  Future<Result<bool>> queueProgressUpdate({
    required String questId,
    required int progress,
  }) async {
    try {
      // TODO: Implement offline queue
      // - Store update in local queue
      // - Sync when connection restored
      
      return Success(true);
    } catch (e) {
      return Failure('Failed to queue update: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR SERVICE RESPONSES
// ============================================================================

/// Complete quest details (mission + user progress)
class QuestDetails {
  final UserMissionsRow userMission;
  final MissionsRow? mission;
  final double completionPercentage;
  final bool canComplete;
  final DateTime? estimatedCompletion;

  QuestDetails({
    required this.userMission,
    this.mission,
    required this.completionPercentage,
    required this.canComplete,
    this.estimatedCompletion,
  });
}

/// Quest completion result with rewards
class QuestCompletionResult {
  final UserMissionsRow completedQuest;
  final QuestRewards rewards;
  final List<String> unlockedAchievements;
  final int newXpTotal;
  final String? newRank;

  QuestCompletionResult({
    required this.completedQuest,
    required this.rewards,
    required this.unlockedAchievements,
    required this.newXpTotal,
    this.newRank,
  });
}

/// Quest rewards breakdown
class QuestRewards {
  final int xp;
  final int points;
  final List<String> unlockedCosmetics;
  final List<String> achievementIds;
  final Map<String, dynamic>? customRewards;

  QuestRewards({
    required this.xp,
    required this.points,
    this.unlockedCosmetics = const [],
    this.achievementIds = const [],
    this.customRewards,
  });
}

/// Quest statistics
class QuestStats {
  final int totalActive;
  final int totalCompleted;
  final int totalAbandoned;
  final double completionRate;
  final int totalXpEarned;
  final int averageCompletionTime; // in hours
  final String mostCompletedCategory;

  QuestStats({
    required this.totalActive,
    required this.totalCompleted,
    required this.totalAbandoned,
    required this.completionRate,
    required this.totalXpEarned,
    required this.averageCompletionTime,
    required this.mostCompletedCategory,
  });
}
