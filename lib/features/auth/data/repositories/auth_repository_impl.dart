import 'package:pomogrow/features/auth/data/models/user_models.dart';
import 'package:pomogrow/features/auth/domain/entities/local_auth_state.dart';
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
  Future<Either<Failures, Unit>> resetPassword({required String email}) async {
    try {
      await remoteDatasource.resetPassword(email: email);
      return const Right(unit);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, UserEntity?>> updatePassword({
    required String password,
  }) async {
    try {
      final user = await remoteDatasource.updatePassword(password: password);
      return Right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<void> signInWithGoogle() {
    return remoteDatasource.signInWithGoogle();
  }

  @override
  Stream<LocalAuthState> getAuthStateChange() {
    return remoteDatasource.getAuthStateChange().map((data) {
      final user = data.session?.user;

      return LocalAuthState(
          user: user != null ? UserModels.fromSupabase(user) : null);
    });
  }

  @override
  Future<Either<Failures, String?>> getExistingProvider(
      String email,
      ) async {
    try {
      final provider = await remoteDatasource.getExistingProvider(email);

      return Right(provider);
    } on ServerException catch (e) {
      return Left(Failures(e.message));
    }
  }
}
