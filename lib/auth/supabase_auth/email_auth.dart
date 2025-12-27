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
  // Use deep link for email confirmation redirect
  const String redirectUrl = 'uniquest://uniquest.com/email-confirm';
  
  final AuthResponse res = await SupaFlow.client.auth.signUp(
    email: email,
    password: password,
    emailRedirectTo: redirectUrl,
  );

  // Return the user even if email is not confirmed yet
  // The user will be able to complete signup after email verification
  return res.user;
}
