import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_new_task/add_new_task_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/walkthroughs/onboarding_home.dart';
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_container_model.dart';
export 'onboarding_container_model.dart';

class OnboardingContainerWidget extends StatefulWidget {
  const OnboardingContainerWidget({super.key});

  static String routeName = 'OnboardingContainer';
  static String routePath = '/onboardingContainer';

  @override
  State<OnboardingContainerWidget> createState() =>
      _OnboardingContainerWidgetState();
}

class _OnboardingContainerWidgetState extends State<OnboardingContainerWidget>
    with TickerProviderStateMixin {
  late OnboardingContainerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingContainerModel());

    _model.tasknameTextController ??= TextEditingController();
    _model.tasknameFocusNode ??= FocusNode();

    _model.tagsTextController ??= TextEditingController();
    _model.tagsFocusNode ??= FocusNode();

    _model.notesTextController ??= TextEditingController();
    _model.notesFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(50.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(50.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(50.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(50.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(50.0, 0.0),
            end: const Offset(0.0, 0.0),
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 868.9,
                child: Stack(
                  children: [
                    PageView(
                      controller: _model.pageViewController ??=
                          PageController(initialPage: 0),
                      onPageChanged: (_) async {
                        safeSetState(() => _model.onboardingHomeController =
                            createPageWalkthrough(context));
                        _model.onboardingHomeController?.show(context: context);
                      },
                      scrollDirection: Axis.horizontal,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 300.0,
                              height: 600.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Just_the_logo.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Welcome to UniQuest! 🚀',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .override(
                                                    fontFamily: 'Feather',
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text(
                                              'Let\'s take a quick tour to help you get started with task management.\n\nYou\'ll learn how to create tasks, set priorities, and stay organized.\n\nReady to begin your quest?',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Feather',
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.9),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  await _model.pageViewController?.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                                text: 'NEXT',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFF1A9C0E),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.manrope(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 350.0,
                              height: 600.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  safeSetState(() =>
                                      _model.onboardingHomeController =
                                          createPageWalkthrough(context));
                                  _model.onboardingHomeController
                                      ?.show(context: context);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 20.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          1.0,
                                                      height: 120.0,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.9,
                                                                height: 130.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    -0.18,
                                                                    -1.46),
                                                            child: Container(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.9,
                                                              height: 110.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFFFBD59),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14.0),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            -0.81,
                                                                            -0.05),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          80.0,
                                                                      height:
                                                                          80.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF7E7E7E),
                                                                          width:
                                                                              3.0,
                                                                        ),
                                                                      ),
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            80.0,
                                                                        height:
                                                                            80.0,
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Just_the_logo.png',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0.5,
                                                                            0.0),
                                                                    child: Text(
                                                                      'Welcome to \nUniQuest!',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Feather',
                                                                            fontSize:
                                                                                25.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 140.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  12.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Categories',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Feather',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      26.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 250.0,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            10.0),
                                                        child: ListView(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          16.0,
                                                                          12.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context.pushNamed(
                                                                      TodoListWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 230.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4.0,
                                                                        color: Color(
                                                                            0x34090F13),
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          2.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            140.0,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Color(0xFFF1B49B),
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(0.0),
                                                                            bottomRight:
                                                                                Radius.circular(0.0),
                                                                            topLeft:
                                                                                Radius.circular(12.0),
                                                                            topRight:
                                                                                Radius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                    child: FaIcon(
                                                                                      FontAwesomeIcons.solidListAlt,
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      size: 80.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'To-Do List',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Feather',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 20.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: SizedBox(
                                                                                width: 203.6,
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Text(
                                                                                        'Track and complete tasks',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Feather',
                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                              fontSize: 17.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ).addWalkthrough(
                                                                    columnZz4db3v5,
                                                                    _model
                                                                        .onboardingHomeController,
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation1']!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          16.0,
                                                                          12.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context.pushNamed(
                                                                      AchievementsWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 230.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4.0,
                                                                        color: Color(
                                                                            0x34090F13),
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          2.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            140.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(0.0),
                                                                            bottomRight:
                                                                                Radius.circular(0.0),
                                                                            topLeft:
                                                                                Radius.circular(12.0),
                                                                            topRight:
                                                                                Radius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                    child: FaIcon(
                                                                                      FontAwesomeIcons.trophy,
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      size: 80.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Achievements',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Feather',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 20.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: SizedBox(
                                                                                width: 203.6,
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Text(
                                                                                        'Unlock badges by reaching goals and milestones.',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Feather',
                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation2']!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          16.0,
                                                                          12.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context.pushNamed(
                                                                      LeaderboardWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 230.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4.0,
                                                                        color: Color(
                                                                            0x34090F13),
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          2.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            140.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).warning,
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(0.0),
                                                                            bottomRight:
                                                                                Radius.circular(0.0),
                                                                            topLeft:
                                                                                Radius.circular(12.0),
                                                                            topRight:
                                                                                Radius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.leaderboard_rounded,
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      size: 80.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Leaderboard',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Feather',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 20.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: SizedBox(
                                                                                width: 203.6,
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Text(
                                                                                        'Compete with others and climb the ranks.',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Feather',
                                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation3']!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          16.0,
                                                                          12.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context.pushNamed(
                                                                      CustomizeProfileWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 230.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4.0,
                                                                        color: Color(
                                                                            0x34090F13),
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          2.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            140.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).tertiary,
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(0.0),
                                                                            bottomRight:
                                                                                Radius.circular(0.0),
                                                                            topLeft:
                                                                                Radius.circular(12.0),
                                                                            topRight:
                                                                                Radius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.brush_outlined,
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      size: 80.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Cosmetics',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Feather',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 20.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: SizedBox(
                                                                                width: 203.6,
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Text(
                                                                                        'Customize your profile with earned visual items.',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Feather',
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation4']!),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          12.0,
                                                                          16.0,
                                                                          12.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context.pushNamed(
                                                                      MapWidget
                                                                          .routeName);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 230.0,
                                                                  height: 50.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            4.0,
                                                                        color: Color(
                                                                            0x34090F13),
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          2.0,
                                                                        ),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            140.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).warning,
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(0.0),
                                                                            bottomRight:
                                                                                Radius.circular(0.0),
                                                                            topLeft:
                                                                                Radius.circular(12.0),
                                                                            topRight:
                                                                                Radius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(12.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Stack(
                                                                                children: [
                                                                                  Align(
                                                                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                    child: FaIcon(
                                                                                      FontAwesomeIcons.solidMap,
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      size: 80.0,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                child: Text(
                                                                                  'Map',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Feather',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 20.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: SizedBox(
                                                                                width: 203.6,
                                                                                child: Stack(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Text(
                                                                                        'Navigate campus.',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Feather',
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ).animateOnPageLoad(
                                                                  animationsMap[
                                                                      'containerOnPageLoadAnimation5']!),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                safeSetState(() =>
                                    _model.onboardingHomeController =
                                        createPageWalkthrough(context));
                                _model.onboardingHomeController
                                    ?.show(context: context);
                              },
                              text: 'Start walkthrough',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFF1A9C0E),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                await _model.pageViewController?.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                              text: 'NEXT',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFF1A9C0E),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                safeSetState(() =>
                                    _model.onboardingHomeController =
                                        createPageWalkthrough(context));
                                _model.onboardingHomeController
                                    ?.show(context: context);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(0.0, -1.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: FlutterFlowCalendar(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        iconColor: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        weekFormat: true,
                                        weekStartsMonday: true,
                                        twoRowHeader: true,
                                        rowHeight: 48.0,
                                        onChange:
                                            (DateTimeRange? newSelectedDate) {
                                          safeSetState(() =>
                                              _model.calendarSelectedDay =
                                                  newSelectedDate);
                                        },
                                        titleStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Feather',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 26.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              lineHeight: 2.0,
                                            ),
                                        dayOfWeekStyle: FlutterFlowTheme.of(
                                                context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: 'Feather',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                        dateStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                        selectedDateStyle: FlutterFlowTheme.of(
                                                context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        inactiveDateStyle: FlutterFlowTheme.of(
                                                context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.75, -0.94),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: const AddNewTaskWidget(),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        child: const Icon(
                                          Icons.add_circle_outline,
                                          color: Color(0xFFFFBD59),
                                          size: 60.0,
                                        ),
                                      ).addWalkthrough(
                                        icon5vj7w71e,
                                        _model.onboardingHomeController,
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.04, 0.87),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await _model.pageViewController
                                              ?.nextPage(
                                            duration:
                                                const Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        },
                                        text: 'NEXT',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: const Color(0xFF1A9C0E),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.manrope(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.35, -0.15),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/012adadb-86d3-4c56-a6bb-ef085f1e4a69.jpg',
                                          width: 319.8,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ).addWalkthrough(
                                        image9a5hoiqt,
                                        _model.onboardingHomeController,
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0.05, 0.65),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          safeSetState(() => _model
                                                  .onboardingHomeController =
                                              createPageWalkthrough(context));
                                          _model.onboardingHomeController
                                              ?.show(context: context);
                                        },
                                        text: 'Start walkthrough',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: const Color(0xFF1A9C0E),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.manrope(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            safeSetState(() => _model.onboardingHomeController =
                                createPageWalkthrough(context));
                            _model.onboardingHomeController
                                ?.show(context: context);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 0.0, 0.0),
                                    child: Text(
                                      'Create New Task',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily: 'Feather',
                                            color: const Color(0xFFFFBD59),
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        24.0, 4.0, 0.0, 0.0),
                                    child: Text(
                                      'Below are your task details',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                        child: TextFormField(
                                          controller:
                                              _model.tasknameTextController,
                                          focusNode: _model.tasknameFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: ' Task Name',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE5E7EB),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF6F61EF),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: const Color(0xFF15161E),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          cursorColor: const Color(0xFF6F61EF),
                                          validator: _model
                                              .tasknameTextControllerValidator
                                              .asValidator(context),
                                        ).addWalkthrough(
                                          textFieldDurp415i,
                                          _model.onboardingHomeController,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                        child: TextFormField(
                                          controller: _model.tagsTextController,
                                          focusNode: _model.tagsFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Tags',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE5E7EB),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF6F61EF),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: const Color(0xFF15161E),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          cursorColor: const Color(0xFF6F61EF),
                                          validator: _model
                                              .tagsTextControllerValidator
                                              .asValidator(context),
                                        ).addWalkthrough(
                                          textField9ioipjz3,
                                          _model.onboardingHomeController,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 16.0, 16.0, 0.0),
                                          child: FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .priorityValueController ??=
                                                FormFieldController<String>(
                                                    null),
                                            options: const ['High', 'Medium', 'Low'],
                                            onChanged: (val) => safeSetState(
                                                () =>
                                                    _model.priorityValue = val),
                                            width: 538.7,
                                            height: 60.0,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
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
                                                  color: const Color(0xFF606A85),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                            hintText: 'Priority',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            elevation: 2.0,
                                            borderColor: Colors.transparent,
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            margin:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ).addWalkthrough(
                                            dropDownNy0nvxce,
                                            _model.onboardingHomeController,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                        child: TextFormField(
                                          controller:
                                              _model.notesTextController,
                                          focusNode: _model.notesFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Notes',
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: const Color(0xFF606A85),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFE5E7EB),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF6F61EF),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: const Color(0xFF15161E),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          cursorColor: const Color(0xFF6F61EF),
                                          validator: _model
                                              .notesTextControllerValidator
                                              .asValidator(context),
                                        ).addWalkthrough(
                                          textFieldJxiohxvi,
                                          _model.onboardingHomeController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        24.0, 12.0, 24.0, 24.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.0, 0.05),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            text: 'Cancel',
                                            options: FFButtonOptions(
                                              height: 44.0,
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Colors.white,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
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
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              hoverColor: const Color(0xFFE5E7EB),
                                              hoverBorderSide: const BorderSide(
                                                color: Color(0xFFE5E7EB),
                                                width: 2.0,
                                              ),
                                              hoverTextColor: const Color(0xFF15161E),
                                              hoverElevation: 3.0,
                                            ),
                                          ).addWalkthrough(
                                            buttonY0izahv0,
                                            _model.onboardingHomeController,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.0, 0.05),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              await TasksTable().insert({
                                                'title': valueOrDefault<String>(
                                                  _model.tasknameTextController
                                                      .text,
                                                  '\"Test Task\"',
                                                ),
                                                'description':
                                                    valueOrDefault<String>(
                                                  _model
                                                      .notesTextController.text,
                                                  '\"Test Task\"',
                                                ),
                                                'tags': _model
                                                    .tagsTextController.text,
                                                'priority': '',
                                                'status': '',
                                                'id': currentUserUid,
                                                'user_id': currentUserUid,
                                              });
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: const Text('Success!'),
                                                    content: const Text(
                                                        'New Task Created!'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: const Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            text: 'Save Task',
                                            options: FFButtonOptions(
                                              height: 44.0,
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      24.0, 0.0, 24.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: const Color(0xFFFFBD59),
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                              elevation: 3.0,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              hoverColor: const Color(0x4D9489F5),
                                              hoverBorderSide: const BorderSide(
                                                color: Color(0xFF6F61EF),
                                                width: 1.0,
                                              ),
                                              hoverTextColor: const Color(0xFF15161E),
                                              hoverElevation: 0.0,
                                            ),
                                          ).addWalkthrough(
                                            button1ipklr67,
                                            _model.onboardingHomeController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).addWalkthrough(
                                columnFawd2z5q,
                                _model.onboardingHomeController,
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  safeSetState(() =>
                                      _model.onboardingHomeController =
                                          createPageWalkthrough(context));
                                  _model.onboardingHomeController
                                      ?.show(context: context);
                                },
                                text: 'Start walkthrough',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFF1A9C0E),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.manrope(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  if (Navigator.of(context).canPop()) {
                                    context.pop();
                                  }
                                  context.pushNamed(
                                    HomeWidget.routeName,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.leftToRight,
                                      ),
                                    },
                                  );
                                },
                                text: 'GET STARTED!!',
                                options: FFButtonOptions(
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFF1A9C0E),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.manrope(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ).addWalkthrough(
                                buttonUx6svqrw,
                                _model.onboardingHomeController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: smooth_page_indicator.SmoothPageIndicator(
                          controller: _model.pageViewController ??=
                              PageController(initialPage: 0),
                          count: 4,
                          axisDirection: Axis.horizontal,
                          onDotClicked: (i) async {
                            await _model.pageViewController!.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            safeSetState(() {});
                          },
                          effect: smooth_page_indicator.SlideEffect(
                            spacing: 8.0,
                            radius: 8.0,
                            dotWidth: 8.0,
                            dotHeight: 8.0,
                            dotColor: FlutterFlowTheme.of(context).accent1,
                            activeDotColor:
                                FlutterFlowTheme.of(context).primary,
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TutorialCoachMark createPageWalkthrough(BuildContext context) =>
      TutorialCoachMark(
        targets: createWalkthroughTargets(context),
        onFinish: () async {
          safeSetState(() => _model.onboardingHomeController = null);
        },
        onSkip: () {
          return true;
        },
      );
}
