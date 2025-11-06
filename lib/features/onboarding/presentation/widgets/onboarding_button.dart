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

            Navigator.pushReplacementNamed(context, '/home');
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          currentPages == totalPages - 1 ? 'Mulai' : 'Next',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
