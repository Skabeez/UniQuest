import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Connectivity Service - Network status detection
/// Monitors internet connectivity and provides real-time status updates
/// 
/// Purpose:
/// - Detect online/offline state
/// - Provide reactive connectivity updates via Stream
/// - Verify actual internet access (not just WiFi connected)
/// - Enable offline-first architecture
/// 
/// Demonstrates:
/// - Abstract interface for connectivity monitoring
/// - Stream-based reactive programming
/// - Observer Pattern (connectivity listeners)
abstract class ConnectivityService {
  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================
  
  // ignore: unused_field
  final Connectivity _connectivity = Connectivity();
  // ignore: unused_field
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Current connectivity status
  /// true = online, false = offline
  // ignore: unused_field
  bool _isOnline = true;

  /// Stream controller for connectivity changes
  /// Broadcasts connectivity status to listeners
  // ignore: unused_field
  StreamController<bool>? _connectivityController;

  /// Subscription to connectivity_plus stream
  // ignore: unused_field
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // ============================================================================
  // CONFIGURATION
  // ============================================================================
  
  /// Timeout for ping requests (3 seconds)
  static const Duration pingTimeout = Duration(seconds: 3);
  
  /// Interval for periodic connectivity checks (30 seconds)
  static const Duration checkInterval = Duration(seconds: 30);
  
  /// Number of ping retries before marking as offline
  static const int maxPingRetries = 2;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize connectivity service
  /// Sets up listeners and performs initial connectivity check
  /// Should be called in main() before runApp()
  Future<void> initialize();

  /// Dispose service and cleanup resources
  /// Cancels subscriptions and closes streams
  void dispose();

  /// Check if service is initialized
  bool get isInitialized;

  // ============================================================================
  // CONNECTIVITY STATUS
  // ============================================================================

  /// Check if device is connected to internet
  /// Returns cached status (fast, no network call)
  /// 
  /// @return true if online, false if offline
  bool get isConnected;

  /// Perform fresh connectivity check
  /// Checks device network status + pings Supabase
  /// 
  /// @return true if online and can reach Supabase
  Future<bool> checkConnectivity();

  /// Get current connectivity result
  /// Returns WiFi, mobile, ethernet, or none
  Future<List<ConnectivityResult>> getConnectivityResult();

  /// Check if connected to WiFi
  Future<bool> isConnectedToWiFi();

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile();

  /// Check if connected to ethernet
  Future<bool> isConnectedToEthernet();

  /// Check if airplane mode is enabled
  Future<bool> isAirplaneModeEnabled();

  // ============================================================================
  // REACTIVE CONNECTIVITY STREAM
  // ============================================================================

  /// Stream of connectivity status changes
  /// Emits true when going online, false when going offline
  /// 
  /// Usage:
  /// ```dart
  /// connectivityService.onConnectivityChanged.listen((isOnline) {
  ///   if (isOnline) {
  ///     print('Back online!');
  ///   } else {
  ///     print('Went offline');
  ///   }
  /// });
  /// ```
  Stream<bool> get onConnectivityChanged;

  /// Listen to connectivity changes with callback
  /// Convenience method for simple listeners
  /// 
  /// @param onChanged - Callback invoked on connectivity change
  /// @return StreamSubscription for cancellation
  StreamSubscription<bool> listenToConnectivity(
    void Function(bool isOnline) onChanged,
  );

  // ============================================================================
  // INTERNET VERIFICATION
  // ============================================================================

  /// Ping Supabase to verify actual internet access
  /// Performs lightweight request to check server reachability
  /// 
  /// Note: Device can show "connected" but have no internet
  /// This verifies we can actually reach our backend
  /// 
  /// @return true if Supabase is reachable
  // ignore: unused_element
  Future<bool> _pingSupabase();

  /// Ping with retry logic
  /// Retries up to maxPingRetries times before failing
  // ignore: unused_element
  Future<bool> _pingWithRetry();

  /// Ping custom endpoint
  /// Allows testing connectivity to other services
  Future<bool> pingEndpoint(String url);

  /// Check DNS resolution
  /// Verifies internet routing works
  Future<bool> checkDnsResolution();

  // ============================================================================
  // CONNECTIVITY MONITORING
  // ============================================================================

