import '/backend/supabase/supabase.dart';

Future<User?> emailSignInFunc(
  String email,
  String password,
) async {
  final AuthResponse res = await SupaFlow.client.auth
      .signInWithPassword(email: email, password: password);
  return res.user;
}

Future<User?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  final AuthResponse res = await SupaFlow.client.auth.signUp(
    email: email,
    password: password,
    // No emailRedirectTo - let Supabase use the default site URL configured in dashboard
  );

  // Return the user even if email is not confirmed yet
  // The user will be able to complete signup after email verification
  return res.user;
}
