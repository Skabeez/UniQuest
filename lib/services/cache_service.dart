import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
// ignore_for_file: unused_import
import 'dart:convert';

/// Cache Service - Local data persistence using SharedPreferences
/// Provides simple key-value caching with TTL (time-to-live) support
/// 
/// Purpose:
/// - Cache frequently accessed data for offline viewing
/// - Reduce Supabase API calls when online
/// - Improve app performance and user experience
/// 
/// Demonstrates:
/// - Singleton Pattern (single cache instance)
/// - TTL-based cache invalidation
/// - JSON serialization for complex objects
abstract class CacheService {
  // ============================================================================
  // SINGLETON PATTERN
  // ============================================================================
  
  // Constructor for subclass implementation
  CacheService();

  // ignore: unused_field
  SharedPreferences? _prefs;

  // ============================================================================
  // CACHE KEYS
  // ============================================================================
  
  // Quest cache keys
  static const String keyQuestsActive = 'cache_quests_active_';
  static const String keyQuestsCompleted = 'cache_quests_completed_';
  static const String keyQuestDetails = 'cache_quest_details_';
  
  // User profile cache keys
  static const String keyUserProfile = 'cache_user_profile_';
  static const String keyUserStats = 'cache_user_stats_';
  
  // Achievement cache keys
  static const String keyAchievements = 'cache_achievements_';
  static const String keyAchievementProgress = 'cache_achievement_progress_';
  
  // Leaderboard cache keys
  static const String keyLeaderboard = 'cache_leaderboard_global';
  static const String keyLeaderboardXp = 'cache_leaderboard_xp';
  
  // Static assets
  static const String keyMapAssets = 'cache_map_assets';
  
  // Timestamp suffix for TTL
  static const String timestampSuffix = '_timestamp';

  // Additional cache keys
  static const String keyStreak = 'cache_streak_';
  static const String keyStatistics = 'cache_statistics_';
  static const String keySession = 'cache_session_';
  static const String keyOnboarding = 'cache_onboarding';
  static const String keyNotificationPrefs = 'cache_notification_prefs_';
  static const String keyTheme = 'cache_theme';
  static const String keySettings = 'cache_settings';

  // ============================================================================
  // CACHE EXPIRATION DURATIONS
  // ============================================================================
  
  /// Default cache TTL (5 minutes)
  static const Duration defaultTtl = Duration(minutes: 5);
  
  /// Quest list TTL (5 minutes)
  static const Duration questListTtl = Duration(minutes: 5);
  
  /// User profile TTL (10 minutes)
  static const Duration profileTtl = Duration(minutes: 10);
  
  /// Achievement list TTL (30 minutes)
  static const Duration achievementTtl = Duration(minutes: 30);
  
  /// Leaderboard TTL (1 minute - frequently updated)
  static const Duration leaderboardTtl = Duration(minutes: 1);
  
  /// Static assets TTL (24 hours)
  static const Duration assetsTtl = Duration(hours: 24);

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize SharedPreferences
  /// Must be called before using cache service
  /// Typically called in main() before runApp()
  Future<void> initialize();

  /// Check if cache service is initialized
  bool get isInitialized;

  // ============================================================================
  // QUEST CACHING
  // ============================================================================

  /// Cache active quest list for user
  /// Stores list as JSON string with timestamp
  /// 
  /// @param userId - User ID to cache quests for
  /// @param quests - List of UserMissionsRow to cache
  Future<bool> cacheQuestList({
    required String userId,
    required List<UserMissionsRow> quests,
  });

  /// Get cached active quest list
  /// Returns null if cache expired or not found
  /// 
  /// @param userId - User ID to retrieve cached quests for
  Future<List<UserMissionsRow>?> getCachedQuestList(String userId);

  /// Cache completed quest list
  Future<bool> cacheCompletedQuests({
    required String userId,
    required List<UserMissionsRow> quests,
  });

  /// Get cached completed quests
  Future<List<UserMissionsRow>?> getCachedCompletedQuests(String userId);

  /// Cache single quest details
  Future<bool> cacheQuestDetails({
    required String questId,
    required UserMissionsRow quest,
  });

  /// Get cached quest details
  Future<UserMissionsRow?> getCachedQuestDetails(String questId);

  // ============================================================================
  // USER PROFILE CACHING
  // ============================================================================

  /// Cache user profile
  /// Stores profile as JSON string with timestamp
  /// 
  /// @param profile - ProfilesRow to cache
  Future<bool> cacheUserProfile(ProfilesRow profile);

  /// Get cached user profile
  /// Returns null if cache expired or not found
  /// 
  /// @param userId - User ID to retrieve cached profile for
  Future<ProfilesRow?> getCachedUserProfile(String userId);

  /// Cache user statistics (XP, achievements, streak)
  Future<bool> cacheUserStats({
    required String userId,
    required Map<String, dynamic> stats,
  });

  /// Get cached user statistics
  Future<Map<String, dynamic>?> getCachedUserStats(String userId);

  // ============================================================================
  // ACHIEVEMENT CACHING
  // ============================================================================

  /// Cache achievement list for user
  Future<bool> cacheAchievements({
    required String userId,
    required List<UserAchievementsRow> achievements,
  });

  /// Get cached achievements
  Future<List<UserAchievementsRow>?> getCachedAchievements(String userId);

  /// Cache achievement progress (for specific achievement)
  Future<bool> cacheAchievementProgress({
    required String userId,
    required String achievementId,
    required int progress,
  });

