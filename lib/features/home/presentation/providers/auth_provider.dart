import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/home/data/repositories/auth_repository.dart';
import 'package:pomogrow/features/home/domain/repositories/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepo>((ref) {
  return AuthRepositoryImpl(Supabase.instance.client);
});

class AuthNotifier extends Notifier<void> {
  late final AuthRepo _repo;

  @override
  void build() {
    _repo = ref.read(authRepositoryProvider);
  }

  Future<void> logout() async {
    await _repo.signOut();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, void>(
  () => AuthNotifier(),
);
