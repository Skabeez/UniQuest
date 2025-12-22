import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'walkthrough_bubble_model.dart';
export 'walkthrough_bubble_model.dart';

class WalkthroughBubbleWidget extends StatefulWidget {
  const WalkthroughBubbleWidget({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  State<WalkthroughBubbleWidget> createState() =>
      _WalkthroughBubbleWidgetState();
}

class _WalkthroughBubbleWidgetState extends State<WalkthroughBubbleWidget> {
  late WalkthroughBubbleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WalkthroughBubbleModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 320.0,
          minHeight: 120.0,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A1F36),
              Color(0xFF0F1319),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 100.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
              spreadRadius: 100.0,
            )
          ],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Guide',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Feather',
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                valueOrDefault<String>(
                  widget.text,
                  'Tip text',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Feather',
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.95),
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
