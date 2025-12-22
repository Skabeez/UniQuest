import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';

String _kSupabaseUrl = 'https://fwgzodfujdhyvxpwnrrn.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3Z3pvZGZ1amRoeXZ4cHducnJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0MzE3NjQsImV4cCI6MjA3ODAwNzc2NH0.wkFQy2YFIxIiZ260zj1hOmZbzblVMludcEUaDW5DYak';

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
