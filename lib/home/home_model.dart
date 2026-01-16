import '/components/mission/mission_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/cache_service.dart';
import '/services/connectivity_service.dart';
import '/backend/supabase/supabase.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Categories horizontal scroll
  ScrollController? categoriesScrollController;

  // Models for mission dynamic component.
  late FlutterFlowDynamicModels<MissionModel> missionModels;

  // Services for caching and connectivity
  CacheService? _cacheService;
  final ConnectivityService _connectivityService = ConnectivityService();

  // Data state
  List<MissionsRow>? cachedMissions;
  bool isLoadingMissions = false;
  bool showOfflineWarning = false;

  @override
  void initState(BuildContext context) {
    // ScrollController removed - static navbar
    missionModels = FlutterFlowDynamicModels(() => MissionModel());
    _initializeCacheService();
  }

  /// Initialize cache service singleton
  Future<void> _initializeCacheService() async {
    _cacheService = await CacheService.getInstance();
  }

  // ============ READ OPERATIONS (WITH CACHE FALLBACK) ============

  /// Load missions with cache fallback when offline
  Future<List<MissionsRow>?> loadMissions() async {
    isLoadingMissions = true;

    try {
      // Try to fetch from server if connected
      if (await _connectivityService.isConnected()) {
        final missions = await MissionsTable().queryRows(
          queryFn: (q) => q.eq('is_active', true),
        );
        
        // Cache the fresh data
        if (_cacheService != null) {
          await _cacheService!.cacheMissions(missions);
        }
        
        cachedMissions = missions;
        isLoadingMissions = false;
        showOfflineWarning = false;
        return missions;
      } else {
        // Load from cache if offline
        final cached = await _cacheService?.getCachedMissions();
        if (cached != null && cached.isNotEmpty) {
          cachedMissions = cached;
          isLoadingMissions = false;
          showOfflineWarning = true;
          return cached;
        } else {
          throw Exception('No cached missions available offline');
        }
      }
    } catch (e) {
      isLoadingMissions = false;
      debugPrint('Error loading missions: $e');
      rethrow;
    }
  }

  // ============ WRITE OPERATIONS (REQUIRE CONNECTIVITY) ============

  /// Accept a mission (requires internet connection)
  Future<bool> acceptMission(String missionId) async {
    if (!await _connectivityService.isConnected()) {
      // Cannot perform write operations offline
      debugPrint('Cannot accept mission while offline');
      return false;
    }

    try {
      // Perform mission acceptance logic
      // TODO: Implement mission acceptance
      return true;
    } catch (e) {
      debugPrint('Error accepting mission: $e');
      return false;
    }
  }

  // ============ CACHE MANAGEMENT ============

  /// Check if cache is valid
  Future<bool> isMissionsCacheValid() async {
    if (_cacheService == null) return false;
    return await _cacheService!.isCacheValid('cache_missions');
  }

  /// Manually refresh data (force network fetch)
  Future<void> refreshData() async {
    if (!await _connectivityService.isConnected()) {
      throw Exception('Cannot refresh while offline');
    }
    
    // Clear cache and reload
    await _cacheService?.clearCacheKey('cache_missions');
    await loadMissions();
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    // ScrollController disposed
    missionModels.dispose();
  }
}
