import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
