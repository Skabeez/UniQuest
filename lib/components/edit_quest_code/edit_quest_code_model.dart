import '/flutter_flow/flutter_flow_util.dart';
import 'edit_quest_code_widget.dart' show EditQuestCodeWidget;
import 'package:flutter/material.dart';

class EditQuestCodeModel extends FlutterFlowModel<EditQuestCodeWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for code widget.
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;
  String? Function(BuildContext, String?)? codeTextControllerValidator;

  // State field(s) for locationHint widget.
  FocusNode? locationHintFocusNode;
  TextEditingController? locationHintTextController;
  String? Function(BuildContext, String?)? locationHintTextControllerValidator;

  // State field(s) for isActive switch widget.
  bool? isActiveValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codeFocusNode?.dispose();
    codeTextController?.dispose();

    locationHintFocusNode?.dispose();
    locationHintTextController?.dispose();
  }
}
