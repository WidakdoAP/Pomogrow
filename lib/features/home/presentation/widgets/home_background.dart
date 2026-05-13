import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/home/presentation/providers/home_provider.dart';

class HomeBackground extends ConsumerWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equippedPlant = ref.watch(equippedPlantImageProvider);
    ref.invalidate(equippedPlantImageProvider);
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/field.png",
                    fit: BoxFit.cover,
                  ),
                ),
                equippedPlant.when(
                  data: (imageUrl) {

                    if (imageUrl == null) {
                      return const SizedBox();
                    }

                    return Positioned(
                      bottom: 72,
                      left: 0,
                      right: 0,

                      child: Center(
                        child: Image.network(
                          imageUrl,
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, _) => const SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppPalette.gradient3,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
