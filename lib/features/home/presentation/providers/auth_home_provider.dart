import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/home/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider((ref) {
  final client = ref.watch(authRepositoryProvider);
  return client.supabase.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
});
