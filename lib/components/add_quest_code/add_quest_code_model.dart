import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_quest_code_widget.dart' show AddQuestCodeWidget;
import 'package:flutter/material.dart';

class AddQuestCodeModel extends FlutterFlowModel<AddQuestCodeWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for questId widget.
  String? questIdValue;
  FormFieldController<String>? questIdValueController;

  // State field(s) for code widget.
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;
  String? Function(BuildContext, String?)? codeTextControllerValidator;

  // State field(s) for locationHint widget.
  FocusNode? locationHintFocusNode;
  TextEditingController? locationHintTextController;
  String? Function(BuildContext, String?)? locationHintTextControllerValidator;

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
