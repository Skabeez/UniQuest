import '/backend/supabase/supabase.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'redeem_quest_model.dart';
export 'redeem_quest_model.dart';

class RedeemQuestWidget extends StatefulWidget {
  const RedeemQuestWidget({
    super.key,
    required this.quest,
    required this.userQuest,
    required this.onRedeemed,
  });

  final QuestsRow quest;
  final UserQuestsRow userQuest;
  final VoidCallback onRedeemed;

  @override
  State<RedeemQuestWidget> createState() => _RedeemQuestWidgetState();
}

class _RedeemQuestWidgetState extends State<RedeemQuestWidget> {
  late RedeemQuestModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RedeemQuestModel());

    _model.codeFieldTextController ??= TextEditingController();
    _model.codeFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _redeemQuest() async {
    if (_model.codeFieldTextController?.text.isEmpty ?? true) {
      await showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (alertDialogContext) {
          return const ModernAlertDialog(
            title: 'Missing Code',
            description: 'Please enter a verification code to redeem this quest.',
            primaryButtonText: 'OK',
          );
        },
      );
      return;
    }

    setState(() {
      _model.isLoading = true;
    });

    try {
      // Call the redeem_quest RPC function
      final result = await SupaFlow.client.rpc(
        'redeem_quest',
        params: {
          'p_quest_id': widget.quest.id,
          'p_code': _model.codeFieldTextController!.text.trim(),
        },
      );

      if (!mounted) return;

      if (result == true) {
        Navigator.of(context).pop();
        widget.onRedeemed();
        
        if (mounted) {
          // Show success animation
          LottieBurstOverlay.showCentered(
            context: context,
            lottieAsset: 'assets/jsons/Confetti.json',
            size: 300.0,
            repeat: false,
            duration: const Duration(milliseconds: 2000),
          );
          
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            await showDialog(
              context: context,
              barrierColor: Colors.black87,
              builder: (alertDialogContext) {
                return ModernAlertDialog(
                  title: 'Quest Completed!',
                  description: 'You earned +${widget.quest.xpReward} XP for completing "${widget.quest.title}"!',
                  primaryButtonText: 'Awesome!',
                );
              },
            );
          }
        }
      } else {
        await showDialog(
          context: context,
          barrierColor: Colors.black87,
          builder: (alertDialogContext) {
            return const ModernAlertDialog(
              title: 'Invalid Code',
              description: 'The verification code you entered is incorrect. Please try again.',
              primaryButtonText: 'OK',
            );
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (alertDialogContext) {
          return ModernAlertDialog(
            title: 'Error',
            description: 'Something went wrong: ${e.toString()}',
            primaryButtonText: 'OK',
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _model.isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Quest title
            Text(
              widget.quest.title,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Feather',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            // Quest description
            Text(
              widget.quest.description,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Feather',
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            const SizedBox(height: 16.0),
            // XP reward badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFBD59).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color(0xFFFFBD59),
                  width: 1.0,
                ),
              ),
              child: Text(
                '+${widget.quest.xpReward} XP',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Feather',
                      color: const Color(0xFFFFBD59),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Verification code field
            Text(
              'Enter Verification Code',
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Feather',
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _model.codeFieldTextController,
              focusNode: _model.codeFieldFocusNode,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Enter code...',
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Feather',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Feather',
                    letterSpacing: 2.0,
                  ),
              textAlign: TextAlign.center,
              validator: _model.codeFieldTextControllerValidator.asValidator(context),
            ),
            const SizedBox(height: 24.0),
            // Submit button
            FFButtonWidget(
              onPressed: _model.isLoading ? null : _redeemQuest,
              text: _model.isLoading ? 'Verifying...' : 'Redeem Quest',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Feather',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                elevation: 2.0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
                disabledColor: FlutterFlowTheme.of(context).alternate,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
