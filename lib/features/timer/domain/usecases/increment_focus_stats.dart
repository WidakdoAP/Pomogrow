import 'package:pomogrow/features/timer/domain/repositories/points_repository.dart';

class IncrementFocusStat {
  final PointsRepository repository;

  IncrementFocusStat(this.repository);

  Future<void> call(int index) {
    return repository.incrementFocusStat(index);
  }
}