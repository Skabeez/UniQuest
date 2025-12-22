import '/backend/supabase/supabase.dart';
import '/components/cosmetic_div/cosmetic_div_widget.dart';
import '/components/namecard_div/namecard_div_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'cosmetics_list_widget.dart' show CosmeticsListWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CosmeticsListModel extends FlutterFlowModel<CosmeticsListWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for cosmeticDiv dynamic component.
  late FlutterFlowDynamicModels<CosmeticDivModel> cosmeticDivModels1;
  // Models for cosmeticDiv dynamic component.
  late FlutterFlowDynamicModels<CosmeticDivModel> cosmeticDivModels2;
  // Models for namecardDiv dynamic component.
  late FlutterFlowDynamicModels<NamecardDivModel> namecardDivModels;

  @override
  void initState(BuildContext context) {
    cosmeticDivModels1 = FlutterFlowDynamicModels(() => CosmeticDivModel());
    cosmeticDivModels2 = FlutterFlowDynamicModels(() => CosmeticDivModel());
    namecardDivModels = FlutterFlowDynamicModels(() => NamecardDivModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    cosmeticDivModels1.dispose();
    cosmeticDivModels2.dispose();
    namecardDivModels.dispose();
  }
}
