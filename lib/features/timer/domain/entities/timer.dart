class FocusTimer {
  final DateTime? startTime;
  final int duration;
  final bool isRunning;

  const FocusTimer({this.startTime, this.duration = 0, this.isRunning = false});

  FocusTimer copyWith({DateTime? startTime, int? duration, bool? isRunning}) {
    return FocusTimer(
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
