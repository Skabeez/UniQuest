import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
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
  })  : title = title ?? '\"\"',
        description = description ?? '\"\"',
        priority = priority ?? '\"Low\"';

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
        const Divider(
          thickness: 1.0,
          color: Color(0xFFE6E6E6),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAF3E8),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: const Color(0xFFE8DAC8),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  valueOrDefault<String>(
                    widget.title,
                    'title',
                  ),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Feather',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                  child: Text(
                    valueOrDefault<String>(
                      widget.description,
                      'details',
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Feather',
                          color: const Color(0xFF6B6B6B),
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.tag != null && widget.tag!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBD59).withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFFEDA34A),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      valueOrDefault<String>(
                        widget.tag,
                        '[]',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Feather',
                            color: const Color(0xFFFFBD59),
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                          ),
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
