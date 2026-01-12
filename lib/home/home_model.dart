import '/components/mission/mission_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
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
  double categoriesScrollOffset = 0.0;

  // Models for mission dynamic component.
  late FlutterFlowDynamicModels<MissionModel> missionModels;

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
