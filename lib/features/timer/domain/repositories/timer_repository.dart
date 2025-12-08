abstract class TimerRepository {
  Future<void> saveTimer(DateTime startTime, int duration);
  Future<(DateTime?, int)> loadTimer();
  Future<void> clearTimer();
}
