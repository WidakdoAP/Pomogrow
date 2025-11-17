import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

import 'package:pomogrow/core/error/exceptions.dart';
import 'package:pomogrow/core/error/failures.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failures, UserEntity?>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, UserEntity?>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDatasource.signIn(
        email: email,
        password: password,
      );
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<void> signInWithGoogle() {
    return remoteDatasource.signInWithGoogle();
  }

  @override
  Stream<AuthState> getAuthStateChange() {
    return remoteDatasource.getAuthStateChange();
  }
}
