import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "pomogrow://login-callback/",
    );
  }
}

class AuthState {
  final authState = Supabase.instance.client.auth.onAuthStateChange;
}
