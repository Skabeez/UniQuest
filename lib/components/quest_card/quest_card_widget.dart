import '/backend/supabase/supabase.dart';
import '/components/edit_quest/edit_quest_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'quest_card_model.dart';
export 'quest_card_model.dart';

class QuestCardWidget extends StatefulWidget {
  const QuestCardWidget({
    super.key,
    required this.questId,
    this.quest,
  });

  final String? questId;
  final QuestsRow? quest;

  @override
  State<QuestCardWidget> createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget> {
  late QuestCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuestCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Color _getDifficultyColor() {
    switch (widget.quest?.difficulty) {
      case 'easy':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'hard':
        return const Color(0xFFEF4444);
      case 'expert':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFFE0E3E7),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      valueOrDefault<String>(
                        widget.quest?.title,
                        'Quest Title',
                      ),
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Feather',
                            color: const Color(0xFF0F1113),
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  InkWell(
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
                            child: EditQuestWidget(
                              questId: widget.questId!,
                              quest: widget.quest,
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    child: FaIcon(
                      FontAwesomeIcons.solidEdit,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 27.0,
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
                  widget.quest?.description,
                  'Quest description',
                ),
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Feather',
                      color: const Color(0xFF57636C),
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      valueOrDefault<String>(
                        widget.quest?.difficulty?.toUpperCase(),
                        'NORMAL',
                      ),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Feather',
                            color: _getDifficultyColor(),
                            fontSize: 11.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBD59).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFBD59),
                          size: 14.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${widget.quest?.xpReward ?? 0} XP',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Feather',
                                color: const Color(0xFFFFBD59),
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.quest?.category != null && widget.quest!.category!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F61EF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          widget.quest!.category!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Feather',
                                color: const Color(0xFF6F61EF),
                                fontSize: 11.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                    decoration: BoxDecoration(
                      color: widget.quest?.isActive == true
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.quest?.isActive == true ? 'ACTIVE' : 'INACTIVE',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Feather',
                            color: widget.quest?.isActive == true
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontSize: 11.0,
                            letterSpacing: 0.5,
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
