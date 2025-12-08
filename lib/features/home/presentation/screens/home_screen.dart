import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_background.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_bottombar.dart';
import 'package:pomogrow/features/home/presentation/widgets/menu_square.dart';
import 'package:pomogrow/features/home/presentation/widgets/start_button.dart';
import 'package:pomogrow/features/home/presentation/widgets/timer_card.dart';
import 'package:pomogrow/features/timer/presentation/screens/timer_screen.dart';

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
          Column(
            children: [
              const SizedBox(height: 450),
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
            ],
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: BottomBar()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: StartButton(
                onPressed: () {
                  final selectedTimer = minutes[sliderIndex.toInt()];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TimerScreen(timeIntMinutes: selectedTimer),
                    ),
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
