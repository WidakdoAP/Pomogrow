abstract class TimerRepository {
  Future<void> saveTimer(DateTime startTime, int duration, int selectedMinutes);
  Future<(DateTime?, int, int)> loadTimer();
  Future<void> clearTimer();
}
