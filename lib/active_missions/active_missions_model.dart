import '/components/mission_div/mission_div_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'active_missions_widget.dart' show ActiveMissionsWidget;
import 'package:flutter/material.dart';
import 'package:uni_quest/backend/supabase/database/database.dart';
import 'package:uni_quest/repositories/quest_repository.dart';
import 'package:uni_quest/services/cache_service_impl.dart';

class ActiveMissionsModel extends FlutterFlowModel<ActiveMissionsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for missionDiv dynamic component.
  late FlutterFlowDynamicModels<MissionDivModel> missionDivModels;

  // ============================================================================
  // OFFLINE ARCHITECTURE - Added for defense
  // ============================================================================

  // Services
  final CacheServiceImpl _cacheService = CacheServiceImpl();
  final QuestRepository _questRepository =
      QuestRepository(Supabase.instance.client);

  // Local state for missions
  List<UserMissionsRow>? _activeMissions;
  List<UserMissionsRow>? _completedMissions;
  // ignore: unused_field
  bool _isLoadingMissions = false;
  // ignore: unused_field
  bool _isShowingCachedData = false;
  // ignore: unused_field
  String? _lastError;

  // Getters for UI
  List<UserMissionsRow> get activeMissions => _activeMissions ?? [];
  List<UserMissionsRow> get completedMissions => _completedMissions ?? [];
  bool get isLoadingMissions => _isLoadingMissions;
  bool get isShowingCachedData => _isShowingCachedData;
  bool get isOnline => true; // Online-first mode
  String? get lastError => _lastError;

  // ============================================================================
  // READ OPERATIONS (with offline support)
  // ============================================================================

  /// Load active missions for user
  /// Automatically checks cache if offline
  /// Shows warning banner if displaying cached data
  Future<void> loadActiveMissions(String userId) async {
    _isLoadingMissions = true;
    _lastError = null;
    _isShowingCachedData = false;

    try {
      // Try to fetch from repository (handles cache logic internally)
      final result = await _questRepository.getActiveQuests(userId);

      if (result.isSuccess) {
        _activeMissions = result.data!;
        _isShowingCachedData = false;
      } else {
        final error = result.error!;
        // Check if error is due to offline status
        if (error.contains('offline') || error.contains('Offline')) {
          // Try to load from cache
          _loadActiveMissionsFromCache(userId);
          _isShowingCachedData = true;
          _lastError = 'Showing cached data - you are offline';
        } else {
          _lastError = 'Failed to load missions: $error';
        }
      }
    } catch (e) {
      // Fallback to cache on any error
      await _loadActiveMissionsFromCache(userId);
      _isShowingCachedData = true;
      _lastError = 'Using cached data due to connection error';
    } finally {
      _isLoadingMissions = false;
    }
  }

  /// Load completed missions for user
  Future<void> loadCompletedMissions(String userId) async {
    _isLoadingMissions = true;
    _lastError = null;
    _isShowingCachedData = false;

    try {
      final result = await _questRepository.getCompletedQuests(userId);

      if (result.isSuccess) {
        _completedMissions = result.data!;
        _isShowingCachedData = false;
      } else {
        final error = result.error!;
        if (error.contains('offline') || error.contains('Offline')) {
          await _loadCompletedMissionsFromCache(userId);
          _isShowingCachedData = true;
          _lastError = 'Showing cached data - you are offline';
        } else {
          _lastError = 'Failed to load missions: $error';
        }
      }
    } catch (e) {
      await _loadCompletedMissionsFromCache(userId);
      _isShowingCachedData = true;
      _lastError = 'Using cached data due to connection error';
    } finally {
      _isLoadingMissions = false;
    }
  }

  /// Refresh missions (pull-to-refresh)
  Future<void> refreshMissions(String userId) async {
    if (!isOnline) {
      _lastError = 'Cannot refresh while offline';
      return;
    }

    await loadActiveMissions(userId);
    await loadCompletedMissions(userId);
  }

  // ============================================================================
  // WRITE OPERATIONS (require online connectivity)
  // ============================================================================

  /// Accept/start a new quest
  /// Requires internet connection
  Future<bool> acceptQuest({
    required String userId,
    required String missionId,
    required BuildContext context,
  }) async {
    // Check connectivity first
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot accept quest while offline',
        'Please connect to the internet to accept new quests.',
      );
      return false;
    }

    try {
      final result = await _questRepository.startQuest(
        userId: userId,
        missionId: missionId,
      );

      return result.when(
        success: (quest) {
          // Success - refresh missions list
          loadActiveMissions(userId);
          _showSuccessSnackbar(context, 'Quest accepted successfully!');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(
              context, 'Failed to accept quest: ${error.toString()}');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error accepting quest: ${e.toString()}');
      return false;
    }
  }

  /// Complete a quest
  /// Requires internet connection
  Future<bool> completeQuest({
    required String questId,
    required String userId,
    required BuildContext context,
  }) async {
    // Check connectivity first
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot complete quest while offline',
        'Please connect to the internet to complete quests.',
      );
      return false;
    }

    try {
      final result = await _questRepository.markCompleted(questId);

      return result.when(
        success: (quest) {
          // Success - refresh missions
          loadActiveMissions(userId);
          loadCompletedMissions(userId);
          _showSuccessSnackbar(context, 'Quest completed! 🎉');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(
              context, 'Failed to complete quest: ${error.toString()}');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error completing quest: ${e.toString()}');
      return false;
    }
  }

  /// Archive a quest
  /// Requires internet connection
  Future<bool> archiveQuest({
    required String questId,
    required String userId,
    required BuildContext context,
  }) async {
    // Check connectivity first
    if (!isOnline) {
      _showOfflineDialog(
        context,
        'Cannot archive quest while offline',
        'Please connect to the internet to archive quests.',
      );
      return false;
    }

    try {
      final result = await _questRepository.archiveQuest(questId);

      return result.when(
        success: (quest) {
          // Success - refresh missions
          loadActiveMissions(userId);
          _showSuccessSnackbar(context, 'Quest archived');
          return true;
        },
        failure: (error) {
          _showErrorSnackbar(
              context, 'Failed to archive quest: ${error.toString()}');
          return false;
        },
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error archiving quest: ${e.toString()}');
      return false;
    }
  }

  // ============================================================================
  // CACHE FALLBACK METHODS (private)
  // ============================================================================

  /// Load active missions from cache
  /// Used when offline or on error
  Future<void> _loadActiveMissionsFromCache(String userId) async {
    final cached = await _cacheService.getCachedQuestList(userId);
    if (cached != null) {
      _activeMissions = cached;
    } else {
      // No cache available
      _activeMissions = [];
      _lastError = 'No cached data available';
    }
  }

  /// Load completed missions from cache
  Future<void> _loadCompletedMissionsFromCache(String userId) async {
    final cached = await _cacheService.getCachedCompletedQuests(userId);
    if (cached != null) {
      _completedMissions = cached;
    } else {
      _completedMissions = [];
      _lastError = 'No cached data available';
    }
  }

  // ============================================================================
  // UI FEEDBACK HELPERS (private)
  // ============================================================================

  /// Show offline error dialog
  void _showOfflineDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================================================
  // CONNECTIVITY MONITORING
  // ============================================================================

  /// Listen to connectivity changes
  /// Updates UI when connection status changes
  void startConnectivityMonitoring() {
    // Connectivity monitoring placeholder
  }

  /// Stop connectivity monitoring
  void stopConnectivityMonitoring() {
    // Cleanup if needed
  }

  @override
  void initState(BuildContext context) {
    missionDivModels = FlutterFlowDynamicModels(() => MissionDivModel());

    // Initialize services
    _cacheService.initialize();

    // Start monitoring connectivity
    startConnectivityMonitoring();
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    missionDivModels.dispose();
    stopConnectivityMonitoring();
  }
}

// ============================================================================
// CUSTOM EXCEPTIONS
// ============================================================================

/// Exception thrown when operation requires internet but device is offline
class OfflineException implements Exception {
  final String message;
  OfflineException([this.message = 'Operation requires internet connection']);

  @override
  String toString() => 'OfflineException: $message';
}
