import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_task_model.dart';
export 'edit_task_model.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({
    super.key,
    this.taskId,
  });

  final String? taskId;

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget>
    with TickerProviderStateMixin {
  late EditTaskModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditTaskModel());

    _model.tasknameFocusNode ??= FocusNode();

    _model.tagsFocusNode ??= FocusNode();

    _model.notesFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 300.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
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
      decoration: BoxDecoration(
        color: Color(0x9AFFFFFF),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 16.0, 16.0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 670.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                boxShadow: [
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
              child: FutureBuilder<List<TasksRow>>(
                future: TasksTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull(
                    'task_id',
                    widget!.taskId,
                  ),
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
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
                  List<TasksRow> columnTasksRowList = snapshot.data!;

                  final columnTasksRow = columnTasksRowList.isNotEmpty
                      ? columnTasksRowList.first
                      : null;

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 16.0, 0.0, 0.0),
                        child: Text(
                          'Edit Task',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Feather',
                                color: Color(0xFFFFBD59),
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 0.0, 0.0),
                        child: Text(
                          'Below are your task details',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Feather',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: TextFormField(
                              controller: _model.tasknameTextController ??=
                                  TextEditingController(
                                text: columnTasksRow?.title,
                              ),
                              focusNode: _model.tasknameFocusNode,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: ' Task Name',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF6F61EF),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Feather',
                                    color: Color(0xFF15161E),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                              cursorColor: Color(0xFF6F61EF),
                              validator: _model.tasknameTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: TextFormField(
                              controller: _model.tagsTextController ??=
                                  TextEditingController(
                                text: columnTasksRow?.tags,
                              ),
                              focusNode: _model.tagsFocusNode,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Tag',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF6F61EF),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF15161E),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              maxLength: 15,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              cursorColor: Color(0xFF6F61EF),
                              validator: _model.tagsTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 0.0),
                              child: FlutterFlowDropDown<String>(
                                controller: _model.priorityValueController ??=
                                    FormFieldController<String>(
                                  _model.priorityValue ??=
                                      columnTasksRow?.priority,
                                ),
                                options: ['High', 'Medium', 'Low'],
                                onChanged: (val) => safeSetState(
                                    () => _model.priorityValue = val),
                                width: 538.7,
                                height: 60.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                hintText: 'Priority',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context).info,
                                elevation: 2.0,
                                borderColor: Colors.transparent,
                                borderWidth: 0.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: TextFormField(
                              controller: _model.notesTextController ??=
                                  TextEditingController(
                                text: columnTasksRow?.description,
                              ),
                              focusNode: _model.notesFocusNode,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Notes',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF606A85),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF6F61EF),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF15161E),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              maxLength: 50,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              cursorColor: Color(0xFF6F61EF),
                              validator: _model.notesTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Container(
                              width: 550.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final _datePickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: getCurrentTimestamp,
                                    firstDate: getCurrentTimestamp,
                                    lastDate: DateTime(2050),
                                    builder: (context, child) {
                                      return wrapInMaterialDatePickerTheme(
                                        context,
                                        child!,
                                        headerBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        headerForegroundColor:
                                            FlutterFlowTheme.of(context).info,
                                        headerTextStyle: FlutterFlowTheme.of(
                                                context)
                                            .headlineLarge
                                            .override(
                                              font: GoogleFonts.urbanist(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                              fontSize: 32.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                        pickerBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        pickerForegroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        selectedDateTimeBackgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        selectedDateTimeForegroundColor:
                                            FlutterFlowTheme.of(context).info,
                                        actionButtonForegroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        iconSize: 24.0,
                                      );
                                    },
                                  );

                                  if (_datePickedDate != null) {
                                    safeSetState(() {
                                      _model.datePicked = DateTime(
                                        _datePickedDate.year,
                                        _datePickedDate.month,
                                        _datePickedDate.day,
                                      );
                                    });
                                  } else if (_model.datePicked != null) {
                                    safeSetState(() {
                                      _model.datePicked = getCurrentTimestamp;
                                    });
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.91, 0.05),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF606A85),
                                        size: 24.0,
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.89, -0.19),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 5.0, 0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            dateTimeFormat("MMMM, d",
                                                columnTasksRow?.dueDate),
                                            'Not Set Yet',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF606A85),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 12.0, 24.0, 24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.05),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                text: 'Cancel',
                                options: FFButtonOptions(
                                  height: 44.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Colors.white,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Color(0xFF15161E),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  hoverColor: Color(0xFFE5E7EB),
                                  hoverBorderSide: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 2.0,
                                  ),
                                  hoverTextColor: Color(0xFF15161E),
                                  hoverElevation: 3.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.05),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await TasksTable().update(
                                    data: {
                                      'title': valueOrDefault<String>(
                                        _model.tasknameTextController.text,
                                        '\"Test Task\"',
                                      ),
                                      'description': valueOrDefault<String>(
                                        _model.notesTextController.text,
                                        '\"Test Task\"',
                                      ),
                                      'tags': _model.tagsTextController.text,
                                      'priority': valueOrDefault<String>(
                                        _model.priorityValue,
                                        '\"Test Task\"',
                                      ),
                                      'id': currentUserUid,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'task_id',
                                      widget!.taskId,
                                    ),
                                  );
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Success!'),
                                        content: Text('Task has been Updated.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                text: 'Save Changes',
                                options: FFButtonOptions(
                                  height: 44.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFFFFBD59),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  hoverColor: Color(0x4D9489F5),
                                  hoverBorderSide: BorderSide(
                                    color: Color(0xFF6F61EF),
                                    width: 1.0,
                                  ),
                                  hoverTextColor: Color(0xFF15161E),
                                  hoverElevation: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
          ),
        ],
      ),
    );
  }
}
