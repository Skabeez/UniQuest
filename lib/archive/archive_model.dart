import '/backend/supabase/supabase.dart';
import '/components/mission_div/mission_div_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'archive_widget.dart' show ArchiveWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArchiveModel extends FlutterFlowModel<ArchiveWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for missionDiv dynamic component.
  late FlutterFlowDynamicModels<MissionDivModel> missionDivModels;

  @override
  void initState(BuildContext context) {
    missionDivModels = FlutterFlowDynamicModels(() => MissionDivModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    missionDivModels.dispose();
  }
}
