import 'package:pomogrow/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, UserEntity?>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failures, UserEntity?>> signIn({
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();

  Stream<AuthState> getAuthStateChange();
}
