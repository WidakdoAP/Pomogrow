import 'package:pomogrow/core/error/failures.dart';
import 'package:pomogrow/core/usecases/usecase.dart';
import 'package:pomogrow/features/auth/domain/repositories/auth_repository.dart';

import 'package:fpdart/fpdart.dart';

class SignUpWithGoogle implements UseCase<void, NoParams> {
  final AuthRepository repository;
  const SignUpWithGoogle(this.repository);

  @override
  Future<Either<Failures, void>> call(NoParams params) async {
    try {
      await repository.signInWithGoogle();
      return const Right(null);
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }
}

// Karena sign up dengan google tidak mengembalikan parameter apapun.
class NoParams {}
