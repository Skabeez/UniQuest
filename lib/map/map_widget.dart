import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'map_model.dart';
export 'map_model.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  static String routeName = 'map';
  static String routePath = '/map';

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapModel());

    AudioManager().playMainBgm();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0F1419),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F1419),
          ),
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 394.2,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F1419),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 10.0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Map',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Feather',
                                        color: Colors.white,
                                        fontSize: 32.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 10.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    AudioManager().playSfx('button_soft.mp3');
                                    context.pushNamed(HomeWidget.routeName);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ClipRRect(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F1419),
                      ),
                      child: Stack(
                        children: [
                          // Instruction text at top
                          if (!FFAppState().showInfoCard)
                            Positioned(
                              top: 16.0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xE6000000),
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: const Color(0xFFFFBD59)
                                          .withOpacity(0.3),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.touch_app,
                                        color: Color(0xFFFFBD59),
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Tap the pins to explore campus buildings',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Feather',
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  AudioManager().playSfx('button_soft.mp3');
                                  FFAppState().showInfoCard = false;
                                  safeSetState(() {});
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/greenmap.png',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.08, -0.18),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'Rolle Hall';
                                FFAppState().selectedPinImage =
                                    'assets/images/Rolle.jpg';
                                FFAppState().selectedPinDescription =
                                    ' A large multipurpose hall named after first university president Santiago M. Rolle; accommodates around 250 people and is used for receptions, seminars, workshops, and other events.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.62, 0.07),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CEMDS Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/cemds.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Economics, Management and Development Studies (CEMDS): Offers business, economics, and development‑oriented programs.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.36, 0.06),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'University Library';
                                FFAppState().selectedPinImage =
                                    'assets/images/UL.jpg';
                                FFAppState().selectedPinDescription =
                                    'Central library with print and digital resources and study spaces for all colleges.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.45, 0.11),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'CAFENR Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CAFENR.png';
                                FFAppState().selectedPinDescription =
                                    'College of Agriculture, Food, Environment and Natural Resources; offers agriculture, food tech, and environmental programs.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.7, 0.14),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'Chapel';
                                FFAppState().selectedPinImage =
                                    'assets/images/chapel.jpg';
                                FFAppState().selectedPinDescription =
                                    'Campus chapel for masses, worship services, and other spiritual activities.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.12, -0.03),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CAS Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CAS.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Arts and Sciences; houses science, math, social science, and humanities classrooms and labs.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.17, -0.33),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CVMBS Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CVMBS.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Veterinary Medicine and Biomedical Sciences; houses vet medicine and biomedical programs, classrooms, labs, and clinical training facilities for animal health and research.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.68, -0.21),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'Saluysoy Resort';
                                FFAppState().selectedPinImage =
                                    'assets/images/Saluysoy.jpg';
                                FFAppState().selectedPinDescription =
                                    ' On‑campus water‑sports and recreation area, also serving as a canteen spot where students can relax, and buy food and drinks between classes.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.23, 0.31),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'CSPEAR Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CSPEAR.png';
                                FFAppState().selectedPinDescription =
                                    'College of Sports, Physical Education and Recreation; manages PE classes and sports programs using campus sports facilities.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.67, 0.25),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CCJ Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CCJ.png';
                                FFAppState().selectedPinDescription =
                                    ' College of Criminal Justice; dedicated building for criminology courses, skills training, and offices.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.6, -0.06),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'CTHM Building / IH 1';
                                FFAppState().selectedPinImage =
                                    'assets/images/CTHM.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Tourism and Hospitality Management; home of the Hospitality Management and Tourism Management programs, with hotel, restaurant, and travel‑industry training rooms for hands‑on learning.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.46, 0.16),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'Quadrangle';
                                FFAppState().selectedPinImage =
                                    'assets/images/QUAD.jpg';
                                FFAppState().selectedPinDescription =
                                    'Central open space on campus used as a gathering area for students,and outdoor activities, surrounded by key academic and administrative buildings.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.5, 0.09),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CED';
                                FFAppState().selectedPinImage =
                                    'assets/images/CED.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Education; center for teacher‑education programs and education‑related laboratories.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.39, -0.01),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CEIT Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CEIT.png';
                                FFAppState().selectedPinDescription =
                                    'College of Engineering and Information Technology; contains engineering and IT classrooms, labs, and offices.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.31, 0.06),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'Administration Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/admin.jpg';
                                FFAppState().selectedPinDescription =
                                    'Main administration building of CvSU‑Indang that houses the Office of the President, vice presidents, and other central administrative and support offices serving the whole university.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-0.1, 0.39),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'International House 2';
                                FFAppState().selectedPinImage =
                                    'assets/images/IH2.png';
                                FFAppState().selectedPinDescription =
                                    'International House II; ladies’ dormitory with air‑conditioned rooms for 2–6 students, each with bunk beds, cabinets, and private comfort rooms plus standard safety features.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.15, 0.42),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'U-Mall';
                                FFAppState().selectedPinImage =
                                    'assets/images/UM.png';
                                FFAppState().selectedPinDescription =
                                    'University Mall inside CvSU‑Indang that houses the University Food Hall, air‑conditioned restaurants, and various student‑oriented shops and stalls for everyday meals and essentials.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.31, -0.09),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'CON Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/CONpic.jpg';
                                FFAppState().selectedPinDescription =
                                    'College of Nursing; classrooms and skills labs for nursing and health‑related courses.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.15, 0.19),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName =
                                    'Student Union Building / Registrar Building';
                                FFAppState().selectedPinImage =
                                    'assets/images/Rolle.jpg';
                                FFAppState().selectedPinDescription =
                                    'Student‑centered building for organizations, activities, and support services.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.23, -0.21),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              hoverIconColor:
                                  FlutterFlowTheme.of(context).error,
                              icon: Icon(
                                Icons.location_pin,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = true;
                                FFAppState().selectedPinName = 'ICON ';
                                FFAppState().selectedPinImage =
                                    'assets/images/ICON.jpg';
                                FFAppState().selectedPinDescription =
                                    'Large indoor convention center used for orientations, assemblies, and major university events.';
                                safeSetState(() {});
                              },
                            ),
                          ),
                          if (FFAppState().showInfoCard)
                            GestureDetector(
                              onTap: () async {
                                AudioManager().playSfx('button_soft.mp3');
                                FFAppState().showInfoCard = false;
                                safeSetState(() {});
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutQuart,
                                width: double.infinity,
                                height: double.infinity,
                                color: FFAppState().showInfoCard
                                    ? const Color(0x66000000)
                                    : Colors.transparent,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Prevent dismissal when tapping the card
                                    },
                                    child: AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 750),
                                      curve: Curves.elasticOut,
                                      scale:
                                          FFAppState().showInfoCard ? 1.0 : 0.0,
                                      child: AnimatedSlide(
                                        duration:
                                            const Duration(milliseconds: 600),
                                        curve: Curves.easeOutBack,
                                        offset: FFAppState().showInfoCard
                                            ? const Offset(0, 0)
                                            : const Offset(0, 0.3),
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeOutCubic,
                                          opacity: FFAppState().showInfoCard
                                              ? 1.0
                                              : 0.0,
                                          child: Container(
                                            width: 340.0,
                                            constraints: const BoxConstraints(
                                              maxHeight: 620.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 35.0,
                                                  color: Color(0x50000000),
                                                  offset: Offset(0, 12),
                                                  spreadRadius: -5,
                                                ),
                                                BoxShadow(
                                                  blurRadius: 15.0,
                                                  color: Color(0x20000000),
                                                  offset: Offset(0, 4),
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Image at the top
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                32.0),
                                                        topRight:
                                                            Radius.circular(
                                                                32.0),
                                                      ),
                                                      child: AspectRatio(
                                                        aspectRatio: 1.3,
                                                        child: Image.asset(
                                                          FFAppState()
                                                              .selectedPinImage,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/error_image.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Title with context
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24.0,
                                                              24.0, 60.0, 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            FFAppState()
                                                                .selectedPinName,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Feather',
                                                                  color: const Color(
                                                                      0xFF1A1A1A),
                                                                  fontSize:
                                                                      26.0,
                                                                  letterSpacing:
                                                                      -0.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                              height: 12.0),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical: 6.0,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                          0xFFFFBD59)
                                                                      .withOpacity(
                                                                          0.15),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  border: Border
                                                                      .all(
                                                                    color: const Color(
                                                                            0xFFFFBD59)
                                                                        .withOpacity(
                                                                            0.3),
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      size:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xFFD89E3D),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4.0),
                                                                    Text(
                                                                      'Campus Location',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Feather',
                                                                            color:
                                                                                const Color(0xFFD89E3D),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
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
                                                    // Description with scroll indicator
                                                    Flexible(
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    24.0,
                                                                    0,
                                                                    24.0,
                                                                    28.0),
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              child: Text(
                                                                FFAppState()
                                                                    .selectedPinDescription,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      color: const Color(
                                                                          0xFF4A4A4A),
                                                                      font: GoogleFonts
                                                                          .openSans(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height:
                                                                            1.65,
                                                                      ),
                                                                      fontSize:
                                                                          15.5,
                                                                      letterSpacing:
                                                                          0.2,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          // Scroll fade indicator at bottom
                                                          Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            height: 40.0,
                                                            child:
                                                                IgnorePointer(
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      Color(
                                                                          0x00FFFFFF),
                                                                      Color(
                                                                          0xFFFFFFFF),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Close button with better touch target
                                                Positioned(
                                                  top: 12.0,
                                                  right: 12.0,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                      onTap: () async {
                                                        AudioManager().playSfx(
                                                            'button_soft.mp3');
                                                        FFAppState()
                                                                .showInfoCard =
                                                            false;
                                                        safeSetState(() {});
                                                      },
                                                      child: Container(
                                                        width: 44.0,
                                                        height: 44.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xF5FFFFFF),
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              blurRadius: 10.0,
                                                              color: Color(
                                                                  0x30000000),
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Icon(
                                                          Icons.close_rounded,
                                                          color:
                                                              Color(0xFF2D2D2D),
                                                          size: 24.0,
                                                        ),
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
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