  /// Start periodic connectivity checks
  /// Checks connectivity every checkInterval
  /// Useful for detecting connectivity changes not caught by stream
  void startPeriodicChecks();

  /// Stop periodic connectivity checks
  void stopPeriodicChecks();

  /// Force connectivity refresh
  /// Manually triggers connectivity check and notifies listeners
  Future<void> refreshConnectivity();

  // ============================================================================
  // CONNECTIVITY EVENTS
  // ============================================================================

  /// Handle connectivity change event
  /// Called when connectivity_plus detects a change
  /// Verifies with ping before updating status
  // ignore: unused_element
  Future<void> _handleConnectivityChange(List<ConnectivityResult> results);

  /// Update connectivity status
  /// Updates internal state and notifies listeners if changed
  // ignore: unused_element
  void _updateConnectivityStatus(bool isOnline);

  /// Notify listeners of connectivity change
  /// Broadcasts to onConnectivityChanged stream
  // ignore: unused_element
  void _notifyListeners(bool isOnline);

  // ============================================================================
  // CONNECTIVITY HELPERS
  // ============================================================================

  /// Check if connectivity result indicates connection
  /// Converts ConnectivityResult to boolean
  // ignore: unused_element
  bool _hasNetworkConnection(List<ConnectivityResult> results);

  /// Get connection type as string
  /// Returns "WiFi", "Mobile", "Ethernet", or "None"
  String getConnectionType();

  /// Get connection quality estimate
  /// Returns "good", "poor", or "none"
  /// Based on connection type and ping latency
  Future<String> getConnectionQuality();

  /// Measure ping latency
  /// Returns latency in milliseconds
  Future<int?> measureLatency();

  // ============================================================================
  // OFFLINE CALLBACKS
  // ============================================================================

  /// Register callback for going offline
  /// Invoked when connectivity lost
  void onOffline(VoidCallback callback);

  /// Register callback for going online
  /// Invoked when connectivity restored
  void onOnline(VoidCallback callback);

  /// Unregister offline callback
  void removeOfflineCallback(VoidCallback callback);

  /// Unregister online callback
  void removeOnlineCallback(VoidCallback callback);

  // ============================================================================
  // CONNECTIVITY HISTORY
  // ============================================================================

  /// Get connectivity status history
  /// Returns list of connectivity events with timestamps
  List<ConnectivityEvent> getConnectivityHistory();

  /// Record connectivity event
  /// Stores event in history for analytics
  // ignore: unused_element
  void _recordConnectivityEvent(bool isOnline);

  /// Clear connectivity history
  void clearHistory();

  /// Get total offline duration today
  /// Returns duration device was offline
  Duration getOfflineDurationToday();

  /// Get total online duration today
  Duration getOnlineDurationToday();

  // ============================================================================
  // DEBUGGING & DIAGNOSTICS
  // ============================================================================

  /// Get detailed connectivity info
  /// Returns map with connection type, status, latency, etc.
  Future<Map<String, dynamic>> getConnectivityInfo();

  /// Export connectivity diagnostics
  /// Returns detailed diagnostic report
  Future<Map<String, dynamic>> exportDiagnostics();

  /// Test connectivity to Supabase
  /// Performs comprehensive connectivity test
  Future<ConnectivityTestResult> testSupabaseConnectivity();

  /// Get last connectivity check timestamp
  DateTime? getLastCheckTime();

  /// Get time since last check
  Duration? getTimeSinceLastCheck();
}

// ============================================================================
// SUPPORTING CLASSES
// ============================================================================

/// Connectivity event record
class ConnectivityEvent {
  final DateTime timestamp;
  final bool isOnline;
  final String connectionType;

  ConnectivityEvent({
    required this.timestamp,
    required this.isOnline,
    required this.connectionType,
  });
}

/// Connectivity test result
class ConnectivityTestResult {
  final bool isReachable;
  final int? latencyMs;
  final String connectionType;
  final String? errorMessage;

  ConnectivityTestResult({
    required this.isReachable,
    this.latencyMs,
    required this.connectionType,
    this.errorMessage,
  });
}

/// Callback typedefs for readability
typedef VoidCallback = void Function();
