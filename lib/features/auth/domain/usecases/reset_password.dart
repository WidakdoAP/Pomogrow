import 'package:pomogrow/core/error/failures.dart';
import 'package:pomogrow/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/auth_repository.dart';

class ResetPasswordUsecase implements UseCase<Unit, ResetParams> {
  final AuthRepository repository;

  const ResetPasswordUsecase(this.repository);

  @override
  Future<Either<Failures, Unit>> call(ResetParams params) async {
    return await repository.resetPassword(email: params.email);
  }
}

class ResetParams {
  final String email;

  ResetParams({required this.email});
}
