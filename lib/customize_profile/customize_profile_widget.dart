import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/avatar/avatar_widget.dart';
import '/components/background/background_widget.dart';
import '/components/frame/frame_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'customize_profile_model.dart';
export 'customize_profile_model.dart';

class CustomizeProfileWidget extends StatefulWidget {
  const CustomizeProfileWidget({super.key});

  static String routeName = 'customizeProfile';
  static String routePath = '/customizeProfile';

  @override
  State<CustomizeProfileWidget> createState() => _CustomizeProfileWidgetState();
}

class _CustomizeProfileWidgetState extends State<CustomizeProfileWidget>
    with TickerProviderStateMixin {
  late CustomizeProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomizeProfileModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
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
        backgroundColor: const Color(0xFF1E1E1E),
        body: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Stack(
            alignment: const AlignmentDirectional(0.0, 0.0),
            children: [
              ListView(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  FutureBuilder<List<ProfilesRow>>(
                    future: ProfilesTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull(
                        'id',
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
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<ProfilesRow> coverAndProfilePicProfilesRowList =
                          snapshot.data!;

                      final _ =
                          coverAndProfilePicProfilesRowList.isNotEmpty
                              ? coverAndProfilePicProfilesRowList.first
                              : null;

                      return SizedBox(
                        width: double.infinity,
                        height: 230.0,
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 250.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(0.0),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                FutureBuilder<
                                                    List<ProfilesRow>>(
                                                  future: ProfilesTable()
                                                      .querySingleRow(
                                                    queryFn: (q) => q.eqOrNull(
                                                      'id',
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
                                                    List<ProfilesRow>
                                                        backgroundImageProfilesRowList =
                                                        snapshot.data!;

                                                    final backgroundImageProfilesRow =
                                                        backgroundImageProfilesRowList
                                                                .isNotEmpty
                                                            ? backgroundImageProfilesRowList
                                                                .first
                                                            : null;

                                                    return ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                70.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                70.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                0.0),
                                                      ),
                                                      child: Image.network(
                                                        backgroundImageProfilesRow!
                                                            .equippedNamecard,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  50.0,
                                                                  0.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        borderRadius: 40.0,
                                                        borderWidth: 2.0,
                                                        buttonSize: 40.0,
                                                        fillColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent4,
                                                        icon: Icon(
                                                          Icons.arrow_back,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          size: 24.0,
                                                        ),
                                                        onPressed: () async {
                                                          context.safePop();
                                                        },
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: FutureBuilder<
                                                          List<ProfilesRow>>(
                                                        future: ProfilesTable()
                                                            .querySingleRow(
                                                          queryFn: (q) =>
                                                              q.eqOrNull(
                                                            'id',
                                                            currentUserUid,
                                                          ),
                                                        ),
                                                        builder: (context,
                                                            snapshot) {
                                                          // Customize what your widget looks like when it's loading.
                                                          if (!snapshot
                                                              .hasData) {
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
                                                          List<ProfilesRow>
                                                              avatarContainerProfilesRowList =
                                                              snapshot.data!;

                                                          final avatarContainerProfilesRow =
                                                              avatarContainerProfilesRowList
                                                                      .isNotEmpty
                                                                  ? avatarContainerProfilesRowList
                                                                      .first
                                                                  : null;

                                                          return Container(
                                                            width: 150.0,
                                                            height: 150.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent4,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Stack(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        130.0,
                                                                    height:
                                                                        130.0,
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      avatarContainerProfilesRow!
                                                                          .avatarUrl!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 350.0,
                                                                  height: 350.0,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    avatarContainerProfilesRow
                                                                        .equippedBorder,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
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
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 600.0,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: const Alignment(-1.0, 0),
                            child: TabBar(
                              isScrollable: true,
                              labelColor: FlutterFlowTheme.of(context).tertiary,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              labelPadding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Feather',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                              unselectedLabelStyle: const TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).primary,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              tabs: const [
                                Tab(
                                  text: 'Avatar',
                                ),
                                Tab(
                                  text: 'Avatar Frame',
                                ),
                                Tab(
                                  text: 'Background',
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [() async {}, () async {}, () async {}][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 550.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(15.0, 18.0,
                                                          15.0, 0.0),
                                                  child: FutureBuilder<
                                                      List<UserCosmeticsRow>>(
                                                    future: UserCosmeticsTable()
                                                        .queryRows(
                                                      queryFn: (q) => q
                                                          .eqOrNull(
                                                            'user_id',
                                                            currentUserUid,
                                                          )
                                                          .eqOrNull(
                                                            'type',
                                                            'avatar',
                                                          ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
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
                                                      List<UserCosmeticsRow>
                                                          gridViewUserCosmeticsRowList =
                                                          snapshot.data!;

                                                      return GridView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          crossAxisSpacing:
                                                              10.0,
                                                          mainAxisSpacing: 10.0,
                                                          childAspectRatio: 1.0,
                                                        ),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            gridViewUserCosmeticsRowList
                                                                .length,
                                                        itemBuilder: (context,
                                                            gridViewIndex) {
                                                          final gridViewUserCosmeticsRow =
                                                              gridViewUserCosmeticsRowList[
                                                                  gridViewIndex];
                                                          return wrapWithModel(
                                                            model: _model
                                                                .avatarModels
                                                                .getModel(
                                                              gridViewUserCosmeticsRow
                                                                  .id,
                                                              gridViewIndex,
                                                            ),
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child: AvatarWidget(
                                                              key: Key(
                                                                'Keyqrk_${gridViewUserCosmeticsRow.id}',
                                                              ),
                                                              avatarurl:
                                                                  gridViewUserCosmeticsRow
                                                                      .imageUrl,
                                                              avatarid:
                                                                  gridViewUserCosmeticsRow
                                                                      .id,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 500.0,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: FutureBuilder<
                                                    List<UserCosmeticsRow>>(
                                                  future: UserCosmeticsTable()
                                                      .queryRows(
                                                    queryFn: (q) => q
                                                        .eqOrNull(
                                                          'user_id',
                                                          currentUserUid,
                                                        )
                                                        .eqOrNull(
                                                          'type',
                                                          'frame',
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
                                                    List<UserCosmeticsRow>
                                                        gridViewUserCosmeticsRowList =
                                                        snapshot.data!;

                                                    return GridView.builder(
                                                      padding: EdgeInsets.zero,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        crossAxisSpacing: 10.0,
                                                        mainAxisSpacing: 10.0,
                                                        childAspectRatio: 1.0,
                                                      ),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          gridViewUserCosmeticsRowList
                                                              .length,
                                                      itemBuilder: (context,
                                                          gridViewIndex) {
                                                        final gridViewUserCosmeticsRow =
                                                            gridViewUserCosmeticsRowList[
                                                                gridViewIndex];
                                                        return wrapWithModel(
                                                          model: _model
                                                              .frameModels
                                                              .getModel(
                                                            gridViewUserCosmeticsRow
                                                                .id,
                                                            gridViewIndex,
                                                          ),
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child: FrameWidget(
                                                            key: Key(
                                                              'Key2un_${gridViewUserCosmeticsRow.id}',
                                                            ),
                                                            id: gridViewUserCosmeticsRow
                                                                .id,
                                                            url:
                                                                gridViewUserCosmeticsRow
                                                                    .imageUrl,
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
                                Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 500.0,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FutureBuilder<
                                                      List<UserCosmeticsRow>>(
                                                    future: UserCosmeticsTable()
                                                        .queryRows(
                                                      queryFn: (q) => q
                                                          .eqOrNull(
                                                            'user_id',
                                                            currentUserUid,
                                                          )
                                                          .eqOrNull(
                                                            'type',
                                                            'namecard',
                                                          ),
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
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
                                                      List<UserCosmeticsRow>
                                                          gridViewUserCosmeticsRowList =
                                                          snapshot.data!;

                                                      return GridView.builder(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                          0,
                                                          10.0,
                                                          0,
                                                          0,
                                                        ),
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 10.0,
                                                          childAspectRatio: 2.0,
                                                        ),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            gridViewUserCosmeticsRowList
                                                                .length,
                                                        itemBuilder: (context,
                                                            gridViewIndex) {
                                                          final gridViewUserCosmeticsRow =
                                                              gridViewUserCosmeticsRowList[
                                                                  gridViewIndex];
                                                          return wrapWithModel(
                                                            model: _model
                                                                .backgroundModels
                                                                .getModel(
                                                              gridViewUserCosmeticsRow
                                                                  .id,
                                                              gridViewIndex,
                                                            ),
                                                            updateCallback: () =>
                                                                safeSetState(
                                                                    () {}),
                                                            child:
                                                                BackgroundWidget(
                                                              key: Key(
                                                                'Keyl5v_${gridViewUserCosmeticsRow.id}',
                                                              ),
                                                              id: gridViewUserCosmeticsRow
                                                                  .id,
                                                              url:
                                                                  gridViewUserCosmeticsRow
                                                                      .imageUrl,
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
