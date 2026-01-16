import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
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

  String _formatReward(String? rewardType) {
    final normalized = (rewardType ?? '').trim();
    if (normalized.isEmpty) {
      return 'XP';
    }
    return normalized.toUpperCase();
  }

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
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF3E8),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFE8DAC8),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0.0, 6.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valueOrDefault<String>(
                  widget.achievements?.title,
                  'title',
                ),
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Feather',
                      color: const Color(0xFF2A2E3A),
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.achievements?.description,
                    'none',
                  ),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFF6B6B6B),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Divider(
                height: 24.0,
                thickness: 1.0,
                color: Color(0xFFE6E6E6),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10.0, 6.0, 10.0, 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBD59),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '+${_formatReward(widget.achievements?.rewardType)}',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Feather',
                            color: const Color(0xFF1E1E1E),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
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
