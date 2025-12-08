import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/timer/presentation/providers/timer_provider.dart';
import 'package:pomogrow/features/timer/presentation/widgets/menu_square.dart';
import 'package:pomogrow/features/timer/presentation/widgets/timer_clip.dart';
import 'package:rive/rive.dart' hide Image;

class TimerScreen extends ConsumerStatefulWidget {
  final int timeIntMinutes;
  const TimerScreen({super.key, required this.timeIntMinutes});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  Artboard? _artboard;
  StateMachineController? controller;
  SMIInput<double>? _progress;

  int _treeProgress = 0;
  int _treeMaxProgress = 100;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(timerNotifierProvider.notifier)
          .start(widget.timeIntMinutes * 60);
    });
    ref.listenManual(timerNotifierProvider, (previous, next) {
      if (_progress != null) {
        final notifier = ref.read(timerNotifierProvider.notifier);
        final totalSeconds = widget.timeIntMinutes * 60;
        final remaining = notifier.remainingSeconds;
        final elapsed = totalSeconds - remaining;

        double value = elapsed / totalSeconds;

        _progress!.value = value * 100;
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
        setState(() => _artboard = artboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timerNotifierProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: TimerClip(color: AppPallete.curveColor, height: 400),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TimerClip(color: AppPallete.backgroundColor, height: 300),
          ),
          Positioned.fill(
            bottom: 300,
            child: _artboard == null
                ? const SizedBox()
                : Rive(alignment: Alignment.center, artboard: _artboard!),
          ),

          Positioned(
            bottom: 300 - 60,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  MenuSquare(
                    title: 'Catatan',
                    desc: 'Beri Nama Fokusmu',
                    imagePath: "assets/images/list.png",
                  ),
                  MenuSquare(
                    title: 'Pohon',
                    desc: 'Ganti Pohon Fokusmu',
                    imagePath: "assets/images/forest.png",
                  ),
                ],
              ),
            ),
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
            top: 600,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  children: [
                    SvgPicture.asset('assets/images/leaf_timer.svg'),
                    Positioned(
                      left: 75,
                      bottom: 40,
                      child: Text(
                        notifier.formatted,
                        style: TextStyle(
                          fontSize: 60,
                          color: AppPallete.backgroundColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
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
