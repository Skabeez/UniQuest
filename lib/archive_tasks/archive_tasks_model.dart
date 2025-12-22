import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/archive_task_div/archive_task_div_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'archive_tasks_widget.dart' show ArchiveTasksWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArchiveTasksModel extends FlutterFlowModel<ArchiveTasksWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for archiveTaskDiv dynamic component.
  late FlutterFlowDynamicModels<ArchiveTaskDivModel> archiveTaskDivModels;

  @override
  void initState(BuildContext context) {
    archiveTaskDivModels =
        FlutterFlowDynamicModels(() => ArchiveTaskDivModel());
  }

  @override
  void dispose() {
    archiveTaskDivModels.dispose();
  }
}
