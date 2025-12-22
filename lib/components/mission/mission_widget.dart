import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'mission_model.dart';
export 'mission_model.dart';

class MissionWidget extends StatefulWidget {
  const MissionWidget({
    super.key,
    this.missionName,
    this.description,
    this.deadline,
    this.status,
  });

  final String? missionName;
  final String? description;
  final String? deadline;
  final String? status;

  @override
  State<MissionWidget> createState() => _MissionWidgetState();
}

class _MissionWidgetState extends State<MissionWidget> {
  late MissionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MissionModel());
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
      child: FutureBuilder<List<MissionsRow>>(
        future: MissionsTable().queryRows(
          queryFn: (q) => q,
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }
          final _ = snapshot.data!;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: const Color(0xFFE0E3E7),
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.missionName,
                      'name',
                    ),
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Feather',
                          color: const Color(0xFF0F1113),
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(
                    height: 24.0,
                    thickness: 1.0,
                    color: Color(0xFFE0E3E7),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        widget.description,
                        'details',
                      ),
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Feather',
                            color: const Color(0xFF57636C),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
