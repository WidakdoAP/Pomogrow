import 'package:pomogrow/features/timer/data/datasources/timer_datasource.dart';
import 'package:pomogrow/features/timer/domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  final TimerDatasource datasource;
  TimerRepositoryImpl(this.datasource);

  @override
  Future<void> saveTimer(DateTime startTime, int duration) {
    return datasource.saveTimer(startTime, duration);
  }

  @override
  Future<(DateTime?, int)> loadTimer() {
    return datasource.loadTimer();
  }

  @override
  Future<void> clearTimer() {
    return datasource.clearTimer();
  }
}
