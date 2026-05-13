import 'package:pomogrow/features/home/domain/repositories/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepo {
  final SupabaseClient supabase;
  AuthRepositoryImpl(this.supabase);

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
