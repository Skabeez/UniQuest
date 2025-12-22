import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'edit_task_widget.dart' show EditTaskWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditTaskModel extends FlutterFlowModel<EditTaskWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for taskname widget.
  FocusNode? tasknameFocusNode;
  TextEditingController? tasknameTextController;
  String? Function(BuildContext, String?)? tasknameTextControllerValidator;
  // State field(s) for tags widget.
  FocusNode? tagsFocusNode;
  TextEditingController? tagsTextController;
  String? Function(BuildContext, String?)? tagsTextControllerValidator;
  // State field(s) for priority widget.
  String? priorityValue;
  FormFieldController<String>? priorityValueController;
  // State field(s) for notes widget.
  FocusNode? notesFocusNode;
  TextEditingController? notesTextController;
  String? Function(BuildContext, String?)? notesTextControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tasknameFocusNode?.dispose();
    tasknameTextController?.dispose();

    tagsFocusNode?.dispose();
    tagsTextController?.dispose();

    notesFocusNode?.dispose();
    notesTextController?.dispose();
  }
}
