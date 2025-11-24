import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 50 : 30,
          height: 10,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppPallete.indicatior
                : AppPallete.offIndicator,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
