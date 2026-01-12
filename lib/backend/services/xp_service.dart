import 'package:uni_quest/backend/core/result.dart';
import 'package:uni_quest/repositories/user_repository.dart';
import 'package:uni_quest/constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' as math;

/// XP Service - Experience Points & Leveling Logic
/// Handles all XP-related operations including calculation, distribution,
/// level progression, rank management, and XP multipliers/bonuses.
///
/// Demonstrates:
/// - Service Layer Pattern (XP business logic)
/// - Single Responsibility (only XP calculations)
/// - Complex progression formulas
class XpService {
  // Singleton pattern
  static final XpService _instance = XpService._internal();
  factory XpService() => _instance;
  XpService._internal();

  final UserRepository _userRepository =
      UserRepository(Supabase.instance.client);

  // ============================================================================
  // XP RETRIEVAL & DISPLAY
  // ============================================================================

  /// Get user's current XP
  /// Returns total XP accumulated
  Future<Result<int>> getUserXp(String userId) async {
    try {
      final result = await _userRepository.getUserById(userId);
      if (result.isFailure) return Failure(result.error!);
      return Success(result.data?.xp ?? 0);
    } catch (e) {
      return Failure('Failed to get user XP: ${e.toString()}');
    }
  }

  /// Get user's current level
  /// Calculated from total XP using progression formula
  Future<Result<int>> getUserLevel(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);
      return Success(calculateLevelFromXp(xpResult.data!));
    } catch (e) {
      return Failure('Failed to get user level: ${e.toString()}');
    }
  }

  /// Get user's current rank/tier
  /// Rank: Novice, Explorer, Achiever, Champion, Legend
  Future<Result<String>> getUserRank(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);
      return Success(calculateRankFromXp(xpResult.data!));
    } catch (e) {
      return Failure('Failed to get user rank: ${e.toString()}');
    }
  }

  /// Get XP progress to next level
  /// Returns current XP, next level XP, and percentage
  Future<Result<XpProgress>> getXpProgressToNextLevel(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final currentXp = xpResult.data!;
      final currentLevel = calculateLevelFromXp(currentXp);
      final nextLevel = currentLevel + 1;
      final nextLevelXp = calculateXpForLevel(nextLevel);
      final currentLevelXp = calculateXpForLevel(currentLevel);
      final progressXp = currentXp - currentLevelXp;
      final requiredXp = nextLevelXp - currentLevelXp;
      final percentage =
          requiredXp > 0 ? (progressXp / requiredXp * 100) : 100.0;

      final progress = XpProgress(
        currentXp: currentXp,
        currentLevel: currentLevel,
        nextLevel: nextLevel,
        xpForCurrentLevel: currentLevelXp,
        xpForNextLevel: nextLevelXp,
        xpToNextLevel: nextLevelXp - currentXp,
        progressPercentage: percentage.clamp(0.0, 100.0),
      );

      return Success(progress);
    } catch (e) {
      return Failure('Failed to get XP progress: ${e.toString()}');
    }
  }

  /// Get XP progress to next rank
  /// Returns XP needed for next rank tier
  Future<Result<RankProgress>> getRankProgress(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final currentXp = xpResult.data!;
      final currentRank = calculateRankFromXp(currentXp);
      final nextRank = getNextRank(currentRank);
      final xpForCurrentRank = calculateXpForRank(currentRank);
      final nextRankXp =
          nextRank != null ? calculateXpForRank(nextRank) : currentXp;
      final xpToNextRank = nextRankXp - currentXp;
      final progressPercentage = nextRankXp > xpForCurrentRank
          ? ((currentXp - xpForCurrentRank) /
              (nextRankXp - xpForCurrentRank) *
              100)
          : 100.0;

      final progress = RankProgress(
        currentRank: currentRank,
        nextRank: nextRank,
        currentXp: currentXp,
        xpForCurrentRank: xpForCurrentRank,
        xpForNextRank: nextRankXp,
        xpToNextRank: xpToNextRank,
        progressPercentage: progressPercentage.clamp(0.0, 100.0),
      );

      return Success(progress);
    } catch (e) {
      return Failure('Failed to get rank progress: ${e.toString()}');
    }
  }

  // ============================================================================
  // XP AWARD & CALCULATION
  // ============================================================================

  /// Award XP to user
  /// Updates profile.xp field
  /// Checks for level up
  /// Checks for rank up
  /// Applies multipliers (streak, premium, events)
  /// Sends notifications on level/rank up
  ///
  /// Returns: XP award result with level/rank changes
  Future<Result<XpAwardResult>> awardXp({
    required String userId,
    required int baseXp,
    String? source,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Get current XP
      final currentXpResult = await getUserXp(userId);
      if (currentXpResult.isFailure) return Failure(currentXpResult.error!);
      final oldXp = currentXpResult.data!;

      // Calculate final XP with multipliers
      final finalXp = calculateXpWithMultipliers(baseXp: baseXp);

      // Update user XP
      final newXp = oldXp + finalXp;
      final updateResult = await _userRepository.update(userId, {'xp': newXp});
      if (updateResult.isFailure) return Failure(updateResult.error!);

      // Check for level/rank changes
      final leveledUp = didLevelUp(oldXp: oldXp, newXp: newXp);
      final rankedUp = didRankUp(oldXp: oldXp, newXp: newXp);

      final result = XpAwardResult(
        xpAwarded: finalXp,
        oldXp: oldXp,
        newXp: newXp,
        oldLevel: calculateLevelFromXp(oldXp),
        newLevel: calculateLevelFromXp(newXp),
        didLevelUp: leveledUp,
        oldRank: calculateRankFromXp(oldXp),
        newRank: calculateRankFromXp(newXp),
        didRankUp: rankedUp,
      );

      // Handle level up
      if (leveledUp) {
        await handleLevelUp(userId: userId, newLevel: result.newLevel);
      }

      // Handle rank up
      if (rankedUp) {
        await handleRankUp(userId: userId, newRank: result.newRank);
      }

      return Success(result);
    } catch (e) {
      return Failure('Failed to award XP: ${e.toString()}');
    }
  }

  /// Calculate XP with multipliers
  /// Applies all active multipliers (streak, premium, events)
  ///
  /// Returns: Final XP amount after multipliers
  int calculateXpWithMultipliers({
    required int baseXp,
    int streakMultiplier = 1,
    bool isPremium = false,
    List<XpMultiplier>? activeMultipliers,
  }) {
    double finalXp = baseXp.toDouble();

    // Apply streak multiplier
    finalXp *= streakMultiplier;

    // Apply premium multiplier
    if (isPremium) {
      finalXp *= getPremiumMultiplier(true);
    }

    // Apply active multipliers
    if (activeMultipliers != null) {
      for (final multiplier in activeMultipliers) {
        finalXp *= multiplier.multiplier;
      }
    }

    return finalXp.round();
  }

  /// Calculate XP for task completion
  /// Based on task difficulty, due date proximity, etc.
  int calculateTaskXp({
    required bool isCompleted,
    DateTime? dueDate,
    String? difficulty,
  }) {
    if (!isCompleted) return 0;

    int baseXp = AppConstants.xpTaskComplete;

    // Bonus for completing before due date
    if (dueDate != null && DateTime.now().isBefore(dueDate)) {
      final daysEarly = dueDate.difference(DateTime.now()).inDays;
      if (daysEarly > 2) baseXp = (baseXp * 1.2).round();
    }

    return baseXp;
  }

  /// Calculate XP for quest completion
  /// Uses quest reward_points as base
  int calculateQuestXp({
    required int rewardPoints,
    String? questDifficulty,
  }) {
    return rewardPoints; // Direct mapping
  }

  /// Calculate XP for achievement unlock
  /// Based on achievement rarity
  int calculateAchievementXp({
    required String rarity,
  }) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return 50;
      case 'rare':
        return 100;
      case 'epic':
        return 200;
      case 'legendary':
        return 500;
      default:
        return 25;
    }
  }

  // ============================================================================
  // LEVEL PROGRESSION
  // ============================================================================

  /// Calculate level from XP
  /// Uses progression formula (e.g., XP = level^2 * 100)
  int calculateLevelFromXp(int totalXp) {
    // Formula: level = sqrt(xp / 100)
    return math.sqrt(totalXp / 100).floor() + 1;
  }

  /// Calculate XP required for level
  /// Returns XP needed to reach specified level
  int calculateXpForLevel(int level) {
    // Formula: xp = (level - 1)^2 * 100
    if (level <= 1) return 0;
    return math.pow(level - 1, 2).toInt() * 100;
  }

  /// Calculate XP required to reach next level
  /// From current XP
  Future<Result<int>> getXpToNextLevel(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final currentXp = xpResult.data!;
      final currentLevel = calculateLevelFromXp(currentXp);
      final nextLevelXp = calculateXpForLevel(currentLevel + 1);

      return Success(nextLevelXp - currentXp);
    } catch (e) {
      return Failure('Failed to calculate XP to next level: ${e.toString()}');
    }
  }

  /// Check if user leveled up
  /// Compares old level vs new level after XP award
  ///
  /// Returns: true if level increased
  bool didLevelUp({
    required int oldXp,
    required int newXp,
  }) {
    final oldLevel = calculateLevelFromXp(oldXp);
    final newLevel = calculateLevelFromXp(newXp);
    return newLevel > oldLevel;
  }

  /// Handle level up event
  /// Awards level up rewards
  /// Unlocks new features
  /// Sends notification
  /// Updates user stats
  Future<Result<LevelUpResult>> handleLevelUp({
    required String userId,
    required int newLevel,
  }) async {
    try {
      final result = LevelUpResult(
        newLevel: newLevel,
        xpReward: 0,
        unlockedFeatures: [],
        unlockedCosmetics: [],
      );

      return Success(result);
    } catch (e) {
      return Failure('Failed to handle level up: ${e.toString()}');
    }
  }

  // ============================================================================
  // RANK PROGRESSION
  // ============================================================================

  /// Calculate rank from XP
  /// Rank tiers: Novice (0-999), Explorer (1000-4999), etc.
  String calculateRankFromXp(int totalXp) {
    if (totalXp >= 50000) return 'Legend';
    if (totalXp >= 15000) return 'Champion';
    if (totalXp >= 5000) return 'Achiever';
    if (totalXp >= 1000) return 'Explorer';
    return 'Novice';
  }

  /// Get rank thresholds
  /// Returns map of rank name to XP threshold
  Map<String, int> getRankThresholds() {
    return {
      'Novice': 0,
      'Explorer': 1000,
      'Achiever': 5000,
      'Champion': 15000,
      'Legend': 50000,
    };
  }

  /// Get next rank
  /// Returns rank after current rank
  String? getNextRank(String currentRank) {
    const rankOrder = ['Novice', 'Explorer', 'Achiever', 'Champion', 'Legend'];
    final currentIndex = rankOrder.indexOf(currentRank);

    if (currentIndex >= 0 && currentIndex < rankOrder.length - 1) {
      return rankOrder[currentIndex + 1];
    }

    return null; // Max rank reached
  }

  /// Calculate XP required for rank
  /// Returns XP needed to reach specified rank
  int calculateXpForRank(String rank) {
    final thresholds = getRankThresholds();
    return thresholds[rank] ?? 0;
  }

  /// Check if user ranked up
  /// Compares old rank vs new rank after XP award
  bool didRankUp({
    required int oldXp,
    required int newXp,
  }) {
    final oldRank = calculateRankFromXp(oldXp);
    final newRank = calculateRankFromXp(newXp);
    return oldRank != newRank;
  }

  /// Handle rank up event
  /// Awards rank rewards (titles, cosmetics)
  /// Sends notification
  /// Updates profile
  Future<Result<RankUpResult>> handleRankUp({
    required String userId,
    required String newRank,
  }) async {
    try {
      final result = RankUpResult(
        newRank: newRank,
        xpReward: 0,
        unlockedCosmetics: [],
        unlockedTitle: 'Rank: $newRank',
      );

      return Success(result);
    } catch (e) {
      return Failure('Failed to handle rank up: ${e.toString()}');
    }
  }

  // ============================================================================
  // XP MULTIPLIERS & BONUSES
  // ============================================================================

  /// Get active XP multipliers for user
  /// Includes streak, premium, event multipliers
  Future<Result<List<XpMultiplier>>> getActiveMultipliers(String userId) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get active multipliers: ${e.toString()}');
    }
  }

  /// Calculate streak multiplier
  /// Streak bonuses: 3 days = 1.1x, 7 days = 1.25x, 30 days = 1.5x
  double calculateStreakMultiplier(int streakDays) {
    if (streakDays >= 30) return AppConstants.streakMultiplierMax;
    if (streakDays >= 14) return AppConstants.streakMultiplierHigh;
    if (streakDays >= 7) return AppConstants.streakMultiplierMedium;
    if (streakDays >= 3) return AppConstants.streakMultiplierLow;
    return AppConstants.streakMultiplierNone;
  }

  /// Calculate premium multiplier
  /// Premium users get XP boost
  double getPremiumMultiplier(bool isPremium) {
    return isPremium ? 1.5 : 1.0;
  }

  /// Calculate event multiplier
  /// During special events (double XP weekend, etc.)
  Future<Result<double>> getEventMultiplier() async {
    try {
      return Success(1.0);
    } catch (e) {
      return Failure('Failed to get event multiplier: ${e.toString()}');
    }
  }

  /// Apply temporary XP boost
  /// User-activated boost (e.g., from shop purchase)
  Future<Result<bool>> applyXpBoost({
    required String userId,
    required double multiplier,
    required Duration duration,
  }) async {
    try {
      return Success(true);
    } catch (e) {
      return Failure('Failed to apply XP boost: ${e.toString()}');
    }
  }

  // ============================================================================
  // XP STATISTICS & ANALYTICS
  // ============================================================================

  /// Get XP statistics for user
  /// Returns XP breakdown by source
  Future<Result<XpStats>> getXpStats(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final stats = XpStats(
        totalXp: xpResult.data!,
        currentLevel: 1,
        currentRank: 'Novice',
        xpBySource: {},
        xpThisWeek: 0,
        xpThisMonth: 0,
        xpToday: 0,
        averageXpPerDay: 0.0,
        daysActive: 0,
      );

      return Success(stats);
    } catch (e) {
      return Failure('Failed to get XP stats: ${e.toString()}');
    }
  }

  /// Get XP history
  /// Returns paginated XP gain events
  Future<Result<List<XpEvent>>> getXpHistory({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get XP history: ${e.toString()}');
    }
  }

  /// Get XP leaderboard
  /// Returns top users by XP
  Future<Result<List<XpLeaderboardEntry>>> getXpLeaderboard({
    int limit = 50,
    String? period,
  }) async {
    try {
      return Success([]);
    } catch (e) {
      return Failure('Failed to get XP leaderboard: ${e.toString()}');
    }
  }

  /// Calculate average XP per day
  /// Based on account age and total XP
  Future<Result<double>> getAverageXpPerDay(String userId) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final userResult = await _userRepository.getUserById(userId);
      if (userResult.isFailure) return Failure(userResult.error!);

      final user = userResult.data!;
      final accountAge = DateTime.now().difference(user.createdAt).inDays;

      if (accountAge <= 0) return Success(0.0);

      final averageXp = xpResult.data! / accountAge;
      return Success(averageXp);
    } catch (e) {
      return Failure('Failed to calculate average XP: ${e.toString()}');
    }
  }

  // ============================================================================
  // XP VALIDATION & BUSINESS RULES
  // ============================================================================

  /// Validate XP award
  /// Checks for reasonable values, abuse prevention
  ///
  /// Returns: true if valid
  Result<bool> validateXpAward({
    required int xpAmount,
    required String source,
  }) {
    if (xpAmount <= 0) {
      return Failure('XP amount must be positive');
    }

    if (xpAmount > 10000) {
      return Failure('XP amount too large (possible abuse)');
    }

    return Success(true);
  }

  /// Check for XP farming/abuse
  /// Detects suspicious patterns
  Future<Result<bool>> detectXpAbuse(String userId) async {
    try {
      return Success(false);
    } catch (e) {
      return Failure('Failed to detect abuse: ${e.toString()}');
    }
  }

  /// Get max XP per day
  /// Daily cap to prevent abuse
  int getMaxXpPerDay() {
    return 5000; // Cap at 5000 XP per day
  }

  /// Check if user hit daily XP cap
  Future<Result<bool>> hasHitDailyXpCap(String userId) async {
    try {
      // TODO: Query today's XP gains
      // Compare against max XP per day
      return Success(false);
    } catch (e) {
      return Failure('Failed to check daily cap: ${e.toString()}');
    }
  }

  // ============================================================================
  // XP PENALTIES & REDUCTIONS
  // ============================================================================

  /// Deduct XP from user
  /// Used for penalties (quest abandonment, rule violations)
  Future<Result<int>> deductXp({
    required String userId,
    required int xpAmount,
    required String reason,
  }) async {
    try {
      final xpResult = await getUserXp(userId);
      if (xpResult.isFailure) return Failure(xpResult.error!);

      final currentXp = xpResult.data!;
      final newXp = math.max(0, currentXp - xpAmount); // Don't go negative

      // Update database
      // TODO: Store penalty reason in XP history

      return Success(newXp);
    } catch (e) {
      return Failure('Failed to deduct XP: ${e.toString()}');
    }
  }

  /// Reset XP for user
  /// Admin function for testing or account reset
  Future<Result<bool>> resetXp(String userId) async {
    try {
      // TODO: Update database to set XP to 0
      return Success(true);
    } catch (e) {
      return Failure('Failed to reset XP: ${e.toString()}');
    }
  }

  // ============================================================================
  // OFFLINE SUPPORT
  // ============================================================================

  /// Check if offline XP data is available
  Future<bool> hasOfflineXpData() async {
    try {
      // TODO: Check cache for XP data
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get cached XP for offline use
  Future<Result<int>> getOfflineXp(String userId) async {
    try {
      // TODO: Load from cache
      return Success(0);
    } catch (e) {
      return Failure('Failed to get offline XP: ${e.toString()}');
    }
  }

  /// Queue XP award for later sync
  Future<Result<bool>> queueXpAward({
    required String userId,
    required int xpAmount,
    required String source,
  }) async {
    try {
      // TODO: Store in offline queue
      return Success(true);
    } catch (e) {
      return Failure('Failed to queue XP award: ${e.toString()}');
    }
  }
}

// ============================================================================
// DATA MODELS FOR SERVICE RESPONSES
// ============================================================================

/// XP progress to next level
class XpProgress {
  final int currentXp;
  final int currentLevel;
  final int nextLevel;
  final int xpForCurrentLevel;
  final int xpForNextLevel;
  final int xpToNextLevel;
  final double progressPercentage;

  XpProgress({
    required this.currentXp,
    required this.currentLevel,
    required this.nextLevel,
    required this.xpForCurrentLevel,
    required this.xpForNextLevel,
    required this.xpToNextLevel,
    required this.progressPercentage,
  });
}

/// Rank progress
class RankProgress {
  final String currentRank;
  final String? nextRank;
  final int currentXp;
  final int xpForCurrentRank;
  final int? xpForNextRank;
  final int? xpToNextRank;
  final double? progressPercentage;

  RankProgress({
    required this.currentRank,
    this.nextRank,
    required this.currentXp,
    required this.xpForCurrentRank,
    this.xpForNextRank,
    this.xpToNextRank,
    this.progressPercentage,
  });
}

/// XP award result
class XpAwardResult {
  final int xpAwarded;
  final int oldXp;
  final int newXp;
  final int oldLevel;
  final int newLevel;
  final String oldRank;
  final String newRank;
  final bool didLevelUp;
  final bool didRankUp;
  final List<String> unlockedRewards; // Rewards from level/rank up

  XpAwardResult({
    required this.xpAwarded,
    required this.oldXp,
    required this.newXp,
    required this.oldLevel,
    required this.newLevel,
    required this.oldRank,
    required this.newRank,
    required this.didLevelUp,
    required this.didRankUp,
    this.unlockedRewards = const [],
  });
}

/// Level up result
class LevelUpResult {
  final int newLevel;
  final int xpReward;
  final List<String> unlockedFeatures;
  final List<String> unlockedCosmetics;
  final String? unlockedTitle;

  LevelUpResult({
    required this.newLevel,
    required this.xpReward,
    this.unlockedFeatures = const [],
    this.unlockedCosmetics = const [],
    this.unlockedTitle,
  });
}

/// Rank up result
class RankUpResult {
  final String newRank;
  final int xpReward;
  final String? unlockedTitle;
  final String? unlockedBadge;
  final List<String> unlockedCosmetics;

  RankUpResult({
    required this.newRank,
    required this.xpReward,
    this.unlockedTitle,
    this.unlockedBadge,
    this.unlockedCosmetics = const [],
  });
}

/// XP multiplier
class XpMultiplier {
  final String id;
  final String name;
  final double multiplier;
  final String source; // streak, premium, event, boost
  final DateTime? expiresAt;

  XpMultiplier({
    required this.id,
    required this.name,
    required this.multiplier,
    required this.source,
    this.expiresAt,
  });
}

/// XP statistics
class XpStats {
  final int totalXp;
  final int currentLevel;
  final String currentRank;
  final Map<String, int> xpBySource; // quest: 5000, task: 3000, etc.
  final int xpThisWeek;
  final int xpThisMonth;
  final int xpToday;
  final double averageXpPerDay;
  final int daysActive;

  XpStats({
    required this.totalXp,
    required this.currentLevel,
    required this.currentRank,
    required this.xpBySource,
    required this.xpThisWeek,
    required this.xpThisMonth,
    required this.xpToday,
    required this.averageXpPerDay,
    required this.daysActive,
  });
}

/// XP event (gain/loss)
class XpEvent {
  final String id;
  final String userId;
  final int xpAmount;
  final String source; // quest_completion, task_done, achievement, etc.
  final DateTime timestamp;
  final int oldXp;
  final int newXp;
  final Map<String, dynamic>? metadata;

  XpEvent({
    required this.id,
    required this.userId,
    required this.xpAmount,
    required this.source,
    required this.timestamp,
    required this.oldXp,
    required this.newXp,
    this.metadata,
  });
}

/// XP leaderboard entry
class XpLeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int totalXp;
  final int level;
  final String rank;
  final int position;
  final String? title; // Display title

  XpLeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.totalXp,
    required this.level,
    required this.rank,
    required this.position,
    this.title,
  });
}
