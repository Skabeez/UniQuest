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
        Divider(
          thickness: 1.0,
          color: FlutterFlowTheme.of(context).alternate,
        ),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 110.0),
          decoration: BoxDecoration(
            // Keep cards cream while page remains dark
            color: const Color(0xFFFBF7F3),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: const Color(0xFFF3EDE2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Normalize title casing for consistent display
                Text(
                  (widget.title.trim().isNotEmpty
                    ? '${widget.title.trim()[0].toUpperCase()}${widget.title.trim().substring(1)}'
                    : 'Title'),
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFFFFBD59),
                        fontSize: 22.0,
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
                    // Capitalize description sentence start
                    (widget.description.trim().isNotEmpty
                        ? '${widget.description.trim()[0].toUpperCase()}${widget.description.trim().substring(1)}'
                        : 'Details'),
                      textAlign: TextAlign.start,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
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
            )],
            ),
          ),
        ),
      ],
    );
  }
}
