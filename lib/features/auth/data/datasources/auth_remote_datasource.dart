import 'package:pomogrow/core/error/exceptions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserEntity?> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserEntity?> signIn({required String email, required String password});
  Future<void> signInWithGoogle();
  Stream<AuthState> getAuthStateChange();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final SupabaseClient client;
  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserEntity?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signUp(
        data: {'name': name},
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const ServerException("User doesn't exist!");
      }
      return UserEntity(id: user.id, name: name, email: email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null || response.session == null) {
        throw const ServerException("Email atau password salah");
      }

      final user = response.user!;
      final userMetadata = user.userMetadata;
      return UserEntity(
        id: user.id,
        name: userMetadata?['name'] ?? 'User',
        email: user.email ?? '',
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException("Terjadi kesalahan: $e");
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "pomogrow://login-callback/",
    );
  }

  @override
  Stream<AuthState> getAuthStateChange() {
    return client.auth.onAuthStateChange;
  }
}
