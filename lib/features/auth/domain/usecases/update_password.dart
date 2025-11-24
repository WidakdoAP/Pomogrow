import 'package:pomogrow/core/error/failures.dart';
import 'package:pomogrow/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/auth_repository.dart';

class UpdatePasswordUsecase implements UseCase<void, UpdateParams> {
  final AuthRepository repository;
  const UpdatePasswordUsecase(this.repository);

  @override
  Future<Either<Failures, void>> call(UpdateParams params) async {
    return await repository.updatePassword(password: params.password);
  }
}

class UpdateParams {
  final String password;

  UpdateParams({required this.password});
}
