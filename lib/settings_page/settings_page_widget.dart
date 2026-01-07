import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/audio_manager.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'settings_page_model.dart';
export 'settings_page_model.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  static String routeName = 'settingsPage';
  static String routePath = '/settingsPage';

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  late SettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Feather',
                color: const Color(0xFFFFBD59),
                fontSize: 32.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 390.0,
              child: Divider(
                thickness: 1.0,
                indent: 3.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 0.0, 0.0),
              child: Text(
                'Please evaluate your options below.',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Feather',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                // Audio Settings Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    'Audio',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Feather',
                          color: const Color(0xFFFFBD59),
                          fontSize: 12.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                // BGM Toggle
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: const Color(0x33FFBD59),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.music_note_rounded,
                                  color: Color(0xFFFFBD59),
                                  size: 24.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                'Background Music',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Feather',
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
                            value: AudioManager().isBgmEnabled,
                            onChanged: (value) async {
                              await AudioManager().toggleBgm(value);
                              setState(() {});
                            },
                            activeColor: const Color(0xFFFFBD59),
                            activeTrackColor: const Color(0x80FFBD59),
                            inactiveThumbColor: const Color(0xFF6B7280),
                            inactiveTrackColor: const Color(0xFF3A3A3A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // BGM Volume Slider
                if (AudioManager().isBgmEnabled)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Music Volume',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Feather',
                                      color: const Color(0xFFB0B0B0),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                '${(AudioManager().bgmVolume * 100).round()}%',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Feather',
                                      color: const Color(0xFFFFBD59),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4.0,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                            ),
                            child: Slider(
                              value: AudioManager().bgmVolume,
                              onChanged: (value) async {
                                await AudioManager().setBgmVolume(value);
                                setState(() {});
                              },
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFFFFBD59),
                              inactiveColor: const Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // SFX Toggle
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: const Color(0x33FFBD59),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.volume_up_rounded,
                                  color: Color(0xFFFFBD59),
                                  size: 24.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                'Sound Effects',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Feather',
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          Switch.adaptive(
                            value: AudioManager().isSfxEnabled,
                            onChanged: (value) async {
                              await AudioManager().toggleSfx(value);
                              setState(() {});
                            },
                            activeColor: const Color(0xFFFFBD59),
                            activeTrackColor: const Color(0x80FFBD59),
                            inactiveThumbColor: const Color(0xFF6B7280),
                            inactiveTrackColor: const Color(0xFF3A3A3A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SFX Volume Slider
                if (AudioManager().isSfxEnabled)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SFX Volume',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Feather',
                                      color: const Color(0xFFB0B0B0),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                '${(AudioManager().sfxVolume * 100).round()}%',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Feather',
                                      color: const Color(0xFFFFBD59),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4.0,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                            ),
                            child: Slider(
                              value: AudioManager().sfxVolume,
                              onChanged: (value) async {
                                await AudioManager().setSfxVolume(value);
                                setState(() {});
                              },
                              min: 0.0,
                              max: 1.0,
                              activeColor: const Color(0xFFFFBD59),
                              inactiveColor: const Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  width: 390.0,
                  child: Divider(
                    thickness: 1.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(AccountSettingsWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Account',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Feather',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(SupportWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FAQs & Support',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Feather',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(TermsWidget.routeName);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Terms & Conditions',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Feather',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'App Versions',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: 'Feather',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 30.0, 0.0),
                  child: FutureBuilder<List<ProfilesRow>>(
                    future: ProfilesTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull(
                        'isAdmin',
                        true,
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
                      List<ProfilesRow> adminProfilesRowList = snapshot.data!;

                      final adminProfilesRow = adminProfilesRowList.isNotEmpty
                          ? adminProfilesRowList.first
                          : null;

                      return FlutterFlowIconButton(
                        borderColor: FlutterFlowTheme.of(context).primaryText,
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: const Color(0xFF1E1E1E),
                        icon: Icon(
                          Icons.admin_panel_settings_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          if (adminProfilesRow?.isAdmin == true) {
                            context.pushNamed(AdminDashboardWidget.routeName);
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  title: const Text(
                                    'Restricted',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  content: const Text(
                                    'This function is not meant for users.',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
              child: Text(
                'v0.0.1',
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Feather',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  await authManager.signOut();
                  GoRouter.of(context).clearRedirectLocation();

                  context.goNamedAuth(WelcomeWidget.routeName, context.mounted);
                },
                text: 'Log Out',
                options: FFButtonOptions(
                  height: 50.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: const Color(0xFF1E1E1E),
                  textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Feather',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primaryText,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ].addToEnd(const SizedBox(height: 64.0)),
        ),
      ),
    );
  }
}
