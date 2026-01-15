import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_quest_code_model.dart';
export 'add_quest_code_model.dart';

class AddQuestCodeWidget extends StatefulWidget {
  const AddQuestCodeWidget({super.key});

  @override
  State<AddQuestCodeWidget> createState() => _AddQuestCodeWidgetState();
}

class _AddQuestCodeWidgetState extends State<AddQuestCodeWidget>
    with TickerProviderStateMixin {
  late AddQuestCodeModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddQuestCodeModel());

    _model.codeTextController ??= TextEditingController();
    _model.codeFocusNode ??= FocusNode();

    _model.locationHintTextController ??= TextEditingController();
    _model.locationHintFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(115.0, 0.0),
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
                    offset: Offset(
                      0.0,
                      5.0,
                    ),
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
                        'Create Quest Code',
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
                        'Create a verification code for a quest',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Feather',
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    // Load Quests for Dropdown
                    FutureBuilder<List<QuestsRow>>(
                      future: QuestsTable().queryRows(
                        queryFn: (q) => q.eq('is_active', true).order('title'),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final quests = snapshot.data!;
                        if (quests.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'No active quests available. Create a quest first.',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Feather',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quest Dropdown
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'Quest',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Feather',
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 12.0,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  FlutterFlowDropDown<String>(
                                    controller: _model.questIdValueController ??=
                                        FormFieldController<String>(null),
                                    options: quests.map((q) => q.id).toList(),
                                    optionLabels: quests.map((q) => q.title).toList(),
                                    onChanged: (val) => safeSetState(() => _model.questIdValue = val),
                                    width: double.infinity,
                                    height: 56.0,
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                    hintText: 'Select a quest',
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF606A85),
                                      size: 24.0,
                                    ),
                                    fillColor: Colors.white,
                                    elevation: 2.0,
                                    borderColor: const Color(0xFFE5E7EB),
                                    borderWidth: 2.0,
                                    borderRadius: 12.0,
                                    margin: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 12.0, 0.0),
                                    hidesUnderline: true,
                                    isOverButton: false,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  ),
                                ],
                              ),
                            ),
                            // Verification Code
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
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
                          ],
                        );
                      },
                    ),
                    // Buttons
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
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
                          const SizedBox(width: 12.0),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // Validate required fields
                                if (_model.questIdValue == null ||
                                    _model.codeTextController.text.isEmpty ||
                                    _model.locationHintTextController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please fill in all required fields'),
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                  );
                                  return;
                                }

                                // Insert quest code
                                await QuestCodesTable().insert({
                                  'quest_id': _model.questIdValue!,
                                  'verification_code': _model.codeTextController.text.toUpperCase(),
                                  'location_hint': _model.locationHintTextController.text,
                                  'is_active': true,
                                });

                                // Update quest requires_code flag
                                await QuestsTable().update(
                                  data: {'requires_code': true},
                                  matchingRows: (rows) => rows.eq('id', _model.questIdValue!),
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
                                      content: Text(
                                        'Quest code "${_model.codeTextController.text.toUpperCase()}" has been created successfully.',
                                        style: const TextStyle(
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
                              text: 'Create Code',
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
                                hoverTextColor: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}
