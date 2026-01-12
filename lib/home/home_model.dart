import '/components/mission/mission_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/backend/services/mission_service.dart';
import '/backend/supabase/database/database.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Service layer instances (Clean Architecture)
  final MissionService _missionService = MissionService();

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Categories horizontal scroll
  ScrollController? categoriesScrollController;
  double categoriesScrollOffset = 0.0;

  // Models for mission dynamic component.
  late FlutterFlowDynamicModels<MissionModel> missionModels;

  // Cached missions data
  List<UserMissionsRow>? _cachedMissions;
  // ignore: unused_field
  bool _isLoadingMissions = false;
  // ignore: unused_field
  String? _missionsError;

  /// Get active missions using service layer (Facade Pattern)
  Future<List<UserMissionsRow>> getActiveMissions() async {
    if (_isLoadingMissions && _cachedMissions != null) {
      return _cachedMissions!;
    }

    _isLoadingMissions = true;
    final result = await _missionService.getActiveMissions();

    result.onSuccess((missions) {
      _cachedMissions = missions;
      _missionsError = null;
    }).onFailure((error) {
      _missionsError = error;
      print('Error loading missions: $error');
    });

    _isLoadingMissions = false;

    // Return cached data even if there's an error (offline support)
    return _cachedMissions ?? [];
  }

  /// Check if there's an error message to display
  String? get missionsError => _missionsError;

  /// Clear cached missions (for refresh)
  void clearMissionsCache() {
    _cachedMissions = null;
    _missionsError = null;
  }

  @override
  void initState(BuildContext context) {
    categoriesScrollController = ScrollController();
    missionModels = FlutterFlowDynamicModels(() => MissionModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    categoriesScrollController?.dispose();
    missionModels.dispose();
  }
}
