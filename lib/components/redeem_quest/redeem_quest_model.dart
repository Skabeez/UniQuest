import '/flutter_flow/flutter_flow_util.dart';
import 'redeem_quest_widget.dart' show RedeemQuestWidget;
import 'package:flutter/material.dart';

class RedeemQuestModel extends FlutterFlowModel<RedeemQuestWidget> {
  /// State fields for stateful widgets in this component.

  // State field(s) for codeField widget.
  FocusNode? codeFieldFocusNode;
  TextEditingController? codeFieldTextController;
  String? Function(BuildContext, String?)? codeFieldTextControllerValidator;

  // Loading state
  bool isLoading = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codeFieldFocusNode?.dispose();
    codeFieldTextController?.dispose();
  }
}
