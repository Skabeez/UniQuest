import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Cache Manager - Handles local data caching using Hive
/// Demonstrates:
/// - Strategy Pattern (different caching strategies)
/// - Singleton Pattern (single cache instance)
/// - Data Persistence Layer
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();

  factory CacheManager() => _instance;

  CacheManager._internal();

  Box? _cacheBox;
  bool _isInitialized = false;

  /// Initialize Hive cache
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocDir.path);
      _cacheBox = await Hive.openBox('uniquest_cache');
      _isInitialized = true;
      print('Cache Manager initialized');
    } catch (e) {
      print('Error initializing cache: $e');
      // Don't throw - app should work without cache
    }
  }

  /// Save data to cache with expiration
  Future<void> save(
    String key,
    dynamic data, {
    Duration? expiration,
  }) async {
    if (!_isInitialized || _cacheBox == null) {
      await initialize();
    }

    try {
      final cacheEntry = {
        'data': data is String ? data : jsonEncode(data),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiration': expiration?.inMilliseconds,
      };

      await _cacheBox!.put(key, cacheEntry);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  /// Get data from cache
  Future<T?> get<T>(String key) async {
    if (!_isInitialized || _cacheBox == null) {
      await initialize();
    }

    try {
      final cacheEntry = _cacheBox!.get(key);
      if (cacheEntry == null) return null;

      // Check expiration
      final timestamp = cacheEntry['timestamp'] as int?;
      final expiration = cacheEntry['expiration'] as int?;

      if (timestamp != null && expiration != null) {
        final age = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (age > expiration) {
          // Expired - remove it
          await delete(key);
          return null;
        }
      }

      final data = cacheEntry['data'];
      return data as T?;
    } catch (e) {
      print('Error getting from cache: $e');
      return null;
    }
  }

  /// Check if key exists in cache and is not expired
  Future<bool> has(String key) async {
    final data = await get(key);
    return data != null;
  }

  /// Delete specific cache entry
  Future<void> delete(String key) async {
    if (!_isInitialized || _cacheBox == null) return;

    try {
      await _cacheBox!.delete(key);
    } catch (e) {
      print('Error deleting from cache: $e');
    }
  }

  /// Clear all cache
  Future<void> clearAll() async {
    if (!_isInitialized || _cacheBox == null) return;

    try {
      await _cacheBox!.clear();
      print('Cache cleared');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Get cache size (number of entries)
  int get size => _cacheBox?.length ?? 0;

  /// Get all cached keys
  List<String> get keys =>
      _cacheBox?.keys.map((k) => k.toString()).toList() ?? [];
}

/// Cache key builder for consistent cache keys
class CacheKeys {
  static const String missions = 'missions';
  static const String tasks = 'tasks';
  static const String achievements = 'achievements';
  static const String profile = 'profile';
  static const String leaderboard = 'leaderboard';

  static String userMissions(String userId) => 'missions_$userId';
  static String userTasks(String userId) => 'tasks_$userId';
  static String userAchievements(String userId) => 'achievements_$userId';
  static String userProfile(String userId) => 'profile_$userId';
}
