import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:pomogrow/features/timer/presentation/providers/timer_provider.dart';
import 'package:pomogrow/features/timer/presentation/widgets/menu_square.dart';
import 'package:pomogrow/features/timer/presentation/widgets/timer_clip.dart';
import 'package:rive/rive.dart' hide Image;

class TimerScreen extends ConsumerStatefulWidget {
  final int timeIntMinutes;
  const TimerScreen({super.key, required this.timeIntMinutes});

  static Route route(RouteSettings settings) {
    final minutes = settings.arguments as int? ?? 0;
    return MaterialPageRoute(
      builder: (_) => TimerScreen(timeIntMinutes: minutes),
    );
  }

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  Artboard? _artboard;
  StateMachineController? controller;
  SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(timerNotifierProvider.notifier);
      final state = ref.read(timerNotifierProvider);

      if (!state.isRunning) {
        notifier.start(widget.timeIntMinutes);
      }
    });
    rootBundle.load('assets/animations/tree.riv').then((data) async {
      await RiveFile.initialize();
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );
      if (controller != null) {
        artboard.addController(controller);
        _progress = controller.findInput('input');

        final notifier = ref.read(timerNotifierProvider.notifier);
        final state = ref.read(timerNotifierProvider);
        final totalSeconds = state.duration;//widget.timeIntMinutes * 60;
        final remaining = notifier.remainingSeconds;
        final elapsed = totalSeconds - remaining;

        double value = elapsed / totalSeconds;
        _progress!.value = value * 100;

        setState(() => _artboard = artboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timerNotifierProvider);
    ref.listen(timerNotifierProvider, (previous, next) {
      if (_progress != null) {
        final notifier = ref.read(timerNotifierProvider.notifier);
        final totalSeconds = state.duration;
        final remaining = notifier.remainingSeconds;
        final elapsed = totalSeconds - remaining;

        if (totalSeconds == 0) return;

        double value = elapsed / totalSeconds;
        _progress!.value = value * 100;

        if (remaining == 0 && previous?.duration != 0) {
          FlushbarNotif.show(
              context,
              title: "Timer Habis",
              msg: "Selamat, anda berhasil menyelesaikan timer dan mendapatkan "
                  "${state.selectedMinutes} poin.");
        }
      }
    });

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
            child: _artboard == null
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
