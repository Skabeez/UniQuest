import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'achievements_div_model.dart';
export 'achievements_div_model.dart';

class AchievementsDivWidget extends StatefulWidget {
  const AchievementsDivWidget({
    super.key,
    this.achievements,
  });

  final UserAchievementsRow? achievements;

  @override
  State<AchievementsDivWidget> createState() => _AchievementsDivWidgetState();
}

class _AchievementsDivWidgetState extends State<AchievementsDivWidget> {
  late AchievementsDivModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AchievementsDivModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent4,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Color(0xFFE0E3E7),
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valueOrDefault<String>(
                  widget!.achievements?.title,
                  'title',
                ),
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Feather',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget!.achievements?.description,
                    'none',
                  ),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Feather',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Divider(
                height: 24.0,
                thickness: 1.0,
                color: Color(0xFFE0E3E7),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Rewards:',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Feather',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget!.achievements?.rewardType,
                          'none',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Feather',
                              color: Color(0xFF827AE1),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
