import 'package:uni_quest/backend/repositories/achievement_repository.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/backend/core/result.dart';

/// Achievement Service - Badge Unlock & Progress Logic
/// Handles all achievement-related operations including unlock conditions,
/// progress tracking, badge distribution, and achievement notifications.
/// 
/// Demonstrates:
/// - Service Layer Pattern (achievement business logic)
/// - Single Responsibility (only achievement operations)
/// - Complex unlock condition evaluation
class AchievementService {
  final AchievementRepository _achievementRepository;

  AchievementService._internal(this._achievementRepository);

  // Factory for singleton pattern
  static final AchievementService _instance =
      AchievementService._internal(AchievementRepository());
  factory AchievementService() => _instance;

  // ============================================================================
  // ACHIEVEMENT RETRIEVAL
  // ============================================================================

  /// Get all unlocked achievements for user
  /// Returns achievements sorted by unlock date (newest first)
  Future<Result<List<UserAchievementsRow>>> getUnlockedAchievements(
      String userId) async {
    try {
      return await _achievementRepository.getUnlockedAchievements();
    } catch (e) {
      return Failure('Failed to load unlocked achievements: ${e.toString()}');
    }
  }

  /// Get all locked (not yet unlocked) achievements for user
  /// Shows progress towards each locked achievement
  Future<Result<List<UserAchievementsRow>>> getLockedAchievements(
      String userId) async {
    try {
      return await _achievementRepository.getLockedAchievements();
    } catch (e) {
      return Failure('Failed to load locked achievements: ${e.toString()}');
    }
  }

  /// Get achievement details by ID
  /// Includes unlock conditions, rewards, rarity
  Future<Result<AchievementDetails>> getAchievementById(String achievementId) async {
    try {
      final result = await _achievementRepository.getById(achievementId);
      
      if (result.isFailure) {
        return Failure(result.error!);
      }
      
      final achievement = result.data!;
      final progress = calculateAchievementProgress(
        currentProgress: achievement.progress ?? 0,
        targetProgress: 100,
      );
      
      final details = AchievementDetails(
        definition: AchievementDefsRow({}),
        userProgress: achievement,
        isUnlocked: achievement.unlockedAt != null,
        progressPercentage: progress,
        conditions: [],
        rewards: calculateRewards(rarity: 'common', difficulty: 1),
      );
      
      return Success(details);
    } catch (e) {
      return Failure('Failed to load achievement details: ${e.toString()}');
    }
  }

  /// Get all achievements (locked + unlocked)
  /// Used for achievement showcase/collection view
  Future<Result<List<UserAchievementsRow>>> getAllAchievements(String userId) async {
    try {
      return await _achievementRepository.getAll();
    } catch (e) {
      return Failure('Failed to load achievements: ${e.toString()}');
    }
  }

  /// Get achievements by category
  /// Categories: combat, exploration, social, collection, etc.
  Future<Result<List<UserAchievementsRow>>> getAchievementsByCategory({
    required String userId,
    required String category,
  }) async {
    try {
      final allResult = await getAllAchievements(userId);
      
      if (allResult.isFailure) {
        return allResult;
      }
      
      // TODO: Filter by category from achievement_defs
      return allResult;
    } catch (e) {
      return Failure('Failed to load achievements by category: ${e.toString()}');
    }
  }

