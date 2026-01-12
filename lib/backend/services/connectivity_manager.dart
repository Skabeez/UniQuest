import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity Manager - Singleton Service
/// Demonstrates:
/// - Singleton Pattern (single instance managing connectivity)
/// - Observer Pattern (notifies listeners of connectivity changes)
/// - Single Responsibility (only handles network connectivity)
class ConnectivityManager {
  static final ConnectivityManager _instance = ConnectivityManager._internal();

  factory ConnectivityManager() => _instance;

  ConnectivityManager._internal() {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  bool _isOnline = true;

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  /// Initialize connectivity monitoring
  void _initialize() {
    // Check initial connectivity
    _connectivity.checkConnectivity().then((results) {
      _updateConnectivityStatus(results);
    });

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectivityStatus(results);
    });
  }

  /// Update connectivity status
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    // Consider online if any connection type is available
    _isOnline = results.isNotEmpty && !results.every((r) => r == ConnectivityResult.none);

    // Notify listeners if status changed
    if (wasOnline != _isOnline) {
      // Emit first result for compatibility
      final primaryResult = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _connectivityController.add(primaryResult);
      print('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
    }
  }

  /// Check current connectivity
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(results);
    return _isOnline;
  }

  /// Dispose resources
  void dispose() {
    _connectivityController.close();
  }
}
