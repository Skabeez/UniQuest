import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'quest_verification_modal_model.dart';
export 'quest_verification_modal_model.dart';

class QuestVerificationModalWidget extends StatefulWidget {
  const QuestVerificationModalWidget({
    super.key,
    required this.questId,
    required this.questTitle,
    this.locationHint,
    required this.xpReward,
  });

  final String questId;
  final String questTitle;
  final String? locationHint;
  final int xpReward;

  @override
  State<QuestVerificationModalWidget> createState() =>
      _QuestVerificationModalWidgetState();
}

class _QuestVerificationModalWidgetState
    extends State<QuestVerificationModalWidget> {
  late QuestVerificationModalModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuestVerificationModalModel());
    _model.codeController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    if (_model.codeController.text.isEmpty) {
      setState(() {
        _model.errorMessage = 'Please enter a code';
      });
      return;
    }

    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    try {
      // Insert into quest_code_redemptions - trigger handles validation and XP award
      await QuestCodeRedemptionsTable().insert({
        'user_id': currentUserUid,
        'code': _model.codeController.text.toUpperCase().trim(),
      });

      // Success - show animation
      await _showSuccessAnimation();
    } catch (e) {
      setState(() {
        _model.errorMessage = e.toString().contains('already redeemed')
            ? 'You already redeemed this code'
            : e.toString().contains('Invalid or inactive')
            ? 'Invalid code'
            : e.toString().contains('maximum uses')
            ? 'Code has reached maximum uses'
            : 'Verification failed. Please try again.';
        _model.isLoading = false;
      });
    }
  }

  Future<void> _showSuccessAnimation() async {
    setState(() {
      _model.showSuccess = true;
      _model.isLoading = false;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FlutterFlowTheme.of(context).primary.withOpacity(0.95),
              FlutterFlowTheme.of(context).secondary.withOpacity(0.95),
            ],
            stops: const [0.0, 1.0],
            begin: const AlignmentDirectional(-1.0, -1.0),
            end: const AlignmentDirectional(1.0, 1.0),
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _model.showSuccess
            ? _buildSuccessView()
            : _buildInputView(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie_animations/Confetti.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            repeat: false,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Quest Complete!',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Feather',
                  color: Colors.white,
                  fontSize: 28.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFBD59),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Text(
              '+${widget.xpReward} XP',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.questTitle,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Feather',
                        color: Colors.white,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Only show location hint if provided
          if (widget.locationHint != null && widget.locationHint!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.locationHint!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24.0),
          Text(
            'Enter Verification Code',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _model.codeController,
            inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(12),
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            ],
            decoration: InputDecoration(
              hintText: 'Enter code',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              errorText: _model.errorMessage,
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: _model.isLoading ? null : _submitCode,
                  text: _model.isLoading ? 'Verifying...' : 'Verify Code',
                  options: FFButtonOptions(
                    height: 50.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    color: const Color(0xFFFFBD59),
                    textStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              FFButtonWidget(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Cancel',
                options: FFButtonOptions(
                  height: 50.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  color: Colors.white.withOpacity(0.2),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
