import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'background_model.dart';
export 'background_model.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({
    super.key,
    required this.id,
    required this.url,
  });

  final String? id;
  final String? url;

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  late BackgroundModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BackgroundModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
      child: InkWell(
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
                    title: 'Equip Background?',
                    description:
                        'Do you want to equip this background to your profile?',
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
                'equipped_namecard': widget.url,
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
                  description:
                      'Your new background has been equipped successfully.',
                  primaryButtonText: 'Done',
                );
              },
            );
          }
        },
        child: Container(
          width: 180.0,
          height: 130.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.url!,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
