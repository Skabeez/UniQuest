import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/mission/mission_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
// Switch to main app BGM when entering home
    AudioManager().playMainBgm();

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.categoriesScrollController?.addListener(() {
      setState(() {
        _model.categoriesScrollOffset =
            _model.categoriesScrollController?.offset ?? 0.0;
      });
    });

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
          backgroundColor: const Color(0xFF1E1E1E),
          body: SafeArea(
            top: true,
            bottom: false,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 20.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 8.0, 12.0, 0.0),
                              child: Container(
                                height: 140.0,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFC970),
                                      Color(0xFFFF9E4F),
                                    ],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(0.0, -1.0),
                                    end: AlignmentDirectional(0, 1.0),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 16.0,
                                      color: Color(0x33000000),
                                      offset: Offset(0.0, 8.0),
                                    ),
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x1A000000),
                                      offset: Offset(0.0, 2.0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(18.0),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 14.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 72.0,
                                        height: 72.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.25),
                                            width: 2.0,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 10.0,
                                              color: Color(0x22000000),
                                              offset: Offset(0.0, 4.0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(36.0),
                                          child: Image.asset(
                                            'assets/images/app_launcher_icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 18.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Welcome to',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Feather',
                                                  color:
                                                      const Color(0xFF3D1B00),
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            'UniQuest!',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Feather',
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Categories',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 16.0, 0.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.swipe,
                                      color: Color(0xFFFFBD59),
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFFB0B0B0),
                                      size: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 250.0,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                controller: _model.categoriesScrollController,
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 16.0, 12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                            TodoListWidget.routeName);
                                      },
                                      child: Container(
                                        width: 250.0,
                                        height: 220.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1A1F36),
                                              Color(0xFF0F1419),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 8.0),
                                            ),
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icon container
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFFB48A),
                                                      Color(0xFFFF9C6A),
                                                    ],
                                                    stops: [0.0, 1.0],
                                                    begin: AlignmentDirectional(
                                                        0.0, -1.0),
                                                    end: AlignmentDirectional(
                                                        0, 1.0),
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFFFB48A)
                                                            .withOpacity(0.35),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.checklist_rounded,
                                                  color: Color(0xFFFFE7D5),
                                                  size: 36.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Title
                                              Text(
                                                'To-Do List',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Feather',
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              // Description badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Organize Tasks',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation1']!),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 16.0, 12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                            AchievementsWidget.routeName);
                                      },
                                      child: Container(
                                        width: 250.0,
                                        height: 220.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1A1F36),
                                              Color(0xFF0F1419),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 8.0),
                                            ),
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icon container
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                          .withOpacity(0.35),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary
                                                          .withOpacity(0.12),
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                    begin:
                                                        const AlignmentDirectional(
                                                            0.0, -1.0),
                                                    end:
                                                        const AlignmentDirectional(
                                                            0, 1.0),
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondary
                                                        .withOpacity(0.35),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.emoji_events_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  size: 36.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Title
                                              Text(
                                                'Achievements',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Feather',
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              // Description badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Unlock Badges',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation2']!),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 16.0, 12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                            LeaderboardWidget.routeName);
                                      },
                                      child: Container(
                                        width: 250.0,
                                        height: 220.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1A1F36),
                                              Color(0xFF0F1419),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 8.0),
                                            ),
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icon container
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .warning
                                                          .withOpacity(0.3),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .warning
                                                          .withOpacity(0.1),
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                    begin:
                                                        const AlignmentDirectional(
                                                            0.0, -1.0),
                                                    end:
                                                        const AlignmentDirectional(
                                                            0, 1.0),
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .warning
                                                        .withOpacity(0.3),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.leaderboard_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  size: 36.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Title
                                              Text(
                                                'Leaderboard',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Feather',
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              // Description badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Compete & Climb',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation3']!),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 16.0, 12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                            CosmeticsListWidget.routeName);
                                      },
                                      child: Container(
                                        width: 250.0,
                                        height: 220.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1A1F36),
                                              Color(0xFF0F1419),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 8.0),
                                            ),
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icon container
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary
                                                          .withOpacity(0.3),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .tertiary
                                                          .withOpacity(0.1),
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                    begin:
                                                        const AlignmentDirectional(
                                                            0.0, -1.0),
                                                    end:
                                                        const AlignmentDirectional(
                                                            0, 1.0),
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary
                                                        .withOpacity(0.3),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.brush_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tertiary,
                                                  size: 36.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Title
                                              Text(
                                                'Cosmetics',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Feather',
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              // Description badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Browse Cosmetics',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation4']!),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 16.0, 12.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(MapWidget.routeName);
                                      },
                                      child: Container(
                                        width: 250.0,
                                        height: 220.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1A1F36),
                                              Color(0xFF0F1419),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 8.0),
                                            ),
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Icon container
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .warning
                                                          .withOpacity(0.3),
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .warning
                                                          .withOpacity(0.1),
                                                    ],
                                                    stops: const [0.0, 1.0],
                                                    begin:
                                                        const AlignmentDirectional(
                                                            0.0, -1.0),
                                                    end:
                                                        const AlignmentDirectional(
                                                            0, 1.0),
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .warning
                                                        .withOpacity(0.3),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.map_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  size: 36.0,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Title
                                              Text(
                                                'Map',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Feather',
                                                          color: Colors.white,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              // Description badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Navigate Campus',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Feather',
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation5']!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Scroll indicator slider
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24.0, 12.0, 24.0, 0.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                const itemWidth =
                                    266.0; // 250 card + 16 padding
                                const totalItems = 5;
                                final screenWidth =
                                    MediaQuery.of(context).size.width;
                                // Actual max scroll is total width of all items minus the visible screen width
                                final maxScroll = (itemWidth * totalItems) -
                                    screenWidth +
                                    48; // 48 = horizontal padding
                                final scrollProgress =
                                    (_model.categoriesScrollOffset / maxScroll)
                                        .clamp(0.0, 1.0);

                                final trackWidth = constraints.maxWidth;
                                const indicatorWidth = 86.0;
                                final maxIndicatorPosition =
                                    trackWidth - indicatorWidth;
                                final indicatorPosition =
                                    scrollProgress * maxIndicatorPosition;

                                return Container(
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1C1C1E),
                                        Color(0xFF111218),
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 14.0,
                                        color: Color(0x22000000),
                                        offset: Offset(0.0, 6.0),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                            vertical: 3.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2E2E32),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        duration:
                                            const Duration(milliseconds: 160),
                                        curve: Curves.easeOut,
                                        left: indicatorPosition,
                                        child: Container(
                                          width: indicatorWidth,
                                          height: 10.0,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFFD27F),
                                                Color(0xFFFFA63E),
                                              ],
                                              stops: [0.0, 1.0],
                                              begin:
                                                  AlignmentDirectional(-0.6, 0),
                                              end: AlignmentDirectional(1.0, 0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 10.0,
                                                color: Color(0x33FFB85C),
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 600.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E1E1E),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6.0,
                                    color: Color(0x1B090F13),
                                    offset: Offset(
                                      0.0,
                                      -2.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0),
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: const Alignment(0.0, 0),
                                      child: TabBar(
                                        isScrollable: true,
                                        labelColor: const Color(0xFFFFBD59),
                                        unselectedLabelColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Feather',
                                              color: const Color(0xFF0F1113),
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        unselectedLabelStyle: const TextStyle(),
                                        indicatorColor: const Color(0xFFFFBD59),
                                        indicatorWeight: 2.0,
                                        tabs: const [
                                          Tab(
                                            text: ' Missions',
                                          ),
                                        ],
                                        controller: _model.tabBarController,
                                        onTap: (i) async {
                                          [() async {}][i]();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _model.tabBarController,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                16.0, 12.0, 16.0, 12.0),
                                            child: FutureBuilder<
                                                List<UserMissionsRow>>(
                                              future:
                                                  UserMissionsTable().queryRows(
                                                queryFn: (q) => q
                                                    .eqOrNull(
                                                      'completed',
                                                      false,
                                                    )
                                                    .eqOrNull(
                                                      'is_archived',
                                                      false,
                                                    )
                                                    .eqOrNull(
                                                      'user_id',
                                                      currentUserUid,
                                                    ),
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<UserMissionsRow>
                                                    listViewUserMissionsRowList =
                                                    snapshot.data!;

                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      listViewUserMissionsRowList
                                                          .length,
                                                  itemBuilder:
                                                      (context, listViewIndex) {
                                                    final listViewUserMissionsRow =
                                                        listViewUserMissionsRowList[
                                                            listViewIndex];
                                                    return wrapWithModel(
                                                      model: _model
                                                          .missionModels
                                                          .getModel(
                                                        listViewUserMissionsRow
                                                            .missionId!,
                                                        listViewIndex,
                                                      ),
                                                      updateCallback: () =>
                                                          safeSetState(() {}),
                                                      child: MissionWidget(
                                                        key: Key(
                                                          'Keywr2_${listViewUserMissionsRow.missionId!}',
                                                        ),
                                                        missionName:
                                                            listViewUserMissionsRow
                                                                .missionTitle,
                                                        description:
                                                            listViewUserMissionsRow
                                                                .missionDescription,
                                                        status: '',
                                                        deadline: '',
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
