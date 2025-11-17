import 'package:pomogrow/core/error/failures.dart';
import 'package:pomogrow/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase implements UseCase<UserEntity?, UserSignInParams> {
  final AuthRepository repository;
  const SignInUsecase(this.repository);

  @override
  Future<Either<Failures, UserEntity?>> call(UserSignInParams params) async {
    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
