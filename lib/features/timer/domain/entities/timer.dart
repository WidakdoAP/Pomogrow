class FocusTimer {
  final DateTime? startTime;
  final int duration;
  final bool isRunning;
  final int selectedMinutes;
  final bool completed;

  const FocusTimer({
    this.startTime,
    this.duration = 0,
    this.isRunning = false,
    this.selectedMinutes = 0,
    this.completed = false,
  });

  FocusTimer copyWith({
    DateTime? startTime,
    int? duration,
    bool? isRunning,
    int? selectedMinutes,
    bool? completed,
  }) {
    return FocusTimer(
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
      selectedMinutes: selectedMinutes ?? this.selectedMinutes,
      completed: completed ?? this.completed,
    );
  }
}
