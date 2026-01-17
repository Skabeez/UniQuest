import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    return FutureBuilder<List<ProfilesRow>>(
      future: ProfilesTable().queryRows(
        queryFn: (q) => q.eq('id', currentUserUid),
      ),
      builder: (context, snapshot) {
        final isEquipped = snapshot.hasData &&
            snapshot.data!.isNotEmpty &&
            snapshot.data!.first.equippedNamecard == widget.url;

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
                  if (kDebugMode) {
                    print('Equip background: uid="$currentUserUid", bg="${widget.url}"');
                  }
                  if (currentUserUid.isEmpty) {
                    if (context.mounted) {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return const ModernAlertDialog(
                            title: 'Not signed in',
                            description:
                                'Please sign in to equip a background to your profile.',
                            primaryButtonText: 'OK',
                          );
                        },
                      );
                    }
                    return;
                  }

                  // Check if already equipped
                  final currentProfile = await ProfilesTable().queryRows(
                    queryFn: (q) => q.eq('id', currentUserUid),
                  );

                  if (currentProfile.isNotEmpty &&
                      currentProfile.first.equippedNamecard == widget.url) {
                    if (context.mounted) {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return const ModernAlertDialog(
                            title: 'Already Equipped',
                            description:
                                'This background is already equipped to your profile.',
                            primaryButtonText: 'OK',
                          );
                        },
                      );
                    }
                    return;
                  }

                  await ProfilesTable().update(
                    data: {
                      'equipped_namecard': widget.url,
                    },
                    matchingRows: (rows) => rows.eq(
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
                      duration: const Duration(milliseconds: 2000),
                    );

                    // Wait for animation to complete before showing dialog
                    await Future.delayed(const Duration(milliseconds: 2000));
                  }

                  if (context.mounted) {
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
                }
              },
              child: Container(
                width: 180.0,
                height: 130.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: isEquipped
                      ? Border.all(
                          color: const Color(0xFFFFBD59),
                          width: 3.0,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.url!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isEquipped)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFBD59),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
