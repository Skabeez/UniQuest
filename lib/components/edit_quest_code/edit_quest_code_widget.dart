import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_quest_code_model.dart';
export 'edit_quest_code_model.dart';

class EditQuestCodeWidget extends StatefulWidget {
  const EditQuestCodeWidget({
    super.key,
    required this.codeId,
    this.questCode,
  });

  final String? codeId;
  final QuestCodesRow? questCode;

  @override
  State<EditQuestCodeWidget> createState() => _EditQuestCodeWidgetState();
}

class _EditQuestCodeWidgetState extends State<EditQuestCodeWidget>
    with TickerProviderStateMixin {
  late EditQuestCodeModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditQuestCodeModel());

    _model.codeTextController ??=
        TextEditingController(text: widget.questCode?.verificationCode);
    _model.codeFocusNode ??= FocusNode();

    _model.locationHintTextController ??=
        TextEditingController(text: widget.questCode?.locationHint);
    _model.locationHintFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuestCodesRow>>(
      future: QuestCodesTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', widget.codeId),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        final _ = snapshot.data!;

        return Container(
          width: 600.0,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0x9AFFFFFF),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 16.0),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 670.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12.0,
                        color: Color(0x1E000000),
                        offset: Offset(0.0, 5.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Edit Quest Code',
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Feather',
                                  color: const Color(0xFFFFBD59),
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 0.0, 0.0),
                          child: Text(
                            'Update verification code details',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Feather',
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Verification Code
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Verification Code',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Feather',
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 12.0,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _model.codeTextController,
                                    focusNode: _model.codeFocusNode,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., LIBRARY2024',
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                            color: const Color(0xFF606A85),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          color: const Color(0xFF15161E),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                    cursorColor: const Color(0xFF6F61EF),
                                    validator: _model.codeTextControllerValidator.asValidator(context),
                                  ),
                                ],
                              ),
                            ),
                            // Location Hint
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Location Hint',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Feather',
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 12.0,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _model.locationHintTextController,
                                    focusNode: _model.locationHintFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'e.g., Look for a sticker near the main entrance',
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            font: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                            ),
                                            color: const Color(0xFF606A85),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE5E7EB),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF6F61EF),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF5963),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          color: const Color(0xFF15161E),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                    maxLines: 2,
                                    cursorColor: const Color(0xFF6F61EF),
                                    validator: _model.locationHintTextControllerValidator.asValidator(context),
                                  ),
                                ],
                              ),
                            ),
                            // Active Switch
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Active',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Feather',
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Switch(
                                    value: _model.isActiveValue ??= widget.questCode?.isActive ?? true,
                                    onChanged: (newValue) async {
                                      safeSetState(() => _model.isActiveValue = newValue);
                                    },
                                    activeColor: const Color(0xFF6F61EF),
                                    activeTrackColor: const Color(0x4D6F61EF),
                                    inactiveTrackColor: const Color(0xFFE5E7EB),
                                    inactiveThumbColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Buttons
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  var confirmDialogResponse = await showDialog<bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            title: const Text(
                                              'Delete Code',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1E1E1E),
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this verification code?',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(alertDialogContext, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(alertDialogContext, true),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Color(0xFFFF5963)),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;

                                  if (confirmDialogResponse) {
                                    await QuestCodesTable().delete(
                                      matchingRows: (rows) => rows.eq('id', widget.codeId!),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                text: 'Delete',
                                options: FFButtonOptions(
                                  height: 44.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFFFF5963),
                                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontFamily: 'Feather',
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    text: 'Cancel',
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: Colors.white,
                                      textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: 'Feather',
                                            color: const Color(0xFF15161E),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      elevation: 0.0,
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.codeTextController.text.isEmpty ||
                                          _model.locationHintTextController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please fill in all required fields'),
                                            duration: Duration(milliseconds: 2000),
                                          ),
                                        );
                                        return;
                                      }

                                      await QuestCodesTable().update(
                                        data: {
                                          'verification_code': _model.codeTextController.text.toUpperCase(),
                                          'location_hint': _model.locationHintTextController.text,
                                          'is_active': _model.isActiveValue,
                                        },
                                        matchingRows: (rows) => rows.eq('id', widget.codeId!),
                                      );

                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            title: const Text(
                                              'Success!',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1E1E1E),
                                              ),
                                            ),
                                            content: const Text(
                                              'Quest code has been updated successfully.',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(alertDialogContext),
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      Navigator.pop(context);
                                    },
                                    text: 'Save Changes',
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: const Color(0xFFFFBD59),
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Feather',
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      elevation: 3.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
              ),
            ],
          ),
        );
      },
    );
  }
}
