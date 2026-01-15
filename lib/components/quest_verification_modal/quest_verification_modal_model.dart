import '/flutter_flow/flutter_flow_util.dart';
import 'quest_verification_modal_widget.dart'
    show QuestVerificationModalWidget;
import 'package:flutter/material.dart';

class QuestVerificationModalModel
    extends FlutterFlowModel<QuestVerificationModalWidget> {
  late TextEditingController codeController;
  bool isLoading = false;
  String? errorMessage;
  bool showSuccess = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codeController.dispose();
  }
}