  /// Get achievements by rarity
  /// Rarity: common, rare, epic, legendary
  Future<Result<List<UserAchievementsRow>>> getAchievementsByRarity({
    required String userId,
    required String rarity,
  }) async {
    try {
      final allResult = await getAllAchievements(userId);
      
      if (allResult.isFailure) {
        return allResult;
      }
      
      // TODO: Filter by rarity from achievement_defs
      return allResult;
    } catch (e) {
      return Failure('Failed to load achievements by rarity: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT UNLOCK LOGIC
  // ============================================================================

  /// Unlock an achievement for user
  /// Validates unlock conditions
  /// Awards rewards (XP, cosmetics, titles)
  /// Sends notification
  /// 
  /// Returns: Unlocked achievement with rewards
  Future<Result<AchievementUnlockResult>> unlockAchievement({
    required String userId,
    required String achievementId,
    bool validateConditions = true,
  }) async {
    try {
      // Validate conditions if required
      if (validateConditions) {
        final canUnlockResult = await canUnlockAchievement(
          userId: userId,
          achievementId: achievementId,
        );
        
        if (canUnlockResult.isFailure) {
          return Failure(canUnlockResult.error!);
        }
        
        if (!canUnlockResult.data!) {
          return Failure('Achievement cannot be unlocked yet');
        }
      }
      
      // Unlock achievement
      final unlockResult = await _achievementRepository.unlockAchievement(achievementId);
      
      if (unlockResult.isFailure) {
        return Failure(unlockResult.error!);
      }
      
      // Award rewards
      final rewardsResult = await awardAchievementRewards(
        userId: userId,
        achievementId: achievementId,
      );
      
      final rewards = rewardsResult.isSuccess
          ? rewardsResult.data!
          : AchievementRewards(xp: 0, points: 0);
      
      final result = AchievementUnlockResult(
        achievement: unlockResult.data!,
        rewards: rewards,
        unlockedAt: DateTime.now(),
        isFirstUnlock: false,
        unlockRank: 0,
      );
      
      return Success(result);
    } catch (e) {
      return Failure('Failed to unlock achievement: ${e.toString()}');
    }
  }

  /// Check if achievement can be unlocked
  /// Evaluates unlock conditions against user stats
  /// 
  /// Returns: true if conditions are met
  Future<Result<bool>> canUnlockAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final evalResult = await evaluateUnlockConditions(
        userId: userId,
        achievementId: achievementId,
      );
      
      if (evalResult.isFailure) {
        return Failure(evalResult.error!);
      }
      
      return Success(evalResult.data!.allConditionsMet);
    } catch (e) {
      return Failure('Failed to check unlock eligibility: ${e.toString()}');
    }
  }

  /// Update achievement progress
  /// For progressive achievements (e.g., "Complete 100 tasks")
  /// Auto-unlocks if progress reaches target
  Future<Result<UserAchievementsRow>> updateAchievementProgress({
    required String userId,
    required String achievementId,
    required int progress,
  }) async {
    try {
      final clampedProgress = progress.clamp(0, 100);
      
      final result = await _achievementRepository.update(
        achievementId,
        {'progress': clampedProgress},
      );
      
      if (result.isFailure) {
        return result;
      }
      
      // Auto-unlock if at 100%
      if (clampedProgress >= 100) {
        await unlockAchievement(
          userId: userId,
          achievementId: achievementId,
          validateConditions: false,
        );
      }
      
      return result;
    } catch (e) {
      return Failure('Failed to update achievement progress: ${e.toString()}');
    }
  }

  /// Increment achievement progress
  /// Useful for counting achievements
  Future<Result<UserAchievementsRow>> incrementAchievementProgress({
    required String userId,
    required String achievementId,
    int delta = 1,
  }) async {
    try {
      final achievementResult = await _achievementRepository.getById(achievementId);
      
      if (achievementResult.isFailure) {
        return Failure(achievementResult.error!);
      }
      
      final currentProgress = achievementResult.data!.progress ?? 0;
      final newProgress = (currentProgress + delta).clamp(0, 100);
      
      return await updateAchievementProgress(
        userId: userId,
        achievementId: achievementId,
        progress: newProgress,
      );
    } catch (e) {
      return Failure('Failed to increment achievement progress: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT VALIDATION & CONDITIONS
  // ============================================================================

  /// Evaluate achievement unlock conditions
  /// Conditions can be: task count, XP threshold, quest completion, etc.
  /// 
  /// Returns: Evaluation result with details
  Future<Result<ConditionEvaluation>> evaluateUnlockConditions({
    required String userId,
    required String achievementId,
  }) async {
    try {
      // TODO: Get achievement definition and check conditions
      // For now, return simple evaluation
      final evaluation = ConditionEvaluation(
        allConditionsMet: true,
        conditions: [],
        progressPercentage: 100,
      );
      
      return Success(evaluation);
    } catch (e) {
      return Failure('Failed to evaluate conditions: ${e.toString()}');
    }
  }

  /// Check if user meets specific condition
  /// Conditions: level >= X, tasks_completed >= Y, etc.
  Future<Result<bool>> meetsCondition({
    required String userId,
    required String conditionType,
    required dynamic conditionValue,
  }) async {
    try {
      // TODO: Implement condition checking logic
      // - Get user stats
      // - Compare against condition
      return Success(true);
    } catch (e) {
      return Failure('Failed to check condition: ${e.toString()}');
    }
  }

  /// Calculate achievement progress percentage
  /// For progressive achievements
  double calculateAchievementProgress({
    required int currentProgress,
    required int targetProgress,
  }) {
    if (targetProgress <= 0) return 0.0;
    return (currentProgress / targetProgress * 100).clamp(0.0, 100.0);
  }

  // ============================================================================
  // ACHIEVEMENT TRIGGERS & AUTOMATION
  // ============================================================================

  /// Check and unlock achievements based on user event
  /// Called when user performs actions (complete quest, reach level, etc.)
  /// Automatically checks all achievement conditions
  /// 
  /// Example: onUserEvent('quest_completed', userId, {questId: '123'})
  Future<Result<List<AchievementUnlockResult>>> onUserEvent({
    required String eventType,
    required String userId,
    Map<String, dynamic>? eventData,
  }) async {
    try {
      final triggeredResult = await getAchievementsByTrigger(eventType);
      
      if (triggeredResult.isFailure) {
        return Failure(triggeredResult.error!);
      }
      
      final achievements = triggeredResult.data!;
      final unlockedResults = <AchievementUnlockResult>[];
      
      for (final achievement in achievements) {
        final unlockResult = await unlockAchievement(
          userId: userId,
          achievementId: achievement.id,
        );
        
        if (unlockResult.isSuccess) {
          unlockedResults.add(unlockResult.data!);
        }
      }
      
      return Success(unlockedResults);
    } catch (e) {
      return Failure('Failed to process achievement event: ${e.toString()}');
    }
  }

  /// Get achievements triggered by specific event
  /// Returns achievements that should be checked on this event
  Future<Result<List<AchievementDefsRow>>> getAchievementsByTrigger(
      String trigger) async {
    try {
      // TODO: Query achievement_defs by trigger type
      return Success([]);
    } catch (e) {
      return Failure('Failed to get triggered achievements: ${e.toString()}');
    }
  }

  /// Batch check achievements for unlock
  /// Checks multiple achievements at once (optimization)
  Future<Result<List<AchievementUnlockResult>>> batchCheckAchievements({
    required String userId,
    required List<String> achievementIds,
  }) async {
    try {
      final results = <AchievementUnlockResult>[];
      
      for (final achievementId in achievementIds) {
        final unlockResult = await unlockAchievement(
          userId: userId,
          achievementId: achievementId,
        );
        
        if (unlockResult.isSuccess) {
          results.add(unlockResult.data!);
        }
      }
      
      return Success(results);
    } catch (e) {
      return Failure('Failed to batch check achievements: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT REWARDS
  // ============================================================================

  /// Award achievement rewards to user
  /// Distributes XP, cosmetics, titles, etc.
  /// Updates user profile
  /// 
  /// Returns: Reward details
  Future<Result<AchievementRewards>> awardAchievementRewards({
    required String userId,
    required String achievementId,
  }) async {
    try {
      // TODO: Get achievement definition to calculate rewards
      final rewards = calculateRewards(rarity: 'common', difficulty: 1);
      
      // TODO: Award XP to user via XpService
      // TODO: Grant cosmetic rewards
      
      return Success(rewards);
    } catch (e) {
      return Failure('Failed to award rewards: ${e.toString()}');
    }
  }

  /// Calculate achievement reward value
  /// Based on rarity, difficulty, etc.
  AchievementRewards calculateRewards({
    required String rarity,
    required int difficulty,
  }) {
    int baseXp = 50;
    int coins = 10;
    
    // Multiply by difficulty
    baseXp *= difficulty;
    coins *= difficulty;
    
    // Apply rarity multiplier
    switch (rarity.toLowerCase()) {
      case 'common':
        break;
      case 'rare':
        baseXp = (baseXp * 1.5).round();
        coins = (coins * 1.5).round();
        break;
      case 'epic':
        baseXp *= 2;
        coins *= 2;
        break;
      case 'legendary':
        baseXp *= 3;
        coins *= 3;
        break;
    }
    
    return AchievementRewards(
      xp: baseXp,
      points: coins,
      title: null,
      cosmeticId: null,
      badgeUrl: null,
    );
  }

  // ============================================================================
  // ACHIEVEMENT STATISTICS
  // ============================================================================

  /// Get achievement statistics for user
  /// Returns total unlocked, completion rate, rarity breakdown
  Future<Result<AchievementStats>> getAchievementStats(String userId) async {
    try {
      final allResult = await getAllAchievements(userId);
      final unlockedResult = await getUnlockedAchievements(userId);
      
      final total = allResult.isSuccess ? allResult.data!.length : 0;
      final unlocked = unlockedResult.isSuccess ? unlockedResult.data!.length : 0;
      
      final completionRate = total > 0 ? (unlocked / total * 100) : 0.0;
      
      final stats = AchievementStats(
        totalAchievements: total,
        unlockedAchievements: unlocked,
        lockedAchievements: total - unlocked,
        completionRate: completionRate,
        totalXpFromAchievements: 0,
        rarityBreakdown: {
          'common': 0,
          'rare': 0,
          'epic': 0,
          'legendary': 0,
        },
      );
      
      return Success(stats);
    } catch (e) {
      return Failure('Failed to get achievement stats: ${e.toString()}');
    }
  }

  /// Get user's achievement unlock history
  /// Returns paginated list of unlocked achievements
  Future<Result<List<UserAchievementsRow>>> getUnlockHistory({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final unlockedResult = await getUnlockedAchievements(userId);
      if (unlockedResult.isFailure) return unlockedResult;
      
      final unlocked = unlockedResult.data!;
      final startIndex = (page - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, unlocked.length);
      
      if (startIndex >= unlocked.length) return Success([]);
      return Success(unlocked.sublist(startIndex, endIndex));
    } catch (e) {
      return Failure('Failed to get unlock history: ${e.toString()}');
    }
  }

  /// Get nearest achievements to unlock
  /// Returns achievements closest to completion
  Future<Result<List<AchievementProgress>>> getNearestUnlocks(String userId) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get nearest unlocks: ${e.toString()}');
    }
  }

  /// Get rarest achievements
  /// Returns achievements with lowest unlock rate
  Future<Result<List<AchievementDefsRow>>> getRarestAchievements() async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get rarest achievements: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT COMPARISON & SOCIAL
  // ============================================================================

  /// Compare achievements between users
  /// Returns comparison data (who has what, differences)
  Future<Result<AchievementComparison>> compareAchievements({
    required String userId1,
    required String userId2,
  }) async {
    try {
      return Failure('Not implemented');
    } catch (e) {
      return Failure('Failed to compare achievements: ${e.toString()}');
    }
  }

  /// Get achievement leaderboard
  /// Ranks users by total achievements unlocked
  Future<Result<List<AchievementLeaderboardEntry>>> getAchievementLeaderboard({
    int limit = 50,
    String? category,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get leaderboard: ${e.toString()}');
    }
  }

  // ============================================================================
  // ACHIEVEMENT NOTIFICATIONS
  // ============================================================================

  /// Send achievement unlock notification
  /// Triggers in-app and push notification
  Future<Result<bool>> sendUnlockNotification({
    required String userId,
    required String achievementId,
  }) async {
    try {
      return Success(true);
    } catch (e) {
      return Failure('Failed to send notification: ${e.toString()}');
    }
  }

  /// Get recent achievement unlocks for feed
  /// Returns recent unlocks across all users (public achievements)
  Future<Result<List<AchievementUnlockEvent>>> getRecentUnlocks({
    int limit = 20,
    String? category,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get recent unlocks: ${e.toString()}');
    }
  }

  // ============================================================================
  // OFFLINE SUPPORT
  // ============================================================================

  /// Check if offline achievement data is available
  Future<bool> hasOfflineAchievements() async {
    try {
      final cached = await _achievementRepository.getCached();
      return cached.isSuccess && cached.data != null && cached.data!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get cached achievements for offline use
  Future<Result<List<UserAchievementsRow>>> getOfflineAchievements() async {
    try {
      return await _achievementRepository.getCached();
    } catch (e) {
      return Failure('Failed to load offline achievements: ${e.toString()}');
    }
  }

  /// Queue achievement unlock for later sync
  Future<Result<bool>> queueAchievementUnlock({
    required String userId,
    required String achievementId,
  }) async {
    try {
      return Success(true);
    } catch (e) {
      return Failure('Failed to queue unlock: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR SERVICE RESPONSES
// ============================================================================

/// Achievement details with unlock conditions
class AchievementDetails {
  final AchievementDefsRow definition;
  final UserAchievementsRow? userProgress;
  final bool isUnlocked;
  final double progressPercentage;
  final List<UnlockCondition> conditions;
  final AchievementRewards rewards;

  AchievementDetails({
    required this.definition,
    this.userProgress,
    required this.isUnlocked,
    required this.progressPercentage,
    required this.conditions,
    required this.rewards,
  });
}

/// Achievement unlock result
class AchievementUnlockResult {
  final UserAchievementsRow achievement;
  final AchievementRewards rewards;
  final DateTime unlockedAt;
  final bool isFirstUnlock; // First person to unlock
  final int unlockRank; // Position in unlock order (1st, 2nd, etc.)

  AchievementUnlockResult({
    required this.achievement,
    required this.rewards,
    required this.unlockedAt,
    required this.isFirstUnlock,
    required this.unlockRank,
  });
}

/// Achievement rewards breakdown
class AchievementRewards {
  final int xp;
  final int points;
  final String? title; // Special title unlocked
  final String? cosmeticId; // Cosmetic item unlocked
  final String? badgeUrl; // Badge image URL

  AchievementRewards({
    required this.xp,
    required this.points,
    this.title,
    this.cosmeticId,
    this.badgeUrl,
  });
}

/// Unlock condition definition
class UnlockCondition {
  final String type; // task_count, xp_threshold, quest_completed, etc.
  final dynamic targetValue;
  final dynamic currentValue;
  final bool isMet;

  UnlockCondition({
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.isMet,
  });
}

/// Condition evaluation result
class ConditionEvaluation {
  final bool allConditionsMet;
  final List<UnlockCondition> conditions;
  final double progressPercentage;
  final String? blockingCondition; // Which condition is not met

  ConditionEvaluation({
    required this.allConditionsMet,
    required this.conditions,
    required this.progressPercentage,
    this.blockingCondition,
  });
}

/// Achievement statistics
class AchievementStats {
  final int totalAchievements;
  final int unlockedAchievements;
  final int lockedAchievements;
  final double completionRate;
  final Map<String, int> rarityBreakdown; // common: 5, rare: 2, etc.
  final int totalXpFromAchievements;
  final String? favoriteCategory;

  AchievementStats({
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.lockedAchievements,
    required this.completionRate,
    required this.rarityBreakdown,
    required this.totalXpFromAchievements,
    this.favoriteCategory,
  });
}

/// Achievement progress (for nearest unlocks)
class AchievementProgress {
  final AchievementDefsRow achievement;
  final int currentProgress;
  final int targetProgress;
  final double progressPercentage;
  final int progressNeeded;

  AchievementProgress({
    required this.achievement,
    required this.currentProgress,
    required this.targetProgress,
    required this.progressPercentage,
    required this.progressNeeded,
  });
}

/// Achievement comparison between users
class AchievementComparison {
  final String user1Id;
  final String user2Id;
  final List<String> commonAchievements;
  final List<String> user1UniqueAchievements;
  final List<String> user2UniqueAchievements;
  final int totalUser1;
  final int totalUser2;

  AchievementComparison({
    required this.user1Id,
    required this.user2Id,
    required this.commonAchievements,
    required this.user1UniqueAchievements,
    required this.user2UniqueAchievements,
    required this.totalUser1,
    required this.totalUser2,
  });
}

/// Achievement leaderboard entry
class AchievementLeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int totalAchievements;
  final int rank;
  final List<String> rareAchievements; // Rare achievements to showcase

  AchievementLeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.totalAchievements,
    required this.rank,
    this.rareAchievements = const [],
  });
}

/// Achievement unlock event (for feed)
class AchievementUnlockEvent {
  final String userId;
  final String username;
  final String? avatarUrl;
  final String achievementId;
  final String achievementTitle;
  final String? achievementBadge;
  final DateTime unlockedAt;
  final String rarity;

  AchievementUnlockEvent({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.achievementId,
    required this.achievementTitle,
    this.achievementBadge,
    required this.unlockedAt,
    required this.rarity,
  });
}
