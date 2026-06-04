import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:pomogrow/features/timer/domain/entities/timer.dart';
import 'package:pomogrow/features/timer/presentation/providers/timer_provider.dart';
import 'package:pomogrow/features/timer/presentation/widgets/timer_clip.dart';
import 'package:rive/rive.dart' hide Image;

class TimerScreen extends ConsumerStatefulWidget {
  final int timeIntMinutes;
  final int selectedIndex;
  const TimerScreen({
    super.key,
    required this.timeIntMinutes,
    required this.selectedIndex});

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;

    final minutes = args['minutes'];
    final index = args['index'];
    return MaterialPageRoute(
      builder: (_) => TimerScreen(
        timeIntMinutes: minutes,
        selectedIndex: index,
      ),
    );
  }

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  Artboard? _artboard;
  StateMachineController? controller;
  SMIInput<double>? _progress;
  bool _riveReady = false;

  @override
  void initState() {
    super.initState();

    // // START TIMER
    // Future.microtask(() {
    //   final notifier = ref.read(timerNotifierProvider.notifier);
    //   final state = ref.read(timerNotifierProvider);
    //
    //   // if (!state.isRunning) {
    //   //   notifier.start(widget.timeIntMinutes, widget.selectedIndex);
    //   // }
    // });

    // LISTENER
    ref.listenManual<FocusTimer>(timerNotifierProvider, (previous, next) {
        if (_progress == null) return;

        final notifier = ref.read(timerNotifierProvider.notifier);
        final totalSeconds = next.duration;

        if (totalSeconds == 0) return;

        final remaining = notifier.remainingSeconds;
        final elapsed = totalSeconds - remaining;
        final value = elapsed / totalSeconds;

        _progress!.value = value * 100;

        // final prevDuration = previous?.duration ?? 0;
        // final nextDuration = next.duration;
        final wasCompleted = previous?.completed ?? false;

        if (!wasCompleted && next.completed) {
          FlushbarNotif.show(
            context,
            title: "Timer Habis",
            msg:
            "Selamat, anda berhasil menyelesaikan timer dan mendapatkan "
                "${next.selectedMinutes} poin.",
          );

          Future.microtask(() {
            ref.read(timerNotifierProvider.notifier).clear();
          });
        }
      },
    );
    _loadRive();
  }

  Future<void> _loadRive() async {
    final riveService = ref.read(riveTreeProvider);

    await riveService.load();

    _progress = riveService.progress;
    _artboard = riveService.artboard;

    // final data = await rootBundle.load('assets/animations/tree.riv');
    //
    // await RiveFile.initialize();
    // final file = RiveFile.import(data);
    // final artboard = file.mainArtboard;
    //
    // final controller = StateMachineController.fromArtboard(
    //   artboard,
    //   'State Machine 1',
    // );

    // if (controller == null) return;
    // artboard.addController(controller);
    // _progress = controller.findInput<double>('input');

    final notifier = ref.read(timerNotifierProvider.notifier);
    final state = ref.read(timerNotifierProvider);

    final totalSeconds = state.duration;
    final remaining = notifier.remainingSeconds;

    if (totalSeconds > 0) {
      final elapsed = totalSeconds - remaining;
      final value = elapsed / totalSeconds;

      // APPLY FIRST
      _progress?.value = value * 100;
    } else {
      _progress?.value = 0;
    }
    // THEN SHOW
    if (mounted) {
      setState(() {
        _riveReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timerNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: TimerClip(color: AppPalette.curveColor, height: 400),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TimerClip(color: AppPalette.backgroundColor, height: 300),
          ),
          Positioned.fill(
            bottom: 300,
            child: !_riveReady || _artboard == null
                ? const SizedBox()
                : Rive(alignment: Alignment.center, artboard: _artboard!),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/rumput.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            top: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  state.isRunning
                      ? ref.read(timerNotifierProvider.notifier).formatted
                      : "00:00",
                  style: TextStyle(
                    fontSize: 90,
                    color: AppPalette.gradient1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 50, left: 10, child: BackButtonWidgets()),
        ],
      ),
    );
  }
}
