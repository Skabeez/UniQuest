import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_quest_widget.dart' show AddQuestWidget;
import 'package:flutter/material.dart';

class AddQuestModel extends FlutterFlowModel<AddQuestWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;

  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // State field(s) for xp widget.
  FocusNode? xpFocusNode;
  TextEditingController? xpTextController;
  String? Function(BuildContext, String?)? xpTextControllerValidator;

  // State field(s) for difficulty widget.
  String? difficultyValue;
  FormFieldController<String>? difficultyValueController;

  // State field(s) for category widget.
  FocusNode? categoryFocusNode;
  TextEditingController? categoryTextController;
  String? Function(BuildContext, String?)? categoryTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    xpFocusNode?.dispose();
    xpTextController?.dispose();

    categoryFocusNode?.dispose();
    categoryTextController?.dispose();
  }
}
