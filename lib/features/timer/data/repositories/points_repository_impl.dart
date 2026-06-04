import 'package:pomogrow/features/timer/data/datasources/points_datasource.dart';
import 'package:pomogrow/features/timer/domain/repositories/points_repository.dart';

class PointsRepositoryImpl implements PointsRepository {
  final PointsDatasource datasource;

  PointsRepositoryImpl(this.datasource);

  @override
  Future<void> addPoints(int minutes) {
    return datasource.addPoints(minutes);
  }
  @override
  Future<void> incrementFocusStat(int index) {
    return datasource.incrementFocusStat(index);
  }
}