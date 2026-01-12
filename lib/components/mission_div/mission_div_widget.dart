import '/backend/supabase/supabase.dart';
import '/components/edit_mission/edit_mission_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mission_div_model.dart';
export 'mission_div_model.dart';

class MissionDivWidget extends StatefulWidget {
  const MissionDivWidget({
    super.key,
    this.missionID,
    this.missions,
  });

  final String? missionID;
  final MissionsRow? missions;

  @override
  State<MissionDivWidget> createState() => _MissionDivWidgetState();
}

class _MissionDivWidgetState extends State<MissionDivWidget> {
  late MissionDivModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MissionDivModel());
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFFE0E3E7),
            width: 2.0,
          ),
        ),
        child: Align(
          alignment: const AlignmentDirectional(1.0, -1.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.missions?.title,
                        'title',
                      ),
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Feather',
                                color: const Color(0xFF0F1113),
                                fontSize: 20.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: EditMissionWidget(
                                  missionID: widget.missionID!,
                                  missions: widget.missions,
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                        child: FaIcon(
                          FontAwesomeIcons.solidEdit,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 27.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 24.0,
                  thickness: 1.0,
                  color: Color(0xFFE0E3E7),
                ),
                Text(
                  valueOrDefault<String>(
                    widget.missions?.description,
                    'des',
                  ),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFF57636C),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
