import '/components/quest_verification_modal/quest_verification_modal_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'quest_model.dart';
export 'quest_model.dart';

class QuestWidget extends StatefulWidget {
  const QuestWidget({
    super.key,
    required this.questId,
    this.questTitle,
    this.description,
    this.xpReward,
    this.difficulty,
    this.requiresCode,
  });

  final String questId;
  final String? questTitle;
  final String? description;
  final int? xpReward;
  final String? difficulty;
  final bool? requiresCode;

  @override
  State<QuestWidget> createState() => _QuestWidgetState();
}

class _QuestWidgetState extends State<QuestWidget> {
  late QuestModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuestModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty?.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFF44336);
      case 'expert':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF757575);
    }
  }

  Future<void> _handleQuestTap() async {
    if (widget.requiresCode == true) {
      await showDialog(
        context: context,
        builder: (context) => QuestVerificationModalWidget(
          questId: widget.questId,
          questTitle: widget.questTitle ?? 'Quest',
          xpReward: widget.xpReward ?? 0,
        ),
      );
    } else {
      // Handle non-code quests (future implementation)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quest completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: InkWell(
        onTap: _handleQuestTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                FlutterFlowTheme.of(context).secondary.withOpacity(0.05),
              ],
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(-1.0, -1.0),
              end: const AlignmentDirectional(1.0, 1.0),
            ),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.questTitle ?? 'Untitled Quest',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'Feather',
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFBD59),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.white, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            '${widget.xpReward ?? 0} XP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                if (widget.description != null && widget.description!.isNotEmpty)
                  Text(
                    widget.description!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          color: const Color(0xFF57636C),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    if (widget.difficulty != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: _getDifficultyColor(),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          widget.difficulty!.toUpperCase(),
                          style: TextStyle(
                            color: _getDifficultyColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    if (widget.requiresCode == true) ...[
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B39EF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xFF4B39EF),
                            width: 1.0,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.qr_code,
                                size: 14.0, color: Color(0xFF4B39EF)),
                            SizedBox(width: 4.0),
                            Text(
                              'CODE REQUIRED',
                              style: TextStyle(
                                color: Color(0xFF4B39EF),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
