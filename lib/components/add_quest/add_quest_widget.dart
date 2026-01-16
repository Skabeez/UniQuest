import '/backend/supabase/supabase.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/audio_manager.dart';
import '/services/sound_effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_quest_model.dart';
export 'add_quest_model.dart';

class AddQuestWidget extends StatefulWidget {
  const AddQuestWidget({super.key});

  @override
  State<AddQuestWidget> createState() => _AddQuestWidgetState();
}

class _AddQuestWidgetState extends State<AddQuestWidget>
    with TickerProviderStateMixin {
  late AddQuestModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddQuestModel());

    // Play popup sound
    AudioManager().playSfx(SoundEffects.popUp);

    _model.titleTextController ??= TextEditingController();
    _model.titleFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.xpRewardTextController ??= TextEditingController(text: '100');
    _model.xpRewardFocusNode ??= FocusNode();

    _model.verificationCodeTextController ??= TextEditingController();
    _model.verificationCodeFocusNode ??= FocusNode();

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
                        'Create New Quest',
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
                        'Enter quest details below',
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
                        // Quest Title
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                child: Text(
                                  'Quest Title',
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
                                controller: _model.titleTextController,
                                focusNode: _model.titleFocusNode,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Quest Title',
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    color: const Color(0xFF606A85),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
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
                                      color: Color(0xFFFFBD59),
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
                                  fillColor: FlutterFlowTheme.of(context).info,
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Feather',
                                  color: const Color(0xFF15161E),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                cursorColor: const Color(0xFF6F61EF),
                                validator: _model.titleTextControllerValidator.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        // Quest Description
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                child: Text(
                                  'Description',
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
                                controller: _model.descriptionTextController,
                                focusNode: _model.descriptionFocusNode,
                                obscureText: false,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Describe the quest...',
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    color: const Color(0xFF606A85),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
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
                                      color: Color(0xFFFFBD59),
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
                                  fillColor: FlutterFlowTheme.of(context).info,
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Feather',
                                  color: const Color(0xFF15161E),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                cursorColor: const Color(0xFF6F61EF),
                                validator: _model.descriptionTextControllerValidator.asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        // XP Reward & Verification Code Row
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                          child: Row(
                            children: [
                              // XP Reward
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                      child: Text(
                                        'XP Reward',
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
                                      controller: _model.xpRewardTextController,
                                      focusNode: _model.xpRewardFocusNode,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '100',
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: const Color(0xFF606A85),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
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
                                            color: Color(0xFFFFBD59),
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
                                        fillColor: FlutterFlowTheme.of(context).info,
                                        contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Feather',
                                        color: const Color(0xFF15161E),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: const Color(0xFF6F61EF),
                                      validator: _model.xpRewardTextControllerValidator.asValidator(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              // Verification Code
                              Expanded(
                                flex: 2,
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
                                      controller: _model.verificationCodeTextController,
                                      focusNode: _model.verificationCodeFocusNode,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'e.g. libstick2004',
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: const Color(0xFF606A85),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
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
                                            color: Color(0xFFFFBD59),
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
                                        fillColor: FlutterFlowTheme.of(context).info,
                                        contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Feather',
                                        color: const Color(0xFF15161E),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: const Color(0xFF6F61EF),
                                      validator: _model.verificationCodeTextControllerValidator.asValidator(context),
                                    ),
                                  ],
                                ),
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
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              options: FFButtonOptions(
                                height: 44.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: Colors.white,
                                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                hoverColor: const Color(0xFFE5E7EB),
                                hoverBorderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 2.0,
                                ),
                                hoverTextColor: const Color(0xFF15161E),
                                hoverElevation: 3.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // Validate fields
                                if (_model.titleTextController!.text.isEmpty ||
                                    _model.descriptionTextController!.text.isEmpty ||
                                    _model.verificationCodeTextController!.text.isEmpty) {
                                  await showDialog(
                                    context: context,
                                    barrierColor: Colors.black87,
                                    builder: (alertDialogContext) {
                                      return const ModernAlertDialog(
                                        title: 'Missing Fields',
                                        description: 'Please fill in all required fields before creating the quest.',
                                        primaryButtonText: 'OK',
                                      );
                                    },
                                  );
                                  return;
                                }

                                await QuestsTable().insert({
                                  'title': _model.titleTextController!.text,
                                  'description': _model.descriptionTextController!.text,
                                  'xp_reward': int.tryParse(_model.xpRewardTextController!.text) ?? 100,
                                  'verification_code': _model.verificationCodeTextController!.text,
                                });
                                
                                await showDialog(
                                  context: context,
                                  barrierColor: Colors.black87,
                                  builder: (alertDialogContext) {
                                    return const ModernAlertDialog(
                                      title: 'Quest Created!',
                                      description: 'Quest has been created and broadcast to all users.',
                                      primaryButtonText: 'Done',
                                    );
                                  },
                                );
                                Navigator.pop(context);
                              },
                              text: 'Create Quest',
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
                                hoverColor: const Color(0x4D9489F5),
                                hoverBorderSide: const BorderSide(
                                  color: Color(0xFF6F61EF),
                                  width: 1.0,
                                ),
                                hoverTextColor: const Color(0xFF15161E),
                                hoverElevation: 0.0,
                              ),
                            ),
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
  }
}
