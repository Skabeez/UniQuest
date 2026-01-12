import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_quest/config/env_config.dart';

export 'database/database.dart';

// Supabase configuration loaded from .env file
String get _kSupabaseUrl => EnvConfig.supabaseUrl;
String get _kSupabaseAnonKey => EnvConfig.supabaseAnonKey;

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
