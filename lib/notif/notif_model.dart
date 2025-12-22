import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/mail_div/mail_div_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'notif_widget.dart' show NotifWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotifModel extends FlutterFlowModel<NotifWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for mailDiv dynamic component.
  late FlutterFlowDynamicModels<MailDivModel> mailDivModels1;
  // Models for mailDiv dynamic component.
  late FlutterFlowDynamicModels<MailDivModel> mailDivModels2;

  @override
  void initState(BuildContext context) {
    mailDivModels1 = FlutterFlowDynamicModels(() => MailDivModel());
    mailDivModels2 = FlutterFlowDynamicModels(() => MailDivModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    mailDivModels1.dispose();
    mailDivModels2.dispose();
  }
}
