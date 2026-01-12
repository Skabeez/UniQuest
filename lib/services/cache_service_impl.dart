import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cache_service.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';

/// Concrete implementation of CacheService using SharedPreferences
class CacheServiceImpl extends CacheService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  @override
  bool get isInitialized => _initialized;

  // Quest methods with UserMissionsRow
  @override
  Future<bool> cacheQuestList(
      {required String userId, required List<UserMissionsRow> quests}) async {
    return await _prefs.setString('${CacheService.keyQuestsActive}$userId',
        jsonEncode(quests.map((q) => q.data).toList()));
  }

  @override
  Future<List<UserMissionsRow>?> getCachedQuestList(String userId) async {
    final data = _prefs.getString('${CacheService.keyQuestsActive}$userId');
    if (data == null) return null;
    final list = List<Map<String, dynamic>>.from(jsonDecode(data));
    return list.map((json) => UserMissionsRow(json)).toList();
  }

  @override
  Future<bool> cacheCompletedQuests(
      {required String userId, required List<UserMissionsRow> quests}) async {
    return await _prefs.setString('${CacheService.keyQuestsCompleted}$userId',
        jsonEncode(quests.map((q) => q.data).toList()));
  }

  @override
  Future<List<UserMissionsRow>?> getCachedCompletedQuests(String userId) async {
    final data = _prefs.getString('${CacheService.keyQuestsCompleted}$userId');
    if (data == null) return null;
    final list = List<Map<String, dynamic>>.from(jsonDecode(data));
    return list.map((json) => UserMissionsRow(json)).toList();
  }

  @override
  Future<bool> cacheQuestDetails(
      {required String questId, required UserMissionsRow quest}) async {
    return await _prefs.setString(
        '${CacheService.keyQuestDetails}$questId', jsonEncode(quest.data));
  }

  @override
  Future<UserMissionsRow?> getCachedQuestDetails(String questId) async {
    final data = _prefs.getString('${CacheService.keyQuestDetails}$questId');
    if (data == null) return null;
    return UserMissionsRow(Map<String, dynamic>.from(jsonDecode(data)));
  }

  // Profile methods
  @override
  Future<bool> cacheUserProfile(ProfilesRow profile) async {
    return await _prefs.setString('${CacheService.keyUserProfile}${profile.id}',
        jsonEncode(profile.data));
  }

  @override
  Future<ProfilesRow?> getCachedUserProfile(String userId) async {
    final data = _prefs.getString('${CacheService.keyUserProfile}$userId');
    if (data == null) return null;
    return ProfilesRow(Map<String, dynamic>.from(jsonDecode(data)));
  }

  @override
  Future<bool> cacheUserStats(
      {required String userId, required Map<String, dynamic> stats}) async {
    return await _prefs.setString(
        '${CacheService.keyUserStats}$userId', jsonEncode(stats));
  }

  @override
  Future<Map<String, dynamic>?> getCachedUserStats(String userId) async {
    final data = _prefs.getString('${CacheService.keyUserStats}$userId');
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  // Achievement methods
  @override
  Future<bool> cacheAchievements(
      {required String userId,
      required List<UserAchievementsRow> achievements}) async {
    return await _prefs.setString('${CacheService.keyAchievements}$userId',
        jsonEncode(achievements.map((a) => a.data).toList()));
  }

  @override
  Future<List<UserAchievementsRow>?> getCachedAchievements(
      String userId) async {
    final data = _prefs.getString('${CacheService.keyAchievements}$userId');
    if (data == null) return null;
    final list = List<Map<String, dynamic>>.from(jsonDecode(data));
    return list.map((json) => UserAchievementsRow(json)).toList();
  }

  @override
  Future<bool> cacheAchievementProgress(
      {required String userId,
      required String achievementId,
      required int progress}) async {
    return await _prefs.setString(
        '${CacheService.keyAchievementProgress}${userId}_$achievementId',
        progress.toString());
  }

  @override
  Future<int?> getCachedAchievementProgress(
      {required String userId, required String achievementId}) async {
    final data = _prefs.getString(
        '${CacheService.keyAchievementProgress}${userId}_$achievementId');
    return data != null ? int.tryParse(data) : null;
  }

  // Leaderboard methods
  @override
  Future<bool> cacheLeaderboard(List<Map<String, dynamic>> leaderboard) async {
    return await _prefs.setString(
        CacheService.keyLeaderboard, jsonEncode(leaderboard));
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedLeaderboard() async {
    final data = _prefs.getString(CacheService.keyLeaderboard);
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  @override
  Future<bool> cacheXpLeaderboard(
      List<Map<String, dynamic>> leaderboard) async {
    return await _prefs.setString(
        CacheService.keyLeaderboardXp, jsonEncode(leaderboard));
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedXpLeaderboard() async {
    final data = _prefs.getString(CacheService.keyLeaderboardXp);
    if (data == null) return null;
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // Static assets
  @override
  Future<bool> cacheMapAssets(Map<String, dynamic> mapData) async {
    return await _prefs.setString(
        CacheService.keyMapAssets, jsonEncode(mapData));
  }

  @override
  Future<Map<String, dynamic>?> getCachedMapAssets() async {
    final data = _prefs.getString(CacheService.keyMapAssets);
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  // Cache validation (private methods - stubs)
  // ignore: unused_element
  Future<bool> _isCacheValid(String key) async {
    return hasCachedData(key);
  }

  // ignore: unused_element
  Future<DateTime?> _getCacheTimestamp(String key) async {
    final timestamp = _prefs.getInt('${key}_timestamp');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // ignore: unused_element
  Future<bool> _setCacheTimestamp(String key) async {
    return await _prefs.setInt(
        '${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<Duration?> getCacheAge(String key) async {
    final timestamp = await _getCacheTimestamp(key);
    return timestamp != null ? DateTime.now().difference(timestamp) : null;
  }

  @override
  Future<bool> hasCachedData(String key) async {
    return _prefs.containsKey(key);
  }

  // Cache invalidation
  @override
  Future<bool> clearCache() async {
    return await _prefs.clear();
  }

  @override
  Future<bool> clearCacheKey(String key) async {
    return await _prefs.remove(key);
  }

  @override
  Future<bool> clearUserCache(String userId) async {
    await clearQuestCache(userId);
    await _prefs.remove('${CacheService.keyUserProfile}$userId');
    await clearAchievementCache(userId);
    await _prefs.remove('${CacheService.keyUserStats}$userId');
    return true;
  }

  @override
  Future<bool> clearQuestCache(String userId) async {
    await _prefs.remove('${CacheService.keyQuestsActive}$userId');
    await _prefs.remove('${CacheService.keyQuestsCompleted}$userId');
    return true;
  }

  @override
  Future<bool> clearAchievementCache(String userId) async {
    await _prefs.remove('${CacheService.keyAchievements}$userId');
    return true;
  }

  @override
  Future<int> pruneExpiredCaches() async {
    return 0;
  }

  // Generic cache operations
  @override
  Future<bool> saveToCache(String key, dynamic data) async {
    return await _prefs.setString(key, jsonEncode(data));
  }

  @override
  Future<dynamic> getFromCache(String key, {Duration? ttl}) async {
    final data = _prefs.getString(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  @override
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  // Cache statistics
  @override
  Future<int> getCacheSize() async {
    return _prefs.getKeys().length;
  }

  @override
  Future<List<String>> getAllCacheKeys() async {
    return _prefs.getKeys().toList();
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return {
      'totalKeys': _prefs.getKeys().length,
      'isInitialized': _initialized,
    };
  }

  @override
  Future<Map<String, dynamic>> exportCache() async {
    final Map<String, dynamic> export = {};
    for (final key in _prefs.getKeys()) {
      export[key] = _prefs.get(key);
    }
    return export;
  }

  // Offline indicator
  @override
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = _prefs.getInt('last_sync_timestamp');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  @override
  Future<bool> updateLastSyncTime() async {
    return await _prefs.setInt(
        'last_sync_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  String getTimeSinceLastSync() {
    // Synchronous version (reads cached value)
    final timestamp = _prefs.getInt('last_sync_timestamp');
    if (timestamp == null) return 'Never synced';

    final lastSync = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final diff = DateTime.now().difference(lastSync);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  // Serialization helpers (private - stubs)
  // ignore: unused_element
  String _toJson(dynamic object) => jsonEncode(object);

  // ignore: unused_element
  dynamic _fromJson(String jsonString) => jsonDecode(jsonString);

  // ignore: unused_element
  String _listToJson(List<dynamic> list) => jsonEncode(list);

  // ignore: unused_element
  List<dynamic>? _jsonToList(String jsonString) {
    try {
      return List<dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      return null;
    }
  }
}
