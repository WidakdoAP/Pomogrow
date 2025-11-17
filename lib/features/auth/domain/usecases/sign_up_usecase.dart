import 'package:fpdart/fpdart.dart';
import 'package:pomogrow/core/error/failures.dart';
import 'package:pomogrow/core/usecases/usecase.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUsecase implements UseCase<UserEntity?, UserSignUpParams> {
  final AuthRepository repository;
  const SignUpUsecase(this.repository);

  @override
  Future<Either<Failures, UserEntity?>> call(UserSignUpParams params) async {
    return await repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
