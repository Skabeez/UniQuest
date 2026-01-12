import '/components/leader_div/leader_div_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'leaderboard_widget.dart' show LeaderboardWidget;
import 'package:flutter/material.dart';
import 'package:uni_quest/services/cache_service_impl.dart';
import 'dart:async';

class LeaderboardModel extends FlutterFlowModel<LeaderboardWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for leaderDiv dynamic component.
  late FlutterFlowDynamicModels<LeaderDivModel> leaderDivModels1;
  // Models for leaderDiv dynamic component.
  late FlutterFlowDynamicModels<LeaderDivModel> leaderDivModels2;
  // Models for leaderDiv dynamic component.
  late FlutterFlowDynamicModels<LeaderDivModel> leaderDivModels3;
  // Models for leaderDiv dynamic component.
  late FlutterFlowDynamicModels<LeaderDivModel> leaderDivModels4;
  // Models for leaderDiv dynamic component.
  late FlutterFlowDynamicModels<LeaderDivModel> leaderDivModels5;

  // ============================================================================
  // OFFLINE ARCHITECTURE - Leaderboard
  // ============================================================================

  // Services
  final CacheServiceImpl _cacheService = CacheServiceImpl();

  // Local state for leaderboard data
  List<Map<String, dynamic>>? _xpLeaderboard;
  List<Map<String, dynamic>>? _achievementLeaderboard;
  List<Map<String, dynamic>>? _streakLeaderboard;
  bool _isLoadingLeaderboard = false;
  bool _isShowingCachedData = false;
  String? _lastError;
  Timer? _autoRefreshTimer;

  // Getters for UI
  List<Map<String, dynamic>> get xpLeaderboard => _xpLeaderboard ?? [];
  List<Map<String, dynamic>> get achievementLeaderboard =>
      _achievementLeaderboard ?? [];
  List<Map<String, dynamic>> get streakLeaderboard => _streakLeaderboard ?? [];
  bool get isLoadingLeaderboard => _isLoadingLeaderboard;
  bool get isShowingCachedData => _isShowingCachedData;
  bool get isOnline => true; // Online-first mode
  String? get lastError => _lastError;

  // ============================================================================
  // READ OPERATIONS (with offline support)
  // ============================================================================

  /// Load XP leaderboard
  /// Automatically uses cache if offline
  /// Leaderboard has short TTL (1 minute) due to frequent updates
  Future<void> loadXpLeaderboard() async {
    _isLoadingLeaderboard = true;
    _lastError = null;
    _isShowingCachedData = false;

    try {
      if (isOnline) {
        // Online - fetch from Supabase
        // TODO: Replace with repository call when implemented
        // final result = await _leaderboardRepository.getXpLeaderboard();

        // For now, simulate the pattern
        // _xpLeaderboard = await fetchFromSupabase();
        // await _cacheService.cacheXpLeaderboard(_xpLeaderboard!);

        _isShowingCachedData = false;
      } else {
        // Offline - load from cache
        await _loadXpLeaderboardFromCache();
        _isShowingCachedData = true;
        _lastError = 'Showing cached leaderboard - you are offline';
      }
    } catch (e) {
      // Fallback to cache on error
      await _loadXpLeaderboardFromCache();
      _isShowingCachedData = true;
      _lastError = 'Using cached leaderboard due to connection error';
    } finally {
      _isLoadingLeaderboard = false;
    }
  }

  /// Load achievement leaderboard
  Future<void> loadAchievementLeaderboard() async {
    _isLoadingLeaderboard = true;
    _lastError = null;

    try {
      if (isOnline) {
        // Online - fetch fresh data
        // Implement with repository
        _isShowingCachedData = false;
      } else {
        // Offline - show cached
        await _loadAchievementLeaderboardFromCache();
        _isShowingCachedData = true;
        _lastError = 'Showing cached data - you are offline';
      }
    } catch (e) {
      await _loadAchievementLeaderboardFromCache();
      _isShowingCachedData = true;
      _lastError = 'Using cached data';
    } finally {
      _isLoadingLeaderboard = false;
    }
  }

  /// Load streak leaderboard
  Future<void> loadStreakLeaderboard() async {
    _isLoadingLeaderboard = true;
    _lastError = null;

    try {
      if (isOnline) {
        // Online - fetch fresh data
        _isShowingCachedData = false;
      } else {
        // Offline - show cached
        await _loadStreakLeaderboardFromCache();
        _isShowingCachedData = true;
        _lastError = 'Showing cached data - you are offline';
      }
    } catch (e) {
      await _loadStreakLeaderboardFromCache();
      _isShowingCachedData = true;
      _lastError = 'Using cached data';
    } finally {
      _isLoadingLeaderboard = false;
    }
  }

  /// Refresh leaderboard (pull-to-refresh)
  /// Only works when online
  Future<void> refreshLeaderboard() async {
    if (!isOnline) {
      _lastError = 'Cannot refresh while offline';
      return;
    }

    await loadXpLeaderboard();
    await loadAchievementLeaderboard();
    await loadStreakLeaderboard();
  }

  // ============================================================================
  // AUTO-REFRESH (leaderboard updates frequently)
  // ============================================================================

  /// Start auto-refresh timer
  /// Refreshes leaderboard every 30 seconds when online
  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isOnline) {
        refreshLeaderboard();
      }
    });
  }

  /// Stop auto-refresh timer
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  // ============================================================================
  // CACHE FALLBACK METHODS (private)
  // ============================================================================

  Future<void> _loadXpLeaderboardFromCache() async {
    final cached = await _cacheService.getCachedXpLeaderboard();
    if (cached != null) {
      _xpLeaderboard = cached;
    } else {
      _xpLeaderboard = [];
      _lastError = 'No cached leaderboard available';
    }
  }

  Future<void> _loadAchievementLeaderboardFromCache() async {
    final cached = await _cacheService.getCachedLeaderboard();
    if (cached != null) {
      _achievementLeaderboard = cached;
    } else {
      _achievementLeaderboard = [];
    }
  }

  Future<void> _loadStreakLeaderboardFromCache() async {
    final cached = await _cacheService.getCachedLeaderboard();
    if (cached != null) {
      _streakLeaderboard = cached;
    } else {
      _streakLeaderboard = [];
    }
  }

  // ============================================================================
  // CONNECTIVITY MONITORING
  // ============================================================================

  void startConnectivityMonitoring() {
    // Connectivity monitoring placeholder
  }

  @override
  void initState(BuildContext context) {
    leaderDivModels1 = FlutterFlowDynamicModels(() => LeaderDivModel());
    leaderDivModels2 = FlutterFlowDynamicModels(() => LeaderDivModel());
    leaderDivModels3 = FlutterFlowDynamicModels(() => LeaderDivModel());
    leaderDivModels4 = FlutterFlowDynamicModels(() => LeaderDivModel());
    leaderDivModels5 = FlutterFlowDynamicModels(() => LeaderDivModel());

    // Initialize services
    _cacheService.initialize();

    // Start monitoring
    startConnectivityMonitoring();
    startAutoRefresh();
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    leaderDivModels1.dispose();
    leaderDivModels2.dispose();
    leaderDivModels3.dispose();
    leaderDivModels4.dispose();
    leaderDivModels5.dispose();
    stopAutoRefresh();
  }
}
