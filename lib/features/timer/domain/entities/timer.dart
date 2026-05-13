class FocusTimer {
  final DateTime? startTime;
  final int duration;
  final bool isRunning;
  final int selectedMinutes;

  const FocusTimer({
    this.startTime,
    this.duration = 0,
    this.isRunning = false,
    this.selectedMinutes = 0
  });

  FocusTimer copyWith({
    DateTime? startTime,
    int? duration,
    bool? isRunning,
    int? selectedMinutes
  }) {
    return FocusTimer(
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
      selectedMinutes: selectedMinutes ?? this.selectedMinutes
    );
  }
}
