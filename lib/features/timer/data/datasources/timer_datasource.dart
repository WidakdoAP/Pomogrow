import 'package:shared_preferences/shared_preferences.dart';

class TimerDatasource {
  Future<void> saveTimer(
        DateTime startTime,
        int duration,
        int selectedMinutes
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('start_time', startTime.toIso8601String());
    await prefs.setInt('duration', duration);
    await prefs.setInt('selected_minutes', selectedMinutes);
  }

  Future<(DateTime?, int, int)> loadTimer() async {
    final prefs = await SharedPreferences.getInstance();

    final startString = prefs.getString('start_time');
    final duration = prefs.getInt('duration') ?? 0;
    final selectedMinutes = prefs.getInt('selected_minutes') ?? 0;

    if (startString == null) {
      return (null, duration, selectedMinutes);
    }
    return (DateTime.parse(startString), duration, selectedMinutes);
  }

  Future<void> clearTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('start_time');
    await prefs.remove('duration');
    await prefs.remove('selected_minutes');
  }
}
