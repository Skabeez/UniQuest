import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/audio_manager.dart';
import '/services/sound_effects.dart';
import 'package:flutter/material.dart';
import 'menu_mission_model.dart';
export 'menu_mission_model.dart';

class MenuMissionWidget extends StatefulWidget {
  const MenuMissionWidget({
    super.key,
    this.missions,
  });

  final MissionsRow? missions;

  @override
  State<MenuMissionWidget> createState() => _MenuMissionWidgetState();
}

class _MenuMissionWidgetState extends State<MenuMissionWidget> {
  late MenuMissionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuMissionModel());
    
    // Play popup sound
    AudioManager().playSfx(SoundEffects.popUp);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await TasksTable().delete(
          matchingRows: (rows) => rows,
        );
      },
      child: Container(
        width: double.infinity,
        height: 515.29,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Color(0x3B1D2429),
              offset: Offset(
                0.0,
                -3.0,
              ),
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    var confirmDialogResponse = await showDialog<bool>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              title: const Text(
                                'Delete Mission?',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              content: const Text(
                                'Are you sure you want to delete this mission? This action cannot be undone.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                    if (confirmDialogResponse) {
                      await MissionsTable().delete(
                        matchingRows: (rows) => rows.eqOrNull(
                          'mission_id',
                          widget.missions?.missionId,
                        ),
                      );
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            title: const Text(
                              'Success!',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            content: const Text(
                              'The mission has been deleted successfully.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      Navigator.pop(context);
                    } else {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            title: const Text(
                              'Cancelled',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            content: const Text(
                              'The action has been cancelled.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  text: 'Delete Mission',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 60.0,
                    padding: const EdgeInsets.all(14.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Feather',
                          color: const Color(0xFF14181B),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pop();
                  },
                  text: 'Cancel',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 60.0,
                    padding: const EdgeInsets.all(14.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Feather',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
