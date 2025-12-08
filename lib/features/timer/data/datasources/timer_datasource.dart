import 'package:shared_preferences/shared_preferences.dart';

class TimerDatasource {
  Future<void> saveTimer(DateTime startTime, int duration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('start_time', startTime.toIso8601String());
    await prefs.setInt('duration', duration);
  }

  Future<(DateTime?, int)> loadTimer() async {
    final prefs = await SharedPreferences.getInstance();

    final startString = prefs.getString('start_time');
    final duration = prefs.getInt('duration') ?? 0;

    if (startString == null) {
      return (null, duration);
    }
    return (DateTime.parse(startString), duration);
  }

  Future<void> clearTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('start_time');
    await prefs.remove('duration');
  }
}
