import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:pomogrow/features/auth/data/supabase_repo.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = Provider<AuthState>((ref) {
  return AuthState();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final repo = ref.watch(authRepositoryProvider);
      return AuthController(repo);
    });

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo) : super(const AsyncData(null));

  final AuthRepository _repo;

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _repo.signInWithGoogle();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
