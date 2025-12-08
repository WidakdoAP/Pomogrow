import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/timer/data/datasources/timer_datasource.dart';
import 'package:pomogrow/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:pomogrow/features/timer/domain/entities/timer.dart';
import 'package:pomogrow/features/timer/domain/repositories/timer_repository.dart';

class TimerNotifier extends StateNotifier<FocusTimer> {
  final TimerRepository repo;
  Timer? _ticker; // untuk Timer.periodic

  TimerNotifier(this.repo) : super(const FocusTimer()) {
    _restoreTimer();
  }

  // =============================
  // RESTORE TIMER (saat app dibuka)
  // =============================

  Future<void> _restoreTimer() async {
    final (startTime, duration) = await repo.loadTimer();

    if (startTime == null) return;

    final diff = DateTime.now().difference(startTime).inSeconds;
    final remaining = duration - diff;

    if (remaining <= 0) {
      // Timer sudah habis ketika app dibuka
      state = const FocusTimer();
      await repo.clearTimer();
      return;
    }

    // Set initial state dahulu (penting!)
    state = FocusTimer(
      startTime: startTime,
      duration: duration,
      isRunning: true,
    );

    // Lanjutkan ticker
    _startTicker(startTime, duration);
  }

  // =============================
  // START TIMER
  // =============================

  void start(int duration) {
    final now = DateTime.now();

    repo.saveTimer(now, duration);

    state = FocusTimer(startTime: now, duration: duration, isRunning: true);

    _startTicker(now, duration);
  }

  // =============================
  // INTERNAL TICKER
  // =============================

  void _startTicker(DateTime start, int duration) {
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(start).inSeconds;
      final remaining = duration - elapsed;

      if (remaining <= 0) {
        stop();
        return;
      }

      // trigger rebuild
      state = state.copyWith();
    });
  }

  // =============================
  // STOP TIMER
  // =============================

  void stop() {
    _ticker?.cancel();
    repo.clearTimer();
    state = const FocusTimer();
  }

  // =============================
  // HELPER GETTERS
  // =============================

  int get remainingSeconds {
    if (!state.isRunning || state.startTime == null) return state.duration;

    final elapsed = DateTime.now().difference(state.startTime!).inSeconds;

    return (state.duration - elapsed).clamp(0, state.duration);
  }

  String get formatted {
    final r = remainingSeconds;
    final m = (r ~/ 60).toString().padLeft(2, '0');
    final s = (r % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return TimerRepositoryImpl(TimerDatasource());
});

final timerNotifierProvider = StateNotifierProvider<TimerNotifier, FocusTimer>((
  ref,
) {
  return TimerNotifier(ref.read(timerRepositoryProvider));
});
