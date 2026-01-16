import '/flutter_flow/flutter_flow_util.dart';
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
  
  // State field(s) for xpReward widget.
  FocusNode? xpRewardFocusNode;
  TextEditingController? xpRewardTextController;
  String? Function(BuildContext, String?)? xpRewardTextControllerValidator;
  
  // State field(s) for verificationCode widget.
  FocusNode? verificationCodeFocusNode;
  TextEditingController? verificationCodeTextController;
  String? Function(BuildContext, String?)? verificationCodeTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    xpRewardFocusNode?.dispose();
    xpRewardTextController?.dispose();

    verificationCodeFocusNode?.dispose();
    verificationCodeTextController?.dispose();
  }
}
