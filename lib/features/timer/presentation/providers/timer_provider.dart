import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/field/presentation/providers/field_provider.dart';
import 'package:pomogrow/features/market/presentation/providers/transaction_provider.dart';
import 'package:pomogrow/features/timer/data/datasources/points_datasource.dart';
import 'package:pomogrow/features/timer/data/datasources/timer_datasource.dart';
import 'package:pomogrow/features/timer/data/repositories/points_repository_impl.dart';
import 'package:pomogrow/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:pomogrow/features/timer/domain/entities/timer.dart';
import 'package:pomogrow/features/timer/domain/repositories/points_repository.dart';
import 'package:pomogrow/features/timer/domain/repositories/timer_repository.dart';
import 'package:pomogrow/features/timer/domain/usecases/increment_focus_stats.dart';
import 'package:pomogrow/features/timer/presentation/states/rive_tree_state.dart';

class TimerNotifier extends StateNotifier<FocusTimer> {
  final TimerRepository repo;
  final Future<void> Function(int duration, int selectedIndex)? onCompleted;
  Timer? _ticker; // This is for Timer.periodic
  int? _selectedTimer;
  int? selectedIndex;
  bool _isCompleting = false;

  // Constructor
  TimerNotifier(this.repo, {this.onCompleted}) : super(const FocusTimer()) {
    _restoreTimer();
  }

  // Restore timer (when app is opened)
  Future<void> _restoreTimer() async {
    final (startTime, duration, selectedMinutes) = await repo.loadTimer();

    if (startTime == null) return;

    final diff = DateTime.now().difference(startTime).inSeconds;
    final remaining = duration - diff;

    _selectedTimer = selectedMinutes;

    if (remaining <= 0) {
      // Timer is finished when app open.
      state = const FocusTimer();
      await repo.clearTimer();
      return;
    }

    // Set initial state first (important!)
    state = FocusTimer(
      startTime: startTime,
      duration: duration,
      isRunning: true,
      selectedMinutes: selectedMinutes
    );

    // Continue ticker
    _startTicker(startTime, duration);
  }

  // Start timer.
  void start(int duration, int selectedIndexValue) {
    final now = DateTime.now();
    _selectedTimer = duration;
    selectedIndex = selectedIndexValue;

    final durationInSeconds = duration * 60;

    repo.saveTimer(now, durationInSeconds, duration);
    state = FocusTimer(
        startTime: now,
        duration: durationInSeconds,
        isRunning: true,
        selectedMinutes: duration
    );

    _startTicker(now, durationInSeconds);
  }

  // Internal ticker.
  void _startTicker(DateTime start, int duration) {
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      final elapsed = DateTime.now().difference(start).inSeconds;
      final remaining = duration - elapsed;
      if (remaining <= 0) {
        if (_isCompleting) return;

        _isCompleting = true;

        _ticker?.cancel();
        if (onCompleted != null) {
          await onCompleted!(
            _selectedTimer ?? 0,
            selectedIndex ?? 0,
          );
        }

        state = state.copyWith(
          isRunning: false,
          completed: true,
        );

        _isCompleting = false;

        return;
      }

      // trigger rebuild
      state = state.copyWith();
    });
  }

  void clear() {
    repo.clearTimer();
    state = const FocusTimer();
  }

  // Stop timer.
  void stop() {
    _ticker?.cancel();
    repo.clearTimer();
    state = const FocusTimer();
  }

  // Getter Helper.
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

// Provider

// This is the timer provider.
final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return TimerRepositoryImpl(TimerDatasource());
});

// And this is for points.
final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  return PointsRepositoryImpl(PointsDatasource());
});

final incrementFocusStatProvider = Provider((ref) {
  return IncrementFocusStat(
    ref.watch(pointsRepositoryProvider),
  );
});

// For rive assets.
final riveTreeProvider = Provider<RiveTreeService>((ref) {
  return RiveTreeService();
});

final timerNotifierProvider =
StateNotifierProvider<TimerNotifier, FocusTimer>((ref) {
  return TimerNotifier(
    ref.read(timerRepositoryProvider),
    onCompleted: (duration, selectedIndex) async {
      final pointsRepo = ref.read(pointsRepositoryProvider);
      final fieldRepo = ref.read(fieldRepositoryProvider);

      await pointsRepo.addPoints(duration);

      await fieldRepo.plantTree();

      await ref
          .read(incrementFocusStatProvider)
          .call(selectedIndex);

      // REFRESH UI SELALU
      ref.invalidate(fieldTilesProvider);
      ref.invalidate(plantedCountProvider);
      ref.invalidate(focusStatsProvider);
      ref.invalidate(userPointsProvider);

      final full = await fieldRepo.isFieldFull();

      if (full) {
        await pointsRepo.addPoints(500);

        await fieldRepo.resetField();
        await fieldRepo.resetFocusStats();

        // refresh lagi setelah reset
        ref.invalidate(fieldTilesProvider);
        ref.invalidate(plantedCountProvider);
        ref.invalidate(focusStatsProvider);
        ref.invalidate(userPointsProvider);
      }
    },
  );
});