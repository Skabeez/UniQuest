/// Application-wide constants
/// 
/// Centralizes magic numbers and configuration values to improve
/// maintainability and prevent inconsistencies across the codebase.
/// 
/// Design Principles:
/// - Single Source of Truth (DRY principle)
/// - Type-safe constant definitions
/// - Organized by feature/category
/// - Prevents accidental modifications (const/static final)
/// 
/// Defense Talking Points:
/// - "Extracted magic numbers to improve maintainability"
/// - "Constants are grouped by domain for better organization"
/// - "Makes value changes easier - update once, affects everywhere"
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================================================
  // CACHE CONFIGURATION
  // ============================================================================
  
  /// Default cache time-to-live in minutes
  static const int cacheDefaultTtlMinutes = 5;
  
  /// Quest list cache expiration (minutes)
  static const int cacheQuestTtlMinutes = 5;
  
  /// User profile cache expiration (minutes)
  static const int cacheProfileTtlMinutes = 10;
  
  /// Achievement cache expiration (minutes)
  static const int cacheAchievementTtlMinutes = 30;
  
  /// Leaderboard cache expiration (minutes)
  /// Short TTL due to frequent updates
  static const int cacheLeaderboardTtlMinutes = 1;
  
  /// Static assets cache expiration (hours)
  static const int cacheAssetsTtlHours = 24;

  // ============================================================================
  // CONNECTIVITY & NETWORK
  // ============================================================================
  
  /// Ping timeout duration in seconds
  static const int connectivityPingTimeoutSeconds = 3;
  
  // ============================================================================
  // STREAK MULTIPLIERS
  // ============================================================================
  
  /// No streak multiplier (1.0x)
  static const double streakMultiplierNone = 1.0;
  
  /// Low streak multiplier (1.1x for 3-6 day streak)
  static const double streakMultiplierLow = 1.1;
  
  /// Medium streak multiplier (1.25x for 7-13 day streak)
  static const double streakMultiplierMedium = 1.25;
  
  /// High streak multiplier (1.5x for 14-29 day streak)
  static const double streakMultiplierHigh = 1.5;
  
  /// Maximum streak multiplier (2.0x for 30+ day streak)
  static const double streakMultiplierMax = 2.0;

  // ============================================================================
  // CONNECTIVITY & NETWORK
  // ============================================================================
  
  /// Interval for periodic connectivity checks (seconds)
  static const int connectivityCheckIntervalSeconds = 30;
  
  /// Maximum number of ping retry attempts
  static const int connectivityMaxRetries = 2;
  
  /// Auto-refresh interval for leaderboard (seconds)
  static const int leaderboardAutoRefreshSeconds = 30;

  // ============================================================================
  // XP & PROGRESSION
  // ============================================================================
  
  /// Minimum progress value (0%)
  static const int progressMin = 0;
  
  /// Maximum progress value (100%)
  static const int progressMax = 100;
  
  /// XP reward for easy quest
  static const int xpEasyQuest = 10;
  
  /// XP reward for medium quest
  static const int xpMediumQuest = 25;
  
  /// XP reward for hard quest
  static const int xpHardQuest = 50;
  
  /// XP reward for completing a task
  static const int xpTaskComplete = 5;
  
  /// XP reward for daily check-in
  static const int xpDailyCheckIn = 10;
  
  /// Progress percentage for quest completion
  static const int questProgressComplete = 100;
  
  /// Minimum progress value
  static const int progressMinValue = 0;
  
  /// Maximum progress value
  static const int progressMaxValue = 100;
  
  /// Initial progress for new quest
  static const int initialQuestProgress = 0;
  
  /// Initial streak value for new user
  static const int initialStreakValue = 0;

  // ============================================================================
  // RANK THRESHOLDS (XP-based)
  // ============================================================================
  
  /// XP threshold for Novice rank
  static const int rankNoviceXp = 0;
  
  /// XP threshold for Explorer rank
  static const int rankExplorerXp = 1000;
  
  /// XP threshold for Achiever rank
  static const int rankAchieverXp = 5000;
  
  /// XP threshold for Champion rank
  static const int rankChampionXp = 15000;
  
  /// XP threshold for Legend rank
  static const int rankLegendXp = 50000;

  // ============================================================================
  // STREAK MULTIPLIERS
  // ============================================================================
  
  /// Streak multiplier base (no bonus)
  static const double streakMultiplierBase = 1.0;
  
  /// Streak multiplier for 3-day streak
  static const double streakMultiplier3Days = 1.1;
  static const int streakThreshold3Days = 3;
  
  /// Streak multiplier for 7-day streak
  static const double streakMultiplier7Days = 1.25;
  static const int streakThreshold7Days = 7;
  
  /// Streak multiplier for 30-day streak
  static const double streakMultiplier30Days = 1.5;
  static const int streakThreshold30Days = 30;

  // ============================================================================
  // LEADERBOARD CONFIGURATION
  // ============================================================================
  
  /// Top N users to display on leaderboard
  static const int leaderboardTopN = 50;
  
  /// Leaderboard page size for pagination
  static const int leaderboardPageSize = 20;
  
  /// Minimum leaderboard entries before showing
  static const int leaderboardMinEntries = 5;
  
  /// Rare achievement leaderboard limit
  static const int leaderboardRareAchievementsLimit = 10;

  // ============================================================================
  // PAGINATION DEFAULTS
  // ============================================================================
  
  /// Default page number (1-indexed)
  static const int paginationDefaultPage = 1;
  
  /// Default page size for lists
  static const int paginationDefaultSize = 20;
  
  /// Small page size for previews
  static const int paginationSmallSize = 10;
  
  /// Large page size for bulk operations
  static const int paginationLargeSize = 50;
  
  /// Maximum page size allowed
  static const int paginationMaxSize = 100;

  // ============================================================================
  // VALIDATION RULES
  // ============================================================================
  
  /// Minimum password length
  static const int validationPasswordMinLength = 8;
  static const int validationPasswordMin = 8; // Alias
  
  /// Maximum password length
  static const int validationPasswordMaxLength = 128;
  static const int validationPasswordMax = 128; // Alias
  
  /// Minimum username length
  static const int validationUsernameMinLength = 3;
  static const int validationUsernameMin = 3; // Alias
  
  /// Maximum username length
  static const int validationUsernameMaxLength = 15;
  static const int validationUsernameMax = 15; // Alias
  
  /// Maximum task title length
  static const int validationTaskTitleMaxLength = 50;
  static const int validationTaskTitleMax = 50; // Alias
  
  /// Maximum bio length
  static const int validationBioMaxLength = 200;
  static const int validationBioMax = 200; // Alias
  
  /// Maximum quest description length
  static const int validationQuestDescMaxLength = 500;

  // ============================================================================
  // UI ANIMATION DURATIONS (milliseconds)
  // ============================================================================
  
  /// Splash screen display duration
  static const int animationSplashDuration = 3200;
  
  /// Short animation duration
  static const int animationShortDuration = 200;
  
  /// Medium animation duration
  static const int animationMediumDuration = 300;
  
  /// Long animation duration
  static const int animationLongDuration = 500;
  
  /// Navigation transition duration
  static const int animationNavTransition = 300;
  
  /// Fade in/out duration
  static const int animationFadeDuration = 200;
  
  /// Audio fade steps
  static const int audioFadeSteps = 30;
  
  /// Audio fade step duration (ms)
  static const int audioFadeStepDuration = 50;

  // ============================================================================
  // UI DIMENSIONS (logical pixels)
  // ============================================================================
  
  /// Standard border radius
  static const double uiBorderRadius = 12.0;
  
  /// Small border radius
  static const double uiBorderRadiusSmall = 8.0;
  
  /// Large border radius
  static const double uiBorderRadiusLarge = 20.0;
  
  /// Standard padding
  static const double uiPaddingStandard = 16.0;
  
  /// Small padding
  static const double uiPaddingSmall = 8.0;
  
  /// Large padding
  static const double uiPaddingLarge = 24.0;
  
  /// Icon size active
  static const double uiIconSizeActive = 28.0;
  
  /// Icon size inactive
  static const double uiIconSizeInactive = 24.0;
  
  /// Bottom nav bar height
  static const double uiBottomNavHeight = 72.0;
  
  /// Scroll threshold for hiding bottom nav
  static const double uiScrollHideThreshold = 50.0;
  
  /// Badge notification max count display
  static const int uiBadgeMaxCount = 99;
  
  /// Badge min size
  static const double uiBadgeMinSize = 18.0;
  
  /// Badge font size
  static const double uiBadgeFontSize = 10.0;

  // ============================================================================
  // AUDIO CONFIGURATION
  // ============================================================================
  
  /// Default background music volume (0.0 to 1.0)
  static const double audioDefaultBgmVolume = 0.7;
  
  /// Default sound effect volume (0.0 to 1.0)
  static const double audioDefaultSfxVolume = 0.8;
  
  /// Audio volume minimum
  static const double audioVolumeMin = 0.0;
  
  /// Audio volume maximum
  static const double audioVolumeMax = 1.0;
  
  /// Audio fade out steps
  static const int audioFadeOutSteps = 20;

  // ============================================================================
  // NOTIFICATION CONFIGURATION
  // ============================================================================
  
  /// Unread notification threshold for display
  static const int notificationUnreadThreshold = 0;
  
  /// Notification badge position offset X
  static const double notificationBadgeOffsetX = -8.0;
  
  /// Notification badge position offset Y
  static const double notificationBadgeOffsetY = -4.0;

  // ============================================================================
  // ACHIEVEMENT CONFIGURATION
  // ============================================================================
  
  /// Default achievement progress increment
  static const int achievementProgressIncrement = 1;
  
  /// Achievement unlock history limit
  static const int achievementHistoryLimit = 20;
  
  /// Recent achievement unlock feed limit
  static const int achievementRecentFeedLimit = 20;
  
  /// Nearest achievements to show
  static const int achievementNearestLimit = 5;

  // ============================================================================
  // QUEST CONFIGURATION
  // ============================================================================
  
  /// Default quest progress increment
  static const int questProgressIncrement = 1;
  
  /// Quest history pagination size
  static const int questHistoryPageSize = 20;

  // ============================================================================
  // REPOSITORY CONFIGURATION
  // ============================================================================
  
  /// Default cache expiration for mission repository (hours)
  static const int repositoryMissionCacheHours = 24;

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================
  
  /// Generic offline error message
  static const String errorOfflineMessage = 'You are offline - showing cached data';
  
  /// No cached data error
  static const String errorNoCacheMessage = 'No cached data available';
  
  /// Cannot refresh offline error
  static const String errorCannotRefreshOffline = 'Cannot refresh while offline';

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================
  
  /// Quest accepted success message
  static const String successQuestAccepted = 'Quest accepted successfully!';
  
  /// Quest completed success message
  static const String successQuestCompleted = 'Quest completed! 🎉';
  
  /// Profile updated success message
  static const String successProfileUpdated = 'Profile updated successfully!';

  // ============================================================================
  // FEATURE FLAGS (for A/B testing or gradual rollout)
  // ============================================================================
  
  /// Enable offline mode
  static const bool featureOfflineMode = true;
  
  /// Enable auto-refresh for leaderboard
  static const bool featureLeaderboardAutoRefresh = true;
  
  /// Enable audio manager
  static const bool featureAudio = true;
  
  /// Enable achievement notifications
  static const bool featureAchievementNotifications = true;

  // ============================================================================
  // DEBUG CONFIGURATION
  // ============================================================================
  
  /// Enable debug logging
  static const bool debugLogging = false;
  
  /// Enable performance monitoring
  static const bool debugPerformanceMonitoring = false;
}
