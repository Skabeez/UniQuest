import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'avatar_model.dart';
export 'avatar_model.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({
    super.key,
    this.avatarurl,
    required this.avatarid,
  });

  final String? avatarurl;
  final String? avatarid;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late AvatarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvatarModel());
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
            snapshot.data!.first.avatarUrl == widget.avatarurl;

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
                      title: 'Equip Avatar?',
                      description:
                          'Do you want to equip this avatar to your profile?',
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
                  print('Equip avatar: uid="$currentUserUid", avatar="${widget.avatarurl}"');
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
                              'Please sign in to equip an avatar to your profile.',
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
                  currentProfile.first.avatarUrl == widget.avatarurl) {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (alertDialogContext) {
                      return const ModernAlertDialog(
                        title: 'Already Equipped',
                        description:
                            'This avatar is already equipped to your profile.',
                        primaryButtonText: 'OK',
                      );
                    },
                  );
                }
                return;
              }

              await ProfilesTable().update(
                data: {
                  'avatar_url': widget.avatarurl,
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
                          'Your new avatar has been equipped successfully.',
                      primaryButtonText: 'Done',
                    );
                  },
                );
              }
            }
          },
          child: Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              border: Border.all(
                color: isEquipped
                    ? const Color(0xFFFFBD59)
                    : FlutterFlowTheme.of(context).primaryText,
                width: isEquipped ? 3.0 : 1.0,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.avatarurl!,
                      width: 105.0,
                      height: 105.0,
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFBD59),
                        shape: BoxShape.circle,
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
        );
      },
    );
  }
}
