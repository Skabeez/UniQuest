import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'archive_task_div_model.dart';
export 'archive_task_div_model.dart';

class ArchiveTaskDivWidget extends StatefulWidget {
  const ArchiveTaskDivWidget({
    super.key,
    String? title,
    String? description,
    this.deadline,
    String? priority,
    this.tag,
    this.tasks,
    this.id,
    this.isDone,
  })  : this.title = title ?? '\"\"',
        this.description = description ?? '\"\"',
        this.priority = priority ?? '\"Low\"';

  final String title;
  final String description;
  final DateTime? deadline;
  final String priority;
  final String? tag;
  final TasksRow? tasks;
  final String? id;
  final bool? isDone;

  @override
  State<ArchiveTaskDivWidget> createState() => _ArchiveTaskDivWidgetState();
}

class _ArchiveTaskDivWidgetState extends State<ArchiveTaskDivWidget> {
  late ArchiveTaskDivModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArchiveTaskDivModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 139.9,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.79, -0.9),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.title,
                            'title',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Feather',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.94, -0.45),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 0.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              widget!.description,
                              'details',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Feather',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.83, -0.06),
                        child: Text(
                          valueOrDefault<String>(
                            widget!.tag,
                            '[]',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Feather',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
