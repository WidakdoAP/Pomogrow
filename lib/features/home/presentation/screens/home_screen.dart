import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/home/presentation/screens/owned_product_screen.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_background.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_bottombar.dart';
import 'package:pomogrow/features/home/presentation/widgets/menu_square.dart';
import 'package:pomogrow/features/home/presentation/widgets/start_button.dart';
import 'package:pomogrow/features/home/presentation/widgets/timer_card.dart';
import 'package:pomogrow/features/timer/presentation/providers/timer_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ui.Image? thumbImage;
  double sliderIndex = 0;
  //List<int> minutes = [25, 50, 75, 100];
  List<int> minutes = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    loadThumb();
  }

  Future<void> loadThumb() async {
    final data = await rootBundle.load('assets/images/thumb_image.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    setState(() {
      thumbImage = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 400), //450
                  TimerCard(
                    minutes: minutes,
                    index: sliderIndex,
                    onChanged: (v) {
                      setState(() => sliderIndex = v);
                    },
                    thumbImage: thumbImage,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MenuSquare(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/notes');
                            },
                            title: 'Catatan',
                            desc: 'Buat catatan',
                            imagePath: "assets/images/list.png",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MenuSquare(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OwnedProductScreen(),
                                ),
                              );
                            },
                            title: 'Pohon',
                            desc: 'Ganti Pohonmu',
                            imagePath: "assets/images/forest.png",
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), // avoid overlap with bottom button
                ],
              ),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: BottomBar()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: StartButton(
                onPressed: () {
                  final timerState = ref.read(timerNotifierProvider);

                  // Kalau timer masih berjalan
                  if (timerState.isRunning) {
                    Navigator.pushNamed(context, '/timer');
                    return;
                  }

                  final selectedIndex = sliderIndex.toInt();
                  final selectedTimer = minutes[sliderIndex.toInt()];

                  ref.read(timerNotifierProvider.notifier).start(
                    selectedTimer,
                    selectedIndex,
                  );

                  Navigator.pushNamed(
                    context,
                    '/timer',
                    arguments: {
                      'minutes': selectedTimer,
                      'index': selectedIndex,
                    }
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}