import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration Wrapper for UniQuest
/// 
/// Provides centralized access to environment variables loaded from .env file.
/// Uses flutter_dotenv package for secure key management.
/// 
/// Design Principles:
/// - Sensitive keys stored in .env (not committed to git)
/// - Type-safe access to configuration values
/// - Validation on startup (fail fast if keys missing)
/// - Fallback values for optional configuration
/// 
/// Defense Talking Points:
/// - "Separates configuration from code"
/// - "Prevents accidental key exposure in version control"
/// - "Demonstrates security best practices"
/// - "Environment-specific configuration (dev, staging, prod)"
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize environment configuration
  /// Must be called before accessing any config values
  /// 
  /// Usage in main.dart:
  /// ```dart
  /// await EnvConfig.initialize();
  /// ```
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    _validateRequiredKeys();
  }

  /// Validate that all required keys are present
  /// Throws exception if any required key is missing
  static void _validateRequiredKeys() {
    final requiredKeys = [
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
    ];

    final missingKeys = <String>[];
    for (final key in requiredKeys) {
      if (!dotenv.env.containsKey(key) || dotenv.env[key]!.isEmpty) {
        missingKeys.add(key);
      }
    }

    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missingKeys.join(", ")}\n'
        'Please check your .env file and ensure all required keys are set.',
      );
    }
  }

  // ============================================================================
  // SUPABASE CONFIGURATION
  // ============================================================================

  /// Supabase project URL
  /// Format: https://[project-id].supabase.co
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env file');
    }
    return url;
  }

  /// Supabase anonymous (public) API key
  /// Used for client-side authentication and API calls
  /// Safe to expose in client apps (RLS policies protect data)
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env file');
    }
    return key;
  }

  /// Supabase service role key (optional, for admin operations)
  /// WARNING: Never use this in client-side code!
  /// Only for server-side operations or local development
  static String? get supabaseServiceKey {
    return dotenv.env['SUPABASE_SERVICE_KEY'];
  }

  // ============================================================================
  // FIREBASE CONFIGURATION (Optional)
  // ============================================================================

  /// Firebase API key (optional)
  static String? get firebaseApiKey {
    return dotenv.env['FIREBASE_API_KEY'];
  }

  /// Firebase project ID (optional)
  static String? get firebaseProjectId {
    return dotenv.env['FIREBASE_PROJECT_ID'];
  }

  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================

  /// Enable debug logging
  /// Default: false in production
  static bool get debugMode {
    final value = dotenv.env['DEBUG_MODE'];
    return value?.toLowerCase() == 'true';
  }

  /// Enable analytics
  /// Default: true
  static bool get analyticsEnabled {
    final value = dotenv.env['ANALYTICS_ENABLED'];
    return value?.toLowerCase() != 'false'; // Default true
  }

  /// Enable offline mode
  /// Default: true
  static bool get offlineModeEnabled {
    final value = dotenv.env['OFFLINE_MODE_ENABLED'];
    return value?.toLowerCase() != 'false'; // Default true
  }

  // ============================================================================
  // API ENDPOINTS (Optional external services)
  // ============================================================================

  /// External API base URL (if any)
  static String? get apiBaseUrl {
    return dotenv.env['API_BASE_URL'];
  }

  /// API timeout in seconds
  /// Default: 30 seconds
  static int get apiTimeout {
    final value = dotenv.env['API_TIMEOUT'];
    return value != null ? int.tryParse(value) ?? 30 : 30;
  }

  // ============================================================================
  // ENVIRONMENT DETECTION
  // ============================================================================

  /// Current environment (development, staging, production)
  /// Default: development
  static String get environment {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }

  /// Check if running in development environment
  static bool get isDevelopment {
    return environment == 'development';
  }

  /// Check if running in staging environment
  static bool get isStaging {
    return environment == 'staging';
  }

  /// Check if running in production environment
  static bool get isProduction {
    return environment == 'production';
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get any environment variable by key
  /// Returns null if not found
  static String? get(String key) {
    return dotenv.env[key];
  }

  /// Get environment variable with fallback
  /// Returns fallback value if key not found
  static String getOrDefault(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Check if environment variable exists
  static bool has(String key) {
    return dotenv.env.containsKey(key) && dotenv.env[key]!.isNotEmpty;
  }

  /// Print all environment variables (for debugging)
  /// WARNING: Only use in development, never in production
  static void printAll() {
    if (!isProduction) {
      print('=== Environment Configuration ===');
      dotenv.env.forEach((key, value) {
        // Mask sensitive values
        if (key.contains('KEY') || key.contains('SECRET') || key.contains('PASSWORD')) {
          print('$key: ****${value.substring(value.length - 4)}');
        } else {
          print('$key: $value');
        }
      });
      print('=================================');
    }
  }

  /// Validate Supabase configuration
  /// Returns true if valid, throws exception if invalid
  static bool validateSupabaseConfig() {
    final url = supabaseUrl;
    final key = supabaseAnonKey;

    // Validate URL format
    if (!url.startsWith('https://') || !url.contains('.supabase.co')) {
      throw Exception('Invalid SUPABASE_URL format: $url');
    }

    // Validate key format (JWT structure)
    if (!key.contains('.') || key.split('.').length != 3) {
      throw Exception('Invalid SUPABASE_ANON_KEY format (not a valid JWT)');
    }

    return true;
  }
}
