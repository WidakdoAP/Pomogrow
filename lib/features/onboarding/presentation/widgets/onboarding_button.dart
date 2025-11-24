import 'package:pomogrow/core/theme/app_pallete.dart';

import '../providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingButton extends ConsumerWidget {
  final PageController pageController;
  final int currentPages;
  final int totalPages;
  const OnboardingButton({
    super.key,
    required this.pageController,
    required this.currentPages,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (currentPages == totalPages - 1) {
            await ref
                .read(onboardingRepositoryProvider)
                .setOnboardingCompleted();
            if (!context.mounted) return;

            Navigator.pushReplacementNamed(context, '/auth_gate');
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.btnBackground,
          textStyle: const TextStyle(color: AppPallete.btnForeground),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          minimumSize: const Size(80, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          currentPages == totalPages - 1 ? 'MULAI' : 'LANJUT',
          style: const TextStyle(
            color: AppPallete.btnForeground,
          ), //Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
