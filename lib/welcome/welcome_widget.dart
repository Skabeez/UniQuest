import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'welcome_model.dart';
export 'welcome_model.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  static String routeName = 'welcome';
  static String routePath = '/welcome';

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin {
  late WelcomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 3200.0.ms,
            begin: const Offset(0.0, -80.0),
            end: const Offset(0.0, 0.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 3200.0.ms,
            duration: 3200.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.0, -80.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/dark_gradient.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: const Color(0xFF000000).withValues(alpha: 0.35),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/jsons/Rocket_in_space.json',
                              width: 84.0,
                              height: 124.0,
                              fit: BoxFit.contain,
                              frameRate: FrameRate.max,
                              animate: true,
                            ),
                            const SizedBox(width: 8),
                            AutoSizeText(
                              'UniQuest',
                              style: FlutterFlowTheme.of(context)
                                  .displayLarge
                                  .override(
                                    fontFamily: 'Feather',
                                    color: Colors.white,
                                    fontSize: 48.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      Shadow(
                                        color: Color(0x55000000),
                                        offset: Offset(0, 2),
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Achieve more. One quest at a time.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: 'Feather',
                                color: Colors.white70,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ).animateOnPageLoad(
                          animationsMap['textOnPageLoadAnimation2']!,
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Feather',
                                      color: const Color(0xFFFFD63E),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation1']!,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Every task counts. Every achievement matters.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Feather',
                                      color: Colors.white70,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed(
                                    SignupWidget.routeName,
                                    extra: {
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 250),
                                      ),
                                    },
                                  );
                                },
                                text: 'Get Started',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 56.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFFFFBD59),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Colors.black,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                  elevation: 4.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(40.0),
                                  hoverColor: const Color(0xFFFFD37A),
                                ),
                              ),
                              const SizedBox(height: 12),
                              FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed(
                                    LoginRedirectWidget.routeName,
                                    extra: {
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.leftToRight,
                                        duration: Duration(milliseconds: 250),
                                      ),
                                    },
                                  );
                                },
                                text: 'I already have an account',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 56.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                  elevation: 0.0,
                                  borderSide: const BorderSide(
                                    color: Colors.white54,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(40.0),
                                  hoverColor: Colors.white10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
