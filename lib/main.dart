import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/config/env_config.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'services/audio_manager.dart';
import 'services/sound_effects.dart';
import 'services/cache_service_impl.dart';
import 'backend/services/connectivity_manager.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Initialize environment configuration
  await EnvConfig.initialize();

  await initFirebase();

  await SupaFlow.initialize();

  await FlutterFlowTheme.initialize();

  // Initialize cache manager for offline support
  await CacheServiceImpl().initialize();

  // Initialize connectivity manager
  ConnectivityManager();

  // Initialize audio manager
  await AudioManager().initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = uniQuestSupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 5),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UniQuest',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage>
    with SingleTickerProviderStateMixin {
  String _currentPageName = 'home';
  late Widget? _currentPage;
  bool _isNavBarVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _hideNavBar() {
    if (_isNavBarVisible) {
      setState(() => _isNavBarVisible = false);
      _animationController.forward();
    }
  }

  void _showNavBar() {
    if (!_isNavBarVisible) {
      setState(() => _isNavBarVisible = true);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'profilePage': const ProfilePageWidget(),
      'notif': const NotifWidget(),
      'home': const HomeWidget(),
      'todoList': const TodoListWidget(),
      'settingsPage': const SettingsPageWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    final currentPage = _currentPage ?? tabs[_currentPageName]!;

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final currentPosition = notification.metrics.pixels;
            final isScrollable = notification.metrics.maxScrollExtent > 0;
            if (isScrollable) {
              if (currentPosition > _lastScrollPosition &&
                  currentPosition > 50) {
                // Scrolling down
                _hideNavBar();
              } else if (currentPosition < _lastScrollPosition) {
                // Scrolling up
                _showNavBar();
              }
              _lastScrollPosition = currentPosition;
            } else {
              // Content not scrollable, always show navbar
              _showNavBar();
            }
          }
          return true;
        },
        child: currentPage,
      ),
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F1419),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFFFBD59).withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  index: 0,
                  currentIndex: currentIndex,
                ),
                FutureBuilder<List<NotificationsRow>>(
                  future: NotificationsTable().queryRows(
                    queryFn: (q) => q
                        .eqOrNull('user_id', currentUserUid)
                        .eqOrNull('is_read', false),
                  ),
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.data?.length ?? 0;
                    return _buildNavItem(
                      icon: Icons.notifications_outlined,
                      activeIcon: Icons.notifications_rounded,
                      label: 'Inbox',
                      index: 1,
                      currentIndex: currentIndex,
                      badge: unreadCount > 0
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF0F1419),
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  index: 2,
                  currentIndex: currentIndex,
                  isCenter: true,
                ),
                _buildNavItem(
                  icon: Icons.check_box_outlined,
                  activeIcon: Icons.check_box_rounded,
                  label: 'Tasks',
                  index: 3,
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Settings',
                  index: 4,
                  currentIndex: currentIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    bool isCenter = false,
    Widget? badge,
  }) {
    final isActive = currentIndex == index;
    final tabs = ['profilePage', 'notif', 'home', 'todoList', 'settingsPage'];

    return Expanded(
      child: GestureDetector(
        onTap: () {
          AudioManager().playSfx(SoundEffects.buttonSoft);
          _showNavBar(); // Ensure navbar is visible when tapping
          safeSetState(() {
            _currentPage = null;
            _currentPageName = tabs[index];
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? const Color(0xFFFFBD59)
                    : const Color(0xFF6B7280),
                size: isActive ? 28.0 : 24.0,
              ),
              if (badge != null)
                Positioned(
                  right: -8,
                  top: -4,
                  child: badge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
