import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'view_mission_model.dart';
export 'view_mission_model.dart';

class ViewMissionWidget extends StatefulWidget {
  const ViewMissionWidget({
    super.key,
    required this.userMission,
  });

  final UserMissionsRow userMission;

  @override
  State<ViewMissionWidget> createState() => _ViewMissionWidgetState();
}

class _ViewMissionWidgetState extends State<ViewMissionWidget> {
  late ViewMissionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewMissionModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MissionsRow>>(
      future: MissionsTable().queryRows(
        queryFn: (q) => q.eqOrNull('mission_id', widget.userMission.missionId),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(48.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        
        final mission = snapshot.data!.first;
        final progress = widget.userMission.progress ?? 0;
        final targetValue = mission.targetValue;
        final progressPercent = targetValue > 0 
            ? (progress / targetValue).clamp(0.0, 1.0) 
            : 0.0;
        final isCompleted = widget.userMission.completed ?? false;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Status badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? const Color(0xFF39D2C0).withOpacity(0.2)
                            : const Color(0xFFFFBD59).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isCompleted 
                              ? const Color(0xFF39D2C0)
                              : const Color(0xFFFFBD59),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Feather',
                              color: isCompleted 
                                  ? const Color(0xFF39D2C0)
                                  : const Color(0xFFFFBD59),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Mission title
                Text(
                  widget.userMission.missionTitle ?? mission.title,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Feather',
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                // Mission description
                Text(
                  widget.userMission.missionDescription ?? mission.description ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Feather',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                const SizedBox(height: 24.0),
                // Progress section
                Text(
                  'Progress',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Feather',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12.0),
                // Progress bar
                Container(
                  width: double.infinity,
                  height: 12.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progressPercent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCompleted 
                                ? const Color(0xFF39D2C0)
                                : const Color(0xFFFFBD59),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                // Progress text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$progress / $targetValue',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Feather',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      '${(progressPercent * 100).toInt()}%',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Feather',
                            color: isCompleted 
                                ? const Color(0xFF39D2C0)
                                : const Color(0xFFFFBD59),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                // Reward section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFBD59).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFBD59),
                          size: 28.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reward',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Feather',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                          ),
                          Text(
                            '+${mission.rewardPoints} XP',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Feather',
                                  color: const Color(0xFFFFBD59),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                // Close button
                FFButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  text: 'Close',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).alternate,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Feather',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
