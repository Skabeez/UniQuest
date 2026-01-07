import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'frame_model.dart';
export 'frame_model.dart';

class FrameWidget extends StatefulWidget {
  const FrameWidget({
    super.key,
    this.id,
    required this.url,
  });

  final String? id;
  final String? url;

  @override
  State<FrameWidget> createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  late FrameModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FrameModel());
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
        var confirmDialogResponse = await showDialog<bool>(
              context: context,
              barrierColor: Colors.black87,
              builder: (alertDialogContext) {
                return ModernAlertDialog(
                  title: 'Equip Frame?',
                  description:
                      'Do you want to equip this frame to your profile?',
                  secondaryButtonText: 'Cancel',
                  primaryButtonText: 'Equip',
                  onSecondaryPressed: () =>
                      Navigator.pop(alertDialogContext, false),
                  onPrimaryPressed: () =>
                      Navigator.pop(alertDialogContext, true),
                );
              },
            ) ??
            false;
        if (confirmDialogResponse) {
          await ProfilesTable().update(
            data: {
              'equipped_border': widget.url,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id',
              currentUserUid,
            ),
          );
          if (context.mounted) {
            LottieBurstOverlay.showCentered(
              context: context,
              lottieAsset: 'assets/jsons/black rainbow cat.json',
              size: 250.0,
              repeat: false,
              duration: const Duration(milliseconds: 4000), // ~2 loops
            );
          }
          await showDialog(
            context: context,
            barrierColor: Colors.black87,
            builder: (alertDialogContext) {
              return const ModernAlertDialog(
                title: 'Equipped!',
                description: 'Your new frame has been equipped successfully.',
                primaryButtonText: 'Done',
              );
            },
          );
        }
      },
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: 100.0,
                height: 100.0,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  widget.url!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