  /// Get cached achievement progress
  Future<int?> getCachedAchievementProgress({
    required String userId,
    required String achievementId,
  });

  // ============================================================================
  // LEADERBOARD CACHING
  // ============================================================================

  /// Cache global leaderboard
  Future<bool> cacheLeaderboard(List<Map<String, dynamic>> leaderboard);

  /// Get cached leaderboard
  Future<List<Map<String, dynamic>>?> getCachedLeaderboard();

  /// Cache XP leaderboard (specific variant)
  Future<bool> cacheXpLeaderboard(List<Map<String, dynamic>> leaderboard);

  /// Get cached XP leaderboard
  Future<List<Map<String, dynamic>>?> getCachedXpLeaderboard();

  // ============================================================================
  // STATIC ASSETS CACHING
  // ============================================================================

  /// Cache map assets (image paths, static data)
  Future<bool> cacheMapAssets(Map<String, dynamic> mapData);

  /// Get cached map assets
  Future<Map<String, dynamic>?> getCachedMapAssets();

  // ============================================================================
  // CACHE VALIDATION & EXPIRATION
  // ============================================================================

  /// Check if cache is still valid (not expired)
  /// Compares cached timestamp with current time and TTL
  /// 
  /// @param key - Cache key to check
  /// @param ttl - Time-to-live duration (defaults to 5 minutes)
  /// @return true if cache exists and not expired
  // ignore: unused_element
  Future<bool> _isCacheValid(String key);

  /// Get timestamp for cache key
  /// Returns DateTime when cache was last updated
  // ignore: unused_element
  Future<DateTime?> _getCacheTimestamp(String key);

  /// Set timestamp for cache key
  /// Stores current DateTime as milliseconds since epoch
  // ignore: unused_element
  Future<bool> _setCacheTimestamp(String key);

  /// Check how old cache is
  /// Returns duration since last cache update
  Future<Duration?> getCacheAge(String key);

  /// Check if cache exists (regardless of expiration)
  Future<bool> hasCachedData(String key);

  // ============================================================================
  // CACHE INVALIDATION
  // ============================================================================

  /// Clear all cached data
  /// Removes all cache entries from SharedPreferences
  Future<bool> clearCache();

  /// Clear cache for specific key
  /// Removes both data and timestamp
  Future<bool> clearCacheKey(String key);

  /// Clear user-specific caches
  /// Removes all cache entries for a specific user
  /// (profile, quests, achievements)
  Future<bool> clearUserCache(String userId);

  /// Clear quest cache for user
  Future<bool> clearQuestCache(String userId);

  /// Clear achievement cache for user
  Future<bool> clearAchievementCache(String userId);

  /// Invalidate expired caches
  /// Removes all cache entries past their TTL
  /// Should be called periodically or on app start
  Future<int> pruneExpiredCaches();

  // ============================================================================
  // GENERIC CACHE OPERATIONS
  // ============================================================================

  /// Generic method to save data to cache
  /// Stores any JSON-serializable object with timestamp
  /// 
  /// @param key - Cache key
  /// @param data - Data to cache (must be JSON-serializable)
  Future<bool> saveToCache(String key, dynamic data);

  /// Generic method to get data from cache
  /// Returns null if not found or expired
  /// 
  /// @param key - Cache key
  /// @param ttl - Time-to-live duration
  Future<dynamic> getFromCache(String key, {Duration? ttl});

  /// Save raw string to cache
  Future<bool> saveString(String key, String value);

  /// Get raw string from cache
  Future<String?> getString(String key);

  /// Save integer to cache
  Future<bool> saveInt(String key, int value);

  /// Get integer from cache
  Future<int?> getInt(String key);

  /// Save boolean to cache
  Future<bool> saveBool(String key, bool value);

  /// Get boolean from cache
  Future<bool?> getBool(String key);

  // ============================================================================
  // CACHE STATISTICS & DEBUGGING
  // ============================================================================

  /// Get total cache size (approximate)
  /// Returns number of cached keys
  Future<int> getCacheSize();

  /// Get all cache keys
  /// Useful for debugging
  Future<List<String>> getAllCacheKeys();

  /// Get cache statistics
  /// Returns map with cache info (size, oldest entry, etc.)
  Future<Map<String, dynamic>> getCacheStats();

  /// Export cache data (for debugging)
  /// Returns all cached data as JSON
  Future<Map<String, dynamic>> exportCache();

  // ============================================================================
  // OFFLINE INDICATOR
  // ============================================================================

  /// Get last successful sync timestamp
  /// Used to show "Last synced X mins ago" in UI
  Future<DateTime?> getLastSyncTime();

  /// Update last sync timestamp
  /// Called after successful data fetch from Supabase
  Future<bool> updateLastSyncTime();

  /// Get time since last sync
  /// Returns human-readable string like "2 mins ago"
  String getTimeSinceLastSync();

  // ============================================================================
  // SERIALIZATION HELPERS (Private)
  // ============================================================================

  /// Serialize object to JSON string
  /// Handles encoding errors gracefully
  // ignore: unused_element
  String _toJson(dynamic object);

  /// Deserialize JSON string to object
  /// Returns null if parsing fails
  // ignore: unused_element
  dynamic _fromJson(String jsonString);

  /// Serialize list to JSON array string
  // ignore: unused_element
  String _listToJson(List<dynamic> list);

  /// Deserialize JSON array string to list
  // ignore: unused_element
  List<dynamic>? _jsonToList(String jsonString);
}
