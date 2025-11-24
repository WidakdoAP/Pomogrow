import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_background.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_bottombar.dart';
import 'package:pomogrow/features/home/presentation/widgets/menu_square.dart';
import 'package:pomogrow/features/home/presentation/widgets/start_button.dart';
import 'package:pomogrow/features/home/presentation/widgets/timer_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          Column(
            children: [
              const SizedBox(height: 450),
              const TimerCard(),
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
          Positioned(bottom: 30, left: 0, right: 0, child: StartButton()),
        ],
      ),
    );
  }
}
